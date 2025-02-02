#include maps\_utility;
#include common_scripts\utility;
#include maps\payback_util;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_audio;
#include maps\_gameskill;
init_compound_b_flags()
{
flag_init("approaching_compound");
flag_init("open_gate");
flag_init("compound_b2");
flag_init("compound_right_side");
flag_init("support_obj_off");
flag_init("docks1");
flag_init("docks2");
flag_init("mortar_time");
flag_init("mortars_dead");
flag_init("supply_yard_clear");
flag_init("supply_yard_technicals");
flag_init("section1_technicals_dead");
flag_init("technical_vo_line");
flag_init("upper_compound");
flag_init("upper_compound_failsafe_timer");
flag_init("upper_compound_autosave");
flag_init("compound_cover_fire");
flag_init("compound_MG_VO");
flag_init("kill_balcony_guys");
flag_init("upper_compound2");
flag_init("building1_guys");
flag_init("upper_compound_upper_buildings");
flag_init("upper_compound_lower_buildings");
flag_init("upper_compound_upper_buildings_hotzone");
flag_init("upper_compound_courtyard1");
flag_init("upper_compound_courtyard2");
flag_init("compound_courtyard_finished");
flag_init("heli_guy_wait");
flag_init("end_rooftop_guys");
flag_init("leave");
flag_init("heli_need_more_guys");
flag_init("new_guys");
}
remove_placeholder_hummers()
{
hum = GetEnt("placeholder_hummer_alpha", "targetname");
hum delete();
hum = GetEnt("placeholder_hummer_bravo", "targetname");
hum delete();
}
try_activate(trigger)
{
if (IsDefined(trigger) && !IsDefined(trigger.trigger_off))
{
trigger activate_trigger();
}
}
activate_one_trigger(trigger_name)
{
ents = GetEntArray(trigger_name, "targetname");
try_activate(ents[0]);
}
enter_compound()
{
aud_send_msg("s1_outer_compound");
thread sandstorm_fx(2);
texploder(2300);
exploder(2000);
exploder(2500);
level.soap = spawn_ally("soap");
level.price = spawn_ally("price");
level.hannibal = spawn_ally("hannibal");
level.murdock = spawn_ally("murdock");
level.barracus = spawn_ally("barracus");
start = GetStruct("player_enter_compound_loc", "targetname");
level.player setOrigin( start.origin );
level.player setPlayerAngles( start.angles );
maps\payback_1_script_d::chopper_main();
maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
bravo_invulnerability(true);
thread spawn_ground_opposition();
wait 1;
flag_set("approaching_compound");
main();
}
autosave_heli_check()
{
return ( !flag("chopper_in_use_by_player") && (level.player getCurrentWeapon() != "remote_chopper_gunner") );
}
compound_init_threat_bias_stuff()
{
CreateThreatBiasGroup("player");
CreateThreatBiasGroup( "player_ignore_group" );
CreateThreatBiasGroup( "right_side_guys" );
level.player setthreatbiasgroup( "player_ignore_group" );
SetIgnoreMeGroup( "player_ignore_group", "right_side_guys" );
}
fancy_price()
{
activate_one_trigger("price_down_hill");
level.price.ignoresuppression = false;
level.price.ignoreall = false;
}
main()
{
init_color_trigger_listeners("compound_b_colors");
autosave_by_name( "levelstart" );
battlechatter_on( "allies" );
thread maps\payback_1_script_c::init_kick_doors();
delayThread(15, ::bravo_invulnerability, false);
delayThread(5, ::fancy_price);
level.chopper thread maps\payback_1_script_d::Chopper_Change_Strafe_Locations( "chopper_strafing_struct1", true );
thread maps\payback_1_script_c::compound_curtain_anims();
thread spawn_technicals();
thread spawn_mortars();
flag_clear("upper_compound");
thread upper_compound();
level.player thread no_prone_water_trigger();
thread outercompound_enemyvignettes();
if( IsDefined( level.price ) )
{
Objective_OnEntity( obj( "obj_kruger" ), level.price , (0,0,50) );
}
thread turn_off_support_obj();
thread compound_entered_dialog();
thread lazy_player_naglines();
wait 15;
thread wait_for_chopper();
thread outer_compound_roofies();
thread heli_reinforcements();
thread post_heli_autosave();
array_thread( getentarray( "explodable_barrel", "targetname" ), ::do_big_explosion );
thread chopper_barrel_hack();
wait 10;
add_extra_autosave_check( "heli_check", ::autosave_heli_check, "can't autosave in heli" );
flag_set("mortar_time");
flag_wait("compound_courtyard_finished");
thread maps\payback_1_script_c::main();
thread compound_remaining_enemies_flee();
if (flag("chopper_in_use_by_player"))
{
flag_waitopen("chopper_in_use_by_player");
wait 1;
}
flag_clear("chopper_give_player_control");
wait 2;
level notify("end_outer_compound");
level.price thread play_vo( "payback_pri_bravoteamsecure_r" );
wait 1;
autosave_by_name( "section2" );
}
no_prone_water_trigger()
{
level endon( "const_rappel_player_start" );
while (true)
{
flag_wait("no_prone_water_trigger");
if(self GetStance() == "prone")
{
self SetStance("stand");
}
self AllowProne(false);
flag_waitopen("no_prone_water_trigger");
self AllowProne (true);
}
}
compound_entered_dialog()
{
wait 2;
objective_state (obj( "obj_kruger" ), "current");
level.soap play_vo( "payback_mct_takedown_r" );
}
allies_sprint_to_goal()
{
level.price thread sprint_to_goal();
level.soap thread sprint_to_goal();
level.hannibal thread sprint_to_goal();
level.barracus thread sprint_to_goal();
level.murdock thread sprint_to_goal();
}
sprint_to_goal()
{
if (IsDefined(self) && IsAlive(self))
{
self enable_sprint();
self waittill("goal");
self disable_sprint();
}
}
run_away(shootable, no_sprint)
{
if (!IsDefined(self))
{
return;
}
self endon("death");
if (!IsDefined(shootable))
{
shootable = true;
}
if ( !shootable )
{
self magic_bullet_shield();
self.ignoreme = true;
}
if (!IsDefined(no_sprint))
{
no_sprint = false;
}
if (!no_sprint)
{
self enable_sprint();
}
self ignore_everything();
self waittill("goal");
if (!no_sprint)
{
self disable_sprint();
}
self clear_ignore_everything();
if (!shootable)
{
self stop_magic_bullet_shield();
self.ignoreme = false;
}
}
turn_off_support_obj()
{
flag_wait("support_obj_off");
Objective_SetPointerTextOverride( obj( "obj_kruger" ), "" );
obj_pos = getstruct( "compound_objective_loc" , "targetname" );
Objective_Position( obj( "obj_kruger" ) , obj_pos.origin );
}
find_threatbias_guys(guys, groupname)
{
foreach (guy in guys)
{
if (IsDefined(guy.script_noteworthy) && guy.script_noteworthy == groupname)
{
guy setthreatbiasgroup(groupname);
}
}
}
price_go_rambo()
{
level.price.ignoreSuppression = true;
level.price.IgnoreRandomBulletDamage = true;
level.price.ignoreExplosionEvents = true;
level.price.disableBulletWhizbyReaction = true;
wait 5;
level.price.ignoreSuppression = false;
level.price.IgnoreRandomBulletDamage = false;
level.price.ignoreExplosionEvents = false;
level.price.disableBulletWhizbyReaction = false;
}
spawn_ground_opposition()
{
compound_init_threat_bias_stuff();
thread gate_runners();
thread spawn_docks1();
thread spawn_docks2();
thread right_side_guys();
flag_wait("compound_b2");
guys = array_spawn_targetname_allow_fail("compound_b");
find_threatbias_guys(guys, "right_side_guys");
thread price_go_rambo();
guys2 = array_spawn_targetname_allow_fail("compound_b2");
thread ai_array_killcount_flag_set(guys2, int(guys2.size*0.5), "mortar_time");
allguys = array_combine(guys, guys2);
allguys = array_combine(allguys, level.gate_runners);
allguys = array_removedead_or_dying(allguys);
thread ai_array_killcount_flag_set(allguys, allguys.size -2, "supply_yard_clear");
flag_wait("supply_yard_clear");
wait 1;
flag_set("supply_yard_technicals");
wait 2;
trigger_off("r130","targetname");
activate_one_trigger("y200");
activate_one_trigger("b150");
}
gate_runners()
{
level.gate_runners = [];
spawners = GetEntArray("runners", "targetname");
foreach (spawner in spawners)
{
anime = spawner.animation;
endgoal = GetNode( spawner.target, "targetname" );
spawner thread gate_run_away(anime, endgoal);
}
flag_wait("approaching_compound");
level.gate_runners = array_removedead_or_dying(level.gate_runners);
find_threatbias_guys(level.gate_runners, "right_side_guys");
thread ai_array_killcount_flag_set(level.gate_runners, int(level.gate_runners.size), "compound_b2");
}
gate_run_away(animation, endgoal)
{
self endon("death");
guy = self spawn_ai();
if (IsDefined(guy))
{
level.gate_runners[level.gate_runners.size] = guy;
guy ignore_everything();
guy.ignoreme = false;
guy set_goal_radius(20);
guy.animname = "generic";
guy thread anim_generic_loop(guy, animation);
flag_wait("approaching_compound");
if( !IsDefined( guy ) )
{
return;
}
guy StopAnimScripted();
guy follow_path(endgoal);
guy run_away(true);
}
}
right_side_guys()
{
flag_wait("compound_right_side");
level.player setthreatbiasgroup( "player" );
SetIgnoreMeGroup( "player_ignore_group", "right_side_guys" );
if (!flag("supply_yard_technicals"))
{
guys = array_spawn_targetname_allow_fail("compound_right_side");
find_threatbias_guys(guys, "right_side_guys");
flag_wait("upper_compound");
foreach(guy in guys)
{
if (IsDefined(guy) && IsAlive(guy))
{
guy set_force_color("y");
}
}
}
}
spawn_mortars()
{
flag_wait("mortar_time");
if (!flag("upper_compound"))
{
thread compound_mortars();
wait 2;
level.soap play_vo( "payback_mct_tagetusmorters_r" );
wait 1;
level.price play_vo( "payback_pri_weneedair_r" );
wait 0.5;
level.player play_vo( "payback_nik_movinginto_r", true );
flag_set("chopper_give_player_control");
}
}
post_heli_autosave()
{
flag_wait("chopper_in_use_by_player");
flag_waitopen("chopper_in_use_by_player");
wait 0.5;
autosave_by_name("post_heli");
}
spawn_mortar_guys(mortars)
{
level.mortar_guys = [];
for (i=0; i < mortars.size; i++)
{
mortar = mortars[i];
if ( IsDefined(mortar.target) )
{
spawner = GetEnt(mortar.target, "targetname");
if ( IsDefined(spawner) )
{
level.mortar_guys[i] = spawner spawn_ai(true);
if ( IsDefined(level.mortar_guys[i])	)
{
level.mortar_guys[i] ignore_everything();
if (spawner.targetname == "mortar_guy2")
{
level.mortar_guys[i] thread respawn_mortar(spawner, i);
}
}
}
}
}
}
respawn_mortar(spawner, mortar_index)
{
self waittill("death");
flag_waitopen("chopper_in_use_by_player");
wait 10;
if (IsDefined(spawner))
{
guy = spawner spawn_ai(true);
if (IsDefined(guy))
{
guy ignore_everything();
level.mortar_guys[mortar_index] = guy;
}
}
}
compound_find_mortar_source(mortars)
{
start_index = level.mortar_index;
level.mortar_index++;
while ( IsUndefined(level.mortar_guys[level.mortar_index]) && level.mortar_index != start_index )
{
level.mortar_index++;
if (level.mortar_index >= mortars.size)
{
level.mortar_index = 0;
}
}
if (level.mortar_index == start_index && IsUndefined(level.mortar_guys[level.mortar_index]))
{
return undefined;
}
return mortars[level.mortar_index];
}
compound_mortars()
{
mortars = GetStructArray("outer_compound_mortar", "targetname");
mortar_targets = GetStructArray("outer_compound_mortar_target", "targetname");
spawn_mortar_guys(mortars);
level.mortar_index = randomint(mortars.size);
foreach ( targ in mortar_targets )
{
targ.water = IsDefined( targ.script_noteworthy ) && targ.script_noteworthy == "water";
targ.used = 0;
}
mortar_fire_fx = getfx("mortar_flash_120");
mortar_fx = getfx( "mortarexp_mud_nofire" );
water_fx = getfx( "mortarExp_water" );
for ( i = 0; ; i++ )
{
mortar_source = compound_find_mortar_source(mortars);
if ( !IsUndefined(mortar_source) )
{
aud_send_msg("mortar_fire", mortar_source.origin);
wait( 0.4 );
PlayFX(mortar_fire_fx, mortar_source.origin);
wait( 1.333 );
ok_targs = get_outside_range(level.player.origin, mortar_targets, 270);
targ_index = get_closest_index_to_player_view(ok_targs);
targ = ok_targs[targ_index];
if ( IsDefined( targ.used ) && targ.used > 2)
{
targ.used = 0;
ok_targs = array_remove_index(ok_targs, targ_index);
targ = random(ok_targs);
targ.used++;
}
else
{
targ.used++;
}
targ.fx = mortar_fx;
targ.sound = "mortar_impact_dirt";
if ( targ.water )
{
targ.fx = water_fx;
targ.sound = "mortar_impact_water";
}
thread mortar_goes_off( targ );
}
if ( flag("mortars_dead") )
{
break;
}
else
{
wait (randomfloatrange(2.0, 4.0));
}
}
if (flag("mortars_dead"))
{
if (flag("chopper_in_use_by_player"))
{
flag_waitopen("chopper_in_use_by_player");
wait 1;
}
deadguys = GetEntArray("mortar_guys", "script_noteworthy");
array_call(deadguys, ::delete);
}
else
{
flag_set("mortars_dead");
}
while (autosave_heli_check() == false)
{
wait 0.5;
}
autosave_by_name_silent("mortars");
}
mortar_goes_off( targ )
{
aud_send_msg("mortar_incoming", targ.origin);
wait( 1.666 );
PlayFX( targ.fx, targ.origin );
Earthquake( 0.25, 0.75, (targ.origin), 2050 );
aud_send_msg(targ.sound, targ.origin);
PlayRumbleOnPosition( "heavy_3s", targ.origin );
hit_dist = DistanceSquared(level.player.origin, targ.origin);
if (hit_dist < 40000)
{
RadiusDamage( targ.origin, 150, 1, 1 );
}
else
{
RadiusDamage( targ.origin, 150, 100, 50 );
}
wait 0.5;
if (hit_dist <= 360000)
{
level.player maps\_gameskill::grenade_dirt_on_screen("bottom");
}
}
spawn_docks1()
{
flag_wait("docks1");
guys = array_spawn_targetname_allow_fail("docks1");
thread ai_array_killcount_flag_set(guys, guys.size, "docks2");
level.price thread play_vo( "payback_pri_sweepunder" );
}
spawn_docks2()
{
flag_wait("docks2");
trigger_off("docks1_trigger","targetname");
guys = array_spawn_targetname_allow_fail("docks2");
}
spawn_technicals()
{
flag_wait("supply_yard_technicals");
flag_set("compound_right_side");
guys = array_spawn_targetname_allow_fail("upper_compound_runners");
guys = array_spawn_targetname_allow_fail("compound_b3");
wait 2;
flag_waitopen("chopper_in_use_by_player");
wait 2;
technicals = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 110 );
tech1 = technicals[0];
tech2 = technicals[1];
tech1 thread technical_help_riders();
tech2 thread technical_help_riders();
tech1.threatbias = -15000;
tech2.threatbias = -15000;
thread technical_vo(tech1);
thread technical_vo(tech2);
wait 2;
level.price thread play_vo( "payback_pri_techincalscoming_r" );
thread watch_for_technicals_dead(technicals, "section1_technicals_dead");
wait 1;
allguys = getaiarray("axis");
if (allguys.size > 3)
{
thread ai_array_killcount_flag_set(allguys, allguys.size -3, "upper_compound_failsafe_timer");
flag_wait("upper_compound_failsafe_timer");
if (!flag("upper_compound"))
{
activate_one_trigger("upper_compound_entrance_trigger");
}
}
if (!flag("upper_compound"))
{
wait 15;
flag_set("upper_compound");
}
}
watch_for_technicals_dead(technicals, flag_name)
{
threats = technicals.size;
while (threats > 0)
{
threats = technicals.size;
foreach (tech in technicals)
{
if (!IsDefined(tech) || !IsAlive(tech))
{
threats = threats - 1;
}
else
{
threats = threats - 1;
if (tech.riders.size > 0)
{
foreach (guy in tech.riders)
{
if (IsDefined(guy) && IsAlive(guy))
{
threats = threats + 1;
break;
}
}
}
}
}
wait 0.25;
}
flag_set(flag_name);
}
technical_help_riders()
{
self.threatbias = -5000;
riders = self.riders;
foreach( rider in riders )
{
rider.threatbias = -5000;
rider.attackerAccuracy = 0.5;
}
if (self.script_noteworthy == "compound_b_technical2")
{
self waittill("death");
level notify("front_tech_dead");
}
else if (self.script_noteworthy == "compound_b_technical1")
{
level waittill("front_tech_dead");
{
if (IsDefined(self) && IsAlive(self) && self Vehicle_GetSpeed() > 0)
{
self vehicle_setspeed( 0, 15, 15 );
self vehicle_unload();
}
}
}
}
technical_vo(tech)
{
if (IsDefined(tech))
{
tech waittill("death", attacker);
if (IsDefined(attacker) && attacker == level.player && flag("chopper_in_use_by_player") && !flag("technical_vo_line") )
{
flag_set("technical_vo_line");
level.player play_vo("payback_pri_vehicledestroyed", true);
}
autosave_by_name("technicals_destroyed");
}
}
outer_compound_roofies()
{
roofie_spawners = GetEntArray("roofie", "targetname");
foreach (spawner in roofie_spawners)
{
roofie = spawner spawn_ai(true);
if (IsDefined(roofie))
{
roofie.spawner = spawner;
roofie thread roofie_handler();
}
}
}
roofie_handler()
{
level endon("end_outer_compound");
roofie = self;
spawner = roofie.spawner;
while (IsDefined(roofie) && !flag("upper_compound") )
{
roofie waittill("death");
wait RandomIntRange(3,8);
if (!flag("upper_compound"))
{
roofie = spawner spawn_ai(true);
}
}
}
outer_compound_spawn_rooftop_guys(rooftop_guys, spawners)
{
num_guys = RandomInt(2) + 1;
for (i=0; i <= num_guys && ((level.rooftop_guy_index + i) < spawners.size); i++)
{
rooftop_guys[level.rooftop_guy_index+i] = spawners[level.rooftop_guy_index+i] spawn_ai(true);
}
return rooftop_guys;
}
wait_for_chopper()
{
level endon("death");
spawners = GetEntArray("rooftop_guys", "targetname");
rooftop_guys = [];
using_upper_guys = false;
first_time = true;
level.rooftop_guy_index = 0;
rooftop_guys = outer_compound_spawn_rooftop_guys(rooftop_guys, spawners);
while ( !flag("end_rooftop_guys") )
{
level waittill("chopper_use");
flag_clear("heli_guy_wait");
thread heli_guy_timer();
if ( !flag("end_rooftop_guys") )
{
if ( flag("upper_compound") && using_upper_guys == false)
{
using_upper_guys = true;
spawners = GetEntArray("more_heli_guys", "targetname");
level.rooftop_guy_index = 0;
}
rooftop_guys = outer_compound_spawn_rooftop_guys(rooftop_guys, spawners);
}
if (first_time)
{
first_time = false;
level.price thread play_vo( "payback_pri_yougotcontrol_r" );
}
}
}
heli_guy_timer()
{
wait 5;
flag_set("heli_guy_wait");
}
upper_compound_autosave()
{
flag_wait("upper_compound_autosave");
flag_set("mortars_dead");
autosave_by_name( "upper_compound" );
}
upper_compound()
{
flag_wait("upper_compound");
thread upper_compound_autosave();
thread kill_balcony_guys();
thread compound_MG_VO();
rpg_crate_clip = getent( "rpg_crate_clip","targetname" );
rpg_crate_clip NotSolid();
activate_one_trigger("upper_compound_entrance_trigger");
thread building1_guys();
thread compound_cover_fire_line();
thread upper_compound_upper_buildings();
thread upper_compound_lower_buildings();
thread upper_compound_upper_buildings_hotzone();
level.chopper thread maps\payback_1_script_d::Chopper_Change_Strafe_Locations( "chopper_strafing_struct2" );
guys = array_spawn_targetname_allow_fail("upper_compound");
array_spawn_targetname_allow_fail("balcony_runners");
wait(0.2);
guys = array_removedead_or_dying(guys);
thread ai_array_killcount_flag_set(guys, int(guys.size*0.75), "upper_compound2");
level.player thread play_vo( "payback_nik_additonalforces_r", true );
flag_wait("upper_compound2");
if ( !flag("compound_courtyard_finished"))
{
guys = array_spawn_targetname_allow_fail("upper_compound_courtyard1");
flag_set("upper_compound_upper_buildings_hotzone");
}
upper_compound_last_stand();
}
compound_cover_fire_line()
{
flag_wait("compound_cover_fire");
if (!flag("compound_courtyard_finished"))
{
level.price thread play_vo( "payback_pri_laydowncovering" );
}
}
kill_balcony_guys()
{
level endon ("death");
flag_wait("kill_balcony_guys");
if ( !flag("compound_courtyard_finished") )
{
guys = GetEntArray("balcony_guy", "script_noteworthy");
foreach(guy in guys)
{
if (IsAlive(guy))
{
guy Kill();
}
}
}
}
building1_guys()
{
flag_wait("building1_guys");
array_spawn_targetname_allow_fail("building1_guys");
}
upper_compound_upper_buildings()
{
flag_wait("upper_compound_upper_buildings");
guys = array_spawn_targetname_allow_fail("upper_compound_upper_buildings");
guys = array_removedead_or_dying(guys);
flag_set("upper_compound_upper_buildings_hotzone");
thread ai_array_killcount_flag_set(guys, int(guys.size*0.75), "upper_compound_courtyard1");
}
upper_compound_upper_buildings_hotzone()
{
flag_wait("upper_compound_upper_buildings_hotzone");
guys = array_spawn_targetname_allow_fail("upper_compound_upper_buildings_hotzone");
foreach (guy in guys)
{
if (IsDefined(guy) && IsDefined(guy.script_noteworthy) && guy.script_noteworthy == "runner")
{
guy thread run_away(false, true);
}
}
}
upper_compound_lower_buildings()
{
flag_wait("upper_compound_lower_buildings");
guys = array_spawn_targetname_allow_fail("upper_compound_lower_buildings");
array_spawn_targetname_allow_fail("upper_compound_lower_buildings_hotzone");
thread ai_array_killcount_flag_set(guys, int(guys.size*0.75), "upper_compound_courtyard1");
}
upper_compound_last_stand()
{
LAST_FLEE_COUNT = 5;
allguys = getaiarray("axis");
if (allguys.size > LAST_FLEE_COUNT)
{
thread watch_last_guys(allguys, LAST_FLEE_COUNT);
while (!flag("leave"))
{
wait 0.5;
if (flag("new_guys"))
{
flag_clear("new_guys");
level notify("stop_watching");
allguys = GetAIArray("axis");
thread watch_last_guys(allguys, LAST_FLEE_COUNT);
}
}
}
flag_set("upper_compound_courtyard1");
trigger_off("b170", "targetname");
trigger_off("b180", "targetname");
activate_one_trigger("leave_lower_compound");
}
watch_last_guys(allguys, flee_count)
{
level endon("stop_watching");
childthread ai_array_killcount_flag_set(allguys, allguys.size - flee_count, "leave");
}
do_big_explosion()
{
level endon("end_outer_compound");
self waittill("exploding");
if (flag("chopper_in_use_by_player"))
{
thread play_sound_in_space("explo_ambient_building", self.origin);
thread maps\payback_aud::MM_add_submix_oneshot("mix_chopper_explosion",0,0.1,0.3);
}
}
heli_reinforcements()
{
spawners = GetEntArray("heli_reinforcements", "targetname");
spawner_num = 0;
reinforcement_vo = [];
reinforcement_vo[0] = "payback_nik_morehostiles_r";
reinforcement_vo[1] = "payback_nik_enemytroops_r";
reinforcement_vo[2] = "payback_nik_additonalhostiles_r";
while(!flag("compound_courtyard_finished"))
{
level waittill("chopper_use");
wait 0.5;
while (flag("chopper_in_use_by_player") && !flag("compound_courtyard_finished"))
{
flag_clear("heli_need_more_guys");
allguys = getaiarray("axis");
if (allguys.size <= 3)
{
spawn_count = RandomIntRange(3,4);
flag_set("new_guys");
level.player thread play_vo( reinforcement_vo[RandomInt(reinforcement_vo.size)], true);
for (i = 0; i < spawn_count; i++)
{
new_guy = spawners[spawner_num] spawn_ai(true);
if (IsDefined(new_guy))
{
allguys[allguys.size] = new_guy;
new_guy SetGoalEntity(level.player);
spawner_num++;
if (spawner_num >= spawners.size)
{
spawner_num = 0;
}
}
}
}
thread ai_array_killcount_flag_set(allguys, allguys.size - 3, "heli_need_more_guys");
flag_wait("heli_need_more_guys");
wait 0.5;
}
}
}
lazy_player_naglines()
{
level endon("death");
nagline = [];
nag_who = [];
nagline[0] = "payback_pri_advancetotarget";
nag_who[0] = level.price;
nagline[1] = "payback_pri_pinneddown";
nag_who[1] = level.price;
nagline[2] = "payback_pri_getwaraabe";
nag_who[2] = level.price;
nagline[3] = "payback_mct_targetbuilding";
nag_who[3] = level.soap;
nagline[4] = "payback_mct_findwaraabe";
nag_who[4] = level.soap;
nagline[5] = "payback_pri_cmonletsget";
nag_who[5] = level.price;
nagline[6] = "payback_pri_yurimoveit";
nag_who[6] = level.price;
nagline[7] = "payback_pri_letsgocmon";
nag_who[7] = level.price;
wait 20;
nag_delay = 15;
line_num = 0;
while (!flag("upper_compound_autosave"))
{
while(flag("chopper_in_use_by_player"))
{
wait 1;
}
wait 3;
nag_who[line_num] thread play_vo(nagline[line_num]);
if ( flag("upper_compound_failsafe_timer") && !flag("upper_compound") )
{
nag_delay = 5;
}
else
{
nag_delay = 15;
}
wait RandomIntRange(nag_delay, nag_delay + 5);
line_num++;
if (line_num >= nagline.size)
{
line_num = 0;
}
}
}
compound_remaining_enemies_flee()
{
go_here = GetNode("int_compound_flee_node", "targetname");
allguys = getaiarray("axis");
rooftop_mg_guys = GetEntArray( "rooftop_mg", "script_noteworthy" );
allguys = array_combine( allguys, rooftop_mg_guys );
compound_entrance = GetStruct("compound_objective_loc", "targetname");
allguys = remove_dead_from_array(allguys);
no_auto_kill = (allguys.size > 12);
foreach (guy in allguys)
{
rooftop_guy = (IsDefined(guy.script_noteworthy) && guy.script_noteworthy == "rooftop_mg");
dist_to_entrance = DistanceSquared(guy.origin, compound_entrance.origin);
if ( no_auto_kill )
{
dist_to_player = DistanceSquared(guy.origin, level.player.origin);
guy GetEnemyInfo(level.player);
guy.baseaccuracy = RandomFloatRange(0.8, 1.0);
if ( dist_to_player < 250000 || dist_to_entrance < 250000 )
{
guy SetGoalEntity(level.player);
}
if (dist_to_player > 4000000 && !raven_player_can_see_ai(guy))
{
guy delete();
}
}
else
{
see_me = raven_player_can_see_ai(guy);
if ( !rooftop_guy &&
(dist_to_entrance < 250000 || see_me ))
{
guy thread compound_flee(go_here);
}
else
{
guy thread compound_die();
}
}
}
if (no_auto_kill)
{
wait 5;
allguys = remove_dead_from_array(allguys);
foreach (guy in allguys)
{
guy GetEnemyInfo(level.player);
guy.baseaccuracy = 1;
guy.fixednode = false;
guy SetGoalEntity(level.player);
}
}
}
compound_defend()
{
self GetEnemyInfo(level.player);
}
compound_die()
{
self endon("death");
if ( flag("chopper_in_use_by_player") )
{
go_here = GetNode("int_compound_flee_node", "targetname");
self thread compound_flee(go_here);
level waittill("chopper_exit");
wait 0.25;
self delete();
}
else
{
wait (RandomFloatRange(0.0, 2.0));
if (IsAlive(self))
{
self Kill(level.price.origin, level.price);
}
}
}
compound_flee(node)
{
self endon("death");
if (IsAlive(self) && !(self doingLongDeath()))
{
self thread watch_for_close_player();
self endon("player_close");
self.goalradius = 50;
self SetGoalNode(node);
self run_away(true);
if (!players_within_distance(250, self.origin))
{
self delete();
}
else
{
self.ignoreall = false;
self GetEnemyInfo(level.player);
self SetGoalEntity(level.player);
}
}
}
watch_for_close_player()
{
self endon("death");
while (true)
{
if ( players_within_distance(150, self.origin) )
{
self SetGoalEntity(level.player);
self GetEnemyInfo(level.player);
self.ignoreall = false;
self notify("player_close");
break;
}
wait 0.2;
}
}
outercompound_enemyvignettes()
{
thread simple_vignette( "outercompound_anim_guntable" );
thread simple_vignette( "outercompound_anim_dragbuddy" );
thread outercompound_anim_rpgcrate();
}
simple_vignette( vignette_name , extra_models )
{
flag_wait( vignette_name + "_spawnflag" );
ref_struct = getStruct( vignette_name , "targetname" );
spawners = getEntArray( vignette_name + "_ai" , "targetname" );
anim_group = [];
foreach( spawner in spawners )
{
ai = spawner spawn_ai();
anim_group[anim_group.size] = ai;
ai.animname = "generic";
ai.allowdeath = true;
ai.animation = spawner.animation;
ai.is_ai = true;
ai waittill_spawn_finished();
if (IsDefined(ai.script_noteworthy) && ai.script_noteworthy == "guy_being_dragged")
{
ai gun_remove();
}
}
if ( IsDefined( extra_models ))
{
anim_group = array_combine( anim_group , extra_models );
}
foreach( entity in anim_group )
{
ref_struct thread anim_first_frame_solo( entity , entity.animation );
}
flag_wait_or_timeout( vignette_name + "_lookflag" , 5.0 );
foreach ( entity in anim_group )
{
if (IsAlive(entity))
{
if ( IsDefined( entity.is_ai ))
{
ref_struct thread animate_then_path( entity );
}
else
{
ref_struct anim_single_solo( entity , entity.animation );
thread kill_guy_being_dragged( entity );
}
}
}
}
animate_then_path( entity )
{
self anim_single_solo( entity , entity.animation );
thread kill_guy_being_dragged( entity );
if ( IsAlive( entity ) && IsDefined( entity.target ))
{
entity thread maps\_spawner::go_to_node();
}
}
kill_guy_being_dragged( entity )
{
if(IsDefined(entity.script_noteworthy) && entity.script_noteworthy == "guy_being_dragged")
{
entity.noragdoll = 1;
entity.a.nodeath = true;
entity.ignoreme = true;
entity.ignoreall = true;
entity.diequietly = true;
entity kill();
}
}
outercompound_anim_rpgcrate()
{
flag_wait( "outercompound_anim_rpgcrate_spawnflag" );
thread outercompound_anim_rpgcrate_ai();
rpg_crate_clip = getent( "rpg_crate_clip","targetname" );
rpg_crate_clip solid();
ref_struct = getStruct( "outercompound_anim_rpgcrate" , "targetname" );
anim_model = Spawn( "script_model" , ref_struct.origin );
anim_model SetModel( "com_plasticcase_beige_big_us_dirt_animated" );
anim_model.animname = "rpg_crate";
anim_model SetAnimTree();
anim_model.animation = "payback_docks_get_rpg_crate";
ref_struct thread anim_first_frame_solo( anim_model , anim_model.animation );
flag_wait_or_timeout( "outercompound_anim_rpgcrate_lookflag" , 5.0 );
ref_struct anim_single_solo( anim_model, anim_model.animation );
}
outercompound_anim_rpgcrate_ai()
{
spawner = getent("outercompound_anim_rpgcrate_ai", "targetname");
ref_struct = getStruct( "outercompound_anim_rpgcrate" , "targetname" );
outercompound_anim_rpgcrate_ai = spawner spawn_ai();
outercompound_anim_rpgcrate_ai.animname = "generic";
outercompound_anim_rpgcrate_ai.allowdeath = true;
outercompound_anim_rpgcrate_ai.is_ai = true;
outercompound_anim_rpgcrate_ai.ignoreall = true;
ref_struct thread anim_first_frame_solo( outercompound_anim_rpgcrate_ai , outercompound_anim_rpgcrate_ai.animation );
flag_wait_or_timeout( "outercompound_anim_rpgcrate_lookflag" , 5.0 );
if ( IsAlive( outercompound_anim_rpgcrate_ai ))
{
ref_struct anim_single_solo( outercompound_anim_rpgcrate_ai , outercompound_anim_rpgcrate_ai.animation );
}
if ( IsAlive( outercompound_anim_rpgcrate_ai ) && IsDefined( outercompound_anim_rpgcrate_ai.target ))
{
outercompound_anim_rpgcrate_ai thread maps\_spawner::go_to_node();
outercompound_anim_rpgcrate_ai waittill("goal");
outercompound_anim_rpgcrate_ai shoot();
wait(2);
outercompound_anim_rpgcrate_ai.ignoreall = false;
}
}
compound_MG_VO()
{
flag_wait("compound_MG_VO");
mg_guys = GetEntArray("balcony_mg", "script_noteworthy");
mg_guys = array_combine(mg_guys, GetEntArray("rooftop_mg", "script_noteworthy"));
mg_guys = remove_dead_from_array(mg_guys);
if ( mg_guys.size > 0 && !flag("compound_courtyard_finished") )
{
level.soap play_vo("payback_mct_tearingus");
flag_wait( "chopper_usable" );
mg_guys = remove_dead_from_array(mg_guys);
if ( mg_guys.size > 0 && !flag("compound_courtyard_finished") )
{
level.price play_vo("payback_pri_yuriremotegun");
}
}
}
chopper_barrel_hack()
{
normal_fx = level.breakables_fx[ "barrel" ][ "explode" ];
big_fx = getfx("aerial_explosion_large_linger");
while ( !flag("compound_courtyard_finished") )
{
flag_wait("chopper_in_use_by_player");
level.breakables_fx[ "barrel" ][ "explode" ] = big_fx;
flag_waitopen("chopper_in_use_by_player");
level.breakables_fx[ "barrel" ][ "explode" ] = normal_fx;
}
}
compoundexit_vista_hide_show()
{
while ( !flag("compound_courtyard_finished") )
{
flag_wait("chopper_in_use_by_player");
GetEnt("compoundexit_vista", "targetname") Show();
flag_waitopen("chopper_in_use_by_player");
GetEnt("compoundexit_vista", "targetname") Hide();
}
}

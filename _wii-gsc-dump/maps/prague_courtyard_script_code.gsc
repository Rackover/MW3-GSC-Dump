#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
#include maps\prague_code;
courtyard_puzzle()
{
flag_wait( "courtyard_puzzle" );
music_play( "prague_tension_4" );
}
courtyard_beg_player_ignore()
{
flag_wait( "pre_courtyard_ally_clean_up" );
level endon( "kill_sniper_nag_lines" );
level.player.ignoreme = true;
level.sandman.ignoreme = true;
flag_wait_either( "can_shoot_player_courtyard", "courtyard_player_moving_too_fast" );
level.player.ignoreme = false;
level.sandman.ignoreme = false;
level notify( "player_gonna_die" );
disable_trigger_with_noteworthy( "prague_stop_5" );
radio_dialogue_stop();
thread radio_dialogue( "prague_spotted_2" );
waitframe();
dudes = getaiarray( "axis" );
foreach( ai in dudes )
{
ai clear_run_anim();
ai maps\_stealth_utility::disable_stealth_for_ai();
waitframe();
if ( isdefined( ai ) )
{
ai.ignoreme = false;
ai.ignoreall = false;
ai.favoriteenemy = level.player;
ai getenemyinfo( level.player );
ai setgoalentity ( level.player );
}
}
wait( 2 );
level.player dodamage( 70, level.player.origin + AnglesToRight( level.player.angles ) );
wait( 2 );
level.player dodamage( 70, level.player.origin - AnglesToRight( level.player.angles ) );
wait( 1 );
level.player dodamage( 70, level.player.origin + AnglesToForward( level.player.angles ) );
level.player kill();
}
aiShootPlayer( targetPlayer, center )
{
self notify( "aiShootPlayer" );
self endon( "aiShootPlayer" );
self endon ( "helicopter_removed" );
self endon ( "leaving" );
targetPlayer endon( "death" );
numShots = 6;
vollies = 2;
for ( ;; )
{
numShots--;
self FireWeapon( "tag_flash", targetPlayer );
wait ( .15);
if ( numShots <= 0 )
{
vollies--;
numShots = 6;
if ( distanceSquared( targetPlayer.origin, center ) > 500000 || vollies <= 0 || !isAlive(targetPlayer) )
{
self notify ("abandon_target");
return;
}
wait (1);
}
}
}
targetDeathWaiter( targetPlayer )
{
self endon ( "abandon_target" );
targetPlayer waittill( "death" );
self notify( "target_killed" );
}
courtyard_clean_stealth_thinkers()
{
flag_wait_any( "courtyard_combat_start", "_stealth_spotted" );
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b clear_run_anim();
b maps\_stealth_utility::disable_stealth_for_ai();
b addAIEventListener( "gunshot_teammate" );
b addAIEventListener( "gunshot_teammate" );
b addAIEventListener( "gunshot" );
b addAIEventListener( "grenade danger" );
b addAIEventListener( "bulletwhizby" );
b addAIEventListener( "projectile_impact" );
}
}
courtyard_sandman_think()
{
level endon( "_stealth_spotted" );
level endon( "courtyard_combat_start" );
level endon( "can_shoot_player_courtyard" );
level.sandman.ignoreall = true;
flag_wait( "sandman_climb_dumpster" );
if ( !flag( "courtyard_sandman_killed_dude" ) )
{
wait( 1.0 );
thread radio_dialogue( "prague_mct_stayclose" );
}
flag_wait( "courtyard_sandman_killed_dude" );
flag_set( "courtyard_puzzle" );
node = get_Target_ent( "sandman_cp_stop" );
node anim_generic_reach( level.sandman, "cornerL_idle" );
node thread anim_generic_loop( level.sandman, "cornerL_idle" );
flag_wait( "pre_courtyard_ally_clean_up" );
spawn_targetname( "roof_stealth_one" );
spawn_targetname( "roof_stealth_two" );
array_spawn_targetname( "roof_stealth_epic" );
node notify( "stop_loop" );
disable_trigger_with_noteworthy( "prague_stop_5" );
level.sandman thread dialogue_queue( "prague_mct_holdup" );
level.sandman animscripts\shared::placeweaponon( level.sandman.primaryweapon, "right" );
node anim_generic( level.sandman, "signal_stop_coverL" );
level.sandman thread dialogue_queue( "prague_mct_20plus" );
node thread anim_generic( level.sandman, "signal_enemy_coverL" );
level.sandman disable_cqbwalk();
level.sandman AllowedStances( "crouch", "prone" );
node notify( "stop_loop" );
level.sandman SetGoalNode( get_target_ent( "sandman_cp_look" ) );
childthread conversation();
thread conversation_2();
thread delay_flare();
level.sandman waittill( "goal" );
level.sandman AllowedStances( "crouch", "prone", "stand" );
}
conversation()
{
level endon( "courtyard_combat_start" );
level endon( "_stealth_spotted" );
wait( 2.7 );
radio_dialogue( "prague_pri_soapposition" );
wait( 0.4 );
radio_dialogue( "prague_mct_rallypoint" );
wait( 0.2 );
radio_dialogue( "prague_pri_fromwest" );
wait( 0.2 );
radio_dialogue( "prague_mct_roger" );
guys = array_spawn_targetname( "courtyard_roof_dying_quick_kill" );
wait( 0.4 );
thread rooftop_knife_kill();
thread courtyard_laser_sniper();
}
start_combat_on_spotted()
{
level endon( "roof_start_to_stand" );
flag_wait_either( "_stealth_spotted", "can_shoot_player_courtyard" );
flag_set( "_stealth_spotted" );
flag_set( "courtyard_combat_start" );
flag_set( "roof_start_to_stand" );
}
conversation_2()
{
level endon( "roof_start_to_stand" );
flag_wait ( "kill_sniper_nag_lines" );
thread start_combat_on_spotted();
wait( 1.3 );
level.sandman dialogue_queue( "prague_mct_lightswitch" );
level.sandman dialogue_queue( "prague_mct_onesdown" );
radio_dialogue( "prague_pri_dontworry" );
thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );
level.attacker.animname = "price";
flag_set( "roof_start_to_stand" );
}
delay_flare()
{
flag_wait( "roof_start_to_stand" );
wait( 6 );
flag_set( "sniper_shot" );
if( IsAlive ( level.victim ) )
{
level.victim Kill();
}
}
music_start_flare()
{
flag_wait_either( "roof_start_to_stand", "fire_flare" );
level.player.ignoreme = false;
level.sandman.ignoreme = false;
wait( 1 );
music_play( "prague_battle_three", 0.0 );
}
tell_player_too_slow_down()
{
level endon( "kill_sniper_nag_lines" );
level endon( "player_gonna_die" );
while( 1 )
{
if( !flag ( "soap_over_the_fence" ) && flag( "pre_courtyard_ally_clean_up" ) )
{
thread radio_dialogue(	"prague_stop_5" );
break;
}
wait( 0.05 );
}
}
sandman_combat()
{
flag_wait_any( "courtyard_combat_start", "_stealth_spotted" );
flag_set( "_stealth_spotted" );
wait( 3 );
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b notify( "stop_corpse_search" );
b maps\_stealth_utility::disable_stealth_for_ai();
b clear_run_anim();
b notify( "end_patrol" );
}
waitframe();
flag_clear( "_stealth_spotted" );
waitframe();
level.sandman.goalradius = 75;
level.sandman SetGoalNode( get_target_ent( "sandman_courtyard_look_and_fight" ) );
level.sandman.ignoreall = false;
level.sandman set_force_color( "r" );
level.sandman enable_ai_color();
level.sandman.ignoreme = false;
}
courtyard_knife_kill()
{
level endon( "courtyard_combat_start" );
level endon( "_stealth_spotted" );
node = get_Target_ent( "courtyard_takedown" );
level.victim = spawn_targetname( "courtyard_takedown_guy" );
level.victim disable_long_death();
level.sandman.ignoreme = true;
level.victim.ignoreall = true;
level.victim endon ( "death" );
waitframe();
level.victim disable_pain();
level.victim.health = 01;
level.victim.dropweapon = false;
level.victim removeAIEventListener( "gunshot" );
level.victim removeAIEventListener( "gunshot_teammate" );
level.victim removeAIEventListener( "bulletwhizby" );
level.victim removeAIEventListener( "projectile_impact" );
level.victim disable_danger_react();
level.victim.animname = "enemy";
level.victim.goalradius = 2;
level.victim.ignoreme = true;
level.victim thread flag_on_death( "courtyard_sandman_killed_dude" );
flag_wait( "sandman_climb_dumpster" );
node anim_reach_solo( level.sandman, "new_ally_kill" );
node thread interrupt_anim_on_alert_or_damage_courtyard_kill( level.victim, level.sandman );
level.sandman animscripts\shared::placeweaponon( level.sandman.primaryweapon, "left" );
node thread anim_single( [ level.sandman, level.victim ], "new_ally_kill" );
thread delete_trigger_if_player_moves_to_fast();
wait( 3.0 );
thread radio_dialogue( "prague_mct_goodnight" );
wait( 10 );
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b addAIEventListener( "bulletwhizby" );
b addAIEventListener( "projectile_impact" );
}
}
moving_in_ally_too_fast()
{
flag_wait( "courtyard_player_moving_too_fast" );
flag_set( "sandman_start_first_take_down" );
}
delete_trigger_if_player_moves_to_fast()
{
trigger = getent ( "courtyard_player_moving_too_fast_trigger", "targetname" );
trigger delete();
}
victim_god_mode( guy )
{
level.magic ++;
if( level.magic == 0 )
level.victim magic_bullet_shield();
}
sandman_shoot_pistol( guy )
{
PlayFXOnTag( level._effect[ "m4m203_silencer_flash" ] , guy , "TAG_WEAPON_RIGHT" );
PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , guy , "TAG_WEAPON_RIGHT" );
level.tag_shot = 0;
level.tag_shot ++;
level.victim.team = "neutral";
if( level.tag_shot == 0 )
{
PlayFXOnTag( level._effect[ "bodyshot1" ], level.victim, "J_eyeball_ri" );
wait( 0.1 );
PlayFXOnTag( level._effect[ "bodyshot2" ], level.victim, "J_Head_end" );
}
else if( level.tag_shot == 1 )
{
PlayFXOnTag( level._effect[ "bodyshot1" ], level.victim, "tag_inhand" );
wait( 0.1 );
PlayFXOnTag( level._effect[ "bodyshot2" ], level.victim, "J_SpineLower" );
}
}
courtyard_laser_sniper()
{
level.victim_two = get_living_ai( "rooftop_takedown_guy_laser", "script_noteworthy" );
level.victim_two.goalradius = 30;
level.victim_two.goalheight = 20;
waitframe();
level.victim_two thread rooftop_attack_death();
level.victim_two.animname = "enemy";
level.victim_two.ignoreme = true;
level.victim_two.ignoreall = true;
self.moveplaybackrate = 1;
node = get_Target_ent( "guy_laser_node" );
level.victim_two setgoalpos ( node.origin );
level.victim_two waittill( "goal" );
level.victim_two thread laser_moment();
level.victim_two AllowedStances( "crouch" );
waitframe();
level.victim_two LaserForceOn();
level.victim_two thread courtyard_laser_sniper_scanning();
}
price_aim_down()
{
self endon( "death" );
aim_helper = spawn_tag_origin();
vec = AnglestoForward( self.angles );
vec = vec*256;
aim_helper.origin = self.origin + vec + (-20,0,-150);
self setentitytarget ( aim_helper );
}
courtyard_laser_sniper_scanning()
{
self endon( "death" );
self.ignoreall = false;
aim_helper = spawn_tag_origin();
aim_helper_two = spawn_tag_origin();
vec = AnglestoForward( self.angles );
vec = vec*256;
aim_helper.origin = self.origin + vec + (-20,0,-150);
self enable_dontevershoot();
waitframe();
self LaserForceOn();
laser_value_one = getdvarfloat("laserflarepct");
laser_value_two = getdvarfloat("laserradius");
laser_value_three = getdvarfloat("laserlightradius");
waitframe();
setsaveddvar( "laserflarepct", "0.2" );
setsaveddvar( "laserradius", "4" );
setsaveddvar( "laserlightradius", "7" );
self thread aim_helper_think( aim_helper );
looking = 200;
flag_wait ( "kill_sniper_nag_lines" );
setsaveddvar( "laserflarepct", laser_value_one );
setsaveddvar( "laserradius", laser_value_two );
setsaveddvar( "laserlightradius", laser_value_three );
waitframe();
org = self GetTagOrigin( "tag_eye" );
fwd = self GetTagAngles( "tag_eye" );
MagicBullet( level.sandman.weapon, org - fwd, org );
}
aim_helper_think( aim_helper )
{
self endon ( "death" );
wait( 0.5 );
vec = AnglestoForward( self.angles );
vec = vec*256;
aim_helper.origin = self.origin + vec + (-20,0,-150);
while( 1 )
{
self setentitytarget ( aim_helper );
wait( 0.1 );
}
}
rooftop_knife_kill()
{
wait( 0.4 );
level endon( "_stealth_spotted" );
level.victim_roof = get_living_ai( "rooftop_takedown_guy", "script_noteworthy" );
level.victim_roof endon( "death" );
level.victim_roof.health = 10;
level.victim_roof.goalradius = 10;
level.victim_roof.goalheight = 10;
level.victim_roof enable_cqbwalk();
node = get_Target_ent( "rooftop_takedown" );
waitframe();
level.victim_roof thread rooftop_attack_if_player_caught();
level.victim_roof.animname = "enemy";
level.victim_roof.ignoreall = true;
self.moveplaybackrate = 1.3;
node = get_Target_ent( "rooftop_takedown" );
node anim_reach_solo( level.victim_roof, "rooftop_kill" );
node thread anim_loop_solo( level.victim_roof , "rooftop_kill_idle" );
level.victim_roof attach ( "weapon_binocular", "tag_weapon_right" );
wait( 1.3 );
level.sandman thread dialogue_queue( "prague_mct_scout" );
thread roof_sniper_nag_lines();
if( IsAlive( level.victim_roof ) )
{
level thread sniper_light_think();
}
level.victim_roof waittill_player_lookat( 0.1, 0.1 );
while( 1 )
{
if( level.player isADS() && level.player adsbuttonpressed() )
{
level.victim_roof waittill_player_lookat_for_time( 0.6, 0.90 );
flag_set ( "kill_sniper_nag_lines" );
flag_clear( "sandman_announce_spotted" );
level notify( "stop_stealth_busted_music" );
radio_dialogue_stop();
thread radio_dialogue_interupt(	"prague_mct_wait" );
music_stop( 5 );
node = get_Target_ent( "rooftop_takedown" );
level.attacker = spawn_targetname( "rooftop_stealth_attack_guy" );
level.attacker thread deletable_magic_bullet_shield();
spawn_failed();
level.attacker.disable_sniper_glint = true;
level.victim_roof thread interrupt_anim_on_alert_or_damage( node );
level.attacker thread interrupt_anim_on_alert_or_damage( node );
level.attacker.animname = "delta";
level.attacker.ignoreall = true;
level.attacker.ignoreme = true;
node notify( "stop_loop" );
level.attacker gun_remove();
node thread anim_single( [ level.attacker, level.victim_roof ], "rooftop_kill" );
level.attacker AllowedStances ( "crouch" );
wait( 3 );
level.attacker gun_recall();
wait( 2 );
level.victim_roof.a.nodeath = true;
level.victim_roof.allowPain = true;
level.victim_roof.allowDeath = true;
level.attacker.goalheight = 10;
level.attacker setgoalpos ( level.attacker.origin );
level.attacker.goalradius = 10;
node = get_Target_ent( "rooftop_takedown" );
level.attacker setgoalpos( node.origin );
level.attacker price_aim_down();
flag_wait( "roof_all_standing" );
flag_set ( "courtyard_air_drop" );
wait ( 3 );
level.victim_roof.goalradius = 10;
level.victim_roof AllowedStances ( "stand" );
level.victim_roof.ignoreall = false;
level.victim_roof.ignoreme = false;
flag_wait( "fire_flare" );
wait( 6 );
level.attacker.ignoreall = false;
level.attacker.ignoreme = false;
break;
}
wait (0.05);
}
}
laser_moment()
{
level endon ("_stealth_spotted");
level endon ("courtyard_combat_start");
flag_set ( "turn_on_laser_moment" );
}
hide_roof_victim( guy )
{
guy endon ( "death" );
wait( 3 );
ent_to_teleport = getnode( "teleport_node", "targetname" );
waitframe();
level.victim_roof teleport_ai( ent_to_teleport );
level.victim_roof hide();
}
stab_fx_function( guy )
{
PlayFxOnTag( level._effect[ "flesh_hit_head_fatal_exit_exaggerated" ], level.victim_roof, "TAG_WEAPON_CHEST" );
wait( 0.4 );
PlayFxOnTag( level._effect[ "bodyshot2" ], level.victim_roof, "J_SpineLower" );
}
roof_sniper_nag_lines()
{
level endon ( "kill_sniper_nag_lines" );
wait( 4 );
while( IsAlive( level.victim_roof ) )
{
num = randomintrange( 0, 3 );
switch( num )
{
case 0:
thread radio_dialogue(	"prague_mct_sniperyuri" );
wait( 4 );
case 1:
thread radio_dialogue(	"prague_mct_takehimdown" );
wait( 4 );
case 2:
wait( 4 );
}
wait( 0.005 );
}
}
rooftop_attack_if_player_caught()
{
self endon ( "death" );
flag_wait_any( "_stealth_spotted", "courtyard_combat_start" );
self dodamage( self.health + 300, self.origin );
}
rooftop_attack_death()
{
self waittill( "death" );
}
guys_on_rooftops()
{
self endon( "_stealth_spotted" );
self hide();
self thread guys_on_roof_stealth_alerted();
self.accuracy = 0.001;
self enable_dontevershoot();
self.health = 5;
self.ignoreall = true;
self.ignoreme = true;
self.goalradius = 10;
self endon ( "death" );
self thread player_aims_rebels();
wait( 2 );
self endon ( "death" );
self.animname = "generic";
self thread anim_generic_loop( self, "prone_idle", "stop_loop" );
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_two" ) || ( self.script_noteworthy == "roof_stealth_one" ))
{
flag_wait( "roof_start_to_stand" );
}
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_epic" ) )
{
flag_wait( "roof_start_to_stand" );
}
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_two_kamarov" ) )
{
self thread deletable_magic_bullet_shield();
flag_wait( "kill_sniper_nag_lines" );
}
self show();
self.moveplaybackrate = 0.5;
if ( IsDefined ( self.script_noteworthy ) && self.script_noteworthy == "roof_stealth_epic" )
{
thread guys_on_roof_time_tracker();
}
if ( IsDefined ( self.script_noteworthy ) && self.script_noteworthy == "roof_stealth_epic" )
{
wait randomfloatrange( 0.1, 0.7 ) ;
}
num = 0;
num = randomintrange ( 0, 1 );
self notify ( "stop_loop" );
if ( num == 0 )
self thread anim_single_solo( self, "prone_2_stand" );
else
self thread anim_single_solo( self, "prone_to_stand_two" );
self AllowedStances ( "stand" );
num = 0;
num = randomintrange ( 0, 10 );
dont = 0;
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_two_kamarov" ) )
{
self AllowedStances ( "crouch" );
flag_wait( "roof_start_to_stand" );
self AllowedStances ( "stand" );
}
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_two" ) )
{
self.disable_sniper_glint = true;
dont = 1;
self thread anim_single_solo( self, "coup_guard2_jeerC" );
}
wait( 2.5 );
if ( ( num >= 5 ) && ( level.number_to_random <= 6 ) )
{
if( dont == 1 )
{
}
else if ( dont == 0)
{
level.number_to_random ++;
num = 0;
num = randomfloatrange( 0, 1 );
if( num == 0 )
self thread anim_single_solo( self, "coup_guard2_jeerA" );
else
self thread anim_single_solo( self, "coup_guard2_jeerC" );
}
}
else
self delaythread( 3, ::guys_on_rooftops_looking );
flag_wait( "roof_all_standing" );
wait( 2 );
wait randomfloatrange( 1.3, 3.3 ) ;
flag_wait( "courtyard_combat_start" );
wait( 4.5 );
self disable_dontevershoot();
self.ignoreall = false;
self.ignoreme = false;
wait randomintrange( 3, 5 );
if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "roof_stealth_two_kamarov" ) )
{
self thread stop_magic_bullet_shield();
flag_wait( "kill_sniper_nag_lines" );
}
if ( IsDefined ( self.script_noteworthy ) && self.script_noteworthy == "roof_stealth_epic" )
{
self dodamage( self.health + 300, self.origin );
}
}
guys_on_roof_stealth_alerted()
{
flag_wait( "_stealth_spotted" );
wait randomintrange( 3, 5 );
if ( IsDefined ( self.script_noteworthy ) && self.script_noteworthy == "roof_stealth_epic" )
{
self dodamage( self.health + 300, self.origin );
}
}
guys_on_roof_time_tracker()
{
wait ( 5 );
flag_set( "roof_all_standing" );
}
guys_on_rooftops_looking()
{
self endon( "death" );
axis = getaiarray( "axis" );
self.ignoreall = false;
aim_helper = spawn_tag_origin();
vec = AnglestoForward( self.angles );
vec = vec*256;
if ( IsDefined ( self.script_noteworthy ) && self.script_noteworthy == "roof_stealth_epic" )
aim_helper.origin = self.origin + vec + (0,0,-200);
else
aim_helper.origin = self.origin + vec + (0,0,-300);
aim_helper linkto ( self );
self enable_dontevershoot();
self setentitytarget ( aim_helper );
flag_wait( "courtyard_combat_start" );
wait( 4.5 );
waitframe();
self disable_dontevershoot();
self clearentitytarget();
}
roof_top_assign_random_death()
{
num = 0;
switch ( num )
{
case 0:
break;
case 1:
break;
case 2:
break;
case 3:
break;
case 4:
break;
}
}
orient_to_player( num )
{
self endon ( "death" );
while ( true )
{
self orientmode( "face point", level.player geteye() );
wait 0.05;
}
}
sniper_light_think()
{
}
turn_off_light( guy )
{
stopFxOnTag( getfx( "flashlight" ), level.victim_roof, "TAG_FLASH" );
}
damage_trigger_clear_stealth()
{
damage_trigger = getent ( "detect_damage_clear_stealth", "targetname" );
flag_wait( "pre_courtyard_ally_clean_up" );
damage_trigger trigger_on();
level endon( "kill_sniper_nag_lines" );
damage_trigger waittill ( "damage" );
flag_set( "can_shoot_player_courtyard" );
flag_set( "courtyard_combat_start" );
flag_set( "_stealth_spotted" );
flag_set( "roof_start_to_stand" );
}
courtyard_puzzle_guys_think()
{
self.goalheight = 100;
self thread enemy_dead_add();
self endon( "death" );
flag_wait( "courtyard_combat_start" );
self.goalradius = 475;
}
courtyard_backup()
{
flag_wait( "kill_sniper_nag_lines" );
level endon( "start_apartments" );
flag_wait_any( "courtyard_combat_start", "_stealth_spotted", "fire_flare" );
axis = getaiarray( "axis" );
door_r = get_Target_ent( "courtyard_spawner_door_r" );
door_l = get_Target_ent( "courtyard_spawner_door_l" );
goal = GetEnt( "court_yard_backup_goal", "targetname" );
backup = array_spawn_targetname( "courtyard_backup" );
backup = get_living_ai_array( "courtyard_backup", "script_noteworthy" );
foreach ( b in backup )
{
b set_forcegoal();
b.health = 200;
b thread enemy_dead_add();
b.nododgemove = true;
b.ignoreme = true;
b.ignoresuppression = true;
b.ignoreall = true;
b.goalradius = 10;
b SetGoalpos( goal.origin );
}
wait( 8 );
foreach ( b in backup )
{
if( IsAlive( b ) )
{
b unset_forcegoal();
b.nododgemove = false;
b.ignoreme = false;
b.ignoresuppression = false;
b.ignoreall = false;
b.goalradius = 275;
b SetGoalpos( goal.origin );
}
}
wait( 1 );
thread kick_double_door_open( door_l, door_r );
spawners = GetEntArray( "courtyard_fight_good", "targetname" );
maps\_spawner::flood_spawner_scripted( spawners );
rebel_cover_nodes_one = getent( "rebel_cover_nodes_one", "targetname" );
rebel_cover_nodes_one activate_trigger();
dudes = get_living_ai_array_parameters( "second_building_ai", "parameters" );
foreach( b in dudes )
{
if( IsAlive( dudes ) )
dudes dodamage( dudes.health + 300, dudes.origin );
}
ent_origin2 = spawn ( "script_origin", ( 11916, -13038, -62 ) );
thread play_sound_in_space ( "walla_prague_courtyard_bottom_guys", ent_origin2.origin );
wait( 8 );
ent_origin2 delete();
}
courtyard_sniper()
{
level endon ( "courtyard_combat_start" );
dude = get_living_ai( "courtyard_sniper", "script_noteworthy" );
dude waittill_either( "death", "_stealth_spotted" );
flag_set ( "sniper_shot" );
flag_set( "courtyard_air_drop" );
}
courtyard_airdrop()
{
heli_spawner_actual = spawn_vehicle_from_Targetname_and_drive( "plaza_cargo_heli" );
m_heli = heli_spawner_actual vehicle_to_dummy();
m_heli.animname = "mi17";
heli_spawner = get_Target_ent( "plaza_cargo_heli" );
waitframe();
node = get_Target_ent( "courtyard_airdrop_node" );
rope = spawn_anim_model( "airdrop_rope" );
btr = spawn_anim_model( "btr" );
thread jeremy_sound_control_crash( m_heli, rope, btr );
airdrop_group = [ m_heli, rope, btr ];
node anim_first_frame( airdrop_group, "airdrop_idle" );
thread shoot_btr_with_rocket( m_heli, btr, rope, heli_spawner_actual );
node thread anim_single( airdrop_group, "airdrop_idle" );
flag_wait( "courtyard_air_drop" );
flag_wait( "pre_courtyard_ally_clean_up" );
node notify( "stop_loop" );
node thread anim_single( airdrop_group, "prague_drop_btr" );
blocker = get_Target_ent( "courtyard_btr_blocker" );
blocker2 = get_Target_ent( "courtyard_btr_blocker_player" );
wait( 7.5 );
blocker solid();
blocker2 solid();
blocker Disconnectpaths();
}
jeremy_sound_control_crash( m_heli, rope, btr )
{
m_heli playloopsound( "mi17_idle_high" );
flag_wait( "courtyard_air_drop" );
flag_wait( "pre_courtyard_ally_clean_up" );
wait( 5 );
m_heli stoploopsound( "mi17_idle_high" );
m_heli playsound( "mi17_helicopter_hit" );
m_heli playloopsound ("mi17_helicopter_dying_loop" );
wait( 7 );
m_heli stoploopsound ("mi17_helicopter_dying_loop" );
m_heli playsound ("mi17_helicopter_crash" );
}
jeremy_btr_crash_sounds( guy )
{
guy playsound( "mi17_helicopter_hit" );
PlayFxOnTag( getfx( "tank_impact_exaggerated_2" ), guy, "tag_wheel_middle_right" );
RadiusDamage( guy getTagOrigin("tag_wheel_middle_right"), 512, 500, 500 );
wait( 2 );
RadiusDamage( guy getTagOrigin("tag_wheel_middle_right"), 75, 500, 500 );
}
stop_air_drop()
{
flag_wait( "courtyard_combat_start" );
self notify( "stop_loop" );
}
shoot_btr_with_rocket( m_heli, btr, rope, heli_spawner_actual )
{
level endon( "player_gonna_die" );
flag_wait( "pre_courtyard_ally_clean_up" );
level waittill_any( "sniper_shot", "_stealth_spotted", "courtyard_combat_start" );
level notify( "stop_stealth_busted_music" );
wait( 1.3 );
thread magic_smoke( "plaza_smoke" );
flag_set( "fire_flare" );
player_speed_percent( 100 );
ent_origin = spawn ( "script_origin", ( 12006, -12280, 708 ) );
thread play_sound_in_space ( "walla_prague_courtyard_attack_left", ent_origin.origin );
ent_origin2 = spawn ( "script_origin", ( 12896, -12284, 708 ) );
thread play_sound_in_space ( "walla_prague_courtyard_attack_right", ent_origin2.origin );
level.sandman disable_cqbwalk();
flag_clear( "sandman_announce_spotted" );
flag_set ( "courtyard_air_drop" );
wait( 0.5 );
thread shutter_manager();
wait( 3.0 );
org = GetStruct( "build_fake_molotov_start", "targetname" );
impact_point = GetStruct( "build_fake_molotov_end", "targetname" );
org thread molotov_goes_jeremy( org, impact_point );
MagicBullet( "rpg",( 11667.6, -12511.1, 735.5 ), ( 12680.5, -12878.5, 376 ) );
wait( 0.7 );
MagicBullet( "rpg",( 11850, -13168, 212 ), ( 12680.5, -12878.5, 376 ) );
wait( 1.7 );
org = spawn( "script_origin", ( 11979, -12259, 694.5 ) );
impact_point = spawn( "script_origin", ( 12083, -13243, -82.5 ) );
thread molotov_goes_jeremy( org, impact_point );
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b.ignoreme = false;
}
MagicBullet( "rpg_straight",( 11619.1, -12293.9, 735.148 ), ( m_heli.origin ) );
wait( 0.5 );
courtyard_btr_seconday_landing = GetStruct( "courtyard_btr_seconday_landing_two", "targetname" );
btr_spawner = getent( "plaza_btr_spawner", "targetname" );
btr_spawner.origin = courtyard_btr_seconday_landing.origin;
btr_spawner.angles = courtyard_btr_seconday_landing.angles;
waitframe();
PlayFX( level._effect[ "helicopter_explosion_mi17_woodland" ], m_heli.origin , ( 0,0,-100 ) );
wait( 1.6 );
Earthquake( 1, 0.4, level.player.origin, 400 );
wait( 2.8 );
wait( 3 );
org = spawn( "script_origin", ( 15008, -13036, 553 ) );
impact_point = spawn( "script_origin", ( 15230, -12720, -72 ) );
thread molotov_goes_jeremy( org, impact_point );
ent_origin delete();
ent_origin2 delete();
wait( 4 );
PlayFxOnTag( getfx( "helicopter_explosion_mi17_woodland" ), m_heli, "tag_origin" );
m_heli delete();
waitframe();
heli_spawner_actual delete();
}
courtyard_plaza_enemy_manager()
{
level endon( "player_gonna_die" );
flag_wait( "pre_courtyard_ally_clean_up" );
flag_wait( "courtyard_combat_start" );
level.enemy_ai = get_living_ai_array_parameters( "courtyard_guys_jeremy", "parameters" );
color_node_to_activate = getent( "turn_on_color_trigger", "targetname" );
trigger_to_activate = getent( "courtyard_support_trigger", "targetname" );
alive_before_retreat = 3;
level thread enemy_group_almost_dead_run( alive_before_retreat, "courtyard_retreat_one", color_node_to_activate, trigger_to_activate );
flag_wait( "courtyard_retreat_one" );
flag_set( "courtyard_retreat_one" );
CreateThreatBiasGroup( "player" );
level.player SetThreatBiasGroup("player");
setthreatbias( "axis", "player", 10000 );
rebel_cover_nodes_two = getent( "rebel_cover_nodes_two", "targetname" );
rebel_cover_nodes_two activate_trigger();
wait( 5 );
level.enemy_ai = get_living_ai_array_parameters( "courtyard_guys_jeremy", "parameters" );
level thread enemies_getaway( "courtyard_one_getaway_trigger" );
color_node_to_activate = getent( "turn_on_color_trigger_two", "targetname" );
trigger_to_activate = getent( "courtyard_support_trigger_two", "targetname" );
alive_before_retreat = 4;
level thread enemy_group_almost_dead_run( alive_before_retreat, "retreat_two", color_node_to_activate, trigger_to_activate );
flag_wait( "retreat_two" );
flag_set( "retreat_two" );
autosave_by_name( "retreat_two" );
rebel_cover_nodes_three = getent( "rebel_cover_nodes_three", "targetname" );
rebel_cover_nodes_three activate_trigger();
wait( 5 );
level.enemy_ai = get_living_ai_array_parameters( "courtyard_guys_jeremy", "parameters" );
level thread enemies_getaway( "courtyard_two_getaway_trigger" );
color_node_to_activate = getent( "turn_on_color_trigger_three", "targetname" );
trigger_to_activate = getent( "courtyard_support_trigger_three", "targetname" );
alive_before_retreat = 6;
level thread enemy_group_almost_dead_run( alive_before_retreat, "retreat_three", color_node_to_activate, trigger_to_activate );
flag_wait( "retreat_three" );
flag_set( "retreat_three" );
flag_set( "fire_flare_two" );
vec1 = spawn( "script_origin", ( 14142, -12533, -72 ) );
radiusdamage( vec1.origin, 30, 5000, 100 );
vec2 = spawn( "script_origin", ( 14388, -12492, -64 ) );
radiusdamage( vec2.origin, 30, 5000, 100 );
truck = spawn_vehicle_from_targetname_and_drive ( "plaza_btr_attack" );
thread radio_dialogue( "prague_mct_truckcoming" );
wait( 5 );
radiusdamage( vec1.origin, 30, 5000, 100 );
radiusdamage( vec2.origin, 30, 5000, 100 );
level.enemy_ai = get_living_ai_array_parameters( "courtyard_guys_jeremy", "parameters" );
level thread enemies_getaway( "courtyard_three_getaway_trigger" );
color_node_to_activate = getent( "turn_on_color_trigger_four", "targetname" );
alive_before_retreat = 4;
level thread enemy_group_almost_dead_run( alive_before_retreat, "plaza_btrs_show_up", color_node_to_activate );
flag_wait( "plaza_btrs_show_up" );
rebel_cover_nodes_five = getent( "rebel_cover_nodes_five", "targetname" );
rebel_cover_nodes_five activate_trigger();
spawners = GetEntArray( "courtyard_support_ai_three", "targetname" );
maps\_spawner::flood_spawner_scripted( spawners );
array_spawn_function_targetname( "courtyard_support_ai_three", :: floodspawner_new_goal );
}
floodspawner_new_goal()
{
goal = getent( "courtyard_three_getaway_trigger", "targetname" );
self.goalradius = 400;
self.goalheight = 100;
self SetGoalpos( goal.origin );
}
courtyard_sandman_cover_direction()
{
trigger = getent( "turn_on_color_trigger", "targetname" );
trigger_origin = spawn ( "script_origin", trigger.origin );
waitframe();
if ( !isDefined( trigger.realOrigin ) )
trigger.realOrigin = trigger.origin;
if ( trigger.origin == trigger.realorigin )
trigger.origin += ( 0, 0, -10000 );
flag_wait( "kill_sniper_nag_lines" );
battlechatter_off( "allies" );
flag_wait( "fire_flare" );
wait( 4 );
thread radio_dialogue( "prague_pri_gettochurch" );
thread radio_dialogue( "prague_mct_letsgoyuri3" );
wait( 3 );
if ( isDefined( trigger.realOrigin ) )
trigger.origin = trigger.realOrigin;
if ( isDefined( trigger ) )
trigger waittill ( "trigger" );
thread radio_dialogue( "prague_mct_tothestatue" );
battlechatter_on( "allies" );
level.sandman set_battlechatter( true );
trigger = getent( "turn_on_color_trigger_two", "targetname" );
trigger waittill ( "trigger" );
thread radio_dialogue(	"prague_go_6" );
trigger = getent( "turn_on_color_trigger_three", "targetname" );
trigger waittill ( "trigger" );
thread radio_dialogue(	"prague_go_6" );
trigger = getent( "turn_on_color_trigger_four", "targetname" );
trigger waittill ( "trigger" );
flag_set( "plaza_btrs_show_up" );
wait( 1 );
level.sandman SetGoalNode( get_target_ent( "sandman_cover_car_slide" ) );
level.sandman.goalradius = 20;
level.sandman disable_ai_color();
}
enemy_dead_add()
{
CreateThreatBiasGroup( "player" );
level.player SetThreatBiasGroup("player");
setthreatbias( "axis", "player", 10000 );
level.counter_dead ++;
self waittill( "death" );
level.counter_dead --;
}
enemy_dead_add_two()
{
CreateThreatBiasGroup( "player" );
level.player SetThreatBiasGroup("player");
setthreatbias( "axis", "player", 10000 );
wait( 8 );
level.counter_dead ++;
self waittill( "death" );
level.counter_dead --;
}
enemy_group_almost_dead_run( alive_before_retreat, named_flag, color_node_to_activate, trigger_to_activate )
{
while( !flag( named_flag ) )
{
if ( level.counter_dead < alive_before_retreat )
{
if( IsDefined ( trigger_to_activate ) )
{
trigger_to_activate activate_trigger( );
}
flag_set ( named_flag );
if( IsDefined ( color_node_to_activate ) )
{
color_node_to_activate activate_trigger ( );
}
break;
}
wait( 0.05 );
}
if( IsDefined ( trigger_to_activate ) )
{
trigger_to_activate activate_trigger( );
}
if( IsDefined ( color_node_to_activate ) )
{
color_node_to_activate activate_trigger ( );
}
}
enemies_getaway( targetname )
{
goal = GetEnt( targetname, "targetname" );
level.enemy_ai = array_removedead_or_dying( level.enemy_ai );
guys = SortByDistance( level.enemy_ai, goal.origin );
for ( i = 0; i < guys.size; i++ )
{
if ( IsDefined ( guys[ i ] ) && IsAlive( guys[ i ] ) )
{
guys[ i ].goalradius = 1024;
guys[ i ] SetGoalpos( goal.origin );
wait( RandomFloatRange( 1, 2 ) );
}
}
}
resistence_in_buildings()
{
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b.ignoreme = true;
b.ignoreall = true;
}
spawn_targetname( "courtyard_ar_guy_build_one" );
spawn_targetname( "courtyard_rpg_guy_build_one" );
spawn_targetname( "courtyard_ar_guy_build_two" );
spawn_targetname( "courtyard_rpg_guy_build_two" );
spawn_targetname( "courtyard_rpg_guy_build_two_third" );
guys = Get_living_Ai_Array( "courtyard_apt_resistance", "script_noteworthy" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ].ignoreall = true;
guys[ i ].ignoreme = true;
guys[ i ].accuracy = 0.001;
guys[ i ] AllowedStances( "stand" );
}
wait( 4.5 );
for( i = 0; i < guys.size; i++ )
{
guys[ i ].ignoreall = false;
guys[ i ].ignoreme = false;
guys[ i ].accuracy = 0.001;
}
foreach ( b in axis )
{
if ( IsAlive ( b) )
{
b.ignoreme = false;
b.ignoreall = false;
}
}
flag_wait( "rebels_two" );
org = spawn( "script_origin", ( 13855, -12163, 525 ) );
impact_point = spawn( "script_origin", ( 14256, -12886, -72 ) );
thread molotov_goes_jeremy( org, impact_point );
wait( 2 );
org = spawn( "script_origin", ( 14271, -12139, 581 ) );
impact_point = spawn( "script_origin", ( 14414.3, -12723.1, -85.2649 ) );
thread molotov_goes_jeremy( org, impact_point );
org = spawn( "script_origin", ( 13507, -13149, 856 ) );
impact_point = spawn( "script_origin", ( 14297, -12321.1 , -28 ) );
thread molotov_goes_jeremy( org, impact_point );
wait( 13 );
guys = Get_living_Ai_Array( "courtyard_apt_resistance", "script_noteworthy" );
dude = get_living_ai( "rooftop_takedown_guy", "targetname" );
if ( IsAlive( dude ) )
{
dude dodamage( dude.health + 300, dude.origin );
}
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
guys = get_living_ai_array_parameters( "rooftop_courtyard_apt_resistance", "parameters" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
flag_wait( "retreat_three" );
org = spawn( "script_origin", ( 15008, -13036, 553 ) );
impact_point = spawn( "script_origin", ( 15230, -12720, -72 ) );
thread molotov_goes_jeremy( org, impact_point );
level.sandman.ignoreme = true;
}
plaza_btr_load_and_leave( model )
{
level endon( "courtyard_combat_start" );
riders = get_living_ai_array( "plaza_btr_riders", "script_noteworthy" );
wait( 2.0 );
struct = get_Target_ent( "btr_enter_pos" );
riders = SortByDistance( riders, struct.origin );
foreach ( r in riders )
{
wait( RandomFloatRange( 0.2, 0.6 ) );
r clear_run_anim();
r notify( "end_patrol" );
r SetGoalPos( struct.origin );
r thread delete_on_goal();
}
while ( 1 )
{
empty = true;
foreach ( r in riders )
{
if ( IsDefined( r ) )
{
empty = false;
break;
}
}
if ( empty )
break;
wait( 0.1 );
}
wait( 1.0 );
node = get_target_ent( "plaza_btr_exit_node" );
node = node get_target_ent();
flag_set( "courtyard_btr_left" );
brushmodel = get_Target_ent( "courtyard_btr_blocker" );
brushmodel NotSolid();
brushmodel ConnectPaths();
brushmodel Delete();
brushmodel = get_Target_ent( "courtyard_btr_blocker_player" );
brushmodel NotSolid();
btr = self spawn_vehicle();
model Delete();
btr vehicle_lights_on( "running spotlight_turret" );
btr endon( "death" );
wait( 2.0 );
while ( IsDefined( node ) )
{
btr vehicleDriveTo( node.origin, 15 );
while ( Distance2D( btr.origin, node.origin ) > 32 )
wait( 0.1 );
if ( !isdefined( node.target ) )
break;
node = node get_Target_ent();
}
btr Delete();
}
pre_courtyard_think()
{
self.ignoreall = true;
self endon( "death" );
}
plaza_loader_think()
{
node = self get_Target_ent();
self thread interrupt_anim_on_alert_or_damage_jeremy( self, node );
self endon( "death" );
self gun_remove();
attach_tag = "TAG_INHAND";
self.flashlight = Spawn( "script_model", self.origin );
flashlight = self.flashlight;
flashlight.owner = self;
flashlight.origin = self GetTagOrigin( attach_tag );
flashlight.angles = self GetTagAngles( attach_tag );
flashlight SetModel( "com_flashlight_off" );
flashlight LinkTo( self, attach_tag );
node thread anim_generic_loop( self, node.animation );
PlayFxOnTag( getfx( "flashlight" ), flashlight, "TAG_LIGHT" );
flag_wait_any( "courtyard_combat_start", "_stealth_spotted" );
flashlight Delete();
}
interrupt_anim_on_alert_or_damage_jeremy( guy, node )
{
guy endon( "death" );
guy endon( "end_reaction" );
guy endon( "animation_killed_me" );
guy addAIEventListener ( "bulletwhizby" );
guy addAIEventListener ( "gunshot_teammate" );
guy addAIEventListener ( "projectile_impact" );
guy waittill_any( "damage", "_stealth_bad_event_listener", "enemy", "courtyard_combat_start", "_stealth_spotted" );
flag_set( "courtyard_combat_start", "roof_start_to_stand" );
guy notify( "stop_loop" );
guy StopAnimScripted();
guy gun_recall();
node notify( "stop_loop" );
}
interrupt_anim_on_alert_or_damage_courtyard_kill( victim, killer )
{
victim endon( "death" );
victim endon( "end_reaction" );
victim endon( "animation_killed_me" );
victim waittill_any( "damage", "_stealth_bad_event_listener", "enemy", "courtyard_combat_start" );
victim StopAnimScripted();
killer StopAnimScripted();
self notify( "stop_loop" );
}
move_btr_primary_light_two( light )
{
light thread follow_btr( self );
wait( 25 );
intensity = light GetLightIntensity();
while ( intensity > 0 )
{
intensity -= 0.1;
light SetLightIntensity( intensity );
wait( 0.05 );
}
light notify( "kill_light" );
wait( 0.05 );
light SetLightIntensity( 0 );
}
shutter_manager()
{
left_shutter = GetEntArray( "shutter_left_jeremy", "targetname" );
right_shutter = GetEntArray( "shutter_right_jeremy", "targetname" );
for( i = 0; i < left_shutter.size; i++ )
{
for( i = 0; i < right_shutter.size; i++ )
{
wait( RandomFloatRange( 0.1, 0.4 ) );
right_shutter[ i ] rotateyaw( 120, 0.5, 0.1, 0.2 );
wait( RandomFloatRange( 0.6, 0.7 ) );
left_shutter[ i ] rotateyaw( -120, 0.5, 0.1, 0.2 );
}
}
}
heli_support_prague_code()
{
flag_wait( "heli_support_courtyard" );
heli2 = spawn_vehicle_from_targetname_and_drive ( "plaza_heli_support_two" );
heli2 thread helicopter_searchlight_on();
thread radio_dialogue( "prague_mct_helosinbound" );
wait( 4 );
ent = spawn ( "script_origin", ( 14426, -12638, -64 ) );
heli2 helicopter_setturrettargetent( ent );
while( IsAlive( heli2 ) )
{
ent moveto( ( 14272, -12254, -72 ), 3.3 );
wait( 3.3 );
ent moveto( ( 14416, -12886, -72 ), 3.3 );
wait( 3.3 );
}
}
player_aims_rebels()
{
level endon( "start_apartments" );
self endon ( "death" );
flag_wait( "courtyard_combat_start" );
level.talking_about_rebels = 0;
while( 1 )
{
level.talking_about_rebels = 0;
self waittill_player_lookat_for_time( 1, 0.92 );
if( level.player isADS() && level.player adsbuttonpressed() )
{
self waittill_player_lookat_for_time( 1 );
level.looked_at_roof_rebel ++;
if( level.looked_at_roof_rebel == 0 )
{
if ( level.talking_about_rebels == 0 )
{
level.talking_about_rebels = 1;
thread radio_dialogue_interupt( "prague_mct_onourside" );
wait( 5 );
}
}
if( level.looked_at_roof_rebel == 1 )
{
if ( level.talking_about_rebels == 0 )
{
level.talking_about_rebels = 1;
thread radio_dialogue_interupt( "prague_mct_friendlies" );
wait( 5 );
}
}
if( level.looked_at_roof_rebel == 2 )
{
wait( 5 );
}
if( level.looked_at_roof_rebel >= 3 )
{
wait( 5 );
}
}
wait( 0.05 );
}
}
molotov_goes_jeremy( org, impact_point, create_trail )
{
grenade = MagicGrenade( "molotov", org.origin, impact_point.origin, 5 );
if ( !isdefined( grenade ) )
return;
grenade waittill( "death" );
if ( isdefined( impact_point.script_exploder ) )
{
exploder( impact_point.script_exploder );
}
if ( isdefined( create_trail ) )
{
trail_angle = VectorToAngles( impact_point.origin - org.origin );
orig = grenade.origin;
ent = Spawn( "script_model", orig );
ent setModel( "tag_origin" );
ent.angles = (270, 180, 180);
ent2 = Spawn( "script_model", orig );
ent2 setModel( "tag_origin" );
ent2.angles = (0, 0, 0);
ent linkTo( ent2 );
ent2.angles = (0,180,0) + trail_angle;
PlayFxOnTag( getfx( "molotov_trail_F" ), ent, "tag_origin" );
for( i=0; i<20; i++ )
{
vec = AnglesToForward( trail_angle );
orig2 = orig + (vec * ( i * 10 )) + ( 0, 0, 4 );
line( orig, orig2, (1,0,0) );
RadiusDamage( orig2, 32, 100, 100 );
wait( 0.05 );
}
}
}
base_loud_speakers()
{
level.speaker_location = "off";
flag_wait( "heli_support_courtyard" );
level.speaker_location = "player";
level.speaker_min_delay = 20;
level.speaker_max_delay = 30;
level notify( "play_loud_speaker" );
}
shoot_cars_so_their_dead()
{
}
change_model()
{
ai = GetStruct( "change_model", "script_noteworthy" );
ai setModel ();
}

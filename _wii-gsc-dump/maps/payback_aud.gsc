#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_music;
#include maps\_audio_vehicles;
#include maps\_audio_stream_manager;
#include maps\_audio_dynamic_ambi;
main()
{
aud_init();
aud_set_timescale("default");
aud_set_occlusion("soft_occlusion");
set_stringtable_mapname("rvn");
aud_init_flags();
aud_init_globals();
aud_launch_threads();
aud_launch_loops();
aud_create_level_envelop_arrays();
aud_add_note_track_data();
aud_precache_presets();
MM_add_submix("mix_payback_global");
thread loop_rpg_babysitter();
aud_register_handlers();
}
aud_init_flags()
{
flag_init("aud_door_slowmo_exit");
flag_init("aud_player_rappel");
flag_init("beach_music_climax");
flag_init("stop_beach_music");
flag_init("constr_sand_sweeten_done");
flag_init("chopper_hit_primed_now_go");
}
aud_init_globals()
{
level.aud.do_stop_ambush_music = false;
level.aud.do_start_compound_music = true;
level.aud.rocket_lfe = false;
level.aud.player_in_sandstorm = false;
level.aud.max_bullets = 18;
level.aud.playing_bullet_count = 0;
level.bMusBeachVolUpDone = false;
level.aud.bMusBeachPlayed = false;
level.aud.chopper_enabled = false;
level.aud.voprimeindex = 0;
level.aud.voprime = [];
for(i = 0; i < 4; i++)
{
level.aud.voprime[i] = spawn("script_origin", (0, 0, 0));
}
}
aud_launch_threads()
{
thread damb_chopper_fire();
}
aud_launch_loops()
{
thread aud_ignore_slowmo();
level.aud.irongate = Spawn( "script_origin", (105, -1451, 540));
level.aud.irongate playloopsound("loop_iron_gate");
level.aud.irongate2 = Spawn( "script_origin", (1401, -4909, 542));
level.aud.irongate2 playloopsound("loop_iron_gate");
DAMB_start_preset_at_point("pybk_sstorm_flare", (232, -3823, 484), "sandstorm_flare", 1800, 1.0);
DAMB_start_preset_at_point("pybk_sstorm_flare", (1696, -11160, -20), "sandstorm_flare2", 900, 1.0);
}
aud_create_level_envelop_arrays()
{
}
aud_add_note_track_data()
{
anim.notetracks[ "aud_primevo_payback_pri_targetbuilding" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_mct_dragourfeet" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_wrb_insane" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_wrb_volk" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_wrb_paris" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_wrb_wait" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_mct_goingtodonow" ] = ::aud_primevo;
anim.notetracks[ "aud_primevo_payback_pri_softenhim" ] = ::aud_primevo;
anim.notetracks[ "aud_warrabe_shutup" ] = ::aud_warrabe_shutup;
}
aud_precache_presets()
{
MM_precache_preset("mix_intro_mute");
MM_precache_preset("mix_payback_global");
MM_precache_preset("mix_hl_scripted");
MM_precache_preset("mix_intro");
MM_precache_preset("mix_intro_incar");
MM_precache_preset("mix_intro_chopperby");
MM_precache_preset("mix_intro_gatecrash");
MM_precache_preset("mix_start_compound");
MM_precache_preset("mix_compound_outer");
MM_precache_preset("mix_chopper_gunner");
MM_precache_preset("mix_chopper_explosion");
MM_precache_preset("mix_breach_mute_vo");
MM_precache_preset("mix_prebreach");
MM_precache_preset("mix_breach");
MM_precache_preset("mix_int_interrogation");
MM_precache_preset("mix_interrogation");
MM_precache_preset("mix_interrogate_mask");
MM_precache_preset("mix_beach");
MM_precache_preset("mix_ambush_music");
MM_precache_preset("mix_ambush_ambemi");
MM_precache_preset("mix_ambush_veh");
MM_precache_preset("mix_ambush_chopper");
MM_precache_preset("mix_ambush_mayhem");
MM_precache_preset("mix_ambush_kill_vo");
MM_precache_preset("mix_chase");
MM_precache_preset("mix_constr_ext");
MM_precache_preset("mix_construction_wallfall");
MM_precache_preset("mix_constr_int");
MM_precache_preset("mix_construction_roof");
MM_precache_preset("mix_chopper_crash");
MM_precache_preset("mix_chopper_static");
MM_precache_preset("mix_construction_rappel");
MM_precache_preset("mix_construction_crash");
MM_precache_preset("mix_construction_chopper_debris");
MM_precache_preset("mix_sandstorm");
MM_precache_preset("mix_sandstorm_market_tear");
MM_precache_preset("mix_sandstorm_watertower_fall");
MM_precache_preset("mix_rescue");
MM_precache_preset("mix_escape");
MM_precache_preset("mix_escape_jeepenter");
MM_precache_preset("mix_escape_jeep");
MM_precache_preset("mix_pybk_outro");
MM_precache_preset("kill_vo_mix");
}
aud_register_handlers()
{
aud_register_msg_handler(::payback_aud_msg_handler);
aud_register_msg_handler(::music_msg_handler);
}
payback_aud_msg_handler(msg, args)
{
msg_handled = true;
switch(msg)
{
case "default":
{
thread intro_mute();
aud_start_compound();
}
break;
case "start_compound":
{
aud_start_compound();
}
break;
case "s1_outer_compound":
{
AZM_start_zone("zone_exterior_compound");
music_cue("mus_intro_trunc");
thread compound_update();
}
break;
case "s1_main_compound":
{
AZM_start_zone("zone_exterior_compound");
}
break;
case "s1_interrogation":
{
AZM_start_zone("zone_interior_compound");
level.aud.do_stop_ambush_music = false;
}
break;
case "s2_city":
{
level.aud.do_stop_ambush_music = false;
AZM_start_zone("zone_exterior_beach");
music_cue("mus_beach");
}
break;
case "s2_postambush":
{
AZM_start_zone("zone_exterior_city");
thread streets_update();
music_cue("mus_ambush");
level.aud.do_stop_ambush_music = false;
}
break;
case "s2_construction":
{
AZM_start_zone("zone_exterior_construction");
level.aud.do_stop_ambush_music = false;
}
break;
case "s2_rappel":
{
wait(0.1);
AZM_start_zone("zone_interior_construction");
MUS_play("pybk_mx_construction_r");
level.aud.do_stop_ambush_music = false;
}
break;
case "s2_sandstorm":
{
music_cue("mus_sandstorm");
level.aud.do_stop_ambush_music = false;
}
break;
case "s3_rescue":
{
AZM_start_zone("zone_exterior_crashsite");
level.aud.do_stop_ambush_music = false;
}
break;
case "s3_escape":
{
AZM_start_zone("zone_exterior_crashsite");
level.aud.do_stop_ambush_music = false;
thread nikolai_music();
}
break;
case "s3_exfil":
{
level.aud.do_stop_ambush_music = false;
}
break;
case "enter_compound":
{
zone_from = args;
}
break;
case "exit_compound":
{
zone_to = args;
}
break;
case "trigger_city_exterior":
{
}
break;
case "trigger_city_interior":
{
}
break;
case "trigger_compound_exterior":
{
}
break;
case "trigger_compound_interior":
{
}
break;
case "trigger_construction_exterior":
{
AZM_start_zone("zone_exterior_construction");
}
break;
case "trigger_construction_interior":
{
AZM_start_zone("zone_interior_construction");
}
break;
case "trigger_sandstorm_exterior":
{
}
break;
case "trigger_sandstorm_interior":
{
}
break;
case "enter_city":
{
zone_from = args;
}
break;
case "exit_city":
{
zone_to = args;
}
break;
case "enter_construction":
{
zone_from = args;
}
break;
case "exit_construction":
{
zone_to = args;
}
break;
case "enter_sandstorm":
{
zone_from = args;
}
break;
case "exit_sandstorm":
{
zone_to = args;
}
break;
case "intro_black_begin":
{
thread intro_music_start();
}
break;
case "player_slamzoom_prime":
{
level.aud.prime1 = Spawn( "script_origin",(0, 0, 0));
level.aud.prime1 thread aud_prime_stream("intro_jeep_player");
}
break;
case "player_slamzoom":
{
assert(IsDefined(level.aud.prime1));
wait(0.05);
thread intro_unmute();
level.player playSound("player_slamzoom");
thread MM_add_submix_oneshot("mix_intro_incar",0.25,8,0.25);
level.aud.prime1 PlaySound("intro_jeep_player");
thread delete_on_sounddone(level.aud.prime1);
}
break;
case "intro_hummer_ride":
{
music_cue("mus_intro");
}
break;
case "intro_civies_run_by":
{
thread intro_play_walla(args);
}
break;
case "s1_chopper_by":
{
thread intro_chopper_flyby();
}
break;
case "start_lfe_loop":
{
}
break;
case "s1_chopper_missiles":
{
thread intro_chopper_missile();
}
break;
case "intro_rockets_hit":
{
play_sound_in_space("barrel_mtl_explode", (-1555, 1516, 235));
play_sound_in_space("pybk_chopper_missile_hit", (-1555, 1516, 235));
wait (0.5);
play_sound_in_space("barrel_mtl_explode", (-1555, 1516, 235));
play_sound_in_space("pybk_chopper_missile_hit", (-1555, 1516, 235));
}
break;
case "missile_fired":
{
}
break;
case "aud_gatecrash_mix":
{
thread intro_gatecrash_mix();
thread compound_update();
AZM_start_zone("zone_exterior_compound");
}
break;
case "s1_gate_crash":
{
thread attack_siren();
}
break;
case "postgate_shot_01":
{
music_cue("mus_intro_trunc");
level.player playSound("pybk_pri_shotsweet");
}
break;
case "postgate_shot_02":
{
level.price playSound("pybk_pri_shotsweet");
}
break;
case "postgate_shot_03":
{
level.player playSound("pybk_pri_shotsweet");
}
break;
case "mortar_fire":
{
location = args;
thread play_sound_in_space( "mortar_fire", location );
}
break;
case "mortar_incoming":
{
location = args;
location = location + ( 0, 0, 96 );
thread aud_mortar_incoming(location);
}
break;
case "mortar_impact_dirt":
{
location = args;
location = location + ( 0, 0, 48 );
thread aud_mortar_impact_dirt(location);
thread set_mortar_mix(location);
}
break;
case "mortar_impact_water":
{
location = args;
location = location + ( 0, 0, 48 );
thread aud_mortar_impact_water(location);
}
break;
case "player_chopper_enable":
{
aud_player_chopper_enable();
}
break;
case "player_chopper_disable":
{
aud_player_chopper_disable();
wait (0.5);
AZM_start_zone("zone_exterior_compound");
}
break;
case "player_chopper_aborted":
{
wait (0.5);
aud_player_chopper_aborted();
wait (0.5);
AZM_start_zone("zone_exterior_compound");
}
break;
case "start_compound_music":
{
music_cue("mus_compound");
}
break;
case "compound_chopperby":
{
thread compound_chopper_flyby();
}
break;
case "soap_over_balcony":
{
ai = args;
thread aud_soap_over_balcony(ai);
}
break;
case "pre_breach":
{
thread MM_add_submix_oneshot("mix_prebreach", 0.5, 2.5, 0.5);
thread detpack_sweetener();
}
break;
case "breach_start":
{
thread breach_audio();
thread play_enemy_array_bodyfall_breach();
level.player playsound("db_sub_drop_slo_01");
level.player playsound("db_impact_hit_01");
}
break;
case "breach_end":
{
flag_set ("aud_door_slowmo_exit");
}
break;
case "gasmask_on_player":
{
aud_gasmask_on_player();
}
break;
case "mix_interrogation":
{
interrogation_mix();
thread box_tumble();
}
break;
case "gasmask_off_player":
{
aud_gasmask_off_player();
}
break;
case "gas_can_popped":
{
loc = Spawn("script_origin", (3808,4608,448));
loc2 = (4032,4784,418);
wait(0.8);
loc playsound ("pybk_gas_can", "sounddone");
loc MoveTo(loc2, 0.5);
loc waittill("sounddone");
loc delete();
}
break;
case "city_pre_ambush":
{
thread turn_down_mix_pre_shot();
}
break;
case "play_rpg_explode":
{
thread play_rpg_explode(args);
}
break;
case "start_rpg_listener":
{
thread rpg_listener();
}
break;
case "city_ambush_01_sniper":
{
sniper_position = args;
thread play_sound_in_space( "pybk_weap_sniper_fire_3d", sniper_position );
thread MM_add_submix_oneshot("mix_ambush_kill_vo", 0.05, 3, 1);
MM_add_submix("mix_ambush_ambemi", 0.05);
MM_add_submix("mix_ambush_veh", 0.05);
thread MM_add_submix_oneshot("mix_ambush_music", 0.25, 4, 0.25);
wait(0.5);
MUS_stop(0.1);
MUS_play("pybk_mx_ambushhit");
wait(1.5);
thread play_sound_in_space("pybk_ambush_debris", (2736, 2160, 560));
}
break;
case "city_ambush_02_bullet":
{
unfortunate_one = args;
unfortunate_one thread play_sound_on_tag( "bullet_large_flesh", "j_head" );
}
break;
case "city_ambush_03_chopper":
{
MM_clear_submix("mix_ambush_veh", 5);
level.chopper ScalePitch(1.0, 5.0);
}
break;
case "city_ambush_04_mayhem":
{
MM_clear_submix("mix_ambush_ambemi", 3);
thread play_sound_in_space( "pybk_ambush_left", (2608,2112,600) );
thread play_sound_in_space( "pybk_ambush_right", (2704,2112,600) );
wait(0.5);
music_cue("mus_ambush");
level.aud.do_stop_ambush_music = true;
level.chopper PlaySound("ambush_chopper_away");
}
break;
case "city_car_roll":
{
thread play_roll_car_loop(args);
}
break;
case "city_car_explosion":
{
car = args;
car playSound("car_explode");
}
break;
case "siren_wail_1":
{
}
break;
case "siren_wail_2":
{
}
break;
case "stop_ambush_music":
{
if(level.aud.do_stop_ambush_music)
{
level.aud.do_stop_ambush_music = false;
MUS_stop(9);
}
}
break;
case "wall_collapse":
{
wall_location = args;
thread pybk_wallfall(wall_location);
}
break;
case "scaffolding_collapse":
{
thread play_sound_in_space("shot_wood_by_3d", ( -608, 176, 992));
}
break;
case "studwall_collapse":
{
play_sound_in_space( "pybk_studs_and_barrels", args + (0,0,64) );
}
break;
case "aud_crate_falls":
{
thread aud_crate_falls();
}
break;
case "chopper_prime":
{
thread chopper_hit_prime();
}
break;
case "chopper_play_static":
{
thread chopper_play_static();
}
break;
case "chopper_hit_by_rpg":
{
thread chopper_crash_logic();
}
break;
case "chopper_crash":
{
}
break;
case "rappel_npc":
{
npc = args;
thread aud_prime_and_play("pybk_rappel_npc", 1.3, npc.origin);
}
break;
case "rappel_player":
{
level.chopper_audio ScalePitch( 0.70710678, 15.0 );
aud_rappel_player();
}
break;
case "sandstorm_start":
{
thread choose_random_zone_and_filter();
}
break;
case "sandstorm_light":
{
}
break;
case "sandstorm_medium":
{
AZM_start_zone("zone_exterior_city_sandstorm_light");
aud_send_msg("sandstorm_transition_v01");
}
break;
case "sandstorm_hard":
{
}
break;
case "sandstorm_blackout":
{
}
break;
case "sandstorm_extreme":
{
}
break;
case "sandstorm_transition_v01":
{
thread construction_storm_sweeten();
level.player playSound("pybk_sandstorm_wave_v01");
}
break;
case "sandstorm_transition_v02":
{
flag_set("constr_sand_sweeten_done");
level.player playSound("pybk_sandstorm_wave_v02");
}
break;
case "sandstorm_aftermath":
{
AZM_start_zone("zone_exterior_city_sandstorm_light");
}
break;
case "sandstorm_none":
{
AZM_start_zone("zone_exterior_city");
}
break;
case "construction_topfloor":
{
}
break;
case "sandstorm_market_tear":
{
thread play_market_stall(args);
}
break;
case "sandstorm_watertower_fall":
{
watertower = args;
thread MM_add_submix_oneshot("mix_sandstorm_watertower_fall", 2, 4, 1.25);
watertower play_sound_in_space("pybk_watertower_fall", (-475, -4036, 660));
}
break;
case "sandstorm_shanty_enter":
{
if (level.aud.bStormStarted == false)
{
AZM_start_zone("zone_interior_sandstorm");
}
}
break;
case "sandstorm_shanty_exit":
{
}
break;
case "flare_audio_start":
{
flarespot = args;
level.aud.flare = Spawn( "script_origin", flarespot);
level.aud.flare PlaySound("road_flare_start", "sounddone");
thread delete_on_sounddone(level.aud.flare);
DAMB_start_preset_at_point("pybk_sstorm_flare", flarespot, "sandstorm_flare", 900, 1.0);
}
break;
case "roof_tear":
{
if (level.aud.bStormStarted == false)
{
level.aud.bStormStarted = true;
wait(3);
}
}
break;
case "payback_scaffolding_collapse":
{
thread play_scaffolding_collapse(args);
}
break;
case "mus_rescue_start_nikolai_music":
{
}
break;
case "mus_rescue_music_day_saved":
{
}
break;
case "set_pre_rescue_mix":
{
level.player SetChannelVolume("weapon_mid", 0, 0);
}
break;
case "begin_npc_weapon_audio_hack":
{
allyarray = GetAIArray("allies");
axisarray = GetAIArray("axis");
for (i = 0; i < allyarray.size; i++)
{
thread ally_fire(allyarray[i]);
}
for (i = 0; i < axisarray.size; i++)
{
thread axis_fire(axisarray[i]);
}
}
break;
case "nikolai_pickup":
{
thread MM_add_submix_oneshot("mix_nikolai_pickup",0.3,5,1);
thread aud_nikolai_pickup();
}
break;
case "soap_hood_slide":
{
thread aud_play_soap_hood_slide(args);
}
break;
case "outro_slide_start":
{
thread MM_add_submix_oneshot("mix_rescue_slide",1.25,5.5,1);
thread aud_downhill_slide();
}
break;
case "outro_player_in_jeep":
{
AZM_start_zone("zone_exterior_escjeep");
thread aud_jeeps_depart();
thread MM_add_submix_oneshot("mix_escape_jeepenter",0.15,1.5,0.15);
}
break;
case "magic_bullet_fire":
{
thread fire_at_location_if_allowed(args);
}
break;
default:
{
aud_print("payback_aud_msg_handler() unhandled message: " + msg);
msg_handled = false;
}
break;
}
return msg_handled;
}
music_cue(msg, args)
{
thread music_msg_handler(msg, args);
}
music_msg_handler(msg, args)
{
msg_handled = true;
if (GetSubStr(msg, 0, 4) != "mus_")
return false;
level notify("kill_other_music");
level endon("kill_other_music");
switch(msg)
{
case "mus_intro":
{
wait (1.9333);
}
break;
case "mus_intro_trunc":
{
MUS_play("pybk_mx_intro_compound");
}
break;
case "mus_compound":
{
if(level.aud.do_start_compound_music)
{
level.aud.do_stop_ambush_music = false;
MUS_play("pybk_mx_compound");
}
}
break;
case "mus_door_breached":
{
MUS_stop(0.25);
}
break;
case "mus_beach":
{
thread start_beach_music();
}
break;
case "mus_beach_vol_up":
{
}
break;
case "mus_ambush":
{
MUS_play("pybk_mx_ambush");
}
break;
case "mus_construction":
{
MUS_play("pybk_mx_construction");
}
break;
case "mus_start_chopper_stinger":
{
MUS_stop(0.5);
}
break;
case "mus_rappel":
{
MUS_stop(10);
}
break;
case "mus_sandstorm":
{
MUS_stop(10);
}
break;
case "mus_nikolai":
{
thread nikolai_music();
}
break;
case "mus_rescue_start_finale_music":
{
thread aud_mus_rescue_start_finale_music();
}
break;
default:
{
aud_print("music_msg_handler() unhandled message: " + msg);
msg_handled = false;
}
break;
}
return msg_handled;
}
intro_mute()
{
MM_add_submix("mix_intro_mute", 0.0);
}
intro_unmute()
{
MM_clear_submix("mix_intro_mute", 1.0);
}
intro_music_start()
{
wait(0.05);
waittillframeend;
level.aud.prime2 = Spawn( "script_origin",(0, 0, 0));
assert(IsDefined(level.aud.prime2));
level.aud.prime2 thread aud_prime_stream("pybk_mx_intro");
wait(1.25);
isprimed = level.aud.prime2 aud_is_stream_primed("pybk_mx_intro");
assert(isprimed);
wait(1);
level.aud.prime2 PlaySound("pybk_mx_intro", "sounddone");
thread delete_on_sounddone(level.aud.prime2);
}
intro_play_walla(enemy)
{
wait (2);
enemy PlaySound("shot_walla_african_v01");
}
intro_chopper_flyby()
{
thread MM_add_submix_oneshot("mix_intro_chopperby",3.00,6.00,6.00);
level.chopper playSound("intro_heli_flyby");
}
rocket_lfe()
{
wait(0.1);
lfe = Spawn("script_origin", level.player.origin);
lfe PlaySound("pybk_intro_lfe", "sounddone");
lfe waittill("sounddone");
lfe Delete();
}
intro_chopper_missile()
{
level.chopper playSound("pybk_chopper_missile");
}
intro_gatecrash_mix()
{
wait(8);
thread MM_add_submix_oneshot("mix_intro_gatecrash",0.25,2,0.25);
}
hummer_alpha_acceleration()
{
wait (6.35);
level.price PlaySound("jeep_player_shift");
wait (10.832);
level.aud.jeepsound = Spawn( "script_origin",(0, 0, 0));
level.aud.jeepsound PlaySound("intro_jeep_player_end","sounddone");
thread delete_on_sounddone(level.aud.jeepsound);
level.aud.jeepskid = Spawn( "script_origin",(0, 0, 0));
level.aud.jeepskid PlaySound("jeep_player_skid","sounddone");
thread delete_on_sounddone(level.aud.jeepskid);
wait (0.333);
level.price PlaySound("jeep_player_shift");
wait (8);
thread aud_prime_and_play("pybk_gate_crash_02", 3.25, level.player.origin);
wait (3);
level.player PlaySound("jeep_player_skid_end");
looping_sweetener = Spawn("script_origin", level.player.origin);
looping_sweetener PlaySound("pybk_chopper_down_lfe", "sounddone");
looping_sweetener waittill("sounddone");
looping_sweetener Delete();
level.hummer_alpha_audio delete();
level.hummer_alpha_audio_idle delete();
}
hummer_bravo_acceleration()
{
AssertEx(IsDefined(self), "payback_aud::hummer_bravo_acceleration() - must call on an entity");
level.intro_time_begin = GetTime();
volume_min = 0.2511;
volume_max = 0.5011;
pitch_max = 1.2968395546510096;
pitch_min = 1.0000000000000000;
time_accel = 4.0;
time_decel = 0.5;
wait(0.25);
level.hummer_bravo_audio PlayLoopSound("jeep_throttle");
level.hummer_bravo_audio_idle	PlayLoopSound("jeep_idle");
wait (0.05);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_min);
level.hummer_bravo_audio_idle	SetPitch(pitch_min);
level.hummer_bravo_audio SetVolume(0.001);
level.hummer_bravo_audio_idle	SetVolume(0.001);
wait (0.05);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio_idle	SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio SetVolume(volume_max, time_accel);
level.hummer_bravo_audio_idle	SetVolume(volume_min, time_accel);
wait(time_accel);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio_idle	SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio SetVolume(volume_min, 0.125);
level.hummer_bravo_audio_idle	SetVolume(volume_max, 0.25);
wait(time_decel);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio_idle	SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio SetVolume(volume_max, 0.25);
level.hummer_bravo_audio_idle	SetVolume(volume_min, 0.125);
wait(time_accel);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio_idle	SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio SetVolume(volume_min, 0.125);
level.hummer_bravo_audio_idle	SetVolume(volume_max, 0.25);
wait(time_decel);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio_idle	SetPitch(pitch_max, time_accel);
level.hummer_bravo_audio SetVolume(volume_max, 0.25);
level.hummer_bravo_audio_idle	SetVolume(volume_min, 0.125);
level.bravo_hummer thread aud_prime_stream("jeep_splash_shore");
wait(2.05);
level.bravo_hummer PlaySound("jeep_splash_shore");
wait(1.95);
waittillframeend;
level.hummer_bravo_audio SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio_idle	SetPitch(pitch_min, time_decel);
level.hummer_bravo_audio SetVolume(volume_min, 0.125);
level.hummer_bravo_audio_idle	SetVolume(volume_max, 0.25);
wait(time_decel);
waittillframeend;
time_jump = 2.0;
pitch_jump = 1.4142135623730951;
level.hummer_bravo_audio SetPitch(pitch_jump, time_jump);
level.hummer_bravo_audio_idle	SetPitch(pitch_jump, time_jump);
level.hummer_bravo_audio SetVolume(volume_max, 0.25);
level.hummer_bravo_audio_idle	SetVolume(volume_min, 0.125);
wait(time_jump);
waittillframeend;
time_air = 1.0;
pitch_air = 1.0;
level.hummer_bravo_audio SetPitch(pitch_air, time_air);
level.hummer_bravo_audio_idle	SetPitch(pitch_air, time_air);
level.hummer_bravo_audio SetVolume(volume_min, 0.125);
level.hummer_bravo_audio_idle	SetVolume(volume_max, 0.25);
wait(time_air);
waittillframeend;
thread aud_play_linked_sound("jeep_skid_v01", level.hummer_bravo_audio, "oneshot");
pitch_land = 0.7071067811865475;
time_land = 0.1;
level.hummer_bravo_audio SetPitch(pitch_land, time_land);
level.hummer_bravo_audio_idle	SetPitch(pitch_land, time_land);
level.hummer_bravo_audio SetVolume(volume_min, 0.125);
level.hummer_bravo_audio_idle	SetVolume(volume_max, 0.25);
wait(time_land);
waittillframeend;
time_crash = 10.75;
pitch_crash = pitch_jump;
level.hummer_bravo_audio SetPitch(pitch_crash, time_crash);
level.hummer_bravo_audio_idle	SetPitch(pitch_crash, time_crash);
level.hummer_bravo_audio SetVolume(volume_max, 0.25);
level.hummer_bravo_audio_idle	SetVolume(volume_min, 0.125);
wait(time_crash);
waittillframeend;
level.bravo_hummer PlaySound("pybk_gate_crash_01");
crash_to_idle_time = 3.0;
level.hummer_bravo_audio ScalePitch(0.5, crash_to_idle_time);
level.hummer_bravo_audio_idle	ScalePitch(0.5, crash_to_idle_time);
level.hummer_bravo_audio ScaleVolume(0.01, crash_to_idle_time);
level.hummer_bravo_audio_idle	ScaleVolume(0.0630, crash_to_idle_time);
wait(crash_to_idle_time);
waittillframeend;
level.hummer_bravo_audio StopLoopSound();
level.hummer_bravo_audio_idle	StopLoopSound();
wait(0.05);
waittillframeend;
level.hummer_bravo_audio Delete();
level.hummer_bravo_audio_idle	Delete();
}
initialize_intro_hummers()
{
AssertEx(IsDefined(level.alpha_hummer), "payback_aud::initialize_intro_hummers() - level.alpha_hummer was not defined");
AssertEx(IsDefined(level.bravo_hummer), "payback_aud::initialize_intro_hummers() - level.bravo_hummer was not defined");
if (IsDefined(level.alpha_hummer))
level.alpha_hummer StopLoopSound();
if (IsDefined(level.bravo_hummer))
level.bravo_hummer StopLoopSound();
level.hummer_alpha_audio = Spawn( "script_origin", level.player.origin );
level.hummer_alpha_audio LinkTo( level.player );
level.hummer_alpha_audio_idle = Spawn( "script_origin", level.player.origin );
level.hummer_alpha_audio_idle LinkTo( level.player );
offset = ( 72, 0, 48 );
level.hummer_bravo_audio = Spawn( "script_origin", level.bravo_hummer.origin );
level.hummer_bravo_audio LinkTo( level.bravo_hummer, "tag_origin", offset, ( 0, 0, 0 ) );
level.hummer_bravo_audio_idle = Spawn( "script_origin", level.bravo_hummer.origin );
level.hummer_bravo_audio_idle LinkTo( level.bravo_hummer, "tag_origin", offset, ( 0, 0, 0 ) );
level.hummer_alpha_audio thread hummer_alpha_acceleration();
level.hummer_bravo_audio thread hummer_bravo_acceleration();
}
compound_update()
{
wait(8);
loc1 = (1296, 4544, 427);
aliases = ["payback_mrc3_mortarteams", "payback_mrc3_destroy", "payback_mrc3_mainhouse", "payback_mrc3_gunemplacements", "payback_mrc3_reinforcements", "payback_mrc1_alltroops"];
wait_between_megaphone = 2.5;
random_wait_between_megaphone = 25;
wait_between_filter_update = 1;
megaphone_ctr = 0;
while(!flag("upper_compound_upper_buildings_hotzone"))
{
if (megaphone_ctr < 6)
{
level thread play_sound_in_space(aliases[megaphone_ctr], loc1);
megaphone_ctr++;
}
for (i = 0; i < wait_between_megaphone; i += wait_between_filter_update)
{
update_whiz_filter();
wait(wait_between_filter_update);
}
for (i = 0; i < RandomInt(random_wait_between_megaphone); i += wait_between_filter_update)
{
update_whiz_filter();
wait(wait_between_filter_update);
}
}
level.player SetEqLerp(0, 1);
}
update_whiz_filter()
{
level.player seteq("bulletwhizby", 1, 0, "bell", 3, 2000 + RandomInt(5000), 4.5);
level.player seteq("bulletimpact", 1, 0, "bell", 2, 1500 + RandomInt(3000), 4.5);
level.player SetEqLerp(1, 1);
}
aud_mortar_incoming(location)
{
org = Spawn( "script_origin", location );
org playSound("mortar_incoming", location);
wait(3);
waittillframeend;
org delete();
}
aud_mortar_impact_dirt(location)
{
org = Spawn( "script_origin", location );
org playSound("mortar_explosion_dirt", location);
wait(8);
waittillframeend;
org delete();
}
aud_mortar_impact_water(location)
{
org = Spawn( "script_origin", location );
org playSound("mortar_explosion_water", location);
wait(8);
waittillframeend;
org delete();
}
set_mortar_mix(location)
{
max_dist = 800;
dist = Distance(level.player.origin, location);
if (dist < max_dist)
{
scale = clamp(dist / max_dist, 0.0, 1.0);
MM_add_submix_blend("mix_compound_mortar", "mix_compound_outer", "mortar_blend", 0, 0.5);
MM_set_submix_blend_value("mortar_blend", scale, 0.5);
wait(0.6);
MM_set_submix_blend_value("mortar_blend", 1, 1);
}
}
attack_siren()
{
wait ( 3 );
siren = Spawn( "script_origin",(64, 5632, 900));
siren playsound("pybk_attack_siren");
wait ( 30 );
siren delete();
}
aud_player_chopper_enable()
{
wait(1.5);
level.player playSound("player_chopper_enter");
level.aud.chopperzone = AZM_get_current_zone();
AZM_start_zone("zone_interior_chopper");
level.aud.chopper_enabled = true;
cur_weapon = level.player GetCurrentWeapon();
if ( cur_weapon == "remote_chopper_gunner" || cur_weapon == level.chopper_weapon )
{
wait(0.05);
wait(0.05);
waittillframeend;
assert(!level._audio.filter_disabled);
if ( !IsDefined( level.chopper_interior_sound ) )
{
level.chopper_interior_sound = spawn( "script_origin", level.player.origin );
level.chopper_interior_sound LinkTo( level.player );
aud_fade_sound_in(level.chopper_interior_sound, "pybk_chopper_interior", 1.0, 1.0, true);
}
MM_add_submix("mix_chopper_gunner");
thread aud_player_chopper_handle_pings();
}
}
aud_player_chopper_disable()
{
wait(0.10);
level.player playSound("player_slamzoom");
if (isDefined(level.chopper_interior_sound))
{
aud_fade_out_and_delete( level.chopper_interior_sound, 0.5);
}
if (isDefined(level.aud.chopperzone))
{
AZM_start_zone(level.aud.chopperzone);
}
DAMB_stop_preset("pybk_chopperpings", 0.1);
wait(0.5);
waittillframeend;
if (isDefined(level.chopper_interior_sound))
{
level.chopper_interior_sound delete();
}
MM_clear_submix("mix_chopper_gunner");
level.aud.chopper_enabled = false;
}
aud_player_chopper_aborted()
{
wait(0.10);
if (isDefined(level.chopper_interior_sound))
{
aud_fade_out_and_delete( level.chopper_interior_sound, 0.5);
}
if (isDefined(level.aud.chopperzone))
{
AZM_start_zone(level.aud.chopperzone);
}
DAMB_stop_preset("pybk_chopperpings", 0.1);
wait(0.5);
waittillframeend;
if (isDefined(level.chopper_interior_sound))
{
level.chopper_interior_sound delete();
}
MM_clear_submix("mix_chopper_gunner");
level.aud.chopper_enabled = false;
}
aud_player_chopper_handle_pings()
{
while ( level.aud.chopper_enabled )
{
axis = GetAIArray( "axis" );
if (axis.size < 5)
{
if (isDefined(level.aud.chopperzone))
{
AZM_start_zone(level.aud.chopperzone);
}
DAMB_stop_preset("pybk_chopperpings", 0.5);
}
wait(2);
}
}
aud_start_compound()
{
}
compound_chopper_flyby()
{
wait(0.3);
level.chopper playSound("comp_heli_flyby");
}
aud_soap_over_balcony(ai)
{
wait (1.25);
ai thread aud_prime_stream("pybk_deathfall");
wait (1.5);
ai playSound("pybk_deathfall");
}
aud_ignore_slowmo()
{
SoundSetTimeScaleFactor( "norestrict2d", 0 );
SoundSetTimeScaleFactor( "music", 0 );
SoundSetTimeScaleFactor( "local", 0.25 );
SoundSetTimeScaleFactor( "local3", 0.25 );
SoundSetTimeScaleFactor( "weapon", 0.15 );
SoundSetTimeScaleFactor( "grondo2d", 0 );
SoundSetTimeScaleFactor( "bulletimpact", 0 );
SoundSetTimeScaleFactor( "bulletflesh1", 0 );
SoundSetTimeScaleFactor( "bulletflesh2", 0 );
SoundSetTimeScaleFactor( "bulletwhizby", 0 );
}
detpack_sweetener()
{
detpack = spawn("script_origin", level.player.origin);
wait(0.6);
detpack playsound("detpack_plant_arming", "sounddone");
thread delete_on_sounddone(detpack);
}
breach_audio()
{
thread aud_start_slow_mo_gunshot_callback(::aud_play_pybk_door_breach_gunshot, ::aud_play_pybk_door_breach_impact);
thread MM_add_submix ("mix_breach");
thread AZM_start_zone("zone_breach_slowmo", 0.05);
hi_ent = spawn("script_origin", level.player.origin);
lo_ent = spawn("script_origin", level.player.origin);
hi_ent playloopsound("surreal_hi_lp");
lo_ent playloopsound("surreal_lo_lp");
flag_wait("aud_door_slowmo_exit");
thread aud_stop_slow_mo_gunshot_callback();
thread interrogation_music_start();
thread MM_clear_submix("mix_breach");
hi_ent playsound("db_fast_forward");
wait(0.5);
thread AZM_start_zone("zone_interrogation_room");
wait(0.05);
hi_ent ScaleVolume(0.0, 0.1);
wait(0.05);
lo_ent ScaleVolume(0.0, 0.1);
wait(0.05);
lo_ent delete();
wait(0.2);
hi_ent delete();
}
box_tumble()
{
wait(4);
thread play_sound_in_space("evt_boxes_tumble02", (3856,4464,445));
thread play_sound_in_space("evt_boxes_tumble01", (3856,4560,445));
}
play_enemy_array_bodyfall_breach()
{
enemies = getaiarray( "axis" );
foreach ( enemy in enemies )
{
if (enemy.model != "body_warlord")
{
thread play_enemy_bodyfall_breach(enemy);
}
}
}
play_enemy_bodyfall_breach(enemy)
{
while (!flag("aud_door_slowmo_exit"))
{
enemy waittill("death");
wait(0.65);
if (flag("aud_door_slowmo_exit"))
{
wait(0.5);
if ( IsDefined(enemy) )
{
enemy PlaySound("pybk_body_breach");
}
}
else
{
if ( IsDefined(enemy) )
{
enemy PlaySound("pybk_body_slomo");
}
}
break;
}
}
interrogation_mix()
{
thread MM_add_submix_oneshot("mix_interrogation", 0.5, 40, 0.5);
}
aud_play_harb_slowmo_impact(weapontype, damage, attacker, point, type)
{
level.player playsound("slowmo_bullet_whoosh");
}
aud_play_pybk_slowmo_gunshot(weapontype)
{
switch(weapontype)
{
default:
break;
}
}
aud_play_pybk_door_breach_impact(weapontype, damage, attacker, point, type)
{
if ( !IsDefined(level.aud.last_db_time))
{
level.aud.last_db_time = 0;
}
current_time = GetTime();
if (current_time - level.aud.last_db_time > 200)
{
level.aud.last_db_time = current_time;
level.player playsound("db_bullet_whoosh");
}
}
aud_play_pybk_door_breach_gunshot(weapontype)
{
switch(weapontype)
{
default:
break;
}
}
aud_gasmask_on_player()
{
level.player playSound("pybk_mask_on_plr");
}
aud_gasmask_off_player()
{
level.player playSound("pybk_mask_off_plr");
}
interrogation_music_start()
{
MUS_play( "pybk_mx_kruger" );
}
aud_warrabe_shutup(note, _flagName)
{
thread MM_add_submix_oneshot("kill_vo_mix", 0.05, 2, 0.05);
}
start_beach_music()
{
wait (4);
MUS_play("pybk_mx_beach");
}
turn_down_mix_pre_shot()
{
wait(6);
mm_add_submix_oneshot("mix_pre_ambush", 1.5, 0.5, 0.5);
wait(0.5);
flag_set( "stop_beach_music" );
}
streets_update()
{
while(!flag("end_streets_combat"))
{
update_whiz_filter();
wait(1);
}
level.player SetEqLerp(0, 1);
}
play_roll_car_loop(ent)
{
ent2 = Spawn ("script_origin", ent.origin);
ent2 LinkTo( ent );
ent3 = Spawn ("script_origin", ent.origin);
ent3 LinkTo( ent );
thread mm_add_submix_oneshot("mix_streets_car", 0.5, 4, 0.5);
ent PlayLoopSound("pybk_car_roll_down");
wait(3.5);
ent StopLoopSound();
ent2 StopLoopSound();
wait (0.25);
ent2 delete();
ent3 delete();
}
pybk_wallfall(wall_location)
{
wall_location2 = wall_location + ( 0, 0, 96 );
level.player aud_prime_and_play_on_plr("pybk_wallfall_quad", .6);
wait(0.5);
thread MM_add_submix_oneshot("mix_construction_wallfall", 1, 3.5, 0.5);
wait(2.152);
wait(1.323);
wait(0.746);
music_cue("mus_construction");
}
construction_storm_sweeten()
{
ent = Spawn( "script_origin",(0, 0, 0));
ent ScaleVolume(0.1, 0);
wait(0.01);
ent ScaleVolume(1, 2);
ent playloopsound("pybk_construct_quad_f");
flag_wait("constr_sand_sweeten_done");
aud_fade_out_and_delete( ent, 2.0 );
thread chopper_hit_prime();
}
aud_crate_falls()
{
thread play_sound_in_space("pybk_crate_falls", ( -720, -896, 992));
thread play_sound_in_space("pybk_crate_falls_2", ( -720, -896, 992));
}
chopper_crash_logic()
{
thread MM_add_submix_oneshot("mix_construction_chopper_rpg_blast", 0.1, 0.75, 0.25);
MM_add_submix("mix_chopper_crash", 0.5);
if (isDefined(level.chopper_audio))
{
if (isDefined(level.chopper_audio._doppler) && isDefined(level.chopper_audio._doppler.enabled))
level.chopper_audio._doppler.enabled = false;
level.chopper_audio StopLoopSound();
level.chopper_audio_damaged = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged LinkTo( level.chopper_audio );
level.chopper_audio_damaged2 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged2 LinkTo( level.chopper_audio );
level.chopper_audio_damaged3 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged3 LinkTo( level.chopper_audio );
level.chopper_audio_damaged4 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged4 LinkTo( level.chopper_audio );
level.chopper_audio_damaged5 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged5 LinkTo( level.chopper_audio );
level.chopper_audio_damaged6 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged6 LinkTo( level.chopper_audio );
MUS_stop();
level.chopper_audio_damaged PlaySound("mortar_explosion_dirt");
flag_set("chopper_hit_primed_now_go");
level.chopper_audio_damaged4 PlayLoopSound("chopper_main_damaged");
level.chopper_audio_damaged PlaySound("pybk_chopper_hit");
level.chopper_audio_damaged5 thread aud_prime_stream("pybk_chopper_down2");
wait (2.8);
level.chopper_audio_damaged5 PlaySound("pybk_chopper_down2");
level.chopper_audio_damaged6 ScaleVolume (0.1, 0);
wait (4);
level.chopper_audio_damaged6 PlayLoopSound("pybk_chopper_down_hold");
wait(0.1);
level.chopper_audio_damaged6 ScaleVolume (1.0, 3.0);
wait(7.5);
level.chopper_audio_damaged6 ScaleVolume (0, 2.0);
wait (2.1);
level.chopper_audio_damaged6 delete();
}
else
{
AssertEx(isDefined(level.chopper_audio), "level.chopper_audio must be defined before crash sequence! something went wrong.");
}
}
chopper_hit_prime()
{
level.chopper_audio_damaged3 = Spawn( "script_origin", level.chopper_audio.origin );
level.chopper_audio_damaged3 LinkTo( level.chopper_audio );
level.chopper_audio_damaged3 aud_prime_stream("pybk_chopper_down");
flag_wait("chopper_hit_primed_now_go");
level.chopper_audio_damaged3 PlaySound("pybk_chopper_down");
}
chopper_play_static()
{
cur_weapon = level.player GetCurrentWeapon();
if ( cur_weapon == "remote_chopper_gunner" || cur_weapon == level.chopper_weapon )
{
level.player playsound ("pybk_chopper_static");
thread MM_add_submix_oneshot("mix_chopper_static", 0.15, 4, 1);
}
}
chopper_down2_end()
{
wait (7);
level.chopper_audio_damaged5 ScaleVolume(0, 4);
wait (1.5);
level.chopper_audio_damaged5 delete();
}
chopper_damaged_end()
{
wait (5);
level.chopper_audio_damaged4 ScaleVolume(0, 4);
wait (1.5);
level.chopper_audio_damaged4 delete();
}
aud_rappel_player()
{
aud_send_msg("sandstorm_transition_v02");
level.chopper_audio_damaged2 PlaySound("pybk_chopper_rappel2");
level.player aud_prime_and_play_on_plr("pybk_rappel_player", .7);
wait(0.5);
MM_clear_submix("mix_chopper_crash", 0.5);
thread MM_add_submix_oneshot("mix_construction_rappel", 0.15, 3, 1.5);
thread chopper_damaged_end();
thread chopper_down2_end();
level.chopper_audio_damaged ScalePitch( 0.70710678, 3.0 );
thread delete_on_sounddone(level.chopper_audio_damaged);
level.chopper_audio_damaged thread aud_prime_stream("pybk_chopper_end");
wait (1);
level.chopper_audio_damaged playSound("pybk_chopper_end");
wait(9);
level.chopper_audio_damaged delete();
level.chopper_audio_damaged2 delete();
}
play_market_stall(ent)
{
thread MM_add_submix_oneshot("mix_sandstorm_market_tear", 1.0, 2.8, 1.0);
market_stall_sound = spawn( "script_origin", ent GetTagOrigin("J_Default3_vtx_210_") );
market_stall_sound LinkTo(ent, "J_Default3_vtx_210_", (0, 0, 0), (0, 0, 0));
market_stall_sound PlaySound("pybk_market_tear", "sounddone");
market_stall_sound waittill("sounddone");
market_stall_sound delete();
}
choose_random_zone_and_filter()
{
thread choose_random_zone();
thread choose_random_filter();
thread play_random_rumble();
}
choose_random_zone()
{
rand_min = 3;
rand_max = 7;
zones = ["zone_sandstorm_01", "zone_sandstorm_02", "zone_sandstorm_03", "zone_sandstorm_04"];
last = RandomInt(zones.size);
AZM_start_zone(zones[last]);
while (!flag("sandstorm_section_end"))
{
current = RandomInt(zones.size);
if (current == last)
{
current += 1;
if (current == zones.size)
{
current = 0;
}
}
if (RandomInt(10) < 4)
{
wait(RandomIntRange(3, 7));
if(flag("sandstorm_section_end")) { break; }
AZM_start_zone(zones[current], 3);
wait(RandomIntRange(3, 7));
if(flag("sandstorm_section_end")) { break; }
AZM_start_zone(zones[last], 3);
}
else
{
wait(RandomIntRange(rand_min, rand_max));
if(flag("sandstorm_section_end")) { break; }
wait(RandomIntRange(rand_min, rand_max));
if(flag("sandstorm_section_end")) { break; }
wait(RandomIntRange(rand_min, rand_max));
if(flag("sandstorm_section_end")) { break; }
wait(RandomIntRange(rand_min, rand_max));
if(flag("sandstorm_section_end")) { break; }
wait(RandomIntRange(rand_min, rand_max));
if(flag("sandstorm_section_end")) { break; }
AZM_start_zone(zones[current], 6);
}
last = current;
}
wait(5);
aud_clear_filter();
AZM_start_zone("zone_exterior_crashsite", 5);
}
choose_random_filter()
{
rand_min = 5;
rand_max = 15;
filters = ["filter_sandstorm_01", "filter_sandstorm_02", "filter_sandstorm_03", "filter_sandstorm_04", "filter_sandstorm_05"];
last = RandomInt(filters.size);
aud_set_filter(filters[last]);
while (!flag("sandstorm_section_end"))
{
current = RandomInt(filters.size);
if (current == last)
{
current += 1;
if (current == filters.size)
{
current = 0;
}
}
wait(RandomIntRange(rand_min, rand_max));
aud_set_filter(filters[current]);
last = current;
}
}
play_random_rumble()
{
vol_max = 0.5;
vol_min = 0.1;
fade_max = 6;
fade_min = 3;
hold_max = 2;
hold_min = 0.5;
wait_max = 15;
wait_min = 6;
while (!flag("sandstorm_section_end"))
{
ent = Spawn("script_origin", level.player.origin);
ent PlayLoopSound("pybk_sandstorm_rumble");
vol = RandomFloatRange(vol_min, vol_max + 1);
ent SetVolume(0);
wait(0.1);
fade_in = RandomFloatRange(fade_min, fade_max + 1);
ent ScaleVolume(vol, fade_in);
wait(fade_in);
wait(RandomFloatRange(hold_min, hold_max + 1));
fade_out = RandomFloatRange(fade_min, fade_max + 1);
ent ScaleVolume(0, fade_out);
wait(fade_out + 0.02);
ent StopLoopSound();
wait(0.1);
ent delete();
wait(RandomFloatRange(wait_min, wait_max + 1));
}
}
play_scaffolding_collapse(ent)
{
scaffolding_collapse_sound = spawn( "script_origin", (1167, -4717, 542) );
thread MM_add_submix_oneshot("mix_sandstorm_scaffold_collapse", 0.2, 1.7, 0.5);
level.player PlaySound("pybk_scaffolding_whip");
level.player thread aud_prime_stream("pybk_scaffolding_collapse");
wait(1);
scaffolding_collapse_sound PlaySound("pybk_scaffolding_collapse", "sounddone");
scaffolding_collapse_sound MoveTo( (1074, -4275, 550), 1.5);
scaffolding_collapse_sound waittill("sounddone");
scaffolding_collapse_sound delete();
}
nikolai_music()
{
choonz = Spawn( "script_origin",(0, 0, 0));
choonz playsound("pybk_mx_rescue_intro", "sounddone");
thread delete_on_sounddone(choonz);
wait (3.466);
MUS_play("pybk_mx_rescue");
}
aud_nikolai_pickup()
{
plr_nikolai_pickup = spawn("script_origin", level.player.origin);
plr_nikolai_pickup thread aud_prime_stream("evt_nikolai_pickup");
wait(0.65);
plr_nikolai_pickup playsound("evt_nikolai_pickup", "sounddone");
thread delete_on_sounddone(plr_nikolai_pickup);
}
damb_chopper_fire()
{
DAMB_start_preset_at_point("pybk_chopper_fire", (-224, -8160, 464), "damb_chopper_fire", 5000, 1.0);
}
ally_fire(ent_ally)
{
while(IsAlive(ent_ally))
{
ent_ally waittill("shooting");
ent_ally play_sound_on_entity("pybk_weap_m4carbine_fire_npc");
}
}
axis_fire(ent_axis)
{
while(IsAlive(ent_axis))
{
ent_axis waittill("shooting");
thread fire_at_location_if_allowed(ent_axis.origin);
}
}
fire_at_location_if_allowed(vect)
{
if (level.aud.playing_bullet_count < level.aud.max_bullets)
{
level.aud.playing_bullet_count += 1;
loc = Spawn("script_origin", vect);
loc PlaySound("pybk_weap_ak47_fire_npc", "sounddone");
loc waittill("sounddone");
loc Delete();
level.aud.playing_bullet_count -= 1;
}
}
aud_play_soap_hood_slide(ent)
{
level.soap PlaySound("soap_car_jump");
}
aud_downhill_slide()
{
plr_slide = spawn("script_origin", level.player.origin);
plr_slide playsound("evt_downhill_slide", "sounddone");
thread delete_on_sounddone(plr_slide);
}
aud_jeeps_depart()
{
jeeps_outro = spawn("script_origin", level.player.origin);
jeeps_outro playsound("outro_jeep_depart", "sounddone");
thread delete_on_sounddone(jeeps_outro);
wait(8);
thread MM_add_submix_oneshot("mix_pybk_outro",8,20,0.25);
}
aud_mus_rescue_start_finale_music()
{
wait(1);
MUS_play("pybk_mx_escape");
}
loop_chopper()
{
AssertEx(IsDefined(level.chopper), "payback_aud::loop_chopper() - level.chopper was not defined");
if (IsDefined(level.chopper))
level.chopper StopLoopSound();
if (!IsDefined(level.chopper_audio))
{
level.chopper_audio = Spawn( "script_origin", level.chopper.origin );
level.chopper_audio LinkTo( level.chopper, "tag_origin", ( 0, 0, 64 ), ( 0, 0, 0 ) );
}
else
{
level.chopper_audio Unlink();
level.chopper_audio MoveTo( level.chopper.origin, 0.05 );
level.chopper_audio LinkTo( level.chopper, "tag_flare", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}
if (!IsDefined(level.chopper_audio.initialized))
{
level.chopper_audio.initialized = true;
level.chopper_audio PlayLoopSound( "chopper_main" );
chopper_tick_time = 0.05;
while (IsDefined(level.chopper_audio))
{
level.chopper_audio tick_doppler( chopper_tick_time, 80, 0.8908987181403393, 1.2599210498948732, 1.0, 8192, 2.0, 12 );
wait(chopper_tick_time);
waittillframeend;
if (isDefined(self._doppler) && isDefined(self._doppler.enabled) && !level.chopper_audio.enabled)
break;
}
}
}
delete_chopper_audio()
{
if (!IsDefined(level.chopper))
{
if (isDefined(level.chopper_audio._doppler) && isDefined(level.chopper_audio._doppler.enabled))
level.chopper_audio._doppler.enabled = false;
waittillframeend;
delete_time = 15.0;
level.chopper_audio ScaleVolume(0.0, delete_time);
level.chopper_audio ScalePitch(0.7937005259840998, delete_time);
wait(delete_time);
waittillframeend;
level.chopper_audio Delete();
level.chopper_audio = undefined;
}
else
{
AssertEx(!IsDefined(level.chopper), "payback_aud::delete_chopper_audio() - level.chopper is still defined and should not be!");
}
}
rpg_listener()
{
axisarray = GetAIArray("axis");
for (i = 0; i < axisarray.size; i++)
{
ent = axisarray[i];
if (ent.weapon == "rpg")
{
thread rpg_gunner_listener(ent);
}
}
}
rpg_gunner_listener(ent)
{
while (IsAlive(ent))
{
ent waittill("missile_fire", projectile, weapon_name);
play_rpg_explode(projectile);
}
}
play_rpg_explode(rpg_entity)
{
rpg_entity waittill("death");
if (IsDefined(rpg_entity))
{
play_sound_in_space("pybk_rocket_explosion", rpg_entity.origin);
}
}
loop_rpg()
{
self endon("death");
self PlaySound("pybk_rpg");
rpg_tick_time = 0.05;
while (true)
{
if (IsDefined(self))
self tick_doppler( rpg_tick_time, 80, 0.7071067811865475, 1.99999999, 1.0, 6144, 3.0, 4 );
else
break;
wait(rpg_tick_time);
waittillframeend;
}
}
loop_rpg_babysitter()
{
babysitter_tick_time = 0.05;
while (true)
{
rpgs = GetEntArray( "rocket", "classname" );
rpg_count = 0;
foreach ( rpg in rpgs )
{
rpg_count++;
rpg_model = "UNDEFINED";
if (isDefined(rpg.model))
rpg_model = rpg.model;
if (isDefined(rpg.model) && rpg.model == "projectile_tag")
{
}
else
{
if (!isDefined(rpg._doppler))
rpg thread loop_rpg();
}
}
wait(babysitter_tick_time);
waittillframeend;
}
}
tick_doppler( tick_time, doppler_amount, pitch_min, pitch_max, pitch_scalar, distance_tweak, distance_scalar, debug_3d_scale )
{
self endon("death");
AssertEx( IsDefined(self), "must call tick_doppler() on an entity." );
if (isDefined(self) && !isDefined(self._doppler))
self._doppler = SpawnStruct();
if ( !IsDefined( level.snd_dopplerScript ) )
level.snd_dopplerScript = 1;
if ( !IsDefined( level.snd_dopplerScriptDebug ) )
level.snd_dopplerScriptDebug = 0;
if ( level.snd_dopplerScript == 1 )
{
AssertEx( (tick_time>0), "zero/missing required doppler parameter 1 'tick_time'" );
AssertEx( (doppler_amount>0), "zero/missing required doppler parameter 2 'doppler_amount'" );
AssertEx( (pitch_min>0), "zero/missing required doppler parameter 3 'pitch_min'" );
AssertEx( (pitch_max>0), "zero/missing required doppler parameter 4 'pitch_max'" );
AssertEx( self != level.player, "cannot apply doppler to player sounds" );
if (isDefined(self) && !isDefined(self._doppler.enabled))
self._doppler.enabled = true;
if (isDefined(self) && isDefined(self._doppler) && isDefined(self._doppler.enabled) && self._doppler.enabled)
{
if (isDefined(self) && !isDefined(self._doppler.origin_last))
self._doppler.origin_last = self.origin;
self._doppler.velocity = (self.origin - self._doppler.origin_last) / 2;
if (isDefined(self) && isDefined(self._doppler.velocity))
{
normal = VectorNormalize( level.player.origin - self.origin );
dot_source = VectorDot( self._doppler.velocity, normal );
doppler = dot_source;
if (!IsDefined(distance_tweak) || distance_tweak <= 0)
{
distance_result = 1;
}
else
{
AssertEx( (distance_scalar > 1), "doppler distance scalar must be greater than 1.0" );
distance_val = Distance(level.player.origin, self.origin);
distance_amount = distance_tweak;
distance_min = 0;
distance_max = distance_scalar;
distance_gradient = (distance_max - distance_min) / (distance_amount - (0 - distance_amount));
distance_clamped = Clamp(distance_val, (0 - distance_amount), distance_amount);
distance_result = distance_min + ((distance_clamped - (0 - distance_amount)) * distance_gradient);
doppler *= distance_result;
}
pitch_gradient = (pitch_max - pitch_min) / (doppler_amount - (0 - doppler_amount));
pitch_clamped = Clamp(doppler, (0 - doppler_amount), doppler_amount);
pitch_result = pitch_min + ((pitch_clamped - (0 - doppler_amount)) * pitch_gradient);
if (!IsDefined(pitch_scalar) || pitch_scalar <= 0)
pitch_scalar = 1;
pitch_scale = pitch_result * pitch_scalar;
if (IsDefined(pitch_scale))
{
self ScalePitch( pitch_scale, tick_time );
}
if ( level.snd_dopplerScriptDebug == 1 )
{
red = 0.75;
green = 0.25;
blue = 0.25;
alpha = 0.666666;
scale = 2;
if (IsDefined(debug_3d_scale))
scale = debug_3d_scale;
offset = ( 0, 0, 128 );
debug_string = "doppler():: " + doppler + " pitch: " + pitch_scale;
print3D( self.origin + offset, debug_string, (red,green,blue), alpha, scale );
}
if ( level.snd_dopplerScriptDebug == 2 )
{
IPrintLn( "tick_doppler():: " + doppler + " pitch: " + pitch_scale );
}
}
if (isDefined(self))
self._doppler.origin_last = self.origin;
}
}
}
MM_add_submix_oneshot(submixname, fadein, delay, fadeout)
{
MM_add_submix(submixname, fadein);
wait(delay);
MM_clear_submix(submixname, fadeout);
}
aud_primevo(note, flagName)
{
alias = GetSubStr(note, 12);
level.aud.voprime[level.aud.voprimeindex] thread aud_prime_stream(alias);
wait (0.5);
level.aud.voprimeindex += 1;
if (level.aud.voprimeindex == level.aud.voprime.size)
{
level.aud.voprimeindex = 0;
}
}

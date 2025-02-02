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
aud_set_occlusion("med_occlusion");
set_stringtable_mapname("rvn");
aud_init_globals();
aud_init_flags();
aud_launch_threads();
aud_launch_loops();
aud_create_level_envelop_arrays();
aud_add_note_track_data();
aud_precache_presets();
MM_add_submix("mix_hijack_global");
aud_register_handlers();
}
aud_init_flags()
{
flag_init("stop_kitchen");
flag_init("stop_jet_falling");
flag_init("up_prezerog_rumble");
flag_init("conf_room_explosion1_go");
flag_init("conf_room_c4_plant_go");
flag_init("conf_room_explosion2_go");
flag_init("conf_room_shots_go");
flag_init("stop_typing_sound");
flag_init("stop_news_broadcast");
flag_init("turbine_exploded");
flag_init("kill_sirens");
flag_init("makarov_slow");
flag_init("player_dead");
}
aud_init_globals()
{
level.bPreTurbReady = false;
level.bTurbStarted = false;
level.bDebateStarted = false;
level.bFailingEnginePlayed = false;
level.bJetFallingStarted = false;
level.bCrashSequenceEndPlayed = false;
level.bFighterPassed = false;
level.bTarmacShiftPlayed = false;
level.bPreExplosionPlayed = false;
level.bDebrisWait = false;
level.bPlateWait = false;
level.bMusicRevealExtPlayed = false;
level.bWingSettlePlayed = false;
level.bZGDoorwayStarted = false;
level.bTarmacDistFirePlayed = false;
level.bPostTarmacCombatTrig = false;
level.bAmbigunsPlaying = false;
level.last_death_index = 0;
}
aud_launch_threads()
{
}
aud_launch_loops()
{
}
aud_create_level_envelop_arrays()
{
}
aud_add_note_track_data()
{
}
aud_precache_presets()
{
MM_precache_preset("mix_hijack_global");
MM_precache_preset("bassline_mix");
MM_precache_preset("debate_pre_breach_mix");
MM_precache_preset("debate_checkpoint_mix");
MM_precache_preset("door_breach_mix");
MM_precache_preset("debate_post_breach_mix");
MM_precache_preset("turb_mix");
MM_precache_preset("zero_g_mix");
MM_precache_preset("zero_g_ramp_mix");
MM_precache_preset("post_zero_g_mix");
MM_precache_preset("lowerlev_mix");
MM_precache_preset("command_room_mix");
MM_precache_preset("cargo_room_mix");
MM_precache_preset("pre_crash_mix");
MM_precache_preset("pre_crash_duck_mix");
MM_precache_preset("crash_mix");
MM_precache_preset("crash_breached_mix");
MM_precache_preset("crash_death_mix");
MM_precache_preset("ground_internal_mix");
MM_precache_preset("ground_external_mix");
MM_precache_preset("end_mix");
MM_precache_preset("makarov_mix");
MM_precache_preset("end_fade_mix");
MM_precache_preset("debate_room_expl1_mix");
MM_precache_preset("zero_g_moan_mix");
MM_precache_preset("zero_g_bodyslam_mix");
MM_precache_preset("lowerlev_roll_mix");
MM_precache_preset("exterior_reveal_mix");
MM_precache_preset("combat_explosion_mix");
MM_precache_preset("kill_vo_mix");
}
aud_register_handlers()
{
aud_register_msg_handler(::hijack_aud_msg_handler);
aud_register_msg_handler(::music_msg_handler);
}
hijack_aud_msg_handler(msg, args)
{
msg_handled = true;
switch(msg)
{
case "default":
case "start_airplane":
thread intro_music();
AZM_start_zone("jet_normal_zone");
thread conf_room_shots_prime();
thread jet_rumble();
thread migs_1();
thread radio_com_intro();
break;
case "debate":
AZM_start_zone("debate_checkpoint_zone");
thread conf_room_shots_prime();
thread jet_rumble();
break;
case "start_pre_zero_g":
AZM_start_zone("jet_turb_zone");
thread pre_zero_g_rumble_cp();
level.bDebateStarted = true;
break;
case "start_lower_level_combat":
AZM_start_zone("jet_post_zero_g_zone");
MUS_play("hijk_mx_lowerdeck_shootout");
thread jet_falling_2d();
thread post_zero_g_rumble();
level.bTurbStarted = true;
level.bDebateStarted = true;
break;
case "start_crash":
AZM_start_zone("jet_command_room_zone");
MUS_play("hijk_mx_lowerdeck_shootout");
break;
case "start_tarmac":
AZM_start_zone("ground_internal_zone");
level.bCrashSequenceEndPlayed = true;
thread music_cue_postcrash_cp();
break;
case "start_tarmac_2":
AZM_start_zone("ground_external_zone");
level.bCrashSequenceEndPlayed = true;
level.bPreExplosionPlayed = true;
level.bTarmacShiftPlayed = true;
thread engine_pre_explosion();
break;
case "start_post_tarmac":
AZM_start_zone("ground_external_zone");
level.bCrashSequenceEndPlayed = true;
level.bPreExplosionPlayed = true;
break;
case "start_end_scene":
AZM_start_zone("ground_external_zone");
level.bCrashSequenceEndPlayed = true;
level.bPreExplosionPlayed = true;
level.bPostTarmacCombatTrig = true;
level.bAmbigunsPlaying = true;
MUS_play("hijk_tarmac_combat_cp");
thread ambiguns1();
thread ambiguns2();
thread ambiguns3();
thread ambiguns4();
thread ambiguns5();
thread siren_mayhem_cp();
break;
case "intro_door1_open":
intro_door1 = getEnt( "intro_door1", "targetname" );
play_sound_in_space( "hijk_door1open", intro_door1.origin );
break;
case "pres_drops_paper":
thread paper_drop();
break;
case "hijk_cart_moves":
thread hijk_cart_moves();
break;
case "keypad":
thread keypad();
break;
case "hijk_agent_espresso":
thread hijk_agent_espresso();
break;
case "start_news":
thread news_broadcast();
break;
case "debate_door_close":
thread debate_door_close();
break;
case "debate_room_start":
if (level.bDebateStarted == false)
{
AZM_start_zone("debate_pre_breach_zone");
level.bDebateStarted = true;
}
break;
case "stop_news":
flag_set("stop_news_broadcast");
thread chairs_and_props();
break;
case "start_typing":
thread typing_sound();
thread debate_bumps();
break;
case "conf_room_shots":
flag_set ("conf_room_shots_go");
flag_set ("stop_typing_sound");
thread conf_room_explosion2_prime();
thread conf_room_explosion1_prime();
thread conf_room_c4_plant_prime();
thread agent_1_dash();
thread agent_2_dash();
break;
case "conf_room_explosion1":
flag_set("conf_room_explosion1_go");
break;
case "seatbeltsign":
thread seatbeltsign();
break;
case "rumble_foley":
thread agent_1_rumble_foley();
thread agent_2_rumble_foley();
thread agent_1_back();
break;
case "conf_room_plant_c4":
flag_set("conf_room_c4_plant_go");
break;
case "conf_room_explosion2":
flag_set("conf_room_explosion2_go");
break;
case "lets_kick_ass":
thread pre_breach_music_cue();
break;
case "pre_turbulence_ready":
level.bPreTurbReady = true;
break;
case "pre_turbulence_start":
if (level.bPreTurbReady == true)
{
thread turbine_wind_e();
level.bPreTurbReady = false;
}
break;
case "turbulence_start":
if (level.bTurbStarted == false)
{
thread pre_zero_g_rumble();
level.bTurbStarted = true;
}
break;
case "hallway_lurch":
thread hallway_lurch(args);
break;
case "hijk_agent_stumblehit":
thread hijk_agent_stumblehit();
break;
case "failing_engine":
if (level.bFailingEnginePlayed == false)
{
thread failing_engine();
aud_send_msg("turbulence_start");
level.bFailingEnginePlayed = true;
}
break;
case "rumble":
thread turbulence_2d();
thread kitchen_rattle();
break;
case "rumble_boom":
thread turbulence_2d_boom();
break;
case "zero_g_doorway":
if (level.bZGDoorwayStarted == false)
{
thread turbine_wind_a();
level.bZGDoorwayStarted = true;
}
break;
case "zero_g_start":
thread zero_g_start();
flag_set("up_prezerog_rumble");
break;
case "zero_g_bodyslam1":
thread zero_g_bodyslam1();
thread props_debris1();
break;
case "zero_g_bodyslam2":
thread zero_g_bodyslam2();
thread props_debris2();
break;
case "zero_g_bodyslam3":
thread zero_g_bodyslam3();
thread props_debris3();
break;
case "zero_g_bodyslam4":
thread zero_g_bodyslam4();
thread props_debris4();
thread zero_g_end_stress();
break;
case "zero_g_debris_crash":
thread zero_g_debris_crash();
break;
case "turbine_wind_a":
thread turbine_wind_a();
break;
case "turbine_wind_b":
thread turbine_wind_b();
break;
case "turbine_wind_c":
thread turbine_wind_c();
break;
case "jet_roll_v01":
thread jet_roll_v01();
break;
case "jet_roll_v02":
thread jet_roll_v02();
thread metal_tanks();
break;
case "jet_post_zero_g":
AZM_start_zone("jet_post_zero_g_zone");
break;
case "jet_lowerlev_occlusion1":
AZM_start_zone("jet_lowerlev_zone");
break;
case "jet_lowerlev_occlusion2":
AZM_start_zone("jet_command_room_zone");
break;
case "cargo_room_zone_on":
thread cargo_room_zone_on();
break;
case "jet_lowerlev_occlusion3":
AZM_start_zone("pre_crash_zone");
break;
case "suitcase_prop_sound_impact":
{
suitcase_sound = spawn("script_origin", level.player.origin);
suitcase_sound linkto(level.player);
suitcase_sound playsound("hijk_luggage_fall", "soundone");
suitcase_sound waittill("sounddone");
suitcase_sound delete();
}
break;
case "approaching_ground":
AZM_start_zone("pre_crash_zone");
thread approaching_ground();
break;
case "pre_crash_door":
thread pre_crash_door();
break;
case "crash_sequence":
thread crash_sequence();
thread crash_props();
thread crash_badguys_bodyfalls();
break;
case "crash_explosion":
thread crash_explosion();
break;
case "crash_chunk_breaks_away":
thread crash_chunk_breaks_away();
break;
case "tower_impact":
thread tower_impact();
break;
case "crash_death":
thread crash_death();
break;
case "agent_scream":
the_agent = args;
thread crazy_guy_goes_flying(the_agent);
break;
case "crash_sequence_turbine":
thread crash_sequence_turbine();
break;
case "crash_sequence_end":
if (level.bCrashSequenceEndPlayed == false)
{
thread crash_sequence_end();
thread commander_clears_debris();
thread music_cue_postcrash();
level.bCrashSequenceEndPlayed = true;
}
break;
case "debris_shift1":
thread debris_shift1();
break;
case "debris_shift2":
thread debris_shift2();
break;
case "debris_shift3":
thread debris_shift3();
break;
case "debris_shift4":
thread debris_shift4();
break;
case "debris_shift5":
thread debris_shift5();
break;
case "debris_shift6":
thread debris_shift6();
break;
case "debris_shift7":
thread debris_shift7();
break;
case "debris_shift8":
thread debris_shift8();
break;
case "debris_shift9":
thread debris_shift9();
break;
case "debris_shift10":
thread debris_shift10();
break;
case "debris_shift11":
thread debris_shift11();
break;
case "debris_shift12":
thread debris_shift12();
break;
case "debris_shift13":
thread debris_shift13();
break;
case "debris_shift14":
thread debris_shift14();
break;
case "debris_shift15":
thread debris_shift15();
break;
case "debris_shift16":
thread debris_shift16();
break;
case "debris_shift17":
thread debris_shift17();
break;
case "plate_shift1":
thread plate_shift1();
break;
case "plate_shift2":
thread plate_shift2();
break;
case "music_reveal_exterior":
if (level.bMusicRevealExtPlayed == false)
{
thread music_reveal_exterior();
level.bMusicRevealExtPlayed = true;
}
break;
case "ground_external_start":
AZM_start_zone("ground_external_zone");
if (level.bFighterPassed == false)
{
thread fighter_jet_pass_ground();
level.bFighterPassed = true;
}
break;
case "wreck_exit_expl":
thread wreck_exit_explosion();
break;
case "wing_settle":
if (level.bWingSettlePlayed == false)
{
thread wing_settle();
level.bWingSettlePlayed = true;
}
break;
case "engine_pre_explosion":
if (level.bPreExplosionPlayed == false)
{
thread engine_pre_explosion();
level.bPreExplosionPlayed = true;
}
break;
case "engine_explosion":
thread engine_explosion();
break;
case "flare_gun":
thread flare_gun();
break;
case "random_tail_expl":
if (level.bPostTarmacCombatTrig == false)
{
thread random_tail_expl();
}
break;
case "ground_internal_start":
AZM_start_zone("ground_internal_zone");
break;
case "tarmac_shift":
if (level.bTarmacShiftPlayed == false)
{
thread tarmac_shift();
level.bTarmacShiftPlayed = true;
}
break;
case "fighter_jet_pass_ground":
thread fighter_jet_pass_ground();
break;
case "tarmac_dist_fire":
if (level.bTarmacDistFirePlayed == false)
{
thread tarmac_dist_fire();
level.bTarmacDistFirePlayed = true;
}
break;
case "tarmac_combat_music":
thread tarmac_combat_music();
break;
case "first_suv":
thread first_suv();
break;
case "player_entered_end_area":
AZM_start_zone("end_zone");
thread heli();
if (level.bAmbiGunsPlaying == false)
{
thread ambiguns1();
thread ambiguns2();
thread ambiguns3();
thread ambiguns4();
level.bAmbiGunsPlaying = true;
}
break;
case "suv_explosion":
thread suv_explosion();
break;
case "end_heli_approach":
thread end_area_chopper_begin();
break;
case "makarov_slow":
thread heli_door();
thread makarov_slow();
thread end_scene_foley1();
thread end_scene_foley2();
break;
case "commander_shot":
thread commander_shot();
break;
case "player_shot":
thread player_shot();
break;
case "blackout":
thread blackout();
break;
default:
aud_print("payback_aud_msg_handler() unhandled message: " + msg);
msg_handled = false;
break;
}
return msg_handled;
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
}
return msg_handled;
}
intro_music()
{
wait (3.0);
MUS_play("hijk_mx_levelstart");
}
jet_rumble()
{
engine_01 = Spawn( "script_origin",(-28544, 13648, 7360));
engine_01 ScaleVolume(0);
engine_01 playloopsound("hijk_jet_rumble_02");
wait(0.01);
engine_01 ScaleVolume(0.9, 6);
engine_02 = Spawn( "script_origin",(-28544, 11920, 7360));
engine_02 ScaleVolume(0.1, 0);
engine_02 playloopsound("hijk_jet_rumble_02");
wait(0.01);
engine_02 ScaleVolume(0.9, 6);
}
migs_1()
{
wait (0.5);
level.jet_1a.audio = Spawn( "script_origin", level.jet_1a.origin );
level.jet_1a.audio LinkTo( level.jet_1a );
level.jet_1a.audio playloopsound("hijk_jet_engine_intro_lfe");
level.jet_1a.audio ScaleVolume( 0.2 );
loc = Spawn( "script_origin",(-31000, 15536, 7360));
mig_dest = (-28000, 15536, 7360);
loc playloopsound("hijk_jet_engine_intro");
loc ScaleVolume( 0.2 );
wait(4.5);
loc MoveTo(mig_dest, 30.0);
wait(3);
level.jet_1a.audio ScaleVolume( 1, 10);
loc ScaleVolume( 1, 10);
wait ( 8.0 );
level.jet_1b.audio = Spawn( "script_origin", level.jet_1b.origin );
level.jet_1b.audio LinkTo( level.jet_1b );
level.jet_1b.audio playsound("hijk_jet_by_pullup");
wait ( 5.0 );
loc ScaleVolume(0.707, 8);
wait ( 9.0 );
level.jet_1a.audio playsound("hijk_jet_by_takeoff");
wait (2);
level.jet_1a.audio ScaleVolume( 0, 1);
level.jet_1b.audio playsound("hijk_jet_by_takeoff");
wait (3);
loc ScaleVolume(0, 8);
flag_wait("second_migs");
thread migs_2();
loc ScaleVolume(0, 2.5);
wait (3);
loc delete();
}
migs_2()
{
wait (0.5);
level.jet_2b.audio = Spawn( "script_origin", level.jet_2b.origin );
level.jet_2b.audio LinkTo( level.jet_2b );
level.jet_2b.audio playsound("hijk_hallway_flyby");
}
paper_drop()
{
wait(6.5);
level.president playsound("hijk_pres_paper");
}
hijk_cart_moves()
{
wait(0.25);
loc = Spawn( "script_origin",(-29306, 12786, 7346));
loc playsound("hijk_agent_cart");
}
radio_com_intro()
{
loc = Spawn( "script_origin",(0, 0, 0));
loc ScaleVolume(0.1, 0);
wait(0.01);
loc ScaleVolume(1, 2);
loc playloopsound("hijk_radio_com_intro");
wait(17.5);
level.player playsound("hijk_radio_com_intro_out");
aud_fade_out_and_delete( loc, 0.1 );
}
kitchen_rattle()
{
wait (0);
loc = Spawn( "script_origin",(-29044, 12678, 7346));
loc playsound("hijk_turb_glasses");
}
typing_sound()
{
wait(1);
lapt = Spawn( "script_origin",(-28513, 12804, 7318));
lapt playloopsound("hijk_lapt_typing");
flag_wait("stop_typing_sound");
lapt stoploopsound("hijk_lapt_typing");
}
debate_bumps()
{
loc = Spawn( "script_origin",(-28320, 12784, 7312));
wait(15.5);
loc playsound("hijk_debate_bump_01");
wait(5);
loc playsound("hijk_debate_bump_02");
wait(4);
loc delete();
}
keypad()
{
wait(11);
loc = Spawn( "script_origin",(-28832, 12784, 7344));
loc playsound("hijk_keypad");
wait (2);
loc delete();
}
hijk_agent_espresso()
{
wait(15);
loc = Spawn( "script_origin",(-29072, 12678, 7332));
loc playloopsound("hijk_agent_espresso");
flag_wait("stop_kitchen");
aud_fade_out_and_delete( loc, 1 );
}
news_broadcast()
{
news = Spawn( "script_origin",(-28354, 12820, 7390));
news playsound("hijack_tvb_worldmarkets");
flag_wait("stop_news_broadcast");
aud_fade_out_and_delete( news, 0.01 );
}
debate_door_close()
{
level.door3 playsound("hijk_door3close");
flag_set("stop_kitchen");
}
chairs_and_props()
{
wait(4);
level.president playsound("chair_enter");
wait(0.5);
level.advisor playsound("chair_enter");
wait(2);
level.polit_1 playsound("chair_enter");
}
agent_1_dash()
{
thread aud_prime_and_play("hijk_agent_dash1", 3, level.intro_agent2.origin);
}
agent_2_dash()
{
level.hero_agent_01 thread aud_prime_stream("hijk_agent_dash2");
wait(2);
level.hero_agent_01 playsound("hijk_agent_dash2");
}
agent_1_back()
{
wait(1);
level.intro_agent2 playsound("hijk_agent_dash3");
}
agent_1_rumble_foley()
{
wait(1);
level.intro_agent2 playsound("hijk_agent_blastfall1");
}
agent_2_rumble_foley()
{
wait(0);
level.hero_agent_01 playsound("hijk_agent_blastfall2");
wait (3);
}
pre_breach_music_cue()
{
wait(1.5);
MUS_play("hijk_pre_breach");
}
hallway_lurch(is_sp)
{
loc = Spawn( "script_origin",(0, 0, 0));
thread turbulence_2d();
thread turbine_wind_d();
if (is_sp)
{
loc playsound("hijk_zero_g_bigshake");
}
loc playsound("hijk_tilt_stress_01");
}
hijk_agent_stumblehit()
{
wait (1);
level.commander playsound("hijk_agent_stumblehit");
}
pre_zero_g_rumble()
{
AZM_start_zone("jet_turb_zone");
loc = Spawn( "script_origin",(0, 0, 0));
loc2 = Spawn( "script_origin",(0, 0, 0));
loc3 = Spawn( "script_origin",(0, 0, 0));
wait ( 1 );
loc ScaleVolume(0.1, 0);
loc2 ScaleVolume(0.1, 0);
loc3 ScaleVolume(0.1, 0);
wait(0.2);
loc playloopsound("pre_zero_g_rumble");
loc2 playloopsound("loop_jet_tilt");
loc3 playloopsound("hijk_hallway_rattle");
wait( 0.2 );
loc ScaleVolume( 0.4, 12);
loc2 ScaleVolume( 1, 20);
loc3 ScaleVolume( 1, 10);
flag_wait("up_prezerog_rumble");
loc ScaleVolume(1, 10);
aud_fade_out_and_delete( loc3, 1.0 );
aud_fade_out_and_delete( loc2, 2.0 );
wait (20);
loc ScaleVolume (0, 8.0);
thread post_zero_g_rumble();
wait(9);
loc delete();
}
pre_zero_g_rumble_cp()
{
AZM_start_zone("jet_turb_zone");
loc = Spawn( "script_origin",(0, 0, 0));
loc2 = Spawn( "script_origin",(0, 0, 0));
loc playloopsound("pre_zero_g_rumble");
loc2 playloopsound("loop_jet_tilt");
loc ScaleVolume(0.4, 0);
loc2 ScaleVolume( 1, 0);
flag_wait("up_prezerog_rumble");
loc ScaleVolume(1, 10);
aud_fade_out_and_delete( loc2, 2.0 );
wait (15);
aud_fade_out_and_delete( loc, 4.0 );
wait(12);
thread post_zero_g_rumble();
}
zero_g_start()
{
MUS_Stop( 6 );
thread zero_g_tilt_moan_sequence();
AZM_start_zone("jet_zero_g_zone");
zero_g = spawn("script_origin", (0, 0, 0));
thread zero_g_lfe();
zero_g playsound("hijk_zero_g_start");
thread briefcase_impact();
wait ( 8 );
AZM_start_zone("jet_zero_g_ramp_zone");
wait ( 12 );
thread turbine_wind_c();
wait (4);
thread jet_falling_2d();
AZM_start_zone("jet_post_zero_g_zone");
MUS_play("hijk_mx_lowerdeck_shootout");
}
zero_g_lfe()
{
wait(10);
loc = spawn("script_origin", (0, 0, 0));
wait(0.1);
loc ScaleVolume(0.1, 0);
wait(0.1);
loc playloopsound("hijk_lfe_drone");
wait(0.1);
loc ScaleVolume(1, 10);
wait(8);
loc ScalePitch(1.2, 2);
wait(2);
loc ScalePitch(.5, 4);
wait(2);
loc ScaleVolume(0, 4);
wait(4.1);
loc stoploopsound("hijk_lfe_drone");
wait(0.1);
loc delete();
}
briefcase_impact()
{
wait(2);
play_sound_in_space("hijk_briefcase_impact", (-27328, 12688, 7360));
}
zero_g_tilt_moan_sequence()
{
wait(2.3);
thread tilt_moan_02();
wait(12.0);
thread tilt_moan_03();
}
tilt_moan_01()
{
level.player playsound("hijk_tilt_moan_01");
wait(0.3);
thread MM_add_submix_oneshot("zero_g_moan_mix",0.4,0.1,0.8);
}
tilt_moan_02()
{
level.player playsound("hijk_tilt_moan_02");
wait(0.3);
thread MM_add_submix_oneshot("zero_g_moan_mix",0.4,0.1,0.8);
}
tilt_moan_03()
{
level.player playsound("hijk_tilt_moan_03");
wait(0.3);
thread MM_add_submix_oneshot("zero_g_moan_mix",0.4,0.1,0.8);
}
zero_g_bodyslam1()
{
loc1 = Spawn( "script_origin", (0, 0, 0));
loc2 = Spawn( "script_origin",(-27568, 12848, 7318));
loc1 playsound("hijk_zero_g_bigshake");
wait ( 0.5 );
loc2 playsound("hijk_misc_sm_debris");
}
props_debris1()
{
wait(0);
level.player playsound("hijk_props_debris");
wait(0.2);
level.player playsound("hijk_props_debris");
}
zero_g_bodyslam2()
{
thread MM_add_submix_oneshot("zero_g_bodyslam_mix",0,0.1,1.0);
loc1 = Spawn( "script_origin", (0, 0, 0));
loc2 = Spawn( "script_origin",(-27552, 12688, 7318));
loc1 playsound("hijk_body_slam");
wait ( 0.5 );
loc2 playsound("hijk_misc_sm_debris");
}
props_debris2()
{
wait(0);
level.player playsound("hijk_props_debris");
wait(.3);
level.player playsound("hijk_props_debris");
}
zero_g_bodyslam3()
{
thread MM_add_submix_oneshot("zero_g_bodyslam_mix",0,0.1,1.0);
loc1 = Spawn( "script_origin", (0, 0, 0));
loc2 = Spawn( "script_origin",(-27392, 12688, 7318));
loc1 playsound("hijk_body_slam");
wait ( 0.5 );
loc2 playsound("hijk_misc_sm_debris");
}
props_debris3()
{
wait(0);
level.player playsound("hijk_props_debris");
wait(0.3);
level.player playsound("hijk_props_debris");
}
zero_g_bodyslam4()
{
loc1 = Spawn( "script_origin", (0, 0, 0));
loc2 = Spawn( "script_origin",(-27440, 12768, 7318));
loc3 = Spawn( "script_origin", (0, 0, 0));
loc1 playsound("hijk_body_slam");
wait ( 1 );
loc2 playsound("hijk_misc_sm_debris");
loc3 playloopsound("pre_zero_g_rumble");
wait(0.2);
loc3 ScaleVolume(0.1, 0);
wait ( 5 );
loc3 ScaleVolume(1, 4);
wait (4);
loc3 ScaleVolume(0, 10);
wait(11);
loc1 delete();
loc2 delete();
loc3 delete();
}
props_debris4()
{
wait(0);
level.player playsound("hijk_props_debris");
wait(.2);
level.player playsound("hijk_props_debris");
wait(6);
level.player playsound("hijk_props_debris");
level.player playsound("hijk_props_debris");
}
zero_g_end_stress()
{
wait(5.0);
level.player playsound("hijk_tilt_stress_02");
}
zero_g_debris_crash()
{
loc = Spawn( "script_origin",(0, 0, 0));
wait ( 0.2 );
loc playsound("hijk_zero_g_debris_crash");
thread MM_add_submix_oneshot("zero_g_bodyslam_last_mix",0,0.3,1.0);
wait( 2 );
loc delete ();
}
post_zero_g_rumble()
{
loc = Spawn( "script_origin",(0, 0, 0));
loc ScaleVolume(0.1, 0);
wait(0.2);
loc playloopsound("pre_zero_g_rumble");
wait(0.2);
loc ScaleVolume(0.707, 9);
wait (10);
loc ScaleVolume(0, 12.0);
wait(13);
loc delete();
}
jet_falling_2d()
{
engine_drop_01 = spawn( "script_origin",(0, 0, 0));
engine_drop_02 = spawn( "script_origin",(0, 0, 0));
engine_drop_01 ScaleVolume(0.1, 0);
engine_drop_02 ScaleVolume(0.1, 0);
wait(0.01);
engine_drop_01 ScaleVolume(1, 5);
engine_drop_02 ScaleVolume(1, 5);
wait(0.05);
engine_drop_01 playloopsound("hijk_jet_falling_l_2d");
flag_wait("stop_jet_falling");
engine_drop_01 ScaleVolume(1);
engine_drop_02 ScaleVolume(1);
wait(0.01);
engine_drop_01 ScaleVolume(0, 8);
engine_drop_02 ScaleVolume(0, 8);
wait(0.05);
engine_drop_01 delete();
engine_drop_02 delete();
}
conf_room_shots_prime()
{
loc_3d = spawn("script_origin", (-28352, 12740, 7328));
loc_2d = spawn("script_origin", ( 0, 0, 0));
level.aud.loc_3d = loc_3d;
flag_wait ("conf_room_shots_go");
loc_3d playsound("hijk_conf_shots_3d");
wait ( 13 );
}
seatbeltsign()
{
wait ( 1.7 );
loc = spawn("script_origin",(-28352, 12740, 7328));
loc playsound("hijk_seatbelt_bell");
wait ( 5 );
loc delete();
}
conf_room_explosion1_prime()
{
loc_left = spawn("script_origin", (-28368, 12880, 7328));
loc_right = spawn("script_origin", (-28368, 12672, 7328));
bottles = spawn("script_origin", (-28672, 12656, 7328));
table = spawn("script_origin", (-28576, 12784, 7328));
level.aud.loc_left = loc_left;
level.aud.loc_right = loc_right;
flag_wait ("conf_room_explosion1_go");
thread conf_room_expl1_submix();
loc_left playsound("hijk_c4_distant_l");
wait ( 0.05 );
wait ( 0.1 );
bottles playsound("hijk_bottles_break");
table playsound("hijk_table_rattle");
thread desk_debris_01();
thread desk_debris_02();
loc = Spawn( "script_origin",(0, 0, 0));
loc ScaleVolume(0.1, 0);
wait(0.2);
loc playloopsound("pre_zero_g_rumble");
wait( 0.2 );
loc ScaleVolume( 0.6, 1);
wait( 2 );
loc ScaleVolume( 0, 6.0);
wait( 7 );
loc delete();
}
desk_debris_01()
{
wait(1.2);
play_sound_in_space("hijk_desk_debris_01", (-28480, 12736, 7328));
}
desk_debris_02()
{
wait(1.05);
play_sound_in_space("hijk_desk_debris_02", (-28704, 12736, 7328));
}
conf_room_expl1_submix()
{
thread MM_add_submix_oneshot("debate_room_expl1_mix", 0, 0.8, 2);
}
conf_room_c4_plant_prime()
{
loc = spawn("script_origin",(-28352, 12740, 7328));
level.aud.loc = loc;
flag_wait ("conf_room_c4_plant_go");
wait ( 1.5 );
loc playsound("hijk_c4_plant");
wait ( 9 );
loc delete();
}
conf_room_explosion2_prime()
{
c4_l = spawn("script_origin", (-28352, 12768, 7328));
c4_r = spawn("script_origin", (-28352, 12704, 7328));
table_debris1 = spawn("script_origin", (-28624, 12784, 7328));
table_debris2 = spawn("script_origin", (-28496, 12784, 7328));
wave = spawn("script_origin", (0, 0, 0));
display = spawn("script_origin",(-28784, 12848, 7390));
level.aud.c4_l = c4_l;
level.aud.c4_r = c4_r;
flag_wait ("conf_room_explosion2_go");
AZM_start_zone("door_breach_zone");
c4_l playsound("hijk_c4_door_l");
wave playsound("hijk_c4_blast_wave");
level.player playsound("hijk_tonal_door_breach_01");
wait ( 0.1 );
table_debris2 playsound("hijk_table_debris2");
wait (0.1);
wait (0.1);
display playsound("hijk_display_break");
wait ( 1.6 );
AZM_start_zone("debate_post_breach_zone");
wait ( 4 );
wait ( 3 );
c4_l delete();
c4_r delete();
table_debris1 delete();
table_debris2 delete();
wave delete();
display delete();
}
turbulence_2d()
{
level.player playsound("hijk_turbulence_2d");
}
turbulence_2d_boom()
{
level.player playsound("hijk_turbulence_lg_2d");
level.player playsound("hijk_explosion_lg_lfe");
}
failing_engine()
{
loc = Spawn( "script_origin",(-28544, 13648, 7360));
loc playsound("hijk_failing_engine");
flag_wait("up_prezerog_rumble");
loc ScaleVolume(0, 4);
wait(10);
loc delete();
}
turbine_wind_a()
{
loc1 = spawn("script_origin", (-28128, 13536, 7072));
loc2 = spawn("script_origin", (-28144, 12032, 7072));
loc3 = spawn("script_origin", (-30096, 12784, 7072));
wait(RandomIntRange(0, 3));
loc1 playsound("hijk_turbine_wind_v01");
wait(RandomIntRange(0, 3));
loc2 playsound("hijk_turbine_wind_v02");
wait(RandomIntRange(0, 3));
loc3 playsound("hijk_turbine_wind_v03");
wait (25);
loc1 delete ();
loc2 delete ();
loc3 delete ();
}
turbine_wind_b()
{
loc1 = spawn("script_origin", (-28128, 13536, 7072));
loc2 = spawn("script_origin", (-28144, 12032, 7072));
loc3 = spawn("script_origin", (-30096, 12784, 7072));
thread ladder_fall();
wait(RandomIntRange(0, 2));
loc1 playsound("hijk_turbine_wind_fast_v02");
wait(RandomIntRange(0, 2));
loc2 playsound("hijk_turbine_wind_fast_v01");
wait(RandomIntRange(0, 2));
loc3 playsound("hijk_turbine_wind_fast_v03");
wait (4);
aud_send_msg("jet_lowerlev_occlusion3");
loc1 playsound("hijk_turbine_wind_v01");
loc2 playsound("hijk_turbine_wind_v02");
loc3 playsound("hijk_turbine_wind_v03");
wait (8);
aud_fade_out_and_delete(loc1, 4.0 );
aud_fade_out_and_delete(loc2, 4.0 );
aud_fade_out_and_delete(loc3, 4.0 );
}
ladder_fall()
{
wait(2);
play_sound_in_space("hijk_ladder_fall", (-28688, 12896, 7168));
}
turbine_wind_c()
{
loc1 = spawn("script_origin", (-28128, 13536, 7072));
loc2 = spawn("script_origin", (-28144, 12032, 7072));
loc3 = spawn("script_origin", (-30096, 12784, 7072));
loc1 playsound("hijk_turbine_wind_v03");
wait(RandomIntRange(0, 1));
loc2 playsound("hijk_turbine_wind_v02");
wait(RandomIntRange(0, 1));
loc3 playsound("hijk_turbine_wind_v01");
wait (25);
loc1 delete ();
loc2 delete ();
loc3 delete ();
}
turbine_wind_d()
{
loc1 = spawn("script_origin", (-28128, 13536, 7072));
loc2 = spawn("script_origin", (-28144, 12032, 7072));
loc3 = spawn("script_origin", (-30096, 12784, 7072));
loc1 playsound("hijk_turbine_wind_fast_v03");
loc2 playsound("hijk_turbine_wind_fast_v02");
loc3 playsound("hijk_turbine_wind_fast_v01");
wait (25);
loc1 delete ();
loc2 delete ();
loc3 delete ();
}
turbine_wind_e()
{
loc1 = spawn("script_origin", (-28128, 13536, 7072));
loc2 = spawn("script_origin", (-28144, 12032, 7072));
loc3 = spawn("script_origin", (-30096, 12784, 7072));
loc1 playsound("hijk_turbine_wind_v03");
loc2 playsound("hijk_turbine_wind_v02");
loc3 playsound("hijk_turbine_wind_v01");
wait (25);
loc1 delete ();
loc2 delete ();
loc3 delete ();
}
jet_roll_v01()
{
loc1 = spawn("script_origin", (-27472, 12784, 7184));
loc2 = spawn("script_origin", (-27536, 12912, 7184));
loc3 = spawn("script_origin", (-27616, 12672, 7216));
level.player playsound("hijk_jet_roll_v01");
thread MM_add_submix_oneshot("lowerlev_roll_mix",0.1,0.5,1.5);
wait ( 2 );
loc1 playsound("hijk_bottles_break");
wait ( 0.5 );
loc2 playsound("hijk_table_rattle");
wait ( 0.8 );
loc3 playsound("hijk_bar_bottles_break");
wait ( 6 );
loc1 delete();
loc2 delete();
loc3 delete();
}
jet_roll_v02()
{
loc1 = spawn("script_origin", (-28640, 12912, 7168));
loc2 = spawn("script_origin", (-28640, 12688, 7168));
level.player playsound("hijk_jet_roll_v02");
thread MM_add_submix_oneshot("lowerlev_roll_mix",0.1,0.5,1.5);
wait ( 2 );
loc1 playsound("hijk_box_tumble_l");
loc2 playsound("hijk_box_tumble_r");
wait ( 8 );
loc1 delete();
loc2 delete();
}
cargo_room_zone_on()
{
wait ( 8 );
AZM_start_zone("jet_cargo_room_zone");
}
metal_tanks()
{
loc1 = spawn("script_origin", (-28556, 12899, 7178));
wait ( 2.5 );
loc1 playsound("hijk_props_tanks");
wait ( 2.5 );
loc1 playsound("hijk_props_tankroll");
wait ( 8 );
loc1 delete();
}
approaching_ground()
{
tilt = spawn("script_origin", (0, 0, 0));
wind = spawn("script_origin", (0, 0, 0));
tilt playsound("shot_jet_tilt");
wait (4);
}
pre_crash_door()
{
loc1 = spawn("script_origin", (-28954, 12781, 7179));
wait (1);
loc1 playsound("hijk_precrash_door");
wait ( 2.5 );
loc1 delete();
}
crash_sequence(model)
{
bigshake = spawn("script_origin", (0, 0, 0));
crash = spawn("script_origin", (0, 0, 0));
crash2 = spawn("script_origin", (0, 0, 0));
lfe = spawn("script_origin", (0, 0, 0));
bigshake playsound("hijk_zero_g_bigshake");
crash playsound("hijk_turbulence_2d");
crash playsound("hijk_jet_crash_leadin");
wait ( 0.5 );
wait (0.6 );
crash playsound("hijk_turbulence_2d");
wait ( 1.5 );
flag_set("stop_jet_falling");
MUS_Stop( 3 );
wait (2.83);
AZM_start_zone("pre_crash_duck_zone");
wait ( 0.3 );
crash playsound("hijk_jet_crash_tires");
AZM_start_zone("jet_crash_zone");
crash playsound("hijk_jet_crash_hitground");
wait ( 0.47 );
crash playsound("hijk_explosion_lfe");
lfe playloopsound("loop_lfe_shake");
thread jet_fire();
wait ( 2.4 );
thread separation();
crash2 playsound("hijk_jet_scrape2_lr");
wait ( 2.03 );
AZM_start_zone("jet_crash_breached_zone");
wait ( 3 );
crash playsound("hijk_jet_crash_pitchfx");
wait ( 2 );
aud_fade_out_and_delete( crash2, 2.0 );
wait ( 0.5 );
crash playsound("hijk_crash_flyingdebris_01");
wait ( 1.9 );
crash playsound("hijk_jet_tailcrunch1");
wait ( 1.57 );
wait ( 0.4 );
crash playsound("hijk_jet_crash_trees");
wait ( 5.2 );
lfe stoploopsound("loop_lfe_shake");
}
crash_explosion()
{
level.crash_explosion_origin thread play_sound_on_entity( "hijk_crash_left_fire" );
}
crash_chunk_breaks_away()
{
level.crash_breakaway_chunk thread play_sound_on_entity( "hijk_crash_chunk" );
}
tower_impact()
{
thread MM_add_submix_oneshot("tower_impact_mix",0,0.3,1);
level.player thread play_sound_on_entity( "hijk_tower_lfe" );
level.player thread play_sound_on_entity( "hijk_tower_impact" );
}
crash_props()
{
wait(0);
level.player playsound("hijk_props_debris");
wait(0.5);
level.player playsound("hijk_props_debris");
wait(0.5);
level.player playsound("hijk_props_debris");
wait(5);
level.player playsound("hijk_crashprops_group");
wait(0.5);
level.player playsound("hijk_crashprops_group");
wait(0.5);
level.player playsound("hijk_crashprops_group");
}
crash_badguys_bodyfalls()
{
wait(6.5);
level.player playsound("hijk_crash_terror_bodyfall");
level.player playsound("hijk_crash_terror_gundrop1");
wait(0.5);
level.player playsound("hijk_crash_terror_bodyfall");
wait(0.5);
level.player playsound("hijk_crash_terror_bodyfall");
}
jet_fire()
{
loc = spawn("script_origin", ( 0,0,0));
loc playsound("shot_jet_fire");
}
separation()
{
loc = spawn("script_origin", ( -24140, 15908, 4000));
thread aud_prime_and_play("hijk_jet_separation", 3.6, loc.origin);
}
crazy_guy_goes_flying(args)
{
the_agent = args;
wait(17.75);
the_agent playSound("hijk_agent_slipscream");
}
crash_death()
{
AZM_start_zone("jet_crash_death_zone");
level.player playsound("hijk_crash_death");
}
crash_sequence_turbine()
{
if (level.bCrashSequenceEndPlayed == false)
{
incoming = spawn("script_origin", (8384, 4064, 288));
turbine = spawn("script_origin", (8928, 4064, 144));
turbine thread aud_prime_stream("hijk_incoming_turbine");
wait (2.8);
level.player playsound("hijk_incoming_turbine");
incoming thread aud_prime_stream("hijk_zero_g_stop");
wait (1.9);
wait(0.2);
turbine playsound("hijk_turbine_stop");
level.player playsound("hijk_zero_g_stop");
wait(0.2);
thread MM_add_submix_oneshot("post_crash_blackout_mix",0.7,8,6);
wait ( 14 );
level.player playsound("hijk_wake_up_reveal");
}
}
crash_sequence_end()
{
crash = spawn("script_origin", (0, 0, 0));
crash playsound("hijk_jet_crash_end");
wait (0.1);
wait ( 0.2 );
wait ( 2.5 );
}
music_cue_postcrash()
{
wait ( 22 );
MUS_play("hijk_mx_crash_aftermath");
}
music_cue_postcrash_cp()
{
MUS_play("hijk_mx_crash_aftermath");
}
commander_clears_debris()
{
wait ( 15 );
level.commander playsound("hijk_debris_move1");
wait ( 2 );
level.commander playsound("hijk_debris_move2");
wait ( 2 );
level.commander playsound("hijk_debris_move3");
wait ( 6 );
}
debris_shift1()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9008, 4016, 208));
play_sound_in_space("shot_debris_shift", (9008, 4016, 208));
level.bDebrisWait = false;
}
}
debris_shift2()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (8992, 3856, 208));
play_sound_in_space("shot_debris_shift", (8992, 3856, 208));
level.bDebrisWait = false;
}
}
debris_shift3()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9152, 4000, 208));
play_sound_in_space("shot_debris_shift", (9152, 4000, 208));
level.bDebrisWait = false;
}
}
debris_shift4()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9136, 3856, 208));
play_sound_in_space("shot_debris_shift", (9136, 3856, 208));
level.bDebrisWait = false;
}
}
debris_shift5()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9280, 3984, 208));
play_sound_in_space("shot_debris_shift", (9280, 3984, 208));
level.bDebrisWait = false;
}
}
debris_shift6()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9264, 3824, 208));
play_sound_in_space("shot_debris_shift", (9264, 3824, 208));
level.bDebrisWait = false;
}
}
debris_shift7()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9408, 3968, 208));
play_sound_in_space("shot_debris_shift", (9408, 3968, 208));
level.bDebrisWait = false;
}
}
debris_shift8()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9376, 3792, 208));
play_sound_in_space("shot_debris_shift", (9376, 3792, 208));
level.bDebrisWait = false;
}
}
debris_shift9()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9552, 3936, 208));
play_sound_in_space("shot_debris_shift", (9552, 3936, 208));
level.bDebrisWait = false;
}
}
debris_shift10()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9520, 3792, 208));
play_sound_in_space("shot_debris_shift", (9520, 3792, 208));
level.bDebrisWait = false;
}
}
debris_shift11()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9680, 3920, 208));
play_sound_in_space("shot_debris_shift", (9680, 3920, 208));
level.bDebrisWait = false;
}
}
debris_shift12()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9664, 3760, 208));
play_sound_in_space("shot_debris_shift", (9664, 3760, 208));
level.bDebrisWait = false;
}
}
debris_shift13()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9808, 3888, 80));
play_sound_in_space("shot_debris_shift", (9808, 3888, 80));
level.bDebrisWait = false;
}
}
debris_shift14()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9888, 3760, 80));
play_sound_in_space("shot_debris_shift", (9888, 3760, 80));
level.bDebrisWait = false;
}
}
debris_shift15()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (10032, 3856, 80));
play_sound_in_space("shot_debris_shift", (10032, 3856, 80));
level.bDebrisWait = false;
}
}
debris_shift16()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (9824, 3824, 80));
play_sound_in_space("shot_debris_shift", (9824, 3824, 80));
level.bDebrisWait = false;
}
}
debris_shift17()
{
if (level.bDebrisWait == false)
{
level.bDebrisWait = true;
play_sound_in_space("shot_debris_shift", (10096, 3712, 80));
play_sound_in_space("shot_debris_shift", (10096, 3712, 80));
level.bDebrisWait = false;
}
}
plate_shift1()
{
if (level.bPlateWait == false)
{
level.bPlateWait = true;
play_sound_in_space("shot_plate_shift", (9472, 3856, 128));
level.bPlateWait = false;
}
}
plate_shift2()
{
if (level.bPlateWait == false)
{
level.bPlateWait = true;
play_sound_in_space("shot_plate_shift", (9200, 3856, 128));
level.bPlateWait = false;
}
}
music_reveal_exterior()
{
wait (0.5);
level.player playsound("hijk_reveal_exterior");
thread MM_add_submix_oneshot("exterior_reveal_mix",2.0,8.0,8.0);
wait(2);
MUS_Stop(3);
}
wreck_exit_explosion()
{
loc = spawn("script_origin", (3488, 4272, 2096));
loc playsound("hijk_wreck_expl");
wait ( 0.3 );
level.player playsound("hijk_wreck_expl_bg");
wait(10);
loc delete();
}
wing_settle()
{
play_sound_in_space("hijk_wing_settle", (9472, 3504, 100));
}
engine_pre_explosion()
{
loc = spawn("script_origin", (8672, 4128, 144));
loc ScaleVolume(0);
wait(0.2);
loc ScaleVolume(1, 7);
loc playloopsound("hijk_engine_fire");
while (!flag("turbine_exploded"))
{
loc playsound("hijk_engine_sputter");
exploder("engine_sputter");
wait (randomfloatrange(0.4, 2.5));
}
wait(0.2);
loc stoploopsound("hijk_engine_fire");
wait(0.2);
loc delete();
}
engine_explosion()
{
loc = spawn("script_origin", (8688, 4128, 368));
debris_l = spawn("script_origin", (7952, 4256, 368));
debris_r = spawn("script_origin", (8448, 4208, 368));
loc2 = spawn("script_origin", (0, 0, 0));
loc playsound("hijk_engine_sputter");
loc playsound("hijk_engine_expl");
loc2 playsound("hijk_engine_expl_bg");
flag_set("turbine_exploded");
wait (0.5);
loc2 playsound("hijk_eng_expl_debris_2d");
wait (0.5);
debris_l playsound("hijk_engine_expl_debris_l");
debris_r playsound("hijk_engine_expl_debris_r");
wait (1.1);
level.commander playsound("hijack_cmd_ugh");
wait(0.4);
loc2 playsound("hijk_dist_tail2_expl_bg");
wait (15);
loc delete();
debris_l delete();
debris_r delete();
loc2 delete();
}
flare_gun()
{
play_sound_in_space("hijk_flare", (10256, 5968, 1000));
}
heli_approach()
{
if (level.start_point != "end_scene" )
{
level.chopper_audio PlaySound("hijk_heli_approach");
}
}
random_tail_expl()
{
loc = spawn("script_origin", (8512, 6986, 368));
loc playsound("hijk_tail_pre_expl");
wait ( 6 );
loc delete();
}
tarmac_shift()
{
loc = spawn("script_origin", (9648, 3904, 192));
loc2 = spawn("script_origin", (9600, 3856, 210));
loc3 = spawn("script_origin", (9824, 3648, 192));
level.player playsound("hijk_tarmac_shift");
wait(1);
loc playsound("hijk_tarmac_debris");
wait(1.3);
loc2 playsound("hijk_tarmac_pipe");
wait(3.2);
loc playsound("hijk_tarmac_crates_fall");
wait(5.5);
loc3 playsound("hijk_tarmac_crates_fall_dist");
wait(8);
loc delete();
loc2 delete();
loc3 delete();
}
fighter_jet_pass_ground()
{
loc = spawn("script_origin", (10176, -304, 2096));
loc_lfe = spawn("script_origin", (0, 0, 0));
loc playsound("hijk_fighter_pass_ground");
wait ( 2 );
loc_lfe playsound("hijk_fighter_pass_ground_lfe");
wait (25);
loc delete();
loc_lfe delete();
}
tarmac_dist_fire()
{
level endon("stop_tarmac_dist_fire");
loc = spawn("script_origin", (10720, 7840, 600));
while(1)
{
loc PlaySound("hijk_tarmac_ambiguns");
wait(RandomFloatRange( 0.5, 1.5 ));
}
}
tarmac_combat_music()
{
if (level.bPostTarmacCombatTrig == false)
{
level.player playsound("hijk_reveal_ground_combat");
MUS_Stop( 2 );
wait(5);
MUS_play("hijk_tarmac_combat");
level.bPostTarmacCombatTrig = true;
}
}
first_suv()
{
loc = spawn("script_origin", (9792, 7200, 210));
loc playsound("hijk_suv_stop_01");
thread siren_mayhem();
AZM_start_zone("post_tarmac_combat_zone");
wait(8);
level notify("stop_tarmac_dist_fire");
loc delete();
}
siren_mayhem()
{
wait(40);
loc = spawn("script_origin", (6048, 8480, 500));
loc ScaleVolume( 0 );
wait(0.2);
loc playloopsound("hijk_siren_mayhem");
wait(0.2);
loc ScaleVolume(1, 50);
flag_wait ("kill_sirens");
loc stoploopsound("hijk_siren_mayhem");
loc delete();
}
siren_mayhem_cp()
{
loc = spawn("script_origin", (6048, 8480, 500));
loc playloopsound("hijk_siren_mayhem");
flag_wait ("kill_sirens");
loc ScaleVolume(0, 4);
wait(5);
loc stoploopsound("hijk_siren_mayhem");
loc delete();
}
heli()
{
loc1 = spawn("script_origin", (10816, 4960, 192));
loc2 = spawn("script_origin", (0, 0, 0));
loc3 = spawn("script_origin", (0, 0, 0));
flag_wait("makarov_slow");
wait (0.6);
loc1 playsound("hijk_heli_shot");
MUS_play("hijk_makarov_reveal", 5);
wait (0.5);
level.chopper_audio StopLoopSound();
loc1 ScaleVolume( 0.891, 0.1);
loc2 ScaleVolume(0.1, 0);
loc3 ScaleVolume(0.1, 0);
wait(0.2);
loc2 playloopsound("hijk_end_fire");
loc3 playloopsound("pre_zero_g_rumble");
wait( 0.2 );
loc1 ScaleVolume( .63, 8 );
loc2 ScaleVolume( 0.354, 8 );
loc3 ScaleVolume( 0.446, 12 );
flag_wait("player_dead");
wait(0.3);
MUS_stop(0.1);
loc1 ScaleVolume( 0, 0.25);
loc2 ScaleVolume( 0, 0.25);
loc3 ScaleVolume( 0, 0.25);
thread MM_add_submix_oneshot("kill_vo_mix",0.25, 10, 10);
wait(0.3);
loc1 delete();
loc2 delete();
loc3 delete();
}
suv_explosion()
{
thread MM_add_submix_oneshot("combat_explosion_mix",0.1,0.8,1.0);
}
end_area_chopper_begin()
{
level.chopper_audio PlaySound("hijk_heli_approach_close");
}
ambiguns1()
{
level endon("door_used");
wait(8);
loc = spawn("script_origin", (10336, 5808, 600));
while(1)
{
wait(RandomFloatRange( 2, 5 ));
loc PlaySound( "hijk_end_scene_ambiguns");
}
}
ambiguns2()
{
level endon("door_used");
wait(10);
loc = spawn("script_origin", (9680, 5008, 600));
while(1)
{
wait(RandomFloatRange( 2, 5 ));
loc PlaySound( "hijk_end_scene_ambiguns");
}
}
ambiguns3()
{
level endon("door_used");
wait(12);
loc = spawn("script_origin", (9712, 4128, 600));
while(1)
{
wait(RandomFloatRange( 2, 5 ));
loc PlaySound( "hijk_end_scene_ambiguns");
}
}
ambiguns4()
{
level endon("door_used");
wait(14);
loc = spawn("script_origin", (11088, 3184, 600));
while(1)
{
wait(RandomFloatRange( 2, 5 ));
loc PlaySound( "hijk_end_scene_ambiguns");
}
}
ambiguns5()
{
level endon("door_used");
wait(7);
while(1)
{
wait(RandomFloatRange( 0.5, 4 ));
level.player PlaySound("hijk_bulletwhiz");
}
}
heli_door()
{
wait (1.25);
loc = spawn("script_origin", (10816, 4960, 192));
loc playsound("hijk_makarov_gunshot");
flag_set("kill_sirens");
thread MM_add_submix_oneshot("kill_vo_mix",0.25, 4, 4);
}
makarov_slow()
{
wait ( 1.5 );
MUS_Stop( 2 );
wait ( 0.5 );
AZM_start_zone("makarov_zone");
wait ( 1.3 );
flag_set("makarov_slow");
}
end_scene_foley1()
{
wait(5.35);
level.player playsound("hijk_end_scene_p1");
}
end_scene_foley2()
{
wait(9.55);
level.player playsound("hijk_end_scene_p2");
wait(1.32);
level.commander playsound("hijack_fso1_moan");
wait(2);
wait(1.97);
level.player playsound("hijk_end_scene_p4");
wait(11.87);
level.player playsound("hijk_end_scene_p5");
wait(2.99);
level.player playsound("hijk_end_scene_p6");
wait(4.1);
level.player playsound("hijk_end_scene_p7");
wait(4.64);
flag_set("player_dead");
wait(1);
AZM_start_zone("end_fade_zone");
}
commander_shot()
{
level.player playsound("hijk_end_scene_p3");
}
player_shot()
{
level.player playsound("hijk_end_scene_p8");
}
blackout()
{
loc = spawn("script_origin", (0, 0, 0));
wait (4.38);
loc playsound("hijk_blackout_v01");
wait (9.0);
loc playsound("hijk_blackout_v02");
wait (6.0);
loc playsound("hijk_blackout_v03");
}
loop_chopper_makarov_flyover()
{
AssertEx(IsDefined(level.makarov_heli), "hijack_aud::loop_chopper_makarov_flyover() - level.makarov_heli was not defined");
if (IsDefined(level.makarov_heli))
level.makarov_heli StopLoopSound();
if (!IsDefined(level.chopper_audio))
{
level.chopper_audio = Spawn( "script_origin", level.makarov_heli.origin );
level.chopper_audio LinkTo( level.makarov_heli, "tag_origin", ( 0, 0, 64 ), ( 0, 0, 0 ) );
}
thread heli_approach();
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
loop_chopper_makarov()
{
AssertEx(IsDefined(level.makarov_heli), "hijack_aud::loop_chopper_makarov() - level.makarov_heli was not defined");
if (IsDefined(level.makarov_heli))
level.makarov_heli StopLoopSound();
if (!IsDefined(level.chopper_audio))
{
level.chopper_audio = Spawn( "script_origin", level.makarov_heli.origin );
level.chopper_audio LinkTo( level.makarov_heli, "tag_origin", ( 0, 0, 64 ), ( 0, 0, 0 ) );
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
MM_add_submix_oneshot(submixname, fadein, delay, fadeout)
{
MM_add_submix(submixname, fadein);
wait(delay);
MM_clear_submix(submixname, fadeout);
}
filter_oneshot(filtername, delaytime)
{
aud_set_filter(filtername, 0);
wait(delaytime);
aud_clear_filter(0);
}
aud_fade_eq_hold(fade_in, hold, fade_out, channels, band, type, gain, freq, q, occlusion_preset)
{
aud_fade_eq(fade_in, channels, band, type, gain, freq, q, 1, occlusion_preset);
wait(fade_in + hold);
aud_fade_eq(fade_out, channels, band, type, gain, freq, q, 0, occlusion_preset);
}
aud_fade_eq(fadetime, channels, band, type, gain, freq, q, eq_index, occlusion_preset)
{
if (IsArray(channels))
{
for (i = 0; i < channels.size; i++)
{
level.player seteq(channels[i], 0, 0, "lowpass", 0, 20000, 1);
level.player seteq(channels[i], 1, band, type, gain, freq, q);
}
}
else
{
assert(IsString(channels));
level.player seteq(channels, 0, 0, "lowpass", 0, 20000, 1);
level.player seteq(channels, 1, band, type, gain, freq, q);
}
level.player seteqlerp(0, eq_index);
thread audx_filter_fade_internal(fadetime, eq_index, occlusion_preset);
}
audx_filter_fade_internal(fadetime, eq_index, occlusion_preset)
{
assert(IsDefined(fadetime));
update_rate = 0.05;
number_of_ticks = fadetime / update_rate;
increment = 1.0 / number_of_ticks;
lerp = 0;
while (lerp <= 1)
{
level.player seteqlerp(lerp, eq_index);
lerp += increment;
wait(update_rate);
}
level.player seteqlerp(1, eq_index);
if (IsDefined(occlusion_preset))
{
assert(IsString(occlusion_preset));
aud_set_occlusion(occlusion_preset);
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
self SetPitch( pitch_scale, tick_time );
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
}
}
if (isDefined(self))
self._doppler.origin_last = self.origin;
}
}
}

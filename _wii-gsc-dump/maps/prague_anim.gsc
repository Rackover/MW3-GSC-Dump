#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
#include maps\prague_courtyard_script_code;
main()
{
sandman();
kamarov();
generic_anims();
group_scenes();
dog();
dialogue();
radio();
player();
doors();
tank_crush_anims();
drone_deaths();
vehicles();
maps\_hand_signals::initHandSignals();
ambient_sounds();
level.gunless_anims =
[ "bunker_toss_idle_guy1" ,
"prague_woundwalk_wounded",
"prague_civ_door_peek",
"prague_civ_door_runin",
"prague_resistance_hit_idle",
"DC_Burning_bunker_stumble",
"dc_burning_bunker_stumble",
"civilian_crawl_1",
"civilian_crawl_2",
"dying_crawl",
"DC_Burning_artillery_reaction_v1_idle",
"DC_Burning_artillery_reaction_v2_idle",
"DC_Burning_artillery_reaction_v3_idle",
"DC_Burning_artillery_reaction_v4_idle",
"DC_Burning_bunker_sit_idle",
"civilain_crouch_hide_idle",
"DC_Burning_stop_bleeding_wounded_endidle",
"DC_Burning_stop_bleeding_medic_endidle",
"DC_Burning_stop_bleeding_wounded_idle",
"prague_woundwalk_wounded_idle",
"prague_bully_civ_survive_idle",
"training_basketball_rest",
"prague_mourner_man_idle" ];
}
#using_animtree( "generic_human" );
sandman()
{
level.scr_anim[ "delta" ][ "prague_redhouse_sneak" ] = %prague_redhouse_sneakin;
level.scr_anim[ "delta" ][ "hunted_drop" ] = %hunted_dive_2_pronehide_v1;
level.scr_anim[ "delta" ][ "hunted_drop_idle" ][ 0 ] = %hunted_pronehide_idle_v1;
level.scr_anim[ "delta" ][ "hunted_drop_2_stand" ] = %hunted_pronehide_2_stand_v1;
level.scr_anim[ "generic" ][ "hunted_drop_2_stand" ] = %hunted_pronehide_2_stand_v1;
level.scr_anim[ "delta" ][ "prone_hide" ] = %prague_prone_hide;
level.scr_anim[ "generic" ][ "prone_hide_idle" ][ 0 ] = %prague_prone_idle;
level.scr_anim[ "delta" ][ "gallery_jump" ] = %prague_soap_dive_over_cover;
}
kamarov()
{
level.scr_anim[ "kamarov" ][ "corner_idle" ][0] = %corner_standR_alert_idle;
level.scr_anim[ "kamarov" ][ "corner_peek" ] = %corner_standR_alert_2_look;
level.scr_anim[ "kamarov" ][ "corner_return" ] = %corner_standR_look_2_alert;
level.scr_anim[ "kamarov" ][ "corner_leave" ] = %corner_standR_trans_CQB_OUT_8;
}
generic_anims()
{
level.scr_anim[ "generic" ][ "prague_intro_swim_obstacles" ] = %prague_intro_swim_obstacles;
level.scr_anim[ "generic" ][ "prague_soap_radio_talk" ] = %prague_soap_radio_talk;
level.scr_anim[ "generic" ][ "CornerCrR_grenadeA" ] = %CornerCrR_grenadeA;
level.scr_anim[ "generic" ][ "CornerCrL_grenadeA" ] = %CornerCrL_grenadeA;
level.scr_anim[ "generic" ][ "covercrouch_grenadea" ] = %covercrouch_grenadea;
level.scr_anim[ "generic" ][ "exposed_crouch_fast_grenade_1" ] = %exposed_crouch_fast_grenade_2;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_reaction_01" ] = %prague_intro_dock_guard_reaction_01;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_reaction_02" ] = %prague_intro_dock_guard_reaction_02;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_01" ][0] = %prague_intro_dock_resistance_standidle_01;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_02" ][0] = %prague_intro_dock_resistance_standidle_02;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_01_stepforward" ] = %prague_intro_dock_resistance_walk_01;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_02_stepforward" ] = %prague_intro_dock_resistance_walk_02;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_01_getdown" ] = %prague_intro_dock_resistance_getdown_01;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_02_getdown" ] = %prague_intro_dock_resistance_getdown_02;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_01_getdown_idle" ][0] = %prague_intro_dock_resistance_proneidle_02;
level.scr_anim[ "generic" ][ "prague_intro_dock_resistance_standidle_02_getdown_idle" ][0] = %prague_intro_dock_resistance_proneidle_01;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_run2water_center" ] = %prague_intro_dock_guard_run2water_center;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_run2water_left" ] = %prague_intro_dock_guard_run2water_left;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_run2water_right" ] = %prague_intro_dock_guard_run2water_right;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_searchwater_center" ][0] = %prague_intro_dock_guard_searchwater_center;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_searchwater_left" ][0] = %prague_intro_dock_guard_searchwater_left;
level.scr_anim[ "generic" ][ "prague_intro_dock_guard_searchwater_right" ][0] = %prague_intro_dock_guard_searchwater_right;
level.scr_anim[ "generic" ][ "yell_getdown" ] = %CQB_stand_shout_B;
level.scr_anim[ "generic" ][ "casual_stand_idle_trans_in" ] = %casual_stand_idle_trans_in;
level.scr_anim[ "generic" ][ "swim_idle" ][0] = %prague_intro_swim_idle_01;
level.scr_anim[ "generic" ][ "swim" ] = %prague_intro_swim_breaststroke_01;
level.scr_anim[ "generic" ][ "swim_fast" ] = %prague_intro_swim_breaststroke_02;
level.scr_anim[ "generic" ][ "signal_stop_swim" ] = %prague_intro_swim_holdposition;
level.scr_anim[ "generic" ][ "stand_react" ] = %london_kickout_window_kick_reaction;
level.scr_anim[ "generic" ][ "coverL_react" ] = %corner_standL_pain;
level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_death_1" ] = %cargoship_sleeping_guy_death_1;
level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_death_2" ] = %cargoship_sleeping_guy_death_2;
level.scr_anim[ "generic" ][ "run_react_stumble_non_loop" ] = %run_react_stumble_non_loop;
level.scr_anim[ "generic" ][ "run_react_duck_non_loop" ] = %run_react_duck_non_loop;
level.scr_anim[ "generic" ][ "run_react_flinch_non_loop" ] = %run_react_flinch_non_loop;
level.scr_anim[ "generic" ][ "prague_civ_door_peek" ] = %prague_civ_door_peek;
level.scr_anim[ "generic" ][ "prague_civ_door_runin" ] = %prague_civ_door_runin;
level.scr_anim[ "generic" ][ "prague_soap_final_message" ] = %prague_ending_soap_radiotalk;
level.scr_anim[ "generic" ][ "prague_ending_soap_radiotalk" ] = %prague_ending_soap_radiotalk;
level.scr_anim[ "generic" ][ "door_kick_2_cqbwalk" ] = %doorkick_2_cqbwalk;
level.scr_anim[ "generic" ][ "cqb_walk_slice_pie_l" ] = %cqb_walk_slice_pie_l;
level.scr_anim[ "generic" ][ "cqb_walk_slice_pie_r" ] = %cqb_walk_slice_pie_r;
level.scr_anim[ "generic" ][ "door_slowopen_arrive" ] = %hunted_open_barndoor_stop;
level.scr_anim[ "generic" ][ "door_slowopen_idle" ][ 0 ] = %hunted_open_barndoor_idle;
level.scr_anim[ "generic" ][ "door_slowopen" ] = %hunted_open_barndoor_flathand;
level.scr_anim[ "generic" ][ "door_slowopen_shoulder" ] = %prague_shoulder_bash_scan;
level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v1" ] = %coup_civilians_interrogated_civilian_v1;
level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v2" ] = %coup_civilians_interrogated_civilian_v2;
level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v3" ] = %coup_civilians_interrogated_civilian_v3;
level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v4" ] = %coup_civilians_interrogated_civilian_v4;
level.scr_anim[ "generic" ][ "coup_civilians_interrogated_guard_v2" ] = %coup_civilians_interrogated_guard_v2;
level.scr_anim[ "generic" ][ "ziptie_suspect_idle" ][ 0 ] = %ziptie_suspect_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_1_soldier_idle" ][ 0 ] = %prague_interrogate_1_soldier_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_2_soldier_idle" ][ 0 ] = %prague_interrogate_2_soldier_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_3_soldier_idle" ][ 0 ] = %prague_interrogate_3_soldier_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_1_soldier_kill" ] = %prague_interrogate_1_soldier_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_2_soldier_kill" ] = %prague_interrogate_2_soldier_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_3_soldier_kill" ] = %prague_interrogate_3_soldier_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_1short_soldier_drag" ] = %prague_interrogate_1short_soldier_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_1_soldier_drag" ] = %prague_interrogate_1_soldier_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_2_soldier_drag" ] = %prague_interrogate_2_soldier_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_3_soldier_drag" ] = %prague_interrogate_3_soldier_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_1_civ_idle" ][ 0 ] = %prague_interrogate_1_civ_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_1short_civ_idle" ][ 0 ] = %prague_interrogate_1short_civ_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_idle" ][ 0 ] = %prague_interrogate_2_civ_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_3_civ_idle" ][ 0 ] = %prague_interrogate_3_civ_idle;
level.scr_anim[ "generic" ][ "prague_interrogate_1short_civ_kill" ] = %prague_interrogate_1short_civ_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_1_civ_kill" ] = %prague_interrogate_1_civ_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_kill" ] = %prague_interrogate_2_civ_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_3_civ_kill" ] = %prague_interrogate_3_civ_kill;
level.scr_anim[ "generic" ][ "prague_interrogate_1short_civ_drag" ] = %prague_interrogate_1short_civ_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_1_civ_drag" ] = %prague_interrogate_1_civ_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_drag" ] = %prague_interrogate_2_civ_drag;
level.scr_anim[ "generic" ][ "prague_interrogate_3_civ_drag" ] = %prague_interrogate_3_civ_drag;
level.scr_anim[ "generic" ][ "casual_killer_stand_aim5" ][ 0 ] = %casual_killer_stand_aim5;
level.scr_anim[ "generic" ][ "exposed_aim_5" ][ 0 ] = %exposed_aim_5;
level.scr_anim[ "generic" ][ "hostage_fetal_idle" ][ 0 ] = %hostage_fetal_idle;
level.scr_anim[ "generic" ][ "hostage_facedown_idle" ][ 0 ] = %hostage_facedown_idle;
level.scr_anim[ "generic" ][ "crouch_2run_F" ] = %crouch_2run_F;
level.scr_anim[ "generic" ][ "walk_2_cqb_stop" ] = %ny_manhattan_sandman_signal_hold;
level.scr_anim[ "generic" ][ "stand_2_prone" ] = %stand_2_prone;
level.scr_anim[ "generic" ][ "stand_2_crouch" ] = %exposed_stand_2_crouch;
level.scr_anim[ "generic" ][ "crouch_2_stand" ] = %exposed_crouch_2_stand;
level.scr_anim[ "generic" ][ "crouch_2_prone" ] = %crouch_2_prone;
level.scr_anim[ "generic" ][ "prone_2_crouch" ] = %prone_2_crouch;
level.scr_anim[ "generic" ][ "prone_2_stand" ] = %prone_2_stand;
level.scr_anim[ "generic" ][ "crawl" ] = %prone_crawl;
level.scr_anim[ "generic" ][ "stand_exposed" ][0] = %exposed_aim_5;
level.scr_anim[ "generic" ][ "stand_2_run_f_2" ] = %stand_2_run_f_2;
level.scr_anim[ "generic" ][ "cqb_sweep" ] = %combatwalk_F_spin;
level.scr_anim[ "generic" ][ "combatwalk_F_spin" ] = %combatwalk_F_spin;
level.scr_anim[ "generic" ][ "patrol_jog_360_once" ] = %patrol_jog_360_once;
level.scr_anim[ "generic" ][ "patrol_jog_look_up_once" ] = %patrol_jog_360_once;
level.scr_anim[ "generic" ][ "signal_down" ] = %stand_exposed_wave_down;
level.scr_anim[ "price" ][ "cqb_stand_wave_on_me" ] = %cqb_stand_wave_on_me;
level.scr_anim[ "generic" ][ "patrol_jog_360" ] = %patrol_jog_360;
level.scr_anim[ "generic" ][ "patrol_jog_look_up" ] = %patrol_jog_look_up;
level.scr_anim[ "generic" ][ "slide_across_car_2_cover" ] = %slide_across_car_2_cover;
level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1" ][ 0 ] = %bunker_toss_idle_guy1;
level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v1_idle;
level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v2_idle;
level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v3_idle;
level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v4_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v4_idle;
level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][ 0 ] = %DC_Burning_bunker_sit_idle;
level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle" ][ 0 ] = %civilain_crouch_hide_idle;
level.scr_anim[ "generic" ][ "roadkill_cover_soldier_idle" ][ 0 ] = %roadkill_cover_soldier_idle;
level.scr_anim[ "generic" ][ "roadkill_cover_soldier" ][ 0 ] = %roadkill_cover_soldier;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_endidle;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_medic_endidle;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_idle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_idle;
level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier1" ][ 0 ] = %roadkill_cover_active_soldier1;
level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier2" ][ 0 ] = %roadkill_cover_active_soldier2;
level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier3" ][ 0 ] = %roadkill_cover_active_soldier3;
level.scr_anim[ "generic" ][ "prague_bully_civ_survive_idle" ][ 0 ] = %prague_bully_civ_survive_idle;
level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_R" ] = %airport_security_guard_pillar_death_R;
level.scr_anim[ "generic" ][ "RPG_stand_death_stagger" ] = %RPG_stand_death_stagger;
level.scr_anim[ "generic" ][ "death_explosion_run_R_v1" ] = %death_explosion_run_R_v1;
level.scr_anim[ "generic" ][ "death_explosion_stand_F_v4" ] = %death_explosion_stand_F_v4;
level.scr_anim[ "generic" ][ "stand_death_stumbleforward" ] = %stand_death_stumbleforward;
level.scr_anim[ "generic" ][ "stand_death_tumbleback" ] = %stand_death_tumbleback;
level.scr_anim[ "generic" ][ "death_shotgun_spinL" ] = %death_shotgun_spinL;
level.scr_anim[ "generic" ][ "prague_resistance_hit" ] = %prague_resistance_hit;
level.scr_anim[ "generic" ][ "prague_resistance_hit_idle" ][ 0 ] = %prague_resistance_hit_idle;
level.scr_anim[ "generic" ][ "prague_woundwalk_wounded" ] = %prague_woundwalk_wounded;
level.scr_anim[ "generic" ][ "prague_woundwalk_helper" ] = %prague_woundwalk_helper;
level.scr_anim[ "generic" ][ "prague_woundwalk_wounded_idle" ][ 0 ] = %prague_woundidle_wounded;
level.scr_anim[ "generic" ][ "prague_woundwalk_helper_idle" ][ 0 ] = %prague_woundidle_helper;
level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_once_l" ] = %prague_resistance_cover_idle_l;
level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_l" ][ 0 ] = %prague_resistance_cover_idle_l;
level.scr_anim[ "generic" ][ "prague_resistance_cover_shoot_l" ] = %prague_resistance_cover_shoot_l;
level.scr_anim[ "generic" ][ "prague_resistance_cover_l2r" ] = %prague_resistance_cover_l2r;
level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_once_r" ] = %prague_resistance_cover_idle_r;
level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_r" ][ 0 ] = %prague_resistance_cover_idle_r;
level.scr_anim[ "generic" ][ "prague_resistance_cover_shoot_r" ] = %prague_resistance_cover_shoot_r;
level.scr_anim[ "generic" ][ "prague_resistance_cover_r2l" ] = %prague_resistance_cover_r2l;
level.scr_anim[ "generic" ][ "apt_idle" ][0] = %hunted_spotter_idle;
level.scr_anim[ "generic" ][ "civ_captured" ][0] = %prague_resistance_walk_01;
level.scr_anim[ "generic" ][ "civ_captured" ][1] = %prague_resistance_walk_02;
level.scr_anim[ "generic" ][ "apt_jog" ]	= %huntedrun_1_look_right;
level.scr_anim[ "generic" ][ "church_jog" ]	= %huntedrun_1_look_left;
level.scr_anim[ "generic" ][ "cqb_walk" ] = %walk_CQB_f;
level.scr_anim[ "generic" ][ "bully_walk" ] = %prague_bully_a_run;
level.scr_anim[ "generic" ][ "civ_walk" ] = %prague_bully_civ_run;
level.scr_anim[ "generic" ][ "active_patrolwalk_v5" ] = %active_patrolwalk_v5;
level.scr_anim[ "generic" ][ "active_patrolwalk_v4" ] = %active_patrolwalk_v4;
level.scr_anim[ "generic" ][ "active_patrolwalk_v2" ] = %active_patrolwalk_v2;
level.scr_anim[ "generic" ][ "active_patrolwalk_v1" ] = %active_patrolwalk_v1;
level.scr_anim[ "generic" ][ "active_patrolwalk_gundown" ] = %active_patrolwalk_gundown;
level.scr_anim[ "generic" ][ "casual_killer_walk_F" ] = %casual_killer_walk_F;
level.scr_anim[ "generic" ][ "patrol_bored_patrolwalk" ] = %patrol_bored_patrolwalk;
level.scr_anim[ "generic" ][ "crouch_sprint" ] = %crouch_sprint;
level.scr_anim[ "generic" ][ "patrol_walk_and_twitch" ][0] = %patrol_bored_patrolwalk;
level.scr_anim[ "generic" ][ "patrol_walk_and_twitch" ][1] = %patrol_bored_patrolwalk_twitch;
level.scr_anim[ "generic" ][ "civilian_run_hunched_C" ] = %civilian_run_hunched_C;
level.scr_anim[ "generic" ][ "civilian_run_hunched_A" ] = %civilian_run_hunched_A;
level.scr_anim[ "generic" ][ "civilian_run_upright" ] = %civilian_run_upright;
level.scr_anim[ "generic" ][ "CornerCrR_alert_2_lean" ] = %CornerCrR_alert_2_lean;
level.scr_anim[ "generic" ][ "corner_standR_trans_OUT_8" ] = %corner_standR_trans_OUT_8;
level.scr_anim[ "generic" ][ "corner_standR_trans_CQB_OUT_8" ] = %corner_standR_trans_CQB_OUT_8;
level.scr_anim[ "generic" ][ "corner_standL_trans_OUT_6" ] = %corner_standL_trans_OUT_6;
level.scr_anim[ "generic" ][ "corner_standL_trans_CQB_OUT_6" ] = %corner_standL_trans_CQB_OUT_6;
level.scr_anim[ "generic" ][ "dumpster_climb_1" ] = %prague_dumpster_climb;
level.scr_anim[ "generic" ][ "ladder_climbup" ] = %ladder_climbup;
level.scr_anim[ "generic" ][ "jumpdown" ] = %traverse_jumpdown_56;
level.scr_anim[ "generic" ][ "prague_scaffold_climb_geton" ] = %prague_scaffold_climb_geton;
level.scr_anim[ "generic" ][ "prague_scaffold_climb_loop" ] = %prague_scaffold_climb_loop;
level.scr_anim[ "generic" ][ "prague_scaffold_climb_loop_fast" ] = %prague_scaffold_climb_loop_fast;
level.scr_anim[ "generic" ][ "prague_scaffold_climb_getoff" ] = %prague_scaffold_climb_getoff;
level.scr_anim[ "generic" ][ "jump_across_100_lunge" ] = %jump_across_100_lunge;
level.scr_anim[ "delta" ][ "jump_across" ] = %jump_across_100_spring;
level.scr_anim[ "delta" ][ "kick_grenade" ] = %stand_grenade_return_kick;
level.scr_anim[ "generic" ][ "breach_kick" ] = %breach_kick_kickerR1_enter;
level.scr_anim[ "generic" ][ "breach_enter_pre_idle" ][0]= %breach_kick_stackL1_idle;
level.scr_anim[ "generic" ][ "breach_enter" ] = %breach_kick_stackL1_enter;
level.scr_anim[ "generic" ][ "cornerR_idle" ][ 0 ] = %corner_standR_alert_idle;
level.scr_anim[ "generic" ][ "cornerL_idle" ][ 0 ] = %corner_standL_alert_idle;
level.scr_anim[ "generic" ][ "london_loader3_loading" ][ 0 ] = %london_loader3_loading;
level.scr_anim[ "generic" ][ "training_intro_foley_idle_talk_1" ] = %training_intro_foley_idle_talk_1;
level.scr_anim[ "generic" ][ "casual_stand_v2_twitch_radio" ] = %casual_stand_v2_twitch_radio;
level.scr_anim[ "generic" ][ "flee_run_shoot_behind" ] = %flee_run_shoot_behind;
level.scr_anim[ "generic" ][ "flee_stand_2_run_med" ] = %flee_stand_2_run_med;
level.scr_anim[ "generic" ][ "flee_stand_2_run_short" ] = %flee_stand_2_run_short;
level.scr_anim[ "generic" ][ "unarmed_cowerstand_react_2_crouch" ] = %unarmed_cowerstand_react_2_crouch;
level.scr_anim[ "generic" ][ "civilian_run_hunched_A" ] = %civilian_run_hunched_A;
level.scr_anim[ "generic" ][ "gas_run1" ] = %payback_pmc_sandstorm_stumble_1;
level.scr_anim[ "generic" ][ "gas_run2" ] = %payback_pmc_sandstorm_stumble_2;
level.scr_anim[ "generic" ][ "gas_run3" ] = %payback_pmc_sandstorm_stumble_3;
level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble_idle" ][ 0 ] = %DC_Burning_bunker_sit_idle;
level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ] = %DC_Burning_bunker_stumble;
level.scr_anim[ "generic" ][ "dc_burning_bunker_stumble" ] = %dc_burning_bunker_stumble;
level.scr_anim[ "generic" ][ "dc_burning_bunker_stumble_idle" ][ 0 ] = %DC_Burning_bunker_sit_idle;
level.scr_anim[ "generic" ][ "civilian_crawl_2" ] = %civilian_crawl_2;
level.scr_anim[ "generic" ][ "unarmed_cowerstand_react_2_crouch" ] = %unarmed_cowerstand_react_2_crouch;
level.scr_anim[ "generic" ][ "civilian_run_hunched_A" ] = %civilian_run_hunched_A;
level.scr_anim[ "generic" ][ "cqb_explosion_react" ] = %cqb_stand_react_B;
level.scr_anim[ "generic" ][ "civilian_crawl_1" ] = %civilian_crawl_1;
level.scr_anim[ "generic" ][ "civilian_crawl_1_death" ] = %civilian_crawl_1_death_b;
level.scr_anim[ "generic" ][ "civilian_crawl_2" ] = %civilian_crawl_2;
level.scr_anim[ "generic" ][ "civilian_crawl_2_death" ] = %dying_crawl_death_v3;
level.scr_anim[ "generic" ][ "coup_guard2_jeerA" ] = %coup_guard2_jeerA;
level.scr_anim[ "default_civilian" ][ "coup_guard2_jeerA" ] = %coup_guard2_jeerA;
level.scr_anim[ "generic" ][ "coup_guard2_jeerC" ] = %coup_guard2_jeerC;
level.scr_anim[ "generic" ][ "launchfacility_b_blast_door_seq_waveidle" ][ 0 ] = %launchfacility_b_blast_door_seq_waveidle;
level.scr_anim[ "generic" ][ "coverstand_hide_idle_wave01" ] = %coverstand_hide_idle_wave01;
level.scr_anim[ "generic" ][ "dying_crawl" ] = %dying_crawl;
level.scr_anim[ "generic" ][ "dying_crawl_death" ] = %dying_crawl_death_v1;
level.scr_anim[ "generic" ][ "deadguy_throw1" ] = %prague_bodydump_deadguy_throw1;
addNotetrack_customFunction( "generic", "body_splash", ::body_splash, "deadguy_throw1" );
level.scr_anim[ "generic" ][ "deadguy_throw2" ] = %prague_bodydump_deadguy_throw2;
addNotetrack_customFunction( "generic", "body_splash", ::body_splash, "deadguy_throw2" );
level.scr_anim[ "generic" ][ "bodydump_guy1" ] = %scout_sniper_bodydump_guy1;
level.scr_anim[ "generic" ][ "bodydump_guy2" ] = %scout_sniper_bodydump_guy2;
level.scr_anim[ "generic" ][ "paris_delta_deploy_flare_crouched" ] = %paris_delta_deploy_flare_crouched;
level.scr_anim[ "generic" ][ "casual_crouch_v2_idle" ][0]	= %casual_crouch_v2_idle;
level.scr_anim[ "generic" ][ "casual_crouch_twitch" ][0]	= %casual_crouch_twitch;
level.scr_anim[ "generic" ][ "cqb_stand_idle" ][0]	= %cqb_stand_idle;
level.scr_anim[ "generic" ][ "crouch_cover_stand_aim_straight" ][0]	= %crouch_cover_stand_aim_straight;
level.scr_anim[ "generic" ][ "readystand_idle" ][0]	= %readystand_idle;
level.scr_anim[ "generic" ][ "readystand_trans_2_run_8" ]	= %readystand_trans_2_run_8;
level.scr_anim[ "generic" ][ "readystand_trans_2_run_2" ]	= %readystand_trans_2_run_2;
level.scr_anim[ "generic" ][ "covercrouch_run_in_L" ]	= %covercrouch_run_in_L;
level.scr_anim[ "generic" ][ "run_2_crouch_90L" ]	= %run_2_crouch_90L;
level.scr_anim[ "delta" ][ "exposed_crouch_idle_twitch" ]	= %exposed_crouch_idle_twitch;
level.scr_anim[ "generic" ][ "unarmed_crouch_idle1" ]	= %unarmed_crouch_idle1;
level.scr_anim[ "generic" ][ "unarmed_cowercrouch_idle" ]	= %unarmed_cowercrouch_idle;
}
drone_deaths()
{
level.civ_runs = [];
level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_C;
level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_A;
level.civ_runs[ level.civ_runs.size ] = %civilian_run_upright;
level.drone_deaths = [];
level.drone_deaths[ level.drone_deaths.size ] = %stand_death_tumbleback;
level.drone_deaths[ level.drone_deaths.size ] = %run_death_fallonback;
level.drone_deaths[ level.drone_deaths.size ] = %run_death_roll;
level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_blowback;
level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_firing_02;
level.drone_deaths_f = [];
level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_forward_crumple;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_skid;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_02;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_03;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_legshot;
level.random_explosion_deaths = [];
level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %death_explosion_run_b_v1;
level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %death_explosion_run_b_v2;
level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %exposed_death_blowback;
level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %stand_death_tumbleback;
level.explosion_deaths = [];
level.explosion_deaths[ "u" ] = [];
level.explosion_deaths[ "u" ][ level.explosion_deaths[ "u" ].size ] = %death_explosion_up10;
level.explosion_deaths[ "f" ] = [];
level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v1;
level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v2;
level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v3;
level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v4;
level.explosion_deaths[ "b" ] = [];
level.explosion_deaths[ "b" ][ level.explosion_deaths[ "b" ].size ] = %death_explosion_run_b_v1;
level.explosion_deaths[ "b" ][ level.explosion_deaths[ "b" ].size ] = %death_explosion_run_b_v2;
level.explosion_deaths[ "l" ] = [];
level.explosion_deaths[ "l" ][ level.explosion_deaths[ "l" ].size ] = %death_explosion_run_l_v1;
level.explosion_deaths[ "l" ][ level.explosion_deaths[ "l" ].size ] = %death_explosion_run_l_v2;
level.explosion_deaths[ "r" ] = [];
level.explosion_deaths[ "r" ][ level.explosion_deaths[ "r" ].size ] = %death_explosion_run_r_v1;
level.explosion_deaths[ "r" ][ level.explosion_deaths[ "r" ].size ] = %death_explosion_run_r_v2;
level.scr_anim[ "generic" ][ "exposed_death_02" ] = %exposed_death_02;
level.scr_anim[ "generic" ][ "CornerCrR_alert_death_slideout" ] = %CornerCrR_alert_death_slideout;
level.scr_anim[ "generic" ][ "civilian_leaning_death" ] = %civilian_leaning_death;
level.scr_anim[ "generic" ][ "civilian_leaning_death_shot" ] = %civilian_leaning_death_shot;
level.scr_anim[ "generic" ][ "CornerCrL_death_side" ] = %CornerCrL_death_side;
level.scr_anim[ "generic" ][ "pistol_death_3" ] = %pistol_death_3;
level.scr_anim[ "generic" ][ "drone_stand_death" ] = %drone_stand_death;
level.scr_anim[ "generic" ][ "death_run_onfront" ] = %death_run_onfront;
level.scr_anim[ "generic" ][ "doorpeek_deathA" ] = %doorpeek_deathA;
level.scr_anim[ "generic" ][ "death_pose_on_desk" ] = %death_pose_on_desk;
level.scr_anim[ "generic" ][ "covercrouch_death_1" ] = %covercrouch_death_1;
level.scr_anim[ "generic" ][ "covercrouch_death_2" ] = %covercrouch_death_2;
level.scr_anim[ "generic" ][ "covercrouch_death_3" ] = %covercrouch_death_3;
level.scr_anim[ "generic" ][ "corner_standR_death_grenade_slump" ] = %corner_standR_death_grenade_slump;
level.scr_anim[ "generic" ][ "death_run_onfront" ] = %death_run_onfront;
level.scr_anim[ "generic" ][ "death_run_onfront" ] = %death_run_onfront;
level.scr_anim[ "generic" ][ "hostage_stand_idle" ][ 0 ] = %hostage_stand_idle;
level.scr_anim[ "generic" ][ "hostage_knees_idle" ][ 0 ] = %hostage_knees_idle;
level.scr_anim[ "generic" ][ "prague_deadguy_movement_01" ][ 0 ] = %prague_deadguy_movement_01;
level.scr_anim[ "generic" ][ "london_enemy_capture_enemy_death_01" ] = %london_enemy_capture_enemy_death_01;
level.scr_anim[ "generic" ][ "london_enemy_capture_enemy_death_04" ] = %london_enemy_capture_enemy_death_04;
level.scr_anim[ "generic" ][ "paris_rooftop_death_a" ] = %paris_rooftop_death_a;
level.scr_anim[ "generic" ][ "roadkill_cover_radio_soldier3" ][0] = %roadkill_cover_radio_soldier3;
level.scr_anim[ "generic" ][ "training_basketball_rest" ][0] = %training_basketball_rest;
level.scr_anim[ "generic" ][ "roadkill_humvee_map_sequence_quiet_idle" ][0] = %roadkill_humvee_map_sequence_quiet_idle;
level.scr_anim[ "generic" ][ "training_locals_groupB_guy1" ][0] = %training_locals_groupB_guy1;
level.scr_anim[ "generic" ][ "training_locals_groupB_guy2" ][0] = %training_locals_groupB_guy2;
level.scr_anim[ "generic" ][ "training_locals_groupA_guy1" ][0] = %training_locals_groupA_guy1;
level.scr_anim[ "generic" ][ "training_locals_groupA_guy2" ][0] = %training_locals_groupA_guy2;
level.scr_anim[ "generic" ][ "training_locals_kneel" ][0] = %training_locals_kneel;
level.scr_anim[ "generic" ][ "casual_stand_idle" ][0] = %casual_stand_idle;
level.scr_anim[ "generic" ][ "casual_stand_v2_idle" ][0] = %casual_stand_v2_idle;
level.scr_anim[ "generic" ][ "casual_crouch_idle" ][0] = %casual_crouch_idle;
level.scr_anim[ "generic" ][ "casual_crouch_point" ][0] = %casual_crouch_point;
level.scr_anim[ "generic" ][ "training_intro_foley_idle_1" ][0] = %training_intro_foley_idle_1;
level.scr_anim[ "generic" ][ "dead_body_floating_1" ][0] = %dead_body_floating_1;
level.scr_anim[ "generic" ][ "dead_body_floating_2" ][0] = %dead_body_floating_2;
level.scr_anim[ "generic" ][ "dead_body_floating_3" ][0] = %dead_body_floating_3;
level.scr_anim[ "generic" ][ "harbor_floating_idle_02" ][0] = %harbor_floating_idle_02;
level.scr_anim[ "generic" ][ "harbor_floating_idle_03" ][0] = %harbor_floating_idle_03;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v09" ][0] = %paris_npc_dead_poses_v09;
level.scr_anim[ "generic" ][ "ny_harbor_doorway_headsmash_enemy_deadpose" ][0] = %ny_harbor_doorway_headsmash_enemy_deadpose;
level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_assistant" ][0] = %hijack_hallway_dead_pose_assistant;
level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_agent" ][0] = %hijack_hallway_dead_pose_agent;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v02" ][0] = %paris_npc_dead_poses_v02;
level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_terrorist" ][0] = %hijack_hallway_dead_pose_terrorist;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v22" ][0] = %paris_npc_dead_poses_v22;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v23" ][0] = %paris_npc_dead_poses_v23;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v24_chair_sq" ][0] = %paris_npc_dead_poses_v24_chair_sq;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v07" ][0] = %paris_npc_dead_poses_v07;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v20" ][0] = %paris_npc_dead_poses_v20;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v10" ][0] = %paris_npc_dead_poses_v10;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v01" ][0] = %paris_npc_dead_poses_v01;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v17" ][0] = %paris_npc_dead_poses_v17;
level.scr_anim[ "generic" ][ "arcadia_ending_sceneA_dead_civilian" ][0] = %arcadia_ending_sceneA_dead_civilian;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v05" ][0] = %paris_npc_dead_poses_v05;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v11" ][0] = %paris_npc_dead_poses_v11;
level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v14" ][0] = %paris_npc_dead_poses_v14;
level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_idle_B" ][0] = %dcburning_elevator_corpse_idle_B;
level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_bump_B" ] = %dcburning_elevator_corpse_bump_B;
level.scr_anim[ "generic" ][ "prague_mourner_woman_idle" ][0] = %prague_mourner_woman_idle;
level.scr_anim[ "generic" ][ "prague_mourner_man_idle" ][0] = %prague_mourner_man_idle;
}
KNIFE_ATTACK_MODEL =	"weapon_parabolic_knife";
KNIFE_ATTACK_TAG =	"TAG_INHAND";
GUN_ATTACK_MODEL =	"weapon_usp_silencer";
TAG_WEAPON_RIGHT =	"TAG_WEAPON_RIGHT";
WEAPON_BINOC_MODEL = "weapon_binocular";
TAG_BINOC_WEAPON_RIGHT = "TAG_WEAPON_RIGHT";
group_scenes()
{
level.scr_anim[ "price" ][ "intro" ] = %prague_intro_getinwater_price;
level.scr_anim[ "delta" ][ "intro" ] = %prague_intro_getinwater_soap;
addNotetrack_customFunction( "price", "splash", ::splash, "intro" );
addNotetrack_customFunction( "delta", "splash", ::splash, "intro" );
level.scr_anim[ "generic" ][ "swim_idle" ][0] = %prague_intro_swim_idle_01;
level.scr_anim[ "generic" ][ "swim" ] = %prague_intro_swim_breaststroke_01;
level.scr_anim[ "generic" ][ "swim_fast" ] = %prague_intro_swim_breaststroke_02;
addNotetrack_customFunction( "price", "exhale", ::price_exhales );
addNotetrack_customFunction( "price", "cigar_on", ::price_puffs );
level.scr_sound[ "price" ][ "prague_pri_letsmove2" ] = "prague_pri_letsmove2";
level.scr_anim[ "delta" ][ "swim_up" ] = %prague_intro_swim_surfacing_soap;
level.scr_anim[ "price" ][ "swim_up" ] = %prague_intro_swim_surfacing_price;
level.scr_anim[ "player_rig" ][ "swim_up" ] = %prague_intro_swim_surfacing_player;
level.scr_anim[ "guy1" ][ "mean_guard" ] = %prague_intro_dock_meanguard_resistance1;
level.scr_anim[ "guy2" ][ "mean_guard" ] = %prague_intro_dock_meanguard_resistance2;
level.scr_anim[ "guard" ][ "mean_guard" ] = %prague_intro_dock_meanguard_guard;
level.scr_anim[ "r0" ][ "peptalk" ] = %prague_peptalk_rebel_1;
level.scr_anim[ "r1" ][ "peptalk" ] = %prague_peptalk_rebel_2;
level.scr_anim[ "r2" ][ "peptalk" ] = %prague_peptalk_rebel_3;
level.scr_anim[ "r3" ][ "peptalk" ] = %prague_peptalk_rebel_4;
level.scr_anim[ "r4" ][ "peptalk" ] = %prague_peptalk_talker;
level.scr_anim[ "dog_scare_1" ][ "dog_scare" ] = %prague_dog_scare_b;
level.scr_anim[ "dog_scare_2" ][ "dog_scare" ] = %prague_dog_scare_a;
level.scr_anim[ "shooter1" ][ "deadguy_shot" ] = %prague_deadguy_shooter1;
level.scr_anim[ "shooter2" ][ "deadguy_shot" ] = %prague_deadguy_shooter2;
level.scr_anim[ "victim" ][ "deadguy_shot" ] = %prague_deadguy_shot;
level.scr_anim[ "victim" ][ "deadguy_idle" ][0] = %prague_deadguy_idle;
level.scr_anim[ "delta" ][ "rooftop_kill" ] = %prague_sniper_roof_kill_rebel;
level.scr_anim[ "enemy" ][ "rooftop_kill" ] = %prague_sniper_roof_kill_sniper;
level.scr_anim[ "enemy" ][ "rooftop_kill_idle" ][0] = %prague_sniper_roof_kill_idle;
addNotetrack_customFunction( "enemy", "stab", ::stab_fx_function, "rooftop_kill" );
addNotetrack_customFunction( "enemy", "stab", ::turn_off_light, "rooftop_kill" );
addNotetrack_customFunction( "enemy", "stab", ::hide_roof_victim, "rooftop_kill" );
level.scr_anim[ "delta" ][ "new_ally_kill" ] = %prague_stealth_kill_n_catch_soap;
level.scr_anim[ "enemy" ][ "new_ally_kill" ] = %prague_stealth_kill_n_catch_guard;
addNotetrack_customFunction( "enemy", "dead", ::ai_ignores_everything, "new_ally_kill" );
addNotetrack_attach( "delta", "prague_pistol_pullout", GUN_ATTACK_MODEL, TAG_WEAPON_RIGHT, "new_ally_kill" );
addNotetrack_detach( "delta", "prague_pistol_putaway", GUN_ATTACK_MODEL, TAG_WEAPON_RIGHT, "new_ally_kill" );
addNotetrack_animsound( "delta", "new_ally_kill", "fire", "weap_usp45sd_fire_npc" );
addNotetrack_customFunction( "delta", "fire", ::sandman_shoot_pistol, "new_ally_kill" );
level.scr_anim[ "generic" ][ "prone_idle" ][ 0 ] = %prone_aim_idle;
level.scr_anim[ "generic" ][ "prone_to_stand" ] = %hunted_pronehide_2_stand_v4;
level.scr_anim[ "generic" ][ "prone_to_stand_two" ] = %prone_2_stand;
level.scr_anim[ "generic" ][ "deadbody_check" ] = %hunted_woundedhostage_check_soldier;
level.scr_anim[ "generic" ][ "deadbody_check_end" ] = %hunted_woundedhostage_check_soldier_end;
level.scr_anim[ "generic" ][ "deadbody_check_body_start" ] = %hunted_woundedhostage_idle_start;
level.scr_anim[ "generic" ][ "deadbody_check_body" ] = %hunted_woundedhostage_check_hostage;
level.scr_anim[ "generic" ][ "death_rooftop_a" ] = %death_rooftop_a;
level.scr_anim[ "generic" ][ "death_rooftop_b" ] = %death_rooftop_b;
level.scr_anim[ "generic" ][ "death_rooftop_c" ] = %death_rooftop_c;
level.scr_anim[ "generic" ][ "death_rooftop_d" ] = %death_rooftop_d;
level.scr_anim[ "generic" ][ "death_rooftop_e" ] = %death_rooftop_e;
level.scr_anim[ "delta" ][ "hunted_pronehide_jumpback" ] = %hunted_pronehide_jumpback;
level.scr_anim[ "generic" ][ "hunted_pronehide_jumpback" ] = %hunted_pronehide_jumpback;
level.scr_anim[ "price" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_price;
level.scr_anim[ "pricehelper" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_pricehelper;
level.scr_anim[ "delta" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_soap;
level.scr_anim[ "soaphelper" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_soaphelper;
level.scr_anim[ "kamarov" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_kamarov_helpplayer;
addNotetrack_customFunction( "pricehelper", "gun_off", ::notetrack_gun_remove, "sewer_get_out" );
addNotetrack_customFunction( "soaphelper", "gun_off", ::notetrack_gun_remove, "sewer_get_out" );
addNotetrack_customFunction( "price", "gun_on", ::notetrack_gun_recall, "sewer_get_out" );
addNotetrack_customFunction( "delta", "gun_on", ::notetrack_gun_recall, "sewer_get_out" );
level.scr_anim[ "kamarov" ][ "sewer_get_out_idle" ][0] = %prague_intro_sewer_helpout_kamarov_waitidle;
level.scr_anim[ "pricehelper" ][ "sewer_get_out_idle" ][0] = %prague_intro_sewer_helpout_pricehelper_idle;
level.scr_anim[ "soaphelper" ][ "sewer_get_out_idle" ][0] = %prague_intro_sewer_helpout_soaphelper_idle;
level.scr_anim[ "kamarov" ][ "flare_pop" ] = %prague_intro_sewer_helpout_kamarov_walk2water;
level.scr_anim[ "generic" ][ "flare_walk" ] = %prague_kamarov_flare_walk;
level.scr_anim[ "generic" ][ "flare_idle" ][0] = %prague_sewer_turnaround_kamarov_idle;
level.scr_anim[ "generic" ][ "price_sewer_idle" ][0] = %prague_sewer_turnaround_price_idle;
level.scr_anim[ "generic" ][ "prague_sewer_turnaround_price" ] = %prague_sewer_turnaround_price;
level.scr_anim[ "generic" ][ "prague_sewer_turnaround_kamarov" ] = %prague_sewer_turnaround_kamarov;
level.scr_anim[ "generic" ][ "prague_kamarov_flare_stairs" ] = %prague_kamarov_flare_stairs;
level.scr_anim[ "generic" ][ "unarmed_idle" ][0] = %unarmed_cowerstand_idle;
level.scr_anim[ "generic" ][ "unarmed_walk" ] = %unarmed_walk_slow;
}
#using_animtree( "dog" );
dog()
{
level.scr_anim[ "generic" ][ "sniper_escape_dog_fence" ] = %sniper_escape_dog_fence;
level.scr_anim[ "generic" ][ "german_shepherd_attackidle_growl" ] = %german_shepherd_attackidle_growl;
level.scr_anim[ "generic" ][ "german_shepherd_attackidle_bark" ] = %german_shepherd_attackidle_bark;
level.scr_anim[ "generic" ][ "german_shepherd_attackidle_once" ] = %german_shepherd_attackidle_b;
level.scr_anim[ "generic" ][ "german_shepherd_attackidle" ][ 0 ] = %german_shepherd_attackidle_b;
level.scr_anim[ "generic" ][ "german_shepherd_attackidle_b" ][ 0 ] = %german_shepherd_attackidle_b;
level.scr_anim[ "generic" ][ "german_shepherd_run_start" ] = %german_shepherd_run_start;
level.scr_anim[ "generic" ][ "eat" ][ 0 ] = %german_shepherd_eating;
}
#using_animtree( "vehicles" );
vehicles()
{
level.scr_animtree[ "boat" ] = #animtree;
level.scr_model[ "boat" ] = "com_boat_fishing_1";
level.scr_animtree[ "mi17" ] = #animtree;
level.scr_model[ "mi17" ] = "vehicle_mi17_woodland_fly_cheap";
level.scr_anim[ "mi17" ][ "airdrop" ] = %prague_drop_mi17;
level.scr_anim[ "mi17" ][ "airdrop_idle" ] = %prague_idle_mi17;
level.scr_anim[ "mi17" ][ "prague_drop_btr" ] = %prague_drop_mi17;
level.scr_animtree[ "airdrop_rope" ] = #animtree;
level.scr_model[ "airdrop_rope" ] = "com_prague_rope_animated";
level.scr_anim[ "airdrop_rope" ][ "airdrop" ] = %prague_drop_rope;
level.scr_anim[ "airdrop_rope" ][ "airdrop_idle" ] = %prague_idle_rope;
level.scr_anim[ "airdrop_rope" ][ "prague_drop_btr" ] = %prague_drop_rope;
level.scr_animtree[ "btr" ] = #animtree;
level.scr_model[ "btr" ] = "vehicle_btr80";
level.scr_anim[ "btr" ][ "airdrop" ] = %prague_drop_btr;
level.scr_anim[ "btr" ][ "airdrop_idle" ] = %prague_idle_btr;
level.scr_anim[ "btr" ][ "prague_drop_btr" ] = %prague_drop_btr;
addNotetrack_customFunction( "btr", "impact1", ::jeremy_btr_crash_sounds, "prague_drop_btr" );
addnotetrack_startfxontag( "btr", "impact4", "prague_drop_btr", "tank_impact_exaggerated", "origin_animate_jnt" );
}
#using_animtree( "generic_human" );
dialogue()
{
level.scr_radio[ "prague_pri_welcome" ] = "prague_pri_welcome";
level.scr_sound[ "price" ][ "prague_pri_welcome" ] = "prague_pri_welcome";
level.scr_sound[ "delta" ][ "prague_pri_halfaclick" ] = "prague_pri_halfaclick";
level.scr_sound[ "price" ][ "prague_pri_letsmove" ] = "prague_pri_letsmove";
level.scr_sound[ "price" ][ "prague_pri_chitchat" ] = "prague_pri_chitchat";
level.scr_sound[ "delta" ][ "prague_mct_seethat" ] = "prague_mct_seethat";
level.scr_sound[ "delta" ][ "prague_mct_intelwasoff" ] = "prague_mct_intelwasoff";
level.scr_sound[ "delta" ][ "prague_mct_letsgoyuri" ] = "prague_mct_letsgoyuri";
level.scr_sound[ "kamarov" ][ "prague_kmv_whattookyou" ] = "prague_kmv_whattookyou";
level.scr_sound[ "kamarov" ][ "prague_kmv_uprising" ] = "prague_kmv_uprising";
level.scr_sound[ "kamarov" ][ "prague_kmv_thisfar" ] = "prague_kmv_thisfar";
level.scr_face[ "kamarov" ][ "prague_kmv_thisfar" ] = %prague_intro_sewer_helpout_kamarov_helpplayer_thisfar;
level.scr_sound[ "delta" ][ "prague_snd_holdup2targets" ] = "prague_snd_holdup2targets";
level.scr_face[ "delta" ][ "prague_snd_holdup2targets" ] = %prague_holdup2targets_soap_face;
}
radio()
{
level.scr_radio[ "prague_pri_compromised" ] = "prague_pri_compromised";
level.scr_radio[ "prague_snd_holdup" ]	= "prague_snd_holdup";
level.scr_radio[ "prague_snd_youhearthat" ]	= "prague_snd_youhearthat";
level.scr_radio[ "prague_snd_enemyconvoy" ]	= "prague_snd_enemyconvoy";
level.scr_radio[ "prague_snd_toomany" ]	= "prague_snd_toomany";
level.scr_radio[ "prague_snd_getdown" ]	= "prague_snd_getdown";
level.scr_radio[ "prague_snd_insidebuilding" ]	= "prague_snd_insidebuilding";
level.scr_radio[ "prague_snd_dontdostupid" ]	= "prague_snd_dontdostupid";
level.scr_radio[ "prague_stop_1" ]	= "prague_snd_stop";
level.scr_radio[ "Prague_Stop_2" ]	= "prague_snd_hold";
level.scr_radio[ "prague_stop_3" ]	= "prague_snd_holdup2";
level.scr_radio[ "prague_stop_4" ]	= "prague_snd_wait";
level.scr_radio[ "prague_stop_5" ]	= "prague_snd_slowdown";
level.scr_radio[ "prague_go_1" ]	= "prague_snd_letsgo2";
level.scr_radio[ "prague_go_2" ]	= "prague_snd_letsmove2";
level.scr_radio[ "prague_go_3" ]	= "prague_snd_onme";
level.scr_radio[ "prague_go_4" ]	= "prague_snd_followme";
level.scr_radio[ "prague_go_5" ]	= "prague_snd_move";
level.scr_radio[ "prague_go_6" ]	= "prague_snd_moveup";
level.scr_radio[ "prague_killfirm_player_1" ]	= "prague_snd_goodshot";
level.scr_radio[ "prague_killfirm_player_2" ]	= "prague_snd_niceshot";
level.scr_radio[ "prague_killfirm_player_3" ]	= "prague_snd_nice";
level.scr_radio[ "prague_killfirm_other_1" ]	= "prague_snd_hesdown";
level.scr_radio[ "prague_killfirm_other_2" ]	= "prague_snd_targetdown";
level.scr_radio[ "prague_killfirm_other_3" ]	= "prague_snd_gotem";
level.scr_radio[ "prague_killfirm_other_4" ]	= "prague_snd_thatsakill";
level.scr_radio[ "prague_mct_stayclose" ]	= "prague_mct_stayclose";
level.scr_radio[ "prague_clear_1" ]	= "prague_snd_allclear2";
level.scr_radio[ "prague_clear_2" ]	= "prague_snd_clear";
level.scr_radio[ "prague_clear_3" ]	= "prague_snd_targetsneutralized";
level.scr_radio[ "prague_spotted_1" ]	= "prague_snd_returnfire";
level.scr_radio[ "prague_spotted_2" ]	= "prague_snd_openfire";
level.scr_radio[ "prague_spotted_3" ]	= "prague_snd_spottedtakeout";
level.scr_radio[ "prague_recover_1" ]	= "prague_snd_morecareful";
level.scr_radio[ "prague_recover_2" ]	= "prague_snd_sloppy";
level.scr_radio[ "prague_recover_3" ]	= "prague_snd_remindme";
level.scr_radio[ "prague_snd_holdup2targets" ] = "prague_snd_holdup2targets";
level.scr_radio[ "prague_snd_staylow" ] = "prague_snd_staylow";
level.scr_radio[ "prague_snd_grabcover" ] = "prague_snd_grabcover";
level.scr_radio[ "prague_mct_okletsgo" ] = "prague_mct_okletsgo";
level.scr_radio[ "prague_mct_getrough" ] = "prague_mct_getrough";
level.scr_radio[ "prague_snd_church" ] = "prague_snd_church";
level.scr_radio[ "prague_snd_gettocover" ] = "prague_snd_gettocover";
level.scr_radio[ "prague_snd_bythestatue" ] = "prague_snd_bythestatue";
level.scr_radio[ "prague_snd_getasshere" ] = "prague_snd_getasshere";
level.scr_radio[ "prague_snd_forgetthis" ] = "prague_snd_forgetthis";
level.scr_radio[ "prague_snd_outofcourtyard" ] = "prague_snd_outofcourtyard";
level.scr_radio[ "prague_snd_thisway2" ] = "prague_snd_thisway2";
level.scr_radio[ "prague_snd_wereclear" ] = "prague_snd_wereclear";
level.scr_radio[ "prague_snd_advancing" ] = "prague_snd_advancing";
level.scr_radio[ "prague_snd_waitforem" ] = "prague_snd_waitforem";
level.scr_radio[ "prague_snd_armoronroad" ] = "prague_snd_armoronroad";
level.scr_radio[ "prague_snd_onme2" ] = "prague_snd_onme2";
level.scr_radio[ "prague_snd_roadsanogo" ] = "prague_snd_roadsanogo";
level.scr_radio[ "prague_snd_moretargets" ] = "prague_snd_moretargets";
level.scr_sound[ "delta" ][ "prague_snd_theydontknow" ] = "prague_snd_theydontknow";
level.scr_face[ "delta" ][ "prague_snd_theydontknow" ] = %prague_snd_theydontknow;
level.scr_sound[ "delta" ][ "prague_snd_niceandeasy" ] = "prague_snd_niceandeasy";
level.scr_face[ "delta" ][ "prague_snd_niceandeasy" ] = %prague_snd_niceandeasy;
level.scr_radio[ "prague_snd_gotcompany" ] = "prague_snd_gotcompany";
level.scr_radio[ "prague_snd_jumpgun" ] = "prague_snd_jumpgun";
level.scr_radio[ "prague_snd_smokeem" ] = "prague_snd_smokeem";
level.scr_radio[ "prague_snd_covertracks" ] = "prague_snd_covertracks";
level.scr_radio[ "prague_snd_improvise" ] = "prague_snd_improvise";
level.scr_radio[ "prague_snd_downnow" ] = "prague_snd_downnow";
level.scr_radio[ "prague_snd_moveit" ] = "prague_snd_moveit";
level.scr_radio[ "prague_mct_staydown" ] = "prague_mct_staydown";
level.scr_radio[ "prague_mct_woah" ] = "prague_mct_woah";
level.scr_radio[ "prague_mct_getsetup" ] = "prague_mct_getsetup";
level.scr_radio[ "prague_mct_pricecopy" ] = "prague_mct_pricecopy";
level.scr_radio[ "prague_pri_goahead" ] = "prague_pri_goahead";
level.scr_radio[ "prague_mct_lotsofmovement" ] = "prague_mct_lotsofmovement";
level.scr_radio[ "prague_pri_eyeout" ] = "prague_pri_eyeout";
level.scr_radio[ "prague_mct_fiveguys" ] = "prague_mct_fiveguys";
level.scr_radio[ "prague_mct_sittight" ] = "prague_mct_sittight";
level.scr_radio[ "prague_mct_splittingup" ] = "prague_mct_splittingup";
level.scr_radio[ "prague_mct_snipersfirst" ] = "prague_mct_snipersfirst";
level.scr_radio[ "prague_mct_alertothers" ] = "prague_mct_alertothers";
level.scr_radio[ "prague_mct_takeoutsnipers" ] = "prague_mct_takeoutsnipers";
level.scr_radio[ "prague_mct_dogandfriend" ] = "prague_mct_dogandfriend";
level.scr_radio[ "prague_mct_lockingdown" ] = "prague_mct_lockingdown";
level.scr_radio[ "prague_mct_followme" ] = "prague_mct_followme";
level.scr_radio[ "prague_mct_bytables" ] = "prague_mct_bytables";
level.scr_radio[ "prague_mct_12oclock" ] = "prague_mct_12oclock";
level.scr_radio[ "prague_mct_yougetone" ] = "prague_mct_yougetone";
level.scr_radio[ "prague_mct_onyou" ] = "prague_mct_onyou";
level.scr_radio[ "prague_mct_eyeshigh" ] = "prague_mct_eyeshigh";
level.scr_radio[ "prague_mct_dontmove" ] = "prague_mct_dontmove";
level.scr_radio[ "prague_mct_easy" ] = "prague_mct_easy";
level.scr_radio[ "prague_mct_sharpish" ] = "prague_mct_sharpish";
level.scr_radio[ "prague_mct_getready" ] = "prague_mct_getready";
level.scr_radio[ "prague_mct_go" ] = "prague_mct_go";
level.scr_radio[ "prague_mct_goodnight" ] = "prague_mct_goodnight";
level.scr_sound[ "delta" ][ "prague_mct_holdup" ] = "prague_mct_holdup";
level.scr_face[ "delta" ][ "prague_holdup_soap_face" ] = %prague_holdup_soap_face;
level.scr_sound[ "delta" ][ "prague_mct_20plus" ] = "prague_mct_20plus";
level.scr_face[ "delta" ][ "prague_mct_20plus" ] = %prague_mct_20plus;
level.scr_radio[ "prague_pri_soapposition" ] = "prague_pri_soapposition";
level.scr_radio[ "prague_mct_rallypoint" ] = "prague_mct_rallypoint";
level.scr_radio[ "prague_pri_fromwest" ] = "prague_pri_fromwest";
level.scr_radio[ "prague_mct_roger" ] = "prague_mct_roger";
level.scr_radio[ "prague_mct_scout" ] = "prague_mct_scout";
level.scr_sound[ "delta" ][ "prague_mct_scout" ] = "prague_mct_scout";
level.scr_radio[ "prague_mct_sniperyuri" ] = "prague_mct_sniperyuri";
level.scr_radio[ "prague_mct_takehimdown" ] = "prague_mct_takehimdown";
level.scr_radio[ "prague_mct_wait" ] = "prague_mct_wait";
level.scr_radio[ "prague_mct_lightswitch" ] = "prague_mct_lightswitch";
level.scr_sound[ "delta" ][ "prague_mct_lightswitch" ] = "prague_mct_lightswitch";
level.scr_radio[ "prague_pri_aimstraight" ] = "prague_pri_aimstraight";
level.scr_radio[ "prague_mct_onesdown" ] = "prague_mct_onesdown";
level.scr_sound[ "delta" ][ "prague_mct_onesdown" ] = "prague_mct_onesdown";
level.scr_radio[ "prague_pri_dontworry" ] = "prague_pri_dontworry";
level.scr_radio[ "prague_pri_gettochurch" ] = "prague_pri_gettochurch";
level.scr_radio[ "prague_mct_letsgoyuri3" ] = "prague_mct_letsgoyuri3";
level.scr_radio[ "prague_pri_gettocover" ] = "prague_pri_gettocover";
level.scr_radio[ "prague_mct_nowherefast" ] = "prague_mct_nowherefast";
level.scr_radio[ "prague_mct_getanrpg" ] = "prague_mct_getanrpg";
level.scr_radio[ "prague_mct_getanrpg" ] = "prague_mct_getanrpg";
level.scr_radio[ "prague_mct_takeoutarmor" ] = "prague_mct_takeoutarmor";
level.scr_radio[ "prague_mct_takeout" ] = "prague_mct_takeout";
level.scr_radio[ "prague_mct_userpg" ] = "prague_mct_userpg";
level.scr_radio[ "prague_mct_hitthatthing" ] = "prague_mct_hitthatthing";
level.scr_radio[ "prague_mct_itsdown" ] = "prague_mct_itsdown";
level.scr_radio[ "prague_pri_getoffroad" ] = "prague_pri_getoffroad";
level.scr_radio[ "prague_mct_fallback" ] = "prague_mct_fallback";
level.scr_radio[ "prague_mct_goleftgoleft" ] = "prague_mct_goleftgoleft";
level.scr_radio[ "prague_mct_getinbuilding" ] = "prague_mct_getinbuilding";
level.scr_radio[ "prague_mct_getoverhere2" ] = "prague_mct_getoverhere2";
level.scr_radio[ "prague_mct_getoverhere" ] = "prague_mct_getoverhere";
level.scr_radio[ "prague_mct_offstreetnow" ] = "prague_mct_offstreetnow";
level.scr_radio[ "prague_mct_whatareyoudoing" ] = "prague_mct_whatareyoudoing";
level.scr_radio[ "prague_pri_yurioffroad" ] = "prague_pri_yurioffroad";
level.scr_radio[ "prague_mct_onourside" ] = "prague_mct_onourside";
level.scr_radio[ "prague_mct_bringingit" ] = "prague_mct_bringingit";
level.scr_radio[ "prague_mct_friendlies" ] = "prague_mct_friendlies";
level.scr_radio[ "prague_pri_soapstatus" ] = "prague_pri_soapstatus";
level.scr_radio[ "prague_mct_tiptop" ] = "prague_mct_tiptop";
level.scr_radio[ "prague_mct_findaway" ] = "prague_mct_findaway";
level.scr_radio[ "prague_pri_goodluck" ] = "prague_pri_goodluck";
level.scr_radio[ "prague_mct_throughhere2" ] = "prague_mct_throughhere2";
level.scr_radio[ "prague_mct_coveroursix" ] = "prague_mct_coveroursix";
level.scr_radio[ "prague_mct_takepoint" ] = "prague_mct_takepoint";
level.scr_radio[ "prague_mct_scoutahead" ] = "prague_mct_scoutahead";
level.scr_radio[ "prague_mct_takemuchmore" ] = "prague_mct_takemuchmore";
level.scr_radio[ "prague_mct_getrough" ] = "prague_mct_getrough";
level.scr_radio[ "prague_mct_okletsgo" ] = "prague_mct_okletsgo";
level.scr_radio[ "prague_mct_dothislively" ] = "prague_mct_dothislively";
level.scr_radio[ "prague_mct_turretgunners" ] = "prague_mct_turretgunners";
level.scr_radio[ "prague_mct_flankthem" ] = "prague_mct_flankthem";
level.scr_radio[ "prague_mct_flankturrets" ] = "prague_mct_flankturrets";
level.scr_radio[ "prague_mct_fromalcove" ] = "prague_mct_fromalcove";
level.scr_radio[ "prague_mct_theyredown" ] = "prague_mct_theyredown";
level.scr_radio[ "prague_mct_moveup" ] = "prague_mct_moveup";
level.scr_radio[ "prague_mct_thechurch" ] = "prague_mct_thechurch";
level.scr_radio[ "prague_mct_thechurch" ] = "prague_mct_thechurch";
level.scr_radio[ "prague_snd_gettocover" ] = "prague_snd_gettocover";
level.scr_radio[ "prague_snd_bythestatue" ] = "prague_snd_bythestatue";
level.scr_radio[ "prague_snd_getasshere" ] = "prague_snd_getasshere";
level.scr_radio[ "prague_snd_outofcourtyard" ] = "prague_snd_outofcourtyard";
level.scr_radio[ "prague_snd_thisway2" ] = "prague_snd_thisway2";
level.scr_radio[ "prague_mct_move" ] = "prague_mct_move";
level.scr_radio[ "prague_mct_copythat" ] = "prague_mct_copythat";
level.scr_radio[ "prague_mct_takenprisoners" ] = "prague_mct_takenprisoners";
level.scr_radio[ "prague_mct_hidebodies" ] = "prague_mct_hidebodies";
level.scr_radio[ "prague_mct_taketheother" ] = "prague_mct_taketheother";
level.scr_radio[ "prague_mct_tablesforcover" ] = "prague_mct_tablesforcover";
level.scr_radio[ "prague_mct_throughhere" ] = "prague_mct_throughhere";
level.scr_radio[ "prague_mct_easy" ] = "prague_mct_easy";
level.scr_radio[ "prague_mct_move" ] = "prague_mct_move";
level.scr_radio[ "prague_mct_morehostiles" ] = "prague_mct_morehostiles";
level.scr_radio[ "prague_mct_inposition" ] = "prague_mct_inposition";
level.scr_radio[ "prague_mct_yougotit" ] = "prague_mct_yougotit";
level.scr_radio[ "prague_mct_easynow" ] = "prague_mct_easynow" ;
level.scr_radio[ "prague_pri_contact" ] = "prague_pri_contact";
level.scr_radio[ "prague_pri_movingfaster" ] = "prague_pri_movingfaster";
level.scr_radio[ "prague_pri_singlefile" ] = "prague_pri_singlefile";
level.scr_radio[ "prague_pri_useboats" ] = "prague_pri_useboats";
level.scr_radio[ "prague_pri_easy" ] = "prague_pri_easy";
level.scr_radio[ "prague_pri_letthempass" ] = "prague_pri_letthempass";
level.scr_radio[ "prague_pri_okay" ] = "prague_pri_okay";
level.scr_radio[ "prague_pri_go" ] = "prague_pri_go";
level.scr_radio[ "prague_pri_guarddown" ] = "prague_pri_guarddown";
level.scr_radio[ "prague_pri_getcomfortable" ] = "prague_pri_getcomfortable";
level.scr_radio[ "prague_mct_truckcoming" ] = "prague_mct_truckcoming";
level.scr_radio[ "prague_mct_belltower" ] = "prague_mct_belltower";
level.scr_radio[ "prague_mct_btronright" ] = "prague_mct_btronright" ;
level.scr_radio[ "prague_mct_tothestatue" ] = "prague_mct_tothestatue" ;
level.scr_radio[ "prague_mct_fallback" ] = "prague_mct_fallback" ;
level.scr_radio[ "prague_mct_getinbuilding" ] = "prague_mct_getinbuilding" ;
level.scr_radio[ "prague_mct_getoverhere" ] = "prague_mct_getoverhere" ;
level.scr_radio[ "prague_mct_whatareyoudoing" ] = "prague_mct_whatareyoudoing" ;
level.scr_radio[ "prague_mct_helosinbound" ] = "prague_mct_helosinbound" ;
level.scr_radio[ "prague_mct_onourside" ] = "prague_mct_onourside" ;
level.scr_radio[ "prague_mct_genocide" ] = "prague_mct_genocide" ;
level.scr_radio[ "prague_snd_outofcourtyard" ] = "prague_snd_outofcourtyard" ;
level.scr_radio[ "prague_mct_keepmoving" ] = "prague_mct_keepmoving" ;
level.scr_radio[ "prague_mct_waitformygo" ] = "prague_mct_waitformygo" ;
level.scr_radio[ "prague_mct_getcloser" ] = "prague_mct_getcloser" ;
level.scr_radio[ "prague_mct_now" ] = "prague_mct_now" ;
level.scr_radio[ "prague_mct_covertracks" ] = "prague_mct_covertracks" ;
level.scr_radio[ "prague_mct_getsetup" ] = "prague_mct_getsetup" ;
level.scr_radio[ "prague_mct_letsgoyuri2" ] = "prague_mct_letsgoyuri2" ;
level.scr_radio[ "prague_mct_rooftopfirst" ] = "prague_mct_rooftopfirst";
level.scr_radio[ "prague_mct_snipersrooftop" ] = "prague_mct_snipersrooftop";
level.scr_radio[ "prague_pri_underdocks" ] = "prague_pri_underdocks";
level.scr_radio[ "prague_mct_waithere" ] = "prague_mct_waithere";
level.scr_radio[ "prague_mct_lightswitch" ] = "prague_mct_lightswitch";
level.scr_radio[ "prague_pri_aimstraight" ] = "prague_pri_aimstraight";
level.scr_radio[ "prague_pri_gettochurch" ] = "prague_pri_gettochurch";
level.scr_radio[ "prague_mct_letsgoyuri3" ] = "prague_mct_letsgoyuri3";
level.scr_sound[ "detpack_explo_wood" ] = "detpack_explo_wood";
level.scr_sound[ "detpack_explo_wood_debris" ] = "detpack_explo_wood_debris";
level.scr_sound[ "elm_thunder_distant" ] = "elm_thunder_distant";
level.scr_sound[ "elm_thunder_strike" ] = "elm_thunder_strike";
}
#using_animtree( "generic_human" );
player()
{
level.scr_animtree[ "player_rig" ] = #animtree;
level.scr_model[ "player_rig" ] = "viewhands_player_yuri_europe";
level.scr_anim[ "player_rig" ][ "sewer_get_out" ] = %prague_intro_sewer_helpout_player;
}
#using_animtree( "vehicles" );
tank_crush_anims()
{
level.scr_animtree[ "tank_crush" ] = #animtree;
level.scr_anim[ "truck" ][ "tank_crush" ] = %pickup_tankcrush_front;
level.scr_anim[ "tank" ][ "tank_crush" ] = %tank_tankcrush_front;
level.scr_sound[ "tank_crush" ] = "bog_tank_crush_truck";
level._vehicle_effect[ "tankcrush" ][ "window_med" ] = loadfx( "props/car_glass_med" );
level._vehicle_effect[ "tankcrush" ][ "window_large" ] = loadfx( "props/car_glass_large" );
}
#using_animtree( "script_model" );
doors()
{
level.scr_animtree[ "door" ] = #animtree;
level.scr_anim[ "door" ][ "prague_civ_door_peek_door" ] = %prague_civ_door_peek_door;
level.scr_anim[ "door" ][ "prague_civ_door_runin_door" ] = %prague_civ_door_runin_door;
}
shoot_gun( guy )
{
guy Shoot();
}
ambient_sounds()
{
level.scr_sound[ "generic" ][ "emt_mtl_tower_creaking" ] = "emt_mtl_tower_creaking";
level.scr_sound[ "generic" ][ "emt_wood_creak_heavy2" ] = "emt_wood_creak_heavy2";
level.scr_sound[ "generic" ][ "emt_mtl_drum_pings" ] = "emt_mtl_drum_pings";
}
do_nothing( note, flagname )
{
}
ai_ignores_everything( guy )
{
guy endon( "death" );
guy notify( "animation_killed_me" );
guy.ignoreall = true;
guy maps\_stealth_utility::disable_stealth_for_ai();
wait( 3.0 );
if ( isdefined( guy ) )
{
guy.a.nodeath = true;
guy.allowPain = false;
guy.allowDeath = true;
guy.ignoreall = true;
guy DropWeapon( guy.primaryweapon, "right", 0.2 );
guy gun_remove();
guy kill();
}
}
notetrack_gun_remove( guy )
{
guy gun_remove();
}
notetrack_gun_recall( guy )
{
guy gun_recall();
}
price_exhales( price )
{
playfxOnTag( getfx( "cigar_exhale" ), price, "tag_eye" );
wait( 6.5 );
price Detach( "prop_price_cigar", "tag_inhand" );
}
price_puffs( price )
{
wait( 1.5 );
playfxOnTag( getfx( "cigar_glow_puff_strong" ), price, "tag_cigarglow" );
wait( 1 );
playfxOnTag( getfx( "cigar_glow_far" ), price, "tag_cigarglow" );
playfxOnTag( getfx( "cigar_smoke_puff" ), price, "tag_eye" );
}
splash( guy )
{
org = guy getTagOrigin( "j_knee_le" );
start = org + ( 0, 0, 30 );
end = org - ( 0, 0, 30 );
trace = BulletTrace( start, end, false, undefined );
if ( isdefined( trace[ "position" ] ) )
PlayFX( getfx( "body_splash_prague" ), trace[ "position" ] );
}
body_splash( guy )
{
org = guy getTagOrigin( "j_knee_le" );
start = org + ( 0, 0, 30 );
end = org - ( 0, 0, 300 );
trace = BulletTrace( start, end, false, undefined );
if ( isdefined( trace[ "position" ] ) )
{
PlayFX( getfx( "body_splash" ), trace[ "position" ] );
thread play_sound_in_space( "scn_prague_enemy_water_splash", trace[ "position" ] );
}
}
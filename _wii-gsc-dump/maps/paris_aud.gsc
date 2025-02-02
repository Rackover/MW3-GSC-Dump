#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_music;
#include maps\_audio_dynamic_ambi;
#include maps\_audio_vehicles;
MAX_VFX_MIGS = 10;
MAX_VFX_HELIS = 10;
MAX_VFX_PARA_JETS	= 3;
main()
{
aud_init();
set_stringtable_mapname("shg");
aud_set_occlusion("med_occlusion");
aud_set_timescale();
flag_init("aud_intro_heli_exit");
flag_init("aud_ac130_moment_complete");
flag_init("mi17_courtyard_flyby");
flag_init("aud_sewers_start");
flag_init("aud_player_exits_bomb_truck");
flag_init("flag_catacombs_bomb_1");
flag_init("flag_catacombs_bomb_2");
flag_init("flag_catacombs_bomb_3");
flag_init("flag_catacombs_pipe_burst");
flag_init("primed_sound_played");
flag_init("aud_tank_toggle");
flag_init("aud_tank_toggle_2");
flag_init("aud_gaz_jump_stairs");
flag_init("aud_van_stairs_fall_01");
flag_init("aud_van_stairs_fall_02");
flag_init("aud_van_stairs_fall_03");
flag_init("aud_van_pre_tunnel");
flag_init("aud_van_over_ledge");
flag_init("aud_van_enter_tunnel");
flag_init("aud_van_tunnel_stairs_02");
flag_init("aud_van_tunnel_stairs_03");
level.aud.enable_fx_bombshake_duck = false;
chase_flags = ["aud_gaz_jump","aud_van_down_big_stairs", "aud_van_to_canal", "aud_van_canal_part_2", "aud_van_entering_tunnel", "aud_van_tunnel_turn", "aud_van_exiting_tunnel", "aud_van_volk_rundown_pt1"];
aud_init_chase_flags(chase_flags);
aud_launch_threads();
aud_create_level_envelop_arrays();
aud_register_trigger_callbacks();
MM_add_submix("paris_level_global_mix");
aud_SetAllTimeScaleFactors(0);
aud_register_msg_handler(::paris_aud_msg_handler);
}
aud_precache_presets()
{
MM_precache_preset("paris_level_global_mix");
MM_precache_preset("pars_intro_flight");
MM_precache_preset("pars_rooftop");
MM_precache_preset("pars_rooftop_interior");
MM_precache_preset("pars_rooftop_blownout");
MM_precache_preset("paris_window_break");
MM_precache_preset("pars_street");
MM_precache_preset("pars_restaurant_kitchen");
MM_precache_preset("pars_plaza_battle");
MM_precache_preset("pars_tank_escape");
MM_precache_preset("tanks_attenuate_for_fire");
MM_precache_preset("pars_ac130_street");
MM_precache_preset("pars_no_ambdist_submix");
MM_precache_preset("paris_antiaircraft_off");
MM_precache_preset("paris_sewers");
MM_precache_preset("paris_pre_catacombs");
MM_precache_preset("paris_catacombs_main");
MM_precache_preset("paris_metal_staircase");
MM_precache_preset("paris_final_chase_street");
MM_precache_preset("pars_gaz_barricade_explo");
MM_precache_preset("pars_chase_tank");
MM_precache_preset("paris_final_chase_canal");
MM_precache_preset("pars_chase_hind");
MM_precache_preset("pars_chase_hind_strafe");
MM_precache_preset("pars_volk_crash");
MM_precache_preset("pars_volk_foley");
}
aud_launch_threads()
{
if (aud_is_specops())
return;
if ( getdvarint( "r_reflectionProbeGenerate" ) )
return;
template_level_name = get_template_level();
if (template_level_name == "paris_a" || template_level_name == "so_killspree_paris_a")
{
thread aud_paris_a_positional_start();
thread damb_paris_fire_start();
thread aud_static_tvs_start();
thread aud_courtyard_mi17_circle_overhead();
}
else if(template_level_name == "paris_b")
{
thread sewers_start_audio();
thread aud_gaz_jump();
thread aud_van_down_big_stairs();
thread aud_van_to_canal();
thread aud_van_canal_part_2();
thread aud_van_entering_tunnel();
thread aud_van_tunnel_turn();
thread aud_van_exiting_tunnel();
thread aud_van_volk_rundown_pt1();
thread aud_van_over_ledge();
thread aud_van_enter_tunnel();
thread aud_van_tunnel_stairs_02();
thread aud_van_tunnel_stairs_03();
thread aud_volk_final_crash_moment();
thread aud_volk_postcrash_foley();
}
else if(template_level_name == "so_jeep_paris_b")
{
}
}
aud_create_level_envelop_arrays()
{
level.aud.envs["tanks_attenuate_for_fire"]	= [
[0.000, 0.000],
[0.082, 0.426],
[0.238, 0.736],
[0.408, 0.844],
[0.756, 0.953],
[1.000, 1.000]
];
level.aud.envs["ac130_2d_attenuate"]	= [
[0.000, 1.000],
[0.200, 1.000],
[0.400, 0.800],
[0.600, 0.600],
[0.800, 0.400],
[1.000, 0.000]
];
level.aud.envs["aud_paris_sewers"]	= [
[0.000, 0.000],
[0.082, 0.426],
[0.238, 0.736],
[0.408, 0.844],
[0.756, 0.953],
[1.000, 1.000]
];
}
aud_register_trigger_callbacks()
{
callbacks = [
["aud_sewer_river_progress_point", ::aud_sewer_river_progress_point],
["aud_archfire_submix_progress", ::aud_archfire_submix_progress]
];
trigger_multiple_audio_register_callback(callbacks);
}
paris_aud_msg_handler(msg, args)
{
msg_handled = true;
default_mus_fade	= 4.0;
switch(msg)
{
case "debug_start_rooftops":
{
AZM_start_zone("pars_rooftop_exterior");
thread aud_paris_intro_flight();
}
break;
case "debug_start_stairwell":
{
AZM_start_zone("pars_rooftop_apartment");
aud_send_msg("mus_pre_first_contact");
}
break;
case "debug_start_restaurant_approach":
{
AZM_start_zone("pars_green_building_alley");
}
break;
case "debug_start_ac_moment":
{
AZM_start_zone("pars_ac130_strobe_street");
aud_send_msg("mus_courtyard1_crossed");
}
break;
case "debug_start_sewer_entrance":
{
AZM_start_zone("pars_ac130_strobe_street");
thread aud_courtyard2_combat_done();
aud_send_msg("mus_courtyard_2_combat_finished");
}
break;
case "debug_start_catacombs_start":
{
AZM_start_zone("paris_sewers_entrance");
thread aud_paris_b_positional_start();
aud_send_msg("mus_sewer1");
MM_add_submix("paris_antiaircraft_off");
}
break;
case "debug_start_catacombs_skull_chamber":
{
AZM_start_zone("paris_catacombs_main");
aud_send_msg("mus_catacombs_entrance");
MM_add_submix("paris_antiaircraft_off");
}
break;
case "debug_start_chase":
{
AZM_start_zone("paris_final_chase_street");
}
break;
case "debug_start_chase_canal":
{
aud_send_msg("mus_street_chase");
AZM_start_zone("paris_final_chase_canal");
}
break;
case "debug_start_chase_ending":
{
aud_send_msg("mus_street_chase");
AZM_start_zone("paris_final_chase_canal");
}
break;
case "debug_start_protect":
{
AZM_start_zone("paris_streets");
}
break;
case "enter_pars_rooftop":
{
zone_from = args;
}
break;
case "exit_pars_rooftop":
{
zone_to = args;
}
break;
case "enter_pars_rooftop_ledge":
{
zone_from = args;
}
break;
case "exit_pars_rooftop_ledge":
{
zone_to = args;
}
break;
case "enter_pars_rooftop_apartment":
{
zone_from = args;
}
break;
case "exit_pars_rooftop_apartment":
{
zone_to = args;
}
break;
case "enter_pars_rooftop_blownout":
{
zone_from = args;
}
break;
case "exit_pars_rooftop_blownout":
{
zone_to = args;
}
break;
case "enter_pars_rooftop_stairwell":
{
zone_from = args;
}
break;
case "exit_pars_rooftop_stairwell":
{
zone_to = args;
}
break;
case "enter_pars_green_building_street":
{
zone_from = args;
}
break;
case "exit_pars_green_building_street":
{
zone_to = args;
}
break;
case "enter_pars_green_building_interior":
{
zone_from = args;
}
break;
case "exit_pars_green_building_interior":
{
zone_to = args;
}
break;
case "enter_pars_green_building_alley":
{
zone_from = args;
}
break;
case "exit_pars_green_building_alley":
{
zone_to = args;
}
break;
case "enter_pars_restaurant_kitchen":
{
zone_from = args;
}
break;
case "exit_pars_restaurant_kitchen":
{
zone_to = args;
}
break;
case "enter_pars_restaurant_blownout":
{
zone_from = args;
}
break;
case "exit_pars_restaurant_blownout":
{
zone_to = args;
}
break;
case "enter_pars_restaurant_to_plaza":
{
zone_from = args;
}
break;
case "exit_pars_restaurant_to_plaza":
{
zone_to = args;
}
break;
case "enter_pars_plaza_deli":
{
zone_from = args;
}
break;
case "exit_pars_plaza_deli":
{
zone_to = args;
}
break;
case "enter_pars_plaza_coffee_shop":
{
zone_from = args;
}
break;
case "exit_pars_plaza_coffee_shop":
{
zone_to = args;
}
break;
case "enter_pars_plaza_bistro":
{
zone_from = args;
}
break;
case "exit_pars_plaza_bistro":
{
zone_to = args;
}
break;
case "enter_pars_tank_excape_building":
{
zone_from = args;
}
break;
case "exit_pars_tank_excape_building":
{
zone_to = args;
}
break;
case "enter_pars_ac130_strobe_street":
{
zone_from = args;
}
break;
case "exit_pars_ac130_strobe_street":
{
zone_to = args;
MM_clear_submix_blend("archfire_submix");
}
break;
case "enter_pars_strobe_street_library":
{
zone_from = args;
}
break;
case "exit_pars_strobe_street_library":
{
zone_to = args;
}
break;
case "enter_pars_downed_heli_store":
{
zone_from = args;
}
break;
case "exit_pars_downed_heli_store":
{
zone_to = args;
}
break;
case "enter_streets_sewers_entrance":
{
zone_from = args;
if (zone_from == "paris_streets")
{
}
}
break;
case "exit_streets_sewers_entrance":
{
}
break;
case "progress_streets_sewers_entrance":
{
progress = args;
}
break;
case "enter_sewers_entrance_sewers_stairwell":
{
zone_from = args;
}
break;
case "exit_sewers_entrance_sewers_stairwell":
{
zone_to = args;
}
break;
case "progress_sewers_entrance_sewers_stairwell":
{
progress = args;
}
break;
case "enter_sewers_stairwell_sewers":
{
zone_from = args;
if (zone_from == "paris_sewers_stairwell")
{
if (!isDefined(level.aud.damb_pars_sewer_pipe_stress))
{
DAMB_start_preset_at_point("pars_sewer_pipe_stress", (328, -377, 240));
thread aud_stop_pipe_stress();
level.aud.damb_pars_sewer_pipe_stress = true;
}
}
}
break;
case "exit_sewers_stairwell_sewers":
{
zone_to = args;
}
break;
case "progress_sewers_stairwell_sewers":
{
progress = args;
}
break;
case "enter_sewers_pre_catacombs":
{
zone_from = args;
if (zone_from == "paris_sewers")
{
aud_send_msg("mus_catacombs_entrance");
}
}
break;
case "exit_sewers_pre_catacombs":
{
zone_to = args;
}
break;
case "progress_sewers_pre_catacombs":
{
progress = args;
}
break;
case "enter_pre_catacombs_catacombs_main":
{
zone_from = args;
}
break;
case "exit_pre_catacombs_catacombs_main":
{
zone_to = args;
if (zone_to == "paris_catacombs_main")
{
}
}
break;
case "progress_pre_catacombs_catacombs_main":
{
progress = args;
}
break;
case "enter_catacombs_main_infrastructure":
{
MM_add_submix("paris_metal_staircase", 1);
zone_from = args;
if (zone_from == "paris_catacombs_main")
{
if (!isDefined(level.aud.infrastructure_metal_clangs))
{
wait(0.5);
level.aud.infrastructure_metal_clangs = true;
level.player playsound("pars_metal_stairs_clangs_1");
wait(3);
level.player playsound("pars_metal_stairs_clangs_2");
}
}
}
break;
case "exit_catacombs_main_infrastructure":
{
MM_clear_submix("paris_metal_staircase", 2);
zone_to = args;
}
break;
case "enter_paris_infrastructure_exit_lobby":
{
zone_from = args;
}
break;
case "exit_paris_infrastructure_exit_lobby":
{
zone_to = args;
}
break;
case "enter_paris_final_chase_street":
{
zone_from = args;
}
break;
case "exit_paris_final_chase_street":
{
zone_to = args;
}
break;
case "progress_catacombs_main_infrastructure":
{
progress = args;
}
break;
case "aud_paris_intro_heli_exit":
{
bird = args;
assert(IsDefined(bird));
thread aud_paris_intro_heli_exit(bird);
}
break;
case "fx_skybox_hind":
{
aud_handle_fx_skybox_hind(args);
}
break;
case "fx_skybox_mig":
{
aud_handle_fx_skybox_mig(args);
}
break;
case "fx_paratrooper_jet":
{
thread aud_handle_fx_paratrooper_jet(args);
}
break;
case "pars_missile_launch":
{
assert(IsDefined(args) && IsDefined(args[0]));
missile = args[0];
thread aud_play_linked_sound("dist_missile_travel", missile, "oneshot");
}
break;
case "pars_missile_explode":
{
explo_origin = args[0];
thread play_sound_in_space("nymn_explosion_mortar_distant", explo_origin);
}
break;
case "msg_audio_fx_bombshake":
{
if (level.aud.enable_fx_bombshake_duck)
{
duck_time = 3.0;
fade_in_time	= 0.3;
fade_out_time	= 2.0;
aud_duck("sewer_bomb_submix", duck_time, fade_in_time, fade_out_time);
}
thread play_sound_in_space("sewer_bombs", level.player.origin);
}
break;
case "aud_manual_bombshake_triggered":
{
wait(.35);
play_sound_in_space("paris_picture_fall", (7670, 2675, 1350));
}
break;
case "debris_push_animation":
{
wait(10.2);
play_sound_in_space("paris_debrispush_crash",(7441,2173,996));
}
break;
case "start_ledge_footstep":
{
level.player playsound("paris_ledge_debris");
level.player playsound("step_run_plr_concrete");
level.player playsound("gear_rattle_plr_walk");
}
break;
case "jets_flyby_01":
{
ent_array = args;
ent_array[0] Vehicle_TurnEngineOff();
thread VM_aud_air_vehicle_flyby(ent_array[0], "pars_mig_flyby_01", 10000);
}
break;
case "jets_flyby_02":
{
ent_array = args;
ent_array[0] Vehicle_TurnEngineOff();
}
break;
case "bookstore_spray_moment":
{
mm_add_submix("paris_window_break");
wait(3);
mm_clear_submix("paris_window_break", 2);
}
break;
case "tank_battalion_bookstore":
{
tanks = args;
aud_play_bookstore_tanks(tanks);
}
break;
case "jet_flyby_back_alley":
{
jet = args[0];
if(IsDefined(args[0]))
{
flyby_3 = aud_play_linked_sound("pars_jet_flyover_city_long", level.player);
wait(3.25);
flyby_1 = aud_play_linked_sound("paris_f15_flyby_1", level.player);
flyby_2 = aud_play_linked_sound("pars_jet_flyover_city", level.player);
wait(1.5);
flybys = [flyby_1, flyby_2];
foreach(flyby in flybys)
{
flyby scalevolume(0, 4);
}
}
}
break;
case "courtyard_tanks":
{
tanks = args;
aud_play_courtyard_tanks(tanks);
}
break;
case "ac130_prepare_inc":
{
level.aud.first_ac130_bullet = true;
}
break;
case "aud_ac130_bullet":
{
thread aud_ac130_bullet_sound(args);
}
break;
case "msg_audio_fx_ambientExp":
{
bomb_pos = args;
if(isdefined (bomb_pos))
{
dist = Distance(level.player.origin, bomb_pos);
play_sound_in_space("explo_ambient_building", bomb_pos);
}
}
break;
case "ac130_moment_complete":
{
flag_set("aud_ac130_moment_complete");
}
break;
case "mi17_courtyard_02_start":
{
mi17 = args;
if(isDefined(mi17))
{
flag_set("mi17_courtyard_flyby");
mi17 Vehicle_TurnEngineOff();
wait(0.5);
aud_play_linked_sound("pars_heli_by_overhead", mi17);
mi17 thread aud_courtyard_mi17_flight_flyaway();
}
}
break;
case "courtyard_2_combat_finished":
{
thread aud_courtyard2_combat_done();
aud_send_msg("mus_courtyard_2_combat_finished");
}
break;
case "aud_btr_courtyard_start":
{
btr = args;
if (IsDefined(btr))
{
btr Vehicle_TurnEngineOff();
btr thread VM_ground_vehicle_start("pars_btr_engine_low_lp" , "pars_btr_roll_lp", "pars_btr_idle_lp", "pars_btr_rev", "pars_btr_breaks");
}
}
break;
case "volk_escape":
{
car = args;
car waittillmatch("vehicle_scripted_animation", "aud_volk_escape" );
L_sound = "pars_volk_peel_out_L";
R_sound	= "pars_volk_peel_out_R";
L_pos = (-3880, -817, 896);
R_pos	=	(-3930, -205, 902);
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos);
}
break;
case "mi17_01_escape_ambient":
{
ent_array = args;
ent_array[0] Vehicle_TurnEngineOff();
heli_ent_L = spawn("script_origin", (-3791,-1476,1615) );
heli_ent_R = spawn("script_origin", (-3734,-451,1615));
heli_ent_L playsound("pars_mi17_chase_L", "sounddone_L");
heli_ent_R playsound("pars_mi17_chase_R", "sounddone_R");
heli_ent_L waittill("sounddone_L");
heli_ent_L delete();
heli_ent_R waittill("sounddone_R");
heli_ent_R delete();
}
break;
case "mi17_02_escape_ambient":
{
ent_array = args;
ent_array[0] Vehicle_TurnEngineOff();
}
break;
case "mi17_03_escape_ambient":
{
ent_array = args;
ent_array[0] Vehicle_TurnEngineOff();
}
break;
case "mi17_01_escape":
{
ent_array = args;
assert(ent_array.size == 1);
ent_array[0] Vehicle_TurnEngineOff();
ent_array[0] thread aud_courtyard_mi17_flight_flyaway();
}
break;
case "delta_pull_movemanhole":
{
}
break;
case "enter_sewers_stairwell":
{
aud_send_msg("mus_sewer_stairs");
}
break;
case "catacombs_bomb_1":
{
level.player playsound("sewer_bombs");
aud_play_2d_sound("pars_bomb_shake_extender");
wait(0.35);
aud_play_2d_sound("pars_bomb_shake_extender_small_02");
wait(0.4);
aud_play_2d_sound("pars_bomb_shake_extender_small_03");
}
break;
case "catacombs_bomb_2":
{
level.player playsound("sewer_bombs");
aud_play_2d_sound("pars_bomb_shake_extender");
wait(0.4);
aud_play_2d_sound("pars_bomb_shake_extender_small_01");
wait(0.4);
aud_play_2d_sound("pars_bomb_shake_extender_small_02");
}
break;
case "catacombs_bomb_3":
{
level.player playsound("sewer_bombs");
aud_play_2d_sound("pars_bomb_shake_extender");
wait(0.5);
aud_play_2d_sound("pars_bomb_shake_extender_small_04");
}
break;
case "catacombs_pipe_burst_bomb_shake":
{
aud_do_catacombs_bomb();
}
break;
case "catacombs_pipe_burst":
{
thread aud_broken_pipes();
thread DAMB_stop_preset("pars_sewer_pipe_stress", 0.2);
level.aud.is_catacomb_pipe_burst_playing = true;
catacomb_pipe_ent = Spawn("script_origin", (325, -416, 185));
thread aud_play_catacomb_pipe_burst(catacomb_pipe_ent);
wait(2.5);
fade_out_time = 1.1;
if (level.aud.is_catacomb_pipe_burst_playing)
{
catacomb_pipe_ent ScaleVolume(0.0, fade_out_time);
catacomb_pipe_ent waittill("sounddone");
}
catacomb_pipe_ent delete();
aud_send_msg("mus_sewer2");
}
break;
case "aud_prime_catacombs_squeeze":
{
level.player aud_prime_stream("pars_se_catacombsqueeze");
}
break;
case "aud_start_catacombs_squeeze":
{
level.player playsound("pars_se_catacombsqueeze");
}
break;
case "road_flare_start":
{
flare_anim = args;
wait(0.7);
flare_anim playsound("road_flare_start");
}
break;
case "road_flare_lp":
{
flare_ent = args;
flare_ent playloopsound("road_flare_lp");
}
break;
case "shadow_gag_main_room":
{
}
break;
case "enemy_gate_gag":
{
door = args;
door playsound("catacombs_kick_gag_v2");
aud_send_msg("mus_enemy_gate_gag");
}
break;
case "scripted_flashbang":
{
assert(IsDefined(args));
where = args;
thread play_sound_in_space("flashbang_explode_default", where);
aud_send_msg("mus_flashbang");
}
break;
case "heli_crash":
{
}
break;
case "bomb_truck_start":
{
aud_send_msg("mus_street_chase");
AZM_start_zone("paris_streets_escape");
MM_add_submix("paris_antiaircraft_off", 3.0);
MM_add_submix("pars_gaz_barricade_explo", 2.0);
thread aud_paris_truck_bomb_start(args);
}
break;
case "aud_rpg_3d_short":
{
rpg_ent = args[0];
rpg_origin = args[1];
rpg_target = args[2];
rpg_ent playsound("pars_3d_rpg_L");
}
break;
case "aud_rpg_3d":
{
rpg_ent = args[0];
rpg_origin = args[1];
rpg_target = args[2];
thread play_sound_in_space("pars_3d_rpg_L", rpg_origin);
thread play_sound_in_space("pars_3d_rpg_R", rpg_target);
}
break;
case "aud_rpg_2d":
{
thread aud_play_2d_sound("pars_2d_rpg");
}
break;
case "aud_rpg":
{
rpg_ent = args[0];
rpg_origin = args[1];
rpg_target = args[2];
}
break;
case "gaz_death":
{
args thread aud_gaz_explo_on_death();
}
break;
case "pars_chase_tank_start":
{
wait(1.4);
aud_play_2d_sound("pars_chase_tank_move");
MM_add_submix("pars_chase_tank", 2);
MM_clear_submix("pars_gaz_barricade_explo", 2);
}
break;
case "pars_chase_tank_smash":
{
aud_play_2d_sound("pars_chase_tank_smash");
wait(1.2);
aud_play_2d_sound("pars_chase_tank_turret");
}
break;
case "pars_chase_tank_shoot_01":
{
aud_play_2d_sound("pars_chase_tank_shoot_01");
wait(0.3);
aud_play_2d_sound("chase_tank_shell_impact");
wait(2.5);
aud_play_2d_sound("chase_tank_building_debris");
}
break;
case "van_storefront_destroy_glass":
{
thread play_sound_in_space("glass_pane_shatter", args);
}
break;
case "pars_chase_tank_shoot_02":
{
aud_play_2d_sound("pars_chase_tank_shoot_02");
}
break;
case "pars_chase_tank_impact_02":
{
aud_play_2d_sound("chase_tank_shell_explode");
wait(0.5);
aud_play_2d_sound("chase_tank_building_debris");
wait(2.5);
aud_play_2d_sound("pars_van_engine_seq_02");
MM_clear_submix("pars_chase_tank", 1);
}
break;
case "chase_uaz_01":
{
}
break;
case "chase_gaz_02":
{
gaz = args;
gaz playsound("gaz_tire_slide");
}
break;
case "van_slam_storefront_01":
{
aud_play_2d_sound("pars_storefront_impact");
aud_play_2d_sound("pars_van_tunnel_body_hit");
aud_play_2d_sound("exp_van_impacts_storefront");
}
break;
case "paris_b_chase_hind_spawn":
{
hind = args;
if (IsDefined(hind))
{
thread aud_chase_hind(hind);
}
}
break;
case "chase_hind_fire":
{
hind = args;
if (IsDefined(hind))
{
thread aud_chase_hind_fire_control(hind);
}
}
break;
case "chase_hind_bullet_impact":
{
hind_bullet = args;
if (IsDefined(hind_bullet))
{
if ( RandomInt( 5 ) > 2 )
{
thread aud_chase_hind_bullet_impact(hind_bullet);
}
}
}
break;
case "player_shot_sedan_ending":
{
level.player playsound("volk_crash_tire_blowout");
sedan = args;
if (IsDefined(sedan))
{
grind = spawn("script_origin", sedan.origin);
grind linkto( sedan );
grind playsound("volk_crash_tire_grind", "sounddone");
flag_wait("flag_final_crash_wall_impact_1");
grind scalevolume(0.0, 0.1);
wait(0.2);
grind stopsounds();
grind delete();
}
}
break;
case "pars_volk_escape_failstate":
{
aud_play_2d_sound("pars_volk_escape_failstate");
}
break;
case "start_engine_02":
{
ent = spawn("script_origin", level.player.origin);
ent playsound("pars_van_engine_seq_02");
flag_wait("aud_van_down_big_stairs");
ent scalevolume(0.0, 0.5);
wait(0.3);
ent stopsounds();
ent delete();
}
break;
case "start_engine_03":
{
}
break;
case "player_to_front_of_truck":
{
}
break;
case "gallery_gate_crash_exit":
{
thread play_sound_in_space("pars_van_gate_impact", level.player.origin);
thread play_sound_in_space("gaz_explode_crunch", level.player.origin);
}
break;
case "uaz_jump_bridge":
{
gaz = args;
aud_play_2d_sound("pars_van_engine_seq_04");
}
break;
case "meet_gign":
{
}
break;
case "aud_flashlight_on":
{
}
break;
case "aud_player_exits_bomb_truck":
{
flag_set("aud_player_exits_bomb_truck");
}
break;
case "mus_post_intro":
{
MUS_play("pars_post_intro", 10);
}
break;
case "mus_ledge_walk":
{
}
break;
case "mus_pre_first_contact":
{
MUS_play("pars_pre_first_contact", default_mus_fade);
}
break;
case "mus_first_contact":
{
wait(1);
MUS_play("pars_first_contact", 0.25);
}
break;
case "mus_enter_book_store":
{
}
break;
case "mus_bookstore_clear":
{
if (!IsDefined(level.aud.mus_enter_book_store_done))
{
level.aud.mus_enter_book_store_done = true;
MUS_play("pars_enter_book_store_done", 8);
}
}
break;
case "mus_reached_gign":
{
}
break;
case "mus_follow_gign":
{
MUS_play("pars_follow_gign", default_mus_fade);
}
break;
case "mus_cross_courtyard1":
{
aud_set_music_submix(1.5, 0);
MUS_play("pars_cross_courtyard1", default_mus_fade);
}
break;
case "mus_courtyard1_crossed":
{
fade_time = 10;
MUS_play("pars_courtyard1_crossed", fade_time);
wait(fade_time);
MUS_stop(fade_time);
}
break;
case "mus_ac130_replies":
{
if (!IsDefined(level.aud.mus_cross_courtyard2))
{
MUS_play("pars_ac130_music", 8);
}
}
break;
case "mus_cross_courtyard2":
{
if (!IsDefined(level.aud.mus_cross_courtyard2))
{
level.aud.mus_cross_courtyard2 = true;
MUS_play("pars_cross_courtyard2", default_mus_fade);
}
}
break;
case "mus_btr_destroyed":
{
}
break;
case "mus_courtyard_2_combat_finished":
{
if (!IsDefined(level.aud.mus_courtyard_2_combat_finished))
{
level.aud.mus_cross_courtyard2 = true;
MUS_play("pars_cross_courtyard2_ending", 1.25);
wait(5);
MUS_play("pars_to_the_sewers", 0.5);
wait(4);
MUS_stop(50);
}
}
break;
case "mus_sewer1":
{
MUS_play("pars_sewer1", default_mus_fade);
}
break;
case "mus_sewer_stairs":
{
}
break;
case "mus_sewer2":
{
}
break;
case "mus_catacombs_entrance":
{
MUS_play("pars_catacombs_entrance", default_mus_fade);
}
break;
case "mus_catacombs_ambush":
{
MUS_stop(2);
wait(1.0);
MUS_play("pars_catacombs_chase_intro", 0, 3);
aud_set_music_submix(100, 0);
}
break;
case "mus_flashbang":
{
}
break;
case "mus_catacombs_chase":
{
aud_set_music_submix(1, 0);
MUS_play("pars_catacombs_chase", 0, 6);
}
break;
case "mus_catacombs_chase_end":
{
MUS_play("pars_catacombs_chase_end", 3, 5);
}
break;
case "mus_street_chase":
{
aud_set_music_submix(100, 0);
MUS_play("pars_street_chase", 0, 1);
}
break;
case "mus_street_chase_end":
{
MUS_play("pars_outro", 0, 3);
wait(4);
aud_set_music_submix(0.5, 15);
wait(7.5);
aud_set_music_submix(0, 30);
}
break;
default:
{
msg_handled = false;
}
}
return msg_handled;
}
aud_handle_fx_skybox_hind(args)
{
if (flag("aud_intro_heli_exit"))
{
assert(IsArray(args));
assert(IsDefined(args[0]) && IsDefined(args[1]) && IsDefined(args[2]));
start_point	= args[0];
end_point = args[1];
flight_time	= args[2];
dist = distance(start_point, level.player.origin);
if (dist < 20000)
{
if (!IsDefined(level.aud.vfx_heli_count))
{
level.aud.vfx_heli_count = 0;
}
if (level.aud.vfx_heli_count < MAX_VFX_HELIS)
{
level.aud.vfx_heli_count++;
thread aud_play_vfx_heli_oneshot(start_point, end_point, flight_time);
aud_play_vfx_heli_loop(start_point, end_point, flight_time);
level.aud.vfx_heli_count--;
assert(level.aud.vfx_heli_count >= 0 && level.aud.vfx_heli_count < MAX_VFX_HELIS);
}
}
}
}
aud_play_vfx_heli_oneshot(start_point, end_point, flight_time)
{
wait(4);
ent = spawn("script_origin", start_point);
ent PlaySound("vfx_dist_heli", "sounddone");
ent MoveTo(end_point, flight_time);
ent waittill("sounddone");
ent delete();
}
aud_play_vfx_heli_loop(start_point, end_point, flight_time)
{
ent = spawn("script_origin", start_point);
ent PlayLoopSound("vfx_dist_heli_lp");
ent MoveTo(end_point, flight_time);
wait(flight_time);
ent delete();
}
aud_handle_fx_skybox_mig(args)
{
if (flag("aud_intro_heli_exit"))
{
assert(IsArray(args));
assert(IsDefined(args[0]) && IsDefined(args[1]) && IsDefined(args[2]));
start_point	= args[0];
end_point	= args[1];
flight_time	= args[2];
if (!IsDefined(level.aud.vfx_mig_count))
{
level.aud.vfx_mig_count = 0;
}
if (level.aud.vfx_mig_count < MAX_VFX_MIGS)
{
level.aud.vfx_mig_count++;
ent = spawn("script_origin", start_point);
ent PlaySound("vfx_dist_jet", "sounddone");
ent MoveTo(end_point, flight_time);
ent waittill("sounddone");
ent ScaleVolume(0.0, 0.5);
wait(0.5);
ent delete();
level.aud.vfx_mig_count--;
assert(level.aud.vfx_mig_count >= 0 && level.aud.vfx_mig_count < MAX_VFX_MIGS);
}
}
}
aud_play_vfx_dist_jet(ent, end_point, flight_time)
{
level endon("aud_kill_vfx_dist_jet");
ent PlaySound("vfx_dist_jet", "sounddone");
ent MoveTo(end_point, flight_time);
ent waittill("sounddone");
}
aud_handle_fx_paratrooper_jet(args)
{
if (true)
{
assert(IsArray(args));
assert(IsDefined(args[0]) && IsDefined(args[1]) && IsDefined(args[2]));
start_point	= args[0];
end_point	= args[1];
flight_time	= args[2];
if (!IsDefined(level.aud.vfx_para_jets))
{
level.aud.vfx_para_jets = [];
for (i = 0; i < MAX_VFX_PARA_JETS; i++)
{
level.aud.vfx_para_jets[i] = spawnstruct();
}
level.aud.vfx_para_jet_index = 0;
}
wait(8);
i = level.aud.vfx_para_jet_index;
if (IsDefined(level.aud.vfx_para_jets[i].ent))
{
kill_me = level.aud.vfx_para_jets[i].ent;
level.aud.vfx_para_jets[i].ent = undefined;
aud_fade_out_and_delete(kill_me, 3.0);
}
ent = spawn("script_origin", start_point);
ent PlaySound("vfx_dist_paratrooper_jet");
ent MoveTo(end_point, flight_time);
level.aud.vfx_para_jets[i].ent = ent;
level.aud.vfx_para_jet_index = (level.aud.vfx_para_jet_index + 1) % MAX_VFX_PARA_JETS;
}
}
aud_courtyard2_combat_done()
{
wait(1);
AZM_set_zone_dynamic_ambience("pars_ac130_strobe_street", "none");
AZM_set_zone_dynamic_ambience("pars_strobe_street_library", "none");
AZM_set_zone_dynamic_ambience("pars_downed_heli_store", "none");
DAMB_stop();
}
aud_paris_intro_flight()
{
thread MM_add_submix("pars_intro_flight", 0.05);
thread MM_add_submix("pars_intro_skybattle", 0.05);
aud_play_2d_sound("paris_intro_flight_music");
aud_delay_play_2d_sound("paris_intro_flight_sfx", 10.5);
aud_delay_play_2d_sound("paris_intro_flight_paper", 19);
}
aud_paris_intro_heli_exit(bird)
{
flag_set("aud_intro_heli_exit");
wait(1.5);
bird thread play_sound_on_entity( "paris_intro_heli_exit" );
thread MM_clear_submix("pars_intro_skybattle", 10.0);
wait(10.0);
thread MM_clear_submix("pars_intro_flight", 6.0);
wait(3);
aud_send_msg("mus_post_intro");
}
aud_play_courtyard_tanks(ent)
{
tanks = ent;
_volscale = 1;
tanks[0] Vehicle_TurnEngineOff();
tanks[1] Vehicle_TurnEngineOff();
tanks[1] playloopsound("tank_treads_lp");
L_pos = (5687, -1089, 1152);
R_pos	=	(4843, -1972, 1080);
if(flag("aud_tank_toggle_2"))
{
_volscale = 1;
zone = AZM_get_current_zone();
L_sound = "tank_by_long_L_01";
R_sound	= "tank_by_long_R_01";
flag_clear("aud_tank_toggle_2");
wait(0.5);
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos, _volscale);
}
else if(!flag("aud_tank_toggle_2"))
{
L_sound = "tank_by_long_L_02";
R_sound	= "tank_by_long_R_02";
flag_set("aud_tank_toggle_2");
wait(0.5);
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos, _volscale);
}
}
aud_play_bookstore_tanks(ent)
{
tanks = ent;
_volscale = 1;
tanks[0] Vehicle_TurnEngineOff();
tanks[1] Vehicle_TurnEngineOff();
L_pos = (3626, 2841, 962);
R_pos	=	(3980, 3077, 962);
if(flag("aud_tank_toggle"))
{
_volscale = 1;
zone = AZM_get_current_zone();
if(zone == "pars_green_building_alley")
{
_volscale = 0.3;
}
L_sound = "tank_by_short_L_01";
R_sound	= "tank_by_short_R_01";
flag_clear("aud_tank_toggle");
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos, _volscale);
}
else if(!flag("aud_tank_toggle"))
{
L_sound = "tank_by_short_L_02";
R_sound	= "tank_by_short_R_02";
flag_set("aud_tank_toggle");
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos, _volscale);
}
}
aud_btr_courtyard(ent)
{
btr = ent;
btr aud_courtyard_btr();
}
aud_courtyard_btr()
{
self vehicle_turnengineoff();
self playloopsound("veh_btr_roll_lp");
self playloopsound("veh_btr_idle_lp");
}
play_spaced_stereo_sound(L_sound, R_sound, L_pos, R_pos, _volscale)
{
ent_L = spawn("script_origin", L_pos );
ent_R = spawn("script_origin", R_pos );
ent_L playsound(L_sound, "sounddone");
ent_R playsound(R_sound, "sounddone");
if(isdefined (_volscale))
{
volscale = _volscale;
ent_L scalevolume(volscale);
ent_R	scalevolume(volscale);
}
thread delete_on_sounddone(ent_L);
thread delete_on_sounddone(ent_R);
}
aud_play_sound_on_tv(damage_trigger_name, org_name, alias)
{
org = getent(org_name, "targetname");
if (IsDefined(org))
{
org playloopsound(alias);
trigger_wait_targetname(damage_trigger_name);
org stoploopsound();
}
}
aud_paris_truck_bomb_start(args)
{
aud_play_2d_sound("pars_van_engine_seq_01");
bombtruck = args;
self endon("aud_player_exits_bomb_truck");
skid_ent = Spawn( "script_origin",level.player.origin);
while(1)
{
bombtruck_speed = bombtruck Vehicle_GetSpeed();
velocity = bombtruck Vehicle_GetBodyVelocity();
skid_ent LinkTo(bombtruck);
X_vel = velocity[1];
Y_vel = velocity[2];
if ( bombtruck_speed > 20 )
{
if ( X_vel < -150.0 )
{
alias = "ar_van_skid_hard_left";
skid_ent aud_uhaul_playskid(alias);
wait(0.5);
}
else if ( X_vel > 150.0 )
{
alias = "ar_van_skid_hard_right";
skid_ent aud_uhaul_playskid(alias);
wait(0.5);
}
}
else if ( bombtruck_speed > 10)
{
if ( X_vel < -95.0 )
{
alias = "ar_van_skid_hard_left";
skid_ent aud_uhaul_playskid(alias);
}
else if ( X_vel > 95.0 )
{
alias = "ar_van_skid_hard_right";
skid_ent aud_uhaul_playskid(alias);
}
}
wait 0.5;
}
}
aud_ac130_bullet_sound(bullet_data)
{
assert(IsDefined(bullet_data));
if (IsDefined(bullet_data.bullet))
{
assert(IsDefined(bullet_data.target_pos));
assert(IsDefined(level.aud.first_ac130_bullet));
bullet = bullet_data.bullet;
target_pos = bullet_data.target_pos;
dist_threshold = 10000;
alias_name = "ac130_magicbullet_short";
max_dist = 5000;
if (level.aud.first_ac130_bullet)
{
level.aud.first_ac130_bullet = false;
dist_threshold = 10000;
max_dist = 4500;
alias_name = "ac130_magicbullet_long";
}
while(true)
{
if (IsDefined(bullet))
{
dist = distance( bullet.origin, target_pos );
player_dist = distance2d( target_pos, level.player.origin );
if ( dist < dist_threshold )
{
inc_vol = aud_map_range(player_dist, 0, max_dist, level.aud.envs["ac130_2d_attenuate"]);
bullet_ent = spawn("script_origin", bullet.origin);
bullet_ent linkto( bullet );
bullet_ent playsound(alias_name);
bullet_ent ScaleVolume(inc_vol);
bullet waittill("death");
exp_pos = bullet_ent.origin;
thread aud_ac130_impacts(exp_pos);
thread aud_ac130_debris(exp_pos);
bullet_ent stopsounds();
wait(0.05);
bullet_ent delete();
return;
}
else
{
wait(0.05);
}
}
else
{
return;
}
}
}
}
aud_init_chase_flags(chase_flags)
{
foreach (chase_flag in chase_flags)
{
flag_init(chase_flag);
}
}
chase_flag_watcher(chase_flag)
{
flag_wait(chase_flag);
level.player playsound(chase_flag);
}
aud_ac130_impacts(exp_pos)
{
exp_dist2d = distance2d(exp_pos, level.player.origin);
exp_ent = Spawn("script_origin", exp_pos);
exp_alias = "alias";
exp_dist_threshold = 3000;
exp_dist_threshold_3d = 1000;
thread play_sound_in_space("ac130_dist_exp_3d", exp_pos);
if(exp_dist2d < exp_dist_threshold)
{
exp_vol = aud_map_range(exp_dist2d, 500, 3000, level.aud.envs["ac130_2d_attenuate"]);
exp_ent playsound("ac130_main_impact_2d");
exp_ent playsound("ac130_layer_2d", "sounddone");
exp_ent ScaleVolume(exp_vol);
}
}
aud_ac130_debris(exp_pos)
{
if(IsDefined(level.aud.ac130_debris_ent))
{
level.aud.ac130_debris_ent stopsounds();
wait(0.05);
if(IsDefined(level.aud.ac130_debris_ent))
level.aud.ac130_debris_ent delete();
}
wait(0.05);
level.aud.ac130_debris_ent = Spawn("script_origin", exp_pos);
level.aud.ac130_debris_ent playsound("ac130_debris_lyr_2", "sounddone");
level.aud.ac130_debris_ent waittill("sounddone");
if(IsDefined(level.aud.ac130_debris_ent))
level.aud.ac130_debris_ent delete();
}
aud_paris_a_positional_start()
{
play_loopsound_in_space("ceramic_wind_chimes",(8173,3151, 1441));
play_loopsound_in_space("smoldering_wreckage",(7684,2490, 1413));
play_loopsound_in_space("smoldering_wreckage",(7136,2351, 1388));
play_loopsound_in_space("smoldering_wreckage",(6991,2291, 1375));
play_loopsound_in_space("smoldering_wreckage",(6116,1396, 1119));
play_loopsound_in_space("emt_doorway_drips_02",(6700, 2407, 1420));
play_loopsound_in_space("paris_stove_pots",(3432, 286, 941));
play_loopsound_in_space("paris_stove_pots",(3378, 300, 941));
play_loopsound_in_space("paris_stove_pots",(3431, 256, 941));
play_loopsound_in_space("paris_stove_pots",(3378, 300, 941));
play_loopsound_in_space("paris_stove_pots",(3401, 124, 941));
play_loopsound_in_space("paris_stove_pots",(3363, 130, 941));
}
aud_static_tvs_start()
{
thread aud_play_sound_on_tv("trigger_paris_tv_02", "trigger_paris_tv_02_origin", "emt_tv_static_lp_paris" );
}
aud_paris_b_positional_start()
{
play_loopsound_in_space("pars_sewer_entrance_tube",(990,347,583));
play_loopsound_in_space("sewer_wind_st_lp",(271,326,514));
play_loopsound_in_space("sewer_wind_st_lp",(1421,345,564));
play_loopsound_in_space("sewer_wind_st_lp",(432,-1140,109));
}
aud_courtyard_mi17_circle_overhead()
{
flag_wait("aud_ac130_moment_complete");
mi17_overhead = aud_play_linked_sound("pars_heli_circle_overhead", level.player, "loop", "aud_kill_heli_circle_loop");
mi17_overhead scalevolume(0.0);
wait(0.05);
mi17_overhead ScaleVolume(1, 3);
flag_wait("mi17_courtyard_flyby");
wait(1);
mi17_overhead ScaleVolume(0.0, 3);
wait(3.5);
level notify("aud_kill_heli_circle_loop");
}
aud_courtyard_mi17_flight_flyaway()
{
if(IsDefined(self))
{
mi17_loop = spawn("script_origin", self.origin);
mi17_loop linkto(self);
aud_fade_sound_in(mi17_loop,"pars_heli_blades_loop", 1.0, 5, true);
self thread aud_courtyard_mi17_kill(mi17_loop);
self waittill("unloaded");
thread aud_play_linked_sound("pars_heli_take_off_fly_out", self);
wait(3);
mi17_loop thread aud_fade_out_courtyard_mi17_loop();
}
}
aud_fade_out_courtyard_mi17_loop()
{
wait(0.25);
if(Isdefined(self))
{
thread aud_fade_out_and_delete(self, 8);
}
}
aud_courtyard_mi17_kill(ent)
{
assert(IsDefined(ent));
self waittill_any("deathspin");
thread aud_fade_out_and_delete(ent, 0.5);
}
aud_heli_mi17_spawn_and_drive(ent, mi17_preset_)
{
assert(IsDefined(ent));
mi17_preset = "paris_a_mi17";
instance = "paris_a_mi17";
if (IsDefined(mi17_preset_))
{
mi17_preset = mi17_preset_;
instance = mi17_preset_;
}
thread VM_start_preset(instance, mi17_preset, ent);
ent Vehicle_TurnEngineOff();
thread aud_heli_mi17_kill(ent, mi17_preset, instance);
ent waittill("unloaded");
ent thread play_sound_on_entity("mi17_fly_away");
}
aud_heli_mi17_kill(ent, mi17_preset, instance)
{
assert(IsDefined(ent));
assert(IsDefined(mi17_preset));
assert(IsDefined(instance));
ent waittill_any("deathspin", "death");
thread VM_stop_preset_instance(instance, 3.0);
MM_clear_submix(mi17_preset, 3.0);
}
aud_uhaul_playskid(alias)
{
self playsound(alias, "sounddone");
self waittill ("sounddone");
}
aud_archfire_submix_progress(progress)
{
if (!IsDefined(level.aud.archfire_submix_progress))
{
level.aud.archfire_submix_progress = true;
MM_add_submix_blend_to("tanks_attenuate_for_fire", "archfire_submix", progress);
}
else
{
assert(IsDefined(progress));
assert(IsDefined(level.aud.envs["tanks_attenuate_for_fire"]));
blendvalue = aud_map(progress, level.aud.envs["tanks_attenuate_for_fire"]);
MM_set_submix_blend_value("archfire_submix", blendvalue);
}
}
aud_sewer_river_progress_point(progress_point)
{
if (!IsDefined(level.aud.sewer_river_sound_handle))
{
level.aud.sewer_river_sound_handle = Spawn("script_origin", progress_point);
level.aud.sewer_river_sound_handle playloopsound("pars_sewer_river");
}
else
{
level.aud.sewer_river_sound_handle MoveTo(progress_point, 0.3 );
}
}
aud_paris_sewers_progress(progress)
{
}
aud_catacombs_bomb_1_exit()
{
wait(0.2);
MM_clear_submixes();
}
aud_play_catacomb_pipe_burst(catacomb_pipe_ent)
{
assert(IsDefined(catacomb_pipe_ent));
catacomb_pipe_ent PlaySound("pars_sewer_pipe_burst", "sounddone");
catacomb_pipe_ent waittill("sounddone");
level.aud.is_catacomb_pipe_burst_playing = false;
}
sewers_helper(pos, alias, vol, fadetime)
{
ent = spawn("script_origin", pos);
thread aud_fade_sound_in(ent, alias, vol, fadetime, true);
}
sewers_start_audio()
{
sewers_helper((966, -36, 0), "emt_doorway_drips_01", 0.3, 2);
sewers_helper((969, -375, 121), "emt_doorway_drips_01", 0.4, 2);
sewers_helper((197, -644, 73), "emt_doorway_drips_01", 0.3, 2);
sewers_helper((455, -659, 77), "emt_doorway_drips_01", 0.3, 2);
sewers_helper((342, -416, 67), "emt_doorway_drips_03", 1, 2);
sewers_helper((210, -412, 123), "emt_doorway_drips_03", 1, 2);
sewers_helper((-232, -658, 20), "emt_doorway_drips_03", 1, 2);
sewers_helper((1036, 284, 480), "emt_doorway_drips_03", 2, 2);
sewers_helper((1282, 31, 352), "emt_doorway_drips_03", 1, 2);
sewers_helper((1375, 260,358), "emt_doorway_drips_03", 1, 2);
sewers_helper((1083, 287, 275), "emt_doorway_drips_03", 1, 2);
sewers_helper((945, 288, 224), "emt_catacombs_drips_03", 1, 2);
sewers_helper((971, -23, 137), "emt_catacombs_drips_03", 1, 2);
sewers_helper((-242, -379, 67), "emt_doorway_drips_03", 1, 2);
sewers_helper((654, -657, 123), "emt_doorway_drips_03", 1, 2);
sewers_helper((895, 374, 471), "emt_water_spray_sewer_lp", 1, 2);
sewers_helper((916, 71, 479), "emt_doorway_drips_03", 1, 2);
sewers_helper((-725,-545,23), "emt_storm_drain_lp", 0.8, 2);
sewers_helper((392, -1007, 89), "emt_catacombs_drips_02", 1, 2);
sewers_helper((328, -1407, 92), "emt_catacombs_drips_02", 1, 2);
sewers_helper((247, -1472, 92), "emt_catacombs_drips_02", 1, 2);
sewers_helper((536, -1493, 100), "emt_catacombs_drips_02", 1, 2);
sewers_helper((669, -1918, 71), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-1572, -1214, 426), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-1654, -1330, 401), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-2302, -1304, 429), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-2346, -1223, 431), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-2512, -863, 700), "emt_catacombs_drips_02", 1, 2);
sewers_helper((-2532, -929, 674), "emt_doorway_drips_03", 1, 2);
sewers_helper((-171, -393, 184), "pars_emt_steam_lp_01", 1, 2);
sewers_helper((-2042, -1305, 514), "pars_emt_steam_lp_01", 1, 2);
sewers_helper((-2407, -658, 672), "pars_emt_steam_lp_01", 1, 2);
loop_fx_sound("pars_sewer_waterfall_splatter_large",(171,-556,28),1);
loop_fx_sound("pars_sewer_pipe_splash_lp",(177,-560,181),1);
loop_fx_sound("pars_emt_light_flicker",(136,-311,174),1);
}
damb_paris_fire_start()
{
DAMB_start_preset_at_point("fire_wood_med", (7439, 1546, 1279), "paris_aptfire_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_med_tight", (2691, 746, 914), "paris_alley_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (2485, 632, 923), "paris_alley_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3729, 313, 938), "pre_alley_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_extra_lrg_tight", (3005, -320, 966), "paris_wood_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_extra_lrg_tight", (3341, -408, 959), "paris_bigwood_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (3341, -408, 959), "paris_bigwood_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (3150, -278, 1079), "paris_wood_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_extra_med_tight", (3091, -493, 1045), "paris_wood_03", 1000, 1.0);
DAMB_start_preset_at_point("fire_metal_med", (5023, -1314, 1098), "paris_gastruck_metal_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (5023, -1314, 1098), "paris_gastruck_flame_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_metal_med", (4917, -1327, 1124), "paris_gastruck_metal_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (4917, -1327, 1124), "paris_gastruck_flame_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (3979, -1380, 1175), "paris_wood_04", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (3991, -1442, 1061), "paris_wood_05", 1000, 1.0);
DAMB_start_preset_at_point("fire_rock_lrg", (4076, -1409, 1170), "paris_wood_06", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3631, -1495, 1185), "paris_ceiling_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3626, -1526, 1179), "paris_ceiling_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3617, -1617, 1176), "paris_ceiling_03", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3705, -1796, 1162), "paris_ceilingbeam_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3572, -1778, 1150), "paris_ceilingbeam_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (3750, -1662, 1065), "paris_ceilingbeam_03", 1000, 1.0);
}
aud_broken_pipes()
{
pipe_splashes = Spawn( "script_origin",(202, -542, 0));
broken_pipe = Spawn( "script_origin",(202, -542, 208));
broken_pipe2 = Spawn( "script_origin",(202, -542, 209));
thread aud_fade_sound_in(broken_pipe, "pars_sewer_pipe_spray_lp", 1.0, 2.0, true);
thread aud_fade_sound_in(broken_pipe2, "pars_sewer_pipe_spray_02_lp", 1.0, 2.0, true);
thread aud_fade_sound_in(pipe_splashes, "pars_sewer_pipe_splash_lp", 1.0, 2.0, true);
}
rpg_explo_watch(org_ent, target_ent)
{
self waittill("death");
thread play_sound_in_space("rocket_explode_default", self.origin);
flag_set("aud_rpg_explo");
org_ent stopsounds();
target_ent stopsounds();
}
rpg_crossover(rpg_ent)
{
self endon("aud_rpg_dop_start");
while(1)
{
dist = distance2d(level.player.origin, rpg_ent.origin);
if (dist < 700)
{
flag_set("aud_rpg_dop_start");
}
}
}
aud_gaz_jump()
{
flag_wait("aud_gaz_jump");
wait(0.4);
level.player playsound("pars_gaz_jump_stairs");
}
aud_gaz_explo_on_death()
{
self waittill("death");
aud_play_linked_sound("gaz_explode_big", self);
aud_play_linked_sound("gaz_explode_crunch", self);
aud_play_linked_sound("gaz_explode_metal", self);
}
aud_van_down_big_stairs()
{
flag_wait("aud_van_down_big_stairs");
ent = spawn("script_origin", level.player.origin);
ent playsound("pars_van_down_stairs", "sounddone");
ent scalevolume(0.0, 0.01);
wait(0.5);
ent scalevolume(1, 0.5);
ent waittill("sounddone");
ent delete();
AZM_start_zone("paris_final_chase_canal", 3);
}
aud_van_to_canal()
{
flag_wait("aud_van_to_canal");
wait(2);
aud_play_2d_sound("pars_van_engine_seq_03");
}
aud_van_canal_part_2()
{
flag_wait("aud_van_canal_part_2");
}
aud_van_entering_tunnel()
{
flag_wait("aud_van_entering_tunnel");
aud_play_2d_sound("pars_van_street_to_tunnel");
}
aud_van_tunnel_turn()
{
flag_wait("aud_van_tunnel_turn");
}
aud_van_exiting_tunnel()
{
flag_wait("aud_van_exiting_tunnel");
van = spawn("script_origin", level.player.origin);
van linkto( level.player );
van playsound("pars_van_tunnel_to_street");
thread aud_stop_van_engine(van, "flag_final_crash_wall_impact_1", 1.0);
}
aud_van_volk_rundown_pt1()
{
flag_wait("aud_van_volk_rundown_pt1");
}
aud_van_over_ledge()
{
flag_wait("aud_van_over_ledge");
aud_play_2d_sound("pars_van_jump_ledge");
}
aud_van_enter_tunnel()
{
flag_wait("aud_van_enter_tunnel");
aud_play_2d_sound("pars_van_enter_tunnel_stairs");
}
aud_van_tunnel_stairs_02()
{
flag_wait("aud_van_tunnel_stairs_02");
aud_play_2d_sound("pars_van_tunnel_turn_01");
}
aud_van_tunnel_stairs_03()
{
flag_wait("aud_van_tunnel_stairs_03");
aud_play_2d_sound("pars_van_tunnel_turn_02");
}
aud_stop_van_engine(entity, stop_flag, kill_time)
{
assert(IsDefined(entity));
assert(IsDefined(stop_flag));
assert(IsDefined(kill_time));
flag_wait(stop_flag);
entity scalevolume(0.0, kill_time);
wait(kill_time);
wait(0.1);
entity stopsounds();
entity delete();
}
aud_do_catacombs_bomb()
{
aud_send_msg("catacombs_bomb_1");
Earthquake( 0.3, 3, level.player.origin, 850 );
org_fx = GetEnt("origin_catacombs_bomb_1", "targetname");
PlayFX(level._effect[ "falling_dirt_catacomb" ], org_fx.origin);
}
aud_chase_hind(hind)
{
hind Vehicle_TurnEngineOff();
wait(5);
if (IsDefined(hind))
{
thread MM_add_submix("pars_chase_hind", 2);
thread aud_play_linked_sound("chase_hind_inbound", hind);
wait(2.0);
chase_hind_loop = spawn("script_origin", hind.origin);
chase_hind_loop linkto(hind);
aud_fade_sound_in(chase_hind_loop,"chase_hind_blades_loop", 1.0, 5, true);
wait(12);
thread MM_clear_submix("pars_chase_hind", 4);
flag_wait("aud_van_enter_tunnel");
chase_hind_loop thread aud_fade_out_chase_hind_loop();
thread MM_add_submix("pars_chase_hind_strafe", 2);
wait(1.25);
aud_play_2d_sound("pars_chase_hind_strafe_fronts");
wait(5.5);
aud_play_2d_sound("pars_chase_hind_flyaway");
wait(1.0);
aud_play_2d_sound("pars_chase_hind_strafe_rear2");
thread MM_clear_submix("pars_chase_hind_strafe", 2);
}
}
aud_cleanup_chase_hind_turret(hind)
{
assert(IsDefined(hind));
hind waittill("death");
thread aud_fade_out_and_delete(level.aud.chase_hind_turret, 0.5);
}
aud_chase_hind_fire_control(hind)
{
if (IsDefined(hind))
{
if (!isDefined(level.aud.chase_hind_turret))
{
level.aud.chase_hind_turret = spawn("script_origin", hind.origin);
level.aud.chase_hind_turret linkto(hind);
thread aud_cleanup_chase_hind_turret(hind);
}
level.aud.chase_hind_turret playsound("weap_hind_turret");
}
}
aud_chase_hind_bullet_impact(hind_bullet)
{
assert(IsDefined(hind_bullet));
hind_bullet waittill("death");
aud_play_2d_sound("chase_hind_bullet_impact");
}
aud_fade_out_chase_hind_loop()
{
wait(5);
if(Isdefined(self))
{
thread aud_fade_out_and_delete(self, 3);
}
}
aud_volk_final_crash_moment()
{
flag_wait("flag_final_crash_begin");
wait(0.5);
aud_play_2d_sound("volk_crash_fruit_cart_1");
wait(0.4);
aud_play_2d_sound("volk_crash_fruit_cart_2");
flag_wait("flag_final_crash_wall_impact_1");
van = spawn("script_origin", level.player.origin);
van linkto( level.player );
van playsound("pars_van_engine_final");
van ScaleVolume(0.0);
wait(0.01);
van ScaleVolume(1.0, 0.5);
thread aud_stop_van_engine(van, "flag_final_crash_slowmo_start", 0.1);
level.player thread aud_prime_stream("volk_crash_tbone");
wait(2.75);
thread MM_start_preset("pars_volk_crash", 2.0);
flag_wait("flag_final_crash_slowmo_start");
aud_play_2d_sound("volk_crash_tbone");
MUS_stop(0.5);
flag_wait("flag_final_crash_slowmo_end");
wait(3);
MM_clear_submix("pars_volk_crash", 0.5);
aud_send_msg("mus_street_chase_end");
}
aud_volk_postcrash_foley()
{
flag_wait("flag_volk_ending_start");
thread MM_start_preset("pars_volk_foley", 1.0);
}
aud_gasmask_chatter_filter_on()
{
was_occluded = level.player IsOcclusionEnabled("voice");
level.player SetEq("voice", 0, 0, "highshelf", -8, 1150, 2);
level.player SetEq("voice", 1, 0, "highshelf", -8, 1150, 2);
aud_disable_filter_setting("voice");
return was_occluded;
}
aud_gasmask_chatter_filter_off(was_occluded_)
{
was_occluded = aud_get_optional_param(was_occluded_, true);
aud_enable_filter_setting("voice");
if (was_occluded)
{
level.player SetOcclusion("voice", 800, "highshelf", -8, 2);
}
else
{
level.player DeactivateEq(0, "voice", 0);
level.player DeactivateEq(1, "voice", 0);
}
}
aud_stop_pipe_stress()
{
wait(8);
DAMB_stop_preset("pars_sewer_pipe_stress", 10);
}

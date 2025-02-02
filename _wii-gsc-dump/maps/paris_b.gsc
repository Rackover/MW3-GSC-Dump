#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\paris_b_code;
#include maps\paris_shared;
main()
{
template_level("paris_b");
noself_delayCall(0.05, ::SetDvar, "paris_transition_movie", "");
init_level_flags();
maps\createart\paris_b_art::main();
maps\paris_b_fx::main();
maps\paris_b_precache::main();
maps\sp_paris_b_precache::main();
vehicle_scripts\_hind::main( "vehicle_mi24p_hind_woodland", undefined, "script_vehicle_hind_woodland" );
PreCacheItem( "scar_h_acog" );
PreCacheItem( "sa80lmg_fastreload_reflex" );
PreCacheItem( "ninebang_grenade" );
PreCacheItem( "flash_grenade" );
PreCacheItem( "chopper_gunner_minigun_paris" );
PreCacheItem( "rpg" );
PreCacheShellShock( "default" );
PreCacheShellShock( "paris_scripted_flashbang" );
PreCacheRumble( "viewmodel_small" );
PreCacheRumble( "viewmodel_medium" );
PreCacheRumble( "viewmodel_large" );
PreCacheRumble( "heavy_1s" );
PreCacheRumble( "heavy_2s" );
PreCacheRumble( "heavy_3s" );
PrecacheShader( "gasmask_overlay_delta2_top" );
PrecacheShader( "gasmask_overlay_delta2_bottom" );
PreCacheModel("armored_van_passengerDoor_obj");
PreCacheModel("armored_van_rearDoorR");
PreCacheModel("armored_van_rearDoorL");
PreCacheModel("paris_crowbar_01");
PreCacheModel("mil_emergency_flare");
PreCacheString(&"PARIS_FAIL_CAPTURE_VOLK_ALIVE");
PreCacheString(&"PARIS_FAIL_DONT_KILL_VOLK");
PreCacheString(&"PARIS_FAIL_KILL_VOLKS_GUARDS");
PreCacheString(&"PARIS_FAIL_SHOOT_VOLKS_CAR");
add_start( "intro_cinematic", ::debug_start_intro_cinematic, "Intro cinematic", ::intro_cinematic_logic);
add_start( "catacombs_start", ::debug_start_catacombs_start, "Catacombs Start", ::catacombs_logic);
add_start( "catacombs_skull_chamber",	::debug_start_catacombs_skull_chamber,	"Catacombs Skull Chamber", ::catacombs_skull_chamber_logic);
add_start( "chase", ::debug_start_chase, "Chase", ::chase_logic);
add_start( "chase_canal", ::debug_start_chase_canal, "Chase Canal", ::chase_canal_logic);
add_start( "chase_ending", ::debug_start_chase_ending, "Chase Ending", ::chase_ending_logic);
set_default_start( "catacombs_start" );
maps\_load::main();
setsaveddvar("ai_count", 24);
maps\paris_aud::main();
maps\paris_b_anim::main();
flashlight_init();
spawn_metrics_init();
level.scr_sound[ "breach_wooden_door" ] = "detpack_explo_main";
level.scr_sound[ "breach_wood_door_kick" ] = "wood_door_kick";
maps\paris_b_vo::main();
setup_bomb_truck();
thread setup_ignore_suppression_triggers();
level.ali_car = GetEnt("car_chemical_ali", "targetname");
level.ali_car.animname = "escape_sedan";
level.ali_car hide_destruct_parts();
level.ali_car_node = getstruct("struct_ali_car_fishtail", "script_noteworthy");
level.ali_car_node anim_first_frame_solo(level.ali_car, "sedan_escape");
level.volk_escape_table = GetEnt("volk_escape_table", "script_noteworthy");
level.volk_escape_table.animname = "volk_escape_table";
level.volk_escape_table assign_animtree();
level.volk_escape_table_props = GetEnt("volk_escape_table_props", "script_noteworthy");
level.volk_escape_table_props.animname = "volk_escape_table_props";
level.volk_escape_table_props assign_animtree();
level.struct_volk_escape_moment = getstruct("struct_volk_escape_moment", "script_noteworthy");
level.struct_volk_escape_moment anim_first_frame([level.volk_escape_table, level.volk_escape_table_props], "volk_escape");
gate_origin = getent("catacombs_gate_origin", "script_noteworthy");
gate_model = getent("catacombs_gate_model", "script_noteworthy");
gate_model.animname = "catacombs_gate";
gate_model assign_animtree();
gate_origin anim_first_frame_solo(gate_model, "catacombs_gate_enter");
getent_safe("catacombs_gate_brushmodel", "script_noteworthy") DisconnectPaths();
level.final_crash_fence = getent_safe("final_crash_fence", "script_noteworthy");
level.final_crash_fence Hide();
level.final_crash_fence.animname = "final_crash_fence";
level.final_crash_fence assign_animtree();
GetStruct("struct_final_crash_start", "script_noteworthy") anim_first_frame_solo(level.final_crash_fence, "chase_final_crash");
foreach(fence_base in GetEntArray("final_crash_fence_broken_base", "script_noteworthy"))
{
fence_base Hide();
}
thread launch_object_setup();
thread tank_stairway_moment();
thread van_climb_paired_moment();
thread spawn_gaz_02();
thread chase_uaz_01();
thread chase_gaz_02();
thread canal_combat_01();
thread canal_runners_01();
thread canal_combat_02();
thread pre_canal_combat();
thread chase_vehicles_initial_combat();
thread heli_post_river_moment();
thread catacombs_shadow_gag_main_room();
thread catacombs_enemy_gate_gag();
thread combat_staging_room();
thread minimap_switching();
thread obj_setup();
getent_safe("lone_star", "targetname").animname = "lonestar";
getent_safe("reno", "targetname").animname = "reno";
getent_safe("redshirt", "targetname").animname = "redshirt";
getent_safe("frenchie", "targetname").animname = "gign_leader";
getent_safe("lone_star_gasmask", "targetname").animname = "lonestar";
getent_safe("redshirt_gasmask", "targetname").animname = "redshirt";
foreach(spawner in GetEntArray("ai_enemy_chase_encounter_05", "script_noteworthy"))
{
spawner add_spawn_function(::ai_enemy_chase_encounter_spawn_function);
}
weapons = [
"ak47"
, "ak47"
, "ak47_acog"
, "ak47_eotech"
, "ak47_grenadier"
, "ak47_reflex"
, "ak74u"
, "ak74u_reflex"
, "ak74u_silencer"
, "coltanaconda"
, "deserteagle"
, "fnfiveseven"
, "g36c"
, "g36c_acog"
, "g36c_reflex"
, "g36c_silencer"
, "m16_acog"
, "m16_basic"
, "m16_grenadier"
, "m203"
, "m203_m4"
, "m4_grenadier"
, "mk46"
, "mk46_acog"
, "mk46_grip"
, "mk46_reflex"
, "ninebang_grenade"
, "mp5"
, "mp5_eotech"
, "mp5_reflex"
, "mp5_silencer"
, "mp5_silencer_reflex"
, "p99"
, "pecheneg"
, "pecheneg_acog"
, "pecheneg_reflex"
, "pp90m1"
, "pp90m1_reflex"
, "pp90m1_silencer"
, "rpg"
, "rpg_straight"
, "rpg_player"
, "saw_bipod_crouch"
, "saw_bipod_prone"
, "saw_bipod_stand"
, "scar_h"
, "spas12"
, "usp_no_knife"
, "usp_silencer"
];
foreach(weapon in weapons)
PrecacheItem(weapon);
persisted_weapons = maps\_loadout::RestorePlayerWeaponStatePersistent("paris", true);
if(!persisted_weapons)
{
paris_equip_player();
}
}
init_level_flags()
{
flag_init("game_fx_started");
flag_init( "flag_gasmasks_off" );
flag_init( "van_ride_complete" );
flag_init( "flag_intro_cinematic_done" );
flag_init( "flag_catacombs_gate_frenchie_idling" );
flag_init( "flag_catacombs_gate_redshirt_idling" );
flag_init( "flag_catacombs_gate_begin" );
flag_init( "flag_npc_in_squeeze_corridor" );
flag_init( "flag_frenchie_fallen_corridor_committed" );
flag_init( "flag_redshirt_fallen_corridor_committed" );
flag_init( "flag_lone_star_past_fallen_corridor" );
flag_init( "flag_reno_past_fallen_corridor" );
flag_init( "set_flare_3" );
flag_init( "flag_volk_boiler_room_escape_complete" );
flag_init( "flag_player_in_truck" );
flag_init( "flag_chase_gaz_barricade_01" );
flag_init( "flag_crash_gaz_barricade_started");
flag_init( "flag_player_to_the_front_complete" );
flag_init( "flag_van_180_skid_start" );
flag_init( "flag_get_in_van" );
flag_init( "flag_tank_moment_ai_move_up" );
flag_init( "flag_player_shot_sedan_ending" );
flag_init( "flag_final_crash_begin" );
flag_init( "flag_failure_did_not_shoot" );
flag_init( "flag_volk_ending_start" );
flag_init( "flag_stair_impact" );
flag_init( "flag_combat_staging_room" );
flag_init( "flag_obj_capture_volk_complete" );
}
start_default()
{
debug_start_catacombs_start();
}
debug_start_intro_cinematic()
{
aud_send_msg("debug_start_catacombs_start");
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
}
debug_start_catacombs_start()
{
aud_send_msg("debug_start_catacombs_start");
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
}
debug_start_catacombs_skull_chamber()
{
aud_send_msg("debug_start_catacombs_skull_chamber");
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
level.hero_lone_star = spawn_targetname("lone_star", true);
level.hero_frenchie = spawn_targetname("frenchie", true);
level.hero_reno = spawn_targetname("reno", true);
level.hero_redshirt = spawn_targetname("redshirt", true);
level.hero_lone_star set_force_color( "b" );
level.hero_reno set_force_color( "o" );
level.hero_redshirt set_force_color( "y" );
level.hero_frenchie set_force_color( "r" );
level.hero_lone_star deletable_magic_bullet_shield();
level.hero_frenchie deletable_magic_bullet_shield();
level.hero_reno deletable_magic_bullet_shield();
level.hero_redshirt deletable_magic_bullet_shield();
SetSavedDvar( "ai_friendlyFireBlockDuration", 1.25 );
teleport_to_scriptstruct("checkpoint_catacombs_skull_chamber");
for(i = 1; i <= 5; i++)
{
flare = getent_safe("flare_light_" + i, "script_noteworthy");
node = getstruct("flare_plant_" + i, "script_noteworthy");
flare flare_on(node);
}
level.hero_frenchie flashlight_guy_start();
level.hero_frenchie.aggressivemode = true;
wait 1;
foreach(guy in [level.hero_reno, level.hero_lone_star, level.hero_frenchie, level.hero_redshirt])
{
guy enable_cqbwalk();
guy enable_ai_color();
}
}
debug_start_chase()
{
aud_send_msg("debug_start_chase");
battlechatter_on( "allies" );
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
level.hero_lone_star = spawn_targetname("lone_star", true);
level.hero_frenchie = spawn_targetname("frenchie", true);
level.hero_reno = spawn_targetname("reno", true);
level.hero_redshirt = spawn_targetname("redshirt", true);
level.hero_lone_star set_force_color( "b" );
level.hero_reno set_force_color( "o" );
level.hero_redshirt set_force_color( "y" );
level.hero_frenchie set_force_color( "r" );
level.hero_lone_star deletable_magic_bullet_shield();
level.hero_frenchie deletable_magic_bullet_shield();
level.hero_reno deletable_magic_bullet_shield();
level.hero_redshirt deletable_magic_bullet_shield();
teleport_to_scriptstruct("checkpoint_chase");
SetSavedDVar("compassMaxRange", 1500);
}
debug_start_chase_canal()
{
aud_send_msg("debug_start_chase_canal");
battlechatter_on( "allies" );
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
level.hero_lone_star = spawn_targetname("lone_star", true);
level.hero_reno = spawn_targetname("reno", true);
level.hero_lone_star deletable_magic_bullet_shield();
level.hero_reno deletable_magic_bullet_shield();
level.hero_lone_star set_force_color( "b" );
level.hero_reno set_force_color( "r" );
level.bomb_truck_model hide_van_door( "door_KR" );
level.bomb_truck_model hide_van_door( "door_KL" );
level.bomb_truck_model SetAnim( level.bomb_truck getanim("player_enter_van_glass"), 1, 0, 0 );
level.bomb_truck_model SetAnimTime( level.bomb_truck getanim("player_enter_van_glass"), 1 );
bomb_truck_hide_windshield();
spawn_van_ride_weapon();
vehicle_node = GetVehicleNode("debug_start_chase_canal_vehicle_node", "script_noteworthy");
level.bomb_truck Vehicle_Teleport(vehicle_node.origin, vehicle_node.angles);
level.bomb_truck thread vehicle_paths(vehicle_node, false);
level.bomb_truck StartPath(vehicle_node);
level.player_link_ent = spawn_tag_origin();
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_player", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(0, 105, 100, 40, 40);
thread camera_shake_during_ride();
level.player AllowCrouch(true);
level.player delayCall(0.5, ::SetStance, "crouch");
level.player delayCall(.05, ::SetPlayerAngles, level.bomb_truck_model GetTagAngles("tag_player"));
level.hero_lone_star thread lonestar_rides_bomb_truck();
level.hero_reno thread frenchie_drives_truck();
flag_set("trigger_minimap_chase");
level.bomb_truck.script_badplace = false;
SetSavedDVar("compassMaxRange", 3500);
}
debug_start_chase_ending()
{
aud_send_msg("debug_start_chase_ending");
flag_set( "game_fx_started" );
vision_set_fog_changes( "paris_catacombs", 0 );
level.hero_lone_star = spawn_targetname("lone_star", true);
level.hero_reno = spawn_targetname("reno", true);
level.hero_lone_star deletable_magic_bullet_shield();
level.hero_reno deletable_magic_bullet_shield();
level.hero_lone_star set_force_color( "b" );
level.hero_reno set_force_color( "r" );
level.bomb_truck_model hide_van_door( "door_KR" );
level.bomb_truck_model hide_van_door( "door_KL" );
level.bomb_truck_model SetAnim( level.bomb_truck getanim("player_enter_van_glass"), 1, 0, 0 );
level.bomb_truck_model SetAnimTime( level.bomb_truck getanim("player_enter_van_glass"), 1 );
bomb_truck_hide_windshield();
spawn_van_ride_weapon();
vehicle_node = GetVehicleNode("debug_start_chase_ending_vehicle_node", "script_noteworthy");
level.bomb_truck Vehicle_Teleport(vehicle_node.origin, vehicle_node.angles);
level.bomb_truck thread vehicle_paths(vehicle_node, false);
level.bomb_truck StartPath(vehicle_node);
level.player_link_ent = spawn_tag_origin();
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_player", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(0, 105, 100, 40, 40);
thread camera_shake_during_ride();
level.player AllowCrouch(true);
level.player delayCall(0.5, ::SetStance, "crouch");
level.player delayCall(.05, ::SetPlayerAngles, level.bomb_truck_model GetTagAngles("tag_player"));
level.hero_lone_star thread lonestar_rides_bomb_truck();
level.hero_reno thread frenchie_drives_truck();
flag_set("trigger_minimap_chase");
SetSavedDVar("compassMaxRange", 3500);
}
intro_cinematic_logic()
{
level.hero_lone_star = spawn_targetname("lone_star_gasmask", true);
level.hero_redshirt = spawn_targetname("redshirt_gasmask", true);
flag_set( "flag_intro_cinematic" );
level.hero_lone_star add_wait(::intro_cinematic_lone_star_logic);
level.hero_redshirt add_wait(::intro_cinematic_redshirt_logic);
add_wait(::intro_cinematic_player);
do_wait();
level.hero_lone_star Delete();
level.hero_redshirt Delete();
flag_set("flag_intro_cinematic_done");
}
catacombs_logic()
{
level.hero_lone_star = spawn_targetname("lone_star", true);
level.hero_redshirt = spawn_targetname("redshirt", true);
level.hero_frenchie = spawn_targetname("frenchie", true);
level.hero_reno = spawn_targetname("reno", true);
thread catacombs_bomb_1();
thread catacombs_bomb_2();
thread maps\paris_b_vo::catacombs_nag_dialogue();
thread player_cinematic_gasmask_off();
thread battlechatter_off( "allies" );
level.player SetMoveSpeedScale(.7);
vision_set_fog_changes( "paris_catacombs" , 2 );
level.hero_lone_star add_wait(::catacombs_lone_star_logic);
level.hero_frenchie add_wait(::catacombs_frenchie_logic);
level.hero_reno add_wait(::catacombs_reno_logic);
level.hero_redshirt add_wait(::catacombs_redshirt_logic);
SetSavedDvar( "ai_friendlyFireBlockDuration", 1.25 );
add_wait(::catacombs_sequencing);
do_wait();
}
catacombs_sequencing()
{
flag_wait("flag_catacombs_gate_frenchie_idling");
flag_wait("flag_catacombs_gate_redshirt_idling");
flag_wait("trigger_catacombs_gate_player_nearby");
flag_set("flag_catacombs_gate_begin");
flag_set( "flag_dialogue_catacombs_post_breach" );
thread maps\paris_b_fx::fx_doorkick_dust();
thread catacombs_gate_gate();
thread catacombs_gate_blocker();
thread catacombs_gate_crowbar();
flag_wait("flag_frenchie_fallen_corridor_committed");
flag_wait("flag_redshirt_fallen_corridor_committed");
thread player_squeeze_through_fallen_corridor();
}
catacombs_skull_chamber_logic()
{
vision_set_fog_changes( "paris_catacombs", 0 );
thread battlechatter_off( "allies" );
level.hero_lone_star thread ally_keep_player_distance(39 * -6, .8, 1.2);
level.hero_reno thread ally_keep_player_distance(39 * -4, .8, 1.2);
level.hero_redshirt thread ally_keep_player_distance(39 * 4, .8, 1.2);
level.hero_frenchie thread ally_keep_player_distance(39 * 8, .8, 1.2);
level.player SetMoveSpeedScale(.7);
flag_wait( "flag_volk_catacombs_escape" );
thread volk_catacombs_escape();
catacombs_guys = [level.hero_reno, level.hero_lone_star, level.hero_frenchie, level.hero_redshirt];
foreach(guy in catacombs_guys)
{
guy disable_cqbwalk();
guy.movePlaybackRate = 1;
}
battlechatter_on( "allies" );
flag_wait( "flag_catacombs_bomb_3" );
thread catacombs_bomb_3();
flag_wait( "flag_ai_catacombs_exit" );
thread combat_catacombs_exit();
flag_wait( "flag_volk_boiler_room_escape" );
thread volk_boiler_room_escape();
maps\paris_b_vo::catacombs_nag_dialogue_stop();
flag_wait( "flag_ai_boiler_room_runners" );
thread boiler_room_runners();
flag_wait( "flag_volk_apartment_escape" );
thread volk_apartment_escape();
flag_wait( "flag_catacombs_ally_exit" );
thread allies_in_boiler_room_stop_sprint();
level.hero_frenchie flashlight_guy_stop();
level.hero_frenchie.aggressivemode = undefined;
vision_set_fog_changes( "paris_b" , 2 );
flag_wait( "flag_ai_boiler_room_exit" );
addforcestreamxmodel("vehicle_gaz_tigr_harbor_pb");
aud_send_msg("mus_catacombs_chase_end");
thread combat_boiler_room_exit();
}
chase_logic()
{
flag_wait( "trigger_found_bomb_truck" );
triggers = GetEntArray( "trigger_chase_scripting_on", "targetname" );
foreach(trigger in triggers)
{
trigger trigger_off();
}
thread spawn_corpses("dead_gign_chase_1");
thread chemical_ali_escape();
thread van_crash_gaz_barricade();
wait 6;
flag_set( "flag_get_in_van" );
player_rides_bomb_truck();
reduced_accuracy_for_ride_begin();
thread ai_clean_up_catatombs_exit();
thread player_move_to_back();
thread fake_rpg_chase_2();
thread fake_rpg_chase_3();
thread ai_clean_up_pre_stairs();
thread ai_clean_up_post_stairs();
}
chase_canal_logic()
{
thread fake_rpg_chase_4();
flag_wait("spawn_tank_02");
river_moment();
thread ai_clean_up_canal();
thread ai_clean_up_mid_canal();
thread uaz_jump_bridge();
thread ai_clean_up_post_canal();
thread ai_clean_up_galleria();
thread gallery_gate_crash_enter();
thread gallery_gate_crash_exit();
}
chase_ending_logic()
{
thread player_to_front_of_truck();
final_crash_moment_vehicle_animations();
reduced_accuracy_for_ride_end();
chase_ending_moment();
}
obj_setup()
{
obj_create_completed_objectives();
switch( level.start_point )
{
case "intro_cinematic":
flag_wait("flag_intro_cinematic_done");
case "default":
case "catacombs_start":
case "catacombs_skull_chamber":
obj_follow_gign_catacombs();
case "chase":
obj_capture_volk();
obj_get_in_van();
case "chase_canal":
case "chase_ending":
obj_capture_volk_chase();
break;
default:
AssertMsg("Unhandled start point " + level.start_point);
}
}
obj_create_completed_objectives()
{
objective_add( 1, "invisible", &"PARIS_OBJECTIVE_MEET_GIGN" );
objective_state_nomessage(1, "done");
objective_add( 2, "invisible", &"PARIS_OBJECTIVE_DESTROY_BTR" );
objective_state_nomessage(2, "done");
objective_add( 3, "invisible", &"PARIS_OBJECTIVE_FOLLOW_GIGN" );
objective_state_nomessage(3, "done");
if(level.start_point == "intro_cinematic") return;
if(level.start_point == "default") return;
if(level.start_point == "catacombs_start") return;
if(level.start_point == "catacombs_skull_chamber") return;
objective_add( 11, "invisible", &"PARIS_OBJECTIVE_FOLLOW_GIGN_CATACOMBS" );
objective_state_nomessage(11, "done");
flag_set("flag_obj_capture_volk_position_change_1");
flag_set("flag_obj_capture_volk_position_change_2");
if(level.start_point == "chase") return;
if(level.start_point == "chase_canal") return;
objective_add( 12, "invisible", &"PARIS_OBJECTIVE_CAPTURE_VOLK" );
objective_add( 13, "invisible", &"PARIS_OBJECTIVE_GET_IN_VAN" );
objective_state_nomessage(6, "done");
if(level.start_point == "chase_ending") return;
AssertMsg("Unhandled start point in obj_create_completed_objectives(): " + level.start_point);
}
obj_follow_gign_catacombs()
{
objective_number = 11;
objective_add( objective_number, "active", &"PARIS_OBJECTIVE_FOLLOW_GIGN_CATACOMBS" );
while(!IsDefined(level.hero_frenchie))
{
waitframe();
}
Objective_OnEntity_safe( objective_number, level.hero_frenchie );
objective_current( objective_number );
flag_wait( "flag_volk_catacombs_escape" );
objective_complete( objective_number );
}
obj_capture_volk()
{
while(!IsDefined(level.volk))
{
waitframe();
}
wait 1.5;
objective_number = 12;
objective_add( objective_number, "active", &"PARIS_OBJECTIVE_CAPTURE_VOLK" );
Objective_OnEntity( objective_number, level.volk , ( 0, 0, 64) );
Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_CAPTURE" );
objective_current( objective_number );
for(;; waitframe())
{
if(IsAlive(level.volk))
{
if(level.volk.origin[2] > 472)
{
if(IsDefined(level.last_volk_origin))
{
Objective_Position( objective_number, level.last_volk_origin);
Objective_SetPointerTextOverride( objective_number, "" );
}
break;
}
else
{
level.last_volk_origin = level.volk.origin + (0, 0, 64);
Objective_OnEntity( objective_number, level.volk , ( 0, 0, 64) );
Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_CAPTURE" );
}
}
else
{
Objective_Position( objective_number, level.last_volk_origin);
Objective_SetPointerTextOverride( objective_number, "" );
}
}
flag_wait("flag_obj_capture_volk_position_change_1");
Objective_Position( objective_number, getstruct( "obj_capture_volk_target_1", "targetname" ).origin );
flag_wait("flag_obj_capture_volk_position_change_2");
Objective_Position( objective_number, getstruct( "obj_capture_volk_target_2", "targetname" ).origin );
flag_wait("trigger_found_bomb_truck");
while(!IsDefined(level.volk))
{
waitframe();
}
Objective_OnEntity_safe( objective_number, level.volk , ( 0, 0, 64) );
Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_CAPTURE" );
while(IsDefined(level.volk) && !flag("flag_get_in_van"))
{
waitframe();
}
}
obj_get_in_van()
{
objective_number = 13;
objective_add( objective_number, "active", &"PARIS_OBJECTIVE_GET_IN_VAN" ,getstruct( "obj_05_truck_target", "targetname" ).origin );
Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_ENTER" );
objective_current( objective_number );
flag_wait( "flag_player_in_truck" );
objective_complete( objective_number );
}
obj_capture_volk_chase()
{
objective_delete(12);
objective_number = 14;
Objective_String_NoMessage( objective_number, &"PARIS_OBJECTIVE_CAPTURE_VOLK" );
Objective_Current_NoMessage( objective_number );
flag_wait( "flag_player_to_the_front" );
while(!IsDefined(level.volk))
{
waitframe();
}
Objective_OnEntity_safe( objective_number, level.volk , ( 0, 0, 64) );
Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_CAPTURE" );
flag_wait( "flag_obj_capture_volk_complete" );
wait 2;
objective_complete( objective_number );
}

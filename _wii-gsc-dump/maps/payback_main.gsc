#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\payback_util;
#include maps\payback_sandstorm_code;
#include maps\payback_env_code;
main()
{
maps\createart\payback_art::main();
if( !is_split_level() )
{
maps\payback_fx::main();
}
else
{
[[level.FXMainFunc]]();
}
maps\payback_fx_sp::main();
maps\payback_aud::main();
init_payback_flags();
init_assets();
maps\payback_anim::payback_vehicle_anim_overrides();
add_hint_string( "Payback_Dont_Abandon_Mission", &"PAYBACK_DONT_ABANDON_MISSION", maps\payback_1_script_a::HasPlayerReturnedToCompound );
add_hint_string( "chopper_zoom_hint", &"REMOTE_CHOPPER_GUNNER_ZOOM_HINT", maps\payback_1_script_d::Should_Not_Display_Zoom_Hint );
level.cosine = [];
level.cosine[ "5" ] = cos( 5 );
level.cosine[ "10" ] = cos( 10 );
level.cosine[ "15" ] = cos( 15 );
level.cosine[ "20" ] = cos( 20 );
level.cosine[ "25" ] = cos( 25 );
level.cosine[ "30" ] = cos( 30 );
level.cosine[ "35" ] = cos( 35 );
level.cosine[ "40" ] = cos( 40 );
level.cosine[ "45" ] = cos( 45 );
level.cosine[ "55" ] = cos( 55 );
if( !is_split_level() || is_split_level_part("a") )
{
define_loadout( "payback" );
define_introscreen("payback_a");
}
maps\_drone_ai::init();
if( !is_split_level() || is_split_level_part("a") )
{
maps\_breach::main();
maps\_breach_explosive_left::main();
}
maps\_load::main();
maps\_flare_no_sunchange_pb::main( "tag_flash" );
sandstorm_skybox_hide();
level.payback_breach = 1;
maps\_load::set_player_viewhand_model( "viewhands_player_yuri" );
flag_set( "payback_stealth_ready" );
maps\payback_anim::main();
if ( !IsDefined( level.no_breach ) )
{
if( !is_split_level() || is_split_level_part("a") )
{
maps\_slowmo_breach_payback::slowmo_breach_init();
}
}
trigger_off( "breach_save_trig_1" , "targetname" );
trigger_off( "breach_save_trig_2" , "targetname" );
trigger_off( "ready_to_pick_up_niko_save_trig" , "targetname" );
if( is_split_level_part("a") )
{
compound_turret1 = GetEnt( "compound_turret1" , "targetname" );
compound_turret1 MakeUnusable();
}
if( is_split_level_part("a2") )
{
militia_window_mg = GetEnt( "militia_window_mg" , "targetname" );
militia_window_mg MakeUnusable();
militia_window_mg2 = GetEnt( "militia_window_mg2" , "targetname" );
militia_window_mg2 MakeUnusable();
}
if( is_split_level_part("b") )
{
street_run_anim_check_triggers = GetEntArray( "street_run_anim_check_triggers", "script_noteworthy" );
foreach ( trigger in street_run_anim_check_triggers )
{
trigger trigger_off();
}
sslight_01 = GetEnt( "payback_geo_2b_lights2_sslight_01" , "targetname" );
sslight_01 SetLightIntensity( 0 );
street_light_gate = GetEnt( "payback_geo_2b_lights2_street_light_gate" , "targetname" );
street_light_gate SetLightIntensity( 0 );
}
setup_spawn_funcs();
maps\_utility::vision_set_fog_changes( "payback", 0 );
price_spawner = getEnt( "price", "script_noteworthy" );
price_spawner add_spawn_function( ::setup_price );
soap_spawner = getEnt( "soap", "script_noteworthy" );
soap_spawner add_spawn_function( ::setup_soap );
nikolai_spawner = getEnt( "nikolai", "script_noteworthy" );
nikolai_spawner add_spawn_function( ::setup_nikolai );
hannibal_spawner = getEnt( "hannibal" , "script_noteworthy" );
hannibal_spawner add_spawn_function( ::setup_hannibal );
barracus_spawner = getEnt( "barracus" , "script_noteworthy" );
barracus_spawner add_spawn_function( ::setup_barracus );
murdock_spawner = getEnt( "murdock" , "script_noteworthy" );
murdock_spawner add_spawn_function( ::setup_murdock );
level.friendly_startup_thread = ::assign_friendlies;
init_objectives();
tv_triggers = GetEntArray( "tv_trigger", "targetname" );
foreach ( tv_trig in tv_triggers )
{
tv_trig thread tv_trigger_wait_enter( tv_trig.script_noteworthy, tv_trig.script_parameters );
}
thread maps\payback_env_code::handle_spawning_of_sandstorm_models();
blocker_vols = GetEntArray("construction_roof_blocker_volume","targetname");
blocker_vols[blocker_vols.size] = GetEnt("construction_roof_blocker_volume_during_anim","targetname");
foreach(vol in blocker_vols)
{
vol NotSolid();
vol ConnectPaths();
}
so_assets = GetEntArray( "so_asset", "targetname" );
foreach(so_asset in so_assets)
{
so_asset Delete();
}
}
init_objectives()
{
objective_add( obj( "obj_kruger" ), "invisible", &"PAYBACK_OBJ_KRUGER" );
objective_add( obj( "obj_primary_lz" ), "invisible", &"PAYBACK_OBJ_PRIMARY_LZ" );
objective_add( obj( "obj_secondary_lz" ), "invisible", &"PAYBACK_OBJ_SECONDARY_LZ" );
objective_add( obj( "obj_find_chopper" ), "invisible", &"PAYBACK_OBJ_FIND_CHOPPER" );
objective_add( obj( "obj_rescue" ), "invisible", &"PAYBACK_OBJ_RESCUE" );
if( is_split_level_part("a2") )
{
Objective_State_NoMessage( obj( "obj_kruger" ), "done");
Objective_State( obj( "obj_primary_lz" ), "current");
}
else if( is_split_level_part("b") )
{
Objective_State_NoMessage( obj( "obj_kruger" ), "done");
Objective_State_NoMessage( obj( "obj_primary_lz" ), "done");
Objective_State_NoMessage( obj( "obj_secondary_lz" ), "done");
Objective_State( obj( "obj_find_chopper" ), "current");
}
}
init_payback_flags()
{
flag_init( "payback_stealth_ready" );
maps\payback_compound::init_flags_compound();
maps\payback_1_script_e::kruger_interrogation_init();
maps\payback_streets_const::init_construction_flags();
maps\payback_streets::init_flags_streets();
maps\payback_rescue::init_flags_rescue();
}
init_assets()
{
precacheitem("m4m203_acog_payback");
PreCacheItem( "deserteagle" );
PreCacheItem( "remote_chopper_gunner" );
PreCacheItem( "scuba_mask_on" );
PreCacheItem( "scuba_mask_off" );
PreCacheItem( "hind_12.7mm" );
PreCacheItem( "zippy_rockets" );
PreCacheModel( "generic_prop_raven" );
PreCacheModel( "viewhands_player_yuri" );
PreCacheModel( "viewhands_yuri" );
PreCacheModel( "viewlegs_generic" );
PreCacheModel( "tag_flash" );
PreCacheModel( "com_flashlight_on" );
PreCacheModel( "com_flashlight_off" );
PreCacheModel( "payback_sstorm_dwarf_palm" );
PreCacheModel( "pb_sstorm_tree_jungle" );
PreCacheModel( "payback_sstorm_grass" );
PreCacheModel( "com_square_flag_green" );
PreCacheModel( "highrise_fencetarp_08" );
PreCacheModel( "highrise_fencetarp_01" );
PreCacheModel( "highrise_fencetarp_03" );
PreCacheModel( "payback_const_crates" );
PreCacheModel( "payback_studwall_collapse" );
PreCacheModel( "vehicle_pickup_technical_pb_rusted" );
precacheShader( "javelin_overlay_grain" );
precacheShader( "nightvision_overlay_goggles" );
PreCacheShader( "veh_hud_target_chopperfly" );
PreCacheShader( "veh_hud_target_chopperfly_offscreen" );
PreCacheShader( "veh_hud_target_offscreen" );
PreCacheShader( "remote_chopper_hud_reticle" );
PreCacheShader( "remote_chopper_hud_target_hit" );
PreCacheShader( "remote_chopper_hud_target_enemy" );
PreCacheShader( "remote_chopper_hud_target_e_vehicle" );
PreCacheShader( "remote_chopper_hud_target_friendly" );
PreCacheShader( "remote_chopper_hud_target_player" );
PreCacheShader( "remote_chopper_hud_targeting_frame" );
PreCacheShader( "remote_chopper_hud_targeting_bar" );
PreCacheShader( "remote_chopper_hud_targeting_circle" );
PreCacheShader( "remote_chopper_hud_targeting_rectangle" );
PreCacheShader( "remote_chopper_hud_compass_bar" );
PreCacheShader( "remote_chopper_hud_compass_bracket" );
PreCacheShader( "remote_chopper_hud_compass_triangle" );
PreCacheShader( "remote_chopper_overlay_scratches" );
PreCacheShader( "dpad_remote_chopper_gunner" );
PreCacheShader( "hud_dpad" );
PreCacheShader( "hud_arrow_right" );
PreCacheShader( "overlay_sandstorm" );
PreCacheShader( "overlay_static" );
PreCacheShader( "stance_carry" );
PreCacheShader( "gfx_laser_light_bright");
PreCacheShader( "gfx_laser_bright");
PreCacheString( &"PAYBACK_REMOTE_CHOPPER_TURRET" );
PreCacheString( &"PAYBACK_FAIL_ABANDONED" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_TADS" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_RCT_ACTIVE" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_X" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_Z" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_12_7MM" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_ROUNDS" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_63" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_N1_4" );
PreCacheString( &"REMOTE_CHOPPER_GUNNER_RECORDING" );
PreCacheString( &"PAYBACK_KRUGER_NEEDED_ALIVE" );
PreCacheString( &"PAYBACK_USE_THE_ROPE" );
PreCacheString( &"PAYBACK_JUMP" );
PreCacheString( &"PAYBACK_STAY_WITH_TEAM" );
PreCacheString( &"PAYBACK_CAPTURE_KRUGER" );
PreCacheString( &"PAYBACK_KEEP_UP" );
PreCacheString( &"PAYBACK_FAIL_GAS" );
PreCacheString( &"PAYBACK_JEEP_JUMP" );
PreCacheString( &"PAYBACK_RUN_TO_JEEP" );
PreCacheRumble( "heavy_3s" );
PreCacheRumble( "damage_heavy" );
PreCacheRumble( "crash_heli_rumble_rest" );
PreCacheRumble( "steady_rumble" );
PreCacheRumble( "light_1s" );
PrecacheRumble( "subtle_tank_rumble" );
PrecacheRumble( "viewmodel_large" );
PrecacheRumble( "grenade_rumble" );
maps\_treadfx::setallvehiclefx( "script_vehicle_payback_hind", "treadfx/Heli_sand_pb" );
}
assign_friendlies()
{
self endon("death");
if( IsDefined( self.script_noteworthy ))
{
switch( self.script_noteworthy )
{
case "hannibal":
if( !IsDefined( level.hannibal ) && !IsAlive(level.hannibal ) )
{
self setup_hannibal();
return;
}
break;
case "murdock":
if( !IsDefined( level.murdock ) && !IsAlive( level.murdock ) )
{
self setup_murdock();
return;
}
break;
case "barracus":
if( !IsDefined( level.barracus) && !IsAlive( level.barracus) )
{
self setup_barracus();
return;
}
break;
}
}
while(1)
{
if( !IsDefined( level.hannibal ) && !IsAlive(level.hannibal ) )
{
level.hannibal = self;
self.script_noteworthy = "hannibal";
self.animname = "hannibal";
self setup_merc();
level notify( "hannibal_spawned" );
return;
}
else if( !IsDefined( level.murdock ) && !IsAlive( level.murdock ) )
{
level.murdock = self;
self.script_noteworthy = "murdock";
self setup_merc();
level notify( "murdock_spawned" );
return;
}
else if( !IsDefined( level.barracus ) && !IsAlive( level.barracus ) )
{
level.barracus = self;
self.script_noteworthy = "barracus";
self setup_merc();
level notify( "barracus_spawned" );
return;
}
wait 0.1;
if (!IsDefined(self) || !IsAlive(self))
{
break;
}
}
}
setup_price()
{
level.price = self;
level.price magic_bullet_shield();
level.price.animname = "price";
level.price thread make_hero();
level.price.voice = "taskforce";
level.price.countryID = "TF";
level.price payback_setup_stealth();
level.price.baseAccuracy = 0.5;
}
setup_soap()
{
level.soap = self;
level.soap magic_bullet_shield();
level.soap.animname = "soap";
level.soap.disable_sniper_glint = 1;
level.soap.voice = "taskforce";
level.soap.countryID = "TF";
level.soap payback_setup_stealth();
level.soap.baseAccuracy = 0.5;
}
setup_kruger()
{
level.kruger = self;
level.kruger magic_bullet_shield();
level.kruger.animname = "kruger";
level.kruger.notarget = true;
}
setup_nikolai()
{
level.nikolai = self;
level.nikolai.ignoreall = true;
level.nikolai.notarget = true;
level.nikolai magic_bullet_shield();
level.nikolai.animname = "nikolai";
level.nikolai.ignoreme = true;
level.nikolai.baseAccuracy = 0.5;
}
remove_funcs_from( who, func )
{
ents = getEntArray( who , "script_noteworthy" );
foreach(ent in ents)
{
if( IsSpawner( ent ) )
{
ent remove_spawn_function( func );
}
}
}
setup_hannibal()
{
level.hannibal = self;
setup_merc();
self.animname = "hannibal";
remove_funcs_from( "hannibal" , ::setup_hannibal );
level notify( self.script_noteworthy + "_spawned" );
}
setup_barracus()
{
level.barracus = self;
setup_merc();
remove_funcs_from( "barracus" , ::setup_barracus );
level notify( self.script_noteworthy + "_spawned" );
}
setup_murdock()
{
level.murdock = self;
setup_merc();
remove_funcs_from( "murdock" , ::setup_murdock );
level notify( self.script_noteworthy + "_spawned" );
}
setup_merc()
{
self thread replace_on_death();
self payback_setup_stealth();
self.baseAccuracy = 0.5;
}
payback_setup_stealth()
{
}
friendly_color_hidden_override()
{
if ( IsDefined(self.script_forcecolor) )
{
self set_force_color( self.script_forcecolor );
self.fixednode = true;
}
}






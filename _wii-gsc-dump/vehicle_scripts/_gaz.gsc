#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "gaz_tigr_harbor", model, type, classname );
build_localinit( ::init_local );
build_unload_groups( ::Unload_Groups );
build_drive( %humvee_50cal_driving_idle_forward, %humvee_50cal_driving_idle_backward, 10 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "axis" );
if( IsSubStr( classname, "turret" ) )
{
build_aianims( ::setanims_turret, ::set_vehicle_anims );
if ( IsSubStr( classname, "_paris" ) || isSubStr( classname, "_hijack" ) || isSubStr( classname, "_harbor") )
{
build_turret( "dshk_gaz_damage_player", "tag_turret", "weapon_dshk_turret", undefined, "auto_ai", 0.2, -20, -14 );
}
else
{
build_turret( "dshk_gaz", "tag_turret", "weapon_dshk_turret", undefined, "auto_ai", 0.2, -20, -14 );
}
}
else
{
build_aianims( ::setanims, ::set_vehicle_anims );
}
if ( classname == "script_vehicle_gaz_tigr_turret_physics_paris" || classname == "script_vehicle_gaz_tigr_turret_physics_paris_streamed" || classname == "script_vehicle_gaz_tigr_paris_streamed" )
{
build_destructible( model, "vehicle_gaz_harbor" );
}
else
{
build_gaz_death( classname );
}
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "headlight_L", "TAG_HEADLIGHT_LEFT", "misc/spotlight_btr80_daytime", "running", 0.0 );
build_light( lightmodel, "headlight_R", "TAG_HEADLIGHT_RIGHT", "misc/spotlight_btr80_daytime", "running", 0.0 );
build_light( lightmodel, "brakelight_L", "TAG_BRAKELIGHT_LEFT", "misc/car_taillight_btr80_eye", "running", 0.0 );
build_light( lightmodel, "brakelight_R", "TAG_BRAKELIGHT_RIGHT", "misc/car_taillight_btr80_eye", "running", 0.0 );
}
init_local()
{
}
unload_groups()
{
unload_groups = [];
group = "passengers";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
group = "all_but_gunner";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
group = "rear_driver_side";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
group = "all";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ "default" ] = unload_groups[ "all" ];
return unload_groups;
}
build_gaz_death( classname )
{
level._effect[ "gazfire" ] = loadfx( "fire/firelp_med_pm_nolight" );
level._effect[ "gazexplode" ] = loadfx( "explosions/vehicle_explosion_gaz" );
level._effect[ "gazcookoff" ] = loadfx( "explosions/ammo_cookoff" );
level._effect[ "gazsmfire" ] = loadfx( "fire/firelp_small_pm_a" );
build_deathmodel( "vehicle_gaz_tigr_harbor", "vehicle_gaz_tigr_harbor_destroyed" );
build_deathmodel( "vehicle_gaz_tigr_harbor_pb", "vehicle_gaz_tigr_harbor_destroyed" );
if( level.script == "paris_ac130" )
{
build_deathmodel( "vehicle_gaz_tigr_base", "vehicle_gaz_tigr_harbor_destroyed_pc" );
}
else
{
build_deathmodel( "vehicle_gaz_tigr_base", "vehicle_gaz_tigr_harbor_destroyed" );
}
build_deathfx( "explosions/vehicle_explosion_gaz", "tag_deathfx" );
build_deathfx( "fire/firelp_med_pm_nolight", "tag_cab_fx", undefined, undefined, undefined, true, 0 );
build_deathfx( "fire/firelp_small_pm_a" , "tag_trunk_fx", undefined, undefined, undefined, true, 3 );
build_deathquake( 1, 1.6, 500 );
build_radiusdamage( ( 0, 0, 32 ), 300, 200, 0, false );
}
#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
positions[ 0 ].vehicle_getoutanim = %gaz_dismount_frontl_door;
positions[ 1 ].vehicle_getoutanim = %gaz_dismount_frontr_door;
positions[ 2 ].vehicle_getoutanim = %gaz_dismount_backl_door;
positions[ 3 ].vehicle_getoutanim = %gaz_dismount_backr_door;
positions[ 0 ].vehicle_getinanim = %gaz_mount_frontl_door;
positions[ 1 ].vehicle_getinanim = %gaz_mount_frontr_door;
positions[ 2 ].vehicle_getinanim = %gaz_enter_back_door;
positions[ 3 ].vehicle_getinanim = %gaz_enter_back_door;
positions[ 0 ].vehicle_getoutsound = "gaz_door_open";
positions[ 1 ].vehicle_getoutsound = "gaz_door_open";
positions[ 2 ].vehicle_getoutsound = "gaz_door_open";
positions[ 3 ].vehicle_getoutsound = "gaz_door_open";
positions[ 0 ].vehicle_getinsound = "gaz_door_close";
positions[ 1 ].vehicle_getinsound = "gaz_door_close";
positions[ 2 ].vehicle_getinsound = "gaz_door_close";
positions[ 3 ].vehicle_getinsound = "gaz_door_close";
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 4;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "tag_driver";
positions[ 1 ].sittag = "tag_passenger";
positions[ 2 ].sittag = "tag_guy0";
positions[ 3 ].sittag = "tag_guy1";
positions[ 0 ].bHasGunWhileRiding = false;
positions[ 0 ].death = %gaz_dismount_frontl;
positions[ 0 ].death_delayed_ragdoll = 3;
positions[ 0 ].idle = %gaz_idle_frontl;
positions[ 1 ].idle = %gaz_idle_frontr;
positions[ 2 ].idle = %gaz_idle_backl;
positions[ 3 ].idle = %gaz_idle_backr;
positions[ 0 ].getout = %gaz_dismount_frontl;
positions[ 1 ].getout = %gaz_dismount_frontr;
positions[ 2 ].getout = %gaz_dismount_backl;
positions[ 3 ].getout = %gaz_dismount_backr;
positions[ 0 ].getin = %gaz_mount_frontl;
positions[ 1 ].getin = %gaz_mount_frontr;
positions[ 2 ].getin = %gaz_enter_backr;
positions[ 3 ].getin = %gaz_enter_backl;
return positions;
}
setanims_turret()
{
positions = setanims();
positions[ 3 ].mgturret = 0;
positions[ 3 ].passenger_2_turret_func = ::gaz_turret_guy_gettin_func;
positions[ 3 ].sittag = "tag_guy_turret";
return positions;
}
gaz_turret_guy_gettin_func( vehicle, guy, pos, turret )
{
}




















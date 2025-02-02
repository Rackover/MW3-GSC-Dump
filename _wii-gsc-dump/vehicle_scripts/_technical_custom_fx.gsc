#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
vehicle_scripts\_technical::build_technical( model, type, classname, "weapon_m2_50cal_center", "50cal_turret_technical" );
vehicle_scripts\_technical::build_technical_anims();
build_technical_death_custom_fx( classname );
}
build_technical_death_custom_fx( classname )
{
build_deathmodel( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", 1, classname );
build_deathfx( "fire/firelp_med_pm_nolight_15sec", "tag_fx_tank", "smallfire", undefined, undefined, true, 0);
build_deathfx( "explosions/ammo_cookoff", "tag_fx_bed", undefined, undefined, undefined, undefined, 0.5);
build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck", "tag_deathfx", "car_explode", undefined, undefined, undefined, 0.9);
build_deathfx( "fire/firelp_small_pm_a_15sec", "tag_fx_tire_right_r", "smallfire", undefined, undefined, true, 1);
build_deathfx( "fire/firelp_med_pm_nolight_15sec", "tag_fx_cab", "fire_metal_medium",undefined, undefined, true, 1.01);
build_deathfx( "fire/firelp_small_pm_a_15sec", "tag_engine_left", "smallfire", undefined, undefined, true, 1.01);
build_death_badplace( .5, 3, 512, 700, "axis", "allies" );
build_death_jolt( 0.9 );
build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, true, 0.9 );
}




main()
{
vehicle_scripts\_bus::main( "vehicle_london_bus", undefined, "script_vehicle_bus_london" );
vehicle_scripts\_coupe::main( "vehicle_coupe_gray_destructible", undefined, "script_vehicle_coupe_gray" );
vehicle_scripts\_littlebird::main( "vehicle_little_bird_bench", undefined, "script_vehicle_littlebird_bench" );
vehicle_scripts\_london_cab::main( "vehicle_london_cab_black_destructible", undefined, "script_vehicle_london_cab_black" );
vehicle_scripts\_subway::main( "vehicle_subway_cart_destructible", undefined, "script_vehicle_subway_cart_destructible" );
vehicle_scripts\_uk_delivery_truck::main( "vehicle_uk_delivery_truck", "uk_delivery_truck_physics", "script_vehicle_uk_delivery_truck_physics" );
vehicle_scripts\_uk_police_estate::main( "uk_police_estate_destructible", "uk_police_estate_physics", "script_vehicle_uk_police_estate_physics" );
common_scripts\_destructible_types_anim_light_fluo_single::main();
common_scripts\_destructible_types_anim_security_camera::main();
}

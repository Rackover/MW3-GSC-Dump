#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "zodiac", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_zodiac" );
build_life( 999, 500, 1500 );
build_team( "allies" );
build_aianims( ::setanims, ::set_vehicle_anims );
build_unload_groups( ::Unload_Groups );
}
init_local()
{
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 6;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "tag_body";
positions[ 1 ].sittag = "tag_body";
positions[ 2 ].sittag = "tag_body";
positions[ 3 ].sittag = "tag_body";
positions[ 4 ].sittag = "tag_body";
positions[ 5 ].sittag = "tag_body";
positions[ 0 ].idle = %oilrig_civ_escape_1_seal_A;
positions[ 1 ].idle = %oilrig_civ_escape_2_seal_A;
positions[ 2 ].idle = %oilrig_civ_escape_3_A;
positions[ 3 ].idle = %oilrig_civ_escape_4_A;
positions[ 4 ].idle = %oilrig_civ_escape_5_A;
positions[ 5 ].idle = %oilrig_civ_escape_6_A;
positions[ 0 ].getout = %pickup_driver_climb_out;
positions[ 1 ].getout = %pickup_driver_climb_out;
positions[ 2 ].getout = %pickup_passenger_climb_out;
positions[ 3 ].getout = %pickup_passenger_climb_out;
positions[ 4 ].getout = %pickup_passenger_climb_out;
positions[ 5 ].getout = %pickup_passenger_climb_out;
return positions;
}
unload_groups()
{
unload_groups = [];
unload_groups[ "passengers" ] = [];
unload_groups[ "all" ] = [];
group = "passengers";
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ group ][ unload_groups[ group ].size ] = 4;
unload_groups[ group ][ unload_groups[ group ].size ] = 5;
group = "all";
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ group ][ unload_groups[ group ].size ] = 4;
unload_groups[ group ][ unload_groups[ group ].size ] = 5;
unload_groups[ "default" ] = unload_groups[ "all" ];
return unload_groups;
}












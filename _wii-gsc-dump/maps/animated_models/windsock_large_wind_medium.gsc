#include common_scripts\utility;

#using_animtree( "animated_props" );
main()
{
    if( !isdefined ( level.anim_prop_models ) )
        level.anim_prop_models = [];
        
    // Would use isSP() but this runs before we can
    mapname = tolower( getdvar( "mapname" ) );
    SP = true;
    if ( string_starts_with( mapname, "mp_" ) )
        SP = false;
        
    model = "accessories_windsock_large";
    if ( SP )
    {
        level.anim_prop_models[ model ][ "self.wind" ] = %windsock_large_wind_medium;
    }
    else
        level.anim_prop_models[ model ][ "self.wind" ] = "windsock_large_wind_medium";
}
    
#include common_scripts\utility;
#using_animtree( "animated_props" );
main()
{
waittillframeend;
init_wind_if_uninitialized();
level.init_animatedmodels_dump = [];
level.anim_prop_models_animtree = #animtree;
if ( !isdefined( level.anim_prop_models ) )
level.anim_prop_models = [];
if ( !IsDefined( level.anim_prop_init_threads ) )
level.anim_prop_init_threads = [];
animated_models = GetEntArray( "animated_model", "targetname" );
array_thread( animated_models, ::model_init );
if ( isdefined( level.init_animatedmodels_dump ) && level.init_animatedmodels_dump.size )
{
all_dumped_items = " ";
foreach ( dump_item in level.init_animatedmodels_dump )
all_dumped_items += dump_item + " ";
AssertMsg( "^3["+ all_dumped_items + "] Anims not cached for animated prop model, Repackage Zones and Rebuild Precache Script in Launcher, OR CHECK THE TEMPLATE GSC!" );
}
foreach ( model in animated_models )
{
if ( IsDefined( level.anim_prop_init_threads[ model.model ] ) )
{
model thread [[ level.anim_prop_init_threads[ model.model ] ]]();
}
else
{
keys = GetArrayKeys( level.anim_prop_models[ model.model ] );
scriptedWind = false;
foreach ( key in keys )
{
if ( key == "still" )
{
scriptedWind = true;
break;
}
}
if(level.script != "firingrange")
{
if ( scriptedWind )
model thread animateTreeWind();
else
model thread animateModel();
}
}
}
}
init_wind_if_uninitialized()
{
if ( IsDefined( level.wind ) )
return;
level.wind = SpawnStruct();
level.wind.rate = 0.4;
level.wind.weight = 1;
level.wind.variance = 0.2;
}
model_init()
{
println("INIT MODEL " + self.model);
if ( !isdefined( level.anim_prop_models[ self.model ] ) )
{
if ( !already_dumpped( level.init_animatedmodels_dump, self.model ) )
level.init_animatedmodels_dump[ level.init_animatedmodels_dump.size ] = self.model;
}
}
already_dumpped( array, compare )
{
if ( array.size <= 0 )
return false;
foreach ( member in array )
{
if ( member == compare )
return true;
}
return false;
}
animateModel()
{
self UseAnimTree( #animtree );
keys = GetArrayKeys( level.anim_prop_models[ self.model ] );
animkey = keys[ RandomInt( keys.size ) ];
animation = level.anim_prop_models[ self.model ][ animkey ];
self SetAnim( animation, 1, self GetAnimTime( animation ), 1 );
self SetAnimTime( animation, RandomFloatRange( 0, 1 ) );
}
animateTreeWind()
{
self UseAnimTree( #animtree );
wind = "strong";
while ( 1 )
{
thread blendTreeAnims( wind );
level waittill( "windchange", wind );
}
}
blendTreeAnims( animation )
{
level endon( "windchange" );
windweight = level.wind.weight;
windrate = level.wind.rate + RandomFloat( level.wind.variance );
self SetAnim( level.anim_prop_models[ self.model ][ "still" ], 1, self GetAnimTime( level.anim_prop_models[ self.model ][ "still" ] ), windrate );
self SetAnim( level.anim_prop_models[ self.model ][ animation ], windweight, self GetAnimTime( level.anim_prop_models[ self.model ][ animation ] ), windrate );
}


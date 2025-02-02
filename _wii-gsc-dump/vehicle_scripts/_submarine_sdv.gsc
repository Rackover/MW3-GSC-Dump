#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_utility;
#using_animtree( "vehicles" );
main( model, type, classname, norumble )
{
if (model == "vehicle_submarine_sdv")
build_template( "submarine_sdv", model, type, classname );
else
build_template( "blackshadow_730", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( model );
build_life( 999, 500, 1500 );
if (!isDefined(norumble) || !norumble)
{
if (model == "vehicle_submarine_sdv")
build_rumble( "tank_rumble", 0.05, 1.5, 900, 1, 1 );
}
build_team( "allies" );
level._effect[ "sdv_prop_wash_1" ] = loadfx( "water/sdv_prop_wash_2" );
level._effect[ "sdv_headlights" ] = loadfx( "misc/spotlight_submarine_sdv" );
}
init_local()
{
self ent_flag_init( "moving" );
self ent_flag_init( "lights" );
self thread cleanup_sdv();
self thread handle_move();
self thread handle_lights();
}
handle_move()
{
self endon("sdv_done");
self endon("death");
while (true)
{
self ent_flag_wait( "moving" );
self thread play_sound_on_tag( "sdv_start", "TAG_PROPELLER" );
self delaythread( 1,::play_loop_sound_on_tag, "sdv_move_loop", "TAG_PROPELLER", true );
playfxontag( getfx( "sdv_prop_wash_1" ), self, "TAG_PROPELLER" );
self ent_flag_waitopen( "moving" );
stopfxontag( getfx( "sdv_prop_wash_1" ), self, "TAG_PROPELLER" );
self notify( "stop sound" + "sdv_move_loop" );
self thread play_sound_on_tag( "sdv_stop", "TAG_PROPELLER" );
}
}
cleanup_sdv()
{
self waittill_either("sdv_done", "death");
if (self ent_flag("lights"))
{
stopfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_L" );
stopfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_R" );
}
if (self ent_flag("moving"))
{
stopfxontag( getfx( "sdv_prop_wash_1" ), self, "TAG_PROPELLER" );
self notify( "stop sound" + "sdv_move_loop" );
}
}
handle_lights()
{
self endon("sdv_done");
self endon("death");
while (true)
{
self ent_flag_wait( "lights" );
playfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_L" );
playfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_R" );
self ent_flag_waitopen( "lights" );
stopfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_L" );
stopfxontag( getfx( "sdv_headlights" ), self, "TAG_LIGHT_R" );
}
}









#include common_scripts\utility;
friendly_bubbles()
{
self endon( "death" );
self notify( "stop_friendly_bubbles" );
self endon( "stop_friendly_bubbles" );
self thread friendly_bubbles_cleanup();
tag = "TAG_EYE";
while ( true )
{
wait( 3.5 + randomfloat( 3 ) );
playfxOnTag( getfx( "scuba_bubbles_friendly" ), self, tag );
}
}
friendly_bubbles_stop()
{
self notify( "stop_friendly_bubbles" );
}
friendly_bubbles_cleanup()
{
self endon("death");
self waittillmatch( "single anim", "surfacing" );
self notify ( "stop_friendly_bubbles" );
}
player_scuba()
{
if ( !isSplitscreen() )
self thread player_scuba_breathe_sound();
else
{
if ( self == level.player )
self thread player_scuba_breathe_sound();
}
self thread player_scuba_bubbles();
}
player_scuba_breathe_sound()
{
self endon("death");
self notify( "start_scuba_breathe" );
self endon( "start_scuba_breathe" );
self endon( "stop_scuba_breathe" );
while ( true )
{
wait( 0.05 );
self notify( "scuba_breathe_sound_starting" );
self playLocalSound( "scuba_breathe_player", "scuba_breathe_sound_done" );
self waittill( "scuba_breathe_sound_done" );
}
}
stop_player_scuba()
{
self notify( "stop_scuba_breathe" );
self stopLocalSound( "scuba_breathe_player" );
}
debug_org()
{
while( true )
{
print3d( self.origin + ( 0, 0, 0 ), "ORG", ( 1, 1, 1 ), 1, 0.5 );
wait( 0.5 );
}
}
player_scuba_bubbles()
{
self endon("death");
self endon( "stop_scuba_breathe" );
playerFxOrg = spawn( "script_model", self.origin + ( 0, 0, 0 ) );
playerFxOrg setmodel( "tag_origin" );
playerFxOrg.angles = self.angles;
playerFxOrg.origin = level.player.origin + ( 0, 0, 0 );
playerFxOrg linkto( self, "", ( 15, 0, 54 ), ( 0, 0, 0 ) );
playerFxOrg hide();
self thread scuba_fx_cleanup( playerFxOrg );
while ( true )
{
wait( 1.8 );
self thread player_bubbles_fx( playerFxOrg );
wait( 6.2 );
self thread player_bubbles_fx( playerFxOrg );
wait( 6.5 );
self thread player_bubbles_fx( playerFxOrg );
wait( 7.5 );
self thread player_bubbles_fx( playerFxOrg );
wait( 6.8 );
self thread player_bubbles_fx( playerFxOrg );
wait( 6.5 );
self thread player_bubbles_fx( playerFxOrg );
self waittill( "scuba_breathe_sound_starting" );
}
}
scuba_fx_cleanup( playerFxOrg )
{
self waittill( "stop_scuba_breathe" );
playerFxOrg delete();
}
player_bubbles_fx( playerFxOrg )
{
self endon( "stop_scuba_breathe" );
playfxontag( getfx( "scuba_bubbles" ), playerFxOrg, "TAG_ORIGIN" );
}
underwater_hud_enable( bool )
{
wait 0.05;
if ( bool == true )
{
SetSavedDvar( "hud_showStance", "0" );
SetSavedDvar( "compass", "0" );
SetSavedDvar( "ammoCounterHide", "1" );
setsaveddvar( "g_friendlyNameDist", 0 );
}
else
{
setSavedDvar( "hud_drawhud", "1" );
SetSavedDvar( "hud_showStance", "1" );
SetSavedDvar( "compass", "1" );
SetSavedDvar( "ammoCounterHide", "0" );
setsaveddvar( "g_friendlyNameDist", 15000 );
}
}
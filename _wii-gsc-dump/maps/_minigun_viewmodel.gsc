#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
player_viewhands_minigun( turret, viewhands_model )
{
if (!isdefined(viewhands_model))
viewhands_model = "viewhands_player_us_army";
turret useAnimTree( #animtree );
turret.animname = "suburban_hands";
turret.has_hands = false;
turret show_hands(viewhands_model);
turret set_idle();
turret thread player_viewhands_minigun_hand( "LEFT" );
turret thread player_viewhands_minigun_hand( "RIGHT" );
turret thread handle_mounting(viewhands_model);
}
set_idle()
{
self setAnim( %player_suburban_minigun_idle_L, 1, 0, 1 );
self setAnim( %player_suburban_minigun_idle_R, 1, 0, 1 );
}
handle_mounting(viewhands_model)
{
turret = self;
turret endon ( "death" );
while( true )
{
turret waittill ( "turretownerchange" );
owner = turret GetTurretOwner();
if ( !IsAlive( owner ) )
hide_hands(viewhands_model);
else
show_hands(viewhands_model);
}
}
show_hands( viewhands_model )
{
if (!isdefined(viewhands_model))
viewhands_model = "viewhands_player_us_army";
turret = self;
Assert( turret.code_classname == "misc_turret" );
Assert( IsDefined( turret.has_hands ) );
if( turret.has_hands )
return;
turret DontCastShadows();
turret.has_hands = true;
turret attach( viewhands_model, "tag_player" );
}
hide_hands(viewhands_model)
{
if (!isdefined(viewhands_model))
viewhands_model = "viewhands_player_us_army";
turret = self;
Assert( turret.code_classname == "misc_turret" );
Assert( IsDefined( turret.has_hands ) );
if( ! turret.has_hands )
return;
turret CastShadows();
turret.has_hands = false;
turret detach( viewhands_model, "tag_player" );
}
#using_animtree( "vehicles" );
anim_minigun_hands()
{
level.scr_animtree[ "suburban_hands" ] = #animtree;
level.scr_model[ "suburban_hands" ] = "viewhands_player_us_army";
level.scr_anim[ "suburban_hands" ][ "idle_L" ] = %player_suburban_minigun_idle_L;
level.scr_anim[ "suburban_hands" ][ "idle_R" ] = %player_suburban_minigun_idle_R;
level.scr_anim[ "suburban_hands" ][ "idle2fire_L" ] = %player_suburban_minigun_idle2fire_L;
level.scr_anim[ "suburban_hands" ][ "idle2fire_R" ] = %player_suburban_minigun_idle2fire_R;
level.scr_anim[ "suburban_hands" ][ "fire2idle_L" ] = %player_suburban_minigun_fire2idle_L;
level.scr_anim[ "suburban_hands" ][ "fire2idle_R" ] = %player_suburban_minigun_fire2idle_R;
}
player_viewhands_minigun_hand( hand )
{
self endon( "death" );
checkFunc = undefined;
if ( hand == "LEFT" )
checkFunc = ::spinButtonPressed;
else if ( hand == "RIGHT" )
checkFunc = ::fireButtonPressed;
assert( isdefined( checkFunc ) );
for(;;)
{
if( level.player [[checkFunc]]() )
{
thread player_viewhands_minigun_presed( hand );
while( level.player [[checkFunc]]() )
wait 0.05;
}
else
{
thread player_viewhands_minigun_idle( hand );
while( !level.player [[checkFunc]]() )
wait 0.05;
}
}
}
spinButtonPressed()
{
if ( level.player AdsButtonPressed() )
return true;
if ( level.player AttackButtonPressed() )
return true;
return false;
}
fireButtonPressed()
{
return level.player AttackButtonPressed();
}
player_viewhands_minigun_idle( hand )
{
animHand = undefined;
if ( hand == "LEFT" )
animHand = "L";
else if ( hand == "RIGHT" )
animHand = "R";
assert( isdefined( animHand ) );
self clearAnim( self getanim( "idle2fire_" + animHand ), 0.2 );
self setFlaggedAnimRestart( "anim", self getanim( "fire2idle_" + animHand ) );
self waittillmatch( "anim", "end" );
self clearAnim( self getanim( "fire2idle_" + animHand ), 0.2 );
self setAnim( self getanim( "idle_" + animHand ) );
}
player_viewhands_minigun_presed( hand )
{
animHand = undefined;
if ( hand == "LEFT" )
animHand = "L";
else if ( hand == "RIGHT" )
animHand = "R";
assert( isdefined( animHand ) );
self clearAnim( self getanim( "idle_" + animHand ), 0.2 );
self setAnim( self getanim( "idle2fire_" + animHand ) );
}
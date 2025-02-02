#include animscripts\Utility;
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );
main()
{
self.traverseDeath = 1;
self advancedTraverse2( %traverse90, 96 );
}
advancedTraverse2( traverseAnim, normalHeight )
{
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "nogravity" );
self traverseMode( "noclip" );
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
realHeight = startnode.traverse_height - startnode.origin[ 2 ];
self setFlaggedAnimKnoballRestart( "traverse", traverseAnim, %body, 1, 0.15, 1 );
timer = gettime();
self thread animscripts\notetracks::DoNoteTracksForever( "traverse", "no clear", ::handle_death );
if ( !animhasnotetrack( traverseAnim, "gravity on" ) )
{
timer = 1.23;
timerOffset = 0.2;
wait 5.0;
self traverseMode( "gravity" );
wait( timerOffset );
}
else
{
self waittillmatch( "traverse", "gravity on" );
self traverseMode( "gravity" );
if ( !animhasnotetrack( traverseAnim, "blend" ) )
wait( 0.2 );
else
self waittillmatch( "traverse", "blend" );
}
}
handle_death( note )
{
println( note );
if ( note != "traverse_death" )
return;
self endon( "killanimscript" );
if ( self.health == 1 )
{
self.a.nodeath = true;
if ( self.traverseDeath > 1 )
self setFlaggedAnimKnobAll( "deathanim", %traverse90_end_death, %body, 1, .2, 1 );
else
self setFlaggedAnimKnobAll( "deathanim", %traverse90_start_death, %body, 1, .2, 1 );
self animscripts\face::SayGenericDialogue( "death" );
}
self.traverseDeath++ ;
}
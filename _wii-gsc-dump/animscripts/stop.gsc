
#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#using_animtree( "generic_human" );
main()
{
if ( isdefined( self.no_ai ) )
return;
if ( isdefined( self.onSnowMobile ) )
{
animscripts\snowmobile::main();
return;
}
if ( IsDefined( self.custom_animscript_table ) )
{
if ( IsDefined( self.custom_animscript_table[ "stop" ] ) )
{
[[ self.custom_animscript_table[ "stop" ] ]]();
return;
}
}
self notify( "stopScript" );
self endon( "killanimscript" );
[[ self.exception[ "stop_immediate" ] ]]();
thread delayedException();
animscripts\utility::initialize( "stop" );
specialIdleLoop();
self randomizeIdleSet();
self thread setLastStoppedTime();
self thread animscripts\reactions::reactionsCheckLoop();
transitionedToIdle = isdefined( self.customIdleAnimSet );
if ( !transitionedToIdle )
{
if ( self.a.weaponPos[ "right" ] == "none" && self.a.weaponPos[ "left" ] == "none" )
transitionedToIdle = true;
else if ( AngleClamp180( self getMuzzleAngle()[ 0 ] ) > 20 )
transitionedToIdle = true;
}
for ( ;; )
{
desiredPose = getDesiredIdlePose();
if ( desiredPose == "prone" )
{
transitionedToIdle = true;
self ProneStill();
}
else
{
assertex( desiredPose == "crouch" || desiredPose == "stand", desiredPose );
if ( self.a.pose != desiredPose )
{
self clearAnim( %root, 0.3 );
transitionedToIdle = false;
}
self SetPoseMovement( desiredPose, "stop" );
if ( !transitionedToIdle )
{
self transitionToIdle( desiredPose, self.a.idleSet );
transitionedToIdle = true;
}
else
{
self playIdle( desiredPose, self.a.idleSet );
}
}
}
}
setLastStoppedTime()
{
self endon( "death" );
self waittill( "killanimscript" );
self.lastStoppedTime = gettime();
}
specialIdleLoop()
{
self endon( "stop_specialidle" );
if ( isdefined( self.specialIdleAnim ) )
{
idleAnimArray = self.specialIdleAnim;
self.specialIdleAnim = undefined;
self notify( "clearing_specialIdleAnim" );
self animmode( "gravity" );
self orientmode( "face current" );
self clearAnim( %root, .2 );
while ( 1 )
{
self setflaggedanimrestart( "special_idle", idleAnimArray[ randomint( idleAnimArray.size ) ], 1, 0.2, self.animplaybackrate );
self waittillmatch( "special_idle", "end" );
}
}
}
getDesiredIdlePose()
{
myNode = animscripts\utility::GetClaimedNode();
if ( isDefined( myNode ) )
{
myNodeAngle = myNode.angles[ 1 ];
myNodeType = myNode.type;
}
else
{
myNodeAngle = self.desiredAngle;
myNodeType = "node was undefined";
}
self animscripts\face::SetIdleFace( anim.alertface );
desiredPose = animscripts\utility::choosePose();
if ( myNodeType == "Cover Stand" || myNodeType == "Conceal Stand" )
{
desiredPose = animscripts\utility::choosePose( "stand" );
}
else if ( myNodeType == "Cover Crouch" || myNodeType == "Conceal Crouch" )
{
desiredPose = animscripts\utility::choosePose( "crouch" );
}
else if ( myNodeType == "Cover Prone" || myNodeType == "Conceal Prone" )
{
desiredPose = animscripts\utility::choosePose( "prone" );
}
return desiredPose;
}
transitionToIdle( pose, idleSet )
{
if ( self isCQBWalking() && self.a.pose == "stand" )
pose = "stand_cqb";
if ( isdefined( anim.idleAnimTransition[ pose ] ) )
{
assert( isdefined( anim.idleAnimTransition[ pose ][ "in" ] ) );
idleAnim = anim.idleAnimTransition[ pose ][ "in" ];
self setFlaggedAnimKnobAllRestart( "idle_transition", idleAnim, %body, 1, .2, self.animplaybackrate );
self animscripts\shared::DoNoteTracks( "idle_transition" );
}
}
playIdle( pose, idleSet )
{
if ( self isCQBWalking() && self.a.pose == "stand" )
pose = "stand_cqb";
idleAddAnim = undefined;
if ( isdefined( self.customIdleAnimSet ) && isdefined( self.customIdleAnimSet[ pose ] ) )
{
idleAnim = self.customIdleAnimSet[ pose ];
additive = pose + "_add";
if ( isdefined( self.customIdleAnimSet[ additive ] ) )
idleAddAnim = self.customIdleAnimSet[ additive ];
}
else if ( isdefined(anim.readyAnimArray) && (pose == "stand" || pose == "stand_cqb") && isdefined(self.bUseReadyIdle) && self.bUseReadyIdle == true )
{
idleAnim = anim_array( anim.readyAnimArray[ "stand" ][ 0 ], anim.readyAnimWeights[ "stand" ][ 0 ] );
}
else
{
idleSet = idleSet % anim.idleAnimArray[ pose ].size;
idleAnim = anim_array( anim.idleAnimArray[ pose ][ idleSet ], anim.idleAnimWeights[ pose ][ idleSet ] );
}
transTime = 0.2;
if ( gettime() == self.a.scriptStartTime )
transTime = 0.5;
if ( isdefined( idleAddAnim ) )
{
self setAnimKnobAll( idleAnim, %body, 1, transTime, 1 );
self setAnim( %add_idle );
self setFlaggedAnimKnobAllRestart( "idle", idleAddAnim, %add_idle, 1, transTime, self.animplaybackrate );
}
else
{
self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, transTime, self.animplaybackrate );
}
self animscripts\shared::DoNoteTracks( "idle" );
}
ProneStill()
{
if ( self.a.pose != "prone" )
{
anim_array[ "stand_2_prone" ] = %stand_2_prone;
anim_array[ "crouch_2_prone" ] = %crouch_2_prone;
transAnim = anim_array[ self.a.pose + "_2_prone" ];
assertex( isdefined( transAnim ), self.a.pose );
assert( animHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );
self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
animscripts\shared::DoNoteTracks( "trans" );
assert( self.a.pose == "prone" );
self.a.movement = "stop";
self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );
return;
}
self thread UpdateProneThread();
if ( randomint( 10 ) < 3 )
{
twitches = [];
twitches[ 0 ] = %prone_twitch_ammocheck;
twitches[ 1 ] = %prone_twitch_look;
twitches[ 2 ] = %prone_twitch_scan;
twitches[ 3 ] = %prone_twitch_lookfast;
twitches[ 4 ] = %prone_twitch_lookup;
twitchAnim = twitches[ randomint( twitches.size ) ];
self setFlaggedAnimKnobAll( "prone_idle", twitchAnim, %exposed_modern, 1, 0.2 );
}
else
{
self setAnimKnobAll( %prone_aim_5, %exposed_modern, 1, 0.2 );
self setFlaggedAnimKnob( "prone_idle", %prone_idle, 1, 0.2 );
}
self waittillmatch( "prone_idle", "end" );
self notify( "kill UpdateProneThread" );
}
UpdateProneThread()
{
self endon( "killanimscript" );
self endon( "kill UpdateProneThread" );
for ( ;; )
{
self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
wait 0.1;
}
}
delayedException()
{
self endon( "killanimscript" );
wait( 0.05 );
[[ self.exception[ "stop" ] ]]();
}
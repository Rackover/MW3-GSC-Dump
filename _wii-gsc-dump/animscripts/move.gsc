#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\notetracks;
#include animscripts\shared;
#include animscripts\melee;
#include common_scripts\utility;
#include maps\_utility;
#using_animtree( "generic_human" );
main()
{
if ( IsDefined( self.custom_animscript_table ) )
{
if ( IsDefined( self.custom_animscript_table[ "move" ] ) )
{
[[ self.custom_animscript_table[ "move" ] ]]();
return;
}
}
self endon( "killanimscript" );
[[ self.exception[ "move" ] ]]();
moveInit();
getUpIfProne();
animscripts\utility::initialize( "move" );
wasInCover = self wasPreviouslyInCover();
if ( wasInCover && isdefined( self.shuffleMove ) )
{
moveCoverToCover();
moveCoverToCoverFinish();
}
else if ( IsDefined( self.battleChatter ) && self.battleChatter )
{
self moveStartBattleChatter( wasInCover );
self animscripts\battlechatter::playBattleChatter();
}
self thread stairsCheck();
self thread pathChangeCheck();
self thread animDodgeObstacle();
self animscripts\cover_arrival::startMoveTransition();
self.doingReacquireStep = undefined;
self.ignorePathChange = undefined;
self thread startThreadsToRunWhileMoving();
self thread animscripts\cover_arrival::setupApproachNode( true );
self.shoot_while_moving_thread = undefined;
self.aim_while_moving_thread = undefined;
self.runNGun = undefined;
MoveMainLoop( true );
}
end_script()
{
if ( isdefined( self.oldGrenadeWeapon ) )
{
self.grenadeWeapon = self.oldGrenadeWeapon;
self.oldGrenadeWeapon = undefined;
}
self.teamFlashbangImmunity = undefined;
self.minInDoorTime = undefined;
self.ignorePathChange = undefined;
self.shuffleMove = undefined;
self.shuffleNode = undefined;
self.runNGun = undefined;
self.reactingToBullet = undefined;
self.requestReactToBullet = undefined;
self.currentDodgeAnim = undefined;
self.moveLoopOverrideFunc = undefined;
}
moveInit()
{
self.reactingToBullet = undefined;
self.requestReactToBullet = undefined;
self.update_move_anim_type = undefined;
self.update_move_front_bias = undefined;
self.runNGunWeight = 0;
self.arrivalStartDist = undefined;
}
getUpIfProne()
{
if ( self.a.pose == "prone" )
{
newPose = self animscripts\utility::choosePose( "stand" );
if ( newPose != "prone" )
{
self orientMode( "face current" );
self animMode( "zonly_physics", false );
rate = 1;
if ( isdefined( self.grenade ) )
rate = 2;
self animscripts\cover_prone::proneTo( newPose, rate );
self animMode( "none", false );
self orientMode( "face default" );
}
}
}
wasPreviouslyInCover()
{
switch( self.prevScript )
{
case "cover_crouch":
case "cover_left":
case "cover_prone":
case "cover_right":
case "cover_stand":
case "concealment_crouch":
case "concealment_prone":
case "concealment_stand":
case "cover_wide_left":
case "cover_wide_right":
case "hide":
case "turret":
return true;
}
return false;
}
moveStartBattleChatter( wasInCover )
{
if ( self.moveMode == "run" )
{
self animscripts\battleChatter_ai::evaluateMoveEvent( wasInCover );
}
}
MoveMainLoop( doWalkCheck )
{
MoveMainLoopInternal( doWalkCheck );
self notify( "abort_reload" );
}
ChangeMoveMode( moveMode )
{
if ( moveMode != self.prevMoveMode )
{
if ( isdefined( self.customMoveAnimSet ) && isdefined( self.customMoveAnimSet[ moveMode ] ) )
{
self.a.moveAnimSet = self.customMoveAnimSet[ moveMode ];
}
else
{
self.a.moveAnimSet = anim.animsets.move[ moveMode ];
if ( ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" ) &&
( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > squared( 100 ) ) )
{
self.sideStepRate = 1;
animscripts\animset::set_ambush_sidestep_anims();
}
else
{
self.sideStepRate = 1.35;
}
}
self.prevMoveMode = moveMode;
}
}
MoveMainLoopInternal( doWalkCheck )
{
self endon( "killanimscript" );
self endon( "move_interrupt" );
prevLoopTime = self getAnimTime( %walk_and_run_loops );
self.a.runLoopCount = randomint( 10000 );
self.prevMoveMode = "none";
self.moveLoopCleanupFunc = undefined;
for ( ;; )
{
loopTime = self getAnimTime( %walk_and_run_loops );
if ( loopTime < prevLoopTime )
self.a.runLoopCount++ ;
prevLoopTime = loopTime;
ChangeMoveMode( self.moveMode );
MoveMainLoopProcess( self.moveMode );
if ( isDefined( self.moveLoopCleanupFunc ) )
{
self [[self.moveLoopCleanupFunc]]();
self.moveLoopCleanupFunc = undefined;
}
self notify( "abort_reload" );
}
}
MoveMainLoopProcess( moveMode )
{
self endon( "move_loop_restart" );
self animscripts\face::SetIdleFaceDelayed( anim.alertface );
if ( isdefined( self.moveLoopOverrideFunc ) )
{
self [[ self.moveLoopOverrideFunc ]]();
}
else if ( self shouldCQB() )
{
self animscripts\cqb::MoveCQB();
}
else
{
if ( moveMode == "run" )
{
self animscripts\run::MoveRun();
}
else
{
assert( moveMode == "walk" );
self animscripts\walk::MoveWalk();
}
}
self.requestReactToBullet = undefined;
}
MayShootWhileMoving()
{
if ( self.weapon == "none" )
return false;
weapclass = weaponClass( self.weapon );
if ( !usingRifleLikeWeapon() )
return false;
if ( self isSniper() )
{
if ( !( self isCQBWalking() ) && self.faceMotion )
return false;
}
if ( isdefined( self.dontShootWhileMoving ) )
{
assert( self.dontShootWhileMoving );
return false;
}
return true;
}
shootWhileMoving()
{
self endon( "killanimscript" );
self notify( "doing_shootWhileMoving" );
self endon( "doing_shootWhileMoving" );
if ( isdefined( self.combatStandAnims ) && isdefined( self.combatStandAnims[ "fire" ] ) )
self.a.array[ "fire" ] = self.combatStandAnims[ "fire" ];
else
self.a.array[ "fire" ] = %exposed_shoot_auto_v3;
if ( isdefined( self.weapon ) && weapon_pump_action_shotgun() )
self.a.array[ "single" ] = array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );
else
self.a.array[ "single" ] = array( %exposed_shoot_semi1 );
self.a.array[ "burst2" ] = %exposed_shoot_burst3;
self.a.array[ "burst3" ] = %exposed_shoot_burst3;
self.a.array[ "burst4" ] = %exposed_shoot_burst4;
self.a.array[ "burst5" ] = %exposed_shoot_burst5;
self.a.array[ "burst6" ] = %exposed_shoot_burst6;
self.a.array[ "semi2" ] = %exposed_shoot_semi2;
self.a.array[ "semi3" ] = %exposed_shoot_semi3;
self.a.array[ "semi4" ] = %exposed_shoot_semi4;
self.a.array[ "semi5" ] = %exposed_shoot_semi5;
while ( 1 )
{
if ( !self.bulletsInClip )
{
if ( self isCQBWalkingOrFacingEnemy() )
{
self.ammoCheatTime = 0;
cheatAmmoIfNecessary();
}
if ( !self.bulletsInClip )
{
wait 0.5;
continue;
}
}
self shootUntilShootBehaviorChange();
self clearAnim( %exposed_aiming, 0.2 );
}
}
startThreadsToRunWhileMoving()
{
self endon( "killanimscript" );
wait 0.05;
self thread bulletWhizbyCheck_whileMoving();
self thread meleeAttackCheck_whileMoving();
self thread animscripts\door::inDoorCqbToggleCheck();
self thread animscripts\door::doorEnterExitCheck();
}
stairsCheck()
{
self endon( "killanimscript" );
self.prevStairsState = self.stairsState;
while ( 1 )
{
wait .05;
if ( self.prevStairsState != self.stairsState )
{
if ( !isdefined( self.ignorePathChange ) || self.stairsState != "none" )
self notify( "move_loop_restart" );
}
self.prevStairsState = self.stairsState;
}
}
restartMoveLoop( skipMoveTransition )
{
self endon( "killanimscript" );
if ( !skipMoveTransition )
animscripts\cover_arrival::startMoveTransition();
self.ignorePathChange = undefined;
self clearanim( %root, 0.1 );
self OrientMode( "face default" );
self animMode( "none", false );
self.requestArrivalNotify = true;
MoveMainLoop( !skipMoveTransition );
}
pathChangeCheck()
{
self endon( "killanimscript" );
self endon( "move_interrupt" );
self.ignorePathChange = true;
while ( 1 )
{
self waittill( "path_changed", doingReacquire, newDir );
assert( !isdefined( self.ignorePathChange ) || self.ignorePathChange );
if ( isdefined( self.ignorePathChange ) || isdefined( self.noTurnAnims ) )
continue;
if ( !self.faceMotion || abs( self getMotionAngle() ) > 15 )
continue;
if ( self.a.movement != "run" && self.a.movement != "walk" )
continue;
if ( self.a.pose != "stand" )
continue;
self notify( "stop_move_anim_update" );
self.update_move_anim_type = undefined;
angleDiff = AngleClamp180( self.angles[ 1 ] - vectortoyaw( newDir ) );
turnAnim = pathChange_getTurnAnim( angleDiff );
if ( isdefined( turnAnim ) )
{
self.turnAnim = turnAnim;
self.turnTime = getTime();
self.moveLoopOverrideFunc = ::pathChange_doTurnAnim;
self notify( "move_loop_restart" );
self animscripts\run::endFaceEnemyAimTracking();
}
}
}
pathChange_getTurnAnim( angleDiff )
{
if ( isdefined( self.pathTurnAnimOverrideFunc ) )
return [[ self.pathTurnAnimOverrideFunc ]]( angleDiff );
turnAnim = undefined;
secondTurnAnim = undefined;
if ( self shouldCQB() || self.movemode == "walk" )
animArray = anim.cqbTurnAnims;
else
animArray = anim.runTurnAnims;
if ( angleDiff < -30 )
{
if ( angleDiff > -60 )
{
turnAnim = animArray[ "L45" ];
}
else if ( angleDiff > -112.5 )
{
turnAnim = animArray[ "L90" ];
if ( angleDiff > -90 )
secondTurnAnim = animArray[ "L45" ];
else
secondTurnAnim = animArray[ "L135" ];
}
else if ( angleDiff > -157.5 )
{
turnAnim = animArray[ "L135" ];
if ( angleDiff > -135 )
secondTurnAnim = animArray[ "L90" ];
else
secondTurnAnim = animArray[ "180" ];
}
else
{
turnAnim = animArray[ "180" ];
secondTurnAnim = animArray[ "L135" ];
}
}
else if ( angleDiff > 30 )
{
if ( angleDiff < 60 )
{
turnAnim = animArray[ "R45" ];
}
else if ( angleDiff < 112.5 )
{
turnAnim = animArray[ "R90" ];
if ( angleDiff < 90 )
secondTurnAnim = animArray[ "R45" ];
else
secondTurnAnim = animArray[ "R135" ];
}
else if ( angleDiff < 157.5 )
{
turnAnim = animArray[ "R135" ];
if ( angleDiff < 135 )
secondTurnAnim = animArray[ "R90" ];
else
secondTurnAnim = animArray[ "180" ];
}
else
{
turnAnim = animArray[ "180" ];
secondTurnAnim = animArray[ "R135" ];
}
}
if ( isdefined( turnAnim ) )
{
if ( pathChange_canDoTurnAnim( turnAnim ) )
return turnAnim;
}
if ( isdefined( secondTurnAnim ) )
{
if ( pathChange_canDoTurnAnim( secondTurnAnim ) )
return secondTurnAnim;
}
return undefined;
}
pathChange_canDoTurnAnim( turnAnim )
{
if ( !isdefined( self.pathgoalpos ) )
return false;
codeMoveTimes = getNotetrackTimes( turnAnim, "code_move" );
assert( codeMoveTimes.size == 1 );
codeMoveTime = codeMoveTimes[ 0 ];
assert( codeMoveTime <= 1 );
moveDelta = getMoveDelta( turnAnim, 0, codeMoveTime );
codeMovePoint = self localToWorldCoords( moveDelta );
if ( isdefined( self.arrivalStartDist ) && ( squared( self.arrivalStartDist ) > distanceSquared( self.pathgoalpos, codeMovePoint ) ) )
return false;
moveDelta = getMoveDelta( turnAnim, 0, 1 );
endPoint = self localToWorldCoords( moveDelta );
endPoint = codeMovePoint + vectornormalize( endPoint - codeMovePoint ) * 20;
return self mayMoveFromPointToPoint( codeMovePoint, endPoint, true, true );
}
pathChange_doTurnAnim()
{
self endon( "killanimscript" );
self.moveLoopOverrideFunc = undefined;
turnAnim = self.turnAnim;
if ( gettime() > self.turnTime + 50 )
return;
self animMode( "zonly_physics", false );
self clearanim( %body, 0.1 );
self.moveLoopCleanupFunc = ::pathChange_cleanupTurnAnim;
self.ignorePathChange = true;
blendTime = 0.05;
if ( isdefined( self.pathTurnAnimBlendTime ) )
blendTime = isdefined( self.pathTurnAnimBlendTime );
self setflaggedanimrestart( "turnAnim", turnAnim, 1, blendTime, self.movePlaybackRate );
self OrientMode( "face current" );
assert( animHasNotetrack( turnAnim, "code_move" ) );
self animscripts\shared::DoNoteTracks( "turnAnim" );
self.ignorePathChange = undefined;
self OrientMode( "face motion" );
self animmode( "none", false );
self animscripts\shared::DoNoteTracks( "turnAnim" );
}
pathChange_doMoveTransition()
{
self.moveLoopOverrideFunc = undefined;
if ( gettime() > self.turnTime + 50 )
return;
self.moveLoopCleanupFunc = ::pathChange_cleanupTurnAnim;
animscripts\cover_arrival::startMoveTransition();
}
pathChange_cleanupTurnAnim()
{
self.ignorePathChange = undefined;
self OrientMode( "face default" );
self clearanim( %root, 0.1 );
self animMode( "none", false );
}
dodgeMoveLoopOverride()
{
self pushplayer( true );
self animMode( "zonly_physics", false );
self clearanim( %body, 0.2 );
self setflaggedanimrestart( "dodgeAnim", self.currentDodgeAnim, 1, 0.2, 1 );
self animscripts\shared::DoNoteTracks( "dodgeAnim" );
self animmode( "none", false );
self orientMode( "face default" );
if ( animHasNotetrack( self.currentDodgeAnim, "code_move" ) )
self animscripts\shared::DoNoteTracks( "dodgeAnim" );
self clearanim( %civilian_dodge, 0.2 );
self pushplayer( false );
self.currentDodgeAnim = undefined;
self.moveLoopOverrideFunc = undefined;
return true;
}
tryDodgeWithAnim( dodgeAnim, dodgeAnimDelta )
{
rightDir = ( self.lookAheadDir[1], -1 * self.lookAheadDir[0], 0 );
forward = self.lookAheadDir * dodgeAnimDelta[0];
right = rightDir * dodgeAnimDelta[1];
dodgePos = self.origin + forward - right;
self pushPlayer( true );
if ( self mayMoveToPoint( dodgePos ) )
{
self.currentDodgeAnim = dodgeAnim;
self.moveLoopOverrideFunc = ::dodgeMoveLoopOverride;
self notify( "move_loop_restart" );
return true;
}
self pushPlayer( false );
return false;
}
animDodgeObstacle()
{
if ( !isdefined( self.dodgeLeftAnim ) || !isdefined( self.dodgeRightAnim ) )
return;
self endon( "killanimscript" );
self endon( "move_interrupt" );
while ( 1 )
{
self waittill( "path_need_dodge", dodgeEnt, dodgeEntPos );
if ( self animscripts\utility::IsInCombat() )
{
self.noDodgeMove = false;
return;
}
if ( !isSentient( dodgeEnt ) )
continue;
dirToDodgeEnt = vectorNormalize( dodgeEntPos - self.origin );
if ( ( self.lookAheadDir[0] * dirToDodgeEnt[1] ) - ( dirToDodgeEnt[0] * self.lookAheadDir[1] ) > 0 )
{
if ( !tryDodgeWithAnim( self.dodgeRightAnim, self.dodgeRightAnimOffset ) )
tryDodgeWithAnim( self.dodgeLeftAnim, self.dodgeLeftAnimOffset );
}
else
{
if ( !tryDodgeWithAnim( self.dodgeLeftAnim, self.dodgeLeftAnimOffset ) )
tryDodgeWithAnim( self.dodgeRightAnim, self.dodgeRightAnimOffset );
}
if ( isdefined( self.currentDodgeAnim ) )
wait getanimlength( self.currentDodgeAnim );
else
wait 0.1;
}
}
setDodgeAnims( leftAnim, rightAnim )
{
self.noDodgeMove = true;
self.dodgeLeftAnim = leftAnim;
self.dodgeRightAnim = rightAnim;
time = 1;
if ( animHasNoteTrack( leftAnim, "code_move" ) )
time = getNotetrackTimes( leftAnim, "code_move" )[0];
self.dodgeLeftAnimOffset = getMoveDelta( leftAnim, 0, time );
time = 1;
if ( animHasNoteTrack( rightAnim, "code_move" ) )
time = getNotetrackTimes( rightAnim, "code_move" )[0];
self.dodgeRightAnimOffset = getMoveDelta( rightAnim, 0, time );
self.interval = 80;
}
clearDodgeAnims()
{
self.noDodgeMove = false;
self.dodgeLeftAnim = undefined;
self.dodgeRightAnim = undefined;
self.dodgeLeftAnimOffset = undefined;
self.dodgeRightAnimOffset = undefined;
}
meleeAttackCheck_whileMoving()
{
self endon( "killanimscript" );
while ( 1 )
{
if ( isDefined( self.enemy ) && ( isAI( self.enemy ) || isdefined( self.meleePlayerWhileMoving ) ) )
{
if ( abs( self GetMotionAngle() ) <= 135 )
animscripts\melee::Melee_TryExecuting();
}
wait 0.1;
}
}
bulletWhizbyCheck_whileMoving()
{
self endon( "killanimscript" );
if ( isdefined( self.disableBulletWhizbyReaction ) )
return;
while ( 1 )
{
self waittill( "bulletwhizby", shooter );
if ( self.moveMode != "run" || !self.faceMotion || self.a.pose != "stand" || isdefined( self.reactingToBullet ) )
continue;
if ( self.stairsState != "none" )
continue;
if ( !isdefined( self.enemy ) && !self.ignoreAll && isDefined( shooter.team ) && isEnemyTeam( self.team, shooter.team ) )
{
self.whizbyEnemy = shooter;
self animcustom( animscripts\reactions::bulletWhizbyReaction );
continue;
}
if ( self.lookaheadHitsStairs || self.lookaheadDist < 100 )
continue;
if ( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) < 10000 )
{
wait 0.2;
continue;
}
self.requestReactToBullet = gettime();
self notify( "move_loop_restart" );
self animscripts\run::endFaceEnemyAimTracking();
}
}
get_shuffle_to_corner_start_anim( shuffleLeft, startNode )
{
if ( startNode.type == "Cover Left" )
{
assert( !shuffleLeft );
return %CornerCrL_alert_2_shuffle;
}
else if ( startNode.type == "Cover Right" )
{
assert( shuffleLeft );
return %CornerCrR_alert_2_shuffle;
}
else
{
if ( shuffleLeft )
return %covercrouch_hide_2_shuffleL;
else
return %covercrouch_hide_2_shuffleR;
}
}
setup_shuffle_anim_array( shuffleLeft, startNode, endNode )
{
anim_array = [];
assert( isdefined( startNode ) );
assert( isdefined( endNode ) );
if ( endNode.type == "Cover Left" )
{
assert( shuffleLeft );
anim_array[ "shuffle_start" ] = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
anim_array[ "shuffle" ] = %covercrouch_shuffleL;
anim_array[ "shuffle_end" ] = %CornerCrL_shuffle_2_alert;
}
else if ( endNode.type == "Cover Right" )
{
assert( !shuffleLeft );
anim_array[ "shuffle_start" ] = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
anim_array[ "shuffle" ] = %covercrouch_shuffleR;
anim_array[ "shuffle_end" ] = %CornerCrR_shuffle_2_alert;
}
else if ( endNode.type == "Cover Stand" && startNode.type == endNode.type )
{
if ( shuffleLeft )
{
anim_array[ "shuffle_start" ] = %coverstand_hide_2_shuffleL;
anim_array[ "shuffle" ] = %coverstand_shuffleL;
anim_array[ "shuffle_end" ] = %coverstand_shuffleL_2_hide;
}
else
{
anim_array[ "shuffle_start" ] = %coverstand_hide_2_shuffleR;
anim_array[ "shuffle" ] = %coverstand_shuffleR;
anim_array[ "shuffle_end" ] = %coverstand_shuffleR_2_hide;
}
}
else
{
if ( shuffleLeft )
{
anim_array[ "shuffle_start" ] = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
anim_array[ "shuffle" ] = %covercrouch_shuffleL;
if ( endNode.type == "Cover Stand" )
anim_array[ "shuffle_end" ] = %coverstand_shuffleL_2_hide;
else
anim_array[ "shuffle_end" ] = %covercrouch_shuffleL_2_hide;
}
else
{
anim_array[ "shuffle_start" ] = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
anim_array[ "shuffle" ] = %covercrouch_shuffleR;
if ( endNode.type == "Cover Stand" )
anim_array[ "shuffle_end" ] = %coverstand_shuffleR_2_hide;
else
anim_array[ "shuffle_end" ] = %covercrouch_shuffleR_2_hide;
}
}
self.a.array = anim_array;
}
moveCoverToCover_checkStartPose( startNode, endNode )
{
if ( self.a.pose == "stand" && ( endNode.type != "Cover Stand" || startNode.type != "Cover Stand" ) )
{
self.a.pose = "crouch";
return false;
}
return true;
}
moveCoverToCover_checkEndPose( endNode )
{
if ( self.a.pose == "crouch" && endNode.type == "Cover Stand" )
{
self.a.pose = "stand";
return false;
}
return true;
}
serverFPS = 20;
serverSPF = 0.05;
moveCoverToCover()
{
self endon( "killanimscript" );
self endon( "goal_changed" );
shuffleNode = self.shuffleNode;
self.shuffleMove = undefined;
self.shuffleNode = undefined;
self.shuffleMoveInterrupted = true;
if ( !isdefined( self.prevNode ) )
return;
if ( !isdefined( self.node ) || !isdefined( shuffleNode ) || self.node != shuffleNode )
return;
shuffleNodeType = self.prevNode;
node = self.node;
moveDir = node.origin - self.origin;
if ( lengthSquared( moveDir ) < 1 )
return;
moveDir = vectornormalize( moveDir );
forward = anglestoforward( node.angles );
shuffleLeft = ( ( forward[ 0 ] * moveDir[ 1 ] ) - ( forward[ 1 ] * moveDir[ 0 ] ) ) > 0;
if ( moveDoorSideToSide( shuffleLeft, shuffleNodeType, node ) )
return;
if ( moveCoverToCover_checkStartPose( shuffleNodeType, node ) )
blendTime = 0.1;
else
blendTime = 0.4;
setup_shuffle_anim_array( shuffleLeft, shuffleNodeType, node );
self animMode( "zonly_physics", false );
self clearanim( %body, blendTime );
startAnim = animarray( "shuffle_start" );
shuffleAnim = animarray( "shuffle" );
endAnim = animarray( "shuffle_end" );
if ( animhasnotetrack( startAnim, "finish" ) )
startEndTime = getNotetrackTimes( startAnim, "finish" )[ 0 ];
else
startEndTime = 1;
startDist = length( getMoveDelta( startAnim, 0, startEndTime ) );
shuffleDist = length( getMoveDelta( shuffleAnim, 0, 1 ) );
endDist = length( getMoveDelta( endAnim, 0, 1 ) );
remainingDist = distance( self.origin, node.origin );
if ( remainingDist > startDist )
{
self OrientMode( "face angle", getNodeForwardYaw( shuffleNodeType ) );
self setflaggedanimrestart( "shuffle_start", startAnim, 1, blendTime );
self animscripts\shared::DoNoteTracks( "shuffle_start" );
self clearAnim( startAnim, 0.2 );
remainingDist -= startDist;
blendTime = 0.2;
}
else
{
self OrientMode( "face angle", node.angles[1] );
}
playEnd = false;
if ( remainingDist > endDist )
{
playEnd = true;
remainingDist -= endDist;
}
loopTime = getAnimLength( shuffleAnim );
playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;
playTime = floor( playTime * serverFPS ) * serverSPF;
self setflaggedanim( "shuffle", shuffleAnim, 1, blendTime );
self DoNoteTracksForTime( playTime, "shuffle" );
for ( i = 0; i < 2; i++ )
{
remainingDist = distance( self.origin, node.origin );
if ( playEnd )
remainingDist -= endDist;
if ( remainingDist < 4 )
break;
playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;
playTime = floor( playTime * serverFPS ) * serverSPF;
if ( playTime < 0.05 )
break;
self DoNoteTracksForTime( playTime, "shuffle" );
}
if ( playEnd )
{
if ( moveCoverToCover_checkEndPose( node ) )
blendTime = 0.2;
else
blendTime = 0.4;
self clearAnim( shuffleAnim, blendTime );
self setflaggedanim( "shuffle_end", endAnim, 1, blendTime );
self animscripts\shared::DoNoteTracks( "shuffle_end" );
}
self safeTeleport( node.origin );
self animMode( "normal" );
self.shuffleMoveInterrupted = undefined;
}
moveCoverToCoverFinish()
{
if ( isdefined( self.shuffleMoveInterrupted ) )
{
self clearanim( %cover_shuffle, 0.2 );
self.shuffleMoveInterrupted = undefined;
self animmode( "none", false );
self orientmode( "face default" );
}
else
{
wait 0.2;
self clearanim( %cover_shuffle, 0.2 );
}
}
moveDoorSideToSide( shuffleLeft, startNode, endNode )
{
sideToSideAnim = undefined;
if ( startNode.type == "Cover Right" && endNode.type == "Cover Left" && !shuffleLeft )
sideToSideAnim = %corner_standR_Door_R2L;
else if ( startNode.type == "Cover Left" && endNode.type == "Cover Right" && shuffleLeft )
sideToSideAnim = %corner_standL_Door_L2R;
if ( !isdefined( sideToSideAnim ) )
return false;
self animMode( "zonly_physics", false );
self orientmode( "face current" );
self setflaggedanimrestart( "sideToSide", sideToSideAnim, 1, 0.2 );
assert( animHasNoteTrack( sideToSideAnim, "slide_start" ) );
assert( animHasNoteTrack( sideToSideAnim, "slide_end" ) );
self animscripts\shared::DoNoteTracks( "sideToSide", ::handleSideToSideNotetracks );
slideStartTime = self getAnimTime( sideToSideAnim );
slideDir = endNode.origin - startNode.origin;
slideDir = vectornormalize( ( slideDir[0], slideDir[1], 0 ) );
animDelta = getMoveDelta( sideToSideAnim, slideStartTime, 1 );
remainingVec = endNode.origin - self.origin;
remainingVec = ( remainingVec[0], remainingVec[1], 0 );
slideDist = vectordot( remainingVec, slideDir ) - abs( animDelta[1] );
if ( slideDist > 2 )
{
slideEndTime = getNoteTrackTimes( sideToSideAnim, "slide_end" )[0];
slideTime = ( slideEndTime - slideStartTime ) * getAnimLength( sideToSideAnim );
assert( slideTime > 0 );
slideFrames = int( ceil( slideTime / 0.05 ) );
slideIncrement = slideDir * slideDist / slideFrames;
self thread slideForTime( slideIncrement, slideFrames );
}
self animscripts\shared::DoNoteTracks( "sideToSide" );
self safeTeleport( endNode.origin );
self animMode( "none" );
self orientmode( "face default" );
self.shuffleMoveInterrupted = undefined;
wait 0.2;
return true;
}
handleSideToSideNotetracks( note )
{
if ( note == "slide_start" )
return true;
}
slideForTime( slideIncrement, slideFrames )
{
self endon( "killanimscript" );
self endon( "goal_changed" );
while ( slideFrames > 0 )
{
self safeTeleport( self.origin + slideIncrement );
slideFrames--;
wait 0.05;
}
}
MoveStandMoveOverride( override_anim, weights )
{
self endon( "movemode" );
self clearanim( %combatrun, 0.6 );
self setanimknoball( %combatrun, %body, 1, 0.5, self.moveplaybackrate );
if ( isdefined( self.requestReactToBullet ) && gettime() - self.requestReactToBullet < 100 && isdefined( self.run_overrideBulletReact ) && randomFloat( 1 ) < self.a.reactToBulletChance )
{
animscripts\run::CustomRunningReactToBullets();
return;
}
if ( isarray( override_anim ) )
{
if ( isdefined( self.run_override_weights ) )
moveAnim = choose_from_weighted_array( override_anim, weights );
else
moveAnim = override_anim[ randomint( override_anim.size ) ];
}
else
{
moveAnim = override_anim;
}
self setflaggedanimknob( "moveanim", moveAnim, 1, 0.2 );
animscripts\shared::DoNoteTracks( "moveanim" );
}
#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
initAnimTree( animscript )
{
self clearAnim( %body, 0.3 );
self setAnim( %body, 1, 0 );
if ( animscript != "pain" && animscript != "death" )
self.a.special = "none";
self.missedSightChecks = 0;
self.a.aimweight = 1.0;
self.a.aimweight_start = 1.0;
self.a.aimweight_end = 1.0;
self.a.aimweight_transframes = 0;
self.a.aimweight_t = 0;
IsInCombat();
assertEX( isDefined( animscript ), "Animscript not specified in initAnimTree" );
}
UpdateAnimPose()
{
assertEX( self.a.movement == "stop" || self.a.movement == "walk" || self.a.movement == "run", "UpdateAnimPose " + self.a.pose + " " + self.a.movement );
if ( isDefined( self.desired_anim_pose ) && self.desired_anim_pose != self.a.pose )
{
if ( self.a.pose == "prone" )
self ExitProneWrapper( 0.5 );
if ( self.desired_anim_pose == "prone" )
{
self SetProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
self EnterProneWrapper( 0.5 );
self setAnimKnobAll( %prone_aim_5, %body, 1, 0.1, 1 );
}
}
self.desired_anim_pose = undefined;
}
initialize( animscript )
{
if ( isdefined( self.longDeathStarting ) )
{
if ( animscript != "pain" && animscript != "death" )
{
self kill( self.origin );
}
if ( animscript != "pain" )
{
self.longDeathStarting = undefined;
self notify( "kill_long_death" );
}
}
if ( isdefined( self.a.mayOnlyDie ) && animscript != "death" )
{
self kill( self.origin );
}
if ( isDefined( self.a.postScriptFunc ) )
{
scriptFunc = self.a.postScriptFunc;
self.a.postScriptFunc = undefined;
[[ scriptFunc ]]( animscript );
}
if ( animscript != "combat" && animscript != "pain" && animscript != "death" && usingSidearm() )
{
self animscripts\combat::switchToLastWeapon( %pistol_stand_switch, true );
}
if ( animscript != "combat" && animscript != "move" && animscript != "pain" )
self.a.magicReloadWhenReachEnemy = undefined;
if ( animscript != "death" )
self.a.nodeath = false;
if ( isDefined( self.isHoldingGrenade ) && ( animscript == "pain" || animscript == "death" || animscript == "flashed" ) )
{
self dropGrenade();
}
self.isHoldingGrenade = undefined;
self animscripts\squadmanager::aiUpdateAnimState( animscript );
self.coverNode = undefined;
self.suppressed = false;
self.isReloading = false;
self.changingCoverPos = false;
self.a.aimIdleThread = undefined;
self.a.scriptStartTime = gettime();
self.a.atConcealmentNode = false;
if ( isdefined( self.node ) && ( self.node.type == "Conceal Prone" || self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand" ) )
self.a.atConcealmentNode = true;
initAnimTree( animscript );
UpdateAnimPose();
}
getPreferredWeapon()
{
if ( isdefined( self.wantshotgun ) && self.wantshotgun )
{
if ( isShotgun( self.primaryweapon ) )
return self.primaryweapon;
else if ( isShotgun( self.secondaryweapon ) )
return self.secondaryweapon;
}
return self.primaryweapon;
}
badplacer( time, org, radius )
{
for ( i = 0;i < time * 20;i++ )
{
for ( p = 0;p < 10;p++ )
{
angles = ( 0, randomint( 360 ), 0 );
forward = anglestoforward( angles );
scale = ( forward * radius );
line( org, org + scale, ( 1, 0.3, 0.3 ) );
}
wait( 0.05 );
}
}
printDisplaceInfo()
{
self endon( "death" );
self notify( "displaceprint" );
self endon( "displaceprint" );
for ( ;; )
{
print3d( self.origin + ( 0, 0, 60 ), "displacer", ( 0, 0.4, 0.7 ), 0.85, 0.5 );
wait( 0.05 );
}
}
IsInCombat()
{
if ( self.alertLevelInt > 1 )
return true;
if ( isdefined( self.enemy ) )
{
self.a.combatEndTime = gettime() + anim.combatMemoryTimeConst + randomint( anim.combatMemoryTimeRand );
return true;
}
return( self.a.combatEndTime > gettime() );
}
GetEnemyEyePos()
{
if ( isdefined( self.enemy ) )
{
self.a.lastEnemyPos = self.enemy getShootAtPos();
self.a.lastEnemyTime = gettime();
return self.a.lastEnemyPos;
}
else if (
( isDefined( self.a.lastEnemyTime ) ) &&
( isDefined( self.a.lastEnemyPos ) ) &&
( self.a.lastEnemyTime + 3000 < gettime() )
)
{
return self.a.lastEnemyPos;
}
else
{
targetPos = self getShootAtPos();
targetPos = targetPos + ( 196 * self.lookforward[ 0 ], 196 * self.lookforward[ 1 ], 196 * self.lookforward[ 2 ] );
return targetPos;
}
}
GetNodeForwardYaw( node )
{
if ( !isdefined( self.heat ) )
{
if ( node.type == "Cover Left" )
return node.angles[1] + 90;
else if ( node.type == "Cover Right" )
return node.angles[1] - 90;
}
return node.angles[1];
}
GetNodeYawToOrigin( pos )
{
if ( isdefined( self.node ) )
yaw = self.node.angles[ 1 ] - GetYaw( pos );
else
yaw = self.angles[ 1 ] - GetYaw( pos );
yaw = AngleClamp180( yaw );
return yaw;
}
GetNodeYawToEnemy()
{
pos = undefined;
if ( isdefined( self.enemy ) )
{
pos = self.enemy.origin;
}
else
{
if ( isdefined( self.node ) )
forward = anglestoforward( self.node.angles );
else
forward = anglestoforward( self.angles );
forward *= 150 ;
pos = self.origin + forward;
}
if ( isdefined( self.node ) )
yaw = self.node.angles[ 1 ] - GetYaw( pos );
else
yaw = self.angles[ 1 ] - GetYaw( pos );
yaw = AngleClamp180( yaw );
return yaw;
}
GetYawToSpot( spot )
{
yaw = self.angles[ 1 ] - GetYaw( spot );
yaw = AngleClamp180( yaw );
return yaw;
}
GetYawToEnemy()
{
pos = undefined;
if ( isdefined( self.enemy ) )
{
pos = self.enemy.origin;
}
else
{
forward = anglestoforward( self.angles );
forward *= 150 ;
pos = self.origin + forward;
}
yaw = self.angles[ 1 ] - GetYaw( pos );
yaw = AngleClamp180( yaw );
return yaw;
}
GetYaw( org )
{
return VectorToYaw( org - self.origin );
}
GetYaw2d( org )
{
angles = VectorToAngles( ( org[ 0 ], org[ 1 ], 0 ) - ( self.origin[ 0 ], self.origin[ 1 ], 0 ) );
return angles[ 1 ];
}
AbsYawToEnemy()
{
assert( isdefined( self.enemy ) );
yaw = self.angles[ 1 ] - GetYaw( self.enemy.origin );
yaw = AngleClamp180( yaw );
if ( yaw < 0 )
yaw = -1 * yaw;
return yaw;
}
AbsYawToEnemy2d()
{
assert( isdefined( self.enemy ) );
yaw = self.angles[ 1 ] - GetYaw2d( self.enemy.origin );
yaw = AngleClamp180( yaw );
if ( yaw < 0 )
yaw = -1 * yaw;
return yaw;
}
AbsYawToOrigin( org )
{
yaw = self.angles[ 1 ] - GetYaw( org );
yaw = AngleClamp180( yaw );
if ( yaw < 0 )
yaw = -1 * yaw;
return yaw;
}
AbsYawToAngles( angles )
{
yaw = self.angles[ 1 ] - angles;
yaw = AngleClamp180( yaw );
if ( yaw < 0 )
yaw = -1 * yaw;
return yaw;
}
GetYawFromOrigin( org, start )
{
angles = VectorToAngles( org - start );
return angles[ 1 ];
}
GetYawToTag( tag, org )
{
yaw = self gettagangles( tag )[ 1 ] - GetYawFromOrigin( org, self gettagorigin( tag ) );
yaw = AngleClamp180( yaw );
return yaw;
}
GetYawToOrigin( org )
{
yaw = self.angles[ 1 ] - GetYaw( org );
yaw = AngleClamp180( yaw );
return yaw;
}
GetEyeYawToOrigin( org )
{
yaw = self gettagangles( "TAG_EYE" )[ 1 ] - GetYaw( org );
yaw = AngleClamp180( yaw );
return yaw;
}
isStanceAllowedWrapper( stance )
{
if ( isdefined( self.coverNode ) )
return self.coverNode doesNodeAllowStance( stance );
return self isStanceAllowed( stance );
}
choosePose( preferredPose )
{
if ( !isDefined( preferredPose ) )
{
preferredPose = self.a.pose;
}
switch( preferredPose )
{
case "stand":
if ( self isStanceAllowedWrapper( "stand" ) )
{
resultPose = "stand";
}
else if ( self isStanceAllowedWrapper( "crouch" ) )
{
resultPose = "crouch";
}
else if ( self isStanceAllowedWrapper( "prone" ) )
{
resultPose = "prone";
}
else
{
println( "No stance allowed!  Remaining standing." );
resultPose = "stand";
}
break;
case "crouch":
if ( self isStanceAllowedWrapper( "crouch" ) )
{
resultPose = "crouch";
}
else if ( self isStanceAllowedWrapper( "stand" ) )
{
resultPose = "stand";
}
else if ( self isStanceAllowedWrapper( "prone" ) )
{
resultPose = "prone";
}
else
{
println( "No stance allowed!  Remaining crouched." );
resultPose = "crouch";
}
break;
case "prone":
if ( self isStanceAllowedWrapper( "prone" ) )
{
resultPose = "prone";
}
else if ( self isStanceAllowedWrapper( "crouch" ) )
{
resultPose = "crouch";
}
else if ( self isStanceAllowedWrapper( "stand" ) )
{
resultPose = "stand";
}
else
{
println( "No stance allowed!  Remaining prone." );
resultPose = "prone";
}
break;
default:
println( "utility::choosePose, called in " + self.script + " script: Unhandled anim_pose " + self.a.pose + " - using stand." );
resultPose = "stand";
break;
}
return resultPose;
}
GetClaimedNode()
{
myNode = self.node;
if ( isdefined( myNode ) && ( self nearNode( myNode ) || ( isdefined( self.coverNode ) && myNode == self.coverNode ) ) )
return myNode;
return undefined;
}
GetNodeType()
{
myNode = GetClaimedNode();
if ( isDefined( myNode ) )
return myNode.type;
return "none";
}
GetNodeDirection()
{
myNode = GetClaimedNode();
if ( isdefined( myNode ) )
{
return myNode.angles[ 1 ];
}
return self.desiredAngle;
}
GetNodeForward()
{
myNode = GetClaimedNode();
if ( isdefined( myNode ) )
return AnglesToForward( myNode.angles );
return AnglesToForward( self.angles );
}
GetNodeOrigin()
{
myNode = GetClaimedNode();
if ( isdefined( myNode ) )
return myNode.origin;
return self.origin;
}
safemod( a, b )
{
result = int( a ) % b;
result += b;
return result % b;
}
QuadrantAnimWeights( yaw )
{
forwardWeight = cos( yaw );
leftWeight = sin( yaw );
result[ "front" ] = 0;
result[ "right" ] = 0;
result[ "back" ] = 0;
result[ "left" ] = 0;
if ( isdefined( self.alwaysRunForward ) )
{
assert( self.alwaysRunForward );
result[ "front" ] = 1;
return result;
}
if ( forwardWeight > 0 )
{
if ( leftWeight > forwardWeight )
result[ "left" ] = 1;
else if ( leftWeight < -1 * forwardWeight )
result[ "right" ] = 1;
else
result[ "front" ] = 1;
}
else
{
backWeight = -1 * forwardWeight;
if ( leftWeight > backWeight )
result[ "left" ] = 1;
else if ( leftWeight < forwardWeight )
result[ "right" ] = 1;
else
result[ "back" ] = 1;
}
return result;
}
getQuadrant( angle )
{
angle = AngleClamp( angle );
if ( angle < 45 || angle > 315 )
{
quadrant = "front";
}
else if ( angle < 135 )
{
quadrant = "left";
}
else if ( angle < 225 )
{
quadrant = "back";
}
else
{
quadrant = "right";
}
return quadrant;
}
IsInSet( input, set )
{
for ( i = set.size - 1; i >= 0; i -- )
{
if ( input == set[ i ] )
return true;
}
return false;
}
playAnim( animation )
{
if ( isDefined( animation ) )
{
println( "NOW PLAYING: ", animation );
self setFlaggedAnimKnobAllRestart( "playAnim", animation, %root, 1, .1, 1 );
timeToWait = getanimlength( animation );
timeToWait = ( 3 * timeToWait ) + 1;
self thread NotifyAfterTime( "time is up", "time is up", timeToWait );
self waittill( "time is up" );
self notify( "enddrawstring" );
}
}
NotifyAfterTime( notifyString, killmestring, time )
{
self endon( "death" );
self endon( killmestring );
wait time;
self notify( notifyString );
}
drawString( stringtodraw )
{
self endon( "killanimscript" );
self endon( "enddrawstring" );
for ( ;; )
{
wait .05;
print3d( ( self GetDebugEye() ) + ( 0, 0, 8 ), stringtodraw, ( 1, 1, 1 ), 1, 0.2 );
}
}
drawStringTime( msg, org, color, timer )
{
maxtime = timer * 20;
for ( i = 0;i < maxtime;i++ )
{
print3d( org, msg, color, 1, 1 );
wait .05;
}
}
showLastEnemySightPos( string )
{
self notify( "got known enemy2" );
self endon( "got known enemy2" );
self endon( "death" );
if ( !isdefined( self.enemy ) )
return;
if ( self.enemy.team == "allies" )
color = ( 0.4, 0.7, 1 );
else
color = ( 1, 0.7, 0.4 );
while ( 1 )
{
wait( 0.05 );
if ( !isdefined( self.lastEnemySightPos ) )
continue;
print3d( self.lastEnemySightPos, string, color, 1, 2.15 );
}
}
hasEnemySightPos()
{
if ( isdefined( self.node ) )
return( canSeeEnemyFromExposed() || canSuppressEnemyFromExposed() );
else
return( canSeeEnemy() || canSuppressEnemy() );
}
getEnemySightPos()
{
return self.goodShootPos;
}
util_ignoreCurrentSightPos()
{
if ( !hasEnemySightPos() )
return;
self.ignoreSightPos = getEnemySightPos();
self.ignoreOrigin = self.origin;
}
util_evaluateKnownEnemyLocation()
{
if ( !hasEnemySightPos() )
return false;
myGunPos = self getMuzzlePos();
myEyeOffset = ( self getShootAtPos() - myGunPos );
if ( ( isdefined( self.ignoreSightPos ) ) && ( isdefined( self.ignoreOrigin ) ) )
{
if ( distance( self.origin, self.ignoreOrigin ) < 25 )
return false;
}
self.ignoreSightPos = undefined;
canSee = self canshoot( getEnemySightPos(), myEyeOffset );
if ( !canSee )
{
self.ignoreSightPos = getEnemySightPos();
return false;
}
return true;
}
debugTimeout()
{
wait( 5 );
self notify( "timeout" );
}
debugPosInternal( org, string, size )
{
self endon( "death" );
self notify( "stop debug " + org );
self endon( "stop debug " + org );
ent = spawnstruct();
ent thread debugTimeout();
ent endon( "timeout" );
if ( self.enemy.team == "allies" )
color = ( 0.4, 0.7, 1 );
else
color = ( 1, 0.7, 0.4 );
while ( 1 )
{
wait( 0.05 );
print3d( org, string, color, 1, size );
}
}
debugPos( org, string )
{
thread debugPosInternal( org, string, 2.15 );
}
debugPosSize( org, string, size )
{
thread debugPosInternal( org, string, size );
}
debugBurstPrint( numShots, maxShots )
{
burstSize = numShots / maxShots;
burstSizeStr = undefined;
if ( numShots == self.bulletsInClip )
burstSizeStr = "all rounds";
else
if ( burstSize < 0.25 )
burstSizeStr = "small burst";
else
if ( burstSize < 0.5 )
burstSizeStr = "med burst";
else
burstSizeStr = "long burst";
thread animscripts\utility::debugPosSize( self.origin + ( 0, 0, 42 ), burstSizeStr, 1.5 );
thread animscripts\utility::debugPos( self.origin + ( 0, 0, 60 ), "Suppressing" );
}
printShootProc()
{
self endon( "death" );
self notify( "stop shoot " + self.export );
self endon( "stop shoot " + self.export );
printTime = 0.25;
timer = printTime * 20;
for ( i = 0;i < timer;i += 1 )
{
wait( 0.05 );
print3d( self.origin + ( 0, 0, 70 ), "Shoot", ( 1, 0, 0 ), 1, 1 );
}
}
printShoot()
{
}
showDebugProc( fromPoint, toPoint, color, printTime )
{
self endon( "death" );
timer = printTime * 20;
for ( i = 0;i < timer;i += 1 )
{
wait( 0.05 );
line( fromPoint, toPoint, color );
}
}
showDebugLine( fromPoint, toPoint, color, printTime )
{
self thread showDebugProc( fromPoint, toPoint + ( 0, 0, -5 ), color, printTime );
}
shootEnemyWrapper()
{
[[ anim.shootEnemyWrapper_func ]]();
}
shootEnemyWrapper_normal()
{
self.a.lastShootTime = gettime();
maps\_gameskill::set_accuracy_based_on_situation();
shootNow = false;
wclass = WeaponClass( self.weapon );
if ( !isPlayer( self.enemy ) && ( wclass == "mg" || wclass == "smg" || wclass == "spread" ) )
{
maxDist = getDVarInt("shoot_npc_max_dist");
minDist = getDVarInt("shoot_npc_min_dist");
if ( minDist < maxDist && minDist >= 0.0 )
{
enemyOrigin = self.enemy.origin;
distSq = DistanceSquared(self.origin, enemyOrigin);
players = getentarray("player", "classname");
for (i = 0; i < players.size; i++)
{
distSq = min(distSq, DistanceSquared(enemyOrigin, players[i].origin));
}
dist = sqrt(distSq);
chanceToHit = (maxDist - dist)/(maxDist - minDist);
r = randomFloat(1.0);
if ( chanceToHit <= r )
{
self shootBlank();
}
else
{
shootNow = true;
}
}
else
shootNow = true;
}
else
{
shootNow = true;
}
if( shootNow )
{
self notify( "shooting" );
prof_begin( "code shoot" );
self shoot();
prof_end( "code shoot" );
}
}
shootEnemyWrapper_shootNotify()
{
level notify( "an_enemy_shot", self );
shootEnemyWrapper_normal();
}
shootPosWrapper( shootPos )
{
endpos = bulletSpread( self getMuzzlePos(), shootPos, 4 );
self.a.lastShootTime = gettime();
self notify( "shooting" );
prof_begin( "code shoot" );
self shoot( 1, endpos );
prof_end( "code shoot" );
}
throwGun()
{
org = spawn( "script_model", ( 0, 0, 0 ) );
org setmodel( "temp" );
org.origin = self getTagOrigin( "tag_weapon_right" ) + ( 50, 50, 0 );
org.angles = self getTagAngles( "tag_weapon_right" );
right = anglestoright( org.angles );
right *= 15;
forward = anglestoforward( org.angles );
forward *= 15;
org moveGravity( ( 0, 50, 150 ), 100 );
weaponClass = "weapon_" + self.weapon;
weapon = spawn( weaponClass, org.origin );
weapon.angles = self getTagAngles( "tag_weapon_right" );
weapon linkto( org );
lastOrigin = org.origin;
while ( ( isdefined( weapon ) ) && ( isdefined( weapon.origin ) ) )
{
start = lastOrigin;
end = org.origin;
angles = vectortoangles( end - start );
forward = anglestoforward( angles );
forward *= 4;
trace = bulletTrace( end, end + forward, true, weapon );
if ( isalive( trace[ "entity" ] ) && trace[ "entity" ] == self )
{
wait( 0.05 );
continue;
}
if ( trace[ "fraction" ] < 1.0 )
break;
lastOrigin = org.origin;
wait( 0.05 );
}
if ( ( isdefined( weapon ) ) && ( isdefined( weapon.origin ) ) )
weapon unlink();
org delete();
}
setEnv( env )
{
anim.idleAnimTransition [ "stand" ][ "in" ] = %casual_stand_idle_trans_in;
anim.idleAnimArray [ "stand" ][ 0 ][ 0 ] = %casual_stand_idle;
anim.idleAnimArray [ "stand" ][ 0 ][ 1 ] = %casual_stand_idle_twitch;
anim.idleAnimArray [ "stand" ][ 0 ][ 2 ] = %casual_stand_idle_twitchB;
anim.idleAnimWeights	[ "stand" ][ 0 ][ 0 ] = 2;
anim.idleAnimWeights	[ "stand" ][ 0 ][ 1 ] = 1;
anim.idleAnimWeights	[ "stand" ][ 0 ][ 2 ] = 1;
anim.idleAnimArray [ "stand" ][ 1 ][ 0 ] = %casual_stand_v2_idle;
anim.idleAnimArray [ "stand" ][ 1 ][ 1 ] = %casual_stand_v2_twitch_radio;
anim.idleAnimArray [ "stand" ][ 1 ][ 2 ] = %casual_stand_v2_twitch_shift;
anim.idleAnimArray [ "stand" ][ 1 ][ 3 ] = %casual_stand_v2_twitch_talk;
anim.idleAnimWeights	[ "stand" ][ 1 ][ 0 ] = 10;
anim.idleAnimWeights	[ "stand" ][ 1 ][ 1 ] = 4;
anim.idleAnimWeights	[ "stand" ][ 1 ][ 2 ] = 7;
anim.idleAnimWeights	[ "stand" ][ 1 ][ 3 ] = 4;
anim.idleAnimArray [ "stand_cqb" ][ 0 ][ 0 ] = %cqb_stand_idle;
anim.idleAnimArray [ "stand_cqb" ][ 0 ][ 1 ] = %cqb_stand_twitch;
anim.idleAnimWeights	[ "stand_cqb" ][ 0 ][ 0 ] = 2;
anim.idleAnimWeights	[ "stand_cqb" ][ 0 ][ 1 ] = 1;
anim.idleAnimTransition [ "crouch" ][ "in" ] = %casual_crouch_idle_in;
anim.idleAnimArray [ "crouch" ][ 0 ][ 0 ] = %casual_crouch_idle;
anim.idleAnimWeights	[ "crouch" ][ 0 ][ 0 ] = 6;
}
PersonalColdBreath()
{
tag = "TAG_EYE";
self endon( "death" );
self notify( "stop personal effect" );
self endon( "stop personal effect" );
while ( isdefined( self ) )
{
wait( 0.05 );
if( !isdefined( self ) )
break;
if ( ( isdefined( self.a.movement ) ) && ( self.a.movement == "stop" ) )
{
if ( ( isdefined( self.isindoor ) ) && ( self.isindoor == 1 ) )
continue;
playfxOnTag( level._effect[ "cold_breath" ], self, tag );
wait( 2.5 + randomfloat( 3 ) );
}
else
wait( 0.5 );
}
}
PersonalColdBreathStop()
{
self notify( "stop personal effect" );
}
PersonalColdBreathSpawner()
{
self endon( "death" );
self notify( "stop personal effect" );
self endon( "stop personal effect" );
for ( ;; )
{
self waittill( "spawned", spawn );
if ( maps\_utility::spawn_failed( spawn ) )
continue;
spawn thread PersonalColdBreath();
}
}
isSuppressedWrapper()
{
if ( isdefined( self.forceSuppression ) )
return self.forceSuppression;
if ( self.suppressionMeter <= self.suppressionThreshold )
return false;
return self issuppressed();
}
isPartiallySuppressedWrapper()
{
if ( self.suppressionMeter <= self.suppressionThreshold * 0.25 )
return false;
return( self issuppressed() );
}
getNodeOffset( node )
{
if ( isdefined( node.offset ) )
return node.offset;
cover_left_crouch_offset = ( -26, .4, 36 );
cover_left_stand_offset = ( -32, 7, 63 );
cover_right_crouch_offset = ( 43.5, 11, 36 );
cover_right_stand_offset = ( 36, 8.3, 63 );
cover_crouch_offset = ( 3.5, -12.5, 45 );
cover_stand_offset = ( -3.7, -22, 63 );
cornernode = false;
nodeOffset = ( 0, 0, 0 );
right = anglestoright( node.angles );
forward = anglestoforward( node.angles );
switch( node.type )
{
case "Cover Left":
if ( node getHighestNodeStance() == "crouch" )
nodeOffset = calculateNodeOffset( right, forward, cover_left_crouch_offset );
else
nodeOffset = calculateNodeOffset( right, forward, cover_left_stand_offset );
break;
case "Cover Right":
if ( node getHighestNodeStance() == "crouch" )
nodeOffset = calculateNodeOffset( right, forward, cover_right_crouch_offset );
else
nodeOffset = calculateNodeOffset( right, forward, cover_right_stand_offset );
break;
case "Cover Stand":
case "Conceal Stand":
case "Turret":
nodeOffset = calculateNodeOffset( right, forward, cover_stand_offset );
break;
case "Cover Crouch":
case "Cover Crouch Window":
case "Conceal Crouch":
nodeOffset = calculateNodeOffset( right, forward, cover_crouch_offset );
break;
}
node.offset = nodeOffset;
return node.offset;
}
calculateNodeOffset( right, forward, baseoffset )
{
return ( right * baseoffset[ 0 ] ) + ( forward * baseoffset[ 1 ] ) + ( 0, 0, baseoffset[ 2 ] );
}
recentlySawEnemy()
{
return( isdefined( self.enemy ) && self seeRecently( self.enemy, 5 ) );
}
canSeeEnemy( cacheDuration )
{
if ( !isdefined( self.enemy ) )
return false;
if ( (isDefined( cacheDuration ) && self canSee( self.enemy, cacheDuration )) || self canSee( self.enemy ) )
{
if ( !checkPitchVisibility( self geteye(), self.enemy getshootatpos() ) )
return false;
self.goodShootPos = GetEnemyEyePos();
dontGiveUpOnSuppressionYet();
return true;
}
return false;
}
canSeeEnemyFromExposed()
{
if ( !isdefined( self.enemy ) )
{
self.goodShootPos = undefined;
return false;
}
enemyEye = GetEnemyEyePos();
if ( !isDefined( self.node ) )
{
result = self canSee( self.enemy );
}
else
{
result = canSeePointFromExposedAtNode( enemyEye, self.node );
}
if ( result )
{
self.goodShootPos = enemyEye;
dontGiveUpOnSuppressionYet();
}
else
{
}
return result;
}
canSeePointFromExposedAtNode( point, node )
{
if ( node.type == "Cover Left" || node.type == "Cover Right" )
{
if ( !self animscripts\corner::canSeePointFromExposedAtCorner( point, node ) )
return false;
}
nodeOffset = getNodeOffset( node );
lookFromPoint = node.origin + nodeOffset;
if ( !checkPitchVisibility( lookFromPoint, point, node ) )
return false;
if ( !sightTracePassed( lookFromPoint, point, false, undefined ) )
{
if ( node.type == "Cover Crouch" || node.type == "Conceal Crouch" )
{
lookFromPoint = ( 0, 0, 64 ) + node.origin;
return sightTracePassed( lookFromPoint, point, false, undefined );
}
return false;
}
return true;
}
checkPitchVisibility( fromPoint, toPoint, atNode )
{
minPitch = self.downAimLimit - anim.aimPitchDiffTolerance;
maxPitch = self.upAimLimit + anim.aimPitchDiffTolerance;
pitch = AngleClamp180( vectorToAngles( toPoint - fromPoint )[ 0 ] );
if( pitch > maxPitch )
return false;
if ( pitch < minPitch )
{
if ( isdefined( atNode ) && atNode.type != "Cover Crouch" && atNode.type != "Conceal Crouch" )
return false;
if ( pitch < (anim.coverCrouchLeanPitch + minPitch) )
return false;
}
return true;
}
dontGiveUpOnSuppressionYet()
{
self.a.shouldResetGiveUpOnSuppressionTimer = true;
}
updateGiveUpOnSuppressionTimer()
{
if ( !isdefined( self.a.shouldResetGiveUpOnSuppressionTimer ) )
self.a.shouldResetGiveUpOnSuppressionTimer = true;
if ( self.a.shouldResetGiveUpOnSuppressionTimer )
{
self.a.giveUpOnSuppressionTime = gettime() + randomintrange( 15000, 30000 );
self.a.shouldResetGiveUpOnSuppressionTimer = false;
}
}
showLines( start, end, end2 )
{
for ( ;; )
{
line( start, end, ( 1, 0, 0 ), 1 );
wait( 0.05 );
line( start, end2, ( 0, 0, 1 ), 1 );
wait( 0.05 );
}
}
aiSuppressAI()
{
if ( !self canAttackEnemyNode() )
return false;
shootPos = undefined;
if ( isdefined( self.enemy.node ) )
{
nodeOffset = getNodeOffset( self.enemy.node );
shootPos = self.enemy.node.origin + nodeOffset;
}
else
shootPos = self.enemy getShootAtPos();
if ( !self canShoot( shootPos ) )
return false;
if ( self.script == "combat" )
{
if ( !sighttracepassed( self geteye(), self getMuzzlePos(), false, undefined ) )
return false;
}
self.goodShootPos = shootPos;
return true;
}
canSuppressEnemyFromExposed()
{
if ( !hasSuppressableEnemy() )
{
self.goodShootPos = undefined;
return false;
}
if ( !isplayer( self.enemy ) )
return aiSuppressAI();
if ( isdefined( self.node ) )
{
if ( self.node.type == "Cover Left" || self.node.type == "Cover Right" )
{
if ( !self animscripts\corner::canSeePointFromExposedAtCorner( self GetEnemyEyePos(), self.node ) )
return false;
}
nodeOffset = getNodeOffset( self.node );
startOffset = self.node.origin + nodeOffset;
}
else
startOffset = self getMuzzlePos();
if ( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
return false;
return findGoodSuppressSpot( startOffset );
}
canSuppressEnemy()
{
if ( !hasSuppressableEnemy() )
{
self.goodShootPos = undefined;
return false;
}
if ( !isplayer( self.enemy ) )
return aiSuppressAI();
startOffset = self getMuzzlePos();
if ( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
return false;
return findGoodSuppressSpot( startOffset );
}
hasSuppressableEnemy()
{
if ( !isdefined( self.enemy ) )
return false;
if ( !isdefined( self.lastEnemySightPos ) )
return false;
updateGiveUpOnSuppressionTimer();
if ( gettime() > self.a.giveUpOnSuppressionTime )
return false;
if ( !needRecalculateSuppressSpot() )
return isdefined( self.goodShootPos );
return true;
}
canSeeAndShootPoint( point )
{
if ( !sightTracePassed( self getShootAtPos(), point, false, undefined ) )
return false;
if ( self.a.weaponPos[ "right" ] == "none" )
return false;
gunpoint = self getMuzzlePos();
return sightTracePassed( gunpoint, point, false, undefined );
}
needRecalculateSuppressSpot()
{
if ( isdefined( self.goodShootPos ) && !self canSeeAndShootPoint( self.goodShootPos ) )
return true;
return(
!isdefined( self.lastEnemySightPosOld ) ||
self.lastEnemySightPosOld != self.lastEnemySightPos ||
distanceSquared( self.lastEnemySightPosSelfOrigin, self.origin ) > 1024
);
}
findGoodSuppressSpot( startOffset )
{
if ( !needRecalculateSuppressSpot() )
return isdefined( self.goodShootPos );
if ( isdefined( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) > squared( self.enemy.maxVisibleDist ) )
{
self.goodShootPos = undefined;
return false;
}
if ( !sightTracePassed( self getShootAtPos(), startOffset, false, undefined ) )
{
self.goodShootPos = undefined;
return false;
}
self.lastEnemySightPosSelfOrigin = self.origin;
self.lastEnemySightPosOld = self.lastEnemySightPos;
currentEnemyPos = GetEnemyEyePos();
trace = bullettrace( self.lastEnemySightPos, currentEnemyPos, false, undefined );
startTracesAt = trace[ "position" ];
percievedMovementVector = self.lastEnemySightPos - startTracesAt;
lookVector = vectorNormalize( self.lastEnemySightPos - startOffset );
percievedMovementVector = percievedMovementVector - ( lookVector * vectorDot( percievedMovementVector, lookVector ) );
idealTraceInterval = 20.0;
numTraces = int( length( percievedMovementVector ) / idealTraceInterval + 0.5 );
if ( numTraces < 1 )
numTraces = 1;
if ( numTraces > 20 )
numTraces = 20;
vectorDif = self.lastEnemySightPos - startTracesAt;
vectorDif = ( vectorDif[ 0 ] / numTraces, vectorDif[ 1 ] / numTraces, vectorDif[ 2 ] / numTraces );
numTraces++ ;
traceTo = startTracesAt;
self.goodShootPos = undefined;
goodTraces = 0;
neededGoodTraces = 2;
for ( i = 0; i < numTraces + neededGoodTraces; i++ )
{
tracePassed = sightTracePassed( startOffset, traceTo, false, undefined );
thisTraceTo = traceTo;
if ( i == numTraces - 1 )
{
vectorDif = vectorDif - ( lookVector * vectorDot( vectorDif, lookVector ) );
}
traceTo += vectorDif;
if ( tracePassed )
{
goodTraces++ ;
self.goodShootPos = thisTraceTo;
if ( i > 0 && goodTraces < neededGoodTraces && i < numTraces + neededGoodTraces - 1 )
continue;
return true;
}
else
{
goodTraces = 0;
}
}
return isdefined( self.goodShootPos );
}
anim_array( animArray, animWeights )
{
total_anims = animArray.size;
idleanim = randomint( total_anims );
assert( total_anims );
assert( animArray.size == animWeights.size );
if ( total_anims == 1 )
return animArray[ 0 ];
weights = 0;
total_weight = 0;
for ( i = 0;i < total_anims;i++ )
total_weight += animWeights[ i ];
anim_play = randomfloat( total_weight );
current_weight = 0;
for ( i = 0;i < total_anims;i++ )
{
current_weight += animWeights[ i ];
if ( anim_play >= current_weight )
continue;
idleanim = i;
break;
}
return animArray[ idleanim ];
}
print3dtime( timer, org, msg, color, alpha, scale )
{
newtime = timer / 0.05;
for ( i = 0;i < newtime;i++ )
{
print3d( org, msg, color, alpha, scale );
wait( 0.05 );
}
}
print3drise( org, msg, color, alpha, scale )
{
newtime = 5 / 0.05;
up = 0;
org = org + randomvector( 30 );
for ( i = 0;i < newtime;i++ )
{
up += 0.5;
print3d( org + ( 0, 0, up ), msg, color, alpha, scale );
wait( 0.05 );
}
}
crossproduct( vec1, vec2 )
{
return( vec1[ 0 ] * vec2[ 1 ] - vec1[ 1 ] * vec2[ 0 ] > 0 );
}
getGrenadeModel()
{
return getWeaponModel( self.grenadeweapon );
}
sawEnemyMove( timer )
{
if ( !isdefined( timer ) )
timer = 500;
return( gettime() - self.personalSightTime < timer );
}
canThrowGrenade()
{
if ( !self.grenadeAmmo )
return false;
if ( self.script_forceGrenade )
return true;
return( isplayer( self.enemy ) );
}
usingBoltActionWeapon()
{
return( weaponIsBoltAction( self.weapon ) );
}
random_weight( array )
{
idleanim = randomint( array.size );
if ( array.size > 1 )
{
anim_weight = 0;
for ( i = 0;i < array.size;i++ )
anim_weight += array[ i ];
anim_play = randomfloat( anim_weight );
anim_weight = 0;
for ( i = 0;i < array.size;i++ )
{
anim_weight += array[ i ];
if ( anim_play < anim_weight )
{
idleanim = i;
break;
}
}
}
return idleanim;
}
setFootstepEffect( name, fx )
{
assertEx( isdefined( name ), "Need to define the footstep surface type." );
assertEx( isdefined( fx ), "Need to define the footstep effect." );
if ( !isdefined( anim.optionalStepEffects ) )
anim.optionalStepEffects = [];
anim.optionalStepEffects[ anim.optionalStepEffects.size ] = name;
level._effect[ "step_" + name ] = fx;
}
setFootstepEffectSmall( name, fx )
{
assertEx( isdefined( name ), "Need to define the footstep surface type." );
assertEx( isdefined( fx ), "Need to define the mud footstep effect." );
if ( !isdefined( anim.optionalStepEffectsSmall ) )
anim.optionalStepEffectsSmall = [];
anim.optionalStepEffectsSmall[ anim.optionalStepEffectsSmall.size ] = name;
level._effect[ "step_small_" + name ] = fx;
}
setNotetrackEffect( notetrack, tag, surfacename, fx, sound_prefix, sound_suffix )
{
assert( isdefined( notetrack ) );
assert( isdefined( tag ) );
assert( isdefined( fx ) );
assertEx( isstring( notetrack ), "Notetrack name must be a string" );
if ( !isdefined( surfacename ) )
surfacename = "all";
if ( !isdefined( level._notetrackFX ) )
level._notetrackFX = [];
level._notetrackFX[ notetrack ][ surfacename ] = spawnStruct();
level._notetrackFX[ notetrack ][ surfacename ].tag = tag;
level._notetrackFX[ notetrack ][ surfacename ].fx = fx;
if ( isdefined( sound_prefix ) )
level._notetrackFX[ notetrack ][ surfacename ].sound_prefix = sound_prefix;
if ( isdefined( sound_suffix ) )
level._notetrackFX[ notetrack ][ surfacename ].sound_suffix = sound_suffix;
}
persistentDebugLine( start, end )
{
self endon( "death" );
level notify( "newdebugline" );
level endon( "newdebugline" );
for ( ;; )
{
line( start, end, ( 0.3, 1, 0 ), 1 );
wait( 0.05 );
}
}
EnterProneWrapper( timer )
{
thread enterProneWrapperProc( timer );
}
enterProneWrapperProc( timer )
{
self endon( "death" );
self notify( "anim_prone_change" );
self endon( "anim_prone_change" );
self EnterProne( timer, isDefined( self.a.onback ) );
self waittill( "killanimscript" );
if ( self.a.pose != "prone" && !isdefined( self.a.onback ) )
self.a.pose = "prone";
}
ExitProneWrapper( timer )
{
thread ExitProneWrapperProc( timer );
}
ExitProneWrapperProc( timer )
{
self endon( "death" );
self notify( "anim_prone_change" );
self endon( "anim_prone_change" );
self ExitProne( timer );
self waittill( "killanimscript" );
if ( self.a.pose == "prone" )
self.a.pose = "crouch";
}
canBlindfire()
{
if ( self.a.atConcealmentNode )
return false;
if ( !animscripts\weaponList::usingAutomaticWeapon() )
return false;
if ( weaponClass( self.weapon ) == "mg" )
return false;
if ( isdefined( self.disable_blindfire ) && self.disable_blindfire == true )
return false;
return true;
}
canHitSuppressSpot()
{
if ( !hasEnemySightPos() )
return false;
myGunPos = self getMuzzlePos();
return( sightTracePassed( myGunPos, getEnemySightPos(), false, undefined ) );
}
moveAnim( animname )
{
assert( isdefined( self.a.moveAnimSet ) );
return self.a.moveAnimSet[ animname ];
}
randomAnimOfTwo( anim1, anim2 )
{
if ( randomint( 2 ) )
return anim1;
else
return anim2;
}
animArray( animname )
{
assert( isdefined( self.a.array ) );
return self.a.array[ animname ];
}
animArrayAnyExist( animname )
{
assert( isdefined( self.a.array ) );
return self.a.array[ animname ].size > 0;
}
animArrayPickRandom( animname )
{
assert( isdefined( self.a.array ) );
assert( self.a.array[ animname ].size > 0 );
index = randomint( self.a.array[ animname ].size );
return self.a.array[ animname ][ index ];
}
array( a, b, c, d, e, f, g, h, i, j, k, l, m, n )
{
array = [];
if ( isdefined( a ) ) array[ 0 ] = a; else return array;
if ( isdefined( b ) ) array[ 1 ] = b; else return array;
if ( isdefined( c ) ) array[ 2 ] = c; else return array;
if ( isdefined( d ) ) array[ 3 ] = d; else return array;
if ( isdefined( e ) ) array[ 4 ] = e; else return array;
if ( isdefined( f ) ) array[ 5 ] = f; else return array;
if ( isdefined( g ) ) array[ 6 ] = g; else return array;
if ( isdefined( h ) ) array[ 7 ] = h; else return array;
if ( isdefined( i ) ) array[ 8 ] = i; else return array;
if ( isdefined( j ) ) array[ 9 ] = j; else return array;
if ( isdefined( k ) ) array[ 10 ] = k; else return array;
if ( isdefined( l ) ) array[ 11 ] = l; else return array;
if ( isdefined( m ) ) array[ 12 ] = m; else return array;
if ( isdefined( n ) ) array[ 13 ] = n;
return array;
}
getAIPrimaryWeapon()
{
return self.primaryweapon;
}
getAISecondaryWeapon()
{
return self.secondaryweapon;
}
getAISidearmWeapon()
{
return self.sidearm;
}
getAICurrentWeapon()
{
return self.weapon;
}
usingPrimary()
{
return( self.weapon == self.primaryweapon && self.weapon != "none" );
}
usingSecondary()
{
return( self.weapon == self.secondaryweapon && self.weapon != "none" );
}
usingSidearm()
{
return( self.weapon == self.sidearm && self.weapon != "none" );
}
getAICurrentWeaponSlot()
{
if ( self.weapon == self.primaryweapon )
return "primary";
else if ( self.weapon == self.secondaryweapon )
return "secondary";
else if ( self.weapon == self.sidearm )
return "sidearm";
else
assertMsg( "self.weapon does not match any known slot" );
}
AIHasWeapon( weapon )
{
if ( isDefined( self.weaponInfo[ weapon ] ) )
return true;
return false;
}
getAnimEndPos( theanim )
{
moveDelta = getMoveDelta( theanim, 0, 1 );
return self localToWorldCoords( moveDelta );
}
damageLocationIsAny( a, b, c, d, e, f, g, h, i, j, k, ovr )
{
if ( !isdefined( a ) ) return false; if ( self.damageLocation == a ) return true;
if ( !isdefined( b ) ) return false; if ( self.damageLocation == b ) return true;
if ( !isdefined( c ) ) return false; if ( self.damageLocation == c ) return true;
if ( !isdefined( d ) ) return false; if ( self.damageLocation == d ) return true;
if ( !isdefined( e ) ) return false; if ( self.damageLocation == e ) return true;
if ( !isdefined( f ) ) return false; if ( self.damageLocation == f ) return true;
if ( !isdefined( g ) ) return false; if ( self.damageLocation == g ) return true;
if ( !isdefined( h ) ) return false; if ( self.damageLocation == h ) return true;
if ( !isdefined( i ) ) return false; if ( self.damageLocation == i ) return true;
if ( !isdefined( j ) ) return false; if ( self.damageLocation == j ) return true;
if ( !isdefined( k ) ) return false; if ( self.damageLocation == k ) return true;
assert( !isdefined( ovr ) );
return false;
}
usingPistol()
{
return weaponClass( self.weapon ) == "pistol";
}
usingRocketLauncher()
{
return weaponClass( self.weapon ) == "rocketlauncher";
}
usingMG()
{
return weaponClass( self.weapon ) == "mg";
}
usingShotGun()
{
return weaponclass( self.weapon ) == "spread";
}
usingRifleLikeWeapon()
{
class = weaponClass( self.weapon );
switch( class )
{
case "mg":
case "smg":
case "sniper":
case "rifle":
case "spread":
return true;
}
return false;
}
ragdollDeath( moveAnim )
{
self endon( "killanimscript" );
lastOrg = self.origin;
moveVec = ( 0, 0, 0 );
for ( ;; )
{
wait( 0.05 );
force = distance( self.origin, lastOrg );
lastOrg = self.origin;
if ( self.health == 1 )
{
self.a.nodeath = true;
self startRagdoll();
self clearAnim( moveAnim, 0.1 );
wait( 0.05 );
physicsExplosionSphere( lastOrg, 600, 0, force * 0.1 );
self notify( "killanimscript" );
return;
}
}
}
shouldCQB()
{
return isdefined( self.cqbwalking ) && !isdefined( self.grenade );
}
isCQBWalking()
{
return isdefined( self.cqbwalking );
}
isCQBWalkingOrFacingEnemy()
{
return !self.faceMotion || isdefined( self.cqbwalking );
}
randomizeIdleSet()
{
self.a.idleSet = randomint( 2 );
}
isShotgun( weapon )
{
return weaponclass( weapon ) == "spread";
}
isSniperRifle( weapon )
{
return weaponclass( weapon ) == "sniper";
}
weapon_pump_action_shotgun()
{
return self.weapon != "none" && weaponIsBoltAction( self.weapon ) && weaponclass( self.weapon ) == "spread";
}
getRandomIntFromSeed( intSeed, intMax )
{
assert( intMax > 0 );
index = intSeed % anim.randomIntTableSize;
return anim.randomIntTable[ index ] % intMax;
}
getCurrentWeaponSlotName()
{
assert( isDefined( self ) );
if ( self usingSecondary() )
return "secondary";
if ( self usingSidearm() )
return "sidearm";
return "primary";
}
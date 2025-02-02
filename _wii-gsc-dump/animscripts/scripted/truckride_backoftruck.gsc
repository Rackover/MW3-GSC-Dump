#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#using_animtree( "generic_human" );
hackangle()
{
self endon( "killanimscript" );
for ( ;; )
{
enemyAngle = animscripts\utility::GetYawToEnemy();
self OrientMode( "face angle", enemyAngle );
wait .05;
}
}
main()
{
println( "anim1" );
self endon( "killanimscript" );
self endon( "outoftruck" );
animscripts\utility::initialize( "l33t truckride combat" );
thread hackangle();
self OrientMode( "face enemy" );
if ( randomint( 100 ) > 50 )
nextaction = ( "stand" );
else
nextaction = ( "crouch" );
for ( ;; )
{
Reload( 0 );
if ( nextaction == ( "stand" ) )
{
timer = gettime() + randomint( 2000 ) + 2000;
while ( timer > gettime() )
{
success = LocalShootVolley( 0 );
nextaction = ( "crouch" );
}
}
else if ( nextaction == ( "crouch" ) )
{
timer = gettime() + randomint( 2000 ) + 2000;
while ( timer > gettime() )
{
success = ShootVolley();
if ( !success )
continue;
nextaction = ( "stand" );
}
}
}
}
LocalShootVolley( completeLastShot, forceShoot, posOverrideEntity )
{
if ( !isDefined( forceShoot ) )
{
forceShoot = "dontForceShoot";
}
self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );
if ( self.a.pose == "stand" )
{
anim_autofire = %stand_shoot_auto;
anim_semiautofire = %stand_shoot;
anim_boltfire = %stand_shoot;
}
else
{
anim_autofire = %crouch_shoot_auto;
anim_semiautofire = %crouch_shoot;
anim_boltfire = %crouch_shoot;
}
if ( animscripts\weaponList::usingAutomaticWeapon() )
{
self animscripts\face::SetIdleFace( anim.autofireface );
self setflaggedanimknob( "animdone", anim_autofire, 1, .15, 0 );
wait 0.20;
animRate = animscripts\weaponList::autoShootAnimRate();
self setFlaggedAnimKnobRestart( "shootdone", anim_autofire, 1, .05, animRate );
numShots = randomint( 8 ) + 6;
enemyAngle = animscripts\utility::AbsYawToEnemy();
for ( i = 0;( i < numShots && self.bulletsInClip > 0 && enemyAngle < 20 ); i++ )
{
self waittillmatch( "shootdone", "fire" );
if ( isDefined( posOverrideEntity ) )
{
if ( isSentient( posOverrideEntity ) )
{
pos = posOverrideEntity GetEye();
}
else
{
pos = posOverrideEntity.origin;
}
self shoot( 1, pos );
}
else
self shoot();
self decrementBulletsInClip();
enemyAngle = animscripts\utility::AbsYawToEnemy();
}
if ( completeLastShot )
wait animscripts\weaponList::waitAfterShot();
self notify( "stopautofireFace" );
}
else if ( animscripts\weaponList::usingSemiAutoWeapon() )
{
self animscripts\face::SetIdleFace( anim.aimface );
self setanimknob( anim_semiautofire, 1, .15, 0 );
wait 0.2;
rand = randomint( 2 ) + 2;
for ( i = 0;( i < rand && self.bulletsInClip > 0 ); i++ )
{
self setFlaggedAnimKnobRestart( "shootdone", anim_semiautofire, 1, 0, 1 );
if ( isDefined( posOverrideEntity ) )
self shoot( 1, posOverrideEntity . origin );
else
self shoot();
self decrementBulletsInClip();
shootTime = animscripts\weaponList::shootAnimTime();
quickTime = animscripts\weaponList::waitAfterShot();
wait quickTime;
if ( ( ( completeLastShot ) || ( i < rand - 1 ) ) && shootTime > quickTime )
wait shootTime - quickTime;
}
}
else
{
Rechamber();
self animscripts\face::SetIdleFace( anim.aimface );
self setanimknob( anim_boltfire, 1, .15, 0 );
wait 0.2;
self setFlaggedAnimKnobRestart( "shootdone", anim_boltfire, 1, 0, 1 );
if ( isDefined( posOverrideEntity ) )
self shoot( 1, posOverrideEntity . origin );
else
self shoot();
self.a.needsToRechamber = 1;
self decrementBulletsInClip();
shootTime = animscripts\weaponList::shootAnimTime();
quickTime = animscripts\weaponList::waitAfterShot();
wait quickTime;
}
return 1;
}


















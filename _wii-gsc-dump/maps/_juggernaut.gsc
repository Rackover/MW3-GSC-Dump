#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
JUGGERNAUT_MUSIC_DISTANCE = 2500;
main()
{
if ( isdefined( level.juggernaut_initialized ) )
return;
level.juggernaut_initialized = true;
if ( !isdefined( level.subclass_spawn_functions ) )
level.subclass_spawn_functions = [];
level.subclass_spawn_functions[ "juggernaut" ] = ::subclass_juggernaut;
level.juggernaut_next_alert_time = 0;
}
subclass_juggernaut()
{
self.juggernaut = true;
self.minPainDamage = 200;
self.grenadeAmmo = 0;
self.doorFlashChance = .05;
self.aggressivemode = true;
self.ignoresuppression = true;
self.no_pistol_switch = true;
self.noRunNGun = true;
self.dontMelee = true;
self.disableExits = true;
self.disableArrivals = true;
self.disableBulletWhizbyReaction = true;
self.combatMode = "no_cover";
self.neverSprintForVariation = true;
self.a.disableLongDeath = true;
self disable_turnAnims();
self disable_surprise();
init_juggernaut_animsets();
self add_damage_function( animscripts\pain::additive_pain );
self add_damage_function( maps\_spawner::pain_resistance );
if( !self isBadGuy() )
return;
self.bullet_resistance = 40;
self add_damage_function( maps\_spawner::bullet_resistance );
self thread juggernaut_hunt_immediately_behavior();
self thread juggernaut_sound_when_player_close();
self.pathEnemyFightDist = 128;
self.pathenemylookahead = 128;
level notify( "juggernaut_spawned" );
self waittill( "death", attacker, type, weapon );
if ( isdefined( self ) && isdefined( self.noDrop ) )
{
positions = [];
positions[ positions.size ] = "left";
positions[ positions.size ] = "right";
positions[ positions.size ] = "chest";
positions[ positions.size ] = "back";
self animscripts\shared::detachAllWeaponModels();
foreach ( position in positions )
{
weapon = self.a.weaponPos[ position ];
if ( weapon == "none" )
continue;
self.weaponInfo[ weapon ].position = "none";
self.a.weaponPos[ position ] = "none";
}
self.weapon = "none";
self animscripts\shared::updateAttachedWeaponModels();
}
level notify( "juggernaut_died" );
if ( ! isdefined( self ) )
return;
if ( ! isdefined( attacker ) )
return;
if ( ! isplayer( attacker ) )
return;
}
juggernaut_hunt_immediately_behavior()
{
self endon( "death" );
self endon( "stop_hunting" );
self.useChokePoints = false;
while ( 1 )
{
wait .5;
if ( isdefined( self.enemy ) )
{
self setgoalpos( self.enemy.origin );
self.goalradius = 128;
self.goalheight = 81;
}
}
}
juggernaut_sound_when_player_close()
{
self endon( "death" );
level endon( "special_op_terminated" );
if ( isdefined( level.skip_juggernaut_intro_sound ) && level.skip_juggernaut_intro_sound )
return;
music_distance = JUGGERNAUT_MUSIC_DISTANCE;
if ( level.script == "ending" )
{
flag_wait( "panic_button" );
music_distance = 750;
}
while ( 1 )
{
wait 0.05;
if ( gettime() < level.juggernaut_next_alert_time )
continue;
player = get_closest_player( self.origin );
if ( !isalive( player ) )
continue;
if ( distance( player.origin, self.origin ) > music_distance )
continue;
if ( level.pmc_alljuggernauts )
{
tag_flash_loc = self getTagOrigin( "tag_flash" );
if ( !BulletTracePassed( self getEye(), player geteye(), false, undefined ) )
{
wait 0.25;
continue;
}
}
break;
}
level.juggernaut_next_alert_time = gettime() + 15000;
level notify( "juggernaut_attacking" );
array_thread( level.players, ::playLocalSoundWrapper, "_juggernaut_attack" );
}
init_juggernaut_animsets()
{
self.walkDist = 500;
self.walkDistFacingMotion = 500;
self set_move_animset( "run", %Juggernaut_runF, %Juggernaut_sprint );
self set_move_animset( "walk", %Juggernaut_walkF );
self set_move_animset( "cqb", %Juggernaut_walkF );
self set_combat_stand_animset( %Juggernaut_stand_fire_burst, %Juggernaut_aim5, %Juggernaut_stand_idle, %Juggernaut_stand_reload );
}

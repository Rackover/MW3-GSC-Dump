
#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;
#using_animtree( "generic_human" );
CONST_anim_end_time = 0.25;
guy_enter( guy, climbed_in_vehicle )
{
AssertEx( !isSpawner( self ), "Tried to make guys enter a spawner" );
AssertEx( !isdefined( guy.ridingvehicle ), "ai can't ride two vehicles at the same time" );
if ( !isdefined( self ) )
return;
if ( !isdefined( self.vehicletype ) )
return;
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
vehicleanim = level.vehicle_aianims[ classname ];
maxpos = level.vehicle_aianims[ classname ].size;
self.attachedguys[ self.attachedguys.size ] = guy;
pos = set_pos( guy, maxpos );
if ( !isdefined( pos ) )
{
return;
}
if ( pos == 0 )
guy.drivingVehicle = true;
animpos = anim_pos( self, pos );
self.usedPositions[ pos ] = true;
guy.vehicle_position = pos;
guy.vehicle_idling = false;
if ( IsDefined( animpos.delay ) )
{
guy.delay = animpos.delay;
if ( IsDefined( animpos.delayinc ) )
{
self.delayer = guy.delay;
}
}
if ( IsDefined( animpos.delayinc ) )
{
self.delayer += animpos.delayinc;
guy.delay = self.delayer;
}
guy.ridingvehicle = self;
guy.orghealth = guy.health;
guy.vehicle_idle = animpos.idle;
guy.vehicle_standattack = animpos.standattack;
guy.deathanim = animpos.death;
guy.deathanimscript = animpos.deathscript;
guy.standing = 0;
guy.allowdeath = false;
if ( IsDefined( guy.deathanim ) && !isdefined( guy.magic_bullet_shield ) && vehicle_allows_rider_death() )
{
if( guy.vehicle_position != 0 || vehicle_allows_driver_death() )
{
guy.allowdeath = ( !isdefined( guy.script_allowdeath ) || guy.script_allowdeath );
if( isdefined( animpos.death_no_ragdoll ) )
guy.noragdoll = animpos.death_no_ragdoll;
}
}
if( guy.classname == "script_model" )
if ( IsDefined( animpos.death ) && guy.allowdeath && ( !isdefined( guy.script_allowdeath ) || guy.script_allowdeath ) )
thread guy_death( guy, animpos );
if ( !isdefined( guy.vehicle_idle ) )
guy.allowdeath = true;
self.riders[ self.riders.size ] = guy;
if ( guy.classname != "script_model" && spawn_failed( guy ) )
return;
org = self GetTagOrigin( animpos.sittag );
angles = self GetTagAngles( animpos.sittag );
link_to_sittag( guy, classname, animpos.sittag, animpos.sittag_offset );
if ( IsAI( guy ) )
{
guy Teleport( org, angles );
guy.a.disablelongdeath = true;
if ( IsDefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
guy gun_remove();
if ( guy_should_man_turret( animpos ) )
thread guy_man_turret( guy, pos, climbed_in_vehicle );
}
else
{
if ( IsDefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
detach_models_with_substr( guy, "weapon_" );
guy.origin = org;
guy.angles = angles;
}
if ( pos == 0 && IsDefined( vehicleanim[ 0 ].death ) )
thread driverdead( guy );
self notify( "guy_entered", guy, pos );
thread guy_handle( guy, pos );
if (( is_iw4_map_sp() && classname == "snowmobile" )
||( !is_iw4_map_sp() && classname == "script_vehicle_snowmobile" ))
{
self.steering = 0;
guy.onSnowMobile = true;
return;
}
if ( classname == "script_vehicle_atv" )
{
self.steering = 0;
guy.onATV = true;
guy.custom_animscript_table[ "combat" ] = animscripts\atv::main;
guy.custom_animscript_table[ "stop" ] = animscripts\atv::main;
return;
}
if ( IsDefined( animpos.getin_idle_func ) )
thread [[ animpos.getin_idle_func ]]( guy, pos );
else
thread guy_idle( guy, pos );
}
vehicle_allows_driver_death()
{
if( !isdefined( self.script_allow_driver_death ) )
return false;
return self.script_allow_driver_death ;
}
vehicle_allows_rider_death()
{
if( !isdefined( self.script_allow_rider_deaths ) )
return true;
return self.script_allow_rider_deaths ;
}
guy_should_man_turret( animpos )
{
if ( !IsDefined( animpos.mgturret ) )
return false;
if ( !IsDefined( self.script_nomg ) )
return true;
return !self.script_nomg;
}
handle_attached_guys()
{
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
self.attachedguys = [];
if ( !( IsDefined( level.vehicle_aianims ) && IsDefined( level.vehicle_aianims[ classname ] ) ) )
return;
maxpos = level.vehicle_aianims[ classname ].size;
if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "ai_wait_go" )
thread ai_wait_go();
self.runningtovehicle = [];
self.usedPositions = [];
self.getinorgs = [];
self.delayer = 0;
vehicleanim = level.vehicle_aianims[ classname ];
for ( i = 0; i < maxpos; i++ )
{
self.usedPositions[ i ] = false;
if ( IsDefined( self.script_nomg ) && self.script_nomg && IsDefined( vehicleanim[ i ].bIsgunner ) && vehicleanim[ i ].bIsgunner )
self.usedpositions[ 1 ] = true;
}
}
load_ai_goddriver( array )
{
load_ai( array, true );
}
guy_death( guy, animpos )
{
waittillframeend;
assert( !IsAI( guy ) );
guy setcandamage( true );
guy endon( "death" );
guy.allowdeath = false;
guy.script_startinghealth = 100000;
guy.health = 100000;
guy endon( "jumping_out" );
if( IsDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
{
while( IsDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
{
wait( 0.05 );
}
}
guy waittill( "damage" );
thread guy_deathimate_me( guy, animpos );
}
guy_deathimate_me( guy, animpos )
{
animtimer = GetTime() + ( GetAnimLength( animpos.death ) * 1000 );
angles = guy.angles;
origin = guy.origin;
guy = convert_guy_to_drone( guy );
[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
detach_models_with_substr( guy, "weapon_" );
guy LinkTo( self );
guy NotSolid();
guy wiisetallowragdoll( true );
guy setanim( animpos.death );
if( isai( guy ) )
guy animscripts\shared::DropAllAIWeapons();
else
detach_models_with_substr( guy, "weapon_" );
if ( isdefined( animpos.death_delayed_ragdoll ) )
{
guy Unlink();
guy StartRagdoll();
wait animpos.death_delayed_ragdoll;
guy Delete();
return;
}
}
load_ai( array, bGoddriver, group )
{
assert( self.code_classname == "script_vehicle" );
if ( !isdefined( bGoddriver ) )
bGoddriver = false;
if ( !isdefined( array ) )
{
array = vehicle_get_riders();
}
ent_flag_clear( "unloaded" );
ent_flag_clear( "loaded" );
array_levelthread( array, ::get_in_vehicle, bGoddriver, group );
}
is_rider( guy )
{
for ( i = 0; i < self.riders.size; i++ )
{
if ( self.riders[ i ] == guy )
{
return true;
}
}
return false;
}
vehicle_get_riders()
{
array = [];
ai = GetAIArray( self.script_team );
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( !isdefined( guy.script_vehicleride ) )
continue;
if ( guy.script_vehicleride != self.script_vehicleride )
continue;
array[ array.size ] = guy;
}
return array;
}
get_my_vehicleride()
{
array = [];
AssertEx( IsDefined( self.script_vehicleride ), "Tried to get my ride but I have no .script_vehicleride" );
vehicles = GetEntArray( "script_vehicle", "code_classname" );
for ( i = 0; i < vehicles.size; i++ )
{
vehicle = vehicles[ i ];
if ( !isdefined( vehicle.script_vehicleride ) )
continue;
if ( vehicle.script_vehicleride != self.script_vehicleride )
continue;
array[ array.size ] = vehicle;
}
AssertEx( array.size == 1, "Tried to get my ride but there was zero or multiple rides to choose from" );
return array[ 0 ];
}
get_in_vehicle( guy, bGoddriver, group )
{
if ( is_rider( guy ) )
{
return;
}
if ( !handle_detached_guys_check() )
{
return;
}
AssertEx( IsAlive( guy ), "tried to load a vehicle with dead guy, check your AI count to assure spawnability of ai's" );
guy_runtovehicle( guy, self, bGoddriver, group );
}
handle_detached_guys_check()
{
if ( vehicle_hasavailablespots() )
return true;
if( is_iw4_map_sp() )
AssertMsg( "script sent too many ai to vehicle( max is: " + level.vehicle_aianims[ self.vehicletype ].size + " )" );
else
AssertMsg( "script sent too many ai to vehicle( max is: " + level.vehicle_aianims[ self.classname ].size + " )" );
}
vehicle_hasavailablespots()
{
if ( is_iw4_map_sp() )
{
if ( level.vehicle_aianims[ self.vehicletype ].size - self.runningtovehicle.size )
return true;
else
return false;
}
else
{
if ( level.vehicle_aianims[ self.classname ].size - self.runningtovehicle.size )
return true;
else
return false;
}
}
guy_runtovehicle_loaded( guy, vehicle )
{
vehicle endon( "death" );
vehicle endon( "stop_loading" );
msg = guy waittill_any_return( "long_death", "death", "enteredvehicle" );
if ( msg != "enteredvehicle" && IsDefined( guy.forced_startingposition ) )
{
vehicle.usedpositions[ guy.forced_startingposition ] = false;
}
vehicle.runningtovehicle = array_remove( vehicle.runningtovehicle, guy );
vehicle_loaded_if_full( vehicle );
}
vehicle_loaded_if_full( vehicle )
{
if ( ( IsDefined( vehicle.vehicletype ) ) && ( vehicle.vehicletype == "littlebird" ) )
{
if ( vehicle.riders.size == 6 )
vehicle ent_flag_set( "loaded" );
}
else if ( !vehicle.runningtovehicle.size && vehicle.riders.size )
{
if ( vehicle.usedpositions[ 0 ] )
vehicle ent_flag_set( "loaded" );
else
vehicle thread vehicle_reload();
}
}
vehicle_reload()
{
Assert( self.riders.size );
riders = self.riders;
self vehicle_unload();
self ent_flag_wait( "unloaded" );
riders = array_removeDead( riders );
self thread vehicle_load_ai( riders );
}
remove_magic_bullet_shield_from_guy_on_unload_or_death( guy )
{
self waittill_any( "unload", "death" );
guy stop_magic_bullet_shield();
}
guy_runtovehicle( guy, vehicle, bGoddriver, group )
{
vehicle endon( "stop_loading" );
climbed_in_vehicle = true;
if ( !isdefined( bGoddriver ) )
bGoddriver = false;
if( is_iw4_map_sp() )
vehicleanim = level.vehicle_aianims[ vehicle.vehicletype ];
else
vehicleanim = level.vehicle_aianims[ vehicle.classname ];
if ( IsDefined( vehicle.runtovehicleoverride ) )
{
vehicle thread [[ vehicle.runtovehicleoverride ]]( guy );
return;
}
vehicle endon( "death" );
guy endon( "death" );
vehicle.runningtovehicle[ vehicle.runningtovehicle.size ] = guy;
thread guy_runtovehicle_loaded( guy, vehicle );
availablepositions = [];
chosenorg = undefined;
origin = 0;
bIsgettin = false;
for ( i = 0; i < vehicleanim.size; i++ )
{
if ( IsDefined( vehicleanim[ i ].getin ) )
bIsgettin = true;
}
if ( !bIsgettin )
{
guy notify( "enteredvehicle" );
vehicle guy_enter( guy, climbed_in_vehicle );
return;
}
if ( !isdefined( guy.get_in_moving_vehicle ) )
{
while ( vehicle Vehicle_GetSpeed() > 1 )
{
wait( 0.05 );
}
}
positions = vehicle get_availablepositions( group );
if ( IsDefined( guy.script_startingposition ) )
{
chosenorg = vehicle vehicle_getInstart( guy.script_startingposition );
}
else
if ( !vehicle.usedPositions[ 0 ] )
{
chosenorg = vehicle vehicle_getInstart( 0 );
if ( bGoddriver )
{
AssertEx( !isdefined( guy.magic_bullet_shield ), "magic_bullet_shield guy told to god mode drive a vehicle, you should simply load_ai without the god function for this guy" );
guy thread magic_bullet_shield();
thread remove_magic_bullet_shield_from_guy_on_unload_or_death( guy );
}
}
else
if ( positions.availablepositions.size )
{
chosenorg = getClosest( guy.origin, positions.availablepositions );
}
else
{
chosenorg = undefined;
}
if ( !positions.availablepositions.size && positions.nonanimatedpositions.size )
{
guy notify( "enteredvehicle" );
vehicle guy_enter( guy, climbed_in_vehicle );
return;
}
else
if ( !isdefined( chosenorg ) )
{
return;
}
origin = chosenorg.origin;
angles = chosenorg.angles;
guy.forced_startingposition = chosenorg.vehicle_position;
vehicle.usedpositions[ chosenorg.vehicle_position ] = true;
guy.script_moveoverride = true;
guy notify( "stop_going_to_node" );
guy set_forcegoal();
guy disable_arrivals();
guy.goalradius = 16;
guy SetGoalPos( origin );
guy waittill( "goal" );
guy enable_arrivals();
guy unset_forcegoal();
guy notify( "boarding_vehicle" );
animpos = anim_pos( vehicle, chosenorg.vehicle_position );
if ( IsDefined( animpos.delay ) )
{
guy.delay = animpos.delay;
if ( IsDefined( animpos.delayinc ) )
{
self.delayer = guy.delay;
}
}
if ( IsDefined( animpos.delayinc ) )
{
self.delayer += animpos.delayinc;
guy.delay = self.delayer;
}
vehicle link_to_sittag( guy, vehicle.vehicletype, animpos.sittag );
guy.allowdeath = false;
animpos = vehicleanim[ chosenorg.vehicle_position ];
if ( IsDefined( chosenorg ) )
{
if ( IsDefined( animpos.vehicle_getinanim ) )
{
if ( IsDefined( animpos.vehicle_getoutanim ) )
{
no_clear_anim = IsDefined( guy.no_vehicle_getoutanim );
if ( !no_clear_anim )
{
vehicle ClearAnim( animpos.vehicle_getoutanim, 0 );
}
}
vehicle = vehicle getanimatemodel();
vehicle thread setanimrestart_once( animpos.vehicle_getinanim, animpos.vehicle_getinanim_clear );
level thread maps\_anim::start_notetrack_wait( vehicle, "vehicle_anim_flag" );
}
if ( IsDefined( animpos.vehicle_getinsoundtag ) )
origin = vehicle GetTagOrigin( animpos.vehicle_getinsoundtag );
else
origin = vehicle.origin;
if ( IsDefined( animpos.vehicle_getinsound ) )
thread play_sound_in_space( animpos.vehicle_getinsound, origin );
getintags = undefined;
getinthreads = undefined;
if ( IsDefined( animpos.getin_enteredvehicletrack ) )
{
getintags = [];
getintags[ 0 ] = animpos.getin_enteredvehicletrack;
getinthreads = [];
getinthreads[ 0 ] = ::entered_vehicle_notify;
vehicle link_to_sittag( guy, vehicle.vehicletype, animpos.sittag );
}
vehicle animontag( guy, animpos.sittag, animpos.getin, getintags, getinthreads );
}
guy notify( "enteredvehicle" );
vehicle guy_enter( guy, climbed_in_vehicle );
}
entered_vehicle_notify()
{
self notify( "enteredvehicle" );
}
driverdead( guy )
{
if ( maps\_vehicle::isHelicopter() )
return;
self.driver = guy;
self endon( "death" );
guy waittill( "death" );
if ( isdefined( self.vehicle_keeps_going_after_driver_dies ) )
return;
self notify( "driver dead" );
self.deaddriver = true;
if ( IsDefined( self.hasstarted ) && self.hasstarted )
{
self SetWaitSpeed( 0 );
self Vehicle_SetSpeed( 0, 10 );
self waittill( "reached_wait_speed" );
}
self vehicle_unload();
}
copy_cat()
{
model = Spawn( "script_model", self.origin );
model SetModel( self.model );
size = self GetAttachSize();
for ( i = 0; i < size; i++ )
model Attach( self GetAttachModelName( i ) );
return model;
}
guy_becomes_real_ai( guy, pos )
{
if ( IsAI( guy ) )
return guy;
if ( guy.drone_delete_on_unload == true )
{
guy Delete();
return;
}
guy = makerealai( guy );
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
maxpos = level.vehicle_aianims[ classname ].size;
animpos = anim_pos( self, pos );
link_to_sittag( guy, classname, animpos.sittag );
guy.vehicle_idle = animpos.idle;
thread guy_idle( guy, pos );
return guy;
}
link_to_sittag( guy, classname, tag, offset )
{
if( !isdefined( offset ) )
offset = (0,0,0);
if ( ( is_iw4_map_sp() && ( ( classname == "snowmobile" ) || ( classname == "atv" ) ) )
|| ( (!is_iw4_map_sp()) && ( ( classname == "script_vehicle_snowmobile" ) || ( classname == "script_vehicle_atv" ) ) ) )
guy LinkToBlendToTag( self, tag, false );
else
guy _linkto( self, tag, offset, ( 0, 0, 0 ) );
}
anim_pos( vehicle, pos )
{
if( is_iw4_map_sp() )
return level.vehicle_aianims[ vehicle.vehicletype ][ pos ];
else
return level.vehicle_aianims[ vehicle.classname ][ pos ];
}
guy_deathhandle( guy, pos )
{
guy waittill( "death" );
if ( !isdefined( self ) )
return;
self.riders = array_remove( self.riders, guy );
self.usedPositions[ pos ] = false;
}
setup_aianimthreads()
{
if ( !isdefined( level.vehicle_aianimthread ) )
level.vehicle_aianimthread = [];
if ( !isdefined( level.vehicle_aianimcheck ) )
level.vehicle_aianimcheck = [];
level.vehicle_aianimthread[ "idle" ] = ::guy_idle;
level.vehicle_aianimthread[ "duck" ] = ::guy_duck;
level.vehicle_aianimthread[ "duck_once" ] = ::guy_duck_once;
level.vehicle_aianimcheck[ "duck_once" ] = ::guy_duck_once_check;
level.vehicle_aianimthread[ "weave" ] = ::guy_weave;
level.vehicle_aianimcheck[ "weave" ] = ::guy_weave_check;
level.vehicle_aianimthread[ "turn_right" ] = ::guy_turn_right;
level.vehicle_aianimcheck[ "turn_right" ] = ::guy_turn_right_check;
level.vehicle_aianimthread[ "turn_left" ] = ::guy_turn_left;
level.vehicle_aianimcheck[ "turn_left" ] = ::guy_turn_right_check;
level.vehicle_aianimthread[ "turn_hardright" ] = ::guy_turn_hardright;
level.vehicle_aianimthread[ "turn_hardleft" ] = ::guy_turn_hardleft;
level.vehicle_aianimthread[ "turret_fire" ] = ::guy_turret_fire;
level.vehicle_aianimthread[ "turret_turnleft" ] = ::guy_turret_turnleft;
level.vehicle_aianimthread[ "turret_turnright" ] = ::guy_turret_turnright;
level.vehicle_aianimthread[ "unload" ] = ::guy_unload;
level.vehicle_aianimthread[ "pre_unload" ] = ::guy_pre_unload;
level.vehicle_aianimcheck[ "pre_unload" ] = ::guy_pre_unload_check;
level.vehicle_aianimthread[ "idle_alert" ] = ::guy_idle_alert;
level.vehicle_aianimcheck[ "idle_alert" ] = ::guy_idle_alert_check;
level.vehicle_aianimthread[ "idle_alert_to_casual" ] = ::guy_idle_alert_to_casual;
level.vehicle_aianimcheck[ "idle_alert_to_casual" ] = ::guy_idle_alert_to_casual_check;
level.vehicle_aianimthread[ "reaction" ] = ::guy_turret_turnright;
}
guy_handle( guy, pos )
{
guy.vehicle_idling = true;
thread guy_deathhandle( guy, pos );
}
guy_stand_attack( guy, pos )
{
animpos = anim_pos( self, pos );
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
guy.standing = 1;
mintime = 0;
while ( 1 )
{
timer2 = GetTime() + 2000;
while ( GetTime() < timer2 && IsDefined( guy.enemy ) )
animontag( guy, animpos.sittag, guy.vehicle_standattack, undefined, undefined, "firing" );
rnum = RandomInt( 5 ) + 10;
for ( i = 0; i < rnum; i++ )
animontag( guy, animpos.sittag, animpos.standidle );
}
}
guy_stand_down( guy, pos )
{
animpos = anim_pos( self, pos );
if ( !isdefined( animpos.standdown ) )
{
thread guy_stand_attack( guy, pos );
return;
}
animontag( guy, animpos.sittag, animpos.standdown );
guy.standing = 0;
thread guy_idle( guy, pos );
}
driver_idle_speed( driver, pos )
{
driver endon( "newanim" );
self endon( "death" );
driver endon( "death" );
animpos = anim_pos( self, pos );
while ( 1 )
{
if ( self Vehicle_GetSpeed() == 0 )
driver.vehicle_idle = animpos.idle_animstop;
else
driver.vehicle_idle = animpos.idle_anim;
wait .25;
}
}
guy_reaction( guy, pos )
{
animpos = anim_pos( self, pos );
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
if ( IsDefined( animpos.reaction ) )
animontag( guy, animpos.sittag, animpos.reaction );
thread guy_idle( guy, pos );
}
guy_turret_turnleft( guy, pos )
{
animpos = anim_pos( self, pos );
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
while ( 1 )
animontag( guy, animpos.sittag, guy.turret_turnleft );
}
guy_turret_turnright( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
while ( 1 )
animontag( guy, animpos.sittag, guy.turret_turnleft );
}
guy_turret_fire( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.vehicle_turret_fire ) )
self get_dummy() SetAnimRestart( animpos.vehicle_turret_fire );
if ( IsDefined( animpos.turret_fire ) )
{
if ( IsDefined( animpos.turret_fire_tag ) )
animontag( guy, animpos.turret_fire_tag, animpos.turret_fire );
else
animontag( guy, animpos.sittag, animpos.turret_fire );
}
thread guy_idle( guy, pos );
}
guy_idle( guy, pos, ignoredeath )
{
guy endon( "newanim" );
if ( !isdefined( ignoredeath ) )
self endon( "death" );
guy endon( "death" );
guy.vehicle_idling = true;
guy notify( "gotime" );
if ( !isdefined( guy.vehicle_idle ) )
{
return;
}
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.mgturret ) )
return;
if ( IsDefined( animpos.hideidle ) && animpos.hideidle )
guy Hide();
if ( IsDefined( animpos.idle_animstop ) && IsDefined( animpos.idle_anim ) )
thread driver_idle_speed( guy, pos );
while ( 1 )
{
guy notify( "idle" );
self play_new_idle( guy, animpos );
}
}
play_new_idle( guy, animpos )
{
if ( IsDefined( guy.vehicle_idle_override ) )
{
self animontag( guy, animpos.sittag, guy.vehicle_idle_override );
return;
}
if ( IsDefined( animpos.idleoccurrence ) )
{
theanim = randomoccurrance( guy, animpos.idleoccurrence );
self animontag( guy, animpos.sittag, guy.vehicle_idle[ theanim ] );
return;
}
if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_idle ) )
{
self animontag( guy, animpos.sittag, animpos.player_idle );
return;
}
if ( IsDefined( animpos.vehicle_idle ) )
self thread setanimrestart_once( animpos.vehicle_idle );
self animontag( guy, animpos.sittag, guy.vehicle_idle );
}
randomoccurrance( guy, occurrences )
{
range = [];
totaloccurrance = 0;
for ( i = 0; i < occurrences.size; i++ )
{
totaloccurrance += occurrences[ i ];
range[ i ] = totaloccurrance;
}
pick = RandomInt( totaloccurrance );
for ( i = 0; i < occurrences.size; i++ )
if ( pick < range[ i ] )
return i;
}
guy_duck_once_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).duck_once );
}
guy_duck_once( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.duck_once ) )
{
if ( IsDefined( animpos.vehicle_duck_once ) )
self thread setanimrestart_once( animpos.vehicle_duck_once );
animontag( guy, animpos.sittag, animpos.duck_once );
}
thread guy_idle( guy, pos );
}
guy_weave_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).weave );
}
guy_weave( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.weave ) )
{
if ( IsDefined( animpos.vehicle_weave ) )
self thread setanimrestart_once( animpos.vehicle_weave );
animontag( guy, animpos.sittag, animpos.weave );
}
thread guy_idle( guy, pos );
}
guy_duck( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.duckin ) )
animontag( guy, animpos.sittag, animpos.duckin );
thread guy_duck_idle( guy, pos );
}
guy_duck_idle( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
theanim = randomoccurrance( guy, animpos.duckidleoccurrence );
while ( 1 )
animontag( guy, animpos.sittag, animpos.duckidle[ theanim ] );
}
guy_duck_out( guy, pos )
{
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.ducking ) && guy.ducking )
{
animontag( guy, animpos.sittag, animpos.duckout );
guy.ducking = false;
}
thread guy_idle( guy, pos );
}
guy_unload_que( guy )
{
self endon( "death" );
self.unloadque = array_add( self.unloadque, guy );
guy waittill_any( "death", "jumpedout" );
self.unloadque = array_remove( self.unloadque, guy );
if ( !self.unloadque.size )
{
self ent_flag_set( "unloaded" );
self.unload_group = "default";
}
}
riders_unloadable( unload_group )
{
if ( ! self.riders.size )
return false;
for ( i = 0; i < self.riders.size; i++ )
{
if( !isalive( self.riders[ i ] ) )
{
continue;
}
Assert( IsDefined( self.riders[ i ].vehicle_position ) );
if ( check_unloadgroup( self.riders[ i ].vehicle_position, unload_group ) )
return true;
}
return false;
}
get_unload_group()
{
group = [];
unloadgroups = [];
unload_group = "default";
if ( IsDefined( self.unload_group ) )
unload_group = self.unload_group;
if( is_iw4_map_sp() )
unloadgroups = level.vehicle_unloadgroups[ self.vehicletype ][ unload_group ];
else
unloadgroups = level.vehicle_unloadgroups[ self.classname ][ unload_group ];
if ( !IsDefined( unloadgroups ) )
{
if( is_iw4_map_sp() )
unloadgroups = level.vehicle_unloadgroups[ self.vehicletype ][ "default" ];
else
unloadgroups = level.vehicle_unloadgroups[ self.classname ][ "default" ];
}
foreach ( pos in unloadgroups )
{
group[ pos ] = pos;
}
return group;
}
check_unloadgroup( pos, unload_group )
{
if ( !IsDefined( unload_group ) )
unload_group = self.unload_group;
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
if ( !isdefined( level.vehicle_unloadgroups[ classname ] ) )
return true;
if ( !isdefined( level.vehicle_unloadgroups[ classname ][ unload_group ] ) )
{
PrintLn( "Invalid Unload group on node at origin: " + self.currentnode.origin + " with group:( \"" + unload_group + "\" )" );
PrintLn( "Unloading everybody" );
return true;
}
group = level.vehicle_unloadgroups[ classname ][ unload_group ];
for ( i = 0; i < group.size; i++ )
{
if ( pos == group[ i ] )
return true;
}
return false;
}
getoutrig_model_idle( model, tag, animation )
{
self endon( "unloading" );
while ( 1 )
animontag( model, tag, animation );
}
getoutrig_model( animpos, model, tag, animation, bIdletillunload )
{
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
if ( bIdletillunload )
{
thread getoutrig_model_idle( model, tag, level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].idleanim );
self waittill( "unloading" );
}
self.unloadque = array_add( self.unloadque, model );
self thread getoutrig_abort( model, tag, animation );
if ( !isdefined( self.crashing ) )
animontag( model, tag, animation );
model Unlink();
if ( !isdefined( self ) )
{
model Delete();
return;
}
Assert( IsDefined( self.unloadque ) );
self.unloadque = array_remove( self.unloadque, model );
if ( !self.unloadque.size )
self notify( "unloaded" );
self.fastroperig[ animpos.fastroperig ] = undefined;
wait 10;
model Delete();
}
getoutrig_disable_abort_notify_after_riders_out()
{
wait .05;
while ( IsAlive( self ) && self.unloadque.size > 2 )
wait .05;
if ( ! IsAlive( self ) || ( IsDefined( self.crashing ) && self.crashing ) )
return;
self notify( "getoutrig_disable_abort" );
}
getoutrig_abort_while_deploying()
{
self endon( "end_getoutrig_abort_while_deploying" );
while ( !isdefined( self.crashing ) )
wait 0.05;
updatedRiders = [];
foreach( rider in self.riders )
{
if( isAlive( rider ) )
{
add_to_array( updatedRiders , rider );
}
}
array_levelthread( updatedRiders, ::deleteent );
self notify( "crashed_while_deploying" );
updatedRiders = undefined;
}
getoutrig_abort( model, tag, animation )
{
totalAnimTime = GetAnimLength( animation );
ropesFallAnimTime = totalAnimTime - 1.0;
if ( self.vehicletype == "mi17" )
ropesFallAnimTime = totalAnimTime - .5;
ropesDeployedAnimTime = 2.5;
Assert( totalAnimTime > ropesDeployedAnimTime );
Assert( ropesFallAnimTime - ropesDeployedAnimTime > 0 );
self endon( "getoutrig_disable_abort" );
thread getoutrig_disable_abort_notify_after_riders_out();
thread getoutrig_abort_while_deploying();
waittill_notify_or_timeout( "crashed_while_deploying", ropesDeployedAnimTime );
self notify( "end_getoutrig_abort_while_deploying" );
while ( !isdefined( self.crashing ) )
wait 0.05;
thread animontag( model, tag, animation );
waittillframeend;
model SetAnimTime( animation, ropesFallAnimTime / totalAnimTime );
attacker = self;
if( isdefined( self.achievement_attacker ) )
attacker = self.achievement_attacker;
for ( i = 0; i < self.riders.size; i++ )
{
if ( !isdefined( self.riders[ i ] ) )
continue;
if ( !isdefined( self.riders[ i ].ragdoll_getout_death ) )
continue;
if ( self.riders[ i ].ragdoll_getout_death != 1 )
continue;
if ( !isdefined( self.riders[ i ].ridingvehicle ) )
continue;
self.riders[ i ].forcefallthroughonropes = 1;
if( isalive( self.riders[ i ] ) )
thread animontag_ragdoll_death_fall( self.riders[ i ], self, attacker );
}
}
setanimrestart_once( vehicle_anim, bClearAnim )
{
self endon( "death" );
self endon( "dont_clear_anim" );
if ( !isdefined( bClearAnim ) )
{
bClearAnim = true;
}
cycletime = GetAnimLength( vehicle_anim );
dummy = self get_dummy();
dummy endon ( "death" );
dummy SetFlaggedAnimRestart( "vehicle_anim_flag", vehicle_anim );
wait( cycletime );
if ( bClearAnim )
{
dummy ClearAnim( vehicle_anim, 0 );
}
}
getout_rigspawn( animatemodel, pos, bIdletillunload )
{
if ( !isdefined( bIdletillunload ) )
bIdletillunload = true;
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
animpos = anim_pos( self, pos );
if ( IsDefined( self.attach_model_override ) && IsDefined( self.attach_model_override[ animpos.fastroperig ] ) )
overrridegetoutrig = true;
else
overrridegetoutrig = false;
if ( !isdefined( animpos.fastroperig ) || IsDefined( self.fastroperig[ animpos.fastroperig ] ) || overrridegetoutrig )
return;
origin = animatemodel GetTagOrigin( level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].tag );
angles = animatemodel GetTagAngles( level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].tag );
self.fastroperiganimating[ animpos.fastroperig ] = true;
getoutrig_model = Spawn( "script_model", origin );
getoutrig_model.angles = angles;
getoutrig_model.origin = origin;
getoutrig_model SetModel( level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].model );
self.fastroperig[ animpos.fastroperig ] = getoutrig_model;
getoutrig_model UseAnimTree( #animtree );
getoutrig_model LinkTo( animatemodel, level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
thread getoutrig_model( animpos, getoutrig_model, level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].tag, level.vehicle_attachedmodels[ classname ][ animpos.fastroperig ].dropanim, bIdletillunload );
return getoutrig_model;
}
check_sound_tag_dupe( soundtag )
{
if ( !isdefined( self.sound_tag_dupe ) )
self.sound_tag_dupe = [];
duped = false;
if ( !isdefined( self.sound_tag_dupe[ soundtag ] ) )
self.sound_tag_dupe[ soundtag ] = true;
else
duped = true;
thread check_sound_tag_dupe_reset( soundtag );
return duped;
}
check_sound_tag_dupe_reset( soundtag )
{
wait .05;
if ( ! IsDefined( self ) )
return;
self.sound_tag_dupe[ soundtag ] = false;
keys = GetArrayKeys( self.sound_tag_dupe );
for ( i = 0; i < keys.size; i++ )
if ( self.sound_tag_dupe[ keys[ i ] ] )
return;
self.sound_tag_dupe = undefined;
}
guy_unload( guy, pos )
{
animpos = anim_pos( self, pos );
type = self.vehicletype;
if ( !check_unloadgroup( pos ) )
{
thread guy_idle( guy, pos );
return;
}
if ( !isdefined( animpos.getout ) )
{
thread guy_idle( guy, pos );
return;
}
if ( IsDefined( animpos.hideidle ) && animpos.hideidle )
guy Show();
thread guy_unload_que( guy );
self endon( "death" );
if ( IsAI( guy ) && IsAlive( guy ) )
guy endon( "death" );
if ( IsDefined( guy.onSnowMobile ) )
{
guy gun_recall();
guy.onSnowMobile = undefined;
if ( IsDefined( guy.getOffVehicleFunc ) )
guy [[ guy.getOffVehicleFunc ]]();
}
if ( IsDefined( guy.onATV ) )
{
guy gun_recall();
guy.onATV = undefined;
guy.custom_animscript_table[ "combat" ] = undefined;
guy.custom_animscript_table[ "stop" ] = undefined;
if ( IsDefined( guy.getOffVehicleFunc ) )
guy [[ guy.getOffVehicleFunc ]]();
}
if ( IsDefined( guy.onRotatingVehicleTurret ) )
{
guy.onRotatingVehicleTurret = undefined;
if ( IsDefined( guy.getOffVehicleFunc ) )
{
guy [[ guy.getOffVehicleFunc ]]();
}
}
animatemodel = getanimatemodel();
if ( IsDefined( animpos.vehicle_getoutanim ) )
{
animatemodel thread setanimrestart_once( animpos.vehicle_getoutanim, animpos.vehicle_getoutanim_clear );
sound_tag_dupped = false;
if ( IsDefined( animpos.vehicle_getoutsoundtag ) )
{
sound_tag_dupped = check_sound_tag_dupe( animpos.vehicle_getoutsoundtag );
origin = animatemodel GetTagOrigin( animpos.vehicle_getoutsoundtag );
}
else
origin = animatemodel.origin;
if ( IsDefined( animpos.vehicle_getoutsound ) && ! sound_tag_dupped )
thread play_sound_in_space( animpos.vehicle_getoutsound, origin );
sound_tag_dupped = undefined;
}
delay = 0;
if ( IsDefined( animpos.getout_timed_anim ) )
delay += GetAnimLength( animpos.getout_timed_anim );
if ( IsDefined( animpos.delay ) )
delay += animpos.delay;
if ( IsDefined( guy.delay ) )
delay += guy.delay;
if ( delay > 0 )
{
thread guy_idle( guy, pos );
wait delay;
}
hascombatjumpout = IsDefined( animpos.getout_combat );
if ( !hascombatjumpout && guy.standing )
guy_stand_down( guy, pos );
else if ( !hascombatjumpout && !guy.vehicle_idling && IsDefined( guy.vehicle_idle ) )
guy waittill( "idle" );
guy.deathanim = undefined;
guy.deathanimscript = undefined;
guy notify( "newanim" );
if ( IsDefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
{
if ( !IsDefined( guy.disable_gun_recall ) )
{
guy gun_recall();
}
}
if ( IsAI( guy ) )
guy PushPlayer( true );
bNoanimUnload = false;
if ( IsDefined( animpos.bNoanimUnload ) )
bNoanimUnload = true;
else if ( !isdefined( animpos.getout ) ||
( !isdefined( self.script_unloadmgguy ) && ( IsDefined( animpos.bIsgunner ) && animpos.bIsgunner ) ) ||
IsDefined( self.script_keepdriver ) && pos == 0 )
{
self thread guy_idle( guy, pos );
return;
}
if ( guy should_give_orghealth() )
{
guy.health = guy.orghealth;
}
guy.orghealth = undefined;
if ( IsAI( guy ) && IsAlive( guy ) )
guy endon( "death" );
guy.allowdeath = false;
if ( IsDefined( animpos.exittag ) )
tag = animpos.exittag;
else
tag = animpos.sittag;
if ( hascombatjumpout && guy.standing )
animation = animpos.getout_combat;
else if ( IsDefined( guy.get_out_override ) )
animation = guy.get_out_override;
else if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout ) )
animation = animpos.player_getout;
else
animation = animpos.getout;
if ( !bNoanimUnload )
{
thread guy_unlink_on_death( guy );
if ( IsDefined( animpos.fastroperig ) )
{
if ( ! IsDefined( self.fastroperig[ animpos.fastroperig ] ) )
{
thread guy_idle( guy, pos );
getoutrig_model = self getout_rigspawn( animatemodel, guy.vehicle_position, false );
}
}
if ( IsDefined( animpos.getoutsnd ) )
guy thread play_sound_on_tag( animpos.getoutsnd, "J_Wrist_RI", true );
if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound ) )
guy thread play_sound_on_entity( animpos.player_getout_sound );
if ( IsDefined( animpos.getoutloopsnd ) )
guy thread play_loop_sound_on_tag( animpos.getoutloopsnd );
if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_loop ) )
level.player thread play_loop_sound_on_entity( animpos.player_getout_sound_loop );
guy notify( "newanim" );
guy notify( "jumping_out" );
add_new_spawned_ai = false;
if( !IsAI( guy ) )
add_new_spawned_ai = true;
guy = guy_becomes_real_ai( guy, pos );
if ( !isalive( guy ) )
return;
guy.ragdoll_getout_death = true;
if ( isdefined( animpos.rappel_kill_achievement ) )
guy enable_achievement_harder_they_fall();
if ( IsDefined( animpos.ragdoll_getout_death ) )
{
guy.ragdoll_getout_death = true;
if ( IsDefined( animpos.ragdoll_fall_anim ) )
guy.ragdoll_fall_anim = animpos.ragdoll_fall_anim;
}
if( add_new_spawned_ai )
{
self.riders = array_add( self.riders , guy);
thread guy_deathhandle( guy, pos );
thread guy_unload_que( guy );
guy.ridingvehicle = self;
}
if ( IsAI( guy ) )
guy endon( "death" );
guy notify( "newanim" );
guy notify( "jumping_out" );
if ( IsDefined( animpos.littlebirde_getout_unlinks ) && animpos.littlebirde_getout_unlinks )
{
self thread stable_unlink( guy );
}
if ( IsDefined( animpos.getout_secondary ) )
{
animontag( guy, tag, animation );
secondaryunloadtag = tag;
if ( IsDefined( animpos.getout_secondary_tag ) )
secondaryunloadtag = animpos.getout_secondary_tag;
animontag( guy, secondaryunloadtag, animpos.getout_secondary );
}
else
{
guy.anim_end_early = true;
animontag( guy, tag, animation );
}
if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_loop ) )
level.player thread stop_loop_sound_on_entity( animpos.player_getout_sound_loop );
if ( IsDefined( animpos.getoutloopsnd ) )
guy thread stop_loop_sound_on_entity( animpos.getoutloopsnd );
if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_end ) )
level.player thread play_sound_on_entity( animpos.player_getout_sound_end );
}
else
{
if ( !isai( guy ) )
{
if ( guy.drone_delete_on_unload == true )
{
guy Delete();
return;
}
guy = makerealai( guy );
}
}
self.riders = array_remove( self.riders, guy );
self.usedPositions[ pos ] = false;
guy.ridingvehicle = undefined;
guy.drivingVehicle = undefined;
if ( !isalive( self ) && !isdefined( animpos.unload_ondeath ) )
{
guy Delete();
return;
}
guy Unlink();
if ( !isdefined( guy.magic_bullet_shield ) )
guy.allowdeath = true;
if ( IsAlive( guy ) )
{
guy.a.disablelongdeath = !( guy IsBadGuy() );
guy.forced_startingposition = undefined;
guy notify( "jumpedout" );
guy disable_achievement_harder_they_fall();
if ( IsDefined( animpos.getoutstance ) )
{
guy.desired_anim_pose = animpos.getoutstance;
guy AllowedStances( "crouch" );
guy thread animscripts\utility::UpdateAnimPose();
guy AllowedStances( "stand", "crouch", "prone" );
}
guy PushPlayer( false );
if ( guy_resets_goalpos( guy ) )
{
guy.goalradius = 600;
guy SetGoalPos( guy.origin );
}
}
if ( IsDefined( animpos.getout_delete ) && animpos.getout_delete )
{
guy Delete();
return;
}
guy guy_cleanup_vehiclevars();
}
guy_resets_goalpos( guy )
{
if ( IsDefined( guy.script_delayed_playerseek ) )
return false;
if ( guy has_color() )
return false;
if ( IsDefined( guy.qSetGoalPos ) )
return false;
if ( !isdefined( guy.target ) )
return true;
targetedNodes = GetNodeArray( guy.target, "targetname" );
return !targetedNodes.size;
}
animontag( guy, tag, animation, notetracks, sthreads, flag )
{
guy notify( "animontag_thread" );
guy endon( "animontag_thread" );
if ( !isdefined( flag ) )
flag = "animontagdone";
if ( IsDefined( self.modeldummy ) )
animatemodel = self.modeldummy;
else
animatemodel = self;
if ( !isdefined( tag ) )
{
org = guy.origin;
angles = guy.angles;
}
else
{
org = animatemodel GetTagOrigin( tag );
angles = animatemodel GetTagAngles( tag );
}
if ( IsDefined( guy.ragdoll_getout_death ) && !IsDefined( guy.no_vehicle_ragdoll ) )
level thread animontag_ragdoll_death( guy, self );
guy AnimScripted( flag, org, angles, animation );
if ( IsAI( guy ) )
thread DoNoteTracks( guy, animatemodel, flag );
if ( IsDefined( guy.anim_end_early ) )
{
guy.anim_end_early = undefined;
animWait = GetAnimLength( animation ) - CONST_anim_end_time;
if ( animWait > 0 )
wait( animWait );
guy StopAnimScripted();
guy.interval = 0;
guy thread recover_interval();
}
else
{
if ( IsDefined( notetracks ) )
{
for ( i = 0; i < notetracks.size; i++ )
{
guy waittillmatch( flag, notetracks[ i ] );
guy thread [[ sthreads[ i ] ]]();
}
}
guy waittillmatch( flag, "end" );
}
guy notify( "anim_on_tag_done" );
guy.ragdoll_getout_death = undefined;
}
recover_interval()
{
self endon( "death" );
wait( 2 );
if ( self.interval == 0 )
self.interval = 80;
}
animontag_ragdoll_death( guy, vehicle )
{
if ( IsDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
return;
if ( !isAI( guy ) )
guy SetCanDamage( true );
guy endon( "anim_on_tag_done" );
damage = undefined;
attacker = undefined;
vehicleallreadydead = vehicle.health <= 0;
while ( true )
{
if ( !vehicleallreadydead && !( IsDefined( vehicle ) && vehicle.health > 0 ) )
break;
guy waittill( "damage", damage, attacker );
if( isdefined( guy.forcefallthroughonropes ) )
break;
if ( !isdefined( damage ) )
continue;
if ( damage < 1 )
continue;
if ( !isdefined( attacker ) )
continue;
if ( ( IsPlayer( attacker ) ) )
break;
}
if ( !isalive( guy ) )
return;
thread arcadeMode_kill( guy.origin, "rifle", 300 );
thread animontag_ragdoll_death_fall( guy, vehicle, attacker );
}
animontag_ragdoll_death_fall( guy, vehicle, attacker )
{
guy.deathanim = undefined;
guy.deathFunction = undefined;
guy.anim_disablePain = true;
if ( IsDefined( guy.ragdoll_fall_anim ) )
{
moveDelta = GetMoveDelta( guy.ragdoll_fall_anim, 0, 1 );
groundPos = PhysicsTrace( guy.origin + ( 0, 0, 16 ), guy.origin - ( 0, 0, 10000 ) );
distanceFromGround = Distance( guy.origin + ( 0, 0, 16 ), groundPos );
if ( abs( moveDelta[ 2 ] + 16 ) <= abs( distanceFromGround ) )
{
guy thread play_sound_on_entity( "generic_death_falling" );
guy wiisetallowragdoll( true );
guy AnimScripted( "fastrope_fall", guy.origin, guy.angles, guy.ragdoll_fall_anim );
guy waittillmatch( "fastrope_fall", "start_ragdoll" );
}
}
if ( !isdefined( guy ) )
return;
guy.deathanim = undefined;
guy.deathFunction = undefined;
guy.anim_disablePain = true;
guy notify( "rope_death", attacker );
maps\_spawner::death_achievements_rappel( attacker );
guy Kill( attacker.origin, attacker );
guy animscripts\shared::DropAllAIWeapons();
guy StartRagdoll();
}
DoNoteTracks( guy, vehicle, flag )
{
guy endon( "newanim" );
vehicle endon( "death" );
guy endon( "death" );
guy animscripts\shared::DoNoteTracks( flag );
}
animatemoveintoplace( guy, org, angles, movetospotanim )
{
guy AnimScripted( "movetospot", org, angles, movetospotanim );
guy waittillmatch( "movetospot", "end" );
}
guy_vehicle_death( guy, attacker, type )
{
if( !isalive( guy ) )
return;
if ( IsDefined( self.no_rider_death ) )
{
return;
}
animpos = anim_pos( self, guy.vehicle_position );
guy.vehicle_attacker = attacker;
if ( IsDefined( animpos.explosion_death ) )
return guy_blowup( guy );
if ( IsDefined( animpos.unload_ondeath ) && IsDefined( self ) )
{
if ( IsDefined( self.dontunloadondeath ) && self.dontunloadondeath )
{
return;
}
thread guy_idle( guy, guy.vehicle_position, true );
wait animpos.unload_ondeath;
if ( IsDefined( guy ) && IsDefined( self ) )
{
self.groupedanim_pos = guy.vehicle_position;
self vehicle_ai_event( "unload" );
}
return;
}
if ( IsDefined( guy ) )
{
if( isdefined( guy.ragdoll_getout_death ) && type != "bm21_troops" )
{
return;
}
origin = guy.origin;
[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
if ( type == "bm21_troops" )
{
guy.allowdeath = true;
guy Kill();
return;
}
guy Delete();
}
}
guy_turn_right_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).turn_right );
}
guy_turn_right( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.vehicle_turn_right ) )
thread setanimrestart_once( animpos.vehicle_turn_right );
animontag( guy, animpos.sittag, animpos.turn_right );
thread guy_idle( guy, pos );
}
guy_turn_left( guy, pos )
{
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animpos = anim_pos( self, pos );
if ( IsDefined( animpos.vehicle_turn_left ) )
self thread setanimrestart_once( animpos.vehicle_turn_left );
animontag( guy, animpos.sittag, animpos.turn_left );
thread guy_idle( guy, pos );
}
guy_turn_left_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).turn_left );
}
guy_turn_hardright( guy, pos )
{
if( is_iw4_map_sp() )
animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
else
animpos = level.vehicle_aianims[ self.classname ][ pos ];
if ( IsDefined( animpos.idle_hardright ) )
guy.vehicle_idle_override = animpos.idle_hardright;
}
guy_turn_hardleft( guy, pos )
{
if( is_iw4_map_sp() )
animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
else
animpos = level.vehicle_aianims[ self.classname ][ pos ];
if ( IsDefined( animpos.idle_hardleft ) )
guy.vehicle_idle_override = animpos.idle_hardleft;
}
ai_wait_go()
{
self endon( "death" );
self waittill( "loaded" );
maps\_vehicle::gopath( self );
}
set_pos( guy, maxpos )
{
pos = guy.script_startingposition;
if ( IsDefined( guy.forced_startingposition ) )
{
pos = guy.forced_startingposition;
}
if ( IsDefined( pos ) )
{
return pos;
}
AssertEx( !isdefined( pos ), "Illegal starting position" );
for ( j = 0; j < self.usedPositions.size; j++ )
{
if ( self.usedPositions[ j ] )
continue;
return j;
}
if ( IsDefined( guy.script_vehicleride ) )
AssertMsg( "can't find vehicle rider position , likely too many guys assigned to ride a vehicle ( copy paste in radiant? ) rider number: ", guy.script_vehicleride );
AssertMsg( "All spots on this vehicle were used up, too many AI trying to ride." );
}
guy_man_turret( guy, pos, climbed_in_vehicle )
{
animpos = anim_pos( self, pos );
turret = self.mgturret[ animpos.mgturret ];
if( !isalive( guy ) )
return;
turret endon( "death" );
guy endon( "death" );
if ( isdefined( climbed_in_vehicle ) && climbed_in_vehicle && isdefined( animpos.passenger_2_turret_func ) )
[[ animpos.passenger_2_turret_func ]]( self, guy, pos, turret );
set_turret_team( turret );
turret SetDefaultDropPitch( 0 );
wait( 0.1 );
guy endon( "guy_man_turret_stop" );
level thread maps\_mgturret::mg42_setdifficulty( turret, getDifficulty() );
turret SetTurretIgnoreGoals( true );
while ( 1 )
{
if ( !isdefined( guy GetTurret() ) )
guy UseTurret( turret );
wait 1;
}
}
guy_unlink_on_death( guy )
{
guy endon( "jumpedout" );
guy waittill( "death" );
if ( IsDefined( guy ) )
guy Unlink();
}
guy_blowup( guy )
{
if ( ! IsDefined( guy.vehicle_position ) )
return;
pos = guy.vehicle_position;
anim_pos = anim_pos( self, pos );
if ( !isdefined( anim_pos.explosion_death ) )
return;
[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", guy.origin );
guy.deathanim = anim_pos.explosion_death;
angles = self.angles;
origin = guy.origin;
if ( IsDefined( anim_pos.explosion_death_offset ) )
{
origin += ( AnglesToForward( angles ) * anim_pos.explosion_death_offset[ 0 ] );
origin += ( AnglesToRight( angles ) * anim_pos.explosion_death_offset[ 1 ] );
origin += ( AnglesToUp( angles ) * anim_pos.explosion_death_offset[ 2 ] );
}
guy = convert_guy_to_drone( guy );
detach_models_with_substr( guy, "weapon_" );
guy NotSolid();
guy.origin = origin;
guy.angles = angles;
guy AnimScripted( "deathanim", origin, angles, anim_pos.explosion_death );
fraction = .3;
if ( IsDefined( anim_pos.explosion_death_ragdollfraction ) )
fraction = anim_pos.explosion_death_ragdollfraction;
animlength = GetAnimLength( anim_pos.explosion_death );
timer = GetTime() + ( animlength * 1000 );
wait animlength * fraction;
force = ( 0, 0, 1 );
org = guy.origin;
if ( GetDvar( "ragdoll_enable" ) == "0" )
{
guy Delete();
return;
}
if( isai( guy ) )
guy animscripts\shared::DropAllAIWeapons();
else
detach_models_with_substr( guy, "weapon_" );
while ( ! guy IsRagdoll() && GetTime() < timer )
{
org = guy.origin;
wait .05;
force = guy.origin - org;
guy StartRagdoll();
}
wait .05;
force *= ( 20000 );
for ( i = 0; i < 3; i++ )
{
if ( IsDefined( guy ) )
org = guy.origin;
wait( 0.05 );
}
if ( !guy IsRagdoll() )
guy Delete();
}
convert_guy_to_drone( guy, bKeepguy )
{
if ( !isdefined( bKeepguy ) )
bKeepguy = false;
model = Spawn( "script_model", guy.origin );
model.angles = guy.angles;
model SetModel( guy.model );
size = guy GetAttachSize();
for ( i = 0; i < size; i++ )
{
model Attach( guy GetAttachModelName( i ), guy GetAttachTagName( i ) );
}
model UseAnimTree( #animtree );
if ( IsDefined( guy.team ) )
model.team = guy.team;
if ( !bKeepguy )
guy Delete();
model MakeFakeAI();
return model;
}
vehicle_animate( animation, animtree )
{
self UseAnimTree( animtree );
self SetAnim( animation );
}
vehicle_getInstart( pos )
{
animpos = anim_pos( self, pos );
Assert( IsDefined( animpos ) );
Assert( IsDefined( animpos.sittag ) );
Assert( IsDefined( animpos.getin ) );
return vehicle_getanimstart( animpos.getin, animpos.sittag, pos );
}
vehicle_getanimstart( animation, tag, pos )
{
struct = SpawnStruct();
origin = undefined;
angles = undefined;
Assert( IsDefined( animation ) );
org = self GetTagOrigin( tag );
ang = self GetTagAngles( tag );
origin = GetStartOrigin( org, ang, animation );
angles = GetStartAngles( org, ang, animation );
struct.origin = origin;
struct.angles = angles;
struct.vehicle_position = pos;
return struct;
}
is_position_in_group( vehicle, pos, group )
{
if ( !isdefined( group ) )
return true;
classname = vehicle.classname;
if( is_iw4_map_sp() )
classname = vehicle.vehicletype;
Assert( IsDefined( level.vehicle_unloadgroups[ classname ][ group ] ) );
vehicles_group = level.vehicle_unloadgroups[ classname ][ group ];
foreach ( member in vehicles_group )
{
if ( member == pos )
return true;
}
return false;
}
get_availablepositions( group )
{
if( is_iw4_map_sp() )
vehicleanim = level.vehicle_aianims[ self.vehicletype ];
else
vehicleanim = level.vehicle_aianims[ self.classname ];
availablepositions = [];
nonanimatedpositions = [];
for ( i = 0; i < self.usedPositions.size; i++ )
{
if ( self.usedPositions[ i ] )
continue;
if ( IsDefined( vehicleanim[ i ].getin ) && is_position_in_group( self, i, group ) )
availablepositions[ availablepositions.size ] = vehicle_getInstart( i );
else
nonanimatedpositions[ nonanimatedpositions.size ] = i;
}
struct = SpawnStruct();
struct.availablepositions = availablepositions;
struct.nonanimatedpositions = nonanimatedpositions;
return struct;
}
getanimatemodel()
{
if ( IsDefined( self.modeldummy ) )
return self.modeldummy;
else
return self;
}
detach_models_with_substr( guy, substr )
{
size = guy GetAttachSize();
modelstodetach = [];
tagsstodetach = [];
index = 0;
for ( i = 0; i < size; i++ )
{
modelname = guy GetAttachModelName( i );
tagname = guy GetAttachTagName( i );
if ( IsSubStr( modelname, substr ) )
{
modelstodetach[ index ] = modelname;
tagsstodetach[ index ] = tagname;
}
}
for ( i = 0; i < modelstodetach.size; i++ )
guy Detach( modelstodetach[ i ], tagsstodetach[ i ] );
}
should_give_orghealth()
{
if ( !isai( self ) )
return false;
if ( !isdefined( self.orghealth ) )
return false;
return !isdefined( self.magic_bullet_shield );
}
guy_pre_unload_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).pre_unload );
}
guy_pre_unload( guy, pos )
{
animpos = anim_pos( self, pos );
if ( !isdefined( animpos.pre_unload ) )
return;
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animontag( guy, animpos.sittag, animpos.pre_unload );
while ( 1 )
animontag( guy, animpos.sittag, animpos.pre_unload_idle );
}
guy_idle_alert( guy, pos )
{
animpos = anim_pos( self, pos );
if ( !isdefined( animpos.idle_alert ) )
return;
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
while ( 1 )
animontag( guy, animpos.sittag, animpos.idle_alert );
}
guy_idle_alert_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).idle_alert );
}
guy_idle_alert_to_casual( guy, pos )
{
animpos = anim_pos( self, pos );
if ( !isdefined( animpos.idle_alert ) )
return;
guy endon( "newanim" );
self endon( "death" );
guy endon( "death" );
animontag( guy, animpos.sittag, animpos.idle_alert_to_casual );
thread guy_idle( guy, pos );
}
guy_idle_alert_to_casual_check( guy, pos )
{
return IsDefined( anim_pos( self, pos ).idle_alert_to_casual );
}
stable_unlink( guy )
{
self waittill( "stable_for_unlink" );
if( isalive( guy ) )
guy Unlink();
}
track_entered_vehicle()
{
}
animate_guys( other )
{
return_guys = [];
foreach ( guy in self.riders )
{
if ( !IsAlive( guy ) )
continue;
if ( IsDefined( level.vehicle_aianimcheck[ other ] ) && ! [[ level.vehicle_aianimcheck[ other ] ]]( guy, guy.vehicle_position ) )
continue;
if ( IsDefined( level.vehicle_aianimthread[ other ] ) )
{
guy notify( "newanim" );
guy.queued_anim_threads = [];
thread [[ level.vehicle_aianimthread[ other ] ]]( guy, guy.vehicle_position );
return_guys[ return_guys.size ] = guy;
}
else
PrintLn( "Error: leaaaaaaaaaaaaaak", other );
}
return return_guys;
}
guy_cleanup_vehiclevars()
{
self.vehicle_idling = undefined;
self.standing = undefined;
self.vehicle_position = undefined;
self.delay = undefined;
}
delete_corpses_around_vehicle()
{
centroid = self getcentroid();
point_in_bounds = self getpointinbounds( 1,0,0 );
dist = distance( point_in_bounds, centroid );
corpses = getcorpsearray();
foreach( corpse in corpses )
if( distance( corpse.origin, centroid ) < dist )
corpse delete();
}
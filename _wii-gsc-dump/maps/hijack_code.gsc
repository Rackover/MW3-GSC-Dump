#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_hud_util;
start_logic()
{
level.commander = spawn_targetname("commander");
level.commander magic_bullet_shield();
level.advisor = spawn_targetname("advisor");
level.advisor magic_bullet_shield();
}
spawn_ally( allyName , overrideSpawnPointName )
{
if ( !IsDefined( overrideSpawnPointName ))
{
overrideSpawnPointName = level.start_point + "_" + allyName;
}
ally = spawn_noteworthy_at_struct_targetname( allyName , overrideSpawnPointName );
return ally;
}
spawn_noteworthy_at_struct_targetname( noteworthyName , structName )
{
noteworthy_spawner = getent( noteworthyName , "script_noteworthy" );
noteworthy_start = getstruct( structName , "targetname" );
noteworthy_spawner.origin = noteworthy_start.origin;
if(isdefined(noteworthy_start.angles))
{
noteworthy_spawner.angles = noteworthy_start.angles;
}
spawned = noteworthy_spawner spawn_ai();
return spawned;
}
try_activate_trigger_targetname(msg)
{
trigger = GetEnt( msg, "targetname" );
if ( isdefined(trigger) && !isdefined(trigger.trigger_off) )
{
trigger activate_trigger();
}
}
array_wait_any( ents , msg , timeout )
{
setmsg = "array_wait_any_" + msg;
foreach( ent in ents )
{
ent thread array_wait_set( msg , setmsg );
}
if ( !IsDefined( timeout ))
{
level waittill( setmsg );
}
else
{
level waittill_any_timeout( timeout , setmsg );
}
}
array_wait_set( msg , setmsg )
{
self waittill( msg );
level notify( setmsg );
}
AI_civilian_think()
{
eNode = getent( self.target, "targetname" );
assert( isdefined( eNode ) );
sAnim = eNode.script_noteworthy;
assertex( isdefined( level.scr_anim[ "generic" ][ sAnim ], "There is no animation defined named: " + sAnim ) );
self.allowdeath = true;
self.animname = "generic";
self.health = 1;
self.noragdoll = 1;
self.no_pain_sound = true;
self.deathanim = level.scr_anim[ "generic" ][ sAnim ];
self.a.nodeath = true;
self.delete_on_death = false;
self.NoFriendlyfire = true;
self.ignoreme = true;
eNode thread anim_single_solo( self, sAnim );
wait (.2);
self kill();
}
cold_breath_hijack()
{
tag = "TAG_EYE";
self endon( "death" );
self notify( "stop personal effect" );
self endon( "stop personal effect" );
self.has_cold_breath = 1;
while ( isdefined( self ) )
{
wait( 0.05 );
if( !isdefined( self ) )
break;
playfxOnTag( level._effect[ "cold_breath" ], self, tag );
wait( 2.5 + randomfloat( 2.5 ) );
}
}
plane_rumbling()
{
level endon( "stop_rumbling" );
while ( true )
{
earthquake( .15, .05, level.player.origin, 80000 );
wait( .05 );
}
}
setup_player_for_animation()
{
get_player_rig();
level.player allowcrouch( false );
level.player allowprone( false );
level.player allowsprint( false );
level.player allowjump( false );
}
unsetup_player_after_animation()
{
level.player Unlink();
level.player allowcrouch( true );
level.player allowprone( true );
level.player allowsprint( true );
level.player allowjump( true );
level.player_rig Delete();
}
get_player_rig()
{
if ( !isdefined( level.player_rig ) )
level.player_rig = spawn_anim_model( "player_rig" );
return level.player_rig;
}
no_grenades()
{
self.grenadeammo = 0;
}
background_chatter( sLine, org )
{
if ( !isdefined( org ) )
return;
if ( isdefined( org.deleteme ) )
{
org delete();
}
org playsound( sLine, "done" );
org waittill( "done" );
}
check_player_for_prone( clear )
{
self endon( "player_clear_of_idle" );
self endon( "stop_prone_check" );
while(1)
{
distance_player_to_AI = Distance(level.player.origin, self.origin);
if( (level.player GetStance() == "prone") && ( distance_player_to_AI < 50 ))
{
self InvisibleNotSolid();
level.player AllowCrouch( false );
level.player AllowStand( false );
}
else
{
self VisibleSolid();
level.player AllowCrouch( true );
level.player AllowStand( true );
wait(.05);
if( isDefined(clear) && clear == "true" )
{
self notify( "player_clear_of_idle" );
}
}
wait(.05);
}
}
rotate_rollers_roll( angle, time, accel_time, decel_time )
{
self rotateroll( angle, time, accel_time, decel_time );
}
rotate_rollers_pitch( angle, time, accel_time, decel_time )
{
self rotatepitch( angle, time, accel_time, decel_time);
}
rotate_rollers_to( angles, time, accel_time, decel_time )
{
self RotateTo( angles, time, accel_time, decel_time);
}
gravity_shift(x, y, z)
{
setsaveddvar( "phys_gravityChangeWakeupRadius", 1600 );
setPhysicsGravityDir( (x, y, z) );
}
hjk_BeginSliding( velocity, allowedAcceleration, dampening )
{
Assert( IsPlayer( self ) );
player = self;
player thread play_sound_on_entity( "foot_slide_plr_start" );
player thread play_loop_sound_on_tag( "foot_slide_plr_loop" );
override_link_method = IsDefined( level.custom_linkto_slide );
if ( !isDefined( velocity ) )
velocity = player GetVelocity() + ( 0, 0, -10 );
if ( !isDefined( allowedAcceleration ) )
allowedAcceleration = 10;
if ( !isDefined( dampening ) )
dampening = .035;
Assert( !isDefined( player.slideModel ) );
slideModel = Spawn( "script_origin", player.origin );
slideModel.angles = player.angles;
player.slideModel = slideModel;
slideModel MoveSlide( ( 0, 0, 15 ), 15, velocity );
if ( override_link_method )
{
player PlayerLinkToDelta( slideModel, undefined, 0 );
}
else
{
player PlayerLinkTo( slideModel, undefined, 0, 180, 180, 180, 180, true );
}
if(!isdefined(level.custom_linkto_slide_allow_prone))
{
player AllowProne( false );
}
player thread maps\_utility_code::DoSlide( slideModel, allowedAcceleration, dampening );
}
hjk_EndSliding()
{
Assert( IsPlayer( self ) );
player = self;
if( !IsDefined( player.slideModel ) )
{
return;
}
player notify( "stop sound" + "foot_slide_plr_loop" );
player thread play_sound_on_entity( "foot_slide_plr_end" );
player Unlink();
player SetVelocity( player.slidemodel.slideVelocity );
player.slideModel Delete();
player AllowProne( true );
player AllowStand( true );
player notify( "stop_sliding" );
}
RockingPlane()
{
level endon("stop_rocking");
refposent = level.org_view_roll;
refent = spawn_tag_origin();
refent2 = undefined;
if (!isdefined(refposent))
{
refent.angles = (0, 0, 0);
}
else
{
refent.origin = refposent.origin;
refent.angles = refposent.angles;
}
sgn = 1;
level.rocking_mag[0] = .25;
level.rocking_mag[1] = .625;
while (true)
{
t = RandomFloatRange( 6.0, 7.0 );
angle = sgn * RandomFloatRange( level.rocking_mag[0], level.rocking_mag[1] );
sgn = -1 * sgn;
angles = ( 0, 0, angle );
array_thread( level.aRollers, ::rotate_rollers_to, angles, t, t/3, t/3 );
wait t;
}
}
StopRocking( ref2 )
{
flag_wait( "obj_capturesub_complete" );
level notify("stop_rocking");
level.player playerSetGroundReferenceEnt( undefined );
self Delete();
if (isdefined(ref2))
ref2 Delete();
}
set_grav( view_angle_controller_entity )
{
level endon( "stop_rocking" );
thread reset_grav();
count = 0;
jolt_org = getstruct( "jolter", "targetname" );
while( 1 )
{
toup = anglestoup( view_angle_controller_entity.angles );
grav_dir = -1 * toup ;
grav_ampped = grav_dir * ( 1, 10, .75 );
grav = vectorNormalize( grav_ampped );
SetPhysicsGravityDir( grav );
count++;
if( count > 15 )
{
PhysicsJitter(jolt_org.origin, 1000, 800, .01, .1 );
count = 0;
}
wait( .1 );
}
}
reset_grav()
{
level waittill( "stop_rocking" );
wait( .11 );
SetPhysicsGravityDir( ( 0, 0, -1 ) );
}
setup_ent_rockers()
{
level.rockers = [];
level.rockers_opp = [];
level.rocker_hangers = [];
doors = getentarray( "sub_pressuredoor_rocker", "targetname" );
foreach( door in doors )
{
org = getent( door.target, "targetname" );
door linkto( org );
level.rockers[level.rockers.size] = org;
}
doors = getentarray( "sub_pressuredoor_rocker_opposite", "targetname" );
foreach( door in doors )
{
org = getent( door.target, "targetname" );
door linkto( org );
level.rockers_opp[level.rockers_opp.size] = org;
}
hangers01 = getentarray( "dyn_hanger", "targetname" );
foreach( ent in hangers01 )
{
org = getent( ent.target, "targetname" );
ent linkto( org );
level.rocker_hangers[level.rocker_hangers.size] = org;
}
}
turbulence( turbtime )
{
thread turbulence_loop();
t = turbtime;
wait t;
flag_set("stop_turbulence");
t2 = abs(level.turbangles[0])/8;
level.org_view_roll RotateTo( (0,0,0) , t2, 0, 0 );
wait t2;
}
turbulence_loop()
{
level endon("stop_turbulence");
sgn = 1;
level.rocking_mag[0] = .3;
level.rocking_mag[1] = .5;
level.pitch_mag[0] = 2;
level.pitch_mag[1] = 5;
while (true)
{
t = RandomFloatRange( .1, .2 );
anglePitch = sgn * RandomFloatRange( level.pitch_mag[0], level.pitch_mag[1] );
angleYaw = sgn * RandomFloatRange( level.rocking_mag[0], level.rocking_mag[1] );
angleRoll = sgn * RandomFloatRange( level.rocking_mag[0], level.rocking_mag[1] );
sgn = -1 * sgn;
level.turbangles = ( anglePitch, angleYaw, angleRoll );
earthquake( .1, t, level.player.origin, 80000 );
level.org_view_roll RotateTo( level.turbangles, t, t/3, t/3 );
wait t;
}
}
launch_object( force_amount, force_dir )
{
wait_time = RandomFloatRange(0,0.9);
wait(wait_time);
force_amount *= level.objectmass[self.model];
force = force_dir * force_amount;
self PhysicsLaunchClient( self.origin , force );
}
start_phys_explosion_on_delay(outer_radius,inner_radius,magnitude)
{
wait_time = RandomFloatRange(0,0.9);
wait(wait_time);
PhysicsExplosionSphere(self.origin, outer_radius, inner_radius, magnitude);
}
fade_out( fade_out_time, optional_alpha_override )
{
black_overlay = get_black_overlay();
if ( fade_out_time )
black_overlay FadeOverTime( fade_out_time );
if ( isdefined(optional_alpha_override) )
{
black_overlay.alpha = optional_alpha_override;
}
else
{
black_overlay.alpha = 1;
}
wait( fade_out_time );
}
fade_in( fade_time )
{
if ( level.MissionFailed )
return;
level notify( "now_fade_in" );
black_overlay = get_black_overlay();
if ( fade_time )
black_overlay FadeOverTime( fade_time );
black_overlay.alpha = 0;
wait( fade_time );
}
get_black_overlay()
{
if ( !IsDefined( level.black_overlay ) )
level.black_overlay = create_client_overlay( "black", 0, level.player );
level.black_overlay.sort = -1;
level.black_overlay.foreground = false;
return level.black_overlay;
}
airmask_setup()
{
self.dummy = spawn( "script_origin", self.origin + ( 0, 0, 30 ) );
self.dummy.angles = level.org_view_roll.angles;
level.aRollers = array_add( level.aRollers, self.dummy );
self linkto( self.dummy );
self.dummy movez( 45, .1 );
self hide();
}
airmask_think()
{
if ( getdvar( "airmasks" ) == "0" )
return;
self show();
iTime = randomfloatrange( .75, 1.2 );
self.dummy movez( -55, iTime, iTime / 3, iTime / 3 );
wait( iTime );
self.dummy movez( 10, iTime / 2 );
wait( iTime / 2 );
}
ai_array_killcount_flag_set( enemies , killcount , flag , timeout )
{
waittill_dead_or_dying( enemies , killcount , timeout );
flag_set( flag );
}
temp_dialogue( speaker, text, duration )
{
level notify("temp_dialogue", speaker, text, duration);
level endon("temp_dialogue");
if ( !IsDefined( duration ) )
{
duration = 4;
}
if ( IsDefined( level.tmp_subtitle ) )
{
level.tmp_subtitle destroy();
level.tmp_subtitle = undefined;
}
level.tmp_subtitle = newHudElem();
level.tmp_subtitle.x = -60;
level.tmp_subtitle.y = -62;
level.tmp_subtitle settext( "^2" + speaker + ": ^7" + text );
level.tmp_subtitle.fontScale = 1.46;
level.tmp_subtitle.alignX = "center";
level.tmp_subtitle.alignY = "middle";
level.tmp_subtitle.horzAlign = "center";
level.tmp_subtitle.vertAlign = "bottom";
level.tmp_subtitle.sort = 1;
wait duration;
thread temp_dialogue_fade();
}
temp_dialogue_fade()
{
level endon("temp_dialogue");
for ( alpha = 1.0; alpha > 0.0; alpha -= 0.1 )
{
level.tmp_subtitle.alpha = alpha;
wait 0.05;
}
level.tmp_subtitle destroy();
}
hjk_red_light_pulsing(num)
{
lightMin = 0.15;
lightMax = .6;
curr = lightmax;
for ( ;; )
{
while ( ( curr > lightMin) )
{
curr = max(curr-(lightmax/7.5),lightMin);
self setLightIntensity( curr );
wait( .05 );
}
wait( .15 );
pulsing_light_fx(num);
while ( curr<lightMax)
{
curr = min(curr+(lightmax/10),lightMax);
self setLightIntensity( curr );
wait( .05 );
}
wait( .15 );
}
}
pulsing_light_fx(light)
{
switch(light)
{
case 0:
exploder("light_0");
break;
case 1:
exploder("light_1");
break;
case 2:
exploder("light_2");
break;
case 3:
exploder("light_3");
break;
default:
break;
}
}
so_remove_entities_by_script_difficulty()
{
difficulty_string = "";
switch ( level.gameskill )
{
case 0:
case 1:
difficulty_string = "regular";
break;
case 2:
difficulty_string = "hardened";
break;
case 3:
difficulty_string = "veteran";
break;
default:
AssertMsg( "so_remove_entities_by_script_difficulty found that level.gameskill is not an acceptable value: " + level.gameskill );
break;
}
entities = GetEntArray();
foreach ( entity in entities )
{
if ( !IsDefined( entity.script_difficulty ) )
{
continue;
}
if ( so_should_delete_entity_by_difficulty( entity, difficulty_string, is_coop() ) )
{
entity Delete();
}
}
}
so_should_delete_entity_by_difficulty( entity, difficulty_string, is_coop )
{
or_tokens = [];
tokens = StrTok( entity.script_difficulty, "," );
index = 0;
foreach ( token in tokens )
{
AssertEx( !IsSubStr( token, " " ), "Entity " + entity.classname + " at " + entity.origin + " has a script_difficulty that contains spaces: " + entity.script_difficulty );
or_tokens[index] = StrTok( token, "_" );
index++;
}
foreach ( and_tokens in or_tokens )
{
contains_coop = array_contains( and_tokens, "coop" );
contains_sp = array_contains( and_tokens, "sp" );
AssertEx( !(contains_coop && contains_sp), "Entity " + entity.classname + " at " + entity.origin + " has a script_difficulty that contains coop AND sp together when it shouldn't: " + entity.script_difficulty );
if ( contains_coop || contains_sp )
{
if ( is_coop && !contains_coop )
{
continue;
}
if ( !is_coop && !contains_sp )
{
continue;
}
}
contains_regular = array_contains( and_tokens, "regular" );
contains_hardened = array_contains( and_tokens, "hardened" );
contains_veteran = array_contains( and_tokens, "veteran" );
AssertEx( !(contains_regular && contains_hardened), "Entity " + entity.classname + " at " + entity.origin + " has a script_difficulty that contains regular AND hardened together when it shouldn't: " + entity.script_difficulty );
AssertEx( !(contains_regular && contains_veteran), "Entity " + entity.classname + " at " + entity.origin + " has a script_difficulty that contains regular AND veteran together when it shouldn't: " + entity.script_difficulty );
AssertEx( !(contains_hardened && contains_veteran), "Entity " + entity.classname + " at " + entity.origin + " has a script_difficulty that contains hardened AND veteran together when it shouldn't: " + entity.script_difficulty );
if ( contains_regular || contains_hardened || contains_veteran )
{
if ( difficulty_string == "regular" && !contains_regular )
{
continue;
}
if ( difficulty_string == "hardened" && !contains_hardened )
{
continue;
}
if ( difficulty_string == "veteran" && !contains_veteran )
{
continue;
}
}
return false;
}
return true;
}

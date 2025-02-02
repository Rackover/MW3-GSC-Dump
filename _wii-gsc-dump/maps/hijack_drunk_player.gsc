#include common_scripts\utility;
#include maps\_utility;
ENDING_MOVE_SPEED = 0.7;
main()
{
flag_init( "force_limp" );
flag_init( "fall" );
flag_init( "collapse" );
flag_init( "collapse_done" );
flag_init( "aftermath_dont_do_wakeup" );
flag_init( "start_doing_aftermath_walk" );
flag_init( "player_heartbeat_sound" );
flag_init( "player_limping" );
flag_init( "stop_being_stunned" );
flag_init( "stop_fade_in_out" );
waittillframeend;
level.player_heartrate = 0.8;
level.player.movespeedscale = 0.7;
}
aftermath_style_walking()
{
waittillframeend;
waittillframeend;
if ( flag( "stop_aftermath_player" ) )
return;
level endon( "stop_aftermath_player" );
level.ground_ref_ent = spawn( "script_model", ( 0, 0, 0 ) );
level.player playerSetGroundReferenceEnt( level.ground_ref_ent );
level childthread slowview();
level notify("slowview");
if ( flag( "aftermath_dont_do_wakeup" ) )
return;
player_wakeup();
}
slowview()
{
while ( true )
{
level waittill( "slowview", wait_time );
if ( isdefined( wait_time ) )
wait( wait_time );
childthread restart_slowview();
}
}
restart_slowview()
{
level endon ( "slowview" );
wait 10;
level notify ( "slowview" );
}
start_player_heartbeat()
{
flag_set("player_heartbeat_sound");
thread player_heartbeat();
}
player_heartbeat()
{
level notify ( "stop_heart" );
level endon ( "stop_heart" );
while ( true )
{
if ( !flag( "fall" ) )
{
if ( isdefined( level.heartbeat_blood_func ) )
{
[[ level.heartbeat_blood_func ]]();
}
if ( flag( "player_heartbeat_sound" ) )
{
wait 0.05;
level.player PlayRumbleOnEntity( "wii_hijack_heartbeat" );
}
wait level.player_heartrate;
}
wait( 0 + randomfloat( 0.1 ) );
if ( randomint( 50 ) > level.player.movespeedscale * 190 )
wait randomfloat( 1 );
}
}
get_player_speed()
{
}
player_fade_in_out()
{
while(!flag("stop_fade_in_out"))
{
maps\hijack_code::fade_out(0.3, RandomFloatRange(0.5,0.8));
wait(RandomFloatRange(0.2,0.35));
maps\hijack_code::fade_in(0.3);
wait(RandomFloatRange(2,5));
}
}
player_wakeup()
{
flag_wait( "start_doing_aftermath_walk" );
thread swivel();
level.player childthread player_random_blur();
}
adjust_angles_to_player( stumble_angles )
{
pa = stumble_angles[ 0 ];
ra = stumble_angles[ 2 ];
rv = anglestoright( level.player.angles );
fv = anglestoforward( level.player.angles );
rva = ( rv[ 0 ], 0, rv[ 1 ] * - 1 );
fva = ( fv[ 0 ], 0, fv[ 1 ] * - 1 );
angles = ( rva* pa );
angles = angles + ( fva* ra );
return angles + ( 0, stumble_angles[ 1 ], 0 );
}
limp()
{
thread limp_thread();
}
adjust_swivel_over_time( ent )
{
level endon( "stop_drunk_walk" );
next_switch = 1;
original_range = 1;
for ( ;; )
{
range = original_range * level.unsteady_scale;
yaw = randomfloatrange( range * 0.5, range );
next_switch--;
if ( next_switch <= 0 )
{
next_switch = randomint( 3 );
yaw *= -1;
}
dif = yaw - ent.origin[0];
dif = abs( dif );
time = dif * 0.05;
if ( time < 0.05 )
time = 0.05;
start_time = gettime();
ent moveto( ( yaw, 0, 0 ), time, time * 0.5, time * 0.5 );
wait time;
wait_for_buffer_time_to_pass( start_time, 0.6 );
for ( ;; )
{
player_speed = distance( (0,0,0), level.player getvelocity() );
if ( player_speed >= 80 )
break;
wait 0.05;
}
}
}
swivel_ends()
{
level waittill( "stop_drunk_walk" );
time = 0.8;
level.ground_ref_ent rotateto( (0,0,0), time, time * 0.5, time * 0.5 );
wait time;
level.ground_ref_ent delete();
level.player playerSetGroundReferenceEnt( undefined );
SetSlowMotion( 0.95, 1, 0.5 );
}
swivel()
{
thread swivel_ends();
level endon( "stop_drunk_walk" );
level.unsteady_scale = 5.0;
pitch_sin = 0;
yaw_sin = 0;
time = 0.1;
for ( ;; )
{
player_speed = distance( (0,0,0), level.player getvelocity() );
pitch_sin += player_speed * 0.026 * level.unsteady_scale;
if (player_speed == 0)
{
pitch_sin += 1.5;
}
else
{
pitch_sin += RandomFloatRange(0,2);
}
yaw_sin += player_speed * 0.01 * level.unsteady_scale;
if (player_speed == 0)
{
yaw_sin += 1.5;
}
else
{
yaw_sin += RandomFloatRange(0,2);
}
if ( cos(pitch_sin) > 0 )
{
pitch_sin += player_speed * 0.1;
}
sin_of_pitch = sin( pitch_sin )-1;
pitch = sin_of_pitch * 1.8 * level.unsteady_scale;
roll = sin( pitch_sin ) * 1.26 * level.unsteady_scale;
yaw = sin( yaw_sin ) * 1.8 * level.unsteady_scale;
if ( !flag( "player_limping" ) )
{
level.ground_ref_ent rotateto( ( pitch , yaw , roll ), time, time * 0.5, time * 0.5 );
}
wait 0.05;
}
}
swivel_stunplayer( stuntime )
{
level notify ( "swivel_stunplayer" );
level endon ( "swivel_stunplayer" );
level.player allowcrouch( false );
level.player allowprone( false );
wait stuntime;
level.player allowcrouch( true );
level.player allowprone( true );
}
SetSlowMotion_overtime()
{
level endon( "stop_drunk_walk" );
timescale = 1;
range = 0.15;
time = 4;
wait 3;
for ( ;; )
{
SetSlowMotion( timescale, 0.89, time );
wait time;
SetSlowMotion( timescale, 1.06, time );
wait time;
}
}
adjust_roll_ent( roll_ent )
{
level endon( "stop_drunk_walk" );
walking_count = 0;
cap = 140;
struct = getstruct( "limp_yaw_ent", "targetname" );
targ = getstruct( struct.target, "targetname" );
angles = vectortoangles( targ.origin - struct.origin );
forward = anglestoforward( angles );
limped = false;
for ( ;; )
{
player_speed = distance( (0,0,0), level.player getvelocity() );
fast_enough = player_speed > 80;
player_angles = level.player getplayerangles();
player_forward = anglestoforward( player_angles );
correct_limp_direction = vectordot( player_forward, forward ) >= 0.8;
if ( fast_enough && correct_limp_direction )
walking_count += 2;
else
walking_count -= 1;
walking_count = clamp( walking_count, 0, cap );
if ( walking_count < cap )
{
wait 0.05;
continue;
}
walking_count = 0;
if ( !limped )
{
limped = true;
limp();
time = 2;
ent = spawn_tag_origin();
ent.origin = ( level.unsteady_scale, 0, 0 );
ent moveto( (1,0,0), time, time * 0.5, time * 0.5 );
for ( ;; )
{
level.unsteady_scale = ent.origin[0];
if ( level.unsteady_scale == 1 )
break;
wait 0.05;
}
ent delete();
return;
}
cap = randomintrange( 70, 125 );
time = 0.45;
roll = randomfloatrange( -16, -11 );
roll_ent moveto( (roll,0,0), time, 0, time );
wait time;
time *= 0.8;
offset = randomfloatrange( -2, 2 );
roll_ent moveto( (offset,0,0), time, time * 0.5, time * 0.5 );
wait time;
}
}
limp_thread()
{
level notify ( "kill_limp" );
level endon ( "kill_limp" );
while ( true )
{
player_speed = distance( (0,0,0), level.player getvelocity() );
if ( player_speed < 80 )
{
wait 0.05;
continue;
}
stun_time = 2.3;
level.player thread swivel_stunplayer( stun_time );
level notify ( "not_random_blur" );
noself_delayCall( .5, ::setblur, 4, .25 );
noself_delayCall( 1.2, ::setblur, 0, 1 );
delaythread( stun_time, ::player_random_blur );
level.player PlayRumbleOnEntity( "wii_hijack_heartbeat" );
level.player blend_movespeedscale( 0.35, 0.3 );
level.player delaythread( stun_time * 0.5, ::blend_movespeedscale, ENDING_MOVE_SPEED, stun_time );
flag_clear( "force_limp" );
wait stun_time;
break;
}
}
limp_old()
{
stumble = 0;
alt = 0;
while ( true )
{
timer = randomfloatrange( 2, 4 );
wait timer;
velocity = level.player getvelocity();
player_speed = abs( velocity [ 0 ] ) + abs( velocity[ 1 ] );
if ( player_speed < 10 && !flag( "force_limp" ) )
{
wait 0.05;
continue;
}
speed_multiplier = player_speed / ( level.player.movespeedscale * 190 );
p = randomfloatrange( 3, 5 );
if ( randomint( 100 ) < 20 )
p *= 1.5;
stumble_time = randomfloatrange( 0.35, 0.45 );
recover_time = randomfloatrange( 0.65, 0.8 );
if ( flag( "force_limp" ) )
{
flag_clear( "force_limp" );
speed_multiplier = 0.35;
p *= 3;
stumble_time = randomfloatrange( 0.7, 0.85 );
recover_time = randomfloatrange( 1.65, 1.8 );
}
r = randomfloatrange( 3, 7 );
y = randomfloatrange( -8, -2 );
stumble_angles = ( p, y, r );
stumble_angles = ( stumble_angles * speed_multiplier );
stumble++ ;
if ( speed_multiplier > 1.3 )
stumble++ ;
flag_set( "player_limping" );
childthread stumble( stumble_angles, stumble_time, recover_time );
level waittill_either( "recovered", "force_limp" );
flag_clear( "player_limping" );
}
}
end_random_blur()
{
level waittill("not_random_blur");
setblur( 0, .1 );
}
player_random_blur()
{
thread end_random_blur();
level endon( "dying" );
level endon ( "not_random_blur" );
while ( true )
{
wait 0.05;
if ( randomint( 100 ) > 10 )
continue;
blur = randomint( 5 ) + 2;
blur_time = randomfloatrange( 0.3, 0.9 );
recovery_time = randomfloatrange( 0.3, 1 );
setblur( blur * 1.2, blur_time );
wait blur_time;
setblur( 0, recovery_time );
wait 5;
}
}
player_jump_punishment()
{
wait( 2 );
for ( ;; )
{
if ( level.player isonground() )
break;
wait( 0.05 );
}
while ( true )
{
wait 0.05;
if ( level.player isonground() )
continue;
wait 0.2;
if ( level.player isonground() )
continue;
level notify( "stop_stumble" );
wait 0.2;
}
}
stumble( stumble_angles, stumble_time, recover_time, no_notify )
{
level endon( "stop_stumble" );
if ( flag( "collapse" ) )
return;
stumble_angles = adjust_angles_to_player( stumble_angles );
level.ground_ref_ent rotateto( stumble_angles, stumble_time, ( stumble_time / 4 * 3 ), ( stumble_time / 4 ) );
level.ground_ref_ent waittill( "rotatedone" );
base_angles = ( randomfloat( 4 ) - 4, randomfloat( 5 ), 0 );
base_angles = adjust_angles_to_player( base_angles );
level.ground_ref_ent rotateto( base_angles, recover_time, 0, recover_time / 2 );
level.ground_ref_ent waittill( "rotatedone" );
if ( !isdefined( no_notify ) )
level notify( "recovered" );
}
recover()
{
angles = adjust_angles_to_player( ( -5, -5, 0 ) );
level.ground_ref_ent rotateto( angles, .6, 0.6, 0 );
level.ground_ref_ent waittill( "rotatedone" );
angles = adjust_angles_to_player( ( -15, -20, 0 ) );
level.ground_ref_ent rotateto( angles, 2.5, 0, 2.5 );
level.ground_ref_ent waittill( "rotatedone" );
angles = adjust_angles_to_player( ( 5, 5, 0 ) );
level.ground_ref_ent rotateto( angles, 2.5, 2, 0.5 );
level.ground_ref_ent waittill( "rotatedone" );
level.ground_ref_ent rotateto( ( 0, 0, 0 ), 1, 0.2, 0.8 );
}
hud_hide( state )
{
wait 0.1;
SetSavedDvar( "hud_showStance", 0 );
SetSavedDvar( "compass", "0" );
SetSavedDvar( "ammoCounterHide", "1" );
}


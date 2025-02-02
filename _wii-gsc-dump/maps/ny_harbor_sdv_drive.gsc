#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\jake_tools;
#include maps\_shg_common;
#include maps\_gameevents;
CONST_IPSTOMPH = 0.0568;
main()
{
assert( isDefined( level.player_sdv ) );
assert( isDefined( level.water_z ) );
vehicle_scripts\_submarine_sdv::main( "vehicle_blackshadow_730", undefined, "script_vehicle_blackshadow", true );
level.player_sdv thread setup_player_usable_vehicle();
Sonar_Init();
}
player_enter_submarine( submarine, pilot, blend )
{
if (!isdefined(blend))
blend = false;
if (!blend)
{
origin = submarine getTagOrigin("TAG_PLAYER");
angles = submarine getTagAngles("TAG_PLAYER");
pilot SetOrigin( origin );
pilot SetPlayerAngles( angles );
}
pilot.ignoreme = true;
pilot.in_sdv = true;
submarine.pilot = pilot;
submarine.playercontrolled = true;
thread player_becomes_pilot_model( submarine, blend );
submarine thread mine_gauntlet();
thread mine_death_quote();
thread mine_death_collision();
thread setup_contact_mines();
SetSavedDvar("vehcam_offset","-4 0 0");
submarine useby( pilot );
submarine notify( "nodeath_thread" );
submarine notify( "no_regen_health" );
submarine notify( "stop_turret_shoot" );
submarine notify( "stop_friendlyfire_shield" );
submarine notify( "stop_vehicle_wait" );
submarine thread setSubmarineHealth();
submarine thread friendly_bubbles();
self thread track_sub_position();
setsaveddvar("phys_gravity","0");
}
mine_gauntlet()
{
level endon( "submine_planted" );
flag_wait( "player_sdv_moving" );
level.explosion_delay = 2;
self childthread mine_2();
self childthread mine_3();
self childthread mine_5();
}
mine_1()
{
flag_wait( "mine_1" );
explosion = getent( "mine_1", "targetname" );
self thread determine_player_mine_pos( explosion );
}
mine_2()
{
flag_wait( "mine_2" );
explosion = getent( "mine_2", "targetname" );
self thread determine_player_mine_pos( explosion );
}
mine_3()
{
flag_wait( "mine_3" );
explosion = getent( "mine_3", "targetname" );
self thread determine_player_mine_pos( explosion );
}
mine_4()
{
flag_wait( "mine_4" );
explosion = getent( "mine_4", "targetname" );
self thread determine_player_mine_pos( explosion );
}
mine_5()
{
flag_wait( "mine_5" );
explosion = getent( "mine_5", "targetname" );
self thread determine_player_mine_pos( explosion );
}
determine_player_mine_pos( explosion )
{
org = explosion.origin - level.player.origin;
player_forward = AnglesToForward( level.player.angles );
player_right = AnglesToRight( level.player.angles );
exp_vector = VectorNormalize( org );
dot = VectorDot( exp_vector, player_right );
if( dot > 0 )
{
fx = "panel_flash_left";
}
else
{
fx = "panel_flash_right";
}
wait( level.explosion_delay );
wait( 3 );
}
dcs_explosion( fx, explosion )
{
PlayFxOnTag( getfx( fx ), self, "TAG_PANEL" );
wait( level.explosion_delay );
StopFxOnTag( getfx( fx ), self, "TAG_PANEL" );
dummy = spawn_tag_origin();
dummy.origin = explosion.origin;
PlayFxOnTag( getfx( "depth_charge_explosion" ), dummy, "tag_origin" );
wait( 3 );
dummy delete();
}
sub_panel_fx_failsafe( fx )
{
self endon( "panel_fx_off" );
level waittill( "russian_sub_event" );
StopFXOnTag( getfx( fx ), self, "TAG_PANEL" );
}
setup_contact_mines()
{
mines = getentarray( "underwater_mines", "script_noteworthy" );
foreach( mine in mines )
{
dummy = spawn_tag_origin();
dummy.origin = mine.origin;
dummy linkto( mine, "", ( 0, 0, 600 ), ( 0, 0, 0 ) );
dummy thread monitor_dummy_for_delete();
mine thread monitor_mine_detonation( dummy );
PlayFxOnTag( getfx( "light_strobe_undrwtr_mine" ), dummy, "tag_origin" );
}
}
monitor_mine_detonation( dummy )
{
level endon( "mine_detonated" );
level endon( "russian_sub_event" );
level endon( "submine_planted" );
detonation_range = 120;
while( true )
{
dist = Distance( level.player.origin, dummy.origin );
if( dist <= detonation_range )
{
dummy hide();
PlayFxOnTag( getfx( "depth_charge_explosion" ), dummy, "tag_origin" );
aud_send_msg("aud_mine_explosion", dummy.origin);
wait 0.2;
level.player kill();
level notify( "mine_detonated" );
}
wait( 0.05 );
}
}
monitor_dummy_for_delete()
{
level waittill_any( "mine_detonated", "russian_sub_event", "submine_planted" );
self delete();
}
mine_death_quote()
{
level endon( "start_submarine02" );
level.player waittill( "death" );
level notify( "new_quote_string" );
SetDvar( "ui_deadquote", &"NY_HARBOR_MINE_DEATH" );
}
mine_death_collision()
{
level endon( "start_submarine02" );
level.player waittill( "death" );
base_origin = level.player.origin;
coll = getent( "diver_death_collision", "targetname");
coll Hide();
coll.origin = base_origin + (0,0,-24);
}
player_exit_submarine( submarine, dontActivate )
{
if ( isdefined( level.player.in_sdv ) && level.player.in_sdv )
{
submarine useby( level.player );
SetSavedDvar("vehcam_offset","0 0 0");
level.player.ignoreme = false;
submarine.playercontrolled = false;
level.player.in_sdv = false;
if (!isdefined(dontActivate) || !dontActivate)
{
level.player EnableWeapons();
level.player AllowCrouch( true );
level.player AllowProne( true );
level.player AllowSprint( true );
level.player AllowJump( true );
}
setsaveddvar("phys_gravity","-800.");
}
}
sdv_section_finished()
{
level notify( "sdv_done" );
level.player_sdv notify( "sdv_done" );
}
friendly_bubbles()
{
self endon( "death" );
self endon( "sdv_done" );
self notify( "stop_friendly_bubbles" );
self endon( "stop_friendly_bubbles" );
level endon("player_above_water");
self thread maps\_underwater::friendly_bubbles_cleanup();
tag = "TAG_PLAYER";
while ( true )
{
wait( 9.0 + randomfloat( 3 ) );
aud_send_msg("sdv_scuba_bubbles");
playfxOnTag( getfx( "scuba_bubbles_breath_player" ), self, tag );
}
}
npc_bubbles()
{
self endon( "sdv_done" );
self endon( "player_surfaces" );
self endon( "death" );
self notify( "stop_friendly_bubbles" );
self endon( "stop_friendly_bubbles" );
self thread maps\_underwater::friendly_bubbles_cleanup();
tag = "TAG_EYE";
while ( true )
{
wait( 6.5 + randomfloat( 3 ) );
playfxOnTag( getfx( "scuba_bubbles_NPC" ), self, tag );
}
}
setup_player_usable_vehicle()
{
assert( isdefined( self ) );
if ( isdefined( self.target ) )
{
self.trigger = getent( self.target, "targetname" );
assert( isdefined( self.trigger ) );
}
self.script_targetoffset_z = -100;
self makeUnusable();
}
anim_loop_linked( guys, anime, ender, tag )
{
assert( isdefined( tag ) );
foreach( guy in guys )
{
guy linkto( self, tag );
}
anim_loop( guys, anime, ender, tag );
}
#using_animtree( "vehicles" );
player_becomes_pilot_model( submarine, blend )
{
if (!isdefined(blend))
blend = false;
if ( submarine.vehicletype != "blackshadow_730" )
return;
assert( isdefined( submarine.pilot ) );
if (!isdefined(level.sdv_player_arms))
{
level.sdv_player_arms = spawn_anim_model( "player_sdv_rig" );
level.sdv_player_arms.animname = "player_sdv_rig";
}
if (!blend)
{
level.sdv_player_arms.origin = submarine.pilot.origin;
level.sdv_player_arms.angles = submarine.pilot.angles;
submarine.pilot PlayerLinkToDelta( level.sdv_player_arms, "tag_player", 1.0, 20, 20, 30, 20, true );
}
else
{
submarine.pilot PlayerLinkToBlend( level.sdv_player_arms, "tag_player", 0.5, 0.2, 0.2 );
submarine.pilot PlayerLinkToDelta( level.sdv_player_arms, "tag_player", 1.0, 20, 20, 30, 20, true );
}
guys = [];
guys[0] = level.sdv_player_arms;
submarine thread anim_loop_linked( guys, "sdv_idle", "stop_loop", "TAG_PLAYER" );
}
setSubmarineHealth()
{
assert( isdefined( self.pilot ) );
self.health = 100;
self.currenthealth = 100;
self.maxhealth = 100;
}
get_index_in_array( node, nodes )
{
foreach( i, nod in nodes )
{
if ( nod == node )
return i;
}
return -1;
}
find_bracketing_nodes( nodes, pos, curnode )
{
ret = spawnstruct();
if ( isdefined( curnode ) )
index = get_index_in_array( curnode, nodes );
else
index = get_closest_index( pos, nodes );
if ( index == 0 )
{
ret.first = nodes[index];
index++;
assert( nodes.size > index );
ret.second = nodes[index];
}
else if ( index == (nodes.size - 1) )
{
ret.second = nodes[index];
index--;
assert( index >= 0 );
ret.first = nodes[index];
}
else
{
nxtOrg = nodes[index + 1].origin;
org = nodes[index].origin;
dir = nxtOrg - org;
delta = pos - org;
dot = vectordot( dir, delta );
if ( dot > 0 )
{
ret.first = nodes[index];
ret.second = nodes[index + 1];
}
else
{
ret.first = nodes[index - 1];
ret.second = nodes[index];
}
}
return ret;
}
get_3d_progression_between_points( start, first_point, second_point )
{
prog =[];
angles = vectortoangles( second_point - first_point );
forward = anglestoforward( angles );
end = first_point;
difference = vectornormalize( end - start );
dot = vectordot( forward, difference );
normal = vectorNormalize( second_point - first_point );
vec = start - first_point;
progress = vectorDot( vec, normal );
offset_org = first_point + forward * progress;
prog["pos_on_spline"] = offset_org;
prog["progress"] = progress;
baselen = distance( second_point, first_point );
prog["offset"] = distance( offset_org, start );
if ( baselen > 0 )
prog["percent"] = prog["offset"] / baselen;
else
prog["percent"] = 0;
right = anglestoright( angles );
up = anglestoup( angles );
difference = start - offset_org;
prog["right"] = vectordot( right, difference );
prog["up"] = vectordot( up, difference );
return prog;
}
depth_charge( pos, angles )
{
dummy = spawn_tag_origin();
dummy.origin = pos;
dummy.angles = angles;
PlayFXOnTag( getfx( "depth_charge_explosion" ), dummy, "tag_origin" );
Earthquake( 1, 1, pos, 1000 );
dummy PlaySound( "scn_nyhb_jet_water_crash" );
wait 2;
dummy delete();
}
track_sub_position()
{
thread update_sdv_collision();
if (!isdefined(level.sdv_path))
return;
self endon( "sdv_done" );
level endon("sdv_ride_done");
level endon("sdv_done_leading");
while ( !flag( "lead_sdv_reached_end" ) )
{
wait 0.05;
pos = level.player_sdv.origin;
pair = find_bracketing_nodes( level.sdv_path, pos, level.lead_sdv.currentNode );
first = pair.first.origin;
second = pair.second.origin;
info = get_3d_progression_between_points( pos, first, second );
level.player_sdv_pos_on_spline = info["pos_on_spline"];
}
}
get_body_origin()
{
origin = self GetTagOrigin( "J_SpineLower" );
if ( !isdefined( origin ) )
origin = self.origin;
return origin;
}
find_closest_point_of_box( center, ent, bounds )
{
origin = ent get_body_origin();
angles = ent getTagAngles( "J_SpineLower" );
axis =[];
axis[0] = anglestoforward( angles );
axis[1] = anglestoright( angles );
axis[2] = anglestoup( angles );
closestpoint = origin;
closestdist = 100000;
forcedir = (0, 0, 0);
for ( axis_i = 0; axis_i < 3; axis_i++ )
{
for ( side = 0; side < 2; side++ )
{
normal = axis[axis_i];
d = vectordot( normal, origin ) + bounds[axis_i][side];
center_to_plane = vectordot( normal, center ) - d;
point_on_plane = center - (center_to_plane * normal);
origin_on_plane = origin + (bounds[axis_i][side] * normal);
origin_to_point_on_plane = point_on_plane - origin_on_plane;
axis_i_1 = axis_i + 1;
if ( axis_i_1 > 2 )
axis_i_1 -= 3;
dist_1 = vectordot( axis[axis_i_1], origin_to_point_on_plane );
if ( dist_1 < bounds[axis_i_1][0] )
dist_1 = bounds[axis_i_1][0];
if ( dist_1 > bounds[axis_i_1][1] )
dist_1 = bounds[axis_i_1][1];
axis_i_2 = axis_i + 2;
if ( axis_i_2 > 2 )
axis_i_2 -= 3;
dist_2 = vectordot( axis[axis_i_2], origin_to_point_on_plane );
if ( dist_2 < bounds[axis_i_2][0] )
dist_2 = bounds[axis_i_2][0];
if ( dist_2 > bounds[axis_i_2][1] )
dist_2 = bounds[axis_i_2][1];
point_on_plane = origin_on_plane + (dist_1 * axis[axis_i_1]) + (dist_2 * axis[axis_i_2]);
dist = distance( center, point_on_plane );
if ( dist < closestdist )
{
closestpoint = point_on_plane;
closestdist = dist;
if ( side == 0 )
forcedir = axis[axis_i];
else
forcedir = -1 * axis[axis_i];
}
}
}
retval =[];
retval["point"] = closestpoint;
retval["forcedir"] = forcedir;
return retval;
}
FindClosestSegmentBtnLines( p0, dp, q0, dq )
{
w0 = p0 - q0;
a = VectorDot( dp, dp );
b = VectorDot( dp, dq );
c = VectorDot( dq, dq );
d = VectorDot( dp, w0 );
e = VectorDot( dq, w0 );
den = (a*c) - (b*b);
if (den > 0)
{
s = ((b*e) - (c*d)) / den;
t = ((a*e) - (b*d)) / den;
p = p0 + (s*dp);
q = q0 + (t*dq);
seg[0] = p;
seg[1] = q;
return seg;
}
else
{
p = p0;
t = d/b;
q = q0 + (t*dq);
seg[0] = p;
seg[1] = q;
return seg;
}
}
CalculateAngularRotation( body, impulsepoint, impulsedirection, speed )
{
origin = body get_body_origin();
angles = body getTagAngles( "J_SpineLower" );
axis =[];
axis[0] = anglestoforward( angles );
axis[1] = anglestoright( angles );
axis[2] = anglestoup( angles );
Inertia[0] = 10.0;
Inertia[1] = 3.0;
Inertia[2] = 3.0;
angvel[0] = 0;
angvel[1] = 0;
angvel[2] = 0;
for (i=0; i<3; i++)
{
seg = FindClosestSegmentBtnLines( origin, axis[i], impulsepoint, impulsedirection );
dist = distance( seg[0], seg[1] );
segdir = seg[1] - seg[0];
rotvec = VectorCross(segdir, impulsedirection);
dp = VectorDot( rotvec, axis[i] );
if (dp > 0)
dist = 0-dist;
angvel[i] = dist * Inertia[i];
}
angv = (angvel[1],angvel[2],angvel[0]);
angvw = angv;
return angvw;
}
FakeImpulse( body, impulsepoint, from, radius, impulsedirection, speed, awayaxis )
{
center = body get_body_origin();
from_to_center = center - from;
dist_on_awayaxis = vectordot( awayaxis, from_to_center );
point_on_axis = from + (dist_on_awayaxis * awayaxis);
dir = center - point_on_axis;
curdist = distance( from, impulsepoint );
delta = radius - curdist;
if ( delta < 6 )
delta = 6;
delta += 48 + (speed);
time = 2.0 - (speed * .1);
if ( time < .5 )
time = .5;
dir = vectornormalize( dir );
origin = body.origin;
newpos = origin + (delta * dir);
body.tag_origin moveto( newpos, time, 0.05, time - .1 );
angles = CalculateAngularRotation( body, impulsepoint, impulsedirection, speed );
body.tag_origin rotateVelocity( angles, time, 0.05, time - .1 );
}
update_sdv_collision()
{
self endon( "sdv_done" );
level endon("sdv_ride_done");
level.player_sdv thread update_sub_dyn_coll();
array = getentarray( "physics", "targetname" );
if (isdefined(level._physics_dead_bodies))
level._physics_dead_bodies = array_combine( level._physics_dead_bodies, array);
else
level._physics_dead_bodies = array;
outerradius = 120;
outerradiussquared = outerradius * outerradius;
radius = 40;
radiussquared = radius * radius;
bounds =[];
bounds[0] =[];
bounds[0][0] = -36;
bounds[0][1] = 36;
bounds[1] =[];
bounds[1][0] = -18;
bounds[1][1] = 18;
bounds[2] =[];
bounds[2][0] = -18;
bounds[2][1] = 18;
sdvs[0] = level.player_sdv;
sdvs[1] = level.lead_sdv;
sdvs[2] = level.grinch_sdv;
while ( true )
{
origins = [];
forwards = [];
foreach (idx, sdv in sdvs)
{
origins[idx] = sdvs[idx].origin;
forwards[idx] = anglestoforward( sdvs[idx].angles );
origins[idx] += 80 * forwards[idx];
}
foreach( body in level._physics_dead_bodies )
{
if (!isdefined(body))
continue;
if ( isdefined( body.waittime ) && (body.waittime > 0) )
{
body.waittime = body.waittime - 0.1;
continue;
}
body_origin = body get_body_origin();
foreach (idx, origin in origins)
{
distsquared = distancesquared( body_origin, origin );
if ( distsquared < outerradiussquared )
{
retval = find_closest_point_of_box( origin, body, bounds );
point = retval["point"];
distsquared = distancesquared( point, origin );
if ( distsquared < radiussquared )
{
body.waittime = 1.0;
FakeImpulse( body, point, origin, radius, retval["forcedir"], level.player_sdv.veh_speed, forwards[idx] );
}
}
}
}
wait 0.1;
}
}
update_sub_dyn_coll()
{
self endon( "sdv_done" );
level endon("sdv_ride_done");
while ( true )
{
origin = self.origin;
forward = anglestoforward( self.angles );
start = origin + (20 * forward);
PhysicsExplosionSphere(start, 15, 5, 1.0);
wait 0.1;
}
}
MAX_SONAR_DIST = 120*12;
RE_PING_TIME = 1000;
RE_PING_TIME_MIN = 500;
RE_PING_GROUP_TIME = 500;
HandleSonarTargetDeath()
{
self endon("sonar_cleaned");
self waittill( "death" );
RemoveSonarTarget(self);
}
HandleSonarSubDeath()
{
self waittill( "death" );
foreach (target in self.targets)
{
RemoveSonarTarget( target );
}
level.sonar_data.groups = array_remove(level.sonar_data.groups,self);
self.targets = undefined;
}
ChangeSonarSubTarget( tgtsub, orgsub)
{
tgtsub.targets = orgsub.targets;
orgsub.targets = undefined;
tgtsub.sonar_nexttime = orgsub.sonar_nexttime;
foreach (target in tgtsub.targets)
{
target.sonar_group = tgtsub;
}
foreach (i, group in level.sonar_data.groups)
{
if (group == orgsub)
{
level.sonar_data.groups[i] = tgtsub;
break;
}
}
}
AddSonarSubTarget( sub )
{
forward = AnglesToForward(sub.angles);
origin = sub.origin;
startx = -2928;
endx = 3068;
deltax = 12*7;
sub.targets = [];
sub.sonar_nexttime = 0;
while (startx <= endx)
{
tgt = spawnstruct();
tgt.classname = "struct";
tgt.offset = (startx,0,0);
tgt.linked_ent = sub;
tgt.linked_tag = "body";
sub.targets[sub.targets.size] = tgt;
tgt.sonar_group = sub;
AddSonarTarget( tgt, 2 );
startx += deltax;
}
level.sonar_data.groups[level.sonar_data.groups.size] = sub;
}
AddSonarTarget( target, type )
{
assert( isdefined(level.sonar_data) );
target.sonar_still_active = 0;
target.sonar_active = 0;
target.sonar_nexttime = 0;
target.sonar_type = type;
switch(type)
{
case 0:
target.sonar_effect = getfx("friend_ping");
break;
case 1:
target.sonar_effect = undefined;
target.sonar_effects[0] = getfx("mine_ping_scale1");
target.sonar_effect_dists[0] = 0.8;
target.sonar_effects[1] = getfx("mine_ping_scale2");
target.sonar_effect_dists[1] = 0.6;
target.sonar_effects[2] = getfx("mine_ping_scale3");
target.sonar_effect_dists[2] = 0.4;
target.sonar_effects[3] = getfx("mine_ping_scale4");
target.sonar_effect_dists[3] = -0.1;
break;
case 2:
target.sonar_effect = getfx("sub_ping");
break;
default:
assert(0);
break;
}
level.sonar_data.targets[level.sonar_data.targets.size] = target;
if (target.classname != "struct")
target thread HandleSonarTargetDeath();
}
CleanupSonarTarget( target )
{
assert( isdefined(target.sonar_active) );
if (target.sonar_active > 1)
{
if (isdefined(target.sonar_effect) && isdefined(target.sonar_fx))
{
StopFXOnTag( target.sonar_effect, target.sonar_fx, "tag_origin" );
FreeSonarFX(target.sonar_fx);
target.sonar_fx = undefined;
}
}
}
RemoveSonarTarget( target )
{
CleanupSonarTarget( target );
level.sonar_data.targets = array_remove( level.sonar_data.targets, target );
}
ClearSonar()
{
foreach (ent in level.sonar_data.targets)
{
if ( isdefined(ent.sonar_fx) )
{
ent.sonar_active = 0;
StopFXOnTag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
FreeSonarFX(ent.sonar_fx);
ent.sonar_fx = undefined;
}
}
}
ChangeSonarEntity( ent )
{
assert( isdefined(level.sonar_data) );
level.sonar_data.sdv = ent;
Sonar_link_LRSignal( level.sonar_data );
}
ControlSonar( bEnable )
{
assert( isdefined(level.sonar_data) );
level.sonar_data.enable = bEnable;
}
NewSonarFX()
{
if (isdefined(level.sonar_data.free_tag_origins))
{
tag_origin = level.sonar_data.free_tag_origins;
level.sonar_data.free_tag_origins = tag_origin.next;
tag_origin.next = undefined;
return tag_origin;
}
tag_origin = spawn_tag_origin();
tag_origin.origin = level.sonar_data.sdv GetTagOrigin("tag_motion_tracker_fx");
tag_origin.angles = level.sonar_data.sdv GetTagAngles("tag_motion_tracker_fx");
tag_origin linkto( level.sonar_data.sdv, "tag_motion_tracker_fx" );
level.sonar_data.tag_origin_count++;
return tag_origin;
}
FreeSonarFX( tag_origin )
{
assert(!isdefined(tag_origin.next));
tag_origin.next = level.sonar_data.free_tag_origins;
level.sonar_data.free_tag_origins = tag_origin;
}
DisplayPing( ent, forward, right, toent )
{
data = level.sonar_data;
sdv = data.sdv;
x = VectorDot(toent, right)/MAX_SONAR_DIST;
y = VectorDot(toent, forward)/MAX_SONAR_DIST;
if ((x < data.minx) || (data.maxx < x) ||
(y < data.miny) || (data.maxy < y))
return;
dist = Length(toent)/MAX_SONAR_DIST;
if ((ent.sonar_type == 1) && (data.closest_dist > dist))
data.closest_dist = dist;
if (ent.sonar_type == 1)
{
if (x>0)
data.sonar_left = true;
else
data.sonar_right = true;
}
x *= data.width;
y *= data.height;
sonar_pos = data.start + x*data.xdir + y*data.ydir;
if (!isdefined(ent.sonar_fx))
{
ent.sonar_fx = NewSonarFX();
}
ent.sonar_fx unlink();
ent.sonar_fx.origin = sonar_pos;
ent.sonar_fx linkto( sdv, "tag_motion_tracker_fx" );
ent.sonar_still_active = data.sonar_count;
if (ent.sonar_active == 0)
{
ent.sonar_active++;
return;
}
trigger = false;
if (isdefined(ent.sonar_group))
{
trigger = (ent.sonar_group.sonar_nexttime < gettime());
}
else
{
trigger = ((ent.sonar_active == 1) || (ent.sonar_nexttime < gettime()) || isdefined(ent.sonar_effects));
}
if ( trigger )
{
if (isdefined(ent.sonar_effects))
{
if ((ent.sonar_active > 1) && (ent.sonar_nexttime < gettime()))
{
StopFXOnTag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
}
fxchange = false;
fx = undefined;
foreach (i,testdist in ent.sonar_effect_dists)
{
if (testdist < dist)
{
fx = ent.sonar_effects[i];
if (isdefined(ent.sonar_effect) && (fx != ent.sonar_effect))
{
StopFXOnTag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
fxchange = true;
}
break;
}
}
if (fxchange || !isdefined(ent.sonar_effect))
{
ent.sonar_effect = fx;
ent.sonar_active = 2;
playfxontag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
ping_time = RE_PING_TIME_MIN + dist*(RE_PING_TIME-RE_PING_TIME_MIN);
ent.sonar_nexttime = gettime() + ping_time;
}
}
else
{
if (ent.sonar_active == 2)
StopFXOnTag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
ent.sonar_active = 2;
playfxontag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
ent.sonar_nexttime = gettime() + RE_PING_TIME;
}
}
}
UpdatePing( ent, sonar_count )
{
if (ent.sonar_still_active < sonar_count)
{
if (ent.sonar_active == 2)
{
stopfxontag( ent.sonar_effect, ent.sonar_fx, "tag_origin" );
if (isdefined(ent.sonar_effects))
ent.sonar_effect = undefined;
FreeSonarFX(ent.sonar_fx);
ent.sonar_fx = undefined;
}
ent.sonar_active = 0;
}
}
PrepSonarGroup( group )
{
group.forward = AnglesToForward(group.angles);
foreach (target in group.targets)
{
assert(target.classname == "struct");
assert(group == target.sonar_group);
origin = group.origin + target.offset[0]*group.forward;
target.origin = origin;
}
}
UpdateSonarGroup( group, time )
{
if ( group.sonar_nexttime < time )
group.sonar_nexttime = time + RE_PING_GROUP_TIME;
}
UpdateSonarHUD( data )
{
if ((data.sonar_prv_left != data.sonar_left) ||
(data.sonar_left && (data.sonar_left_time < gettime())))
{
fx = getfx("sonar_mine_ping_scrn_left");
if ((data.sonar_prv_left == data.sonar_left) || !data.sonar_left)
StopFXOnTag( fx, data.sonar_left_fx, "tag_origin" );
if (data.sonar_left)
{
playfxontag( fx, data.sonar_left_fx, "tag_origin" );
data.sonar_left_time = gettime() + 1000;
aud_send_msg("sonar_ping_hud");
}
}
if ((data.sonar_prv_right != data.sonar_right) ||
(data.sonar_right && (data.sonar_right_time < gettime())))
{
fx = getfx("sonar_mine_ping_scrn_right");
if ((data.sonar_prv_right == data.sonar_right) || !data.sonar_right)
StopFXOnTag( fx, data.sonar_right_fx, "tag_origin" );
if (data.sonar_right)
{
playfxontag( fx, data.sonar_right_fx, "tag_origin" );
data.sonar_right_time = gettime() + 1000;
aud_send_msg("sonar_ping_hud");
}
}
}
Sonar_Init()
{
level.sonar_data = SpawnStruct();
data = level.sonar_data;
data.minx = -1.0;
data.maxx = 1.0;
data.miny = -0.1;
data.maxy = 1.0;
data.width = 1.0;
data.height = 1.0;
data.sonar_count = 0;
data.sonar_left = false;
data.sonar_right = false;
data.sonar_prv_left = data.sonar_left;
data.sonar_prv_right = data.sonar_right;
data.sonar_left_time = 0;
data.sonar_right_time = 0;
data.closest_dist = 2.0;
data.tag_origin_count = 0;
data.enabled = true;
data.targets = [];
data.groups = [];
}
SONAR_LR_UP = -0.8;
SONAR_LR_RIGHT = 0.8;
SONAR_LR_FORWARD = 0.25;
Sonar_link_LRSignal( data )
{
data.ul = data.sdv GetTagOrigin("tag_screen_tl");
angles = data.sdv GetTagAngles("tag_screen_tl");
up = AnglesToUp(angles);
right = AnglesToRight(angles);
forward = AnglesToForward(angles);
origin = data.ul + (SONAR_LR_UP * up) - (SONAR_LR_RIGHT * right) + (SONAR_LR_FORWARD*forward);
data.sonar_left_fx.origin = origin;
data.sonar_left_fx.angles = angles;
data.sonar_left_fx linkto(data.sdv,"tag_screen_tl");
data.ur = data.sdv GetTagOrigin("tag_screen_tr");
angles = data.sdv GetTagAngles("tag_screen_tr");
up = AnglesToUp(angles);
right = AnglesToRight(angles);
forward = AnglesToForward(angles);
origin = data.ur + (SONAR_LR_UP * up) + (SONAR_LR_RIGHT * right) + (SONAR_LR_FORWARD*forward);
data.sonar_right_fx.origin = origin;
data.sonar_right_fx.angles = angles;
data.sonar_right_fx linkto(data.sdv,"tag_screen_tr");
}
Sonar_Init_LRSignal( data )
{
data.sonar_left_fx = spawn_tag_origin();
data.sonar_right_fx = spawn_tag_origin();
Sonar_link_LRSignal( data );
}
Sonar_Cleanup()
{
level waittill("player_through_water");
data = level.sonar_data;
foreach (target in data.targets)
{
CleanupSonarTarget( target );
target notify("sonar_cleaned");
}
foreach (group in data.groups)
{
foreach (target in group.targets)
{
CleanupSonarTarget( target );
target notify("sonar_cleaned");
if (target.classname != "struct")
target Delete();
}
group.targets = undefined;
}
while (isdefined(data.free_tag_origins))
{
tag_origin = data.free_tag_origins;
data.free_tag_origins = tag_origin.next;
tag_origin Delete();
}
if (data.sonar_right)
{
fx = getfx("sonar_mine_ping_scrn_right");
StopFXOnTag( fx, data.sonar_right_fx, "tag_origin" );
}
data.sonar_right_fx Delete();
if (data.sonar_left)
{
fx = getfx("sonar_mine_ping_scrn_left");
StopFXOnTag( fx, data.sonar_left_fx, "tag_origin" );
}
data.sonar_left_fx Delete();
wait 0.05;
level.sonar_data = undefined;
}
Sonar_Process()
{
level endon("player_through_water");
mines = getentarray("underwater_mines","script_noteworthy");
data = level.sonar_data;
data.sdv = self;
Sonar_Init_LRSignal( data );
ControlSonar(true);
foreach (mine in mines)
{
AddSonarTarget( mine, 1 );
}
foreach (sdv in level.sdvarray)
{
if (sdv == self)
continue;
AddSonarTarget( sdv, 0 );
}
thread Sonar_Cleanup();
while (true)
{
data.sonar_count++;
data.sonar_prv_left = data.sonar_left;
data.sonar_prv_right = data.sonar_right;
data.sonar_left = false;
data.sonar_right = false;
foreach (group in data.groups)
{
PrepSonarGroup( group );
}
if (data.enabled)
{
sdv = level.sonar_data.sdv;
data.ul = sdv GetTagOrigin("tag_screen_tl");
data.ur = sdv GetTagOrigin("tag_screen_tr");
data.bl = sdv GetTagOrigin("tag_screen_bl");
data.br = sdv GetTagOrigin("tag_screen_br");
data.ref_tag = sdv GetTagOrigin("tag_motion_tracker_fx");
data.start = 0.5*(data.bl + data.br);
data.ydir = 0.5*(data.ul + data.ur) - data.start;
data.xdir = data.bl - data.start;
data.closest_dist = 2.0;
angles = sdv.angles;
origin = sdv.origin;
forward = AnglesToForward( angles );
forward = VectorNormalize((forward[0], forward[1], 0));
up = (0, 0, 1);
right = VectorCross( up, forward );
right = VectorNormalize(right);
cleanup = false;
foreach (target in data.targets)
{
if (!isdefined(target))
{
cleanup = true;
continue;
}
totarget = target.origin - origin;
totarget = (totarget[0], totarget[1], 0 );
normtotarget = VectorNormalize(totarget);
dist = Length(totarget);
if (dist > MAX_SONAR_DIST)
continue;
DisplayPing( target, forward, right, totarget);
}
if (cleanup)
{
targets = [];
foreach (target in data.targets)
{
if (isdefined(target))
{
targets[targets.size] = target;
}
}
data.targets = targets;
}
}
foreach (target in data.targets)
{
UpdatePing(target, data.sonar_count);
}
time = gettime();
foreach (group in data.groups)
{
UpdateSonarGroup( group, time );
}
UpdateSonarHUD( data );
aud_send_msg("sonar_ping", data.closest_dist);
wait 0.05;
}
}
SetupSDVHUD()
{
for (i=0; i<10; i++)
level.SDVFont[i] = getfx("wet_sub_num_"+i);
level.SDVFontWidth = 0.5;
self SetupSDVHUDNumber( 4.0, 1.0, 2, true, 0);
self SetupSDVHUDNumber( -3.0 - 3*level.SDVFontWidth, 1.0, 3, false, 1);
thread CleanupSDVHUD();
}
DebugAxis()
{
}
SetupSDVHUDNumber( x, y, numdigits, leading0s, id )
{
tag = "tag_motion_tracker_fx";
origin = self GetTagOrigin(tag);
angles = self GetTagAngles(tag);
forward = AnglesToForward(angles);
right = -1 * AnglesToRight(angles);
up = AnglesToUp(angles);
z = 0.0;
hudentry = spawnstruct();
hudentry.numdigits = numdigits;
hudentry.curnumber = -1;
hudentry.leading0s = leading0s;
digits = [];
for (i=0; i<numdigits; i++)
{
digits[i] = spawnstruct();
digit = digits[i];
digit.fx = 0;
digit.tag_ref = spawn_tag_origin();
digit.tag_ref.offset = (x, y, z);
digit.tag_ref.origin = origin + x*right + y*up + z*forward;
digit.tag_ref.angles = angles;
digit.tag_ref linkto( self, tag );
x += level.SDVFontWidth;
}
hudentry.digits = digits;
level.SDVFontRecord[id] = hudentry;
}
CleanupSDVHUD()
{
level waittill("player_through_water");
foreach (hudentry in level.SDVFontRecord)
{
foreach (digit in hudentry.digits)
{
if (digit.fx > 0)
StopFXOnTag( digit.fx, digit.tag_ref, "tag_origin" );
digit.tag_ref Delete();
}
}
level.SDVFontRecord = undefined;
}
TransferSDVHUD( tgt, isvehicle )
{
if (!isdefined(isvehicle) || !isvehicle)
tgt.notvehicle = true;
if (!isdefined(level.sdv_with_hud.notvehicle) || !level.sdv_with_hud.notvehicle)
tgt.prev_speed = level.sdv_with_hud Vehicle_GetSpeed();
else if (isdefined(level.sdv_with_hud.prev_speed))
tgt.prev_speed = level.sdv_with_hud.prev_speed;
tag = "tag_motion_tracker_fx";
origin = tgt GetTagOrigin(tag);
angles = tgt GetTagAngles(tag);
forward = AnglesToForward(angles);
right = -1 * AnglesToRight(angles);
up = AnglesToUp(angles);
level.sdv_with_hud = tgt;
tgt.flush_sdv_hud = 5;
foreach (hudentry in level.SDVFontRecord)
{
foreach (digit in hudentry.digits)
{
off = digit.tag_ref.offset;
digit.tag_ref.origin = origin + off[0]*right + off[1]*up + off[2]*forward;
digit.tag_ref.angles = angles;
digit.tag_ref linkto( tgt, tag );
}
}
}
DrawSDVHUDNumber( number, id, flush )
{
num = number;
hudentry = level.SDVFontRecord[id];
if ((hudentry.curnumber != number) || flush)
{
hudentry.curnumber = number;
idx = hudentry.numdigits-1;
while (number > 0)
{
nxtnum = int(number/10);
nint = nxtnum*10;
dgt = number - nint;
number = nxtnum;
hudentry.digits[idx].newfx = level.SDVFont[dgt];
idx -= 1;
assert((idx >= 0) || (number == 0));
if (idx < 0)
break;
}
while (idx >= 0)
{
if (hudentry.leading0s)
hudentry.digits[idx].newfx = level.SDVFont[0];
else
hudentry.digits[idx].newfx = 0;
idx--;
}
foreach( digit in hudentry.digits)
{
if ((digit.fx != digit.newfx) || flush)
{
if (digit.fx > 0)
StopFXOnTag( digit.fx, digit.tag_ref, "tag_origin" );
digit.fx = digit.newfx;
if (digit.fx > 0)
PlayFXOnTag( digit.fx, digit.tag_ref, "tag_origin" );
}
}
}
}
SDV_GetSpeed()
{
speed = 0;
if (isdefined(self.prev_speed))
speed = self.prev_speed;
if (isdefined(self.notvehicle))
{
if (isdefined(self.prev_origin))
{
speed = Distance(self.origin, self.prev_origin) / 0.05;
speed *= CONST_IPSTOMPH;
if (speed >= 62)
speed = self.prev_speed;
self.prev_speed = speed;
}
self.prev_origin = self.origin;
}
else
speed = self Vehicle_GetSpeed();
return speed;
}
UpdateSDVHUD()
{
level endon("player_through_water");
self SetupSDVHUD();
level.sdv_with_hud = self;
MPHTOKPH = 1.609344;
INTOM = 0.0254;
while (true)
{
sdv = level.sdv_with_hud;
if (!isdefined(sdv))
return;
flush = false;
if (isdefined(sdv.flush_sdv_hud))
{
flush = true;
sdv.flush_sdv_hud--;
if (sdv.flush_sdv_hud < 0)
sdv.flush_sdv_hud = undefined;
}
speed = sdv SDV_GetSpeed();
speed = int(speed*MPHTOKPH);
depth = level.water_z - sdv.origin[2];
if (depth < 0)
depth = 0;
depth = int(depth*INTOM);
if (depth > 9999)
depth = 9999;
DrawSDVHUDNumber(speed, 0, flush);
DrawSDVHUDNumber(depth, 1, flush);
wait 0.05;
}
}

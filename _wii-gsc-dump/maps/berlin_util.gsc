#include animscripts\utility;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\berlin_a10;
a10_muzzle_flash_fx(stopFiringOnNotify){
level endon(stopFiringOnNotify);
fx = getfx("a10_muzzle_flash");
while(1){
PlayFXOnTag( fx, self, "tag_gun" );
wait(.05);
}
}
mortarExplosion(target_ent, soundEnt)
{
level.player playfx( level._effect[ "a10_impact" ], target_ent.origin );
target_ent radiusdamage( target_ent.origin, 512, 500, 100, level.player);
}
missile_spawner_think()
{
fx = getfx( "f15_missile" );
PlayFXOnTag( fx, self, "tag_origin" );
}
berlin_rappel_behavior()
{
IPrintLn("berlin rappel has been disabled, remove this and include a glock to enable!");
assert(0);
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "actionSlotsHide", 1 );
SetSavedDvar( "hud_showStance", 0 );
SetSavedDvar( "hud_drawhud", 0 );
level.player DisableWeapons();
level.player DisableOffhandWeapons();
level.player DisableWeaponSwitch();
level.player AllowCrouch( false );
level.player AllowProne( false );
stance = level.player GetStance();
level.player SetStance( "stand" );
if ( stance != "stand" )
wait( 0.5 );
old_weapon = level.player GetCurrentWeapon();
level.player giveWeapon( level.rappel_weapon );
level.player givemaxammo( level.rappel_weapon );
level.player switchToWeapon( level.rappel_weapon );
ent = GetEnt( "rappel_animent", "targetname" );
player_rig = spawn_anim_model( "player_rig", level.player.origin );
player_rig DontCastShadows();
player_rope = spawn_anim_model( "rope_rappel", level.player.origin );
player_rope DontCastShadows();
rig_and_rope[0] = player_rig;
rig_and_rope[1] = player_rope;
flag_set( "player_hooking_up" );
rappelHookup(ent, rig_and_rope);
flag_set( "player_hooked_up" );
trigger_rappel_end = getent("trigger_rappel_end", "targetname");
flag_set( "descending" );
rappel_start = getent("rappel_start", "targetname");
rappel_start.origin = level.player.origin;
player_rope.origin = level.player.origin;
player_rope linkto(rappel_start);
player_rig unlink();
player_rig.origin = level.player.origin;
player_rig linkto(rappel_start);
delta_time = 0.05;
level.player.rappel_move_anim_state = "starting";
level.player.rappel_move_anim_state_time = 0;
player_rig UpdateAnimState(false, delta_time, rig_and_rope);
new_angles = level.player.angles;
level.player PlayerLinkTo( rappel_start, undefined, 1, 60, 10, 90, 20);
level.player AllowCrouch( false );
level.player AllowProne( false );
level.player PlayerSetGroundReferenceEnt( rappel_start );
level.player SetPlayerAngles( (0,0,0) );
thread monitorRappelOver( trigger_rappel_end );
level.player EnableWeapons();
move_time = 10 / delta_time;
dist = Distance( rappel_start.origin, trigger_rappel_end.origin);
speed = dist / move_time;
while(!flag("rappel_over") && level.player.origin[2] > 0)
{
breaking = level.player AdsButtonPressed();
speed_now = speed;
if(breaking)
speed_now = speed_now / 1.5;
player_rig UpdateAnimState(breaking, delta_time, rig_and_rope);
new_pos = rappel_start.origin;
new_pos -= (0,0, speed_now);
rappel_start.origin = new_pos;
player_rig.origin = rappel_start.origin;
player_rope.origin = rappel_start.origin;
wait(delta_time);
}
flag_set("rappel_over");
level.player DisableWeapons();
rappelUnHook(trigger_rappel_end);
level.player SwitchToWeapon( old_weapon );
level.player TakeWeapon(level.rappel_weapon);
level.player EnableOffhandWeapons();
level.player EnableWeaponSwitch();
level.player PlayerSetGroundReferenceEnt( undefined );
level.player AllowProne( true );
level.player AllowCrouch( true );
level.player unlink();
player_rig unlink();
wait( 0.8 );
level.player Unlink();
player_rig Delete();
player_rope Delete();
SetSavedDvar( "compass", 1 );
SetSavedDvar( "ammoCounterHide", 0 );
SetSavedDvar( "actionSlotsHide", 0 );
SetSavedDvar( "hud_showStance", 1 );
SetSavedDvar( "hud_drawhud", 1 );
level.player AllowCrouch( true );
level.player AllowProne( true );
level.player EnableWeapons();
}
monitorRappelOver( trigger_rappel_end )
{
trigger_rappel_end waittill("trigger");
flag_set("rappel_over");
}
UpdateAnimState(breaking, delta_time, anim_arr)
{
if(!isDefined(anim_arr))
{
anim_arr = [];
anim_arr[0] = self;
}
start_trans_time = 0.5;
stop_trans_time = 0.5;
level.player.rappel_move_anim_state_time += delta_time;
state = level.player.rappel_move_anim_state;
time_in_state = level.player.rappel_move_anim_state_time;
if(breaking)
{
if(state == "stopped")
{
}
else if(state == "stopping")
{
if(time_in_state > stop_trans_time)
{
state = "stopped";
time_in_state = 0;
self notify("stop_idle");
self thread anim_stopanimscripted();
self thread anim_loop(anim_arr, "stop_idle");
}
}
else if(state == "starting")
{
state = "stopping";
time_in_state = 0;
self thread anim_stopanimscripted();
self thread anim_single(anim_arr, "walk_to_stop");
}
else if(state == "walking")
{
state = "stopping";
time_in_state = 0;
self thread anim_stopanimscripted();
self thread anim_single(anim_arr, "walk_to_stop");
}
}
else
{
if(state == "stopped")
{
state = "starting";
time_in_state = 0;
self thread anim_stopanimscripted();
self thread anim_single(anim_arr, "stop_to_walk");
}
else if(state == "stopping")
{
state = "starting";
time_in_state = 0;
self thread anim_stopanimscripted();
self thread anim_single(anim_arr, "stop_to_walk");
}
else if(state == "starting")
{
if(time_in_state > stop_trans_time)
{
state = "walking";
time_in_state = 0;
self notify("stop_idle");
self thread anim_stopanimscripted();
self thread anim_loop(anim_arr, "walk_idle");
}
}
else if(state == "walking")
{
}
}
level.player.rappel_move_anim_state = state;
level.player.rappel_move_anim_state_time = time_in_state;
}
rappelHookup(anim_org_ent, rig_and_rope)
{
player_legs = spawn_anim_model( "player_legs", level.player.origin );
player_legs DontCastShadows();
rope_hookup = spawn_anim_model( "rope_hookup", level.player.origin );
rope_hookup DontCastShadows();
rope_coil = spawn_anim_model( "rope_coil", level.player.origin );
rope_coil DontCastShadows();
rig_and_rope[ rig_and_rope.size ] = player_legs;
rig_and_rope[ rig_and_rope.size ] = rope_hookup;
rig_and_rope[ rig_and_rope.size ] = rope_coil;
level.player PlayerLinkToBlend( rig_and_rope[0], "tag_player", 0.5, 0.2, 0.2 );
foreach(thing in rig_and_rope)
{
thread debug_line( thing, anim_org_ent.origin, 10 );
}
anim_org_ent anim_single( rig_and_rope, "rappel_hookup" );
level.player unlink();
level notify("clear_rappel_debug");
player_legs Delete();
rope_hookup Delete();
rope_coil Delete();
}
rappelUnHook(anim_org_ent)
{
player_rig = spawn_anim_model( "player_rig", anim_org_ent.origin );
player_rig Hide();
player_rope = spawn_anim_model( "rope_rappel", anim_org_ent.origin );
player_rope Hide();
player_rope linkto(player_rig);
rig_and_rope[ 0 ] = player_rig;
rig_and_rope[ 1 ] = player_rope;
player_rig delayCall( 0.6, ::Show );
player_rope delayCall( 0.6, ::Show );
level.player SetPlayerAngles(player_rig.angles);
level.player PlayerLinkToBlend( player_rig, "tag_player", 0.5, 0.2, 0.2 );
anim_org_ent anim_single( rig_and_rope, "rappel_unhook" );
level notify("clear_rappel_debug");
level.player unlink();
level.player SetPlayerAngles( player_rig.angles );
player_rig Delete();
player_rope Delete();
}
debug_line( ent, end, duration, color )
{
if ( !isdefined( color ) )
color = ( 1, 1, 1 );
for ( i = 0; i < ( duration * 20 ); i++ )
{
if(!isdefined(ent))
break;
Line( ent.origin, end, color );
wait 0.05;
}
}
BattleDrone_Spawner_think()
{
wait(1.0);
level endon("stop_drone_spawner");
my_drone = undefined;
assertex(isdefined(self.script_noteworthy), "your spawner at " + self.origin + " does not point to a info volume with script_noteworthy");
targetting_volume = getent(self.script_noteworthy, "targetname");
assert(isdefined(targetting_volume));
thread DestroyDrone();
while(1)
{
if(!isdefined(self.my_drone) || !isalive(self.my_drone))
{
self.count++;
self.my_drone = self spawn_ai();
self.my_drone.spawner = self;
self.my_drone thread Drone_Setup(targetting_volume);
}
wait(8.0);
}
}
DestroyDrone()
{
level waittill("stop_drone_spawner");
if(isdefined(self.my_drone))
self.my_drone delete();
self.my_drone = undefined;
}
Drone_Setup(battlefield_volume)
{
self endon("death");
assert(isdefined(self.team));
self.attack_range = 350;
if(isdefined(self.script_group))
self.attack_range = self.script_group;
self.attack_dmg = 45;
if(isdefined(self.script_index))
self.attack_dmg = self.script_index;
self.cur_volume = battlefield_volume;
self thread Drone_OnDeath();
self childthread Drone_Move();
self childthread Drone_OnGoal();
self childthread Drone_Fire();
}
Drone_OnGoal()
{
self waittill("goal");
}
Drone_OnDeath()
{
self waittill("death");
wait(5.0);
if(isdefined(self))
self delete();
}
get_opposing_team_name(myteam)
{
my_team = self.team;
if(!isdefined(my_team))
my_team = self.script_team;
assert(isdefined(my_team));
if(my_team == "axis")
return "allies";
return "axis";
}
get_targets_list(targets_volume)
{
targets_arr = targets_volume get_drones_touching_volume( get_opposing_team_name() );
return targets_arr;
}
Drone_Fire()
{
while(1)
{
self waittill( "firing" );
valid_target = Drone_FindTarget();
if(isdefined(valid_target))
{
rotate_time = 1;
normalized = VectorNormalize(valid_target.origin - self.origin);
final = vectorToAngles(normalized);
self rotateTo( final, rotate_time, rotate_time/3, rotate_time/3);
dmg = self.attack_dmg;
valid_target DoDamage( dmg, self.origin, self);
}
}
}
Drone_Move()
{
assert(isdefined(self.target));
while(!isdefined(self.started_moving) || !self.started_moving)
wait( 0.25 );
while(1)
{
if(isdefined(Drone_FindTarget()))
{
if(!isdefined(self.edrone_stopped) || !self.edrone_stopped)
{
self notify("drone_stop");
assert(isdefined(self.cur_node["script_noteworthy"]));
self thread maps\_drone::drone_idle( self.cur_node, self.origin );
self.edrone_stopped = true;
}
wait(3.0);
}
else
{
if(isdefined(self.edrone_stopped) && self.edrone_stopped)
{
self notify("stop_drone_fighting");
if(isdefined(self.cur_node["target"]))
{
self.target = self.cur_node["target"];
self thread maps\_drone::drone_move();
}
self.edrone_stopped = false;
}
}
wait(randomfloatrange(.9, 1.5));
}
}
Drone_FindTarget()
{
target_point = self.origin + (AnglesToForward( self.angles ) * self.attack_range/3);
threat_arr = get_targets_list(self.cur_volume);
valid_target = undefined;
foreach(threat in threat_arr)
{
if(!isalive(threat))
continue;
if(distance2d(target_point, threat.origin) < self.attack_range)
{
if(SightTracePassed(self.origin + (0,0,64), threat.origin + (0,0,40), false, self ))
{
valid_target = threat;
break;
}
wait(0.05);
}
}
return valid_target;
}
battlefield_effects(battlefield_volume, chance_for_effect)
{
level endon("stop_battlefield_effects");
if(!isdefined(chance_for_effect))
chance_for_effect = 100;
while(1)
{
if(randomfloat(100) <= chance_for_effect)
{
effect = level._effect[ "small_vehicle_explosion_nofire" ];
effect_range_from_target = 100;
effect_radius = 512;
effect_damage = 50;
if(cointoss())
{
if(cointoss())
{
effect_range_from_target = 200;
effect_damage = 100;
effect_radius = 256;
effect = level._effect[ "small_vehicle_explosion_nofire" ];
}
else
{
effect_range_from_target = 50;
effect_damage = 50;
effect_radius = 128;
effect = level._effect[ "small_vehicle_explosion_nofire" ];
}
}
else
{
if(cointoss())
{
effect_range_from_target = 80;
effect_damage = 150;
effect_radius = 128;
effect = level._effect[ "small_vehicle_explosion_nofire" ];
}
else
{
effect_range_from_target = 150;
effect_damage = 300;
effect_radius = 512;
effect = level._effect[ "a10_strike" ];
}
}
drone_arr = battlefield_volume get_drones_touching_volume();
if(drone_arr.size > 0)
{
angle = randomfloatrange(0,360);
forward = (0, angle, 0);
forward = anglesToForward(forward);
effect_target = drone_arr[randomint( drone_arr.size )];
effect_loc = effect_target.origin + (forward * effect_range_from_target);
level.player playfx( effect, effect_loc );
wait(0.5);
effect_target radiusdamage( effect_loc, effect_radius, effect_damage, effect_damage / 5 );
}
}
wait(randomfloatRange(5.0, 10.0));
}
}
color_volume_advance( baseName, numTotalFlags, startFlagNum )
{
thread color_volume_advance_cleanup();
level endon( "color_volume_advance_stop" );
team = "allies";
if( !IsDefined( startFlagNum ) )
{
startFlagNum = 1;
}
for ( i = startFlagNum; i <= numTotalFlags; i++ )
{
name = baseName + "_" + i;
trig = GetEnt( name, "targetname" );
assert(isdefined(trig));
assert((trig.spawnflags & 64) == 0);
vol = GetEnt( trig.target, "targetname" );
assert(isdefined(vol));
if(!isdefined(trig.trigger_off) || trig.trigger_off == true)
{
trig waittill("trigger");
trig trigger_off_proc();
}
array = vol maps\_colors::get_colorcodes( vol.script_color_allies, team );
colorCodes = array[ "colorCodes" ];
colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
colors = array[ "colors" ];
infos = [];
foreach( colorCode in colorCodes )
{
ASSERTEX( !color_volume_dupe_info( infos, colorCode ), "More than one volume found for colorCode " + colorCode + ", currently we only support one volume per colorCode." );
info = spawnstruct();
info.colorCodes[ 0 ] = colorCode;
color = GetSubStr( colorCode, 0, 1 );
info.colors[ 0 ] = color;
info.colorCodesByColorIndex[ color ] = colorCodesByColorIndex[ color ];
info.name = name;
info.volume = vol;
infos[ infos.size ] = info;
}
array_thread( infos, ::color_volume_advance_queue_add );
}
}
color_volume_advance_cleanup()
{
level waittill( "color_volume_advance_stop" );
level.color_volume_advance_queue = undefined;
}
color_volume_advance_queue_manager( color )
{
level endon( "color_volume_advance_stop" );
while( 1 )
{
if( level.color_volume_advance_queue[ color ].size )
{
volume = level.color_volume_advance_queue[ color ][ 0 ];
volume color_flag_volume_advance_wait();
}
else
{
level waittill( "color_flag_advance_queue_updated" );
}
}
}
color_volume_advance_queue_add()
{
color = self.colors[ 0 ];
if( !IsDefined( level.color_volume_advance_queue ) )
{
level.color_volume_advance_queue = [];
}
keys = GetArrayKeys( level.color_volume_advance_queue );
foundOne = false;
foreach( key in keys )
{
if( key == color )
{
foundOne = true;
break;
}
}
if( !foundOne )
{
level.color_volume_advance_queue[ color ] = [];
thread color_volume_advance_queue_manager( color );
}
level.color_volume_advance_queue[ color ][ level.color_volume_advance_queue[ color ].size ] = self;
level notify( "color_flag_advance_queue_updated" );
}
color_volume_advance_queue_remove()
{
color = self.colors[ 0 ];
ASSERTEX( self == level.color_volume_advance_queue[ color ][ 0 ], "Tried to remove a volume from the color_volume_advance queue for color " + color + ", but that volume wasn't at the top of the stack. This is unexpected." );
level.color_volume_advance_queue[ color ] = array_remove( level.color_volume_advance_queue[ color ], self );
}
color_flag_volume_advance_wait()
{
level endon( "color_volume_advance_stop" );
self.volume waittill_volume_dead_or_dying();
thread maps\_colors::activate_color_code_internal( self.colorCodes, self.colors, "allies", self.colorCodesByColorIndex );
assert(isdefined(self.volume));
if(isdefined(self.volume.script_noteworthy))
{
trigger_arr = GetEntArray( self.volume.script_noteworthy, "script_noteworthy" );
foreach(obj in trigger_arr)
{
if(obj.classname == "trigger_multiple")
{
obj trigger_off();
}
}
}
self color_volume_advance_queue_remove();
}
color_volume_dupe_info( infos, colorCode )
{
if( !infos.size )
{
return false;
}
foreach( info in infos )
{
if( info.colorCodes[ 0 ] == colorCode )
{
return true;
}
}
return false;
}
FriendlySniperFire(volume_name, end_message)
{
assert(isdefined(level.friendly_sniper_weapon));
wait(1.0);
level endon(end_message);
level.cosine[ "35" ] = cos(35);
while(1)
{
target_volume = GetEnt( volume_name, "targetname" );
pot_target_arr = GetAIArray("axis");
refined_target_arr = [];
foreach(tar in pot_target_arr)
{
if( tar isTouching(target_volume) )
{
refined_target_arr = array_add(refined_target_arr, tar);
}
}
if(refined_target_arr.size > 0)
{
assert(isdefined(target_volume.target));
fire_loc_arr = GetStructArray( target_volume.target, "targetname" );
assert(fire_loc_arr.size);
fire_loc_arr = array_randomize(fire_loc_arr);
fire_loc = fire_loc_arr[0];
refined_target_arr = array_randomize(refined_target_arr);
foreach(tar in refined_target_arr)
{
if( within_fov( level.player GetEye(), level.player GetPlayerAngles(), tar.origin, level.cosine[ "35" ] ) )
{
target_offset = (0,0,randomint( 64 ) + 32);
MagicBullet(level.friendly_sniper_weapon, fire_loc.origin, tar.origin + target_offset);
break;
}
}
}
wait(5);
}
}
add_entity_aim_feedback(vo_down, vo_up, vo_left, vo_right, view_angle_raw)
{
assert(isdefined(self));
thread MonitorEndAimFeedBack();
if(!isdefined(level.aim_vo_feedback_active))
Start_Aim_Vo_feedback();
ent_info = [];
ent_info["entity"] = self;
ent_info["vo_up"] = vo_up;
ent_info["vo_down"] = vo_down;
ent_info["vo_right"] = vo_right;
ent_info["vo_left"] = vo_left;
ent_info["angle"] = Cos(view_angle_raw);
level.aim_vo_feedback_arr = array_add(level.aim_vo_feedback_arr, ent_info);
}
Start_Aim_Vo_feedback()
{
assert(!isdefined(level.aim_vo_feedback_active));
level.aim_vo_feedback_active = true;
level.aim_vo_feedback_arr = [];
level thread ProcessAimVoFeedback();
}
handleRollover(angle)
{
if(angle > 180)
return angle-360;
return angle;
}
GetClosestTarget()
{
best_info = undefined;
best_err = 9999999999;
angles = level.player GetPlayerAngles();
eye = level.player geteye();
foreach(info in level.aim_vo_feedback_arr)
{
if(!isdefined(info["entity"]))
continue;
loc = info["entity"].origin;
to_obj = VectorToAngles(loc - eye);
diff = to_obj - angles;
roll = handleRollover(diff[0]);
pitch = handleRollover(diff[1]);
yaw = handleRollover(diff[2]);
tot_err = abs(roll) + abs(pitch) + abs(yaw);
if(tot_err < best_err)
{
best_info = info;
best_err = tot_err;
}
}
return best_info;
}
ProcessAimVoFeedback()
{
level endon("stop_aim_vo_feedback");
level endon("stop_processing_aim_vo_feedback");
level.player NotifyOnPlayerCommand("player_fired","+attack");
while(1)
{
level.player waittill("player_fired");
if(level.player getcurrentweapon() != level.player getcurrentprimaryweapon())
continue;
if(isdefined(level.aim_vo_feedback_disable))
continue;
target_info = GetClosestTarget();
if(!isdefined(target_info))
continue;
assert(isdefined(target_info["entity"]));
angles = level.player GetPlayerAngles();
view_angle = target_info["angle"];
ent = target_info["entity"];
if(within_fov(level.player.origin, angles, ent.origin, view_angle) )
{
eye = level.player geteye();
forward = anglestoforward( angles );
end = eye + ( forward * 7000 );
trace = bullettrace( eye, end, true, level.player );
entity = trace[ "entity" ];
if ( isdefined( entity ) )
{
trace[ "position" ] = entity.origin;
if(entity == ent)
continue;
}
correct_angles = VectorToAngles(ent.origin - eye);
max_idx = 0;
max_angle_diff = 0;
i = 0;
while(i < 2)
{
c_ang = correct_angles[i];
if(c_ang > 180)
c_ang = c_ang - 360;
n_ang = angles[i];
if(n_ang > 180)
n_ang = n_ang - 360;
angle_diff = c_ang - n_ang;
if(abs(angle_diff) > abs(max_angle_diff))
{
max_idx = i;
max_angle_diff = angle_diff;
}
i++;
}
secondary = max_angle_diff > 0;
text = "";
assert(max_idx == 0 || max_idx == 1);
if(max_idx == 0)
{
text = target_info["vo_up"];
if(secondary)
{
text = target_info["vo_down"];
}
}
else
{
text = target_info["vo_right"];
if(secondary)
{
text = target_info["vo_left"];
}
}
if(isDefined(level.scr_sound["lone_star"][text])){
level.lone_star thread dialogue_queue(text);
}else{
thread hint(text, 1);
}
}
wait(1);
}
}
MonitorEndAimFeedBack()
{
if(isAI(self))
{
assert(isAlive(self));
thread CleanUpOnMessage(self, "death");
self endon("death");
}
thread CleanUpOnMessage(self, "deleted");
thread CleanUpOnMessage(level, "stop_aim_vo_feedback");
thread CleanUpOnMessage(self, "clean_up_vo_feedback");
}
CleanUpOnMessage(obj, msg)
{
obj waittill(msg);
assert(isdefined(obj));
if(isdefined(level.aim_vo_feedback_active))
{
assert(isdefined(level.aim_vo_feedback_arr));
level.aim_vo_feedback_disable = true;
waittillframeend;
new_arr = [];
foreach(info in level.aim_vo_feedback_arr)
{
if(info["entity"] != obj)
{
new_arr[ new_arr.size ] = info;
}
}
level.aim_vo_feedback_arr = new_arr;
level.aim_vo_feedback_disable = undefined;
if(level.aim_vo_feedback_arr.size == 0)
{
level notify("stop_processing_aim_vo_feedback");
level.aim_vo_feedback_arr = undefined;
level.aim_vo_feedback_active = undefined;
}
}
else
{
assert(!isdefined(level.aim_vo_feedback_arr));
}
}
remove_entity_aim_feedback()
{
assert(isdefined(self));
self notify("clean_up_vo_feedback");
}
monitor_reload_event( note_to_end_on )
{
if(isdefined( note_to_end_on ))
{
level endon( note_to_end_on );
}
level endon("stop_monitoring_reload");
was_reloading = level.player IsReloading();
while(1)
{
is_reloading = level.player IsReloading();
if(is_reloading == was_reloading)
{
}
else
{
if(is_reloading)
{
level notify("start_reload");
wait(0.5);
}
else
{
level notify("finish_reload");
}
}
wait(0.05);
was_reloading = is_reloading;
}
}
move_to_group_array_average(group_array, flag_to_endon)
{
lerp_position = false;
self thread clean_me_up(flag_to_endon);
if ( isDefined( self ) && isDefined( group_array ) && isDefined( flag_to_endon ) )
{
while ( !flag( flag_to_endon ) )
{
total_guys = 0;
average_position = ( 0, 0, 0 );
foreach ( guy in group_array )
{
if ( IsDefined( guy ) && IsAlive( guy ) )
{
average_position = average_position + guy.origin;
total_guys++;
}
}
if ( total_guys > 0 )
{
average_position = average_position / total_guys;
if ( lerp_position )
{
self MoveTo( average_position, 0.2 );
}
else
{
lerp_position = true;
self.origin = average_position;
}
}
wait 0.2;
}
}
}
clean_me_up(flag)
{
flag_wait( flag );
self delete();
}
ally_move_dynamic_speed()
{
self notify( "start_dynamic_run_speed" );
self endon( "death" );
self endon( "stop_dynamic_run_speed" );
self endon( "start_dynamic_run_speed" );
if ( self ent_flag_exist( "_stealth_custom_anim" ) )
self ent_flag_waitopen( "_stealth_custom_anim" );
self.run_speed_state = "";
self ally_reset_dynamic_speed();
inches_sq = 12 * 12;
speed_states = [ "sprint", "run" ];
speed_ranges = [];
speed_ranges[ "player_sprint" ][ "sprint" ][0] = ( 15 * 15 * inches_sq );
speed_ranges[ "player_sprint" ][ "sprint" ][1] = ( 30 * 30 * inches_sq );
speed_ranges[ "player_sprint" ][ "run" ][0] = ( 30 * 30 * inches_sq );
speed_ranges[ "player_sprint" ][ "run" ][1] = ( 30 * 30 * inches_sq );
speed_ranges[ "player_run" ][ "sprint" ][0] = ( 15 * 15 * inches_sq );
speed_ranges[ "player_run" ][ "sprint" ][1] = ( 20 * 20 * inches_sq );
speed_ranges[ "player_run" ][ "run" ][0] = ( 20 * 20 * inches_sq );
speed_ranges[ "player_run" ][ "run" ][1] = ( 25 * 25 * inches_sq );
speed_ranges[ "player_crouch" ][ "run" ][0] = ( 2 * 2 * inches_sq );
speed_ranges[ "player_crouch" ][ "run" ][1] = ( 10 * 10 * inches_sq );
max_player_crouch_speed = 123;
max_player_run_speed = 189;
max_player_sprint_speed = 283;
while ( 1 )
{
wait .2;
if ( IsDefined( self.force_run_speed_state ) )
{
ally_dynamic_run_set( self.force_run_speed_state );
continue;
}
look_vector = VectorNormalize( AnglesToForward( self.angles ) );
player_to_self = VectorNormalize( ( self.origin - level.player.origin ) );
look_dot = VectorDot( look_vector, player_to_self );
dist2rd = DistanceSquared( self.origin, level.player.origin );
if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
self.moveplaybackrate = 1;
if ( flag_exist( "_stealth_spotted" ) && flag( "_stealth_spotted" ) )
{
ally_dynamic_run_set( "run" );
continue;
}
if ( look_dot < -0.25 && dist2rd > ( 15 * 15 * inches_sq ) )
{
ally_dynamic_run_set( "sprint" );
continue;
}
ally_dynamic_run_set( "cqb" );
}
}
ally_stop_dynamic_speed()
{
self endon( "death" );
self notify( "stop_dynamic_run_speed" );
ally_reset_dynamic_speed();
}
ally_reset_dynamic_speed()
{
self endon( "death" );
self disable_cqbwalk();
self.moveplaybackrate = 1;
self clear_run_anim();
self notify( "stop_loop" );
}
ally_dynamic_run_set( speed )
{
if ( self.run_speed_state == speed )
return;
self.run_speed_state = speed;
switch( speed )
{
case "sprint":
if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
self.moveplaybackrate = 1;
else
self.moveplaybackrate = 1;
self set_generic_run_anim( "DRS_sprint" );
self disable_cqbwalk();
self notify( "stop_loop" );
break;
case "run":
self.moveplaybackrate = 1;
self clear_run_anim();
self disable_cqbwalk();
self notify( "stop_loop" );
break;
case "jog":
self.moveplaybackrate = 1;
self set_generic_run_anim( "DRS_combat_jog" );
self disable_cqbwalk();
self notify( "stop_loop" );
break;
case "cqb":
self.moveplaybackrate = 1;
self enable_cqbwalk();
self notify( "stop_loop" );
break;
}
}
anim_single_solo_gravity( guy, anime, tag )
{
pain = guy.allowPain;
guy disable_pain();
self anim_single_solo_custom_animmode( guy, "gravity", anime, tag );
if( pain )
guy enable_pain();
}
anim_single_solo_custom_animmode( guy, custom_animmode, anime, tag, thread_func )
{
array = get_anim_position( tag );
org = array[ "origin" ];
angles = array[ "angles" ];
thread anim_custom_animmode_on_guy( guy, custom_animmode, anime, org, angles, self.animname, false, thread_func );
guy wait_until_anim_finishes( anime );
self notify( anime );
}
tank_fire_shotgun( targ, num_shots, spread_amount )
{
barrel_org = self gettagorigin( "tag_flash" );
show_debug_shots = false;
playfxontag( getfx( "t90_flash_berlin_closeup" ), self, "tag_flash" );
for(i = 0; i < num_shots; i++)
{
spread = spread_amount;
if(i == 0)
spread = 1;
shot_end = targ.origin + GetOffset(spread_amount) + targ stanceOffsetHelper();
magicbullet( "acr_hybrid_berlin", barrel_org, shot_end );
tracer_end = targ.origin + GetOffset(spread_amount);
bullettracer( barrel_org, tracer_end );
tracer_end = targ.origin + GetOffset(spread_amount);
bullettracer( barrel_org, tracer_end );
}
if(isalive(targ))
{
targ kill(self.origin, self);
}
PhysicsExplosionSphere(barrel_org + targ stanceOffsetHelper(), 512, 1, 1);
}
GetOffset( limit_x, limit_y, limit_z )
{
if(!isdefined(limit_y))
limit_y = limit_x;
if(!isdefined(limit_z))
limit_z = limit_y;
flip = -1;
return (randomintrange(flip*limit_x, limit_x), randomintrange(flip*limit_y, limit_y), randomintrange(flip*limit_z, limit_z) );
}
stanceOffsetHelper()
{
stance_offset = (0,0,0);
if(isai(self))
{
if(self.a.stance == "stand")
{
stance_offset = (0,0,48);
}
else if(self.a.stance == "crouch")
{
stance_offset = (0,0,32);
}
else if(self.a.stance == "prone")
{
stance_offset = (0,0,16);
}
else
{
assertEx( 0, "I dont know what stance this AI is in");
}
}
return stance_offset;
}
setup_ignore_suppression_triggers()
{
triggers = GetEntArray("trigger_ignore_suppression", "targetname");
foreach(trigger in triggers)
{
level thread ignore_suppression_trigger_think(trigger);
}
}
ignore_suppression_trigger_think(trigger)
{
for(;;)
{
trigger waittill("trigger", other);
if(IsDefined(other) && IsAI(other) && !other IsBadGuy())
{
other thread ignore_suppression_trigger_ai_think(trigger);
}
}
}
ignore_suppression_trigger_ai_think(trigger)
{
self notify("ignore_suppression_trigger_ai_think_stop");
self endon("ignore_suppression_trigger_ai_think_stop");
self endon("death");
self set_ignoresuppression(true);
while(self IsTouching(trigger))
{
wait .5;
}
self set_ignoresuppression(false);
}


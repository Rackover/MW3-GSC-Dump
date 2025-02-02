
#include maps\_utility;
#include common_scripts\utility;
main()
{
if( isDefined( level.cheap_air_strobe_fx ) )
{
level._effect["air_support_marker"]	= LoadFx( "smoke/signal_smoke_air_support_paris_ac130" );
}
else
{
level._effect["air_support_marker"]	= LoadFx( "smoke/signal_smoke_air_support" );
}
level._effect["air_support_trail"] = LoadFx( "smoke/smoke_geotrail_air_support" );
if ( isdefined( level.air_support_sticky_marker_fx ) )
level._effect["air_support_sticky_marker"]	= level.air_support_sticky_marker_fx;
if(isdefined(level.enemy_air_support_marker_fx))
level._effect["air_support_marker_enemy"]	= level.enemy_air_support_marker_fx;
if(isdefined(level.enemy_air_support_trail_fx))
level._effect["air_support_trail_enemy"] = level.enemy_air_support_trail_fx;
level.air_support_weapon = "ac130_40mm_air_support_strobe";
PrecacheItem(level.air_support_weapon);
PreCacheItem("air_support_strobe");
PreCacheRumble("ac130_artillery_rumble");
flag_init("flag_strobes_in_use");
level.air_support_strobes = [];
level.air_support_strobe_count = 0;
thread air_support_loop();
foreach(player in level.players)
{
player ent_flag_init("flag_strobe_ready");
player thread monitor_last_weapon();
}
add_extra_autosave_check("autosave_check_air_support_strobe_not_in_use", ::autosave_check_air_support_strobe_not_in_use, "Can't save because an air support strobe is in use");
}
autosave_check_air_support_strobe_not_in_use()
{
return level.air_support_strobe_count == 0;
}
fake_strobe(origin)
{
strobe = spawn_tag_origin();
strobe.origin = origin;
thread notify_strobe_thrown(strobe);
air_support_enqueue(strobe);
}
strobe_tracking()
{
Assert(IsPlayer(self));
self notify("stop_strobe_tracking");
self endon("stop_strobe_tracking");
self GiveWeapon("air_support_strobe");
self SetWeaponAmmoClip("air_support_strobe", 99);
self SetActionSlot(4, "weapon", "air_support_strobe");
self ent_flag_set( "flag_strobe_ready" );
strobe_cooldown = 18;
if(isdefined(level.strobe_cooldown_override))
strobe_cooldown = level.strobe_cooldown_override;
take_strobe_delay = WeaponFireTime("air_support_strobe") - .05;
for(;;)
{
self waittill("grenade_fire", strobe, weaponName);
strobe.owner = self;
if ( weaponName == "air_support_strobe" )
{
strobe thread strobe_think();
wait take_strobe_delay;
self ent_flag_clear( "flag_strobe_ready" );
self TakeWeapon("air_support_strobe");
ensure_player_has_weapon_selected();
wait strobe_cooldown - take_strobe_delay;
self GiveWeapon("air_support_strobe");
self SetWeaponAmmoClip("air_support_strobe", 99);
self SetActionSlot(4, "weapon", "air_support_strobe");
RefreshHudAmmoCounter();
self ent_flag_set("flag_strobe_ready");
level notify("air_support_strobe_ready");
}
}
}
disable_strobes_for_player()
{
Assert(IsPlayer(self));
self TakeWeapon("air_support_strobe");
self ensure_player_has_weapon_selected();
self notify("stop_strobe_tracking");
self ent_flag_clear("flag_strobe_ready");
}
enable_strobes_for_player()
{
Assert(IsPlayer(self));
self thread strobe_tracking();
}
air_support_loop()
{
strobe_delay = 2.5;
if(isdefined(level.strobe_firedelay_override))
strobe_delay = level.strobe_firedelay_override;
for(;;)
{
strobe = air_support_dequeue();
if( strobe strobe_can_see_targets() || ( isdefined( level.strobe_no_vis_check ) && level.strobe_no_vis_check ) )
{
level notify("air_suport_strobe_fired_upon", strobe);
thread count_strobe_kills(8);
if ( !isdefined( level.strobe_no_badplace ) || !level.strobe_no_badplace )
strobe thread strobe_enemy_badplace();
wait strobe_delay;
strobe strobe_fire();
}
else
{
level notify("air_support_strobe_no_targets");
wait 1;
}
}
}
notify_strobe_thrown(strobe)
{
level notify("air_support_strobe_thrown", strobe);
level endon("air_support_strobe_thrown");
flag_set("flag_strobes_in_use");
wait 5;
while(true)
{
while(!air_support_queue_empty())
{
wait 1;
}
wait 10;
if(air_support_queue_empty())
{
break;
}
}
flag_clear("flag_strobes_in_use");
}
strobe_enemy_badplace()
{
self endon( "death" );
badplace_wait_time = 5.8;
if ( IsDefined( level.strobe_used_once ) )
{
badplace_wait_time = 3;
}
wait badplace_wait_time;
height = 512;
radius = 400;
badplace_duration = 11 - badplace_wait_time;
BadPlace_Cylinder( "", badplace_duration, self.origin - (0, 0, height / 2), radius, height, "axis" );
level.strobe_used_once = true;
}
strobe_think(is_enemy)
{
self endon("death");
self thread monitor_strobe_count();
thread notify_strobe_thrown(self);
self.fx_origin = self spawn_tag_origin();
self.fx_origin LinkTo(self);
wait 0.1;
if ( isdefined ( is_enemy ) && is_enemy )
{
assert(isdefined(level._effect["air_support_trail_enemy"]));
PlayFxOnTag(getfx("air_support_trail_enemy"), self.fx_origin, "tag_origin");
self.isEnemyStrobe = true;
}
else
{
PlayFxOnTag(getfx("air_support_trail"), self.fx_origin, "tag_origin");
}
wait 2.35;
max_extra_wait = 0.5;
end_time = GetTime() + max_extra_wait * 1000;
last_origin = self.origin;
while(GetTime() < end_time)
{
waitframe();
velocity = (self.origin - last_origin) * 20;
last_origin = self.origin;
if(velocity[2] >= 0)
break;
}
result = BulletTrace(self.origin, self.origin + (0, 0, -1024), true, undefined, true);
if(IsDefined(result["position"]))
{
self.origin = result["position"];
}
if ( isdefined( self.sticky ) && self.sticky )
{
self thread marker_pulse();
}
else
{
if ( isdefined ( is_enemy ) && is_enemy )
{
assert(isdefined(level._effect["air_support_marker_enemy"]));
PlayFX(getfx("air_support_marker_enemy"), self.origin);
}
else
PlayFX(getfx("air_support_marker"), self.origin);
}
air_support_enqueue(self);
height = 512;
radius = 650;
BadPlace_Cylinder("", 9.5, self.origin - (0, 0, height / 2), radius, height, "allies");
wait 15;
if(IsDefined(self.fx_origin))
{
if ( isdefined ( is_enemy ) && is_enemy )
{
StopFXOnTag(getfx("air_support_marker_enemy"), self.fx_origin, "tag_origin");
}
else
{
StopFXOnTag(getfx("air_support_marker"), self.fx_origin, "tag_origin");
}
self.fx_origin Delete();
}
self Delete();
}
monitor_strobe_count()
{
if(!IsDefined(self))
return;
level.air_support_strobe_count++;
self waittill("death");
wait 4;
level.air_support_strobe_count--;
}
marker_pulse()
{
self endon( "death" );
assert( isdefined( level._effect["air_support_sticky_marker"] ) );
time = 5;
sample_rate = 0.3;
for( i=0; i<=time/sample_rate; i++ )
{
if ( isdefined( self.fx_origin ) )
{
PlayFxOnTag( getfx( "air_support_sticky_marker" ), self.fx_origin, "tag_origin" );
wait sample_rate;
}
else
{
break;
}
}
wait 1;
StopFXOnTag( getfx( "air_support_sticky_marker" ), self.fx_origin, "tag_origin");
}
linkto_without_angles(parent)
{
self endon("death");
self Unlink();
self RotateTo((0, 0, 90), 0.05);
for(; IsDefined(parent) && IsDefined(parent.origin); waitframe())
{
self MoveTo(parent.origin, 0.05);
}
}
air_support_enqueue(strobe)
{
level.air_support_strobes[level.air_support_strobes.size] = strobe;
level notify("air_support_strobe_popped", strobe);
}
air_support_dequeue()
{
level.air_support_strobes = array_removeUndefined(level.air_support_strobes);
while(level.air_support_strobes.size == 0)
{
level waittill("air_support_strobe_popped", strobe);
level.air_support_strobes = array_removeUndefined(level.air_support_strobes);
}
return level.air_support_strobes[0];
}
air_support_queue_empty()
{
return level.air_support_strobes.size == 0;
}
set_aircraft(aircraft, fake_altitude_inches, gun_tag )
{
if ( IsDefined( fake_altitude_inches ) )
level.air_support_fake_altitude_inches = fake_altitude_inches;
if ( IsDefined( gun_tag ) )
level.air_support_aircraft_guntag = gun_tag;
level.air_support_aircraft = aircraft;
}
get_gun_pos()
{
if(IsDefined(level.air_support_aircraft) && IsAlive(level.air_support_aircraft))
{
origin = level.air_support_aircraft.origin;
if ( isdefined( level.air_support_aircraft_guntag ) )
{
origin = level.air_support_aircraft GetTagOrigin( level.air_support_aircraft_guntag );
}
if(IsDefined(level.air_support_fake_altitude_inches))
{
player_eye = level.player GetEye();
if(origin[2] > level.air_support_fake_altitude_inches && player_eye[2] < level.air_support_fake_altitude_inches)
{
t = (level.air_support_fake_altitude_inches - player_eye[2]) / (origin[2] - player_eye[2]);
Assert(t >= 0);
Assert(t <= 1);
origin = linear_interpolate(t, level.player.origin, origin);
}
}
return origin;
}
else
{
return self.origin + (30, 15, 1000 * 12);
}
}
get_gun_test_pos()
{
return get_gun_pos();
}
strobe_can_see_targets()
{
targets = compute_targets(self.origin, self get_gun_pos());
targets = filter_visible_targets(targets, self get_gun_test_pos());
return targets.size > 0;
}
strobe_fire()
{
self endon("death");
if(!IsDefined(self)) return;
num_shots = 10;
rounds_per_min = 200;
fire_delay = 60 / rounds_per_min;
maps\_audio::aud_send_msg("ac130_prepare_inc");
for(i = 0; i < num_shots; i++)
{
gun_pos = self get_gun_pos();
gun_test_pos = self get_gun_test_pos();
targets = compute_targets(self.origin, gun_pos);
targets = filter_visible_targets(targets, gun_test_pos);
target_pos = get_best_target(targets, i, num_shots);
if ( !IsDefined(target_pos) )
{
target_pos = self.origin + noise_vector( 32 );
}
if( isdefined( self.isEnemyStrobe ) )
bullet = MagicBullet( level.air_support_weapon, gun_pos, target_pos );
else
bullet = MagicBullet( level.air_support_weapon, gun_pos, target_pos, self.owner );
bullet thread projectile_impact_earthquake(0.3,0.5,1200);
bullet_data = spawnstruct();
bullet_data.target_pos = target_pos;
bullet_data.fire_delay = fire_delay;
bullet_data.bullet = bullet;
maps\_audio::aud_send_msg("aud_ac130_bullet", bullet_data);
wait fire_delay;
}
if(IsDefined(self.fx_origin))
{
StopFXOnTag(getfx("air_support_marker"), self.fx_origin, "tag_origin");
self.fx_origin Delete();
}
self Delete();
}
projectile_impact_earthquake(eq_intensity,eq_duration,eq_radius)
{
org = self.origin;
while ( IsDefined( self ) )
{
org = self.origin;
wait( 0.1 );
}
Earthquake( eq_intensity, eq_duration, org, eq_radius );
PlayRumbleOnPosition("ac130_artillery_rumble", org);
}
compute_targets(strobe_pos, gun_pos)
{
target_radius = 512;
target_noise_radius = 32;
strobe_noise_radius = 64;
projectile_speed = 7500;
lead_fudge = 1.1;
lead_time = Distance(strobe_pos, gun_pos) / projectile_speed * lead_fudge;
targets = [];
targets[targets.size] = strobe_pos + noise_vector(strobe_noise_radius);
foreach(vehicle in Vehicle_GetArray())
{
if(
!IsDefined(vehicle.air_support_strobe_ignore) &&
Distance2D(vehicle.origin, strobe_pos) < target_radius)
{
targets[targets.size] = vehicle.origin + (vehicle Vehicle_GetVelocity()) * lead_time + noise_vector(target_noise_radius);
}
}
foreach(ai in GetAIArray("axis", "neutral"))
{
if(IsAlive(ai) &&
!IsDefined(ai.air_support_strobe_ignore) &&
Distance(ai.origin, strobe_pos) < target_radius)
{
targets[targets.size] = ai.origin + noise_vector(target_noise_radius);
}
}
return targets;
}
get_best_target(targets, shot_number, shot_count)
{
target_radius = 512;
far_pos = self.origin + VectorNormalize(self.origin - level.player.origin) * target_radius;
near_pos = self.origin + VectorNormalize(level.player.origin - self.origin) * target_radius;
ideal_pos = VectorLerp(far_pos, near_pos, shot_number / shot_count);
min_range = 9999999;
min_range_target = undefined;
foreach(target in targets)
{
distance = Distance2D(ideal_pos, target);
if(distance < min_range)
{
min_range = distance;
min_range_target = target;
}
}
return min_range_target;
}
filter_visible_targets(targets, gun_test_pos)
{
ret = [];
foreach(target in targets)
{
if(visibility_check(gun_test_pos, target))
ret[ret.size] = target;
}
return ret;
}
noise_vector(radius)
{
return randomvectorrange(0, radius) * (1, 1, 0);
}
visibility_check(gun_pos, target_pos)
{
return BulletTracePassed(gun_pos, target_pos + (0, 0, 128), false, undefined);
}
count_strobe_kills(duration)
{
level notify ("air_support_strobe_stop_damage_watcher");
level.air_support_strobe_num_killed = 0;
level.air_support_strobe_btr_killed = false;
foreach(enemy in GetAIArray("axis"))
{
enemy thread damage_watcher();
}
foreach(vehicle in Vehicle_GetArray())
{
if(IsDefined(vehicle.script_team) && vehicle.script_team == "axis")
{
vehicle thread damage_watcher();
}
}
wait(duration);
level notify("air_support_strobe_stop_damage_watcher");
level notify("air_support_strobe_killed", level.air_support_strobe_num_killed);
}
get_num_kills()
{
return level.air_support_strobe_num_killed;
}
damage_watcher()
{
level endon ("air_support_strobe_stop_damage_watcher");
if(self.health <= 0) return;
while(IsDefined(self))
{
self waittill("damage", amount, attacker, direction_vec, point, type, modelname, tagName, partName, dflags, weapon);
zero_health = 0;
if(IsDefined(self.healthbuffer))
{
zero_health = self.healthbuffer;
}
if( ( isdefined( weapon ) && weapon == level.air_support_weapon ) &&
(IsDefined(self) && IsDefined(self.health) && self.health <= zero_health && self.health + amount > zero_health) &&
(!self maps\_vehicle::is_godmode()))
{
level.air_support_strobe_num_killed++;
if ( IsDefined( level.btr_courtyard ) && self == level.btr_courtyard )
{
level.air_support_strobe_btr_killed = true;
}
return;
}
else
{
if(!IsDefined(self) || !IsDefined(self.health) || self.health <= zero_health)
return;
}
}
}
monitor_last_weapon()
{
self endon("death");
current_weapon = self GetCurrentWeapon();
self.last_weapon = current_weapon;
for(;;)
{
current_weapon = self GetCurrentWeapon();
self waittill("weapon_change", weapon);
self.last_weapon = current_weapon;
current_weapon = weapon;
}
}
ensure_player_has_weapon_selected()
{
Assert(IsPlayer(self));
if(self GetCurrentWeapon() == "none")
{
success = false;
if(IsDefined(self.last_weapon) && self.last_weapon != "none" && self HasWeapon(self.last_weapon))
{
success = self SwitchToWeapon(self.last_weapon);
}
else
{
primary_weapons = self GetWeaponsListPrimaries();
if(primary_weapons.size > 0)
{
success = self SwitchToWeapon(primary_weapons[0]);
}
}
AssertEx(success, "ensure_player_has_weapon_selected() failed, does he have any primary weapons at all?");
}
}

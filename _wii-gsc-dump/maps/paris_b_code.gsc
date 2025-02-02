#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\paris_shared;
#include maps\_shg_common;
#using_animtree("vehicles");
setup_bomb_truck()
{
level.bomb_truck = getent_safe("bomb_truck", "script_noteworthy");
level.bomb_truck.animname = "bomb_truck";
level.bomb_truck godon();
level.bomb_truck.animscripted_root = %armored_van_scripted;
level.bomb_truck HideAllParts();
level.bomb_truck_model = spawn("script_model", (0, 0, 0));
level.bomb_truck_model SetModel(level.bomb_truck.model);
level.bomb_truck_model.animname = level.bomb_truck.animname;
level.bomb_truck_model assign_animtree();
level.bomb_truck_model thread van_damage_glass_setup();
level.bomb_truck_model thread van_damage_glass_think();
level.bomb_truck_model thread van_make_glass_invul( 4 );
level.bomb_truck_model thread van_make_glass_invul( 5 );
level.bomb_truck_model.link_offset = -1 * level.bomb_truck_model GetTagOrigin("tag_body");
level.bomb_truck_model LinkTo(level.bomb_truck, "tag_body", level.bomb_truck_model.link_offset, (0, 0, 0));
}
intro_cinematic_lone_star_logic()
{
pda = Spawn("script_model", (0, 0, 0));
pda SetModel("electronics_pda_big");
pda LinkTo(level.hero_lone_star, "tag_inhand", (0, 0, 0), (0, 0, 0));
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
anim_ent anim_single_solo(self, "a_b_switch_pt1");
pda Delete();
}
intro_cinematic_redshirt_logic()
{
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
anim_ent anim_single_solo(self, "a_b_switch_pt1");
}
intro_cinematic_player()
{
hud_off();
g_friendlyNameDist_old = GetDvarInt( "g_friendlyNameDist" );
SetSavedDvar( "g_friendlyNameDist", 0 );
level.player gasmask_on_player(false);
level.player DisableWeapons();
level.player SetStance("crouch");
level.player AllowStand(false);
level.player AllowCrouch(true);
level.player AllowProne(false);
player_rig = spawn_anim_model("player_rig", level.player.origin);
player_link_ent = spawn_tag_origin();
player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 20), (0, 0, 0));
level.player PlayerLinkToDelta(player_link_ent, "tag_origin", 1, 0, 0, 0, 0, true);
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
hacky_anim_ent = spawn_tag_origin();
hacky_anim_ent.origin = anim_ent.origin;
hacky_anim_ent.angles = anim_ent.angles;
duration = .5;
height_cheat = 5.21875;
hacky_anim_ent delayCall(GetAnimLength(player_rig getanim("a_b_switch_pt1")) - duration - 0.1, ::MoveTo, hacky_anim_ent.origin + (0, 0, height_cheat), duration);
player_rig LinkTo(hacky_anim_ent, "tag_origin", (0, 0, 0), (0, 0, 0));
hacky_anim_ent anim_single_solo(player_rig, "a_b_switch_pt1");
level.player Unlink();
level.player player_control_on();
player_rig Delete();
player_link_ent Delete();
hacky_anim_ent Delete();
delayThread(1, ::hud_on);
SetSavedDvar( "g_friendlyNameDist", g_friendlyNameDist_old );
}
player_cinematic_gasmask_off()
{
thread maps\_introscreen::introscreen_generic_black_fade_in(.25, .5);
level.player DisableWeapons();
level.player SetStance("crouch");
level.player DelayCall(.05, ::SetStance, "crouch");
level.player AllowStand(false);
level.player AllowCrouch(true);
level.player AllowProne(false);
player_rig = spawn_anim_model("player_rig", level.player.origin);
player_gasmask = spawn_anim_model("player_gasmask", level.player.origin);
player_link_ent = spawn_tag_origin();
player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 20), (0, 0, 0));
level.player PlayerLinkToDelta(player_link_ent, "tag_origin", 1, 0, 0, 0, 0, true);
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
height_cheat = 5.21875;
hacky_anim_ent = spawn_tag_origin();
hacky_anim_ent.origin = anim_ent.origin + (0, 0, height_cheat);
hacky_anim_ent.angles = anim_ent.angles;
player_rig LinkTo(hacky_anim_ent, "tag_origin", (0, 0, 0), (0, 0, 0));
unlink_duration = .4;
unlink_delay = GetAnimLength(player_rig getanim("a_b_switch_pt2")) - unlink_duration;
delayThread(unlink_delay, ::player_cinematic_gasmask_off_unlink, unlink_duration, player_rig, player_gasmask);
hacky_anim_ent thread anim_single_solo(player_gasmask, "a_b_switch_pt2");
hacky_anim_ent anim_single_solo(player_rig, "a_b_switch_pt2");
tagangles = player_rig GetTagAngles("tag_player");
level.player Unlink();
level.player player_control_on();
player_rig Delete();
player_gasmask Delete();
player_link_ent Delete();
hacky_anim_ent Delete();
thread player_stand_on_move();
}
player_cinematic_gasmask_off_unlink(unlink_duration, player_rig, player_gasmask)
{
player_rig Hide();
player_gasmask Hide();
level.player player_control_on();
level.player player_smooth_unclamp(unlink_duration, 0, 0, 0, 0);
level.player Unlink();
}
player_stand_on_move()
{
duration = 5.25;
level.player endon("death");
wait .25;
end_ms = GetTime() + duration * 1000;
while(Length(level.player GetNormalizedMovement()) < .001 && level.player GetStance() == "crouch" && GetTime() < end_ms)
waitframe();
if(level.player GetStance() == "crouch")
level.player SetStance("stand");
}
paris_b_intro_player_mask_off(player_rig)
{
level.player gasmask_off_player();
}
catacombs_lone_star_logic()
{
self deletable_magic_bullet_shield();
self thread aud_prime_stream(level.scr_sound["lonestar"]["paris_lns_onelight"]);
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
anim_ent anim_single_solo_run(self, "a_b_switch_pt2");
self set_force_color("b");
self thread ally_keep_player_distance(39 * -6, .8, 1.2);
self enable_cqbwalk();
flag_wait("set_flare_1");
self plant_flare(getent_safe("flare_light_1", "script_noteworthy"), getstruct("flare_plant_1", "script_noteworthy"));
flag_wait("set_flare_2");
self plant_flare(getent_safe("flare_light_2", "script_noteworthy"), getstruct("flare_plant_2", "script_noteworthy"));
flag_wait("trigger_catacombs_gate");
flag_wait("set_flare_3");
self plant_flare(getent_safe("flare_light_3", "script_noteworthy"), getstruct("flare_plant_3", "script_noteworthy"));
flag_wait("flag_catacombs_player_past_squeeze_corridor");
self squeeze_through_corridor(undefined, 5);
flag_set("flag_lone_star_past_fallen_corridor");
self enable_ai_color();
flag_wait_any("set_flare_4", "flag_catacombs_enemy_gate");
if(flag("flag_catacombs_enemy_gate"))
{
scripted_sequence_recon("flare_plant_4", false);
return;
}
self plant_flare(getent_safe("flare_light_4", "script_noteworthy"), getstruct("flare_plant_4", "script_noteworthy"));
flag_wait_any("set_flare_5", "flag_catacombs_enemy_gate");
if(flag("flag_catacombs_enemy_gate"))
{
scripted_sequence_recon("flare_plant_5", false);
return;
}
self plant_flare(getent_safe("flare_light_5", "script_noteworthy"), getstruct("flare_plant_5", "script_noteworthy"));
}
catacombs_frenchie_logic()
{
self thread ally_keep_player_distance(39 * -4, .8, 1.2);
deletable_magic_bullet_shield();
disable_ai_color();
enable_cqbwalk();
self.aggressivemode = true;
self goto_node(GetNode("node_sewer_intro_frenchie", "targetname"), false);
wait 4.5;
scripted_sequence_recon("frenchie_flashlight_on", true, self);
self thread flashlight_guy_start();
wait 1.5;
flag_set("flag_dialogue_stay_close");
self handsignal("onme");
self set_force_color("r");
self enable_ai_color();
flag_wait( "flag_sewer_sabre_signal_stop_pos" );
disable_ai_color();
anim_ent = getstruct("struct_catacombs_signal_quick_stop", "script_noteworthy");
anim_ent anim_generic_reach(self, "catacombs_signal_quick_stop");
anim_ent anim_generic_first_frame(self, "catacombs_signal_quick_stop");
flag_wait( "flag_sewer_sabre_signal_stop_start" );
anim_ent anim_generic_run(self, "catacombs_signal_quick_stop");
scripted_sequence_recon("catacombs_signal_look", true, self, 1);
self anim_single([self], "catacombs_signal_look", undefined, 1.0, "generic");
flag_set( "flag_dialogue_frenchie_signal_clear_sewer" );
self enable_ai_color();
flag_wait("trigger_catacombs_gate");
self disable_ai_color();
anim_ent = getent("catacombs_gate_origin", "script_noteworthy");
anim_ent anim_reach_solo(self, "catacombs_gate_enter_enter");
anim_ent anim_single_solo(self, "catacombs_gate_enter_enter");
anim_ent thread anim_loop_solo(self, "catacombs_gate_enter_idle", "frenchie_ender");
flag_set("flag_catacombs_gate_frenchie_idling");
flag_wait("flag_catacombs_gate_begin");
wait (297 - 126) / 30;
anim_ent notify("frenchie_ender");
anim_ent anim_single_solo_run(self, "catacombs_gate_enter");
self thread ally_keep_player_distance_stop();
self.moveplaybackrate = .7;
squeeze_through_corridor("flag_frenchie_fallen_corridor_committed", .5);
flag_set( "flag_dialogue_frenchie_check_right" );
self goto_node("node_frenchie_past_squeeze_corridor", true);
self thread ally_keep_player_distance(39 * -4, .8, 1.2);
flag_wait( "flag_catacombs_player_past_squeeze_corridor" );
self handsignal("go");
wait 1;
flag_set( "flag_dialogue_this_way_post_squeeze" );
self enable_ai_color();
}
catacombs_reno_logic()
{
self thread ally_keep_player_distance(39 * -4, .8, 1.2);
deletable_magic_bullet_shield();
disable_ai_color();
enable_cqbwalk();
goto_node(GetNode("node_sewer_intro_reno", "targetname"), false);
wait 6 + 1.5;
set_force_color("o");
enable_ai_color();
flag_wait("flag_catacombs_player_past_squeeze_corridor");
wait 3;
self squeeze_through_corridor(undefined, 5);
flag_set("flag_reno_past_fallen_corridor");
enable_ai_color();
}
catacombs_redshirt_logic()
{
deletable_magic_bullet_shield();
anim_ent = getstruct("struct_a_b_switch", "script_noteworthy");
anim_ent anim_single_solo_run(self, "a_b_switch_pt2");
set_force_color("y");
self thread ally_keep_player_distance(39 * 4, .8, 1.2);
enable_cqbwalk();
flag_wait("trigger_catacombs_gate");
disable_ai_color();
anim_ent = getent("catacombs_gate_origin", "script_noteworthy");
anim_ent anim_reach_solo(self, "catacombs_gate_enter_enter");
anim_ent anim_single_solo(self, "catacombs_gate_enter_enter");
anim_ent thread anim_loop_solo(self, "catacombs_gate_enter_idle", "redshirt_ender");
flag_set("flag_catacombs_gate_redshirt_idling");
flag_wait("flag_catacombs_gate_begin");
self thread ally_keep_player_distance_stop();
anim_ent notify("redshirt_ender");
self delayThread(.5, animscripts\notetracks::noteTrackMovementWalk);
scripted_sequence_recon("catacombs_gate_enter", true, self, 4);
anim_ent anim_single_solo_run(self, "catacombs_gate_enter");
self thread ally_keep_player_distance_stop();
self.moveplaybackrate = .7;
self goto_node("node_catacombs_gate_guy1_wait", false);
self squeeze_through_corridor("flag_redshirt_fallen_corridor_committed");
self thread ally_keep_player_distance(39 * 4, .8, 1.2);
self goto_node("node_redshirt_past_squeeze_corridor", true);
flag_wait( "flag_catacombs_player_past_squeeze_corridor" );
wait 2;
self enable_ai_color();
}
catacombs_gate_gate()
{
gate_model = getent("catacombs_gate_model", "script_noteworthy");
anim_ent = getent("catacombs_gate_origin", "script_noteworthy");
anim_ent anim_single_solo(gate_model, "catacombs_gate_enter");
}
catacombs_gate_blocker()
{
wait 8;
blocker = GetEnt_safe("catacombs_gate_brushmodel", "script_noteworthy");
blocker ConnectPaths();
blocker Delete();
}
catacombs_gate_crowbar()
{
crowbar = spawn_anim_model("crowbar");
crowbar Hide();
crowbar DelayCall(.3, ::Show);
anim_ent = getent("catacombs_gate_origin", "script_noteworthy");
anim_ent anim_single_solo(crowbar, "catacombs_gate_enter");
crowbar Delete();
}
squeeze_through_corridor(flag, delay)
{
if(!IsDefined(delay)) delay = 4;
node = getstruct("struct_catacombs_squeeze_moment", "script_noteworthy");
node anim_reach_solo(self, "squeeze_through_fallen_corridor");
self.moveplaybackrate = 1;
flag_waitopen("flag_npc_in_squeeze_corridor");
flag_set("flag_npc_in_squeeze_corridor");
delayThread(delay, ::flag_clear, "flag_npc_in_squeeze_corridor");
if(IsDefined(flag))
{
flag_set(flag);
}
scripted_sequence_recon("fallen_corridor_" + self.animname, true, self, 3);
node anim_single_solo_run(self, "squeeze_through_fallen_corridor");
}
flashlight_guy_start()
{
self flashlight_on();
self.disable_cqb_points_of_interest = true;
self thread flashlight_control();
}
flashlight_guy_stop()
{
self flashlight_off();
self notify("flashlight_control_stop");
self.disable_cqb_points_of_interest = undefined;
}
catacombs_bomb_1()
{
flag_wait("flag_catacombs_bomb_1");
aud_send_msg("catacombs_bomb_1");
Earthquake( 0.3, 3, level.player.origin, 850 );
org_fx = GetEnt("origin_catacombs_bomb_1", "targetname");
PlayFX(level._effect[ "falling_dirt_catacomb" ], org_fx.origin);
}
player_squeeze_through_fallen_corridor()
{
blocker = getent("blocker_corridor", "script_noteworthy");
if(IsDefined(blocker)) blocker delete();
wait 3.5;
anim_ent = getstruct("struct_catacombs_squeeze_moment", "script_noteworthy");
player_rig = spawn_anim_model("player_rig");
player_rig Hide();
anim_ent anim_first_frame_solo(player_rig, "fallen_corridor_f");
aud_send_msg("aud_prime_catacombs_squeeze");
level.player waittill_range_or_eta(GetStartOrigin(anim_ent.origin, anim_ent.angles, player_rig getanim("fallen_corridor_f")), 32, .5);
duration = .5;
level.player PlayerLinkToBlend(player_rig, "tag_player", duration, duration / 3, duration / 3);
level.player DelayCall(duration, ::PlayerLinkToDelta, player_rig, "tag_player", 1, 0, 0, 0, 0, true);
level.player player_control_off();
player_rig delayCall(.5, ::Show);
aud_send_msg("aud_start_catacombs_squeeze");
wait duration;
unlink_duration = .3;
level.player delayThread(GetAnimLength(player_rig getanim("fallen_corridor_f")) - unlink_duration, ::player_smooth_unclamp, unlink_duration, 0, 0, 0, 0);
anim_ent anim_single_solo(player_rig, "fallen_corridor_f");
level.player Unlink();
level.player player_control_on();
player_rig Delete();
}
add_enemy_flashlight()
{
PlayFXOnTag( getfx("flashlight_ai"), self, "tag_flash" );
self.have_flashlight = true;
}
catacombs_bomb_2()
{
flag_wait("flag_catacombs_bomb_2");
aud_send_msg("catacombs_bomb_2");
Earthquake( 0.1, 3, level.player.origin, 850 );
org_fx = GetEnt("origin_catacombs_bomb_2", "targetname");
PlayFX(level._effect[ "falling_dirt_catacomb" ], org_fx.origin);
}
catacombs_shadow_gag_main_room()
{
flag_wait( "flag_shadow_gag_main_room" );
aud_send_msg("shadow_gag_main_room");
spawner_shadow_guy = getent( "guy_shadow_gag_1", "script_noteworthy" );
guy = spawner_shadow_guy spawn_ai( true );
guy endon("death");
scripted_sequence_recon("shadow_gag_shadow", true, guy.origin + (39 * -2, 39 * -8, 4), 1);
scripted_sequence_recon("shadow_gag_guy", true, guy, 1.25);
guy set_ignoreall(true);
guy set_ignoreme(true);
guy enable_cqbwalk();
guy.goalradius = 8;
goal_node = GetNode("goal_shadow_gag_1", "targetname");
guy SetGoalNode(goal_node);
guy waittill("goal");
guy delete();
}
catacombs_enemy_gate_gag()
{
catacombs_enemy_gate_gag_setup();
flag_wait("flag_catacombs_enemy_gate");
battlechatter_on( "allies" );
catacombs_enemy_gate_gag_run();
if(!flag("flag_catacombs_enemy_gate_gag_vfx"))
{
scripted_sequence_recon("catacombs_enemy_gate_gag", false);
}
foreach(guy in [level.hero_reno, level.hero_frenchie, level.hero_lone_star, level.hero_redshirt])
{
guy disable_cqbwalk();
guy.movePlaybackRate = 1;
}
}
catacombs_enemy_gate_gag_setup()
{
anim_ent = getstruct("catacombs_gate_ambush", "script_noteworthy");
gate = getent_safe("catacombs_gate_ambush_door", "script_noteworthy");
gate.animname = "ambush_gate";
gate assign_animtree();
anim_ent anim_first_frame_solo(gate, "gate_ambush");
}
catacombs_enemy_gate_gag_run()
{
level endon("flag_volk_catacombs_escape");
anim_ent = getstruct("catacombs_gate_ambush", "script_noteworthy");
gate = getent_safe("catacombs_gate_ambush_door", "script_noteworthy");
level.hero_frenchie disable_awareness();
level.hero_frenchie disable_ai_color();
anim_ent anim_reach_solo( level.hero_frenchie, "gate_ambush" );
flag_set("flag_combat_staging_room");
if(!flag("flag_catacombs_enemy_gate_abort"))
{
scripted_sequence_recon("catacombs_enemy_gate_gag", true, level.hero_frenchie);
flag_set("flag_catacombs_enemy_gate_gag_vfx");
aud_send_msg("enemy_gate_gag", gate);
enemy_1 = getent_safe("guy_catacombs_enemy_gate_1", "script_noteworthy") spawn_ai(true);
anim_ent thread anim_generic( enemy_1, "gate_ambush" );
anim_ent thread anim_single_solo( gate, "gate_ambush" );
anim_ent anim_single_solo_run( level.hero_frenchie, "gate_ambush" );
blocker = getent("blocker_catacombs_gate", "script_noteworthy");
if(IsDefined(blocker)) blocker delete();
if(IsDefined(enemy_1))
{
enemy_1.ragdoll_immediate = true;
enemy_1 Kill();
}
flag_set("flag_dialogue_catacombs_lets_move");
}
foreach(guy in [level.hero_reno, level.hero_frenchie, level.hero_lone_star, level.hero_redshirt])
{
guy disable_cqbwalk();
guy.movePlaybackRate = 1;
}
SetSavedDvar( "ai_friendlyFireBlockDuration", 0 );
noself_delayCall(10, ::SetSavedDvar, "ai_friendlyFireBlockDuration", 2000);
level.hero_frenchie enable_awareness();
level.hero_frenchie goto_node(GetNode("node_frenchie_post_ambush", "targetname"), true);
SetSavedDvar( "ai_friendlyFireBlockDuration", 2000 );
level.hero_frenchie delayThread(1, ::handsignal, "moveup");
level.hero_frenchie enable_ai_color();
}
combat_staging_room()
{
flag_wait("flag_combat_staging_room");
battlechatter_on( "allies" );
spawners = getentarray( "ai_staging_room", "script_noteworthy" );
foreach( spawner in spawners )
{
spawner add_spawn_function(::add_enemy_flashlight);
spawner spawn_ai( true );
}
aud_send_msg("mus_catacombs_ambush");
}
volk_catacombs_escape()
{
level.player endon("death");
hud_off();
flashbang_delay = 1.3;
flashbang_speed = 600;
slowmo_rate = 0.2;
slowmo_fadein_duration = 0.2;
slowmo_duration = 0.3;
slowmo_fadeout_duration = 1;
extra_god_duration = 1.5;
flag_set( "flag_dialogue_makarov_men" );
flag_set("flag_combat_staging_room");
spawners = getentarray( "ai_staging_room_runners", "script_noteworthy" );
foreach( spawner in spawners )
{
spawner spawn_ai( true );
}
foreach(guy in GetAIArray("axis"))
{
guy thread flashbang_immunity(3);
}
volk = getent("volk_catacombs", "script_noteworthy") spawn_ai( true );
volk forceUseWeapon("deserteagle", "primary");
volk.sidearm = "none";
volk.secondaryweapon = "none";
volk.lastweapon = "none";
level.volk = volk;
volk.animname = "volk";
volk thread fail_if_volk_dies();
volk enable_sprint();
volk deletable_magic_bullet_shield();
volk disable_awareness();
guard = GetEnt("volk_escape_guard_spawner", "script_noteworthy") spawn_ai(true);
guard.animname = "guard";
guard magic_bullet_shield();
player_rig = spawn_anim_model( "player_rig", level.player.origin );
player_rig Hide();
level.struct_volk_escape_moment anim_first_frame([player_rig, volk, level.volk_escape_table, level.volk_escape_table_props, guard], "volk_escape");
thread volk_guards_staging_room();
player_rig_height_cheater = player_rig spawn_tag_origin();
player_rig LinkTo(player_rig_height_cheater, "tag_origin", (0, 0, 0), (0, 0, 0));
flashbang_origin_struct = GetStruct("struct_flashbang_origin", "script_noteworthy");
flashbang_target_struct = GetStruct(flashbang_origin_struct.target, "targetname");
flashbang = MagicGrenadeManual("flash_grenade", flashbang_origin_struct.origin, VectorNormalize(flashbang_target_struct.origin - flashbang_origin_struct.origin) * flashbang_speed, 100 );
flag_wait_or_timeout("flag_volk_catacombs_escape_flash", flashbang_delay);
level.hero_lone_star disable_ai_color();
level.hero_frenchie disable_ai_color();
level.hero_reno disable_ai_color();
level.hero_redshirt disable_ai_color();
scripted_sequence_recon("scripted_flashbang", true, flashbang.origin);
aud_send_msg("scripted_flashbang", flashbang.origin);
PlayFX(getfx("scripted_flashbang"), flashbang.origin, (1, 0, 0), (0, 0, 1));
flashbang Delete();
level.player player_control_off(false);
level.player HideViewModel();
level.player EnableInvulnerability();
level.player player_reload_silently();
SetSlowMotion(1.0, slowmo_rate, slowmo_fadein_duration);
level.player noself_delayCall(slowmo_fadein_duration + slowmo_duration, ::SetSlowMotion, slowmo_rate, 1.0, slowmo_fadeout_duration);
level.player ShellShock( "paris_scripted_flashbang", 3);
level.hero_frenchie enable_awareness();
level.hero_frenchie anim_stopanimscripted();
waitframe();
level.player PlayerLinkToDelta(player_rig, "tag_player", 1, 0, 0, 0, 0, true);
level.player LerpViewAngleClamp(.2, 0, 0, 2, 2, 7, 7);
player_rig Show();
height_cheat = 6;
player_rig_height_cheater delayCall(.05, ::MoveZ, height_cheat, .1);
guard stop_magic_bullet_shield();
exploder(62002);
frenchie_start_pos = GetStartOrigin(level.struct_volk_escape_moment.origin, level.struct_volk_escape_moment.angles, level.hero_frenchie getanim("volk_escape"));
BadPlace_Cylinder("", 15, frenchie_start_pos, 39*3, 100, "axis");
thread volk_catacombs_escape_volk(level.struct_volk_escape_moment, volk);
level.struct_volk_escape_moment thread anim_single_solo(guard, "volk_escape");
unclamp_duration = .3;
level.player delayThread(GetAnimLength(player_rig getanim("volk_escape")) - unclamp_duration, ::player_smooth_unclamp, unclamp_duration, 2, 2, 7, 7);
level.struct_volk_escape_moment anim_single([player_rig, level.hero_frenchie, level.volk_escape_table, level.volk_escape_table_props], "volk_escape");
level.player Unlink();
level.player player_control_on();
level.player ShowViewModel();
level.player delayCall(extra_god_duration, ::DisableInvulnerability);
player_rig Delete();
player_rig_height_cheater Delete();
hud_on();
level.player SetMoveSpeedScale(.85);
level.hero_lone_star thread ally_keep_player_distance(39 * 6, .8, 1.2);
level.hero_reno thread ally_keep_player_distance(39 * 4, .8, 1.2);
level.hero_redshirt thread ally_keep_player_distance(39 * 4, .8, 1.2);
level.hero_frenchie thread ally_keep_player_distance(39 * 6, .8, 1.2);
thread escape_timer_countdown(30, &"PARIS_FAIL_VOLK_ESCAPED");
thread flashbang_complete_enable_color();
}
flashbang_immunity(duration)
{
Assert(IsAI(self));
Assert(IsAlive(self));
self endon("death");
self SetFlashbangImmunity(true);
wait duration;
self SetFlashbangImmunity(false);
}
flashbang_complete_enable_color()
{
SetSavedDvar( "ai_friendlyFireBlockDuration", 0 );
level.hero_frenchie enable_ai_color();
wait 1.3;
level.hero_lone_star enable_ai_color();
wait 1.3;
level.hero_reno enable_ai_color();
wait 1.3;
level.hero_redshirt enable_ai_color();
SetSavedDvar( "ai_friendlyFireBlockDuration", 2000 );
}
volk_catacombs_escape_volk(anim_ent, volk)
{
volk stop_magic_bullet_shield();
thread lerp_fov_overtime( .1 , 40 );
delayThread(2, ::lerp_fov_overtime, 1.5 , 65 );
anim_ent anim_single_solo_run(volk, "volk_escape");
volk thread volk_change_speed_delay();
volk goto_node(GetNode("node_volk_catacombs_escape", "targetname"), true);
volk notify("stop_fail_if_volk_dies");
scripted_sequence_recon("jank_volk_catacombs_escape_delete", true, volk);
volk Delete();
}
volk_change_speed_delay()
{
self endon("death");
wait 3;
self.moveplaybackrate = 1.3;
wait 2;
self.moveplaybackrate = 1.5;
}
volk_guards_staging_room()
{
thread volk_guard_03_staging_room();
wait 3.5;
guy_1 = getent( "ai_staging_room_volk_guard_1", "script_noteworthy" ) spawn_ai(true);
guy_1 goto_node(GetNode("node_ai_staging_room_volk_guard_1", "targetname"), false);
wait 2;
guy_2 = getent( "ai_staging_room_volk_guard_2", "script_noteworthy" ) spawn_ai(true);
guy_2.ignoreall = true;
guy_2 goto_node(GetNode("node_ai_staging_room_volk_guard_2", "targetname"), true);
volume = getent( "info_v_infrastructure_hall", "targetname" );
if(IsAlive(guy_2))
{
guy_2 SetGoalVolumeAuto(volume);
}
wait 4;
if(IsAlive(guy_2))
{
guy_2.ignoreall = false;
}
}
volk_guard_03_staging_room()
{
wait .45;
guy = getent( "ai_staging_room_volk_guard_3", "script_noteworthy" ) spawn_ai(true);
guy endon("death");
guy.ignoreall = true;
guy goto_node(GetNode("node_ai_staging_room_volk_guard_3", "targetname"), true);
guy.ignoreall = false;
wait 1;
volume = getent( "info_v_infrastructure_hall", "targetname" );
guy ClearGoalVolume();
guy SetGoalVolumeAuto(volume);
}
volk_boiler_room_escape()
{
volk = getent("volk_boiler_room_escape", "script_noteworthy") spawn_ai( true );
level.volk = volk;
scripted_sequence_recon("jank_volk_boiler_room_escape_spawn", true, volk);
volk thread fail_if_volk_dies();
volk.moveplaybackrate = 1.5;
volk deletable_magic_bullet_shield();
volk disable_awareness();
autosave_by_name("boiler_room_escape");
thread escape_timer_countdown(50, &"PARIS_FAIL_VOLK_ESCAPED");
volk goto_node(GetNode("node_volk_boiler_room_escape", "targetname"), true);
initial_speed = ( .85 );
level.player thread lerp_move_speed_scale(initial_speed, 1, 4);
volk notify("stop_fail_if_volk_dies");
scripted_sequence_recon("jank_volk_boiler_room_escape_delete", true, volk);
volk Delete();
flag_set( "flag_volk_boiler_room_escape_complete" );
}
volk_apartment_escape()
{
volk = getent("volk_apartment_escape", "script_noteworthy") spawn_ai( true );
level.volk = volk;
scripted_sequence_recon("jank_volk_apartment_escape_spawn", true, volk);
volk thread fail_if_volk_dies();
volk disable_awareness();
volk goto_node(GetNode("node_volk_apartment_escape", "targetname"), true);
volk notify("stop_fail_if_volk_dies");
scripted_sequence_recon("jank_volk_apartment_escape_delete", true, volk);
volk Delete();
}
fail_if_volk_dies()
{
self endon("stop_fail_if_volk_dies");
self waittill("death");
SetDvar( "ui_deadquote", &"PARIS_FAIL_CAPTURE_VOLK_ALIVE" );
maps\_utility::missionFailedWrapper();
}
catacombs_bomb_3()
{
aud_send_msg("catacombs_bomb_3");
Earthquake( 0.3, 3, level.player.origin, 850 );
org_fx = GetEnt("origin_catacombs_bomb_3", "targetname");
PlayFX(level._effect[ "falling_dirt_catacomb" ], org_fx.origin);
}
combat_catacombs_exit()
{
spawners = getentarray( "ai_catacombs_exit", "script_noteworthy" );
foreach(spawner in spawners)
{
spawner add_spawn_function(::add_enemy_flashlight);
spawner spawn_ai(true);
}
{
waitframe();
}
noteworthies = [
"ai_boiler_room_runners"
, "ai_catacombs_exit"
, "ai_boiler_room"
];
spawn_metrics_waittill_count_reaches(4, noteworthies, true);
flag_set( "flag_ai_boiler_room_runners" );
}
infrastructure_hall_complete()
{
level.hero_lone_star enable_sprint();
level.hero_frenchie enable_sprint();
level.hero_reno enable_sprint();
level.hero_redshirt enable_sprint();
}
allies_in_boiler_room_stop_sprint()
{
level.hero_lone_star disable_sprint();
level.hero_frenchie disable_sprint();
level.hero_reno disable_sprint();
level.hero_redshirt disable_sprint();
}
boiler_room_runners()
{
spawners = getentarray( "ai_boiler_room_runners", "script_noteworthy" );
foreach( spawner in spawners )
{
spawner add_spawn_function(::add_enemy_flashlight);
spawner spawn_ai(true);
}
{
waitframe();
}
noteworthies = [
"ai_boiler_room_runners"
, "ai_catacombs_exit"
, "ai_boiler_room"
];
spawn_metrics_waittill_count_reaches(3, noteworthies, true);
path_squad_with_trigger( "trigger_color_corridor_2", true );
spawn_metrics_waittill_count_reaches(0, noteworthies, true);
path_squad_with_trigger( "trigger_color_corridor_3", true );
thread infrastructure_hall_complete();
}
combat_boiler_room_exit()
{
spawners = getentarray( "ai_boiler_room_exit", "script_noteworthy" );
if(spawners.size > 0)
{
maps\_spawner::flood_spawner_scripted( spawners );
}
}
ai_clean_up_catatombs_exit()
{
flag_wait("flag_chase_gaz_barricade_01");
cleanup_ai_with_script_noteworthy( "enemy_ai_catacombs_exit", 128 );
cleanup_ai_with_script_noteworthy( "enemy_ai_catacombs_exit_flood", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_01", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_01_hind", 128 );
AI_delete_when_out_of_sight([level.hero_redshirt, level.hero_frenchie], 512);
}
chemical_ali_escape()
{
blocker = getent( "blocker_ai_volk_sedan_escape", "targetname" );
blocker DisconnectPaths();
spawners = getentarray( "enemy_ai_catacombs_exit", "script_noteworthy" );
foreach( spawner in spawners )
{
spawner spawn_ai(true);
}
spawners_flood = getentarray( "enemy_ai_catacombs_exit_flood", "script_noteworthy" );
if(spawners_flood.size > 0)
{
maps\_spawner::flood_spawner_scripted( spawners_flood );
}
thread escape_helicopters();
vehicle_1 = GetEnt("ali_convoy_1", "targetname");
vehicle_2 = GetEnt("ali_convoy_2", "targetname");
autosave_by_name("chemical_ali_escape");
thread escape_timer_countdown(45, &"PARIS_FAIL_GET_TO_VAN");
thread ali_convoy_vehicle_1(vehicle_1, vehicle_2);
}
ali_convoy_vehicle_1(vehicle_1, vehicle_2)
{
spawner_ali_guard_02 = getent( "ali_guard_02", "script_noteworthy" );
guard_2 = spawner_ali_guard_02 spawn_ai( true );
volk = getent("chemical_ali", "script_noteworthy") spawn_ai( true );
level.volk = volk;
volk.animname = "volk";
guard_2.animname = "sedan_guard";
if(level.start_point != "chase")
scripted_sequence_recon("jank_volk_enter_car_spawn", true, level.ali_car.origin + (0, 0, 64));
foreach(guy in [volk, guard_2])
{
guy set_ignoreme( true );
guy set_ignoreall( true );
guy disable_pain();
guy enable_sprint();
guy deletable_magic_bullet_shield();
guy wiisetallowragdoll(true);
}
guard_2 LinkTo(level.ali_car, "tag_body", (0, 0, 0), (0, 0, 0));
level.ali_car thread anim_loop_solo(guard_2, "sedan_escape_passengers_loop", "ender", "tag_body");
volk LinkTo(level.ali_car, "tag_body", (0, 0, 0), (0, 0, 0));
scripted_sequence_recon("volk_enter_car", true, volk, 2);
level.ali_car thread anim_single_solo(volk, "sedan_escape", "tag_body");
thread unblock_ai_path_volk_sedan_escape();
thread ali_convoy_vehicle_2(vehicle_1);
thread ali_convoy_vehicle_3(vehicle_2);
delayThread(.75, maps\paris_b_fx::fx_volk_sedan_peelout, level.ali_car);
end_node = GetVehicleNode(level.ali_car.target, "targetname");
aud_send_msg("volk_escape", level.ali_car);
level.ali_car vehicle_scripted_animation(level.ali_car_node, "sedan_escape", true, false, end_node, 1, true);
level.ali_car thread anim_loop_solo(volk, "sedan_escape_loop", "ender", "tag_body");
level.ali_car waittill ( "death" );
if(IsDefined(guard_2)) guard_2 delete();
if(IsDefined(volk)) volk delete();
}
unblock_ai_path_volk_sedan_escape()
{
wait 6;
blocker = getent( "blocker_ai_volk_sedan_escape", "targetname" );
blocker ConnectPaths();
blocker Delete();
}
ali_convoy_vehicle_2(vehicle_1)
{
wait 1.5;
vehicle_1 gopath();
wait 7;
vehicle_1 mgoff();
}
ali_convoy_vehicle_3(vehicle_2)
{
wait 2;
vehicle_2 gopath();
}
escape_helicopters()
{
mi17_amb_01 = spawn_vehicles_from_targetname_and_drive( "mi17_01_escape_ambient" );
aud_send_msg("mi17_01_escape_ambient", mi17_amb_01);
mi17_amb_03 = spawn_vehicles_from_targetname_and_drive( "mi17_03_escape_ambient" );
aud_send_msg("mi17_03_escape_ambient", mi17_amb_03);
wait 2.0;
mi17_drop_01 = spawn_vehicles_from_targetname_and_drive( "mi17_01_escape" );
aud_send_msg("mi17_01_escape", mi17_drop_01);
}
player_rides_bomb_truck()
{
level.player endon("death");
flag_set( "flag_dialogue_in_the_truck" );
flag_set( "spawn_initial_vehicle_wave" );
delete_spawners( "enemy_ai_catacombs_exit_flood" );
thread chase_combat_start();
everyone_enters_truck();
thread maps\paris_b_fx::fx_car_peelout(level.bomb_truck_model);
level.bomb_truck thread gopath();
aud_send_msg("bomb_truck_start", level.bomb_truck);
flag_set( "flag_chase_gaz_barricade_01" );
level.player EnableWeapons();
thread camera_shake_during_ride();
}
ai_enemy_chase_encounter_spawn_function()
{
self enable_sprint();
}
camera_shake_during_ride()
{
level endon("player_exits_bomb_truck");
level.bomb_truck endon("death");
max_mph = 40;
for(;;)
{
mph = Min(level.bomb_truck Vehicle_GetSpeed(), max_mph);
if(mph > 5)
{
intensity = 0.125 * mph / 25;
Earthquake(intensity, 2, level.player.origin, 512);
}
wait RandomFloatRange(.1, .3);
}
}
van_ride_set_view_clamp(time, right, left, top, bottom)
{
AssertEx(IsDefined(level.player_link_ent), "player must be linked to level.player_link_ent");
level.player endon("death");
if(!IsAlive(level.player)) return;
level.player_link_ent.arc_right = right;
level.player_link_ent.arc_left = left;
level.player_link_ent.arc_top = top;
level.player_link_ent.arc_bottom = bottom;
if(level.player IsLinked())
{
level.player notify("stop_adjust_view_fraction_during_ride");
level.player LerpViewAngleClamp(time, time/3, time/3, right, left, top, bottom);
}
else
{
level.player PlayerLinkToBlend(level.player_link_ent, "tag_player", time, time/3, time/3);
}
level.player delayThread(time, ::adjust_view_fraction_during_ride, level.bomb_truck_model, true);
}
adjust_view_fraction_during_ride(vehicle, use_tag_angles)
{
level.player endon("death");
level.player endon("adjust_view_fraction_during_ride_stop");
turn_min_dps = 25;
turn_max_dps = 85;
viewfraction_noads_noturning	= 0.6;
viewfraction_noads_turning = 1.0;
viewfraction_ads_noturning = 0.3;
viewfraction_ads_turning = 1.0;
forward_scale_strength = .2;
level.player notify("stop_adjust_view_fraction_during_ride");
level.player endon("stop_adjust_view_fraction_during_ride");
current_view_fraction = -1;
old_forward_vec = AnglesToForward(vehicle.angles);
for(; self IsLinked(); waitframe())
{
if(IsDefined(self.override_view_fraction))
{
desired_view_fraction = self.override_view_fraction;
desired_view_fraction_tolerance = .0001;
}
else
{
ads_fraction = self PlayerAds();
forward_vec = AnglesToForward(vehicle.angles);
turn_dps = ACos(clamp(VectorDot(forward_vec, old_forward_vec), -1, 1)) * 20;
old_forward_vec = forward_vec;
forward_scale = (-1.0 * VectorDot(forward_vec, AnglesToForward(level.player GetPlayerAngles())) + 1) * 0.5;
forward_scale = linear_map_clamp(forward_scale, 0, 1, 1 - forward_scale_strength, 1);
turn_fraction = clamp((turn_dps - turn_min_dps) / (turn_max_dps - turn_min_dps), 0, 1) * forward_scale;
desired_view_fraction =
linear_interpolate(ads_fraction,
linear_interpolate(turn_fraction, viewfraction_noads_noturning, viewfraction_noads_turning),
linear_interpolate(turn_fraction, viewfraction_ads_noturning, viewfraction_ads_turning));
desired_view_fraction_tolerance = .2;
}
if(abs(desired_view_fraction - current_view_fraction) >= desired_view_fraction_tolerance)
{
self PlayerLinkToDelta(level.player_link_ent, "tag_origin", desired_view_fraction, level.player_link_ent.arc_right, level.player_link_ent.arc_left, level.player_link_ent.arc_top, level.player_link_ent.arc_bottom, use_tag_angles);
current_view_fraction = desired_view_fraction;
}
}
}
van_ride_stop_adjusting_view_clamp()
{
level.player notify("adjust_view_fraction_during_ride_stop");
}
chase_combat_start()
{
flag_wait( "flag_player_in_truck" );
triggers = GetEntArray( "trigger_chase_scripting_on", "targetname" );
foreach(trigger in triggers)
{
trigger trigger_on();
}
wait 2;
guy_1 = getent( "ai_enemy_1_chase_shoot_at_van", "script_noteworthy" ) spawn_ai(true);
spawners = getentarray( "ai_enemy_2_chase_shoot_at_van", "script_noteworthy" );
foreach( spawner in spawners )
{
guys = spawner spawn_ai(true);
guys enable_sprint();
guys wiisetallowragdoll(true);
}
spawners = getentarray( "ai_enemy_5_chase_shoot_at_van", "script_noteworthy" );
wait 1;
foreach( spawner in spawners )
{
guys = spawner spawn_ai(true);
guys enable_sprint();
guys set_ignoreall (true);
guys set_ignoreme (true);
}
wait 2;
fake_rpg_chase_1();
wait 5;
guy_3 = getent( "ai_enemy_3_chase_shoot_at_van", "script_noteworthy" ) spawn_ai(true);
guy_4 = getent( "ai_enemy_4_chase_shoot_at_van", "script_noteworthy" ) spawn_ai(true);
}
chase_uaz_01()
{
flag_wait( "chase_uaz_01" );
wait 1;
aud_send_msg("chase_uaz_01");
gaz = spawn_vehicle_from_targetname_and_drive( "chase_uaz_01" );
gaz endon("death");
gaz godon();
wait 3;
gaz godoff();
aud_send_msg("gaz_death", gaz);
flag_wait( "flag_chase_fake_rpg_2" );
gaz mgoff();
}
chase_gaz_02()
{
flag_wait("flag_ai_enemy_chase_encounter_04");
gaz = spawn_vehicle_from_targetname( "gaz_chase_3" );
flag_wait( "flag_gaz_chase_2" );
gaz gopath();
aud_send_msg("chase_gaz_02", gaz);
gaz thread paris_vehicle_death();
gaz thread change_turret_accuracy_over_time( 5, 3, 3 );
aud_send_msg("gaz_death", gaz);
}
chase_vehicles_initial_combat()
{
flag_wait( "spawn_initial_vehicle_wave" );
wait 1.0;
spawn_vehicles_from_targetname_and_drive( "chase_uaz_initial_02" );
wait 6.0;
spawn_vehicles_from_targetname_and_drive( "chase_uaz_initial_03" );
}
fake_rpg_chase_1()
{
fake_rpg_start = getstruct( "org_start_fake_rpg_1", "targetname" );
fake_rpg_target = getstruct( "org_target_fake_rpg_1", "targetname" );
repulsor = Missile_CreateRepulsorEnt( level.player, 1000, 512 );
rpg = MagicBullet( "rpg_straight", fake_rpg_start.origin, fake_rpg_target.origin );
aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
aud_send_msg("aud_rpg_3d_short", aud_data);
}
tank_stairway_moment()
{
flag_wait("spawn_tank_01");
level.tank_01 = spawn_vehicle_from_targetname ("tank_01");
level.tank_01.animname = "tank";
level.tank_01 godon();
level.tank_01 mgoff();
addforcestreamxmodel("vehicle_t72_tank_pc");
level.tank_01 gopath();
level.tank_01 thread tank_fire_control();
aud_send_msg("pars_chase_tank_start");
sedan = getent("tank_crush_sedan", "script_noteworthy");
sedan.animname = "sedan";
sedan SetAnimTree();
end_node = GetVehicleNode("tank_crush_end_node", "script_noteworthy");
level.tank_01 vehicle_scripted_animation_wait(sedan, "tank_crush");
aud_send_msg("pars_chase_tank_smash");
level.tank_01 notify("start_aiming_at_player");
level.tank_01 thread vehicle_scripted_animation(sedan, "tank_crush", true, false, end_node, 1.07, true);
sedan thread anim_single_solo(sedan, "tank_crush");
sedan thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.1 );
sedan thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.1 );
sedan thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.05 );
sedan thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.2 );
wait 1.25;
level.hero_lone_star thread lonestar_anim_scripted("van_ride_lightslam_left");
wait 2;
level.hero_lone_star thread lonestar_anim_scripted("van_ride_hardslam_left");
thread tank_stairway_destruction();
thread van_slam_storefront_01();
flag_wait( "flag_ai_enemy_chase_encounter_04" );
removeforcestreamxmodel("vehicle_t72_tank_pc");
waitframe();
level.tank_01 delete();
}
van_climb_paired_moment()
{
flag_wait("flag_van_climb_paired_moment");
wait 1.75;
guy = GetEnt_safe("van_climb_paired_guy", "script_noteworthy") spawn_ai(true);
guy_anim_ent = spawn_tag_origin();
guy_anim_ent.origin = level.bomb_truck_model GetTagOrigin("tag_guy");
guy_anim_ent.angles = level.bomb_truck_model GetTagAngles("tag_guy");
animlength = GetAnimLength(guy getanim_generic("van_climb_paired"));
guy.forceragdollimmediate = true;
guy.deathFunction = ::van_climb_paired_deathfunc;
scripted_sequence_recon("van_climb_paired", true, guy, 2);
level.hero_lone_star thread lonestar_anim_scripted("van_climb_paired");
guy thread van_climb_paired_guy_filter_damage();
guy_anim_ent thread anim_generic(guy, "van_climb_paired", "tag_origin");
end_early_time = 1.2;
wait animlength - end_early_time;
if(IsAlive(guy))
{
guy.allowdeath = true;
guy Kill();
}
wait end_early_time;
delayThread(4, ::flag_set, "flag_tank_moment_ai_move_up");
flag_set( "flag_van_climb_paired_done" );
delayThread(1, ::force_save);
}
van_climb_paired_guy_filter_damage()
{
self endon("death");
Assert(IsAI(self));
for(;;)
{
self waittill( "damage", amount, attacker, direction, position, damage_type );
if(attacker == level.player)
{
self.allowdeath = true;
self.deathFunction = undefined;
self Kill();
}
}
}
force_save()
{
level.player EnableInvulnerability();
level.player.health = level.player.maxhealth;
thread autosave_now();
wait 3;
level.player DisableInvulnerability();
}
van_climb_paired_deathfunc()
{
self animscripts\shared::DropAllAIWeapons();
self StartRagdoll();
wait 1;
}
tank_fire_control()
{
level.tank_01 thread vehicle_turret_scan_off();
self thread tank_hold_turret_fixed( -2, -40 );
self waittill("start_aiming_at_player");
self notify("stop_tank_hold_turret_fixed");
fire_target = GetEnt("origin_tank_01_fire_over_player", "targetname");
level.tank_01 tank_aim_turret(fire_target, (0, 0, 0), 3);
level.tank_01 SetTurretTargetEnt(fire_target);
flag_wait("tank_01_fire_over_player");
level.player PlayRumbleOnEntity( "heavy_2s" );
thread camera_shake_small();
thread maps\paris_b_fx::fx_tank_chasefire_1(level.tank_01);
aud_send_msg("pars_chase_tank_shoot_01");
level.tank_01 mgon();
wait 3;
fire_target_2 = GetEnt("origin_tank_02_fire_over_player", "targetname");
level.tank_01 SetTurretTargetEnt(fire_target_2);
wait 2.5;
thread maps\paris_b_fx::fx_tank_chasefire_2(level.tank_01);
aud_send_msg("pars_chase_tank_shoot_02");
wait(0.3);
aud_send_msg("pars_chase_tank_impact_02");
Earthquake( 0.3, 3, level.player.origin, 850 );
level.player PlayRumbleOnEntity( "heavy_3s" );
level.tank_01 godoff();
}
tank_aim_turret_local(local_turret_angles)
{
turret_origin = self GetTagOrigin("tag_turret");
global_turret_angles = CombineAngles(self.angles, local_turret_angles);
self SetTurretTargetVec(turret_origin + 100000 * AnglesToForward(global_turret_angles));
}
tank_get_local_turret_angles_for_target(target_origin)
{
turret_origin = self GetTagOrigin("tag_turret");
global_turret_angles = VectorToAngles(target_origin - turret_origin);
result = TransformMove((0, 0, 0), (0, 0, 0), self.origin, self.angles, turret_origin, global_turret_angles);
return result["angles"];
}
tank_get_local_turret_angles()
{
result = TransformMove((0, 0, 0), (0, 0, 0), self.origin, self.angles, self GetTagOrigin("tag_turret"), self GetTagAngles("tag_turret"));
return result["angles"];
}
tank_aim_turret(entity, offset, arrival_time)
{
end_msec = GetTime() + arrival_time * 1000;
while(1)
{
seconds_left = (end_msec - GetTime()) / 1000;
target_origin = (0, 0, 0);
if(IsDefined(offset)) target_origin += offset;
if(IsDefined(entity) && IsDefined(entity.origin)) target_origin += entity.origin;
current_local_angles = tank_get_local_turret_angles();
target_local_angles = tank_get_local_turret_angles_for_target(target_origin);
fraction = clamp(0.05 / max(seconds_left, 0.05), 0, 1);
goal_angles = euler_lerp(current_local_angles, target_local_angles, fraction);
self tank_aim_turret_local(goal_angles);
if(seconds_left < 0)
return;
waitframe();
}
}
tank_hold_turret_fixed(pitch, yaw)
{
self endon("stop_tank_hold_turret_fixed");
for(;; waitframe())
{
self tank_aim_turret_local((pitch, yaw, 0));
}
}
tank_stairway_destruction()
{
}
van_slam_storefront_01()
{
flag_wait( "flag_van_slam_storefront_01" );
level.bomb_truck.script_badplace = false;
aud_send_msg("van_slam_storefront_01");
wait 0.1;
level.player PlayRumbleOnEntity( "heavy_2s" );
Earthquake( 0.5, .5, level.player.origin, 850 );
setblur(2.0, 0.1);
wait .3;
setblur(0, 0.2);
aud_send_msg("start_engine_03");
fx_targets = GetEntArray("origin_van_slam_storefront_01", "targetname");
foreach(fx_targets in fx_targets)
{
aud_send_msg("van_storefront_destroy_glass",fx_targets.origin);
}
}
pre_canal_combat()
{
flag_wait( "flag_ai_enemy_chase_encounter_04" );
array_spawn_noteworthy("ai_enemy_chase_encounter_04", true);
array_spawn_noteworthy("ai_enemy_chase_encounter_04_runners", true);
}
spawn_gaz_02()
{
flag_wait("spawn_gaz_02");
spawners = getentarray( "ai_enemy_chase_tank_moment", "script_noteworthy" );
gaz = spawn_vehicle_from_targetname ("gaz_02");
gaz thread paris_vehicle_death();
aud_send_msg("gaz_death", gaz);
flag_wait("flag_gaz_02_gopath");
foreach( spawner in spawners )
{
guys = spawner spawn_ai(true);
}
wait 9;
gaz gopath();
gaz thread change_turret_accuracy_over_time( 13, 4, 4 );
}
canal_combat_01()
{
flag_wait( "flag_canal_combat_01" );
spawners = getentarray( "ai_enemy_chase_encounter_05", "script_noteworthy" );
foreach( spawner in spawners )
{
guy = spawner spawn_ai(true);
}
}
canal_runners_01()
{
flag_wait( "flag_canal_runners_01" );
spawners = getentarray( "ai_enemy_chase_encounter_06", "script_noteworthy" );
foreach( spawner in spawners )
{
guy = spawner spawn_ai(true);
}
}
canal_combat_02()
{
flag_wait( "flag_canal_combat_02" );
spawners = getentarray( "ai_enemy_chase_encounter_07", "script_noteworthy" );
foreach( spawner in spawners )
{
guy = spawner spawn_ai(true);
guy enable_sprint();
}
}
river_moment()
{
blocker = getent( "blocker_path_canal_end", "targetname" );
blocker DisconnectPaths();
gaz = spawn_vehicle_from_targetname_and_drive ("chase_canal_uaz_01");
gaz thread paris_vehicle_death();
gaz thread change_turret_accuracy_over_time( 7, 2, 8.5 );
aud_send_msg("gaz_death", gaz);
}
uaz_jump_bridge()
{
flag_wait( "flag_chase_canal_uaz_02" );
gaz = spawn_vehicle_from_targetname_and_drive( "chase_canal_uaz_02" );
gaz endon ( "death" );
aud_send_msg("uaz_jump_bridge", gaz);
aud_send_msg("gaz_death", gaz);
gaz thread paris_vehicle_death();
gaz mgoff();
wait 3;
gaz mgon();
gaz thread change_turret_accuracy_over_time( 10, 5, 7.5 );
}
fake_rpg_chase_2()
{
flag_wait( "flag_chase_fake_rpg_2" );
fake_rpg_start_1 = getstruct( "org_start_fake_rpg_2", "targetname" );
fake_rpg_target_1 = getstruct( "org_target_fake_rpg_2", "targetname" );
fake_rpg_start_2 = getstruct( "org_start_fake_rpg_3", "targetname" );
fake_rpg_target_2 = getstruct( "org_target_fake_rpg_3", "targetname" );
repulsor = Missile_CreateRepulsorEnt( level.tank_01, 1000, 512 );
rpg_1 = MagicBullet( "rpg_straight", fake_rpg_start_1.origin, fake_rpg_target_1.origin );
aud_data_01 = [rpg_1, fake_rpg_start_1.origin, fake_rpg_target_1.origin];
aud_send_msg("aud_rpg_2d", aud_data_01);
wait 1;
rpg_2 = MagicBullet( "rpg_straight", fake_rpg_start_2.origin, fake_rpg_target_2.origin );
aud_data_02 = [rpg_2, fake_rpg_start_2.origin, fake_rpg_target_2.origin];
aud_send_msg("aud_rpg_3d", aud_data_02);
}
ai_clean_up_pre_stairs()
{
flag_wait( "kill_ai_enemy_chase_encounter_02" );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_02", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_gaz_1", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_gaz_2", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_gaz_3", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_03", 128 );
}
ai_clean_up_post_stairs()
{
flag_wait("flag_gaz_02_gopath");
cleanup_ai_with_script_noteworthy("ai_enemy_1_chase_shoot_at_van");
cleanup_ai_with_script_noteworthy("ai_enemy_2_chase_shoot_at_van");
cleanup_ai_with_script_noteworthy("ai_enemy_3_chase_shoot_at_van");
cleanup_ai_with_script_noteworthy("ai_enemy_4_chase_shoot_at_van");
cleanup_ai_with_script_noteworthy("ai_enemy_5_chase_shoot_at_van");
}
fake_rpg_chase_3()
{
flag_wait( "kill_ai_enemy_chase_encounter_02" );
flag_set( "flag_dialogue_tank_targeting_us" );
fake_rpg_start = getstruct( "org_start_fake_rpg_4", "targetname" );
fake_rpg_target = getstruct( "org_target_fake_rpg_4", "targetname" );
repulsor = Missile_CreateRepulsorEnt( level.player, 1000, 512 );
rpg = MagicBullet( "rpg_straight", fake_rpg_start.origin, fake_rpg_target.origin );
aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
aud_send_msg("aud_rpg_3d", aud_data);
}
fake_rpg_chase_4()
{
flag_wait( "spawn_tank_02" );
wait 2;
fake_rpg_start = getstruct( "org_start_fake_rpg_5", "targetname" );
fake_rpg_target = getstruct( "org_target_fake_rpg_5", "targetname" );
repulsor = Missile_CreateRepulsorEnt( level.player, 1000, 512 );
rpg = MagicBullet( "rpg", fake_rpg_start.origin, fake_rpg_target.origin );
aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
aud_send_msg("aud_rpg_3d", aud_data);
wait 2;
fake_rpg_start = getstruct( "org_start_fake_rpg_6", "targetname" );
fake_rpg_target = getstruct( "org_target_fake_rpg_6", "targetname" );
repulsor = Missile_CreateRepulsorEnt( level.player, 1000, 512 );
rpg = MagicBullet( "rpg", fake_rpg_start.origin, fake_rpg_target.origin );
aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
aud_send_msg("aud_rpg_3d", aud_data);
}
ai_clean_up_canal()
{
flag_wait( "kill_ai_enemy_chase_encounter_04" );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_04", 128 );
}
ai_clean_up_mid_canal()
{
flag_wait( "kill_ai_enemy_chase_encounter_04_runners" );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_04_runners", 128 );
}
ai_clean_up_post_canal()
{
flag_wait( "kill_ai_enemy_chase_encounter_05" );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_05", 128 );
cleanup_ai_with_script_noteworthy( "ai_enemy_chase_encounter_06", 128 );
cleanup_ai_with_script_noteworthy("ai_enemy_chase_gaz_4");
cleanup_ai_with_script_noteworthy("ai_enemy_chase_encounter_mid_canal");
}
ai_clean_up_galleria()
{
flag_wait("flag_ai_clean_up_galleria");
cleanup_ai_with_script_noteworthy("ai_enemy_chase_encounter_07");
}
heli_post_river_moment()
{
flag_wait("flag_heli_post_river");
heli = vehicle_spawn(GetEnt("heli_post_river", "script_noteworthy"));
heli godon();
Missile_CreateRepulsorEnt( heli, 7500, 1500 );
heli SetAirResistance(10);
heli SetJitterParams((30, 30, 20), .5, 1.5);
heli SetMaxPitchRoll(30, 30);
heli.script_vehicle_selfremove = 1;
heli gopath();
aud_send_msg("paris_b_chase_hind_spawn", heli);
thread heli_canal_pass_01(heli);
thread heli_canal_pass_02(heli);
thread heli_canal_pass_03(heli);
thread heli_canal_pass_04(heli);
flag_wait("flag_uaz_post_river");
uaz = vehicle_spawn(GetEnt("uaz_post_river", "script_noteworthy"));
uaz gopath();
brush = getent_safe( "brush_gallery", "targetname" );
brush Delete();
flag_wait("flag_heli_post_river_starts_shooting");
level.player EnableDeathShield(true);
target_start = GetStruct("heli_post_river_target_start", "script_noteworthy");
target_end = GetStruct("heli_post_river_target_end", "script_noteworthy");
heli thread heli_shooting(target_start.origin, target_end.origin, 6);
wait 5.5;
level.player EnableDeathShield(false);
}
heli_canal_pass_01(heli)
{
flag_wait("flag_heli_canal_pass_01");
target_start = GetStruct("heli_river_target_04_start", "script_noteworthy");
target_end = GetStruct("heli_river_target_04_end", "script_noteworthy");
heli thread heli_shooting(target_start.origin, target_end.origin, 1.25);
}
heli_canal_pass_02(heli)
{
flag_wait("flag_heli_canal_pass_02");
target_start = GetStruct("heli_river_target_01_start", "script_noteworthy");
target_end = GetStruct("heli_river_target_01_end", "script_noteworthy");
heli thread heli_shooting(target_start.origin, target_end.origin, 2.5);
}
heli_canal_pass_03(heli)
{
flag_wait("flag_heli_canal_pass_03");
target_start = GetStruct("heli_river_target_02_start", "script_noteworthy");
target_end = GetStruct("heli_river_target_02_end", "script_noteworthy");
heli thread heli_shooting(target_start.origin, target_end.origin, 1.75);
}
heli_canal_pass_04(heli)
{
flag_wait("flag_heli_canal_pass_04");
target_start = GetStruct("heli_river_target_03_start", "script_noteworthy");
target_end = GetStruct("heli_river_target_03_end", "script_noteworthy");
heli thread heli_shooting(target_start.origin, target_end.origin, 1);
level.player delaycall( 1.0, ::playrumbleonentity, "viewmodel_large" );
}
heli_shooting(target_start_origin, target_end_origin, duration)
{
self endon("death");
weapon_name = "chopper_gunner_minigun_paris";
self SetVehWeapon(weapon_name);
duration_msec = duration * 1000;
rounds_per_min = 1000;
fire_period = 60 / rounds_per_min;
start_msec = GetTime();
for(i = 0; ; i++)
{
elapsed_msec = GetTime() - start_msec;
if(elapsed_msec > duration_msec)
break;
gun_pos = self GetTagOrigin("tag_flash");
shoot_pos = linear_interpolate(elapsed_msec / duration_msec, target_start_origin, target_end_origin);
shoot_dir = VectorNormalize(shoot_pos - gun_pos);
advanced_gun_pos = gun_pos + shoot_dir * 64;
shoot_pos_noisy = shoot_pos + flat_origin(randomvector(64));
self SetTurretTargetVec(shoot_pos_noisy);
hind_bullet = MagicBullet(weapon_name, advanced_gun_pos, shoot_pos_noisy);
aud_send_msg("chase_hind_fire", self);
aud_send_msg("chase_hind_bullet_impact", hind_bullet);
PlayFXOnTag( getfx( "bmp_flash_wv" ), self, "tag_flash" );
if(i % 5 == 0)
{
direction = VectorNormalize(shoot_pos_noisy - advanced_gun_pos);
start = shoot_pos_noisy - direction * 128;
end = shoot_pos_noisy + direction * 2048;
result = BulletTrace(start, end, false, false);
if(IsDefined(result["position"]))
{
PlayFX(getfx("heli_strafe_impact"), result["position"]);
}
}
wait fire_period;
}
self ClearTurretTarget();
}
gallery_gate_crash_enter()
{
flag_wait( "flag_gallery_gate_enter" );
thread camera_shake_default();
level.player PlayRumbleOnEntity( "viewmodel_medium" );
thread gallery_van_collides_with_props();
}
gallery_van_collides_with_props()
{
flag_wait( "flag_gallery_van_hits_props_01" );
thread maps\paris_b_fx::fx_behindview_impact_planters();
flag_wait( "flag_gallery_van_hits_props_02" );
thread maps\paris_b_fx::fx_behindview_impact_diningset();
flag_wait( "flag_gallery_van_hits_props_03" );
thread maps\paris_b_fx::fx_behindview_impact_topiaryleft();
flag_wait( "flag_gallery_van_hits_props_04" );
thread maps\paris_b_fx::fx_behindview_impact_topiaryright();
flag_wait( "flag_gallery_van_hits_props_05" );
thread maps\paris_b_fx::fx_behindview_impact_diningset();
flag_wait( "flag_gallery_van_hits_props_06" );
thread maps\paris_b_fx::fx_behindview_impact_topiaryleft();
flag_wait( "flag_gallery_van_hits_props_07" );
thread maps\paris_b_fx::fx_behindview_impact_topiaryright();
flag_wait( "flag_gallery_van_hits_props_08" );
thread maps\paris_b_fx::fx_behindview_impact_topiaryright();
}
player_to_front_of_truck()
{
flag_wait( "flag_player_to_the_front" );
aud_send_msg("player_to_front_of_truck");
player_rig = create_player_rig(level.bomb_truck_model, "tag_passenger", "player_back_to_front");
level.player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(1, 0, 0, 0, 0);
level.player player_control_off();
level.player player_reload_silently();
level.player delayCall(.25, ::HideViewModel);
player_rig delayCall(.25, ::Show);
level.bomb_truck_model anim_single_solo(player_rig, "player_back_to_front", "tag_passenger");
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_passenger", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(1, 105, 100, 40, 40);
player_rig Delete();
level.player EnableWeapons();
level.player ShowViewModel();
flag_set( "flag_player_to_the_front_complete" );
}
gallery_gate_crash_exit()
{
flag_wait( "flag_gallery_gate_exit" );
thread camera_shake_default();
level.player PlayRumbleOnEntity( "heavy_1s" );
aud_send_msg("gallery_gate_crash_exit");
}
gaz_chase_ending()
{
self endon("death");
gaz = spawn_vehicle_from_targetname_and_drive( "gaz_01_volk_chase" );
gaz thread paris_vehicle_death();
aud_send_msg("gaz_death", gaz);
gaz.animname = "gaz";
anim_ent = getstruct("struct_escort_gaz_crash", "script_noteworthy");
gaz vehicle_scripted_animation_wait(anim_ent, "escort_gaz_crash");
gaz thread vehicle_scripted_animation(anim_ent, "escort_gaz_crash", true, false, undefined, 1.25, true);
gaz Vehicle_Teleport(gaz.origin, gaz.angles);
}
final_crash_moment_vehicle_animations()
{
flag_wait( "flag_player_to_the_front" );
flag_init("flag_final_crash_slowmo_start");
thread battlechatter_off( "axis" );
thread battlechatter_off( "allies" );
flag_init("flag_final_crash_slowmo_end");
flag_init("flag_final_crash_must_kill_guards");
flag_init("flag_final_crash_guards_dead");
final_crash_moment_npc_cleanup();
removeforcestreamxmodel("vehicle_gaz_tigr_harbor_pb");
level.escape_sedan = spawn_vehicle_from_targetname_and_drive( "car_volk_chase" );
escape_sedan = level.escape_sedan;
escape_sedan.animname = "escape_sedan";
escape_sedan HidePart("tag_origin");
escape_sedan_model = escape_sedan vehicle_to_dummy();
level.escape_sedan_model = escape_sedan_model;
escape_sedan_model.animname = escape_sedan.animname;
escape_sedan_model LinkTo(escape_sedan, "tag_body");
escape_sedan_model.animname = "escape_sedan";
escape_sedan hide_destruct_parts();
escape_sedan_model hide_destruct_parts();
volk_spawner = GetEnt_safe("chemical_ali", "script_noteworthy");
volk_spawner.count++;
volk = volk_spawner spawn_ai(true);
volk.takedamage = false;
volk magic_bullet_shield();
volk.health = 5;
level.volk = volk;
volk gun_remove();
volk.animname = "volk";
thread final_crash_breach(volk);
anim_ent = GetStruct("struct_final_crash_start", "script_noteworthy");
thread final_crash_moment_check();
level.bomb_truck vehicle_scripted_animation_wait(anim_ent, "chase_final_crash");
if(!flag("flag_player_shot_sedan_ending"))
{
failure_did_not_shoot();
return;
}
flag_set("flag_final_crash_begin");
thread final_crash_moment_player();
level.bomb_truck Vehicle_SetSpeedImmediate(0, 100, 100);
duration = .5;
sedan_anim = escape_sedan getanim("chase_final_crash");
sedan_anim_ent = (escape_sedan_model create_anim_ent_for_my_position(sedan_anim)) spawn_tag_origin();
escape_sedan_model LinkTo(sedan_anim_ent, "tag_origin", (0, 0, 0), (0, 0, 0));
escape_sedan_model AnimScripted("animdone", sedan_anim_ent.origin, sedan_anim_ent.angles, sedan_anim);
sedan_anim_ent thread animscriptDoNoteTracksThread(escape_sedan_model, "animdone", "chase_final_crash");
sedan_anim_ent thread start_notetrack_wait(escape_sedan_model, "animdone", "chase_final_crash", "escape_sedan");
sedan_anim_ent MoveTo(anim_ent.origin, duration, duration / 4, duration / 4);
sedan_anim_ent RotateTo(anim_ent.angles, duration, duration / 4, duration / 4);
level.bomb_truck_model Unlink();
truck_anim = level.bomb_truck getanim("chase_final_crash");
truck_anim_ent = (level.bomb_truck_model create_anim_ent_for_my_position(truck_anim)) spawn_tag_origin();
level.bomb_truck_model LinkTo(truck_anim_ent, "tag_origin", (0, 0, 0), (0, 0, 0));
level.bomb_truck_model AnimScripted("animdone", truck_anim_ent.origin, truck_anim_ent.angles, truck_anim, "normal", level.bomb_truck.animscripted_root);
truck_anim_ent thread animscriptDoNoteTracksThread(level.bomb_truck_model, "animdone", "chase_final_crash");
truck_anim_ent thread start_notetrack_wait(level.bomb_truck_model, "animdone", "chase_final_crash", "bomb_truck");
truck_anim_ent MoveTo(anim_ent.origin, duration, duration / 4, duration / 4);
truck_anim_ent RotateTo(anim_ent.angles, duration, duration / 4, duration / 4);
anim_ent thread anim_single_solo(level.final_crash_fence, "chase_final_crash");
level.bomb_truck vehicle_scripted_animation(anim_ent, "chase_final_crash", true, false, undefined, 1, true);
level.bomb_truck Vehicle_Teleport(level.bomb_truck.origin, level.bomb_truck.angles);
level.bomb_truck notify( "newpath" );
}
final_crash_moment_npc_cleanup()
{
foreach(guy in GetAIArray("axis", "neutral"))
{
if(!IsDefined(guy.magic_bullet_shield) || !guy.magic_bullet_shield)
{
guy Delete();
}
}
}
hide_destruct_parts()
{
destruct_parts = [ "hitA", "hitB", "hitC", "hitD", "trunk",
"TAG_GLASS_BACK", "TAG_GLASS_FRONT", "TAG_GLASS_LEFT_FRONT", "TAG_GLASS_LEFT_BACK", "TAG_GLASS_RIGHT_FRONT", "TAG_GLASS_RIGHT_BACK", "TAG_GLASS_ROOF",
"wheel_A_KL", "wheel_A_KR", "wheel_A_FL", "wheel_A_FR",
"doorC_FL", "doorC_KL", "doorC_FR", "doorC_KR" ];
foreach ( part in destruct_parts )
{
self HidePart( part + "_D" );
}
}
final_crash_moment_player()
{
level.player endon("death");
player_rig = create_player_rig(level.bomb_truck_model, "tag_passenger", "chase_final_crash");
level.player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 0), (0, 0, 0));
player_rig thread final_crash_moment_player_notetracks();
level.bomb_truck_model anim_single_solo(player_rig, "chase_final_crash", "tag_passenger");
player_rig Delete();
}
final_crash_moment_player_notetracks()
{
level.player endon("death");
thread final_crash_moment_fail_notetrack();
level.player.override_view_fraction = 1;
van_ride_set_view_clamp(1, 50, 50, 40, 40);
self waittillmatch("single anim", "slomo_start");
level.player player_reload_silently(1);
flag_set("flag_final_crash_slowmo_start");
level.player.override_view_fraction = 0;
thread show_rig_when_guards_dead();
self waittillmatch("single anim", "slomo_end");
flag_set("flag_final_crash_slowmo_end");
flag_set("flag_final_crash_must_kill_guards");
}
show_rig_when_guards_dead()
{
level.player endon("death");
flag_wait("flag_final_crash_guards_dead");
hud_off();
level.player DisableWeapons();
van_ride_set_view_clamp(.5, 0, 0, 0, 0);
wait .5;
self Show();
level.player.override_view_fraction = 1;
}
final_crash_moment_fail_notetrack()
{
self waittillmatch("single anim", "slomo_fail");
flag_set("flag_final_crash_must_kill_guards");
}
final_crash_moment_check()
{
while(1)
{
level.escape_sedan waittill("damage", amount, attacker, direction_vec, point, type, modelName, tagName);
if(IsDefined(attacker) && attacker == level.player && IsDefined(type) && type != "MOD_IMPACT" && type != "MOD_GRENADE" && type != "MOD_GRENADE_SPLASH")
break;
}
if(flag("flag_failure_did_not_shoot"))
return;
flag_set( "flag_player_shot_sedan_ending" );
thread maps\paris_b_fx::fx_sedan_damaged(level.escape_sedan_model);
thread final_crash_moment_spinning();
}
final_crash_moment_spinning()
{
yaw_offset_ramp_time = .1;
yaw_oscillation_ramp_time = .5;
yaw_offset = -4;
yaw_amplitude = 8;
yaw_frequency = .8;
yaw_init_phase = 180;
pitch_offset = 3;
pitch_offset_ramp_time = 1;
roll_coupling = .5;
local_offset = -1 * (level.escape_sedan WorldToLocalCoords(level.escape_sedan GetTagOrigin("tag_body")));
dt = 0.05;
t = 0;
while(!flag("flag_final_crash_begin"))
{
yaw =
linear_map_clamp(t, 0, yaw_offset_ramp_time, 0, 1) * yaw_offset +
linear_map_clamp(t, 0, yaw_oscillation_ramp_time, 0, 1) * yaw_amplitude * Cos(t * 360 * yaw_frequency + yaw_init_phase);
pitch = linear_map_clamp(t, 0, pitch_offset_ramp_time, 0, 1) * pitch_offset;
roll = yaw * roll_coupling;
level.escape_sedan_model LinkTo(level.escape_sedan, "tag_body", local_offset, (pitch, yaw, roll));
t += dt;
waitframe();
}
}
failure_did_not_shoot()
{
flag_set("flag_failure_did_not_shoot");
wait 4;
SetDvar( "ui_deadquote", &"PARIS_FAIL_SHOOT_VOLKS_CAR" );
maps\_utility::missionFailedWrapper();
level waittill("forever");
}
final_crash_breach(volk)
{
driver = getent_safe("volk_sedan_ending_driver", "script_noteworthy") spawn_ai(true);
guard_r = getent_safe("volk_sedan_ending_guard_r", "script_noteworthy") spawn_ai(true);
guard_l = getent_safe("volk_sedan_ending_guard_l", "script_noteworthy") spawn_ai(true);
driver wiisetallowragdoll( true );
guard_r wiisetallowragdoll( true );
guard_l wiisetallowragdoll( true );
driver thread final_crash_moment_driver();
guard_r thread final_crash_moment_guard_right();
guard_l thread final_crash_moment_guard_left();
driver setcanradiusdamage(false);
guard_l setcanradiusdamage(false);
guard_r setcanradiusdamage(false);
volk thread final_crash_moment_volk();
flag_wait("flag_final_crash_slowmo_start");
volk thread fail_if_volk_dies();
volk.allowdeath = true;
volk.takedamage = true;
volk stop_magic_bullet_shield();
volk.deathFunction = ::death_do_nohing;
thread final_crash_breach_slowmo();
success = false;
for(;;)
{
alive_count = 0;
if(IsAlive(driver) && !IsDefined(driver.fake_death)) alive_count++;
if(IsAlive(guard_r) && !IsDefined(guard_r.fake_death)) alive_count++;
if(IsAlive(guard_l) && !IsDefined(guard_l.fake_death)) alive_count++;
if(alive_count < 2)
{
success = true;
break;
}
if(flag("flag_final_crash_must_kill_guards"))
{
break;
}
waitframe();
}
if(success)
{
flag_set("flag_final_crash_guards_dead");
foreach(guy in [driver, guard_r, guard_l])
{
if(IsAlive(guy))
guy delayCall(.3, ::DoDamage, guy.health, guy.origin);
}
}
else
{
SetDvar("ui_deadquote", "");
van_ride_set_view_clamp(.2, 30, 30, 30, 30);
volk notify("stop_fail_if_volk_dies");
guy = undefined;
if(IsAlive(guard_r)) guy = guard_r;
if(IsAlive(guard_l)) guy = guard_l;
if(IsDefined(guy))
{
delay = .05;
shots = 10;
for(i = 0; i < shots && IsAlive(guy); i++)
{
tag_flash_origin = guy GetTagOrigin("tag_flash");
MagicBullet(guy.weapon, tag_flash_origin, level.player GetShootAtPos());
level.player DoDamage(20, tag_flash_origin, guy);
wait(delay);
}
}
level.player Kill();
waitframe();
maps\_utility::missionFailedWrapper();
level waittill("forever");
}
}
final_crash_breach_slowmo()
{
SoundSetTimeScaleFactor( "Music", 0 );
SoundSetTimeScaleFactor( "Menu", 0 );
SoundSetTimeScaleFactor( "local3", 0.0 );
SoundSetTimeScaleFactor( "Mission", 0.0 );
SoundSetTimeScaleFactor( "Announcer", 0.0 );
SoundSetTimeScaleFactor( "Bulletimpact", .60 );
SoundSetTimeScaleFactor( "Voice", 0.40 );
SoundSetTimeScaleFactor( "effects2", 0.20 );
SoundSetTimeScaleFactor( "local", 0.40 );
SoundSetTimeScaleFactor( "physics", 0.20 );
SoundSetTimeScaleFactor( "ambient", 0.50 );
SoundSetTimeScaleFactor( "auto", 0.50 );
slowmobreachduration = 4;
slomoLerpTime_in = 0.25;
slomoLerpTime_out = 0.75;
slomobreachplayerspeed = 0.2;
player = level.player;
player thread play_sound_on_entity( "slomo_whoosh" );
player thread player_heartbeat();
thread slomo_breach_vision_change( ( slomoLerpTime_in * 2 ), ( slomoLerpTime_out / 2 ) );
thread slomo_difficulty_dvars();
slowmo_start();
player AllowMelee( false );
slowmo_setspeed_slow( 0.2 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
flag_wait("flag_final_crash_slowmo_end");
level notify( "stop_player_heartbeat" );
player thread play_sound_on_entity( "slomo_whoosh" );
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
player AllowMelee( true );
slowmo_end();
}
player_heartbeat()
{
level endon( "stop_player_heartbeat" );
while ( true )
{
self PlayLocalSound( "breathing_heartbeat" );
wait .5;
}
}
slomo_difficulty_dvars()
{
old_bg_viewKickScale = GetDvar( "bg_viewKickScale" );
old_bg_viewKickMax = GetDvar( "bg_viewKickMax" );
SetSavedDvar( "bg_viewKickScale", 0.3 );
SetSavedDvar( "bg_viewKickMax", "15" );
SetSavedDvar( "bullet_penetration_damage", 0 );
level waittill( "slowmo_breach_ending" );
SetSavedDvar( "bg_viewKickScale", old_bg_viewKickScale );
SetSavedDvar( "bg_viewKickMax", old_bg_viewKickMax );
wait( 2 );
SetSavedDvar( "bullet_penetration_damage", 1 );
}
slomo_breach_vision_change( lerpTime_in, lerpTime_out )
{
if ( !IsDefined( level.slomoBasevision ) )
{
return;
}
VisionSetNaked( "slomo_breach", lerpTime_in );
level waittill( "slowmo_breach_ending", newLerpTime );
if ( IsDefined( newLerpTime ) )
{
lerpTime_out = newLerpTime;
}
wait( 1 );
VisionSetNaked( level.slomoBasevision, lerpTime_out );
}
final_crash_moment_driver()
{
Assert(IsAlive(self));
self magic_bullet_shield();
self.animname = "sedan_driver";
self set_ignoreme(true);
self LinkTo(level.escape_sedan_model, "tag_driver", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model anim_single_solo(self, "ending_breach_death", "tag_driver");
while(!flag("flag_final_crash_begin"))
{
level.escape_sedan_model anim_set_time([self], "ending_breach_death", .9);
waitframe();
}
level.escape_sedan_model anim_single_solo(self, "ending_breach_intro", "tag_driver");
self.team = "neutral";
level.escape_sedan_model anim_single_solo(self, "ending_breach_death", "tag_driver");
while(true)
{
level.escape_sedan_model anim_set_time([self], "ending_breach_death", .9);
waitframe();
}
}
final_crash_moment_volk()
{
self endon("death");
self LinkTo(level.escape_sedan_model, "tag_body", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model thread anim_loop_solo(self, "ending_breach_driving_loop", "volk_ender", "tag_body");
flag_wait("flag_final_crash_begin");
level.escape_sedan_model notify("volk_ender");
self LinkTo(level.escape_sedan_model, "tag_passenger", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model anim_single_solo(self, "ending_breach_intro", "tag_passenger");
if(!flag("flag_volk_ending_start"))
{
self LinkTo(level.escape_sedan_model, "tag_body", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model thread anim_loop_solo(self, "ending_breach_driving_loop", "volk_ender", "tag_body");
}
}
final_crash_moment_guard_right()
{
Assert(IsAlive(self));
self magic_bullet_shield();
self.animname = "sedan_guard_r";
self set_ignoreme(true);
self animscripts\shared::placeWeaponOn( self.weapon, "none" );
self LinkTo(level.escape_sedan_model, "tag_body", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model thread anim_loop_solo(self, "ending_breach_driving_loop", "guard_right_ender", "tag_body");
flag_wait("flag_final_crash_begin");
level.escape_sedan_model notify("guard_right_ender");
self LinkTo(level.escape_sedan_model, "tag_guy1", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model thread anim_single_solo(self, "ending_breach_intro", "tag_guy1");
flag_wait("flag_final_crash_slowmo_start");
self waittill( "damage", damage, attacker, direction_vec, point, type );
if(flag("flag_final_crash_must_kill_guards")) return;
self.team = "neutral";
if(IsDefined(point))
{
PlayFx(getfx("guard_blood_splat"), point);
}
self.fake_death = true;
level.escape_sedan_model anim_single_solo(self, "ending_breach_death", "tag_guy1");
level.escape_sedan_model anim_loop_solo(self, "ending_breach_death_pose", "ender", "tag_guy1");
}
final_crash_moment_guard_left()
{
Assert(IsAlive(self));
self magic_bullet_shield();
self.animname = "sedan_guard_l";
self set_ignoreme(true);
self LinkTo(level.escape_sedan_model, "tag_body", (0, 0, 0), (0, 0, 0));
level.escape_sedan_model thread anim_loop_solo(self, "ending_breach_driving_loop", "guard_left_ender", "tag_body");
flag_wait("flag_final_crash_begin");
anim_ent = spawn_tag_origin();
anim_ent.origin = level.escape_sedan_model GetTagOrigin("tag_guy0");
anim_ent.angles = level.escape_sedan_model GetTagAngles("tag_guy0");
anim_ent LinkTo(level.escape_sedan_model, "tag_guy0", (0, 0, 0), (0, 0, 0));
anim_ent thread monitor_linear_velocity();
level.escape_sedan_model notify("guard_left_ender");
self LinkTo(anim_ent, "tag_origin", (0, 0, 0), (0, 0, 0));
anim_ent thread anim_single_solo(self, "ending_breach_intro", "tag_origin");
flag_wait("flag_final_crash_slowmo_start");
wait .1;
start_msec = GetTime();
self waittill( "damage", damage, attacker, direction_vec, point, type );
if(flag("flag_final_crash_must_kill_guards")) return;
self.team = "neutral";
if(IsDefined(point))
{
PlayFx(getfx("guard_blood_splat"), point);
}
self.fake_death = true;
self.dont_unlink_ragdoll = true;
anim_ent thread anim_single_solo(self, "ending_breach_death", "tag_origin");
self thread ragdoll_repulsor(anim_ent);
if(GetTime() - start_msec >= 1300)
{
sedan_anim = level.escape_sedan_model getanim("chase_final_crash");
notetrack_time = GetNoteTrackTimes(sedan_anim, "stair_impact")[0] * GetAnimLength(sedan_anim);
fence_anim = level.final_crash_fence getanim("chase_final_crash");
fence_anim_length = GetAnimLength(fence_anim);
current_time = level.final_crash_fence GetAnimTime(fence_anim) * fence_anim_length;
if(current_time < notetrack_time)
{
time_advance = .1;
new_time = min(current_time + time_advance, notetrack_time);
level.final_crash_fence SetAnimTime(fence_anim, new_time / fence_anim_length);
delayThread(notetrack_time - new_time, maps\paris_b_anim::final_crash_fence_model_swap);
}
}
wait .1;
elapsed_msec = GetTime() - start_msec;
extra_velocity = 0;
if(elapsed_msec <= 150)	extra_velocity = 1.5;
else	if(elapsed_msec <= 200)	extra_velocity = 1.5;
else	if(elapsed_msec <= 400)	extra_velocity = 1.3;
else	if(elapsed_msec <= 600)	extra_velocity = 0.5;
else	if(elapsed_msec <= 800)	extra_velocity = 0.25;
else	if(elapsed_msec <= 1000)	extra_velocity = 0.1;
else	if(elapsed_msec <= 1200)	extra_velocity = 0;
else	if(elapsed_msec <= 1400)	extra_velocity = 0;
else	if(elapsed_msec <= 1600)	extra_velocity = 0.1;
anim_ent Unlink();
anim_ent.origin += anim_ent.linear_velocity * 0.05;
new_velocity = anim_ent.linear_velocity + extra_velocity * VectorNormalize(anim_ent.origin - (level.player GetEye())) * Length(anim_ent.linear_velocity);
new_velocity = (new_velocity[0], new_velocity[1], new_velocity[2] * 0.25);
move_duration = 5;
anim_ent MoveTo(anim_ent.origin + new_velocity * move_duration, move_duration);
flag_wait("flag_stair_impact");
self.ragdoll_immediate = true;
self stop_magic_bullet_shield();
self Kill();
self StartRagdoll();
wait 1;
anim_ent Delete();
}
ragdoll_repulsor(anim_ent)
{
start_msec = GetTime();
while(GetTime() - start_msec < 5000)
{
PhysicsExplosionSphere(level.bomb_truck_model.origin, 128, 0, 10);
origin = level.escape_sedan_model GetTagOrigin("tag_guy0");
radius = 128;
if(IsDefined(anim_ent))
radius = clamp(Distance(anim_ent.origin, origin), 48, 128);
PhysicsExplosionSphere(origin, radius, 0, 5);
PhysicsExplosionSphere(level.player GetEye(), 96, 64, 10);
waitframe();
}
}
monitor_linear_velocity()
{
self endon("death");
self.linear_velocity = (0, 0, 0);
for(;;)
{
old_origin = self.origin;
waitframe();
self.linear_velocity = (self.origin - old_origin) * 20;
}
}
chase_ending_moment()
{
volk = level.volk;
if(!IsAlive(volk)) return;
volk endon("death");
volk set_ignoreme(true);
volk.dontMelee = true;
volk.deathFunction = ::ragdoll_death_noimpulse;
flag_set( "flag_volk_ending_start" );
escape_sedan = level.escape_sedan_model;
escape_sedan.animname = "escape_sedan";
anim_ent = level.bomb_truck_model create_anim_ent_for_my_position("chase_ending_start");
thread chase_ending_moment_player(anim_ent);
thread chase_ending_moment_frenchie();
thread chase_ending_moment_lone_star(anim_ent);
level.escape_sedan_model notify("enemy_ender");
level.escape_sedan_model notify("volk_ender");
volk Unlink();
anim_ent anim_single([volk, level.escape_sedan_model], "chase_ending_start");
scripted_sequence_recon("chase_ending_moment", true, volk);
anim_ent thread anim_single_solo_and_stop(level.escape_sedan_model, "chase_ending_end");
anim_ent thread anim_single_solo_and_stop(volk, "chase_ending_end");
wait GetAnimLength(volk getanim("chase_ending_end")) - 2;
level_complete();
}
anim_single_solo_and_stop(guy, anime, tag)
{
sanim = guy getanim(anime);
duration = GetAnimLength(sanim) - .2;
guy delayCall(duration, ::SetFlaggedAnim, "single anim", sanim, 1, 0, 0);
self thread anim_single_solo(guy, anime, tag);
wait duration;
}
chase_ending_moment_player(anim_ent)
{
player_rig = spawn_anim_model("player_rig", level.player.origin);
player_legs = spawn_anim_model("player_rig_feet");
player_legs Hide();
anim_ent anim_first_frame([player_rig, player_legs], "chase_ending_start");
duration = .25;
van_ride_set_view_clamp(duration, 0, 0, 0, 0);
delayThread(duration, ::van_ride_stop_adjusting_view_clamp);
level.player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 0), (0, 0, 0));
level.player player_control_off();
player_legs delayCall(duration, ::Show);
level.bomb_truck_model AnimScripted("notify", anim_ent.origin, anim_ent.angles, level.bomb_truck getanim("chase_ending_start"), "normal", level.bomb_truck.animscripted_root);
unlink_duration = .3;
level.player delayThread(GetAnimLength(player_rig getanim("chase_ending_start")) - unlink_duration, ::player_smooth_unclamp, unlink_duration, 0, 0, 0, 0);
anim_ent anim_single([player_rig, player_legs], "chase_ending_start");
level.player Unlink();
level.player player_control_on();
player_rig Delete();
player_legs Delete();
level.player_link_ent Delete();
flag_set( "flag_obj_capture_volk_complete" );
hud_on();
}
chase_ending_moment_frenchie()
{
frenchie_start_origin = getstruct("struct_frenchie_exit_van", "script_noteworthy");
Assert(IsDefined(frenchie_start_origin));
level.hero_reno notify("frenchie_drives_truck_stop");
level.bomb_truck_model notify("driver_ender");
level.hero_reno Unlink();
level.hero_reno gun_recall();
level.hero_reno ForceTeleport(frenchie_start_origin.origin, frenchie_start_origin.angles);
level.hero_reno goto_node("node_frenchie_exit_van_target", false);
}
chase_ending_moment_lone_star(anim_ent)
{
level.hero_lone_star notify("lonestar_exit_truck");
level.hero_lone_star Unlink();
level.hero_lone_star gun_remove();
anim_ent anim_single_solo(level.hero_lone_star, "chase_ending_start");
anim_ent anim_single_solo_and_stop(level.hero_lone_star, "chase_ending_end");
}
level_complete()
{
thread introscreen_generic_fade_out( "black", 999, 0, 2 );
wait 2;
level.player DisableWeapons();
level.player FreezeControls( true );
level.player EnableInvulnerability(true);
wait 9;
nextmission();
}
flashlight_init()
{
level.flashlight_tag = "j_head";
}
flashlight_on()
{
self.flashlight_tag_origin = spawn_tag_origin();
self.flashlight_tag_origin LinkTo(self, level.flashlight_tag, (2.35, 1.5, -5), (0, 90 - 10, 0));
waitframe();
PlayFxOnTag(getfx("flashlight"), self.flashlight_tag_origin, "tag_origin");
aud_send_msg("aud_flashlight_on");
}
flashlight_off()
{
StopFxOnTag(getfx("flashlight"), self.flashlight_tag_origin, "tag_origin");
}
flashlight_control()
{
max_look_down_degrees = 15;
self endon("death");
self endon("flashlight_control_stop");
self childthread flashlight_target_control();
aim_target = undefined;
last_aim_pos = undefined;
aim_velocity = (0, 0, 0);
for(;; waitframe())
{
waittillframeend;
if(IsDefined(self.flashlight_target))
{
aim_target = self.flashlight_target;
}
if(!animscripts\utility::shouldCQB() || !IsDefined(aim_target))
{
last_aim_pos = undefined;
aim_velocity = (0, 0, 0);
self.cqb_point_of_interest = undefined;
continue;
}
if(!IsDefined(last_aim_pos))
{
last_aim_pos = (self GetTagOrigin("tag_flash")) + AnglesToForward(self GetTagAngles("tag_flash")) * 64;
}
positional_error = aim_target - last_aim_pos;
acceleration = positional_error * 20 - aim_velocity * 2;
aim_pos = last_aim_pos + (aim_velocity + (acceleration * .05)) * .05;
tag_flash_pos = self GetTagOrigin("tag_flash");
if(!IsDefined(tag_flash_pos)) continue;
radius = Length(tag_flash_pos - aim_pos);
aim_pos_noisy = aim_pos + flashlight_noise_vector() * (radius * .035);
flash_to_aim_noisy = aim_pos_noisy - tag_flash_pos;
flash_to_aim_noisy_length = Length(flash_to_aim_noisy);
if(flash_to_aim_noisy_length > .01)
{
flash_to_aim_noisy_angles = VectorToAngles(VectorNormalize(flash_to_aim_noisy));
flash_to_aim_noisy_angles = (AngleClamp(clamp(AngleClamp180(flash_to_aim_noisy_angles[0]), -90, max_look_down_degrees)), flash_to_aim_noisy_angles[1], flash_to_aim_noisy_angles[2]);
if(IsDefined(self.stairsState) && self.stairsState == "down")
flash_to_aim_noisy_angles += (20, -40, 0);
flash_to_aim_noisy_angles = (AngleClamp(flash_to_aim_noisy_angles[0]), AngleClamp(flash_to_aim_noisy_angles[1]), AngleClamp(flash_to_aim_noisy_angles[2]));
aim_pos_noisy = tag_flash_pos + AnglesToForward(flash_to_aim_noisy_angles) * flash_to_aim_noisy_length;
}
if(aim_pos != aim_pos || aim_pos[0] != aim_pos[0])
{
AssertMsg("flashlight control diverged");
return;
}
self.cqb_point_of_interest = aim_pos_noisy;
aim_velocity = (aim_pos - last_aim_pos) * 20 ;
last_aim_pos = aim_pos;
}
}
flashlight_noise_vector()
{
time = GetTime();
pi_time = ((time, time, time) / 1000 + (0, 42.5, 121.3)) * 180;
return (
Sin(pi_time[0] * 2.0) * .7 + Sin(pi_time[0] * 5.0) * .3,
Sin(pi_time[1] * 1.8) * .7 + Sin(pi_time[1] * 4.6) * .3,
Sin(pi_time[2] * 2.2) * .7 + Sin(pi_time[2] * 5.4) * .3
);
}
flashlight_target_control()
{
for(;;)
{
potential_targets = [];
start_pos = level.player GetEye();
end_pos = start_pos + AnglesToForward(level.player GetPlayerAngles()) * 1024;
result = BulletTrace(start_pos, end_pos, false, undefined);
if(IsDefined(result) && IsDefined(result["position"]))
{
potential_targets[potential_targets.size] = result["position"];
}
potential_targets[potential_targets.size] = level.player GetEye();
if(IsDefined(self.goalpos))
{
potential_targets[potential_targets.size] = self.goalpos + (0, 0, 32);
}
self.flashlight_target = undefined;
foreach(potential_target in potential_targets)
{
if(within_fov_2d(self.origin, self.angles, potential_target, Cos(45)) &&
Distance2D(self.origin, potential_target) > 64)
{
self.flashlight_target = potential_target;
break;
}
}
wait RandomFloatRange(0.3, 1.0);
}
}
escape_timer_countdown(seconds, deadquote)
{
level notify( "escape_timer_countdown_stop" );
level endon( "escape_timer_countdown_stop" );
flag_wait_or_timeout( "flag_volk_escaped", seconds );
SetDvar( "ui_deadquote", deadquote );
missionFailedWrapper();
}
escape_timer_cancel()
{
level notify("escape_timer_countdown_stop");
}
reduced_accuracy_for_ride_begin()
{
accuracy_scale = 0.18;
level.player.old_attackeraccuracy = get_player_attacker_accuracy();
level.player set_player_attacker_accuracy(level.player.old_attackeraccuracy * accuracy_scale);
foreach(vehicle_spawner in _getVehicleSpawnerArray())
{
vehicle_spawner add_spawn_function(::reduce_turret_accuracy);
}
foreach(vehicle in getVehicleArray())
{
vehicle reduce_turret_accuracy();
}
}
reduced_accuracy_for_ride_end()
{
if(IsDefined(level.player.old_attackeraccuracy))
{
level.player set_player_attacker_accuracy(level.player.old_attackeraccuracy);
}
level notify("reduce_turret_accuracy_stop");
foreach(vehicle_spawner in _getVehicleSpawnerArray())
{
vehicle_spawner remove_spawn_function(::reduce_turret_accuracy);
}
}
get_player_attacker_accuracy()
{
if(IsDefined(level.player.gs.attackeraccuracy))
return level.player.gs.attackeraccuracy;
return level.player.attackeraccuracy;
}
reduce_turret_accuracy()
{
if(IsDefined(self.mgturret))
{
foreach(turret in self.mgturret)
{
if(IsDefined(turret))
{
turret SetAISpread(10);
}
}
}
}
plant_flare(flare_light, anim_node)
{
self disable_ai_color();
plant_flare_internal(flare_light, anim_node);
self enable_ai_color();
}
plant_flare_internal(flare_light, anim_node)
{
level endon("flag_catacombs_enemy_gate");
AssertEx(IsDefined(flare_light.angles), "node to plant flare at needs angles");
anim_node anim_generic_reach(self, "plant_flare");
anim_speedup = 1.3;
aud_send_msg("road_flare_start", flare_light);
flare_model = spawn_anim_model("catacombs_flare");
flare_model Hide();
self delayThread(0.1, ::anim_set_rate_internal, "plant_flare", anim_speedup, "generic");
flare_model delayThread(0.1, ::anim_set_rate_internal, "plant_flare", anim_speedup);
scripted_sequence_recon(anim_node.script_noteworthy, true, self, 1);
anim_node thread anim_generic_run(self, "plant_flare");
anim_node thread anim_single_solo(flare_model, "plant_flare");
self waittillmatch("single anim", "show_flare");
flare_model Show();
flare_model waittillmatch("single anim", "show_sparks");
PlayFXOnTag(getfx("flare_catacombs_moving"), flare_model, "tag_fire_fx");
flare_model waittillmatch("single anim", "flare_planted");
StopFXOnTag(getfx("flare_catacombs"), flare_model, "tag_fire_fx");
flare_light flare_on(anim_node, flare_model);
flare_model waittillmatch("single anim", "end");
anim_node thread anim_loop_solo(flare_model, "plant_flare_idle");
}
flare_on(anim_node, flare_model)
{
self thread flare_flicker();
self.fx_origin = self spawn_tag_origin();
if(IsDefined(anim_node.origin))
self.fx_origin.origin = anim_node.origin;
self.fx_origin.angles = VectorToAngles((0, 0, 1));
if(IsDefined(anim_node.angles))
self.fx_origin.angles = CombineAngles(anim_node.angles, self.fx_origin.angles);
aud_send_msg("road_flare_lp", self);
PlayFXOnTag(getfx("flare_catacombs"), self.fx_origin, "tag_origin");
if (flag ("msg_fx_zone6100"))
PlayFXOnTag(getfx("flare_catacombs_mist"), self.fx_origin, "tag_origin");
}
flare_off()
{
self notify("stop_flare_flicker");
self SetLightIntensity(0);
self.fx_origin Delete();
self.fx_origin = undefined;
}
flare_flicker()
{
self endon("stop_flare_flicker");
while(1)
{
self SetLightIntensity(RandomFloatRange(0.6, 1.0));
waitframe();
}
}
everyone_enters_truck()
{
flag_set( "flag_dialogue_everyone_in_truck" );
spawn_van_ride_weapon();
add_wait(::frenchie_enters_truck);
add_wait(::lone_star_enters_truck);
add_wait(::player_enters_truck);
do_wait();
}
frenchie_enters_truck()
{
level.hero_reno set_ignoreSuppression(true);
level.hero_reno disable_pain();
level.hero_reno ally_keep_player_distance_stop();
flag_wait("flag_player_in_truck");
wait 2;
level.hero_reno disable_awareness();
node_teleport = getnode( "node_frenchie_teleport_to_van", "targetname" );
level.hero_reno disable_ai_color();
level.hero_reno enable_sprint();
level.hero_reno set_ignoreall( true );
level.hero_reno teleport_ai (node_teleport);
level.hero_reno AnimScripted("notify", node_teleport.origin, node_teleport.angles, getanim_generic("catacombs_signal_stop"));
wait 1;
level.hero_reno StopAnimScripted();
level.bomb_truck_model anim_reach_solo(level.hero_reno, "van_driver_enter", "tag_driver");
level.hero_reno gun_remove();
level.hero_reno LinkTo(level.bomb_truck_model, "tag_driver", (0, 0, 0), (0, 0, 0));
level.bomb_truck_model SetFlaggedAnimRestart( "vehicle_anim_flag", level.bomb_truck getanim("van_driver_enter") );
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_enter", "tag_driver");
level.bomb_truck_model ClearAnim(level.bomb_truck getanim("van_driver_enter"), .25);
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_start_engine", "tag_driver");
thread frenchie_drives_truck();
}
lone_star_enters_truck()
{
guy = level.hero_lone_star;
guy disable_pain();
guy enable_sprint();
guy set_ignoreall( true );
guy disable_ai_color();
guy set_ignoreSuppression(true);
guy ally_keep_player_distance_stop();
door_blocker = getent_safe("van_door_blocker", "script_noteworthy");
door_blocker LinkTo(level.bomb_truck_model, "door_KR");
door_blocker Solid();
level.bomb_truck_model add_wait(::anim_reach_solo, guy, "van_ride_enter", "tag_guy");
add_wait(::flag_wait, "flag_player_in_truck");
do_wait_any();
guy set_ignoreme(true);
level.bomb_truck_model SetFlaggedAnimRestart( "vehicle_anim_flag", level.bomb_truck getanim("van_ride_enter") );
level.bomb_truck_model anim_single_solo(guy, "van_ride_enter", "tag_guy");
level.bomb_truck_model ClearAnim(level.bomb_truck getanim("van_ride_enter"), .25);
guy LinkTo(level.bomb_truck_model, "tag_guy", (0, 0, 0), (0, 0, 0));
door_blocker Delete();
level.bomb_truck_model thread anim_loop_solo(guy, "van_ride_enter_idle", "enter_idle_ender", "tag_guy");
}
player_enters_truck()
{
level.player endon("death");
thread maps\paris_b_fx::fx_car_chase(level.bomb_truck_model);
player_rig = create_player_rig(level.bomb_truck_model, "tag_passenger", "player_enter_van");
thread van_glowing_doors();
trigger = getent_safe("trigger_player_held_x_to_enter_truck", "script_noteworthy");
trigger SetHintString(&"PARIS_ENTER_VAN_HINT");
flag_clear("flag_player_held_x_to_enter_truck");
flag_wait("flag_player_held_x_to_enter_truck");
trigger SetHintString("");
flag_set("flag_player_in_truck");
hud_off();
van_sight_blocker = getent_safe("van_sight_blocker", "script_noteworthy");
van_sight_blocker Delete();
escape_timer_cancel();
disable_trigger_with_targetname( "trigger_flag_volk_escaped" );
level.player.health = level.player.maxhealth;
level.player EnableInvulnerability();
duration = .4;
level.player_link_ent = spawn_tag_origin();
level.player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(duration, 10, 10, 10, 10);
level.player player_control_off(true);
level.player player_reload_silently();
wait duration;
player_rig Show();
level.bomb_truck_model SetFlaggedAnimRestart( "vehicle_anim_flag", level.bomb_truck getanim("player_enter_van") );
level.bomb_truck_model SetFlaggedAnimRestart( "vehicle_anim_flag", level.bomb_truck getanim("player_enter_van_glass") );
level.bomb_truck_model anim_single_solo(player_rig, "player_enter_van", "tag_passenger");
level.bomb_truck_model ClearAnim( level.bomb_truck getanim("player_enter_van"), 0);
level.bomb_truck_model SetAnim( level.bomb_truck getanim("player_enter_van_glass"), 1, 0, 0 );
level.bomb_truck_model SetAnimTime( level.bomb_truck getanim("player_enter_van_glass"), 1 );
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_passenger", (0, 0, 0), (0, 0, 0));
player_rig Delete();
van_ride_set_view_clamp(1, 105, 100, 40, 40);
level.player EnableWeapons();
hud_on();
thread autosave_now();
level.player delayCall(3, ::DisableInvulnerability);
}
van_glowing_doors()
{
alternate_deadquote(&"PARIS_DEADQUOTE_GET_IN_VAN");
level.bomb_truck_model hide_van_door( "door_FR" );
glowing_door = Spawn("script_model", level.bomb_truck_model GetTagOrigin("door_FR"));
glowing_door LinkTo(level.bomb_truck_model, "door_FR", (0, 0, 0), (0, 0, 0));
glowing_door SetModel("armored_van_passengerDoor_obj");
glowing_door setup_ent_for_damage();
glowing_door update_glass( level.bomb_truck_model, 8 );
level.bomb_truck_model thread van_damage_glass_think( glowing_door );
flag_wait("flag_player_in_truck");
alternate_deadquote_stop();
glowing_door Delete();
level.bomb_truck_model show_van_door( "door_FR" );
}
spawn_van_ride_weapon()
{
weapon_name = "sa80lmg_fastreload_reflex";
weapon = spawn("weapon_" + weapon_name, level.bomb_truck_model GetTagOrigin("tag_player"));
weapon ItemWeaponSetAmmo(WeaponClipSize(weapon_name), WeaponStartAmmo(weapon_name) - WeaponClipSize(weapon_name));
weapon LinkTo(level.bomb_truck_model);
weapon Hide();
}
van_crash_gaz_barricade()
{
flag_wait( "flag_player_in_truck" );
anim_ent = getstruct("struct_chase_barricade_moment", "script_noteworthy");
end_node = GetVehicleNode("van_path_post_barricade", "script_noteworthy");
gaz2 = spawn_vehicle_from_targetname( "chase_uaz_02_blocker" );
wait 3.5;
gaz1 = spawn_vehicle_from_targetname_and_drive( "chase_uaz_01_blocker" );
gaz1 change_turret_accuracy_over_time( 10, 50, 10 );
gaz1 godon();
gaz2 godon();
gaz1.animname = "gaz1";
gaz2.animname = "gaz2";
flag_wait( "gaz_1_barricade_ready" );
guy = GetEnt_safe("ai_enemy_barricade_roadkill", "script_noteworthy") spawn_ai(true);
guy deletable_magic_bullet_shield();
guy disable_awareness();
anim_ent anim_generic_first_frame(guy, "chase_gaz_barricade");
level.bomb_truck vehicle_scripted_animation_wait(anim_ent, "chase_gaz_barricade");
flag_set("flag_crash_gaz_barricade_started");
thread maps\paris_b_fx::fx_blockade_impact(level.bomb_truck_model, 1);
thread van_crash_gaz_barricade_player();
aud_send_msg("start_engine_02");
anim_ent thread anim_generic(guy, "chase_gaz_barricade");
level.bomb_truck add_wait_arg_array(::vehicle_scripted_animation, [anim_ent, "chase_gaz_barricade", true, false, end_node, 1, false ]);
gaz1 add_wait_arg_array(::vehicle_scripted_animation, [anim_ent, "chase_gaz_barricade", true, false, undefined, 1, true ]);
gaz2 add_wait_arg_array(::vehicle_scripted_animation, [anim_ent, "chase_gaz_barricade", true, false, undefined, 1, false ]);
do_wait();
gaz1 godoff();
gaz2 godoff();
gaz1 DoDamage( gaz1.health + 2000, (0,0,0) );
gaz2 DoDamage( gaz2.health + 2000, (0,0,0) );
guy Delete();
}
van_crash_gaz_barricade_player()
{
player_rig = create_player_rig(level.bomb_truck_model, "tag_passenger", "player_gaz_barricade");
thread van_crash_gaz_barricade_player_delay(player_rig);
delayThread(2.25, ::camera_shake_default);
level.player delaycall( 2.25, ::playrumbleonentity, "heavy_2s" );
level.bomb_truck_model anim_single_solo(player_rig, "player_gaz_barricade", "tag_passenger");
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_passenger");
player_rig Delete();
van_ride_set_view_clamp(1, 105, 100, 40, 40);
}
van_crash_gaz_barricade_player_delay(player_rig)
{
level.player_link_ent LinkTo(player_rig, "tag_player");
van_ride_set_view_clamp(.75, 0, 0, 0, 0);
wait .75;
level.player DisableWeapons();
level.player EnableDeathShield(true);
level.player player_reload_silently();
wait .5;
level.player HideViewModel();
player_rig Show();
}
player_move_to_back()
{
flag_wait( "flag_player_move_to_back" );
flag_set( "flag_dialogue_another_shooter" );
thread tweak_damage_multiplier_on_vet();
wait 1;
player_rig_feet = spawn_anim_model("player_rig_feet", level.player.origin);
player_rig_feet Hide();
level.bomb_truck_model anim_first_frame_solo(player_rig_feet, "player_front_to_back", "tag_passenger");
player_rig_feet LinkTo(level.bomb_truck_model, "tag_passenger", (0, 0, 0), (0, 0, 0));
player_rig = create_player_rig(level.bomb_truck_model, "tag_passenger", "player_front_to_back");
level.player_link_ent LinkTo(player_rig, "tag_player", (0, 0, 0), (0, 0, 0));
van_ride_set_view_clamp(.25, 10, 10, 10, 10);
player_rig delayCall(.25, ::Show);
player_rig_feet delayCall(.25, ::Show);
level.bomb_truck_model SetFlaggedAnimRestart( "vehicle_anim_flag", level.bomb_truck getanim("player_front_to_back") );
level.hero_lone_star thread lonestar_rides_bomb_truck();
level.bomb_truck_model thread van_doors_window_break();
level.bomb_truck_model anim_single([player_rig, player_rig_feet], "player_front_to_back", "tag_passenger");
level.bomb_truck_model ClearAnim(level.bomb_truck getanim("player_front_to_back"), 0.2);
thread van_doors_fall_off();
player_rig_feet Delete();
level.player_link_ent LinkTo(level.bomb_truck_model, "tag_player", (0, 0, 0), (0, 0, 0));
player_rig Delete();
van_ride_set_view_clamp(.25, 105, 100, 40, 40);
level.player EnableWeapons();
level.player ShowViewModel();
level.player EnableDeathShield(false);
level.player SetStance("crouch");
level.player AllowCrouch( true );
}
tweak_damage_multiplier_on_vet()
{
if ( getdifficulty() == "fu" )
{
setsaveddvar( "player_damageMultiplier", 0.6 );
flag_wait ( "flag_van_climb_paired_done" );
setsaveddvar( "player_damageMultiplier", .8 );
flag_wait ( "flag_ai_clean_up_galleria" );
setsaveddvar( "player_damageMultiplier", 1 );
}
}
van_doors_fall_off()
{
thread spawn_dynamic_door("door_KR", "armored_van_rearDoorR", "r_door_rip_off", 5);
thread spawn_dynamic_door("door_KL", "armored_van_rearDoorL", "l_door_rip_off", 4);
level.bomb_truck_model SetFlaggedAnimRestart("van_back_door", level.bomb_truck getanim("van_back_door_idle"));
wait 8;
level.bomb_truck_model ClearAnim(level.bomb_truck getanim("van_back_door_idle"), 0);
level.bomb_truck_model SetFlaggedAnimRestart("van_back_door", level.bomb_truck getanim("van_back_door_rip_off"));
level.bomb_truck_model waittillmatch("van_back_door", "end");
level.bomb_truck_model ClearAnim(level.bomb_truck getanim("van_back_door_rip_off"), 0);
}
spawn_dynamic_door(tag, model, notetrack, glass_index)
{
level.bomb_truck_model set_glass_broken( level.bomb_truck_model, glass_index, true );
door = Spawn("script_model", level.bomb_truck_model GetTagOrigin(tag));
door.angles = level.bomb_truck_model GetTagAngles(tag);
door Hide();
door SetModel(model);
door LinkTo(level.bomb_truck_model, tag, (0, 0, 0), (0, 0, 0));
waitframe();
level.bomb_truck_model hide_van_door( tag );
door Show();
level.bomb_truck_model waittillmatch("van_back_door", notetrack);
door UnLink();
impulse = 3000;
door PhysicsLaunchClient(door GetPointInBounds(0, 0, 0), AnglesToForward(level.bomb_truck_model.angles + (0, 180, 0)) * impulse);
wait 30;
door Delete();
}
frenchie_drives_truck()
{
level endon("frenchie_drives_truck_stop");
level.hero_reno LinkTo(level.bomb_truck_model, "tag_driver", (0, 0, 0), (0, 0, 0));
level.hero_reno gun_remove();
switch( level.start_point )
{
default:
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving", "driver_ender", "tag_driver");
flag_wait("flag_crash_gaz_barricade_started");
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving_braced"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving_braced", "driver_ender", "tag_driver");
wait 2;
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_impact_big"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_impact_big", "tag_driver");
case "chase_canal":
case "chase_ending":
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving", "driver_ender", "tag_driver");
flag_wait("flag_player_to_the_front");
wait 1.5;
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_turn_full_right"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_turn_full_left", "tag_driver");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving", "driver_ender", "tag_driver");
wait 1;
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_turn_full_left"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_turn_full_left", "tag_driver");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving", "driver_ender", "tag_driver");
flag = flag_wait_either_return("flag_final_crash_begin", "flag_failure_did_not_shoot");
if(flag == "flag_failure_did_not_shoot")
{
wait 2;
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_turn_full_left"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_turn_full_left", "tag_driver");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_idle"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_idle", "driver_ender", "tag_driver");
return;
}
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_turn_full_right"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_turn_full_right", "tag_driver");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_driving_braced"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_driving_braced", "driver_ender", "tag_driver");
wait 1.5;
level.bomb_truck_model notify("driver_ender");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_impact_big"));
level.bomb_truck_model anim_single_solo(level.hero_reno, "van_driver_impact_big", "tag_driver");
level.bomb_truck_model SetAnimKnobRestart(level.bomb_truck_model getanim("van_driver_idle"));
level.bomb_truck_model thread anim_loop_solo(level.hero_reno, "van_driver_idle", "driver_ender", "tag_driver");
}
}
lonestar_rides_bomb_truck()
{
lone_star = level.hero_lone_star;
lone_star endon("death");
level.bomb_truck_model notify("enter_idle_ender");
lone_star set_ignoreme(false);
lone_star LinkTo(level.bomb_truck_model, "tag_guy", (0, 0, 0), (0, 0, 0));
level.bomb_truck_model anim_single_solo(lone_star, "van_ride_to_combat", "tag_guy");
lone_star.no_friendly_fire_penalty = true;
lone_star.dontShootStraight = true;
lone_star thread lonestar_targeting();
lone_star thread lonestar_anim_idle();
lone_star waittill("lonestar_exit_truck");
lone_star ClearEntityTarget();
level.bomb_truck_model notify("lonestar_stop_idle");
level.bomb_truck_model notify("lonestar_stop_fire");
lone_star Unlink();
}
lonestar_anim_idle()
{
self endon("death");
self endon("lonestar_exit_truck");
self endon("lonestar_anim_fire");
self endon("lonestar_anim_scripted");
level.bomb_truck_model endon("death");
was_moving = undefined;
for(;;)
{
moving = Length(level.bomb_truck Vehicle_GetVelocity()) > 5.0 * 17.6;
if(!IsDefined(was_moving) || was_moving != moving)
{
if(moving)
{
if(IsDefined(self.best_enemy_pos))
{
self childthread lonestar_play_idle(lonestar_choose_idle_anim(self.best_enemy_pos));
}
else
{
self childthread lonestar_play_idle("van_ride_idle_fwd");
}
}
else
{
self childthread lonestar_play_idle("van_noneride_idle");
}
}
was_moving = moving;
wait(0.5);
}
}
lonestar_delay_if_necessary()
{
msec = GetTime();
if(IsDefined(self.last_anim_msec) && self.last_anim_msec == msec)
{
waitframe();
}
self.last_anim_msec = msec;
}
lonestar_play_idle(idle)
{
level.bomb_truck_model notify("lonestar_stop_idle");
level.bomb_truck_model notify("lonestar_stop_fire");
lonestar_delay_if_necessary();
level.bomb_truck_model anim_loop_solo(self, idle, "lonestar_stop_idle", "tag_guy");
}
lonestar_anim_fire(target_pos)
{
self endon("death");
self endon("lonestar_exit_truck");
self endon("lonestar_anim_scripted");
self notify("lonestar_anim_fire");
if(IsDefined(self.lonestar_anim_scripted))
return;
anim_name = self lonestar_choose_fire_anim(self.best_enemy_pos);
lonestar_delay_if_necessary();
self.last_fire_msec = GetTime();
level.bomb_truck_model notify("lonestar_stop_idle");
level.bomb_truck_model notify("lonestar_stop_fire");
level.bomb_truck_model thread anim_loop_solo(self, anim_name, "lonestar_stop_fire", "tag_guy");
wait RandomFloatRange(0.4, 0.8);
level.bomb_truck_model notify("lonestar_stop_fire");
self thread lonestar_anim_idle();
}
lonestar_anim_scripted(anim_name)
{
self endon("death");
self endon("lonestar_exit_truck");
self notify("lonestar_anim_scripted");
self.lonestar_anim_scripted = true;
lonestar_delay_if_necessary();
level.bomb_truck_model anim_single_solo(self, anim_name, "tag_guy");
self.lonestar_anim_scripted = undefined;
self thread lonestar_anim_idle();
}
lonestar_choose_fire_anim(target_pos)
{
anims = ["van_ride_fire_right", "van_ride_fire_fwd", "van_ride_fire_left"];
angles = [ 15, 45, 70];
return lonestar_choose_anim(anims, angles, target_pos);
}
lonestar_choose_idle_anim(target_pos)
{
anims = ["van_ride_idle_right", "van_ride_idle_fwd", "van_ride_idle_left"];
angles = [ 15, 45, 70];
return lonestar_choose_anim(anims, angles, target_pos);
}
lonestar_choose_anim(anims, angles, target_pos)
{
local_target_pos = self WorldToLocalCoords(target_pos);
local_yaw = VectorToYaw(local_target_pos);
min_abs_error = 360;
best_index = undefined;
for(i = 0; i < anims.size; i++)
{
abs_error = abs(AngleClamp180(angles[i] - AngleClamp180(local_yaw)));
if(abs_error < min_abs_error)
{
min_abs_error = abs_error;
best_index = i;
}
}
return anims[best_index];
}
lonestar_targeting()
{
self endon("death");
self endon("lonestar_exit_truck");
for(;;)
{
self.best_enemy = undefined;
forward = AnglesToForward(self.angles);
eye = self GetEye();
enemies = GetAIArray("axis");
vehicles = array_filter(Vehicle_GetArray(), ::enemy_vehicles_only);
targets = array_combine(enemies, vehicles);
targets = SortByDistance(targets, eye);
for(i = 0; i < targets.size; i++)
{
target = targets[i];
target_shoot_pos = target GetShootAtPos();
target_shoot_pos_local = self WorldToLocalCoords(target_shoot_pos);
local_yaw = AngleClamp180(VectorToYaw(target_shoot_pos_local));
if(local_yaw > 0 && local_yaw < 85)
{
if(BulletTracePassed(self GetMuzzlePos(), target_shoot_pos, false, undefined))
{
self.best_enemy = target;
self.best_enemy_pos = target_shoot_pos;
break;
}
}
}
if(IsDefined(self.best_enemy))
{
self thread lonestar_anim_fire(self.best_enemy_pos);
}
if(targets.size > 3)
{
wait RandomFloatRange(.5, 1);
}
else
{
wait RandomFloatRange(.5, 3);
}
}
}
enemy_vehicles_only(vehicle)
{
return !IsDefined(vehicle.script_team) || vehicle.script_team == "axis";
}
lonestar_handle_fire_event(lonestar)
{
lonestar.a.lastShootTime = GetTime();
if(GetTime() - lonestar.last_fire_msec < .3 * 1000)
{
return;
}
if(IsDefined(lonestar.best_enemy) && IsAlive(lonestar.best_enemy))
{
lonestar.fire_pos = lonestar.best_enemy GetShootAtPos();
}
if(IsDefined(lonestar.fire_pos))
{
accuracy = 1.0;
if(IsDefined(lonestar.ride_accuracy))
accuracy = lonestar.ride_accuracy;
lonestar Shoot(accuracy, lonestar.fire_pos);
}
}
camera_shake_default()
{
Earthquake( 0.5, 3, level.player.origin, 850 );
}
camera_shake_small()
{
Earthquake( 0.25, 3, level.player.origin, 850 );
}
player_reload_silently(min_ammo_fraction)
{
Assert(IsPlayer(self));
if(!IsDefined(min_ammo_fraction)) min_ammo_fraction = .75;
weapon = self GetCurrentWeapon();
if(IsDefined(weapon) && weapon != "none")
{
class = WeaponClass(weapon);
if(class != "rocketlauncher" && class != "grenade")
{
current = self GetWeaponAmmoClip(weapon);
clip = WeaponClipSize(weapon);
if(clip > 0 && current / clip < min_ammo_fraction)
{
SetSavedDvar( "ammoCounterHide", "1" );
noself_DelayCall(1, ::SetSavedDvar, "ammoCounterHide", "0");
needed = clip - current;
stock = self GetWeaponAmmoStock(weapon);
given = needed;
self SetWeaponAmmoClip(weapon, current + given);
self SetWeaponAmmoStock(weapon, Int(max(stock - given, 0)));
}
}
}
}
setup_ent_for_damage()
{
self.maxhealth = 20000;
self SetNormalHealth( self.maxhealth );
self SetCanDamage( true );
}
van_damage_glass_setup()
{
setup_ent_for_damage();
self.glass_damage_state = [];
for ( i = 0; i < 9; i++ )
{
self.glass_damage_state[i] = SpawnStruct();
self.glass_damage_state[i].v[ "currentState" ] = 0;
self.glass_damage_state[i].v[ "health" ] = 40;
self.glass_damage_state[i].v[ "invul" ] = false;
update_glass( self, i );
}
}
update_glass( damage_state_ent, glass_index, show_fx )
{
if ( !IsDefined( damage_state_ent ) )
damage_state_ent = self;
glass_states = [ "glass", "glass_shattered", "glass_broken" ];
foreach ( j,state_name in glass_states )
{
glass_tag = "tag_" + state_name + "_0" + (glass_index+1);
if ( j == damage_state_ent.glass_damage_state[glass_index].v[ "currentState" ] )
{
self ShowPart( glass_tag );
if ( IsDefined( show_fx ) && show_fx && j == 2 )
{
PlayFXOnTag( getfx( "van_window_broken" ), self, glass_tag );
}
}
else
{
self HidePart( glass_tag );
}
}
}
van_damage_glass_think( damage_ent )
{
if ( !IsDefined( damage_ent ) )
damage_ent = self;
damage_ent endon( "death" );
while ( true )
{
damage_ent SetNormalHealth( damage_ent.maxhealth );
damage_ent waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName );
if ( IsDefined( tagName ) && tagName == "" )
{
if ( IsDefined( partName ) && partName != "" && partName != "tag_body" && partName != "body_animate_jnt" )
tagName = partName;
else
tagName = undefined;
}
if ( !IsDefined( tagName ) )
continue;
if ( tagName.size < 10 )
continue;
tagNameLower = ToLower( tagName );
tagNamePrefix = GetSubStr( tagNameLower, 0, 10 );
if ( tagNamePrefix == "tag_glass_" )
{
window_index = GetSubStr( tagNameLower, tagNameLower.size - 1, tagNameLower.size );
window_index = Int( window_index ) - 1;
do_glass_damage( damage_ent, window_index, amount );
}
}
}
do_glass_damage( display_model, window_index, amount )
{
if ( self.glass_damage_state[ window_index ].v[ "currentState" ] < 2 )
{
if ( self.glass_damage_state[ window_index ].v[ "invul" ] )
{
return;
}
self.glass_damage_state[ window_index ].v[ "health" ] -= amount;
if ( self.glass_damage_state[ window_index ].v[ "health" ] < 0 )
{
self.glass_damage_state[ window_index ].v[ "health" ] = 40;
self.glass_damage_state[ window_index ].v[ "currentState" ]++;
display_model update_glass( self, window_index, true );
}
}
}
set_glass_broken( display_model, window_index, show_fx )
{
array_index = window_index - 1;
if ( self.glass_damage_state[ array_index ].v[ "currentState" ] < 2 )
{
self.glass_damage_state[ array_index ].v[ "health" ] = 40;
self.glass_damage_state[ array_index ].v[ "currentState" ] = 2;
display_model update_glass( self, array_index, show_fx );
}
}
hide_van_door( door_tag )
{
glass_index = undefined;
if ( door_tag == "door_KR" )
glass_index = 5;
else if ( door_tag == "door_KL" )
glass_index = 4;
else if ( door_tag == "door_FR" )
glass_index = 9;
else
{
AssertEx( false, "hiding van door " + door_tag + " not supported." );
return;
}
self HidePart( door_tag );
self HidePart( "tag_glass_0" + glass_index );
self HidePart( "tag_glass_shattered_0" + glass_index );
self HidePart( "tag_glass_broken_0" + glass_index );
self HidePart( "tag_glass_screen_0" + glass_index );
}
show_van_door( door_tag )
{
glass_index = undefined;
if ( door_tag == "door_FR" )
glass_index = 9;
else
{
AssertEx( false, "showing van door " + door_tag + " not supported." );
return;
}
self ShowPart( "door_FR" );
self ShowPart( "tag_glass_screen_0" + glass_index );
self update_glass( self, glass_index-1 );
}
van_make_glass_invul( glass_index )
{
array_index = glass_index - 1;
self.glass_damage_state[array_index].v[ "invul" ] = true;
}
van_doors_window_break()
{
level.player endon( "death" );
wait 2.35;
self set_glass_broken( self, 4, true );
self set_glass_broken( self, 5, true );
}
launch_object_setup()
{
array_thread( getentarray( "launch_object", "targetname" ), ::launch_object );
}
rotate_vector( vector, rotation )
{
right = anglestoright( rotation ) * -1;
forward = anglestoforward( rotation );
up = anglestoup( rotation );
new_vector = forward * vector[ 0 ] + right * vector[ 1 ] + up * vector[ 2 ];
return new_vector;
}
launch_object()
{
obj_array = getentarray( self.target, "targetname" );
self waittill( "trigger", vehicle );
force_multiplier_arr = [];
force_multiplier_arr[ "com_trafficcone01" ] = 2;
force_multiplier_arr[ "paris_traffic_sign_02" ] = 22;
force_multiplier_arr[ "paris_street_signs_f" ] = 25;
force_multiplier_arr[ "paris_traffic_sign_08" ] = 25;
force_multiplier_arr[ "paris_street_signs_e" ] = 25;
foreach( obj in obj_array )
{
if ( vehicle == level.bomb_truck )
{
level.player PlayRumbleOnEntity( "damage_light" );
continue;
}
velocity = vehicle vehicle_getvelocity();
angles1 = vectortoangles( ( obj.origin + (0,0,6) ) - vehicle.origin );
angles2 = vectortoangles( velocity );
if ( obj_array.size > 2 )
{
random_angels = (0, randomint( 30 ) -15, 0 );
angles1 += random_angels;
}
rotation = ( angles1 - angles2 );
velocity = rotate_vector( velocity, rotation );
force_multiplier = 2;
if ( isdefined( force_multiplier_arr[ obj.model ] ) )
force_multiplier = force_multiplier_arr[ obj.model ];
if ( isdefined( obj.script_accel ) )
force_multiplier = force_multiplier * obj.script_accel;
if ( isdefined( obj.script_soundalias ) )
level thread play_sound_in_space( obj.script_soundalias, obj.origin );
velocity *= force_multiplier;
direction = vectornormalize( velocity * -1 );
contact_point = obj.origin + direction * 16;
obj PhysicsLaunchClient( contact_point, velocity );
dir = vectornormalize( velocity );
}
}
ragdoll_death_noimpulse()
{
self StartRagdoll();
}
death_do_nohing()
{
self waittill("forever");
}
minimap_switching()
{
for(;;)
{
maps\_compass::setupMiniMap("compass_map_paris_catacombs", "minimap_corner_catacombs");
SetSavedDVar("compassMaxRange", 1500);
flag_wait("trigger_minimap_chase");
maps\_compass::setupMiniMap("compass_map_paris_b", "minimap_corner");
SetSavedDVar("compassMaxRange", 3000);
flag_clear("trigger_minimap_catacombs");
flag_wait("trigger_minimap_catacombs");
flag_clear("trigger_minimap_chase");
}
}

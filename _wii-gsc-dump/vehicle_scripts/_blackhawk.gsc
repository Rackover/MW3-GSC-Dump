#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "blackhawk", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_blackhawk" );
build_deathmodel( "vehicle_blackhawk_low" );
build_deathmodel( "vehicle_blackhawk_low_so" );
build_deathmodel( "vehicle_blackhawk_low_thermal" );
build_deathmodel( "vehicle_blackhawk_hero_sas_night" );
build_drive( %bh_rotors, undefined, 0 );
blackhawk_death_fx = [];
blackhawk_death_fx[ "vehicle_blackhawk" ] = "explosions/helicopter_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_pc" ] = "explosions/helicopter_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_sas_night" ] = "explosions/helicopter_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_hero_sas_night" ] = "explosions/helicopter_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_hero" ] = "explosions/helicopter_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_low" ] = "explosions/large_vehicle_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_low_so" ] = "explosions/large_vehicle_explosion";
blackhawk_death_fx[ "vehicle_blackhawk_low_thermal" ] = "explosions/large_vehicle_explosion";
build_deathfx( "explosions/helicopter_explosion_secondary_small", "tag_engine_left", "blackhawk_helicopter_hit", undefined, undefined, undefined, 0.2, true );
build_deathfx( "explosions/helicopter_explosion_secondary_small", "elevator_jnt", "blackhawk_helicopter_secondary_exp", undefined, undefined, undefined, 0.5, true );
build_deathfx( "fire/fire_smoke_trail_L", "elevator_jnt", "blackhawk_helicopter_dying_loop", true, 0.05, true, 0.5, true );
build_deathfx( "explosions/helicopter_explosion_secondary_small", "tag_engine_right", "blackhawk_helicopter_secondary_exp", undefined, undefined, undefined, 2.5, true );
build_deathfx( "explosions/helicopter_explosion_secondary_small", "tag_deathfx", "blackhawk_helicopter_secondary_exp", undefined, undefined, undefined, 4.0 );
build_deathfx( blackhawk_death_fx[ model ], undefined, "blackhawk_helicopter_crash", undefined, undefined, undefined, - 1, undefined, "stop_crash_loop_sound" );
build_rocket_deathfx( "explosions/aerial_explosion_heli_large", "tag_deathfx", "blackhawk_helicopter_crash",undefined, undefined, undefined, undefined, true, undefined, 0 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "allies" );
build_aianims( ::setanims, ::set_vehicle_anims );
build_attach_models( ::set_attached_models );
build_unload_groups( ::Unload_Groups );
build_bulletshield( true );
randomStartDelay = randomfloatrange( 0, 1 );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "cockpit_blue_cargo01", "tag_light_cargo01", "misc/aircraft_light_cockpit_red", "interior", 0.0 );
build_light( lightmodel, "cockpit_blue_cockpit01", "tag_light_cockpit01", "misc/aircraft_light_cockpit_blue", "interior", 0.0 );
build_light( lightmodel, "white_blink", "tag_light_belly", "misc/aircraft_light_white_blink", "running", randomStartDelay );
build_light( lightmodel, "white_blink_tail", "tag_light_tail", "misc/aircraft_light_white_blink", "running", randomStartDelay );
build_light( lightmodel, "wingtip_green", "tag_light_L_wing", "misc/aircraft_light_wingtip_green", "running", randomStartDelay );
build_light( lightmodel, "wingtip_red", "tag_light_R_wing", "misc/aircraft_light_wingtip_red", "running", randomStartDelay );
}
init_local()
{
if( maps\_utility::is_iw4_map_sp() )
{
self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
self.fastropeoffset = 762 ;
}
else
{
isSpecOps = false;
tokens = StrTok(level.script, "_");
if( tokens[0] == "so" )
isSpecOps = true;
if( isSpecOps )
{
tagOrigin = self gettagorigin( "tag_origin" );
tagRope = self gettagorigin( "TAG_FastRope_RI" );
self.fastropeoffset = (tagOrigin[2] - tagRope[2]) + 872;
}
else
{
self.fastropeoffset = 762 + distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
}
}
self.script_badplace = false;
}
#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
for ( i = 0;i < positions.size;i++ )
positions[ i ].vehicle_getoutanim = %bh_idle;
return positions;
}
#using_animtree( "fastrope" );
setplayer_anims( positions )
{
positions[ 3 ].player_idle = %bh_player_idle;
positions[ 3 ].player_getout_sound = "fastrope_start_plr";
positions[ 3 ].player_getout_sound_loop = "fastrope_loop_plr";
positions[ 3 ].player_getout_sound_end = "fastrope_end_plr";
positions[ 3 ].player_getout = %bh_player_drop;
positions[ 3 ].player_animtree = #animtree;
positions[ 2 ].player_idle = %bh_player_idle;
positions[ 2 ].player_getout_sound = "fastrope_start_plr";
positions[ 2 ].player_getout_sound_loop = "fastrope_loop_plr";
positions[ 2 ].player_getout_sound_end = "fastrope_end_plr";
positions[ 2 ].player_getout = %bh_player_drop;
positions[ 2 ].player_animtree = #animtree;
positions[ 6 ].player_idle = %bh_player_idle;
positions[ 6 ].player_getout_sound = "fastrope_start_plr";
positions[ 6 ].player_getout_sound_loop = "fastrope_loop_plr";
positions[ 6 ].player_getout_sound_end = "fastrope_end_plr";
positions[ 6 ].player_getout = %bh_player_drop;
positions[ 6 ].player_animtree = #animtree;
return positions;
}
#using_animtree( "generic_human" );
set_coop_player_anims( positions )
{
positions[ 3 ].player_getout = %bh_2_drop;
positions[ 3 ].player_animtree = #animtree;
positions[ 6 ].player_getout = %bh_8_drop;
positions[ 6 ].player_animtree = #animtree;
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 8;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].idle = %bh_Pilot_idle;
positions[ 1 ].idle = %bh_coPilot_idle;
positions[ 2 ].idle = %bh_1_idle;
positions[ 3 ].idle = %bh_2_idle;
positions[ 4 ].idle = %bh_4_idle;
positions[ 5 ].idle = %bh_5_idle;
positions[ 6 ].idle = %bh_8_idle;
positions[ 7 ].idle = %bh_6_idle;
positions[ 0 ].sittag = "tag_detach";
positions[ 1 ].sittag = "tag_detach";
positions[ 2 ].sittag = "tag_detach";
positions[ 3 ].sittag = "tag_detach";
positions[ 4 ].sittag = "tag_detach";
positions[ 5 ].sittag = "tag_detach";
positions[ 6 ].sittag = "tag_detach";
positions[ 7 ].sittag = "tag_detach";
positions[ 2 ].getout = %bh_1_drop;
positions[ 3 ].getout = %bh_2_drop;
positions[ 4 ].getout = %bh_4_drop;
positions[ 5 ].getout = %bh_5_drop;
positions[ 6 ].getout = %bh_8_drop;
positions[ 7 ].getout = %bh_6_drop;
positions[ 2 ].getoutstance = "crouch";
positions[ 3 ].getoutstance = "crouch";
positions[ 4 ].getoutstance = "crouch";
positions[ 5 ].getoutstance = "crouch";
positions[ 6 ].getoutstance = "crouch";
positions[ 7 ].getoutstance = "crouch";
positions[ 2 ].ragdoll_getout_death = true;
positions[ 3 ].ragdoll_getout_death = true;
positions[ 4 ].ragdoll_getout_death = true;
positions[ 5 ].ragdoll_getout_death = true;
positions[ 6 ].ragdoll_getout_death = true;
positions[ 7 ].ragdoll_getout_death = true;
positions[ 2 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 3 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 4 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 5 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 6 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 7 ].ragdoll_fall_anim = %fastrope_fall;
positions[ 1 ].rappel_kill_achievement = 1;
positions[ 2 ].rappel_kill_achievement = 1;
positions[ 3 ].rappel_kill_achievement = 1;
positions[ 4 ].rappel_kill_achievement = 1;
positions[ 5 ].rappel_kill_achievement = 1;
positions[ 6 ].rappel_kill_achievement = 1;
positions[ 7 ].rappel_kill_achievement = 1;
positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
positions[ 2 ].fastroperig = "TAG_FastRope_RI";
positions[ 3 ].fastroperig = "TAG_FastRope_RI";
positions[ 4 ].fastroperig = "TAG_FastRope_LE";
positions[ 5 ].fastroperig = "TAG_FastRope_LE";
positions[ 6 ].fastroperig = "TAG_FastRope_RI";
positions[ 7 ].fastroperig = "TAG_FastRope_LE";
return setplayer_anims( positions );
return set_coop_player_anims( positions );
}
unload_groups()
{
unload_groups = [];
unload_groups[ "left" ] = [];
unload_groups[ "right" ] = [];
unload_groups[ "both" ] = [];
unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 4;
unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 5;
unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 7;
unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 2;
unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 3;
unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 6;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 5;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 6;
unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 7;
unload_groups[ "default" ] = unload_groups[ "both" ];
return unload_groups;
}
set_attached_models()
{
array = [];
array[ "TAG_FastRope_LE" ] = spawnstruct();
array[ "TAG_FastRope_LE" ].model = "rope_test";
array[ "TAG_FastRope_LE" ].tag = "TAG_FastRope_LE";
array[ "TAG_FastRope_LE" ].idleanim = %bh_rope_idle_le;
array[ "TAG_FastRope_LE" ].dropanim = %bh_rope_drop_le;
array[ "TAG_FastRope_RI" ] = spawnstruct();
array[ "TAG_FastRope_RI" ].model = "rope_test_ri";
array[ "TAG_FastRope_RI" ].tag = "TAG_FastRope_RI";
array[ "TAG_FastRope_RI" ].idleanim = %bh_rope_idle_ri;
array[ "TAG_FastRope_RI" ].dropanim = %bh_rope_drop_ri;
strings = getarraykeys( array );
for ( i = 0;i < strings.size;i++ )
{
precachemodel( array[ strings[ i ] ].model );
}
return array;
}

























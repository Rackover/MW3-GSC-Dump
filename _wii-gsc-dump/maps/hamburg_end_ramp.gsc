#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_end;
#include maps\_hud_util;
#include maps\_audio;
setup_crash_exit()
{
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
setup_spawn_funcs();
battlechatter_on( "allies" );
battlechatter_on( "axis" );
get_sandman();
level.player SetOrigin( ( -7773.06, 13280, -279 ) );
level.player SetPlayerAngles( ( 0, 88, 0 ) );
level.player takeallweapons();
}
crash_exit()
{
dummy = maps\hamburg_a_to_b::get_post_crash_tank();
dummy Show();
thread maps\hamburg_a_to_b::do_idle_guys_in_tank( dummy );
dummy thread turn_on_interior_light();
thread vision_set_fog_changes( "hamburg_garage_inside_tank", 0.1 );
maps\hamburg_a_to_b::tank_crash_exit();
}
setup_ramp()
{
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
setup_spawn_funcs();
battlechatter_on( "allies" );
battlechatter_on( "axis" );
spawn_allies(0, "hamburg_end_ramp");
assign_allies();
level.player SetOrigin( ( -7773.06, 14022.6, -324 ) );
level.player SetPlayerAngles( ( 0, 88, 0 ) );
activate_trigger_with_targetname( "hvi_intro_vo" );
}
begin_ramp()
{
thread autosave_now(1);
thread wait_combat_start();
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
level.destructible_protection_func = undefined;
level.jeep_numpass = 0;
thread do_garage_wave1();
thread do_garage_move();
set_no_explode_vehicles();
thread objective_streetsfollow_sandmansniper();
remove_global_spawn_function( "axis", ::disable_grenades );
vo_trig = GetEnt( "hvi_intro_vo", "targetname" );
vo_trig waittill("trigger");
flag_wait( "rampfoot_finished" );
thread end_vo();
}
end_vo()
{
level.player radio_dialogue( "tank_hqr_spottedtheconvoy" );
music_play( "ham_end_ramp" );
level.sandman dialogue_queue( "hamburg_snd_onourway" );
}
wait_combat_start()
{
level.sandman waittill( "enemy" );
allies = getaiarray( "allies" );
foreach ( a in allies )
{
a set_battlechatter( true );
}
level.green1 generic_dialogue_queue( "hamburg_rhg_contact" );
battlechatter_on( "allies" );
music_stop( 5 );
}
assign_allies()
{
allies = GetAIArray( "allies" );
foreach( ally in allies )
{
if(IsDefined(ally.script_noteworthy) && ally.script_noteworthy == "redend1" )
{
}
else if(!IsDefined(level.green1))
{
ally setup_green1();
}
else
{
ally setup_green2();
}
}
}
do_garage_wave1()
{
trigger = getEnt("trig_garage_wave1", "targetname");
trigger waittill("trigger");
wave1 = array_spawn_targetname_allow_fail( "garage_end_wave1" );
wave2 = array_spawn_targetname_allow_fail( "garage_end_wave2" );
wait 0.2;
enemies = GetAIArray( "axis" );
thread set_flag_on_killcount( enemies , int( enemies.size*0.8 ) , "flag_garage_wave_killed" );
thread do_jeep();
}
do_garage_move()
{
flag_wait( "flag_garage_wave_killed" );
SafeActivateTrigger( "trig_garage_move" );
flag_wait( "flag_garage_wave2_killed" );
SafeActivateTrigger( "trig_garage_move2" );
}
do_jeep()
{
jeep = spawn_vehicle_from_targetname( "garage_jeep" );
wait 0.2;
enemies = GetAIArray( "axis" );
thread set_flag_on_killcount( enemies , enemies.size-1 , "flag_garage_wave2_killed" );
jeep goPath();
aud_send_msg("humvee_pull_up", jeep);
flag_wait( "sjp_quick_stop" );
jeep.attachedpath = undefined;
jeep notify( "newpath" );
jeep Vehicle_SetSpeed( 0,20,20 );
wait 0.1;
jeep vehicle_unload();
}






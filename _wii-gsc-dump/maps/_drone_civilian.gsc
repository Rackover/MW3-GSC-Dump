#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
init()
{
level.drone_anims[ "neutral" ][ "stand" ][ "idle" ] = %casual_stand_idle;
level.drone_anims[ "neutral" ][ "stand" ][ "run" ] = %unarmed_scared_run;
level.drone_anims[ "neutral" ][ "stand" ][ "death" ] = %exposed_death;
level.attachPropsFunction = animscripts\civilian\civilian_init::attachProps;
maps\_drone::initGlobals();
}
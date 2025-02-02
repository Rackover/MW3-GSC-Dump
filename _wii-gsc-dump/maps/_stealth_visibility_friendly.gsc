#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
stealth_visibility_friendly_main()
{
self friendly_init();
self thread friendly_visibility_logic();
}
friendly_visibility_logic()
{
self endon( "death" );
self endon( "pain_death" );
current_stance_func = self._stealth.logic.current_stance_func;
if ( isPlayer( self ) )
self thread player_movespeed_calc_loop();
while ( 1 )
{
self ent_flag_wait( "_stealth_enabled" );
self [[ current_stance_func ]]();
assert( ent_flag( "_stealth_enabled" ) );
self.maxVisibleDist = self friendly_compute_score();
wait .05;
}
}
friendly_getvelocity()
{
return length( self getVelocity() );
}
player_getvelocity_pc()
{
velocity = length( self getVelocity() );
stance = self._stealth.logic.stance;
add = [];
add[ "stand" ] = 30;
add[ "crouch" ] = 15;
add[ "prone" ] = 4;
sub = [];
sub[ "stand" ] = 40;
sub[ "crouch" ] = 25;
sub[ "prone" ] = 10;
if ( !velocity )
self._stealth.logic.player_pc_velocity = 0;
else if ( velocity > self._stealth.logic.player_pc_velocity )
{
self._stealth.logic.player_pc_velocity += add[ stance ];
if ( self._stealth.logic.player_pc_velocity > velocity )
self._stealth.logic.player_pc_velocity = velocity;
}
else if ( velocity < self._stealth.logic.player_pc_velocity )
{
self._stealth.logic.player_pc_velocity -= sub[ stance ];
if ( self._stealth.logic.player_pc_velocity < 0 )
self._stealth.logic.player_pc_velocity = 0;
}
return self._stealth.logic.player_pc_velocity;
}
friendly_compute_score( stance )
{
if ( !isdefined( stance ) )
stance = self._stealth.logic.stance;
if ( stance == "back" )
stance = "prone";
detection_level = level._stealth.logic.detection_level;
score_range = level._stealth.logic.detect_range[ detection_level ][ stance ];
if ( self ent_flag( "_stealth_in_shadow" ) )
{
score_range *= .5;
if ( score_range < level._stealth.logic.detect_range[ "hidden" ][ "prone" ] )
score_range = level._stealth.logic.detect_range[ "hidden" ][ "prone" ];
}
score_move = self._stealth.logic.movespeed_multiplier[ detection_level ][ stance ];
if ( isdefined( self._stealth_move_detection_cap ) && score_move > self._stealth_move_detection_cap )
score_move = self._stealth_move_detection_cap;
return( score_range + score_move );
}
friendly_getstance_ai()
{
return self.a.pose;
}
friendly_getangles_ai()
{
return self.angles;
}
friendly_compute_stances_ai()
{
self._stealth.logic.stance = self [[ self._stealth.logic.getstance_func ]]();
self._stealth.logic.oldstance = self._stealth.logic.stance;
}
player_movespeed_calc_loop()
{
self endon( "death" );
self endon( "pain_death" );
angles_func = self._stealth.logic.getangles_func;
velocity_func = self._stealth.logic.getvelocity_func;
oldangles = self [[ angles_func ]]();
while ( 1 )
{
self ent_flag_wait( "_stealth_enabled" );
score = undefined;
if ( self ent_flag( "_stealth_in_shadow" ) )
{
score = 0;
}
else
{
score = self [[ velocity_func ]]();
}
foreach ( statename, state in self._stealth.logic.movespeed_multiplier )
{
foreach ( stancename, stance in state )
{
stance = score * self._stealth.logic.movespeed_scale[ statename ][ stancename ];
}
}
oldangles = self [[ angles_func ]]();
wait .1;
}
}
friendly_getstance_player()
{
return self getstance();
}
friendly_getangles_player()
{
return self getplayerangles();
}
friendly_compute_stances_player()
{
stance = self [[ self._stealth.logic.getstance_func ]]();
if ( !self._stealth.logic.stance_change )
{
switch( stance )
{
case "prone":
if ( self._stealth.logic.oldstance != "prone" )
self._stealth.logic.stance_change = self._stealth.logic.stance_change_time;
break;
case "crouch":
if ( self._stealth.logic.oldstance == "stand" )
self._stealth.logic.stance_change = self._stealth.logic.stance_change_time;
break;
}
}
if ( self._stealth.logic.stance_change )
{
self._stealth.logic.stance = self._stealth.logic.oldstance;
if ( self._stealth.logic.stance_change > .05 )
self._stealth.logic.stance_change -= .05;
else
{
self._stealth.logic.stance_change = 0;
self._stealth.logic.stance = stance;
self._stealth.logic.oldstance = stance;
}
}
else
{
self._stealth.logic.stance = stance;
self._stealth.logic.oldstance = stance;
}
}
friendly_init()
{
self ent_flag_init( "_stealth_in_shadow" );
self ent_flag_init( "_stealth_enabled" );
self ent_flag_set( "_stealth_enabled" );
assertex( !isdefined( self._stealth ), "you called maps\_stealth_logic::friendly_init() twice on the same ai or player" );
self._stealth = spawnstruct();
self._stealth.logic = spawnstruct();
if ( isPlayer( self ) )
{
self._stealth.logic.getstance_func = ::friendly_getstance_player;
self._stealth.logic.getangles_func = ::friendly_getangles_player;
if ( level.Console )
self._stealth.logic.getvelocity_func = ::friendly_getvelocity;
else
{
self._stealth.logic.getvelocity_func = ::player_getvelocity_pc;
self._stealth.logic.player_pc_velocity = 0;
}
self._stealth.logic.current_stance_func = ::friendly_compute_stances_player;
}
else
{
self._stealth.logic.getstance_func = ::friendly_getstance_ai;
self._stealth.logic.getangles_func = ::friendly_getangles_ai;
self._stealth.logic.getvelocity_func = ::friendly_getvelocity;
self._stealth.logic.current_stance_func = ::friendly_compute_stances_ai;
}
self._stealth.logic.stance_change_time = .2;
self._stealth.logic.stance_change = 0;
self._stealth.logic.oldstance = self [[ self._stealth.logic.getstance_func ]]();
self._stealth.logic.stance = self [[ self._stealth.logic.getstance_func ]]();
self._stealth.logic.spotted_list = [];
self._stealth.logic.movespeed_multiplier = [];
self._stealth.logic.movespeed_scale = [];
self._stealth.logic.movespeed_multiplier[ "hidden" ] = [];
self._stealth.logic.movespeed_multiplier[ "hidden" ][ "prone" ] = 0;
self._stealth.logic.movespeed_multiplier[ "hidden" ][ "crouch" ] = 0;
self._stealth.logic.movespeed_multiplier[ "hidden" ][ "stand" ] = 0;
self._stealth.logic.movespeed_multiplier[ "spotted" ] = [];
self._stealth.logic.movespeed_multiplier[ "spotted" ][ "prone" ] = 0;
self._stealth.logic.movespeed_multiplier[ "spotted" ][ "crouch" ] = 0;
self._stealth.logic.movespeed_multiplier[ "spotted" ][ "stand" ] = 0;
friendly_default_movespeed_scale();
}
friendly_default_movespeed_scale()
{
hidden = [];
hidden[ "prone" ] = 3;
hidden[ "crouch" ] = 2;
hidden[ "stand" ] = 2;
spotted = [];
spotted[ "prone" ] = 2;
spotted[ "crouch" ] = 2;
spotted[ "stand" ] = 2;
self friendly_set_movespeed_scale( hidden, spotted );
}
friendly_set_movespeed_scale( hidden, spotted )
{
if ( isdefined( hidden ) )
{
self._stealth.logic.movespeed_scale[ "hidden" ][ "prone" ] = hidden[ "prone" ];
self._stealth.logic.movespeed_scale[ "hidden" ][ "crouch" ] = hidden[ "crouch" ];
self._stealth.logic.movespeed_scale[ "hidden" ][ "stand" ] = hidden[ "stand" ];
}
if ( isdefined( spotted ) )
{
self._stealth.logic.movespeed_scale[ "spotted" ][ "prone" ] = spotted[ "prone" ];
self._stealth.logic.movespeed_scale[ "spotted" ][ "crouch" ] = spotted[ "crouch" ];
self._stealth.logic.movespeed_scale[ "spotted" ][ "stand" ] = spotted[ "stand" ];
}
}
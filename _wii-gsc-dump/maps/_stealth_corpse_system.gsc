#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
stealth_corpse_system_main()
{
stealth_corpse_system_init();
}
stealth_corpse_system_init()
{
assertEX( isdefined( level._stealth ), "There is no level._stealth struct.  You ran stealth behavior before running the detection logic.  Run _stealth_logic::main() in your level load first" );
flag_init( "_stealth_found_corpse" );
level._stealth.logic.corpse = spawnstruct();
level._stealth.logic.corpse.last_pos = undefined;
level._stealth.logic.corpse.distances = [];
stealth_corpse_default_distances();
level._stealth.logic.corpse.corpse_height = 6;
stealth_corpse_default_forget_time();
stealth_corpse_default_reset_time();
level._stealth.behavior.corpse = spawnstruct();
}
stealth_corpse_default_distances()
{
array = [];
array[ "player_dist" ] = 1500;
array[ "sight_dist" ] = 1500;
array[ "detect_dist" ] = 256;
array[ "found_dist" ] = 96;
array[ "found_dog_dist" ] = 50;
stealth_corpse_set_distances( array );
}
stealth_corpse_set_distances( array )
{
foreach ( key, value in array )
level._stealth.logic.corpse.distances[ key ] = value;
level._stealth.logic.corpse.player_distsqrd = squared( level._stealth.logic.corpse.distances[ "player_dist" ] );
level._stealth.logic.corpse.sight_distsqrd = squared( level._stealth.logic.corpse.distances[ "sight_dist" ] );
level._stealth.logic.corpse.detect_distsqrd = squared( level._stealth.logic.corpse.distances[ "detect_dist" ] );
level._stealth.logic.corpse.found_distsqrd = squared( level._stealth.logic.corpse.distances[ "found_dist" ] );
level._stealth.logic.corpse.found_dog_distsqrd = squared( level._stealth.logic.corpse.distances[ "found_dog_dist" ] );
}
stealth_corpse_default_reset_time()
{
stealth_corpse_set_reset_time( 30 );
}
stealth_corpse_set_reset_time( time )
{
level._stealth.logic.corpse.reset_time = time;
}
stealth_corpse_default_forget_time()
{
stealth_corpse_set_forget_time( 60 );
}
stealth_corpse_set_forget_time( time )
{
level._stealth.logic.corpse.forget_time = time;
}
stealth_corpse_set_collect_func( func )
{
AssertEx( IsDefined( level._stealth.logic.corpse ), "Tried to set the corpse collect function before the corpse system was initialized." );
level._stealth.logic.corpse.collect_func = func;
}
stealth_corpse_default_collect_func()
{
AssertEx( IsDefined( level._stealth.logic.corpse ), "Tried to clear the corpse collect function before the corpse system was initialized." );
level._stealth.logic.corpse.collect_func = undefined;
}
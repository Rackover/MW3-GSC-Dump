#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_1.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_1.csv";	// enables player load out override
	
	// Make easy enemies not somolians for paris, looks silly.
	maps\_so_survival_ai::ai_type_add_override_class( "easy", "actor_enemy_so_easy_v2" );
	
	// mp map precache and art
	maps\mp\mp_paris_precache::main();
	maps\createart\mp_paris_art::main();
	maps\mp\mp_paris_fx::main();
	maps\createfx\mp_paris_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_paris" );	
	
	// survival mode post load
	maps\_utility::set_vision_set( "mp_paris", 0 );
	maps\_so_survival::survival_postload();
	
	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_paris" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();	
}
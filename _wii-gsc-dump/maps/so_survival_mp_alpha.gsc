#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.wave_table 	= "sp/so_survival/tier_4.csv";	// enables wave definition override
	level.loadout_table = "sp/so_survival/tier_4.csv";	// enables player load out override
	
	// mp map precache and art
	maps\mp\mp_alpha_precache::main();
	maps\createart\mp_alpha_art::main();
	maps\mp\mp_alpha_fx::main();
	maps\createfx\mp_alpha_fx::main();
	
	// survival mode precache
	maps\_so_survival::survival_preload();
	
	maps\_load::main();
	
	AmbientPlay( "ambient_mp_alpha" );
	
	// survival mode post load
	maps\_utility::set_vision_set( "mp_alpha", 0 );
	maps\_so_survival::survival_postload();

	// mini map
	maps\_compass::setupMiniMap( "compass_map_mp_alpha" );
	
	// kick off survival mode
	maps\_so_survival::survival_init();
}
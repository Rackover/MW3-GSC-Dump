#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
initChickens()
{
waittillframeend;
cages = getentarray( "caged_chicken", "targetname" );
array_thread( cages, ::spawnChicken );
}
spawnChicken()
{
chicken = spawn_anim_model( "chicken" );
self thread anim_single_solo( chicken, "cage_freakout" );
anime = chicken getanim( "cage_freakout" );
starttime = RandomFloatRange( 0, 1.0 );
chicken SetAnimTime( anime, starttime );
for ( ;; )
{
chicken playsound( "animal_chicken_idle", "sounddone" );
chicken waittill( "sounddone" );
}
}

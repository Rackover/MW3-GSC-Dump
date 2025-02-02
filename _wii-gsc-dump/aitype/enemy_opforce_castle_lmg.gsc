
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "glock";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(5) )
{
case 0:
self.weapon = "sa80";
break;
case 1:
self.weapon = "sa80_scope";
break;
case 2:
self.weapon = "pecheneg";
break;
case 3:
self.weapon = "pecheneg_acog";
break;
case 4:
self.weapon = "pecheneg_reflex";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_henchmen_lmg_a::main();
break;
case 1:
character\character_opforce_henchmen_lmg_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_lmg_a::precache();
character\character_opforce_henchmen_lmg_b::precache();
precacheItem("sa80");
precacheItem("sa80_scope");
precacheItem("pecheneg");
precacheItem("pecheneg_acog");
precacheItem("pecheneg_reflex");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_lmg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_lmg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}


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
self.sidearm = "p99";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 768.000000 );
}
switch( codescripts\character::get_random_weapon(6) )
{
case 0:
self.weapon = "pp90m1";
break;
case 1:
self.weapon = "pp90m1_reflex";
break;
case 2:
self.weapon = "pp90m1_silencer";
break;
case 3:
self.weapon = "ak74u";
break;
case 4:
self.weapon = "ak74u_reflex";
break;
case 5:
self.weapon = "ak74u_silencer";
break;
}
character\character_opforce_paris_smg::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_paris_smg::precache();
precacheItem("pp90m1");
precacheItem("pp90m1_reflex");
precacheItem("pp90m1_silencer");
precacheItem("ak74u");
precacheItem("ak74u_reflex");
precacheItem("ak74u_silencer");
precacheItem("p99");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_paris_smg::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}

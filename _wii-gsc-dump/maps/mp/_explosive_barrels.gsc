main()
{
	//------------------
	//EFECTS DEFINITIONS
	//------------------
	
		qBarrels = false;
		precacheItem( "barrel_mp" );
		barrels = getentarray ("explodable_barrel","targetname");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBarrels = true;
		barrels = getentarray ("explodable_barrel","script_noteworthy");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBarrels = true;
		if (qBarrels)
		{
			level.breakables_fx["barrel"]["explode"] 	= loadfx ("props/barrelExp");
			level.breakables_fx["barrel"]["burn_start"]	= loadfx ("props/barrel_ignite");
			level.breakables_fx["barrel"]["burn"]	 	= loadfx ("props/barrel_fire_top");
		}
		oilspill = getentarray ("oil_spill","targetname");
		if(isdefined(oilspill) && oilspill.size > 0)
		{
			level.breakables_fx["oilspill"]["burn"]		= loadfx ("props/barrel_fire");	
			level.breakables_fx["oilspill"]["spark"]	= loadfx("impacts/small_metalhit_1"); 
		}
		
	//------------------
	//------------------
	
	
	//-----------------
	//SOUND DEFINITIONS
	//-----------------
		level.barrelExpSound = "explo_metal_rand";
	//-----------------
	//-----------------
	
		
		level.barrelHealth = 150;
		maxBrokenPieces = 25;
	//-------------
	//-------------
	
	level.precachemodeltype = [];
	level.barrelExplodingThisFrame = false;
	level.breakables_clip = [];
	
	temp = getentarray ("breakable clip","targetname");
	for (i=0;i<temp.size;i++)
		level.breakables_clip[level.breakables_clip.size] = temp[i];
	level._breakable_utility_modelarray = [];
	level._breakable_utility_modelindex = 0;
	level._breakable_utility_maxnum = maxBrokenPieces;
	common_scripts\utility::array_thread(getentarray ("explodable_barrel","targetname"), ::explodable_barrel_think);
	//common_scripts\utility::array_thread(getentarray ("explodable_barrel","script_noteworthy"), ::explodable_barrel_think); ASK MO
	common_scripts\utility::array_thread(getentarray ("oil_spill", "targetname"), ::oil_spill_think);
}

oil_spill_think()
{
	self.end = getstruct(self.target, "targetname");
	self.start = getstruct(self.end.target, "targetname");
	self.barrel = getClosestEnt(self.start.origin, getentarray ("explodable_barrel","targetname"));
	self.extra = getent(self.target, "targetname");
	self setcandamage(true);
	
	if(isdefined(self.barrel))
	{
		self.barrel.oilspill = true;
		self thread oil_spill_burn_after();
	}
	
	while(1)
	{
		self waittill("damage", other, damage, direction_vec, P, type );
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		
		self.damageOwner = other;
		
		playfx (level.breakables_fx["oilspill"]["spark"], P, direction_vec);
		//P = pointOnSegmentNearestToPoint(self.start.origin, self.end.origin, P);
		thread oil_spill_burn_section(P);
		self thread oil_spill_burn(P, self.start.origin);
		self thread oil_spill_burn(P, self.end.origin);
		break;
	}
	if(isdefined(self.barrel))
		self.barrel waittill("exploding");
	
	self.extra delete();
	self hide();
	
	wait 10;
	self delete();
}

getClosestEnt(org, array)
{
	if (array.size < 1)
		return;
		
//	dist = distance(array[0] getorigin(), org);
//	ent = array[0];
	dist = 256;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

oil_spill_burn_after()
{
	while(1)
	{
		self.barrel waittill("damage", amount ,attacker, direction_vec, P, type);
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		break;
	}
	self.damageOwner = attacker;
	
	// do not pass damage owner if they have disconnected before the barrels explode
	if ( !isdefined( self.damageOwner ) ) 
		self radiusdamage (self.origin, 4, 10, 10 );
	else
		self radiusdamage (self.origin, 4, 10, 10, self.damageOwner);
}

oil_spill_burn(P, dest)
{
	
	forward = vectornormalize(dest - P);
	dist = distance(p, dest);
	range = 8;
	interval = (forward * range);	
	angle = vectortoangles(forward);
	right = anglestoright(angle);
	
	barrels = getentarray ("explodable_barrel","targetname");
	distsqr = 22 * 22;
	
	test = spawn("script_origin", P);
	test hide();
	
	num = 0;
	while(1)
	{
		dist -= range;
		if(dist < range *.1)
			break;
			
		p += (interval + (right * randomfloatrange(-6, 6)));		
		
		thread oil_spill_burn_section(P);
		num++;
		if(num == 4)
		{
			num = 0;
		}
		
		test.origin = P;
		
		remove = [];
		barrels = common_scripts\utility::array_removeUndefined(barrels);
		for(i=0; i<barrels.size; i++)
		{
			vec = anglestoup(barrels[i].angles);
			start = barrels[i].origin + (vec * 22);
			pos = physicstrace(start, start + (0,0,-64));
			
			if(distancesquared(P, pos) < distsqr) 
			{
				remove[remove.size] = barrels[i];
				d = (80 + randomfloat(10));
				
				if ( !isdefined ( self.damageOwner ) )
					self radiusdamage (barrels[i].origin, 4, d, d);
				else
					self radiusdamage (barrels[i].origin, 4, d, d, self.damageOwner);
				//barrels[i] dodamage(  , P);
			}
		}
		for(i=0; i<remove.size; i++)
			barrels = common_scripts\utility::array_remove(barrels, remove[i]);	
		wait .1;
	}		
	
	if(!isdefined(self.barrel))
		return;
	if( distance(P, self.start.origin) < 32)
	{
		d = (80 + randomfloat(10));
		if ( !isdefined ( self.damageOwner ) )
			self radiusdamage (self.barrel.origin, 4, d, d);
		else
			self radiusdamage (self.barrel.origin, 4, d, d, self.damageOwner);
	}
}

oil_spill_burn_section(P)
{
	count = 0;
	time = 0;
	playfx (level.breakables_fx["oilspill"]["burn"], P);
	
	while(time < 5)
	{
		if ( !isdefined ( self.damageOwner ) )
			self radiusdamage(P, 32, 5, 1);
		else
			self radiusdamage(P, 32, 5, 1, self.damageOwner);
		time += 1;
		wait 1;
	}
}

explodable_barrel_think()
{	
	if (self.classname != "script_model")
		return;
//	if ( (self.model != "com_barrel_benzin") && (self.model != "com_barrel_benzin_snow") )
//		return;
	if(!isdefined(level.precachemodeltype["com_barrel_benzin"]))
	{
		level.precachemodeltype["com_barrel_benzin"] = true;
//*		precacheModel("com_barrel_piece");
		precacheModel("com_barrel_piece2");	
	}
	self endon ("exploding");
	
	self breakable_clip();
	self.damageTaken = 0;
	self setcandamage(true);
	for (;;)
	{
		self waittill("damage", amount ,attacker, direction_vec, P, type);
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		
		self.damagetype = type;
		
		self.damageOwner = attacker;
			
		if (level.barrelExplodingThisFrame)
			wait randomfloat(1);
		self.damageTaken += amount;
		if (self.damageTaken == amount)
			self thread explodable_barrel_burn();
	}
}

explodable_barrel_burn()
{
	count = 0;
	startedfx = false;
	
	up = anglestoup(self.angles);
	worldup = anglestoup((0,90,0));
	dot = vectordot(up, worldup);
	
	offset1 = (0,0,0);
	offset2 =  (up * 44);
	
	if(dot < .5)
	{
		offset1 =  (up * 22) - (0,0,30);
		offset2 =  (up * 22) + (0,0,14);	
	}
	
	if( self.damagetype != "MOD_GRENADE_SPLASH" && self.damagetype != "MOD_GRENADE" )
	{
		while (self.damageTaken < level.barrelHealth)
		{
			if (!startedfx)
			{
				playfx (level.breakables_fx["barrel"]["burn_start"], self.origin + offset1);
				startedfx = true;
			}
			if (count > 15) //FPS
				count = 0;
			
			playfx (level.breakables_fx["barrel"]["burn"], self.origin + offset2);
			
			if (count == 0)
			{
				self.damageTaken += (10 + randomfloat(10));
			}
			count++;
			wait 0.05;
		}
	}
	self thread explodable_barrel_explode();
}

explodable_barrel_explode()
{
	self notify ("exploding");
	self notify ("death");

	up = anglestoup(self.angles);
	worldup = anglestoup((0,90,0));
	dot = vectordot(up, worldup);
	
	offset = (0,0,0);
	if(dot < .5)
	{
		start = (self.origin + (up * 22));
		end  = physicstrace(start, (start + (0,0,-64)));
		offset = end - self.origin;
	}
	offset += (0,0,4);
	
	self playsound (level.barrelExpSound);
	//level thread play_sound_in_space(level.barrelExpSound, self.origin);
	playfx (level.breakables_fx["barrel"]["explode"], self.origin + offset);
	
	level.barrelExplodingThisFrame = true;
	
	if (isdefined (self.remove))
	{
		self.remove delete();
	}
	
	phyExpMagnitude = 2;
	minDamage = 1;
	maxDamage = 250;
	blastRadius = 250;
	if (isdefined(self.radius))
		blastRadius = self.radius;
	
	// do not pass damage owner if they have disconnected before the barrels explode
	if ( !isdefined( self.damageOwner ) ) 
		self radiusDamage(self.origin + (0,0,30), blastRadius, maxDamage, minDamage, undefined, "MOD_EXPLOSIVE", "barrel_mp");
	else
		self radiusDamage(self.origin + (0,0,30), blastRadius, maxDamage, minDamage, self.damageOwner, "MOD_EXPLOSIVE", "barrel_mp" );
		
	physicsExplosionSphere( self.origin + (0,0,30), blastRadius, blastRadius/2, phyExpMagnitude );
	
	self maps\mp\gametypes\_shellshock::barrel_earthQuake();
		
//*	if (randomint(2) == 0)
//*		self setModel("com_barrel_piece");
//*	else
		self setModel("com_barrel_piece2");
	self setCanDamage( false );
	
	if(dot < .5)
	{
		start = (self.origin + (up * 22));
		pos = physicstrace(start, (start + (0,0,-64)));
		
		self.origin = pos;
		self.angles += (0,0,90);
			
	}
	wait 0.05;
	level.barrelExplodingThisFrame = false;
}

getstruct(name, type)
{
	if(!isdefined(level.struct_class_names))
		return undefined;
	
	array = level.struct_class_names[type][name];
	if(!isdefined(array))
		return undefined;
	if(array.size > 1)
	{
		assertMsg ("getstruct used for more than one struct of type " + type + " called " + name +".");
		return undefined;
	}
	return array[0];
}

breakable_clip()
{
	//targeted brushmodels take priority over proximity based breakables - nate
	if (isdefined(self.target))
	{
		targ = getent(self.target,"targetname");
		if(targ.classname == "script_brushmodel")
		{
			self.remove = targ;
			return;
		}
	}
	//setup it's removable clip part
	if ((isdefined (level.breakables_clip)) && (level.breakables_clip.size > 0))
		self.remove = getClosestEnt( self.origin , level.breakables_clip );
	if (isdefined (self.remove))
		level.breakables_clip = common_scripts\utility::array_remove ( level.breakables_clip , self.remove );
}


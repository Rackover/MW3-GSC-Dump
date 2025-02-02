#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_sp_killstreaks;
#include maps\_sp_airdrop;
remotemissile_infantry_kills_dialogue_setup()
{
level.scr_radio[ "inv_hqr_fivenotenkills" ] = "inv_hqr_fivenotenkills";
level.scr_radio[ "inv_hqr_tenmoreconfirms" ] = "inv_hqr_tenmoreconfirms";
level.scr_radio[ "inv_hqr_tenpluskia" ] = "inv_hqr_tenpluskia";
level.scr_radio[ "inv_hqr_fiveplus" ] = "inv_hqr_fiveplus";
level.scr_radio[ "inv_hqr_another5plus" ] = "inv_hqr_another5plus";
level.scr_radio[ "inv_hqr_morethanfive" ] = "inv_hqr_morethanfive";
level.scr_radio[ "inv_hqr_yougotem" ] = "inv_hqr_yougotem";
level.scr_radio[ "inv_hqr_goodkills" ] = "inv_hqr_goodkills";
level.scr_radio[ "inv_hqr_directhit" ] = "inv_hqr_directhit";
level.scr_radio[ "inv_hqr_hesdown" ] = "inv_hqr_hesdown";
}
remotemissile_infantry_kills_dialogue()
{
dialog10 = [];
dialog10[dialog10.size] = "inv_hqr_tenpluskia";
dialog10[dialog10.size] = "inv_hqr_tenmoreconfirms";
dialog10[dialog10.size] = "inv_hqr_fivenotenkills";
current_dialog10 = 0;
dialog5 = [];
dialog5[dialog5.size] = "inv_hqr_fiveplus";
dialog5[dialog5.size] = "inv_hqr_another5plus";
dialog5[dialog5.size] = "inv_hqr_morethanfive";
current_dialog5 = 0;
said_hes_down = false;
said_direct_hit = false;
level.enemies_killed = 0;
kills = 0;
while( 1 )
{
level waittill( "remote_missile_exploded" );
old_num = level.enemies_killed;
wait .1;
if( isdefined( level.uav_killstats[ "ai" ] ) )
kills = level.uav_killstats[ "ai" ];
if( kills == 0 )
{
continue;
}
wait .5;
if( isdefined( level.uav_is_destroyed ) )
return;
if( kills == 1 )
{
if( said_hes_down )
{
radio_dialogue( "inv_hqr_yougotem" );
said_hes_down = false;
}
else
{
radio_dialogue( "inv_hqr_hesdown" );
said_hes_down = true;
}
continue;
}
if( kills >= 10 )
{
radio_dialogue( dialog10[current_dialog10] );
current_dialog10++;
if( current_dialog10 >= dialog10.size )
current_dialog10 = 0;
continue;
}
if( kills >= 5 )
{
radio_dialogue( dialog5[current_dialog5] );
current_dialog5++;
if( current_dialog5 >= dialog5.size )
current_dialog5 = 0;
continue;
}
else
{
if( said_direct_hit )
{
radio_dialogue( "inv_hqr_goodkills" );
said_direct_hit = false;
}
else
{
radio_dialogue( "inv_hqr_directhit" );
said_direct_hit = true;
}
continue;
}
}
}
remotemissile_uav()
{
if (!using_wii())
return;
level.uav = spawn_vehicle_from_targetname( "remotemissile_uav" );
pathStart = GetVehicleNode( "vnode_remotemissile_uav_start", "targetname" );
level.uav AttachPath( pathStart );
gopath( level.uav );
level.uav PlayLoopSound( "uav_engine_loop" );
level.uavRig = Spawn( "script_model", level.uav.origin );
level.uavRig SetModel( "tag_origin" );
level thread uav_rig_aiming();
}
uav_rig_aiming()
{
level.uav endon( "death" );
focusPoints = GetStructArray( "uav_focus_point", "targetname" );
ASSERT( focusPoints.size );
while( 1 )
{
focus_origin = level.player.origin;
if ( isdefined( level.uav_user ) )
focus_origin = level.uav_user.origin;
closestPoint = getclosest( focus_origin, focusPoints );
targetPos = closestPoint.origin;
angles = VectorToAngles( targetPos - level.uav.origin );
level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
level.uavRig RotateTo( angles, 0.10, 0, 0 );
wait( 0.05 );
}
}
ai_remote_missile_fof_outline()
{
if (!using_wii())
return;
if( !isAI( self ) )
return;
if( IsDefined( self.ridingvehicle ) )
{
self endon( "death" );
self waittill( "jumpedout" );
}
self maps\_remotemissile_utility::setup_remote_missile_target();
}
splash_notify_message( splashData )
{
self endon( "death" );
assert( isDefined( splashData.title ) );
if( !IsDefined( splashData.type ) )
splashData.type = "";
duration = splashData.duration;
transTime = 0.15;
self.doingNotify = true;
self.splashTitle transitionReset();
self.splashDesc transitionReset();
self.splashDesc1 transitionReset();
self.splashDesc2 transitionReset();
self.splashDesc3 transitionReset();
self.splashDesc4 transitionReset();
self.splashHint transitionReset();
self.splashIcon transitionReset();
wait ( 0.05 );
SetSavedDvar( "cg_drawBreathHint", "0" );
elements = [];
elements[elements.size] = self.splashTitle;
self.splashTitle.label = splashData.title;
if( IsDefined( splashData.title_set_value ) )
self.splashTitle SetValue( splashData.title_set_value );
self.splashTitle SetPulseFX( int( 5 * duration ), int( duration * 1000 ), 1000 );
og_title_font = self.splashTitle.font;
if( IsDefined( splashData.title_font ) )
self.splashTitle.font = splashData.title_font;
og_title_label = splashData.title;
if ( isDefined( splashData.title_label ) )
self.splashTitle.label = splashData.title_label;
og_title_baseFontScale = self.splashTitle.baseFontScale;
if( IsDefined( splashData.title_baseFontScale ) )
self.splashTitle.baseFontScale = splashData.title_baseFontScale;
og_title_glowColor = self.splashTitle.glowColor;
og_title_glowAlpha = self.splashTitle.glowAlpha;
if ( IsDefined( splashData.title_glowColor ) )
{
self.splashTitle.glowColor = splashData.title_glowColor;
self.splashTitle.glowAlpha = 1.0;
}
og_title_color = self.splashTitle.color;
if ( isDefined( splashData.title_color ) )
{
og_title_color = splashData.title_color;
self.splashTitle.color = splashData.title_color;
}
og_icon_shader = self.splashIcon.shader;
if ( isDefined( splashData.icon ) && splashData.icon != "" )
{
elements[elements.size] = self.splashIcon;
self.splashIcon.shader = splashData.icon;
}
og_desc_font = undefined;
og_desc_baseFontScale	= undefined;
if ( isDefined( splashData.desc ) && (!isString( splashData.desc ) || splashData.desc != "") )
{
elements[elements.size] = self.splashDesc;
self.splashDesc.label = splashData.desc;
if ( isdefined( splashData.desc_set_value ) )
self.splashDesc SetValue( splashData.desc_set_value );
og_desc_font = self.splashDesc.font;
if( IsDefined( splashData.desc_font ) )
self.splashDesc.font = splashData.Desc_Font;
og_desc_baseFontScale = self.splashDesc.baseFontScale;
if( IsDefined( splashData.desc_baseFontScale ) )
self.splashDesc.baseFontScale = splashData.desc_baseFontScale;
if ( isDefined( splashData.desc1 ) && (!isString( splashData.desc1 ) || splashData.desc1 != "") )
{
elements[elements.size] = self.splashDesc1;
self.splashDesc1.label = splashData.desc1;
self.splashDesc1.font = self.splashDesc.font;
if ( isdefined( splashData.desc1_set_value ) )
self.splashDesc1 SetValue( splashData.desc1_set_value );
}
if ( isDefined( splashData.desc2 ) && (!isString( splashData.desc2 ) || splashData.desc2 != "") )
{
elements[elements.size] = self.splashDesc2;
self.splashDesc2.label = splashData.desc2;
self.splashDesc2.font = self.splashDesc.font;
if ( isdefined( splashData.desc2_set_value ) )
self.splashDesc2 SetValue( splashData.desc2_set_value );
}
if ( isDefined( splashData.desc3 ) && (!isString( splashData.desc3 ) || splashData.desc3 != "") )
{
elements[elements.size] = self.splashDesc3;
self.splashDesc3.label = splashData.desc3;
self.splashDesc3.font = self.splashDesc.font;
if ( isdefined( splashData.desc3_set_value ) )
self.splashDesc3 SetValue( splashData.desc3_set_value );
}
if ( isDefined( splashData.desc4 ) && (!isString( splashData.desc4 ) || splashData.desc4 != "") )
{
elements[elements.size] = self.splashDesc4;
self.splashDesc4.label = splashData.desc4;
self.splashDesc4.font = self.splashDesc.font;
if ( isdefined( splashData.desc4_set_value ) )
self.splashDesc4 SetValue( splashData.desc4_set_value );
}
}
if ( isDefined( splashData.hint ) && ( !isString( splashData.hint ) || splashData.hint != "") )
{
elements[elements.size] = self.splashHint;
self.splashHint.label = splashData.hint;
if ( isDefined( splashData.hintLabel ) )
self.splashHint.label = splashData.hintLabel;
}
if ( isDefined( splashData.fadeIn ) )
{
foreach ( element in elements )
element transitionFadeIn( transTime );
}
if ( isDefined( splashData.zoomIn ) )
{
foreach ( element in elements )
element transitionZoomIn( transTime );
}
if ( isDefined( splashData.slideIn ) )
{
foreach ( element in elements )
element transitionSlideIn( transTime, splashData.slideIn );
}
if ( isDefined( splashData.pulseFXIn ) )
{
foreach ( element in elements )
element transitionPulseFXIn( transTime, duration );
}
if ( isDefined( splashData.sound ) )
{
if( IsDefined( splashData.playSoundLocally ) )
{
self PlayLocalSound( splashData.sound );
}
else
{
foreach( player in level.players )
player playLocalSound( splashData.sound );
}
}
if( IsDefined( splashData.abortFlag ) )
ent_flag_wait_or_timeout( splashData.abortFlag, duration );
else
wait ( duration );
if ( isDefined( splashData.fadeOut ) )
{
foreach ( element in elements )
element transitionFadeOut( transTime );
}
if ( isDefined( splashData.zoomOut ) )
{
foreach ( element in elements )
element transitionZoomOut( transTime );
}
if ( isDefined( splashData.slideOut ) )
{
foreach ( element in elements )
element transitionSlideOut( transTime, splashData.slideOut );
}
wait( transTime );
SetSavedDvar( "cg_drawBreathHint", "1" );
self.splashTitle.font = og_title_font;
self.splashTitle.label = og_title_label;
self.splashTitle.baseFontScale	= og_title_baseFontScale;
self.splashTitle.glowColor = og_title_glowColor;
self.splashTitle.glowAlpha = og_title_glowAlpha;
self.splashTitle.color = og_title_color;
self.splashIcon.shader = og_icon_shader;
if( IsDefined( og_desc_font ) )
self.splashDesc.font = og_desc_font;
if( IsDefined( og_desc_baseFontScale ) )
self.splashDesc.baseFontScale = og_desc_baseFontScale;
self.doingNotify = false;
}
player_reward_splash_init()
{
line_yOffset = 15;
if ( IsSplitscreen() )
{
titleFont = "objective";
titleSize = 2.25;
title_yOffset = 10;
title_xOffset = 0;
textFont = "objective";
textSize = 1;
text_yOffset = 57;
text_xOffset = 0;
text2Font = "small";
text2Size = 1.4;
text2_yOffset = 72;
text2_xOffset = 0;
iconSize = 24;
icon_yOffset = 5;
icon_xOffset = 0;
point = "TOP";
relativePoint = "BOTTOM";
}
else
{
titleFont = "objective";
titleSize = 2.5;
title_yOffset = 10;
title_xOffset = 0;
textFont = "objective";
textSize = 1.1;
text_yOffset = 42;
text_xOffset = 0;
text2Font = "small";
text2Size = 1.5;
text2_yOffset = 300;
text2_xOffset = 0;
iconSize = 42;
icon_yOffset = 250;
icon_xOffset = 0;
point = "TOP";
relativePoint = "BOTTOM";
}
elem = createFontString_mp( titleFont, titleSize );
elem maps\_hud_util::setPoint( point, undefined, title_xOffset, title_yOffset );
elem.glowColor = ( 0.3, 0.6, 0.3 );
elem.glowAlpha = 1;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashTitle = elem;
elem = undefined;
elem = createFontString_mp( textFont, textSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashDesc = elem;
elem = undefined;
elem = createFontString_mp( textFont, textSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(1*(line_yOffset)) );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashDesc1 = elem;
elem = undefined;
elem = createFontString_mp( textFont, textSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(2*(line_yOffset)) );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashDesc2 = elem;
elem = undefined;
elem = createFontString_mp( textFont, textSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(3*(line_yOffset)) );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashDesc3 = elem;
elem = undefined;
elem = createFontString_mp( textFont, textSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem maps\_hud_util::setPoint( point, relativePoint, text_xOffset, text_yOffset+(4*(line_yOffset)) );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashDesc4 = elem;
elem = undefined;
elem = createFontString_mp( "hudbig", 0.75 );
elem maps\_hud_util::setParent( self.splashDesc );
elem maps\_hud_util::setPoint( point, relativePoint, text2_xOffset, text2_yOffset );
elem.glowColor = ( 0, 0, 0 );
elem.glowAlpha = 0;
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
elem.color = ( 0.75, 1, 0.75 );
self.splashHint = elem;
elem = undefined;
elem = createIcon_mp( "white", iconSize, iconSize );
elem maps\_hud_util::setParent( self.splashTitle );
elem setPoint( point, relativePoint, icon_xOffset, icon_yOffset );
elem.hideWhenInMenu = true;
elem.archived = false;
elem.alpha = 0;
self.splashIcon = elem;
}
createFontString_mp( font, textSize )
{
fontElem = NewClientHudElem( self );
fontElem.hidden = false;
fontElem.elemType = "font";
fontElem.font = font;
fontElem.fontscale = textSize;
fontElem.baseFontScale = fontElem.fontScale;
fontElem.x = 0;
fontElem.y = 0;
fontElem.width = 0;
fontElem.height = int( level.fontHeight * fontElem.fontScale );
fontElem.xOffset = 0;
fontElem.yOffset = 0;
fontElem.children = [];
fontElem maps\_hud_util::setParent( level.uiParent );
return fontElem;
}
createIcon_mp( shader, width, height )
{
iconElem = NewClientHudElem( self );
iconElem.elemType = "icon";
iconElem.x = 0;
iconElem.y = 0;
iconElem.width = width;
iconElem.height = height;
iconElem.baseWidth = iconElem.width;
iconElem.baseHeight = iconElem.height;
iconElem.xOffset = 0;
iconElem.yOffset = 0;
iconElem.children = [];
iconElem maps\_hud_util::setParent( level.uiParent );
iconElem.hidden = false;
if ( isDefined( shader ) )
{
iconElem setShader( shader, width, height );
iconElem.shader = shader;
}
return iconElem;
}
waittill_players_ready_for_splash( timeoutSecs )
{
timeoutTime = GetTime() + milliseconds( timeoutSecs );
while( 1 )
{
if( GetTime() >= timeoutTime )
{
break;
}
delay = false;
foreach( player in level.players )
{
if( player.doingNotify || (!using_wii() && player.using_uav) )
{
delay = true;
break;
}
}
if( delay )
{
wait( 0.1 );
}
else
{
break;
}
}
}
transitionReset()
{
self SetText( "" );
self.x = self.xOffset;
self.y = self.yOffset;
if ( self.elemType == "font" )
{
self.fontScale = self.baseFontScale;
self.label = &"";
}
else if ( self.elemType == "icon" )
{
self setShader( self.shader, self.width, self.height );
}
self.alpha = 0;
}
transitionZoomIn( duration )
{
switch ( self.elemType )
{
case "font":
case "timer":
self.fontScale = 6.3;
self changeFontScaleOverTime( duration );
self.fontScale = self.baseFontScale;
break;
case "icon":
self setShader( self.shader, self.width * 6, self.height * 6 );
self scaleOverTime( duration, self.width, self.height );
break;
}
}
transitionPulseFXIn( inTime, duration )
{
transTime = int(inTime)*1000;
showTime = int(duration)*1000;
switch ( self.elemType )
{
case "font":
case "timer":
self setPulseFX( transTime+250, showTime+transTime, transTime+250 );
break;
default:
break;
}
}
transitionSlideIn( duration, direction )
{
if ( !isDefined( direction ) )
direction = "left";
switch ( direction )
{
case "left":
self.x += 1000;
break;
case "right":
self.x -= 1000;
break;
case "up":
self.y -= 1000;
break;
case "down":
self.y += 1000;
break;
}
self moveOverTime( duration );
self.x = self.xOffset;
self.y = self.yOffset;
}
transitionSlideOut( duration, direction )
{
if ( !isDefined( direction ) )
direction = "left";
gotoX = self.xOffset;
gotoY = self.yOffset;
switch ( direction )
{
case "left":
gotoX += 1000;
break;
case "right":
gotoX -= 1000;
break;
case "up":
gotoY -= 1000;
break;
case "down":
gotoY += 1000;
break;
}
self.alpha = 1;
self moveOverTime( duration );
self.x = gotoX;
self.y = gotoY;
}
transitionZoomOut( duration )
{
switch ( self.elemType )
{
case "font":
case "timer":
self changeFontScaleOverTime( duration );
self.fontScale = 6.3;
case "icon":
self scaleOverTime( duration, self.width * 6, self.height * 6 );
break;
}
}
transitionFadeIn( duration )
{
self fadeOverTime( duration );
if ( isDefined( self.maxAlpha ) )
self.alpha = self.maxAlpha;
else
self.alpha = 1;
}
transitionFadeOut( duration )
{
self fadeOverTime( 0.15 );
self.alpha = 0;
}
get_spawners_by_classname( classname )
{
spawners = getentarray( classname, "classname" );
real_spawners = [];
foreach( spawner in spawners )
{
if ( isspawner( spawner ) )
real_spawners[ real_spawners.size ] = spawner;
}
return real_spawners;
}
get_spawners_by_targetname( targetname )
{
all_spawners = getspawnerarray();
found_spawners = [];
foreach( spawner in all_spawners )
if ( isdefined( spawner.targetname ) && spawner.targetname == targetname )
found_spawners[ found_spawners.size ] = spawner;
return found_spawners;
}
get_furthest_from_these( array, avoid_locs, rand_locs_num )
{
rand_locs_num = ter_op( isdefined( rand_locs_num ), rand_locs_num, 1 );
rand_locs_num = max( 1, rand_locs_num );
while( array.size > rand_locs_num )
{
foreach ( avoid_loc in avoid_locs )
{
element = getclosest( avoid_loc.origin, array );
if ( array.size > rand_locs_num )
{
array = array_remove( array, element );
}
else
{
element = array[ 0 ];
thread maps\_squad_enemies::draw_debug_marker( element.origin, ( 1, 1, 1 ) );
break;
}
}
}
return array[ randomint( array.size ) ];
}
throw_grenade_at_player( player )
{
self endon( "death" );
player endon( "stopped camping" );
if ( cointoss() )
self.grenadeweapon = "flash_grenade";
else
self.grenadeweapon = "fraggrenade";
self.grenadeammo = 2;
self.script_forceGrenade = 1;
wait 8;
self.script_forceGrenade = 0;
self.grenadeweapon = "fraggrenade";
}
clear_from_boss_array_when_dead()
{
self waittill( "death" );
bosses = [];
foreach( boss in level.bosses )
if ( isdefined( boss ) && ( !isdefined( self ) || self != boss ) )
bosses[ bosses.size ] = boss;
level.bosses = bosses;
}
clear_from_special_ai_array_when_dead()
{
self waittill( "death" );
special_ais = [];
foreach( ai in level.special_ai )
{
if ( isalive( ai ) )
special_ais[ special_ais.size ] = ai;
}
level.special_ai = special_ais;
}
was_headshot()
{
if ( IsDefined( self.died_of_headshot ) && self.died_of_headshot )
return true;
if ( !IsDefined( self.damageLocation ) )
return false;
return( self.damageLocation == "helmet" || self.damageLocation == "head" || self.damageLocation == "neck" );
}
chopper_spawn_from_targetname_and_drive( name, spawn_origin, path_start )
{
msg = "passed start struct without targetname: " + name;
assertex( !isdefined( path_start.in_use ), "helicopter told to use path that is in use." );
path_start.in_use = true;
chopper = chopper_spawn_from_targetname( name, spawn_origin );
chopper.loc_current = path_start;
chopper thread vehicle_paths( path_start );
return chopper;
}
chopper_spawn_from_targetname( name, spawn_origin )
{
chopper_spawner = getent( name, "targetname" );
assertex( isdefined( chopper_spawner ), "Invalid chopper spawner targetname: " + name );
set_health = maps\_so_survival_ai::get_ai_health( name );
if ( isdefined( set_health ) )
chopper_spawner.script_startinghealth = set_health;
while ( isdefined( chopper_spawner.vehicle_spawned_thisframe ) )
wait 0.05;
if ( isdefined( spawn_origin ) )
chopper_spawner.origin = spawn_origin;
chopper = spawn_vehicle_from_targetname( name );
assertex( isdefined( chopper ), "chopper failed to spawn." );
return chopper;
}
chopper_spawn_pilot_from_targetname( name, position )
{
all_spawners = getspawnerarray();
spawner = undefined;
foreach ( spawner in all_spawners )
if ( isdefined( spawner.targetname ) && spawner.targetname == name )
break;
assertex( isdefined( spawner ), "no spawner with targetname of: " + name );
pilot = self chopper_spawn_passenger( spawner, position, true );
pilot.health = 9999;
return pilot;
}
chopper_spawn_passenger( spawner, position, drone )
{
passenger = undefined;
while( 1 )
{
spawner.count = 1;
if ( isdefined( drone ) && drone )
{
passenger = dronespawn( spawner );
break;
}
else
{
passenger = spawner spawn_ai( true );
if ( !spawn_failed( passenger ) )
break;
}
wait 0.5;
}
if ( isdefined( position ) )
passenger.forced_startingposition = position;
self guy_enter_vehicle( passenger );
return passenger;
}
chopper_drop_smoke_at_unloading()
{
self endon( "death" );
self waittill( "unloading" );
tail_pos = self.origin - ( vectornormalize( anglestoforward( self.angles ) ) * 145 );
groundposition = groundpos( tail_pos );
MagicGrenadeManual( "smoke_grenade_fast", groundposition, ( 0, 0, -1 ), 0 );
}
chopper_wait_for_cloest_open_path_start( target_origin, start_name, struct_string_field )
{
path_start = undefined;
while ( 1 )
{
path_start = chopper_closest_open_path_start( target_origin, start_name, struct_string_field );
if ( isdefined( path_start ) )
break;
wait 0.25;
}
return path_start;
}
chopper_closest_open_path_start( target_origin, start_name, struct_string_field )
{
path_starts = GetStructArray( start_name, "targetname" );
assertex( path_starts.size, "No heli path structs with targetname: " + start_name );
closest_path_start = undefined;
closest_path_start_dist = undefined;
closest_path_drop = undefined;
foreach ( path_start in path_starts )
{
if ( isdefined( path_start.in_use ) )
continue;
path_drop = path_start;
switch ( struct_string_field )
{
case "script_unload":
{
while ( !isdefined( path_drop.script_unload ) )
path_drop = getstruct( path_drop.target, "targetname" );
assertex( isdefined( path_drop.script_unload ), "Level has a helicopter path without a struct with script_unload defined." );
if ( !isdefined( path_drop.script_unload ) )
continue;
break;
}
case "script_stopnode":
{
while ( !isdefined( path_drop.script_stopnode ) )
path_drop = getstruct( path_drop.target, "targetname" );
assertex( isdefined( path_drop.script_stopnode ), "Level has a helicopter path without a struct with script_stopnode defined." );
if ( !isdefined( path_drop.script_stopnode ) )
continue;
break;
}
default:
assertmsg( "Invalid struct_string_field: " + struct_string_field );
break;
}
if ( !isdefined( closest_path_drop ) )
{
closest_path_drop = path_drop;
closest_path_start_dist = distance2d( target_origin, path_drop.origin );
closest_path_start = path_start;
}
else
{
path_drop_dist = distance2d( target_origin, path_drop.origin );
if ( path_drop_dist < closest_path_start_dist )
{
closest_path_drop = path_drop;
closest_path_start_dist = distance2d( target_origin, closest_path_drop.origin );
closest_path_start = path_start;
}
}
}
return closest_path_start;
}
MP_ents_cleanup()
{
entitytypes = getentarray();
for ( i = 0; i < entitytypes.size; i++ )
{
if ( isdefined( entitytypes[ i ].script_gameobjectname ) )
entitytypes[ i ] delete();
}
}
Precache_loadout_item( item_ref )
{
if ( isdefined( item_ref ) && item_ref != "" )
PrecacheItem( item_ref );
}
int_capped( int_input, int_min, int_max )
{
return int( max( int_min, min( int_max, int_input ) ) );
}
float_capped( float_input, float_min, float_max )
{
return max( float_min, min( float_max, float_input ) );
}
delete_on_load()
{
ents = GetEntArray( "delete", "targetname" );
foreach( ent in ents )
ent Delete();
}
milliseconds( seconds )
{
return seconds * 1000;
}
seconds( milliseconds )
{
return milliseconds / 1000;
}
random_player_origin()
{
assertex( isdefined( level.players ) && level.players.size, "Level.players not defined yet." );
return level.players[ randomint( level.players.size ) ].origin;
}
highest_player_rank()
{
rank = -1;
foreach( player in level.players )
{
player_rank = player maps\_rank::getRank();
if ( player_rank > rank )
rank = player_rank;
}
return rank;
}
ent_linked_delete()
{
assertex( isdefined( self ), "Entity must be defined." );
self endon( "death" );
self unlink();
wait 0.05;
if ( isdefined( self ) )
self delete();
}
so_survival_kill_ai( attacker, dmg_type, weapon_type )
{
AssertEx( IsDefined( self ), "Survival kill AI must have defined self." );
AssertEx( IsAlive( self ), "Survival kill AI called on already dead actor." );
AssertEx( IsAI( self ), "Survival kill AI called on non AI." );
AssertEx( !IsDefined( self.magic_bullet_shield ), "Survival kill AI called on AI with magic_bullet_shield." );
if ( IsDefined( attacker ) )
{
if ( IsDefined( dmg_type ) && IsDefined( weapon_type ) )
{
self notify( "death", attacker, dmg_type, weapon_type );
self Kill();
}
else
{
self Kill( attacker.origin, attacker );
}
}
else
{
self Kill();
}
}
break_glass()
{
glass_break_structs = getstructarray( "struct_break_glass", "targetname" );
foreach ( struct in glass_break_structs )
{
GlassRadiusDamage( struct.origin, 64, 100, 99 );
}
}
so_survival_validate_entities()
{
array_script_brushmodels = GetEntArray( "armory_script_brushmodel", "targetname" );
foreach ( brush_model in array_script_brushmodels )
{
brush_model NotSolid();
}
origin_offset = (0,0,0);
trace_length_up = 60.0;
trace_length_down	= 60.0;
array_objects = [];
array_objects[ array_objects.size ] = GetEnt( "armory_weapon", "targetname" );
array_objects[ array_objects.size ] = GetEnt( "armory_equipment", "targetname" );
array_objects[ array_objects.size ] = GetEnt( "armory_airsupport", "targetname" );
array_objects = array_combine( array_objects, getstructarray( "so_claymore_loc", "targetname" ) );
array_objects = array_combine( array_objects, getstructarray( "leader", "script_noteworthy" ) );
array_objects = array_combine( array_objects, getstructarray( "follower", "script_noteworthy" ) );
foreach ( object in array_objects )
{
object so_survival_validate_entity( origin_offset, trace_length_up, trace_length_down );
}
foreach ( brush_model in array_script_brushmodels )
{
brush_model Solid();
}
wait 2.0;
if ( IsDefined( level.debug_survival_error_msgs ) && level.debug_survival_error_msgs.size )
{
foreach ( error in level.debug_survival_error_msgs )
{
PrintLn( "^1" + error );
}
}
}
so_survival_validate_entity( origin_offset, trace_length_up, trace_length_down )
{
Assert( IsDefined( self ), "Self not defined when validating entity." );
if ( !IsDefined( level.debug_survival_error_msgs ) )
{
level.debug_survival_error_msgs = [];
}
if ( !IsDefined( level.debug_survival_error_locs ) )
{
level.debug_survival_error_locs = [];
}
origin_start = self.origin + origin_offset + ( 0, 0, trace_length_up );
origin_end = self.origin + origin_offset;
trace_pos = PhysicsTrace( origin_start, origin_end );
if ( Distance( trace_pos, origin_end ) > 0.1 )
{
level.debug_survival_error_msgs[ level.debug_survival_error_msgs.size ] = "Error: Survival Entity may be in solid at: " + self.origin;
level.debug_survival_error_locs[ level.debug_survival_error_locs.size ] = self.origin;
return;
}
origin_start = self.origin + origin_offset;
origin_end = self.origin + origin_offset - ( 0, 0, trace_length_down );
trace_pos = PhysicsTrace( origin_start, origin_end );
if ( Distance( trace_pos, origin_end ) < 0.1 )
{
level.debug_survival_error_msgs[ level.debug_survival_error_msgs.size ] = "Error: Survival Entity floating or under floor: " + self.origin;
level.debug_survival_error_locs[ level.debug_survival_error_locs.size ] = self.origin;
return;
}
}
so_survival_display_entity_error_3D()
{
if ( !IsDefined( level.debug_survival_error_locs ) || !level.debug_survival_error_locs.size )
{
return;
}
level endon( "special_op_terminated" );
while ( true )
{
foreach ( location in level.debug_survival_error_locs )
{
Print3d( location, "Ent Bad", (1,0,0), 1.0, 1.0, 200 );
}
wait 10.0;
}
}


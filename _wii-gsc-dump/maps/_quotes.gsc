main()
{
thread setDeadQuote();
}
setDeadQuote()
{
level endon( "mine death" );
level notify( "new_quote_string" );
level endon( "new_quote_string" );
if ( isalive( level.player ) )
level.player waittill( "death" );
if ( !level.missionfailed )
{
deadQuoteSize = ( Int( TableLookup( "sp/deathQuoteTable.csv", 1, "size", 0 ) ) );
deadQuoteIndex = randomInt( deadQuoteSize );
if ( GetDvar( "cycle_deathquotes" ) != "" )
{
if ( GetDvar( "ui_deadquote_index" ) == "" )
SetDvar( "ui_deadquote_index", "0" );
deadQuoteIndex = GetDvarInt( "ui_deadquote_index" );
SetDvar( "ui_deadquote", lookupDeathQuote( deadQuoteIndex ) );
deadQuoteIndex++;
if ( deadQuoteIndex > (deadQuoteSize - 1) )
deadQuoteIndex = 0;
SetDvar( "ui_deadquote_index", deadQuoteIndex );
}
else
{
SetDvar( "ui_deadquote", lookupDeathQuote( deadQuoteIndex ) );
}
}
}
lookupDeathQuote( index )
{
quote = TableLookup( "sp/deathQuoteTable.csv", 0, index, 1 );
if ( tolower( quote[0] ) != tolower( "@" ) )
quote = "@" + quote;
return quote;
}
setDeadQuote_so()
{
level notify( "new_quote_string" );
deadquotes = [];
deadquotes = so_buildDeadQuote();
deadquotes = maps\_utility::array_randomize( deadquotes );
i = randomInt( deadquotes.size );
if ( !maps\_utility::is_coop_online() )
{
keep_searching = ( deadquotes.size > 1 );
original_i = i;
while( keep_searching )
{
if ( deadquote_recently_used( deadquotes[ i ] ) )
{
i++;
if ( i >= deadquotes.size )
i = 0;
if ( i == original_i )
keep_searching = false;
}
else
{
keep_searching = false;
}
}
setdvar( "ui_deadquote_v3", getdvar( "ui_deadquote_v2" ) );
setdvar( "ui_deadquote_v2", getdvar( "ui_deadquote_v1" ) );
setdvar( "ui_deadquote_v1", deadquotes[ i ] );
}
switch ( deadquotes[ i ] )
{
case "@DEADQUOTE_SO_ICON_PARTNER":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_partner" );
break;
case "@DEADQUOTE_SO_ICON_OBJ":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_obj" );
break;
case "@DEADQUOTE_SO_ICON_OBJ_OFFSCREEN":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_obj_offscreen" );
break;
case "@DEADQUOTE_SO_STAR_RANKINGS":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_stars" );
break;
case "@DEADQUOTE_SO_CLAYMORE_POINT_ENEMY":
case "@DEADQUOTE_SO_CLAYMORE_ENEMIES_SHOOT":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_claymore" );
break;
case "@DEADQUOTE_SO_STEALTH_STAY_LOW":
maps\_specialops_code::so_special_failure_hint_reset_dvars( "ui_icon_stealth_stance" );
break;
}
setdvar( "ui_deadquote", deadquotes[ i ] );
}
deadquote_recently_used( deadquote )
{
if ( deadquote == getdvar( "ui_deadquote_v1" ) )
return true;
if ( deadquote == getdvar( "ui_deadquote_v2" ) )
return true;
if ( deadquote == getdvar( "ui_deadquote_v3" ) )
return true;
return false;
}
so_buildDeadQuote()
{
if ( should_use_custom_deadquotes() )
return level.so_deadquotes;
deadquotes = [];
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TOGGLE_WEAP_ALT_MODE";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_RED_FIND_COVER";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_THROW_FLASHBANG";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_GRENADES_ROLL";
if ( !maps\_utility::is_survival() )
{
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TRY_NEW_DIFFICULTY";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_BEAT_BEST_TIME";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SEARCH_FOR_WEAPONS";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_ICON_OBJ";
}
else
{
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TURRET_PLACEMENT";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_AMMO_REFILL";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_BUY_NEW_WEAPON";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_ATTACHMENT";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_WAVE_BONUS";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_CHALLENGE_REWARD";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_LAST_STAND";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_RIOT_SHIELD_DAMAGE";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_ARMOR_RESTOCK";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_FRIENDLY_RIOTSHIELD";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_ARMORY_UNLOCK";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_SENTRY_UNATTENDED";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_SURVIVAL_KILL_CHEMICAL_ENEMIES";
}
if ( isdefined( self.so_infohud_toggle_state ) && self.so_infohud_toggle_state != "none" )
{
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TOGGLE_TIMER";
}
if ( maps\_utility::is_coop() )
{
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CRAWL_TO_TEAMMATE";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STAY_NEAR_TEAMMATE";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_FRIENDLY_FIRE_HINT";
deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_ICON_PARTNER";
}
return deadquotes;
}
should_use_custom_deadquotes()
{
if ( !isdefined( level.so_deadquotes ) )
return false;
if ( level.so_deadquotes.size <= 0 )
return false;
assertex( isdefined( level.so_deadquotes_chance ), "level.so_deadquotes had contents, but level.so_deadquote_chance was undefined." );
return ( level.so_deadquotes_chance >= randomfloat( 1.0 ) );
}
#include common_scripts\utility;
main()
{
maps\_utility::precache( "woodgib_medium" );
maps\_utility::precache( "woodgib_big" );
maps\_utility::precache( "woodgib_small1" );
maps\_utility::precache( "woodgib_small2" );
maps\_utility::precache( "wood_plank2" );
maps\_utility::precache( "gib_woodplank" );
wood = getentarray( "wood_splinter", "targetname" );
maps\_utility::array_thread( wood, ::wood_think );
}
wood_think()
{
if ( !isdefined( self.target ) )
{
println( "Wood at ", self getorigin(), " has no target" );
return;
}
mainpiece = getentarray( self.target, "targetname" );
for ( i = 0;i < mainpiece.size;i++ )
{
if ( ( isdefined( mainpiece[ i ].script_noteworthy ) ) && ( mainpiece[ i ].script_noteworthy == "notsolid" ) )
mainpiece[ i ] notsolid();
if ( !isdefined( mainpiece[ i ].target ) )
continue;
mainpiece[ i ].brokenpiece = getentarray( mainpiece[ i ].target, "targetname" );
for ( j = 0;j < mainpiece[ i ].brokenpiece.size;j++ )
{
if ( isdefined( mainpiece[ i ].brokenpiece[ j ] ) )
mainpiece[ i ].brokenpiece[ j ] hide();
}
}
if ( isdefined( self.script_noteworthy ) )
level waittill( self.script_noteworthy );
self waittill( "trigger", other );
if ( isplayer( other ) )
org = other getorigin();
else
org = other.origin;
for ( i = 0;i < mainpiece.size;i++ )
{
if ( !isdefined( mainpiece[ i ].target ) )
continue;
mainpiece[ i ].brokenpiece = getentarray( mainpiece[ i ].target, "targetname" );
for ( j = 0;j < mainpiece[ i ].brokenpiece.size;j++ )
{
if ( isdefined( mainpiece[ i ].brokenpiece[ j ] ) )
mainpiece[ i ].brokenpiece[ j ] show();
}
}
for ( i = 0;i < mainpiece.size;i++ )
{
if ( !isdefined( mainpiece[ i ] ) )
continue;
mainpiece[ i ] playsound( "wood_break" );
mainpiece[ i ] thread splinter( org );
mainpiece[ i ] delete();
}
}
splinter( org )
{
splinter = spawn( "script_model", ( 0, 0, 0 ) );
if ( randomint( 100 ) > 25 )
{
if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "dark" ) )
{
if ( randomint( 100 ) > 50 )
splinter setmodel( "wood_plank2" );
else
splinter setmodel( "gib_woodplank" );
}
else
{
if ( randomint( 100 ) > 50 )
splinter setmodel( "woodgib_big" );
else
splinter setmodel( "woodgib_medium" );
}
}
splinter.origin = self getorigin();
splinter thread go( org );
if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "dark" ) )
return;
small_gibs( splinter.origin, org );
}
go( org )
{
temp_vec = vectornormalize( self.origin - org );
temp_vec = ( temp_vec * ( 250 + RandomInt( 100 ) ) );
x = temp_vec[ 0 ];
y = temp_vec[ 1 ];
z = 200 + randomint( 100 );
if ( x > 0 )
self rotateroll( ( 1500 + randomfloat( 2500 ) ) * - 1, 5, 0, 0 );
else
self rotateroll( 1500 + randomfloat( 2500 ), 5, 0, 0 );
self moveGravity( ( x, y, z ), 12 );
wait( 6 );
self delete();
}
small_gibs( org, startorg )
{
splinter = [];
for ( i = 0;i < randomint( 6 ) + 1;i++ )
{
splinter[ i ] = spawn( "script_model", org );
splinter[ i ].origin += ( randomfloat( 10 ) - 5, 0, randomfloat( 30 ) - 15 );
if ( randomint( 100 ) > 50 )
splinter[ i ] setmodel( "woodgib_small1" );
else
splinter[ i ] setmodel( "woodgib_small2" );
startorg += ( 50 - randomint( 100 ), 50 - randomint( 100 ), 0 );
temp_vec = vectornormalize( org - startorg );
temp_vec = ( temp_vec * ( 300 + RandomInt( 150 ) ) );
x = temp_vec[ 0 ];
y = temp_vec[ 1 ];
z = 120 + randomint( 200 );
splinter[ i ] moveGravity( ( x, y, z ), 12 );
if ( x > 0 )
splinter[ i ] rotateroll( ( 1500 + randomfloat( 2500 ) ) * - 1, 5, 0, 0 );
else
splinter[ i ] rotateroll( 1500 + randomfloat( 2500 ), 5, 0, 0 );
}
wait( 6 );
for ( i = 0;i < splinter.size;i++ )
splinter[ i ] delete();
}

main()
{
self setModel("body_russian_military_assault_b_black");
codescripts\character::attachHead( "alias_russian_military_black_heads", xmodelalias\alias_russian_military_black_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_b_black");
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_black_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_b_black";
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_black_heads::main());
return models;
}

#import "PlayerData.h"
#import <UIKit/UIKit.h>

@implementation PlayerData
@synthesize hp, hpmax, mp, mpmax, lvl, exp, gold, sprite, displayToggle, currentMap, playerTilePos, att, def, weapon, armor, trinket, potions, playerName,playerClass;
- (id)init 
{
	//if (self = [super init])
	att = 1;
	def = 0;
	weapon = 0;
	armor = 0;
	trinket = 0;
	potions = 5;
	currentMap = 0;
	hpmax = 20;
	hp = 20;
	mpmax = 5;
	mp = 5;
	lvl = 1;
	exp = 0;
	gold = 50;
	playerTilePos = CGPointMake(6, 5);
	return self;
}
//encode the player data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:playerTilePos.x] forKey:@"playerTilePos.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:playerTilePos.y] forKey:@"playerTilePos.y" ];
	[coder encodeObject: [NSNumber numberWithInt:hp] forKey:@"hp" ];
	[coder encodeObject: [NSNumber numberWithInt:hpmax] forKey:@"hpmax" ];
	[coder encodeObject: [NSNumber numberWithInt:mp] forKey:@"mp" ];
	[coder encodeObject: [NSNumber numberWithInt:mpmax] forKey:@"mpmax" ];
	[coder encodeObject: [NSNumber numberWithInt:lvl] forKey:@"lvl" ];
	[coder encodeObject: [NSNumber numberWithInt:exp] forKey:@"exp" ];
	[coder encodeObject: [NSNumber numberWithInt:gold] forKey:@"gold" ];
	[coder encodeObject: [NSNumber numberWithInt:sprite] forKey:@"sprite" ];
	[coder encodeObject: [NSNumber numberWithInt:displayToggle] forKey:@"displayToggle" ];
	[coder encodeObject: [NSNumber numberWithInt:currentMap] forKey:@"currentMap" ];
	[coder encodeObject: [NSNumber numberWithInt:att] forKey:@"att" ];
	[coder encodeObject: [NSNumber numberWithInt:def] forKey:@"def" ];
	[coder encodeObject: [NSNumber numberWithInt:potions] forKey:@"potions" ];
	[coder encodeObject: weapon forKey:@"weapon" ];
	[coder encodeObject: armor forKey:@"armor" ];
	[coder encodeObject: trinket forKey:@"trinket" ];
	[coder encodeObject: playerName forKey:@"playerName" ];
	[coder encodeObject: playerClass forKey:@"playerClass" ];
} 
//init a player from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    playerTilePos.x = [[coder decodeObjectForKey:@"playerTilePos.x"] floatValue];
	playerTilePos.y = [[coder decodeObjectForKey:@"playerTilePos.y"] floatValue];
	hp = [[coder decodeObjectForKey:@"hp"] intValue];
	hpmax = [[coder decodeObjectForKey:@"hpmax" ] intValue];
	mp = [[coder decodeObjectForKey:@"mp" ] intValue];
	mpmax = [[coder decodeObjectForKey:@"mpmax" ] intValue];
	lvl = [[coder decodeObjectForKey:@"lvl" ] intValue];
	exp = [[coder decodeObjectForKey:@"exp" ] intValue];
	gold = [[coder decodeObjectForKey:@"gold" ] intValue];
	sprite = [[coder decodeObjectForKey:@"sprite" ] intValue];
	displayToggle = [[coder decodeObjectForKey:@"displayToggle" ] intValue];
	currentMap = [[coder decodeObjectForKey:@"currentMap" ] intValue];
	att = [[coder decodeObjectForKey:@"att" ] intValue];
	def = [[coder decodeObjectForKey:@"def" ] intValue];
	potions = [[coder decodeObjectForKey:@"potions" ] intValue];
	weapon = [coder decodeObjectForKey:@"weapon" ];
	[weapon retain];
	armor = [coder decodeObjectForKey:@"armor" ];
	[armor retain];
	trinket = [coder decodeObjectForKey:@"trinket"];
	[trinket retain];
	playerName = [coder decodeObjectForKey:@"playerName" ];
	[playerName retain];
	playerClass = [coder decodeObjectForKey:@"playerClass" ];
	[playerClass retain];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

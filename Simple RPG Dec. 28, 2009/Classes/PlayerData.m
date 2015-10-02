#import "PlayerData.h"
#import <UIKit/UIKit.h>

@implementation PlayerData
@synthesize hp, hpmax, mp, mpmax, lvl, exp, gold, sprite, displayToggle, currentMap, playerTilePos, att, def, weapon, armor, trinket, potions;
- (id)init 
{
	//if (self = [super init])
	att = 1;
	def = 0;
	weapon = 0;
	armor = 0;
	trinket = 0;
	potions = 5;
	currentMap = 1;
	hpmax = 20;
	hp = 20;
	mpmax = 5;
	mp = 5;
	lvl = 1;
	exp = 0;
	gold = 50;
	return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

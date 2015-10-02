#import "NpcData.h"

@implementation NpcData
@synthesize hpmax, mpmax, lvl, exp, gold,sprite, name
, attack,speed,weapon,trinket,defense,
potions,armor,special,canDropWeapon,canDropTrinket,
canLevelUp,canDropArmor,canDropGold,canDropPotions,
movementStyles,attackStyles,canMove,tranMapTravel;
- (id)init 
{
	//if (self = [super init])
	sprite = 0;
	hpmax = 0;
	mpmax = 0;
	lvl = 0;
	exp = 0;
	gold = 0;
	name = @"New NPC";
	movementStyles = 1;
	attackStyles = 1;
	return self;
}
//encode the npc data
- (void) encodeWithCoder: (NSCoder *)coder
{   
	[coder encodeObject: [NSNumber numberWithInt:hpmax] forKey:@"hp" ];
	[coder encodeObject: [NSNumber numberWithInt:mpmax] forKey:@"mp" ];
	[coder encodeObject: [NSNumber numberWithInt:lvl] forKey:@"lvl" ];
	[coder encodeObject: [NSNumber numberWithInt:exp] forKey:@"exp" ];
	[coder encodeObject: [NSNumber numberWithInt:gold] forKey:@"gold" ];
	[coder encodeObject: [NSNumber numberWithInt:sprite] forKey:@"sprite" ];
	
	[coder encodeObject:name forKey:@"name" ];
	[coder encodeObject: [NSNumber numberWithInt:attack] forKey:@"attack" ];
	[coder encodeObject: [NSNumber numberWithInt:speed] forKey:@"speed" ];
	[coder encodeObject: [NSNumber numberWithInt:weapon] forKey:@"weapon" ];
	[coder encodeObject: [NSNumber numberWithInt:trinket] forKey:@"trinket" ];
	[coder encodeObject: [NSNumber numberWithInt:defense] forKey:@"defense" ];
	[coder encodeObject: [NSNumber numberWithInt:potions] forKey:@"potions" ];
	[coder encodeObject: [NSNumber numberWithInt:armor] forKey:@"armor" ];
	[coder encodeObject: [NSNumber numberWithInt:special] forKey:@"special" ];
	[coder encodeObject: [NSNumber numberWithInt:movementStyles] forKey:@"movementStyles" ];
	[coder encodeObject: [NSNumber numberWithInt:attackStyles] forKey:@"attackStyles" ];
	
	[coder encodeObject: [NSNumber numberWithBool:canDropWeapon] forKey:@"canDropWeapon" ];
	[coder encodeObject: [NSNumber numberWithBool:canDropTrinket] forKey:@"canDropTrinket" ];
	[coder encodeObject: [NSNumber numberWithBool:canLevelUp] forKey:@"canLevelUp" ];
	[coder encodeObject: [NSNumber numberWithBool:canDropArmor] forKey:@"canDropArmor" ];
	[coder encodeObject: [NSNumber numberWithBool:canDropGold] forKey:@"canDropGold" ];
	[coder encodeObject: [NSNumber numberWithBool:canDropPotions] forKey:@"canDropPotions" ];
	[coder encodeObject: [NSNumber numberWithBool:canMove] forKey:@"canMove" ];
	[coder encodeObject: [NSNumber numberWithBool:tranMapTravel] forKey:@"tranMapTravel" ];
} 
//init a npc from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
	hpmax = [[coder decodeObjectForKey:@"hp"] intValue];
	mpmax = [[coder decodeObjectForKey:@"mp" ] intValue];
	lvl = [[coder decodeObjectForKey:@"lvl" ] intValue];
	exp = [[coder decodeObjectForKey:@"exp" ] intValue];
	gold = [[coder decodeObjectForKey:@"gold" ] intValue];
	sprite = [[coder decodeObjectForKey:@"sprite" ] intValue];
	
	name = [coder decodeObjectForKey:@"name" ];
	[name retain];
	
	attack = [[coder decodeObjectForKey:@"attack" ] intValue];
	speed = [[coder decodeObjectForKey:@"speed" ] intValue];
	weapon = [[coder decodeObjectForKey:@"weapon" ] intValue];
	trinket = [[coder decodeObjectForKey:@"trinket" ] intValue];
	defense = [[coder decodeObjectForKey:@"defense" ] intValue];
	potions = [[coder decodeObjectForKey:@"potions" ] intValue];
	armor = [[coder decodeObjectForKey:@"armor" ] intValue];
	special = [[coder decodeObjectForKey:@"special" ] intValue];
	movementStyles = [[coder decodeObjectForKey:@"movementStyles" ] intValue];
	attackStyles = [[coder decodeObjectForKey:@"attackStyles" ] intValue];
	
	canDropWeapon = [[coder decodeObjectForKey:@"canDropWeapon" ] boolValue];
	canDropTrinket = [[coder decodeObjectForKey:@"canDropTrinket" ] boolValue];
	canLevelUp = [[coder decodeObjectForKey:@"canLevelUp" ] boolValue];
	canDropArmor = [[coder decodeObjectForKey:@"canDropArmor" ] boolValue];
	canDropGold = [[coder decodeObjectForKey:@"canDropGold" ] boolValue];
	canDropPotions = [[coder decodeObjectForKey:@"canDropPotions" ] boolValue];
	canMove = [[coder decodeObjectForKey:@"canMove" ] boolValue];
	tranMapTravel = [[coder decodeObjectForKey:@"tranMapTravel" ] boolValue];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

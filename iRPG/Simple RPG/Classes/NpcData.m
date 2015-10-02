#import "NpcData.h"
#import <UIKit/UIKit.h>

@implementation NpcData
@synthesize position, moveCount, moveTimer, movStyle, target, hp, hpmax, mp, mpmax, lvl, exp, gold, aggressive, collisionEvent,sprite;
- (id)init 
{
	//if (self = [super init])
	sprite = 0;
	moveCount = 0;
	moveTimer = 0;
	movStyle = 0;
	target = -1;
	hp = 0;
	hpmax = 0;
	mp = 0;
	mpmax = 0;
	lvl = 0;
	exp = 0;
	gold = 0;
	triggerevent = -1;
	aggressive = 0;
	collisionEvent = 0;
	return self;
}
//encode the npc data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:position.x] forKey:@"position.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:position.y] forKey:@"position.y" ];
	[coder encodeObject: [NSNumber numberWithInt:hp] forKey:@"hp" ];
	[coder encodeObject: [NSNumber numberWithInt:hpmax] forKey:@"hpmax" ];
	[coder encodeObject: [NSNumber numberWithInt:mp] forKey:@"mp" ];
	[coder encodeObject: [NSNumber numberWithInt:mpmax] forKey:@"mpmax" ];
	[coder encodeObject: [NSNumber numberWithInt:lvl] forKey:@"lvl" ];
	[coder encodeObject: [NSNumber numberWithInt:exp] forKey:@"exp" ];
	[coder encodeObject: [NSNumber numberWithInt:gold] forKey:@"gold" ];
	[coder encodeObject: [NSNumber numberWithInt:moveCount] forKey:@"moveCount" ];
	[coder encodeObject: [NSNumber numberWithInt:moveTimer] forKey:@"moveTimer" ];
	[coder encodeObject: [NSNumber numberWithInt:movStyle] forKey:@"movStyle" ];
	[coder encodeObject: [NSNumber numberWithInt:target] forKey:@"target" ];
	[coder encodeObject: [NSNumber numberWithInt:aggressive] forKey:@"aggressive" ];
	[coder encodeObject: [NSNumber numberWithInt:collisionEvent] forKey:@"collisionEvent" ];
	[coder encodeObject: [NSNumber numberWithInt:sprite] forKey:@"sprite" ];
} 
//init a npc from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    position.x = [[coder decodeObjectForKey:@"position.x"] floatValue];
	position.y = [[coder decodeObjectForKey:@"position.y"] floatValue];
	hp = [[coder decodeObjectForKey:@"hp"] intValue];
	hpmax = [[coder decodeObjectForKey:@"hpmax" ] intValue];
	mp = [[coder decodeObjectForKey:@"mp" ] intValue];
	mpmax = [[coder decodeObjectForKey:@"mpmax" ] intValue];
	lvl = [[coder decodeObjectForKey:@"lvl" ] intValue];
	exp = [[coder decodeObjectForKey:@"exp" ] intValue];
	gold = [[coder decodeObjectForKey:@"gold" ] intValue];
	sprite = [[coder decodeObjectForKey:@"sprite" ] intValue];
	moveCount = [[coder decodeObjectForKey:@"moveCount" ] intValue];
	moveTimer = [[coder decodeObjectForKey:@"moveTimer" ] intValue];
	movStyle = [[coder decodeObjectForKey:@"movStyle" ] intValue];
	target = [[coder decodeObjectForKey:@"target" ] intValue];
	aggressive = [[coder decodeObjectForKey:@"aggressive" ] intValue];
	collisionEvent = [[coder decodeObjectForKey:@"collisionEvent" ] intValue];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

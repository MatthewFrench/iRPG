#import "NpcData.h"
#import <UIKit/UIKit.h>

@implementation NpcData
@synthesize npcImageObj, position, moveCount, moveTimer, movStyle, target, hp, hpmax, mp, mpmax, lvl, exp, gold, aggressive, collisionEvent;
- (id)init 
{
	//if (self = [super init])
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
-(void)dealloc {
	[npcImageObj release];
	[super dealloc];
}
@end

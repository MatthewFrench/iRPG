#import "TileData.h"
#import "MapData.h"
#import <UIKit/UIKit.h>


@implementation TileData
@synthesize blocked, npcOn, warpWhenHitTo, warpLeaveToRight, warpLeaveToLeft, warpLeaveToDown, warpLeaveToUp;
@synthesize warpWhenHitToMap, warpLeaveToRightMap, warpLeaveToLeftMap, warpLeaveToDownMap, warpLeaveToUpMap;
- (id)init 
{
	//if (self = [super init])
	blocked = 0;
	warpWhenHitTo = CGPointMake(-1, -1);
	warpLeaveToRight = CGPointMake(-1, -1);
	warpLeaveToLeft = CGPointMake(-1, -1);
	warpLeaveToDown = CGPointMake(-1, -1);
	warpLeaveToUp = CGPointMake(-1, -1);
	warpWhenHitToMap = -1;
	warpLeaveToRightMap = -1;
	warpLeaveToLeftMap = -1;
	warpLeaveToDownMap = -1;
	warpLeaveToUpMap = -1;
	return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

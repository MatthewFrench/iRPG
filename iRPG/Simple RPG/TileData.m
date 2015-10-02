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
int blocked,npcOn,warpWhenHitToMap,warpLeaveToRightMap,warpLeaveToLeftMap,warpLeaveToDownMap,warpLeaveToUpMap;
CGPoint warpLeaveToUp,warpLeaveToDown,warpLeaveToLeft,warpLeaveToRight,warpWhenHitTo;
//encode the tile data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithInt:blocked] forKey:@"blocked" ];
	[coder encodeObject: [NSNumber numberWithInt:npcOn] forKey:@"npcOn" ];
	[coder encodeObject: [NSNumber numberWithInt:warpWhenHitToMap] forKey:@"warpWhenHitToMap" ];
	[coder encodeObject: [NSNumber numberWithInt:warpLeaveToRightMap] forKey:@"warpLeaveToRightMap" ];
	[coder encodeObject: [NSNumber numberWithInt:warpLeaveToLeftMap] forKey:@"warpLeaveToLeftMap" ];
	[coder encodeObject: [NSNumber numberWithInt:warpLeaveToDownMap] forKey:@"warpLeaveToDownMap" ];
	[coder encodeObject: [NSNumber numberWithInt:warpLeaveToUpMap] forKey:@"warpLeaveToUpMap" ];
	
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToUp.x] forKey:@"warpLeaveToUp.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToUp.y] forKey:@"warpLeaveToUp.y" ];
	
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToDown.x] forKey:@"warpLeaveToDown.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToDown.y] forKey:@"warpLeaveToDown.y" ];
	
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToLeft.x] forKey:@"warpLeaveToLeft.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToLeft.y] forKey:@"warpLeaveToLeft.y" ];
	
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToRight.x] forKey:@"warpLeaveToRight.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:warpLeaveToRight.y] forKey:@"warpLeaveToRight.y" ];
	
	[coder encodeObject: [NSNumber numberWithFloat:warpWhenHitTo.x] forKey:@"warpWhenHitTo.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:warpWhenHitTo.y] forKey:@"warpWhenHitTo.y" ];
} 
//init a tile from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
	
	blocked = [[coder decodeObjectForKey:@"blocked" ]intValue];
	npcOn = [[coder decodeObjectForKey:@"npcOn" ]intValue];
	warpWhenHitToMap = [[coder decodeObjectForKey:@"warpWhenHitToMap" ]intValue];
	warpLeaveToRightMap = [[coder decodeObjectForKey:@"warpLeaveToRightMap" ]intValue];
	warpLeaveToLeftMap = [[coder decodeObjectForKey:@"warpLeaveToLeftMap" ]intValue];
	warpLeaveToDownMap = [[coder decodeObjectForKey:@"warpLeaveToDownMap" ]intValue];
	warpLeaveToUpMap = [[coder decodeObjectForKey:@"warpLeaveToUpMap" ]intValue];
	
	warpLeaveToUp.x = [[coder decodeObjectForKey:@"warpLeaveToUp.x" ]floatValue];
	warpLeaveToUp.y = [[coder decodeObjectForKey:@"warpLeaveToUp.y" ]floatValue];
	
	warpLeaveToDown.x = [[coder decodeObjectForKey:@"warpLeaveToDown.x" ]floatValue];
	warpLeaveToDown.y = [[coder decodeObjectForKey:@"warpLeaveToDown.y" ]floatValue];
	
	warpLeaveToLeft.x = [[coder decodeObjectForKey:@"warpLeaveToLeft.x" ]floatValue];
	warpLeaveToLeft.y = [[coder decodeObjectForKey:@"warpLeaveToLeft.y" ]floatValue];
	
	warpLeaveToRight.x = [[coder decodeObjectForKey:@"warpLeaveToRight.x" ]floatValue];
	warpLeaveToRight.y = [[coder decodeObjectForKey:@"warpLeaveToRight.y" ]floatValue];
	
	warpWhenHitTo.x = [[coder decodeObjectForKey:@"warpWhenHitTo.x" ]floatValue];
	warpWhenHitTo.y = [[coder decodeObjectForKey:@"warpWhenHitTo.y" ]floatValue];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

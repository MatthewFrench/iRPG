#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TileData;


@interface TileData : NSObject {
	int item,blocked,npcOn,warpWhenHitToMap,warpLeaveToRightMap,warpLeaveToLeftMap,warpLeaveToDownMap,warpLeaveToUpMap;
	CGPoint warpLeaveToUp,warpLeaveToDown,warpLeaveToLeft,warpLeaveToRight,warpWhenHitTo;
};
-(void) dealloc;

@property(nonatomic) int blocked,item,npcOn,warpWhenHitToMap,warpLeaveToRightMap,warpLeaveToLeftMap,warpLeaveToDownMap,warpLeaveToUpMap;
@property(nonatomic) CGPoint warpWhenHitTo,warpLeaveToRight,warpLeaveToLeft,warpLeaveToDown,warpLeaveToUp;

@end

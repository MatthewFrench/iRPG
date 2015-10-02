//
//  tileData.h
//  Simple RPG
//
//  Created by Matthew on 10/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TileData;


@interface TileData : NSObject {
	int blocked;
	int npcOn;
	int warpWhenHitToMap;
	CGPoint warpWhenHitTo;
	int warpLeaveToRightMap;
	CGPoint warpLeaveToRight;
	int warpLeaveToLeftMap;
	CGPoint warpLeaveToLeft;
	int warpLeaveToDownMap;
	CGPoint warpLeaveToDown;
	int warpLeaveToUpMap;
	CGPoint warpLeaveToUp;
};
-(void) dealloc;

@property(nonatomic) int blocked;
@property(nonatomic) int npcOn;
@property(nonatomic) int warpWhenHitToMap;
@property(nonatomic) CGPoint warpWhenHitTo;
@property(nonatomic) int warpLeaveToRightMap;
@property(nonatomic) CGPoint warpLeaveToRight;
@property(nonatomic) int warpLeaveToLeftMap;
@property(nonatomic) CGPoint warpLeaveToLeft;
@property(nonatomic) int warpLeaveToDownMap;
@property(nonatomic) CGPoint warpLeaveToDown;
@property(nonatomic) int warpLeaveToUpMap;
@property(nonatomic) CGPoint warpLeaveToUp;

@end

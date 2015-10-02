//
//  PlayerData.h
//  Simple RPG
//
//  Created by Matthew on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PlayerData;


@interface PlayerData : NSObject {
	//*****Player Vars***
	CGPoint playerTilePos;
	int hp, hpmax, mp, mpmax, lvl, exp, gold, sprite, displayToggle, currentMap;
};
-(void) dealloc;

@property(nonatomic) int currentMap, displayToggle, sprite, hp, hpmax, mp, mpmax, lvl, exp, gold;
@property(nonatomic) CGPoint playerTilePos;

@end

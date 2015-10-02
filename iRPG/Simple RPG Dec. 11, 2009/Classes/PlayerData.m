//
//  PlayerData.m
//  Simple RPG
//
//  Created by Matthew on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "PlayerData.h"
#import <UIKit/UIKit.h>

@implementation PlayerData
@synthesize hp, hpmax, mp, mpmax, lvl, exp, gold, sprite, displayToggle, currentMap, playerTilePos;
- (id)init 
{
	//if (self = [super init])
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

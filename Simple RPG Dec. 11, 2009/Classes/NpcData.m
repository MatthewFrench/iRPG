//
//  PlayerData.m
//  Simple RPG
//
//  Created by Matthew on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "NpcData.h"
#import <UIKit/UIKit.h>

@implementation NpcData
@synthesize npcImageObj, position, moveCount, moveTimer, movStyle, targetAttack, hp, hpmax, mp, mpmax, lvl, exp, gold, talk, aggressive;
- (id)init 
{
	//if (self = [super init])
	moveCount = 0;
	moveTimer = 0;
	movStyle = 0;
	targetAttack = -1;
	hp = 0;
	hpmax = 0;
	mp = 0;
	mpmax = 0;
	lvl = 0;
	exp = 0;
	gold = 0;
	talk = -1;
	aggressive = 0;
	return self;
}
-(void)dealloc {
	[npcImageObj release];
	[super dealloc];
}
@end

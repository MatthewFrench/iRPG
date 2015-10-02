//
//  PlayerData.h
//  Simple RPG
//
//  Created by Matthew on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NpcData;


@interface NpcData : NSObject {
	//*****Npc Vars***
	UIImage* npcImageObj;
	CGPoint position;
	int movStyle;
	int moveTimer;
	int moveCount;
	int targetAttack;
	int hp, hpmax, mp, mpmax, lvl, exp, gold, aggressive, talk;
};
-(void) dealloc;

@property(nonatomic, retain) UIImage* npcImageObj;
@property(nonatomic) CGPoint position;
@property(nonatomic) int moveTimer;
@property(nonatomic) int moveCount;
@property(nonatomic) int movStyle;
@property(nonatomic) int targetAttack;
@property(nonatomic) int hp;
@property(nonatomic) int hpmax;
@property(nonatomic) int mp;
@property(nonatomic) int mpmax;
@property(nonatomic) int lvl;
@property(nonatomic) int exp;
@property(nonatomic) int gold;
@property(nonatomic) int talk;
@property(nonatomic) int aggressive;

@end

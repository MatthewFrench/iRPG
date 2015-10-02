#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NpcData;


@interface NpcData : NSObject {
	//*****Npc Vars***
	UIImage* npcImageObj;
	CGPoint position;
	int movStyle,moveTimer,moveCount,target,hp, hpmax, mp, mpmax, lvl, exp, gold, aggressive, triggerevent, collisionEvent;
};
-(void) dealloc;

@property(nonatomic, retain) UIImage* npcImageObj;
@property(nonatomic) CGPoint position;
@property(nonatomic) int moveTimer,moveCount,movStyle,target,hp,hpmax,mp,mpmax,lvl,exp,gold,aggressive,collisionEvent;

@end

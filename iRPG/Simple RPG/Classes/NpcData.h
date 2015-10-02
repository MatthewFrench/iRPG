#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NpcData;


@interface NpcData : NSObject {
	//*****Npc Vars***
	CGPoint position;
	int movStyle,moveTimer,moveCount,target,hp, hpmax, mp, mpmax, lvl, exp, gold, aggressive, triggerevent, collisionEvent, sprite;
};
-(void) dealloc;

@property(nonatomic) CGPoint position;
@property(nonatomic) int moveTimer,moveCount,movStyle,target,hp,hpmax,mp,mpmax,lvl,exp,gold,aggressive,collisionEvent,sprite;

@end

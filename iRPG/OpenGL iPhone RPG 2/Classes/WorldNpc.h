#import <UIKit/UIKit.h>

@class WorldNpc;


@interface WorldNpc : NSObject {
	//*****Npc Vars***
	int npcNum, hp, mp, originalMap, currentMap, npcTimer;
	CGPoint originalTile, currentTile;
	BOOL permanent;
};
-(void) dealloc;

@property(nonatomic) int npcNum, hp, mp, originalMap, currentMap,npcTimer;
@property(nonatomic) CGPoint originalTile, currentTile;
@property(nonatomic) BOOL permanent;

@end

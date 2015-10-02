#import <UIKit/UIKit.h>

@class WorldNpc;


@interface WorldNpc : NSObject {
	//*****Npc Vars***
	int npcNum, hp, mp, originalMap, currentMap, npcTimer,moveNpcTimer;
	CGPoint originalTile, currentTile, movedToDir;
	BOOL permanent;
};
-(void) dealloc;

@property(nonatomic) int npcNum, hp, mp, originalMap, currentMap,npcTimer,moveNpcTimer;
@property(nonatomic) CGPoint originalTile, currentTile, movedToDir;
@property(nonatomic) BOOL permanent;

@end

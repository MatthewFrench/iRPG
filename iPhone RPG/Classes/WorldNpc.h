#import <UIKit/UIKit.h>

@class WorldNpc;


@interface WorldNpc : NSObject {
	//*****Npc Vars***
	int npcNum, hp, mp, originalMap, currentMap;
	CGPoint originalTile, currentTile;
};
-(void) dealloc;

@property(nonatomic) int npcNum, hp, mp, originalMap, currentMap;
@property(nonatomic) CGPoint originalTile, currentTile;

@end

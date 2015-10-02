#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

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

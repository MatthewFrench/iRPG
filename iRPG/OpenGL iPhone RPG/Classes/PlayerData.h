#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PlayerData;


@interface PlayerData : NSObject {
	//*****Player Vars***
	CGPoint playerTilePos, movedToDir;
	int hp, hpmax, mp, mpmax, lvl, exp, gold, sprite, displayToggle, currentMap, att, def, potions;
	NSString *playerName, *playerClass, *weapon, *armor, *trinket;
};
-(void) dealloc;

@property(nonatomic) int currentMap, displayToggle, sprite, hp, hpmax, mp, mpmax, lvl, exp, gold, att, def, potions;
@property(nonatomic) CGPoint playerTilePos, movedToDir;
@property(nonatomic, retain) NSString *playerName,*playerClass, *weapon, *armor, *trinket;

@end

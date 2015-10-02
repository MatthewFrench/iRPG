#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class NpcData;


@interface NpcData : NSObject {
	//*****Npc Vars***
	int hpmax,mpmax, lvl, exp, gold, 
	sprite, attack,speed,weapon,trinket,defense,
	potions,armor,special,canDropWeapon,canDropTrinket,
	canLevelUp,canDropArmor,canDropGold,canDropPotions,
	movementStyles,attackStyles,canMove,tranMapTravel;
	NSString* name;
};
-(void) dealloc;

@property(nonatomic) int hpmax,mpmax,lvl,exp,gold,sprite, attack,speed,weapon,trinket,defense,
potions,armor,special,canDropWeapon,canDropTrinket,
canLevelUp,canDropArmor,canDropGold,canDropPotions,
movementStyles,attackStyles,canMove,tranMapTravel;
@property(nonatomic, retain) NSString* name;

@end

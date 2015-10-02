//
//  GameView.h
//  Simple RPG
//
//  Created by Matthew on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapData.h"
#import "TileData.h"
#import "PlayerData.h"
#import "NpcData.h"

@interface GameView : UIView {
	//*****Interface Vars
	UIImage* interfaceImageObj[5];
	int currentview;
	NSTimer *gameTimer;
	
	//*****Map Data
	NSMutableArray* maps;
	CGPoint mapPos;
	
	//*****Player Data
	PlayerData *playerData;
	
	//*****NPC Data
	NSString* npcData;
	NSMutableArray* npcSprites;
	
	//*****Input Data
	BOOL twoFingers;
	CGPoint touchedScreen;
}
- (UIImage*) loadImage:(NSString*)name type:(NSString*)imageType;
- (NSString*) loadText:(NSString*)name type:(NSString*)fileType;
- (void) drawImage:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY image:(UIImage*)sprite point:(CGPoint)point rotation:(float)rotation;
- (void) drawString:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(UIFont*)font;
- (void) moveNpc:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles movementStyle:(int)movStyle allNpcs:(NSArray*)allNpcs;
- (void) npcAttack:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs;

@end

#import <UIKit/UIKit.h>
#import "MapData.h"
#import "TileData.h"
#import "PlayerData.h"
#import "NpcData.h"
#import "DamageEffect.h"
#import "Item.h"

@interface GameView : UIView {
	//*****Interface Vars
	UIImage* interfaceImageObj[6];
	int currentview;
	BOOL talkOn;
	UIImage* talkImage;
	NSTimer *gameTimer;
	
	//*****Map Data
	NSMutableArray* maps;
	CGPoint mapPos;
	
	//*****Player Data
	PlayerData *playerData;
	
	//*****NPC Data
	NSMutableArray* npcSprites;
	
	//*****Item Data
	NSMutableArray* itemSprites;
	
	//*****Input Data
	BOOL twoFingers;
	CGPoint touchedScreen;
	
	//****Damage effect display
	NSMutableArray* damageEffects;
}
- (UIImage*) loadImage:(NSString*)name type:(NSString*)imageType;
- (NSString*) loadText:(NSString*)name type:(NSString*)fileType;
- (void) drawImage:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY image:(UIImage*)sprite point:(CGPoint)point rotation:(float)rotation;
- (void) drawString:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(UIFont*)font color:(CGColorRef)color;
- (void) drawRectangle:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[4])color rotation:(float)rotation;
- (void) moveNpc:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs;
- (void) npcAttack:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs;
- (void) loadmaps;
- (NpcData*) loadnpcs:(int)npcnum xpos:(int)xpos ypos:(int)ypos;
- (void) playerCollision:(NpcData*)npcCollided;
- (void) npcDeath:(NpcData*)deadNpc npcNumber:(int)npcNum;
- (void) playerDeath;
- (void) gameEvents:(NpcData*)eventNpc;

@end

#import <UIKit/UIKit.h>
#import "MapData.h"
#import "TileData.h"
#import "PlayerData.h"
#import "NpcData.h"
#import "DamageEffect.h"
#import "Item.h"
#import "WorldNpc.h"


@interface GameView : UIView {
	//*****holds all menu interfaces
	UIImage* interfaceView[9];
	//Tells the game what view to draw and what to do in the view
	int currentView;
	int tileWidth;
	int tileHeight;
	int mapWidth;
	int mapHeight;
	
	//Tells the game that something's happening so it'll probably need to pull a dialog or something.
	int activateEvent;
	Item* eventItem;
	int eventItemNum;
	
	//Dialogs to be drawn for eventOn
	NSMutableArray* eventBg;
	
	//TileView
	NSMutableArray* tileImages;
	NSMutableArray* characterImages;
	NSMutableArray* itemImages;
	NSMutableArray* tiles;
	
	NSMutableArray* maps;
	NSMutableArray* npcData;
	
	//*****Player Data
	PlayerData *playerData;
	
	//****Damage effect to display
	NSMutableArray* damageEffects;
	
	UIImage* originalLightning[4];
	UIImage* lightning[4];
	CGPoint lightningPosition;
	float lightningLength;
	float lightningRotation;
	int lightningTimerMax;
	int lightningTimer;
	int lightningNum;
	float loadingProgress;
	float loadingProgressMax;
	BOOL drawLightning;
	
	//*****Input Data
	CGPoint touchedScreenBegan1;
	CGPoint touchedScreenBegan2;
	
	CGPoint touchedScreenMoved1;
	CGPoint touchedScreenMoved2;
	
	CGPoint touchedScreenEnded1;
	CGPoint touchedScreenEnded2;
	
	//****Game Text Box Use Freely****
	UITextField* textField;
	
	BOOL updateScreen;
	
	//Runs the game's logic
	NSTimer *gameTimer;
	CGPoint screenDimensions;
}
- (void) touchedBegan1:(CGPoint)touchPosition;
- (void) touchedMoved1:(CGPoint)touchPosition;
- (void) touchedEnded1:(CGPoint)touchPosition;
- (void) touchedBegan2:(CGPoint)touchPosition;
- (void) touchedMoved2:(CGPoint)touchPosition;
- (void) touchedEnded2:(CGPoint)touchPosition;

- (UIImage*) loadImage:(NSString*)name type:(NSString*)imageType;
- (NSString*) loadText:(NSString*)name type:(NSString*)fileType;
- (void) drawLine:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point topoint:(CGPoint)topoint rotation:(float)rotation linesize:(float)linesize;
- (void) drawImage:(CGContextRef)context translate:(CGPoint)translate image:(UIImage*)sprite point:(CGPoint)point rotation:(float)rotation;
- (void) drawOval:(CGContextRef)context translate:(CGPoint)translate color:(float[])color point:(CGPoint)point dimensions:(CGPoint)dimensions rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize;
- (void) drawString:(CGContextRef)context translate:(CGPoint)translate text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(NSString*)font color:(float[])color size:(int)textSize;
- (void) drawRectangle:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize;
- (NSMutableArray*) openFileInDocs:(NSString*)name;
- (BOOL) saveFileInDocs:(NSString*)name object:(NSMutableArray*)object;
- (void) deleteFileInDocs:(NSString*)name;
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (NSMutableArray*) openFileAtApp:(NSString*)name type:(NSString*)type;

- (void) moveNpc:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs;
- (void) npcAttack:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs;
- (void) loadmaps;
- (NpcData*) loadnpcs:(int)npcnum xpos:(int)xpos ypos:(int)ypos;
- (void) playerCollision:(NpcData*)npcCollided;
- (void) npcDeath:(NpcData*)deadNpc npcNumber:(int)npcNum;
- (void) playerDeath;
- (void) itemEvents:(Item*)eventItem itemNum:(int)itemNum event:(int)event;
- (void) npcEvents:(NpcData*)eventNpc;
- (CGColorRef)createCGColor:(float[])rgba;
- (NSString*)getItemName:(int)itemNum;
- (NSMutableArray*)getItemDescription:(NSString*)itemName;
- (void) saveGame;
- (void) loadGame;
- (void) appQuit;

@end

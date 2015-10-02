#import <UIKit/UIKit.h>
#import "MapData.h"
#import "TileData.h"
#import "PlayerData.h"
#import "NpcData.h"
#import "DamageEffect.h"
#import "SpellEffect.h"
#import "Item.h"

@interface GameView : UIView {
	//*****holds all menu interfaces
	UIImage* interfaceImageObj[8];
	//Tells the game what view to draw and what to do in the view
	int currentview;
	
	//Save/load game
	NSMutableArray* game1;
	NSMutableArray* game2;
	NSMutableArray* game3;
	int selectedGame;
	
	//Tells the game that something's happening so it'll probably need to pull a dialog or somethin.
	int eventOn;
	//Dialogs to be drawn for eventOn
	NSMutableArray* eventImages;
	//Holds the item of the event so we can draw it in the dialog
	Item* eventItem;
	int eventItemNum;
	
	//Runs the game's logic
	NSTimer *gameTimer;
	
	//*****Map Data
	NSMutableArray* maps;
	NSMutableArray* mapImages;
	CGPoint mapPos;
	
	//*****Player Data
	PlayerData *playerData;
	
	//*****NPC Data
	NSMutableArray* npcSprites;
	
	//*****Item Data
	NSMutableArray* itemSprites;
	
	//*****Battle GFX sprites
	//Is an NSMutableArray within an NSMutableArray to hold animation sequence.
	NSMutableArray* battleGfx;
	
	//*****Input Data
	CGPoint touchedScreenBegan1;
	CGPoint touchedScreenBegan2;
	
	CGPoint touchedScreenMoved1;
	CGPoint touchedScreenMoved2;
	
	CGPoint touchedScreenEnded1;
	CGPoint touchedScreenEnded2;
	
	//****Damage effect display
	NSMutableArray* damageEffects;
	
	//****Spell effect display
	NSMutableArray* spellEffects;
	
	//****Game Text Box Use Freely****
	UITextField* textField;
}
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

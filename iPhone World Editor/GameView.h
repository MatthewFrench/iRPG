#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "TileView.h"
#import "TileData.h"
#import "MapData.h"
#import "NpcData.h"
#import "WorldNpc.h"


@interface GameView : NSView {
	//Don't touch these variables unless you wish a slow and painful death.
	NSTimer *gameTimer;
	CGPoint screenDimensions;
	
	//Put your global game variables here, but don't set a value to them!!
	//This works: int test;
	//This doesn't: int test = 0;
	
	BOOL keysPressed[178];
	
	//TileView
	NSMutableArray* tiles;
	
	NSMutableArray* sprites;
	
	NSMutableArray* items;
	
	NSMutableArray* maps;
	
	NSMutableArray* npcs;
	
	int selectedNpc;
	int selectedMap;
	CGPoint selectedTile;
	CGPoint previouslySelectedTile;
	int tileWidth;
	int tileHeight;
	int mapWidth;
	int mapHeight;
	float scrollX;
	float scrollAccelX;
	float scrollY;
	float scrollAccelY;
	CGPoint mouseDown;
	BOOL updateScreen;
	BOOL playingWorld;
	int currentLayer;
	NSString* selectedTab;
	
	IBOutlet TileView *tileView;
	IBOutlet NSTableView *mapTableView;
	IBOutlet NSButton *deleteMapBtn;
	IBOutlet NSButton *newMapBtn;
	IBOutlet NSTextField *mapNumLabel;
	IBOutlet NSTextField *mapNameTxt;
	IBOutlet NSTextField *mapLeftTxt;
	IBOutlet NSTextField *mapRightTxt;
	IBOutlet NSTextField *mapUpTxt;
	IBOutlet NSTextField *mapDownTxt;
	IBOutlet NSButton *fillTool;
	IBOutlet NSTabView *tabView;
	
	IBOutlet TileView *spriteView;
	IBOutlet TileView *itemView;
	IBOutlet NSTableView *npcTableView;
	IBOutlet NSTextField *npcNameLabel;
	IBOutlet NSTextField *healthLabel;
	IBOutlet NSTextField *levelLabel;
	IBOutlet NSTextField *attackLabel;
	IBOutlet NSTextField *speedLabel;
	IBOutlet NSTextField *weaponLabel;
	IBOutlet NSTextField *trinketLabel;
	IBOutlet NSTextField *manaLabel;
	IBOutlet NSTextField *goldLabel;
	IBOutlet NSTextField *defenseLabel;
	IBOutlet NSTextField *potionsLabel;
	IBOutlet NSTextField *armorLabel;
	IBOutlet NSTextField *specialLabel;
	IBOutlet NSButton *canDropWeapon;
	IBOutlet NSButton *canDropTrinket;
	IBOutlet NSButton *canLevelUp;
	IBOutlet NSButton *canDropArmor;
	IBOutlet NSButton *canDropGold;
	IBOutlet NSButton *canDropPotions;
	IBOutlet NSButton *deleteNPCBtn;
	IBOutlet NSButton *newNPCBtn;
	IBOutlet NSButton *canMove;
	IBOutlet NSButton *tranMapTravel;
	IBOutlet NSButton *moveRand;
	IBOutlet NSButton *moveToPlayer;
	IBOutlet NSButton *moveToNPC;
	IBOutlet NSButton *moveToAnything;
	IBOutlet NSButton *attackNothing;
	IBOutlet NSButton *attackPlayer;
	IBOutlet NSButton *attackNPC;
	IBOutlet NSButton *attackAnything;

	
	IBOutlet NSButton *playMap;
	IBOutlet NSButton *saveWorld;
	
	IBOutlet NSMatrix *tileLayers;
	
	//***Attributes
	IBOutlet NSMatrix *drawAttributes;
	IBOutlet NSTextField *tileTxt;
	IBOutlet NSButton *blockedCheckBox;
	IBOutlet NSTextField *setTileNpc;
	IBOutlet NSButton *setPermanentNpc;
	
	
	//Play world variables
	int playerMap;
	CGPoint playerTile;
	CGPoint goingToTile;
	int moveTimer;
	NSImage* player;
	NSMutableArray* worldNpcs;
	
	//IBOutlet id textField;
}

-(void)updateMapStats;
- (void)updateTileStats;
- (void)updateNpcStats;
- (TileData*)dynamicallyGetTileAt:(CGPoint)position;
- (TileData*)staticallyGetTileAt:(CGPoint)position;

- (NSImage*) loadImage:(NSString*)name type:(NSString*)imageType;
- (NSImage*) loadImageAtApp:(NSString*)name type:(NSString*)imageType;
- (NSString*) loadText:(NSString*)name type:(NSString*)fileType;
- (void) drawLine:(CGPoint)point topoint:(CGPoint)topoint linesize:(float)linesize color:(float[])color;
- (void) drawImage:(NSImage*)sprite point:(CGPoint)point rotation:(float)rotation;
- (void) drawOval:(float[])color point:(CGPoint)point dimensions:(CGPoint)dimensions filled:(BOOL)filled linesize:(float)linesize;
- (void) drawString:(NSString*)text point:(CGPoint)point font:(NSString*)font color:(float[])color size:(int)textSize;
- (void) drawRectangle:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color filled:(BOOL)filled linesize:(float)linesize;
- (BOOL) saveFileAtApp:(NSString*)name object:(NSMutableArray*)object;
- (NSMutableArray*) openFileAtApp:(NSString*)name;
-(void) quit;

@end

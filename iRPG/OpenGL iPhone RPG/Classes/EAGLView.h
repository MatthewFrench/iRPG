#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"
#import "Image.h"

#import "MapData.h"
#import "TileData.h"
#import "PlayerData.h"
#import "NpcData.h"
#import "DamageEffect.h"
#import "Item.h"
#import "WorldNpc.h"

@interface EAGLView : UIView {
	//******GAME VARIABLES
	NSTimer *gameTimer;
	BOOL runningLogic;
	CGPoint screenDimensions;
	
	CFTimeInterval fpsCounter;
	int fpsCounterTimer;
	
	//*****holds all menu interfaces
	Image* interfaceView[10];
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
	NSMutableArray* npcs;
	
	//*****Player Data
	PlayerData *playerData;
	
	//****Damage effect to display
	NSMutableArray* damageEffects;
	
	Image* toggleStats[14];
	NSString* toggleStatsText[14];
	
	Image* originalLightning[4];
	CGPoint lightningPosition;
	float lightningLength;
	float lightningRotation;
	int lightningTimerMax;
	int lightningTimer;
	int lightningNum;
	float loadingProgress;
	float loadingProgressMax;
	BOOL drawLightning;
	
	int movePlayerTimer;
	int movePlayerTimerMax;
	
	int moveNpcTimerMax;
	
	int attackPlayerTimer;
	int attackPlayerTimerMax;
	
	int regenPlayerTimer;
	int regenPlayerTimerMax;
	
	//*****Input Data
	CGPoint touchedScreenBegan1;
	CGPoint touchedScreenBegan2;
	
	CGPoint touchedScreenMoved1;
	CGPoint touchedScreenMoved2;
	
	CGPoint touchedScreenEnded1;
	CGPoint touchedScreenEnded2;
	
	CGPoint touchedScreen1;
	CGPoint touchedScreen2;
	
	//****Game Text Box Use Freely****
	UITextField* textField;
	
	NSMutableArray* savedGames[3];
	
	CGPoint middleScreen;
	BOOL updateScreen;
	//******END GAME VARIABLES
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
}

@end

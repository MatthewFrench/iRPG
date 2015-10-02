/**
 ~Try adding in smooth movement.
 ~Make monsters follow you when in view range.
 ~Items.
 **/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

//Define the views
#define GameScreen 0
#define MainMenu 1
#define SaveMenu 2
#define CreditsMenu 3
#define CharacterMenu 4
#define OptionsMenu 5
#define InstructionsMenu 6
#define Loading 7
#define PlayerDead 8

//For Organizing maps in a grid
#define Center 0
#define Above 1
#define Below 2
#define Left 3
#define Right 4
#define TopLeft 5
#define TopRight 6
#define BottomLeft 7
#define BottomRight 8

//For NPC Movement
#define MoveRand 1
#define MoveToPlayer 2
#define MoveToNpc 3
#define MoveToAnything 4
#define AttackNothing 1
#define AttackPlayer 2
#define AttackNpc 3
#define AttackAnything 4


// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) renderScene;
- (void)drawImage:(Image*)image AtPoint:(CGPoint)point;
- (void)updateToggleStats:(int)number text:(NSString *)text AtPoint:(CGPoint)point Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color;
- (Image*)drawTextToImage:(NSString *)text  Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color;
- (void)drawText:(NSString *)text AtPoint:(CGPoint)point Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color;
- (void)drawRect:(CGRect)rect color:(float[])color;
//******GAME METHODS
- (void) touchedBegan1:(CGPoint)touchPosition;
- (void) touchedMoved1:(CGPoint)touchPosition;
- (void) touchedEnded1:(CGPoint)touchPosition;
- (void) touchedBegan2:(CGPoint)touchPosition;
- (void) touchedMoved2:(CGPoint)touchPosition;
- (void) touchedEnded2:(CGPoint)touchPosition;
- (NSMutableArray*) openFileAtApp:(NSString*)name type:(NSString*)type;
- (NSMutableArray*) openFileInDocs:(NSString*)name;
- (BOOL) saveFileInDocs:(NSString*)name object:(NSMutableArray*)object;
- (void) deleteFileInDocs:(NSString*)name;
- (void)mainGameLoop;
- (void)drawView:(int)drawView;
- (void)movePlayer:(int)direction;
- (void)thinkNpc:(int)npcNum;
- (void)moveNpc:(int)npcNum direction:(int)direction;
- (void)getSurroundingMaps:(MapData*[])map;
- (void) saveGame;
- (void) loadGame:(int)selectedGame;
- (void) appQuit;
- (void) textFieldFinished;

//*****END GAME METHODS

@end


@implementation EAGLView

@synthesize context;


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		
		CGRect rect = [[UIScreen mainScreen] bounds];
		
		
		// Set up OpenGL projection matrix
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof( rect.size.width/2, -rect.size.width/2, -rect.size.height / 2, rect.size.height / 2, -1, 1 );
		glMatrixMode(GL_MODELVIEW);
		glViewport(0, 0, rect.size.width, rect.size.height);
		glTranslatef(160.0f, 240.0f, 0.0f );
		glRotatef(270.0f, 0.0f, 0.0f, 1.0f);
		glScalef(1.0, -1.0, 1.0);
		
		
		// Initialize OpenGL states
		//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		currentView = Loading;
		interfaceView[Loading] = [[Image alloc] initWithImage:[UIImage imageNamed:@"loading.png"] filter:GL_NEAREST];
		originalLightning[0] = [[Image alloc] initWithImage:[UIImage imageNamed:@"Spell 0.png"] filter:GL_NEAREST];
		originalLightning[1] = [[Image alloc] initWithImage:[UIImage imageNamed:@"Spell 1.png"] filter:GL_NEAREST];
		originalLightning[2] = [[Image alloc] initWithImage:[UIImage imageNamed:@"Spell 2.png"] filter:GL_NEAREST];
		originalLightning[3] = [[Image alloc] initWithImage:[UIImage imageNamed:@"Spell 3.png"] filter:GL_NEAREST];
		loadingProgressMax = 6;
		lightningPosition = CGPointMake(139,115);
		touchedScreen1 = CGPointMake(-1, -1);
		touchedScreen2 = CGPointMake(-1, -1);
		movePlayerTimerMax = 6;
		attackPlayerTimerMax = 12;
		regenPlayerTimerMax = 200; //Regenerate every 10 seconds
		updateScreen = TRUE;
		
		//Make the textField
		textField = [ [ UITextField alloc ] initWithFrame: CGRectMake(160, 28, 150, 50) ];
		textField.adjustsFontSizeToFitWidth = YES;
		textField.textColor = [UIColor whiteColor];
		textField.font = [UIFont systemFontOfSize:17.0];
		textField.placeholder = @"Enter your name...";
		textField.autocorrectionType = UITextAutocorrectionTypeNo;        // no auto correction support
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		textField.textAlignment = UITextAlignmentCenter;
		textField.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
		textField.returnKeyType = UIReturnKeyDone;
		textField.tag = 0;
		textField.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
		textField.center = CGPointMake(267, 240);
		
		textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
		textField.text = @"";
		[ textField setEnabled: YES ];
		
		damageEffects = [NSMutableArray new];
		middleScreen = CGPointMake((177 - 46/2)*2,(160 - 46/2)*2);
		
		gameTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1/20 target:self selector:@selector(mainGameLoop) userInfo:nil repeats:YES];
		screenDimensions = CGPointMake([self bounds].size.height, [self bounds].size.width);
	}
    return self;
}

- (void)mainGameLoop {
	//Run fps counter
	fpsCounterTimer += 1;
	if (fpsCounterTimer > 60) {
		float delta = (CFAbsoluteTimeGetCurrent() - fpsCounter);
		NSLog(@"%f fps",(float)1/delta*fpsCounterTimer);
		fpsCounter = CFAbsoluteTimeGetCurrent();
		fpsCounterTimer = 0;
	}
	
	if (touchedScreenBegan1.x != -1) {[self touchedBegan1:touchedScreenBegan1]; touchedScreen1 = touchedScreenBegan1; touchedScreenBegan1.x = -1;updateScreen = TRUE;}
	if (touchedScreenMoved1.x != -1) {[self touchedMoved1:touchedScreenMoved1]; touchedScreen1 = touchedScreenMoved1; touchedScreenMoved1.x = -1;updateScreen = TRUE;}
	if (touchedScreenEnded1.x != -1) {[self touchedEnded1:touchedScreenEnded1]; touchedScreen1 = CGPointMake(-1, -1); touchedScreenEnded1.x = -1;updateScreen = TRUE;}
	if (touchedScreenBegan2.x != -1) {[self touchedBegan2:touchedScreenBegan2]; touchedScreenBegan2.x = -1;updateScreen = TRUE;}
	if (touchedScreenMoved2.x != -1) {[self touchedMoved2:touchedScreenMoved2]; touchedScreenMoved2.x = -1;updateScreen = TRUE;}
	if (touchedScreenEnded2.x != -1) {[self touchedEnded2:touchedScreenEnded2]; touchedScreenEnded2.x = -1;updateScreen = TRUE;}
	
	
	//Control all game elements
	if (currentView == GameScreen) {
		//Player Move Timer
		if (movePlayerTimer != movePlayerTimerMax) {
			movePlayerTimer += 1;
		}
		//Player Attack Timer
		if (attackPlayerTimer != attackPlayerTimerMax) {
			attackPlayerTimer += 1;
		}
		//Player Regeneration Timer
		if (playerData.hp < playerData.hpmax || playerData.mp < playerData.mpmax) {
			regenPlayerTimer += 1;
			if (regenPlayerTimer >= regenPlayerTimerMax) {
				regenPlayerTimer = 0;
				playerData.hp += 1;
				playerData.mp += 1;
				if (playerData.hp > playerData.hpmax) {playerData.hp = playerData.hpmax;}
				if (playerData.mp > playerData.mpmax) {playerData.mp = playerData.mpmax;}
				updateScreen = TRUE;
			}
		}
		//Player Control
		if (touchedScreen1.x != -1) {
			if (movePlayerTimer == movePlayerTimerMax) {
				//Arrow Pad Buttons
				//RIGHT BUTTON
				if (touchedScreen1.x >= 427 && touchedScreen1.x <= 472 && touchedScreen1.y >= 242 && touchedScreen1.y <= 272) {
					[self movePlayer:2];
				} 
				//LEFT BUTTON
				else if (touchedScreen1.x >= 358 && touchedScreen1.x <= 402 && touchedScreen1.y >= 245 && touchedScreen1.y <= 278) {
					[self movePlayer:1];
				}
				//UP BUTTON
				else if (touchedScreen1.x >= 400 && touchedScreen1.x <= 440 && touchedScreen1.y >= 203 && touchedScreen1.y <= 242) {
					[self movePlayer:3];
				}
				//Down BUTTON
				else if (touchedScreen1.x >= 398 && touchedScreen1.x <= 434 && touchedScreen1.y >= 272 && touchedScreen1.y <= 314) {
					[self movePlayer:4];
				}
			}
		}
		if (touchedScreen2.x != -1) {}
		
		
		//Control Npcs
		MapData* map[9];
		map[Center] = [maps objectAtIndex:playerData.currentMap]; //Selected Map
		[self getSurroundingMaps:&map];
		for (int i = 0; i < [npcs count]; i ++) {
			WorldNpc* npc = [npcs objectAtIndex:i];
			NpcData* dataOfNpc = [npcData objectAtIndex:npc.npcNum];
			BOOL npcInMap = FALSE;
			for (int e = 0; e < 9; e ++) {
				if (npc.currentMap == [maps indexOfObject:map[e]]) {npcInMap = TRUE;}
			}
			if (npcInMap) {
				if (dataOfNpc.canMove) {
					npc.npcTimer += 1;
					if (npc.npcTimer == dataOfNpc.speed) {npc.npcTimer = 0;[self thinkNpc:i];}
				}
				
				if (npc.hp <= 0) {
				//Npc dead
					
					if (!npc.permanent) {
						WorldNpc* newNpc = [WorldNpc new];
						newNpc.npcNum = npc.npcNum;
						newNpc.originalMap = npc.originalMap;
						newNpc.originalTile = npc.originalTile;
						newNpc.currentMap = npc.originalMap;
						newNpc.currentTile = npc.originalTile;
						newNpc.permanent = npc.permanent;
						newNpc.hp = dataOfNpc.hpmax;
						newNpc.mp = dataOfNpc.mpmax;
						newNpc.npcTimer = 0;
						[npcs addObject:newNpc];
						[newNpc release];
					}
					[npcs removeObjectAtIndex:i];
					//i-=1;
					 
				}
				
			}
		}
		 
		//See if player dead
		if (playerData.hp <= 0) {currentView = PlayerDead;}
	}
	if (currentView == Loading) {
		tiles = [NSMutableArray new];
		//Load all the tile Images
		for (int i = 0; i > -1; i += 1) {
			loadingProgress += 1;
			[self renderScene];
			if ([UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]] != nil) {
				Image* tileImage = [[Image alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]];
				[tiles addObject:tileImage];
				[tileImage release];
			} else {
				i= -2;
			}
		}
		//End load all tile Images
		lightningNum += 1;
		
		//Load all character Sprites
		characterImages = [NSMutableArray new];
		for (int e = 0;e > -1;e += 1) {
			loadingProgress += 1;
			[self renderScene];
			if ([UIImage imageNamed:[NSString stringWithFormat:@"Npc %d.png",e]] != nil) {
				Image* npcSpriteFile = [[Image alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Npc %d.png",e]] filter:GL_NEAREST];
				[characterImages addObject:npcSpriteFile];
				[npcSpriteFile release];
			} else {
				e= -2;
			}
		}
		//End load all character Sprites
		lightningNum += 1;
		
		
		//Load all item Sprites
		itemImages = [NSMutableArray new];
		for (int e = 0;e > -1;e += 1) {
			loadingProgress += 1;
			[self renderScene];
			if ([UIImage imageNamed:[NSString stringWithFormat:@"Item %d.png",e]] != nil) {
				Image* itemSpritesFile = [[Image alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Item %d.png",e]] filter:GL_NEAREST];
				[itemImages addObject:itemSpritesFile];
				[itemSpritesFile release];
			} else {
				e= -2;
			}
		}
		//End load all item Sprites
		lightningNum += 1;
		
		
		eventBg = [NSMutableArray new];
		for(int i = 0; i > -1; i += 1) {
			loadingProgress += 1;
			[self renderScene];
			if ([UIImage imageNamed:[NSString stringWithFormat:@"event %d.png",i]] != nil) {
				Image* eventImage = [[Image alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"event %d.png",i]] filter:GL_NEAREST];
				[eventBg addObject:eventImage];
				[eventImage release];
			} else {
				i= -2;
			}
		}
		//***END LOAD IMAGE
		lightningNum += 1;
		
		
		//***LOAD Interface Images TO DRAW	
		interfaceView[MainMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"mainmenu.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[GameScreen] = [[Image alloc] initWithImage:[UIImage imageNamed:@"background.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[InstructionsMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"instructions.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[OptionsMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"options.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[CreditsMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"credits.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[SaveMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"savemenu.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		[self renderScene];
		interfaceView[CharacterMenu] = [[Image alloc] initWithImage:[UIImage imageNamed:@"charactermenu.png"] filter:GL_NEAREST];
		loadingProgress += 1;
		interfaceView[PlayerDead] = [[Image alloc] initWithImage:[UIImage imageNamed:@"playerdeath.png"] filter:GL_NEAREST];
		
		loadingProgress += 1;
		lightningNum += 1;
		[self renderScene];
		//Load world
		NSMutableArray* world = [self openFileAtApp:@"World Data" type:@"gan"];
		if ([world count] > 1) {
			loadingProgress += 1;
			lightningNum += 1;
			[self renderScene];
			maps = [world objectAtIndex:0];
			loadingProgress += 1;
			lightningNum += 1;
			[self renderScene];
			npcData = [world objectAtIndex:1];
			loadingProgress += 1;
			lightningNum += 1;
			[self renderScene];
		} else {
			maps = [world objectAtIndex:0];
		}
		
		
		loadingProgress += 1;
		lightningNum += 1;
		[self renderScene];
		tileWidth = 45;
		tileHeight = 45;
		mapWidth = 765;
		mapHeight = 630;
		currentView = MainMenu;
	}
	if (updateScreen) {updateScreen = FALSE; [self renderScene];}
}
- (void)drawView:(int)drawView {
	float color[] = {1.0,1.0,1.0,1.0};
	//Render the game Scene	
	switch (currentView) {
		case Loading:
		{
			if (lightningNum == 4) {lightningNum = 0;}
			[self drawImage:interfaceView[currentView] AtPoint:CGPointMake(0, 0)];
			int oldWidth = originalLightning[lightningNum].imageWidth;
			[originalLightning[lightningNum] setImageWidth:(333 - lightningPosition.x)*(loadingProgress/158)];
			[self drawImage:originalLightning[lightningNum] AtPoint:lightningPosition];
			[originalLightning[lightningNum] setImageWidth:oldWidth];
			break;
		}
		case SaveMenu:
		{
			[self drawImage:interfaceView[currentView] AtPoint:CGPointMake(0, 0)];
			for (int i = 0; i < 3; i++) {
				if (savedGames[i] == nil) {
					[self drawText:[NSString stringWithFormat:@"Game %d: Empty",i+1] AtPoint:CGPointMake(90, 100 + 68*i) Alignment:UITextAlignmentCenter Font:@"Helvetica" FontSize:16 color:color];
				} else {
					PlayerData* viewGame = [savedGames[i] objectAtIndex:0];
					[self drawText:viewGame.playerName AtPoint:CGPointMake(125, 87 + 68*i) Alignment:UITextAlignmentCenter Font:@"Helvetica" FontSize:18 color:color];
					
					[self drawText:[NSString stringWithFormat:@"Lvl:%d  Gold:%d" ,viewGame.lvl,viewGame.gold] AtPoint:CGPointMake(100, 110 + 68*i) Alignment:UITextAlignmentCenter Font:@"Helvetica" FontSize:14 color:color];
				}
			}
			break;
		}
		case GameScreen:
		{
			//Draw World
			if (playerData.currentMap > -1 && playerData.currentMap < [maps count]) {
				MapData* map[9];
				int mapNumbers[9];
				map[Center] = [maps objectAtIndex:playerData.currentMap]; //Selected Map
				[self getSurroundingMaps:&map];
				for (int i = 0; i < 9; i ++) {
					mapNumbers[i] = [maps indexOfObject:map[i]];
				}
				//Draw the maps
				for (int i = 0; i < 9; i ++) {
					if (map[i] != nil) {
						NSArray* maptiles = [map[i] mapTiles];
						int addX = 0;
						int addY = 0;
						if (i == Above) {addY = -mapHeight;}
						if (i == Below) {addY = mapHeight;}
						if (i == Left) {addX = -mapWidth;}
						if (i == Right) {addX = mapWidth;}
						if (i == TopLeft) {addY = -mapHeight;addX = -mapWidth;}
						if (i == TopRight) {addY = -mapHeight;addX = mapWidth;}
						if (i == BottomLeft) {addY = mapHeight;addX = -mapWidth;}
						if (i == BottomRight) {addY = mapHeight;addX = mapWidth;}
						int mapx = addX-playerData.playerTilePos.x*45+middleScreen.x/2;
						int mapy = addY-playerData.playerTilePos.y*45+middleScreen.x/2;
						//Only draw maps in view
						if (mapx < screenDimensions.x && mapx + mapWidth > 0 &&
							mapy < screenDimensions.y && mapy + mapHeight > 0) {
							//Draw each layer of tiles
							for (int l = 0; l < 10; l ++) {
								//Draw npcs, player..
								if (l == 6) { //Before fringe draw player
									if (map[i] == [maps objectAtIndex:playerData.currentMap]) {
										[self drawImage:[characterImages objectAtIndex:playerData.sprite] AtPoint:CGPointMake(middleScreen.x/2, middleScreen.y/2)];
										//Now draw the player's health bar
										if (playerData.hp < playerData.hpmax) {
											color[0] = 1.0;
											color[1] = 0.0;
											color[2] = 0.0;
											color[3] = 1.0;
											[self drawRect:CGRectMake(middleScreen.x/2+5, middleScreen.y/2+43, middleScreen.x/2+40, middleScreen.y/2+3+43) color:color];
											color[0] = 0.0;
											color[1] = 1.0;
											color[2] = 0.0;
											color[3] = 1.0;
											if (playerData.hp > 0) {
												[self drawRect:CGRectMake(middleScreen.x/2+5, middleScreen.y/2+43, middleScreen.x/2+5+35*((float)playerData.hp/playerData.hpmax), middleScreen.y/2+3+43) color:color];
											}
											color[0] = 1.0;
											color[1] = 1.0;
											color[2] = 1.0;
											color[3] = 1.0;
										}
									}
									//Also Draw NPCS
									for (int e = 0; e < [npcs count]; e ++) {
										WorldNpc* npc = [npcs objectAtIndex:e];
										if (mapNumbers[i] == npc.currentMap) {
											NpcData* drawNpc = [npcData objectAtIndex:npc.npcNum];
											CGPoint npcPosition = CGPointMake(round(npc.currentTile.x*45 - playerData.playerTilePos.x*45+addX+middleScreen.x/2),round(npc.currentTile.y*45 - playerData.playerTilePos.y*45+addY+middleScreen.y/2));
											[self drawImage:[characterImages objectAtIndex:drawNpc.sprite] AtPoint:npcPosition];
											//Now draw the npc's health bar
											if (npc.hp < drawNpc.hpmax) {
												color[0] = 1.0;
												color[1] = 0.0;
												color[2] = 0.0;
												color[3] = 1.0;
												[self drawRect:CGRectMake(npcPosition.x+5, npcPosition.y+43, npcPosition.x+40, npcPosition.y+3+43) color:color];
												color[0] = 0.0;
												color[1] = 1.0;
												color[2] = 0.0;
												color[3] = 1.0;
												if (npc.hp > 0) {
													[self drawRect:CGRectMake(npcPosition.x+5, npcPosition.y+43, npcPosition.x+5+35*((float)npc.hp/drawNpc.hpmax), npcPosition.y+3+43) color:color];
												}
												color[0] = 1.0;
												color[1] = 1.0;
												color[2] = 1.0;
												color[3] = 1.0;
											}
										}
									}
									//Draw Damage stats
									for (int d = 0; d < [damageEffects count]; d += 1) {
										DamageEffect* damage = [damageEffects objectAtIndex:d];
										if (mapNumbers[i] == damage.mapPosition) {
										damage.ticks += 0.5;
										if (damage.textImage == nil) {
											color[0] = 2.0;
											color[1] = 0.0;
											color[2] = 0.0;
											damage.textImage = [self drawTextToImage:damage.text Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:20 color:color];
											color[0] = 1.0;
											color[1] = 1.0;
											color[2] = 1.0;
										}
										//Now draw the image of the text
										//[self drawImage:damage.textImage AtPoint:CGPointMake((damage.position.x+.5)*45.0, (damage.position.y+.5 - (damage.ticks/damage.ticksMax*0.6))*45.0)];
										
											[self drawImage:damage.textImage AtPoint: CGPointMake(round(damage.tilePosition.x*45 - playerData.playerTilePos.x*45+addX+middleScreen.x/2+.5*45),round(damage.tilePosition.y*45 - playerData.playerTilePos.y*45+addY+middleScreen.y/2+.5*45 - (damage.ticks/damage.ticksMax*0.6)*45))];
										
											
										if (damage.ticks >= damage.ticksMax) {[damageEffects removeObjectAtIndex:d]; i-=1;}
										updateScreen = TRUE;
										}
									}
								}
								//Draw the tiles.
								int startx = floor((playerData.playerTilePos.x*45 - screenDimensions.x/2-addX)/45);
								if (startx < 0) {startx = 0;}
								int endx = ceil((playerData.playerTilePos.x*45 + screenDimensions.x/2-addX)/45);
								if (endx > [maptiles count]) {endx = [maptiles count];}
								for (int x = startx; x < endx; x ++) {
									NSArray* column = [maptiles objectAtIndex:x];
									int starty = floor((playerData.playerTilePos.y*45 - screenDimensions.y/2-addY)/45);
									if (starty < 0) {starty = 0;}
									int endy = ceil((playerData.playerTilePos.y*45 + screenDimensions.y/2-addY)/45);
									if (endy > [column count]) {endy = [column count];}
									for (int y = starty; y < endy; y ++) {
										TileData* tile = [column objectAtIndex:y];
											if ([tile getTileOnLayer:l] != 0) {
												[self drawImage:[tiles objectAtIndex:[tile getTileOnLayer:l]] AtPoint:CGPointMake(round(x*45+addX-playerData.playerTilePos.x*45+middleScreen.x/2),round(y*45+addY-playerData.playerTilePos.y*45+middleScreen.y/2))];
											}
									}
								}
							}
						}
					}
				}
			}
			
			[self drawImage:interfaceView[currentView] AtPoint:CGPointMake(0, 0)];
			//Draw Toggle Stats
			
			if (playerData.displayToggle == 0) {
				
				[self updateToggleStats:0 text:@"Stats" AtPoint:CGPointMake(395,5) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:18 color:color];
			 

			 [self updateToggleStats:1 text:[NSString stringWithFormat:@"HP: %d/%d",playerData.hp,playerData.hpmax] AtPoint:CGPointMake(375,30) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 [self updateToggleStats:2 text:[NSString stringWithFormat:@"MP: %d/%d",playerData.mp,playerData.mpmax] AtPoint:CGPointMake(375,44) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 [self updateToggleStats:3 text:[NSString stringWithFormat:@"LVL: %d",playerData.lvl] AtPoint:CGPointMake(375,58) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 [self updateToggleStats:4 text:[NSString stringWithFormat:@"EXP: %d",playerData.exp] AtPoint:CGPointMake(375,72) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 [self updateToggleStats:5 text:[NSString stringWithFormat:@"Gold: %d",playerData.gold] AtPoint:CGPointMake(375,86) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 [self drawImage:[itemImages objectAtIndex:20] AtPoint:CGPointMake(430,90)];
			 [self updateToggleStats:6 text:[NSString stringWithFormat:@"%d Potions",playerData.potions] AtPoint:CGPointMake(375,110) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:14 color:color];
			 } else 
			 if (playerData.displayToggle == 1) {
			 [self updateToggleStats:7 text:@"Inventory" AtPoint:CGPointMake(380,5) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:18 color:color];
			 
			 [self updateToggleStats:8 text:@"Weapon:" AtPoint:CGPointMake(375,28) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:15 color:color];
			 [self updateToggleStats:9 text:[NSString stringWithFormat:@"%@", playerData.weapon] AtPoint:CGPointMake(375,44) Alignment:UITextAlignmentLeft Font:@"Helvetica-Oblique" FontSize:14 color:color];
			 
			 [self updateToggleStats:10 text:@"Armor:" AtPoint:CGPointMake(375,60) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:15 color:color];
			 [self updateToggleStats:11 text:[NSString stringWithFormat:@"%@",playerData.armor] AtPoint:CGPointMake(375,76) Alignment:UITextAlignmentLeft Font:@"Helvetica-Oblique" FontSize:14 color:color];
			 
			 [self updateToggleStats:12 text:@"Trinket:" AtPoint:CGPointMake(375,92) Alignment:UITextAlignmentLeft Font:@"Helvetica" FontSize:15 color:color];
			 [self updateToggleStats:13 text:[NSString stringWithFormat:@"%@",playerData.trinket] AtPoint:CGPointMake(375,108) Alignment:UITextAlignmentLeft Font:@"Helvetica-Oblique" FontSize:14 color:color];
			 }
			//float textcolor[4] = {1.0,1.0,1.0,1.0};
			
			break;
		}
		default:
		{
			[self drawImage:interfaceView[currentView] AtPoint:CGPointMake(0, 0)];
		}
			break;
	}
}
- (void)renderScene {
    
	// Make sure we are renderin to the frame buffer
    [EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
	// Clear the color buffer with the glClearColor which has been set
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self drawView: currentView];
	
	// Switch the render buffer and framebuffer so our scene is displayed on the screen
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)movePlayer:(int)direction {
	CGPoint originalPosition = playerData.playerTilePos;
	CGPoint newPosition = originalPosition;
	if (direction == 1) {newPosition.x -= 1;} //Left
	if (direction == 2) {newPosition.x += 1;} //Right
	if (direction == 3) {newPosition.y -= 1;} //Up
	if (direction == 4) {newPosition.y += 1;} //Down
	MapData* originalMap = [maps objectAtIndex:playerData.currentMap];
	TileData* originalTile = [[originalMap.mapTiles objectAtIndex:originalPosition.x] objectAtIndex:originalPosition.y];
	int newMapPos = playerData.currentMap;
	if (newPosition.x < 0) {newMapPos = originalMap.mapLeft; newPosition.x += mapWidth/45;}
	if (newPosition.y < 0) {newMapPos = originalMap.mapUp; newPosition.y += mapHeight/45;}
	if (newPosition.x >= mapWidth/45) {newMapPos = originalMap.mapRight; newPosition.x -= mapWidth/45;}
	if (newPosition.y >= mapHeight/45) {newMapPos = originalMap.mapDown; newPosition.y -= mapHeight/45;}
	if (newMapPos > -1 && newMapPos < [maps count]) {
		MapData* newMap = [maps objectAtIndex:newMapPos];
		TileData* newTile = [[newMap.mapTiles objectAtIndex:newPosition.x] objectAtIndex:newPosition.y];
		if (!newTile.blocked) {
			int blockedNpc = -1;;
			for (int i = 0; i < [npcs count]; i ++) {
				WorldNpc* npc = [npcs objectAtIndex:i];
				if (npc.currentTile.x == newPosition.x && npc.currentTile.y == newPosition.y && npc.currentMap == newMapPos) {blockedNpc = i;}
			}
			if (blockedNpc == -1) { //No npc so move
				playerData.playerTilePos = newPosition;
				playerData.currentMap = newMapPos;
				movePlayerTimer = 0;
			} else { //Npc so don't move and see if can attack
				WorldNpc* attackNpc = [npcs objectAtIndex:blockedNpc];
				NpcData* attackNpcData = [npcData objectAtIndex:attackNpc.npcNum];
				if (attackNpcData.attackStyles == AttackPlayer) {
					if (attackPlayerTimer == attackPlayerTimerMax) {
						//Attack npc
						attackNpc.hp -= playerData.att;
						DamageEffect* newDamage = [DamageEffect new];
						newDamage.tilePosition = attackNpc.currentTile;
						newDamage.mapPosition = attackNpc.currentMap;
						newDamage.text = [NSString stringWithFormat:@"%d",-playerData.att];
						[damageEffects addObject: newDamage];
						[newDamage release];
						attackPlayerTimer = 0;
					}
					movePlayerTimer = 0;
					
				}
			}
			updateScreen = TRUE;
		}
	}
}
- (void)thinkNpc:(int)npcNum {
	//Think on what to do
	//Then call moveNpc
	WorldNpc* npc = [npcs objectAtIndex:npcNum];
	NpcData* npcsData = [npcData objectAtIndex:npc.npcNum];
	if (npcsData.canMove) {
		if (npcsData.movementStyles == MoveRand) {
			//Rand starts at 0 so rand%4 can choose 0,1,2 or 3.
			[self moveNpc:npcNum direction:(rand() % 4)+1];
		} else if (npcsData.movementStyles == MoveToPlayer) {
			/** Directions
			 1 = Left
			 2 = Right
			 3 = Up
			 4 = Down
			 **/
			//Take into account that the npc has trans-map movement
			MapData* map[9];
			map[Center] = [maps objectAtIndex:playerData.currentMap]; //Selected Map
			[self getSurroundingMaps:&map];
			float addX = 0;
			float addY = 0;
			for (int i = 0; i < 9; i ++) {
				if (map[i] != nil) {
					if ([maps objectAtIndex:npc.currentMap] == map[i]) {
						if (i == Above) {addY = -mapHeight;}
						if (i == Below) {addY = mapHeight;}
						if (i == Left) {addX = -mapWidth;}
						if (i == Right) {addX = mapWidth;}
						if (i == TopLeft) {addY = -mapHeight;addX = -mapWidth;}
						if (i == TopRight) {addY = -mapHeight;addX = mapWidth;}
						if (i == BottomLeft) {addY = mapHeight;addX = -mapWidth;}
						if (i == BottomRight) {addY = mapHeight;addX = mapWidth;}
					}
				}
			}
			
			CGPoint playerPosition = CGPointMake(playerData.playerTilePos.x - addX/45, playerData.playerTilePos.y - addY/45);
			
			int HorzVert = rand() % 2;
			if (playerPosition.x == npc.currentTile.x) {HorzVert = 0;}
			if (playerPosition.y == npc.currentTile.y) {HorzVert = 1;}
			
			if (playerPosition.x < npc.currentTile.x && HorzVert == 1) {
				[self moveNpc:npcNum direction:1];
			} else if (playerPosition.x > npc.currentTile.x && HorzVert == 1) {
				[self moveNpc:npcNum direction:2];
			} else if (playerPosition.y < npc.currentTile.y && HorzVert == 0) {
				[self moveNpc:npcNum direction:3];
			} else if (playerPosition.y > npc.currentTile.y && HorzVert == 0) {
				[self moveNpc:npcNum direction:4];
			}
		}
		
	}
}
- (void)moveNpc:(int)npcNum direction:(int)direction {
	WorldNpc* npc = [npcs objectAtIndex:npcNum];
	NpcData* npcsData = [npcData objectAtIndex:npc.npcNum];
	CGPoint originalPosition = npc.currentTile;;
	CGPoint newPosition = originalPosition;
	if (direction == 1) {newPosition.x -= 1;} //Left
	if (direction == 2) {newPosition.x += 1;} //Right
	if (direction == 3) {newPosition.y -= 1;} //Up
	if (direction == 4) {newPosition.y += 1;} //Down
	MapData* originalMap = [maps objectAtIndex:npc.currentMap];
	TileData* originalTile = [[originalMap.mapTiles objectAtIndex:originalPosition.x] objectAtIndex:originalPosition.y];
	int newMapPos = npc.currentMap;
	if (newPosition.x < 0) {newMapPos = originalMap.mapLeft; newPosition.x += mapWidth/45;}
	if (newPosition.y < 0) {newMapPos = originalMap.mapUp; newPosition.y += mapHeight/45;}
	if (newPosition.x >= mapWidth/45) {newMapPos = originalMap.mapRight; newPosition.x -= mapWidth/45;}
	if (newPosition.y >= mapHeight/45) {newMapPos = originalMap.mapDown; newPosition.y -= mapHeight/45;}
	if (newMapPos > -1 && newMapPos < [maps count]) {
		MapData* newMap = [maps objectAtIndex:newMapPos];
		TileData* newTile = [[newMap.mapTiles objectAtIndex:newPosition.x] objectAtIndex:newPosition.y];
		BOOL attackedPlayer = FALSE;
		if (!newTile.blocked) {
			if (playerData.currentMap != newMapPos || playerData.playerTilePos.x != newPosition.x || playerData.playerTilePos.y != newPosition.y) {
				npc.currentTile = newPosition;
				npc.currentMap = newMapPos;
				updateScreen = TRUE;
			} else {
				//Player on that tile... ATTACK!!!!!!!!
				attackedPlayer = TRUE;
				if (npcsData.attackStyles = AttackPlayer) {
					//Temporary battle code
					playerData.hp -= 5;
					//Add damage stuff
					DamageEffect* newDamage = [DamageEffect new];
					newDamage.tilePosition = playerData.playerTilePos;
					newDamage.mapPosition = playerData.currentMap;
					newDamage.text = [NSString stringWithFormat:@"%d",-5];
					[damageEffects addObject: newDamage];
					[newDamage release];
					updateScreen = TRUE;
				}
			}
		} else if (attackedPlayer == FALSE) {
			//If behind a barrier then move randomly
			[self moveNpc:npcNum direction:(rand() % 4)+1];
		}
	}
}
- (void)getSurroundingMaps:(MapData*[])map {
	if (map[Center].mapUp != -1) { //Map Above
		map[Above] = [maps objectAtIndex:map[Center].mapUp];
	} else {map[Above] = nil;}
	if (map[Center].mapDown != -1) { //Map Below
		map[Below] = [maps objectAtIndex:map[Center].mapDown];
	} else {map[Below] = nil;}
	if (map[Center].mapLeft != -1) { //Map left
		map[Left] = [maps objectAtIndex:map[Center].mapLeft];
	} else {map[Left] = nil;}
	if (map[Center].mapRight != -1) { //Map Right
		map[Right] = [maps objectAtIndex:map[Center].mapRight];
	} else {map[Right] = nil;}
	if (map[Above] != nil) { //Top Left Map
		if (map[Above].mapLeft != -1) {
			map[TopLeft] = [maps objectAtIndex:map[Above].mapLeft];
		} else {map[TopLeft] = nil;}
	} else {map[TopLeft] = nil;}
	if (map[TopLeft] == nil) {
		if (map[Left] != nil) { //Left Top - Couldn't connect so try another map
			if (map[Left].mapUp != -1) {
				map[TopLeft] = [maps objectAtIndex:map[Left].mapUp];
			} else {map[TopLeft] = nil;}
		} else {map[TopLeft] = nil;}
	}
	if (map[Above] != nil) { //Top Right
		if (map[Above].mapRight != -1) {
			map[TopRight] = [maps objectAtIndex:map[1].mapRight];
		} else {map[TopRight] = nil;}
	} else {map[TopRight] = nil;}
	if (map[TopRight] == nil) {
		if (map[Right] != nil) { //Right Top - Couldn't connect so try another map
			if (map[Right].mapUp != -1) {
				map[TopRight] = [maps objectAtIndex:map[Right].mapUp];
			} else {map[TopRight] = nil;}
		} else {map[TopRight] = nil;}
	}
	if (map[Below] != nil) { //Bottom Left
		if (map[Below].mapLeft != -1) {
			map[BottomLeft] = [maps objectAtIndex:map[Below].mapLeft];
		} else {map[BottomLeft] = nil;}
	} else {map[BottomLeft] = nil;}
	if (map[BottomLeft] == nil) {
		if (map[Left] != nil) { //Left Bottom - Couldn't connect so try another map
			if (map[Left].mapDown != -1) {
				map[BottomLeft] = [maps objectAtIndex:map[Left].mapDown];
			} else {map[BottomLeft] = nil;}
		} else {map[BottomLeft] = nil;}
	}
	if (map[Below] != nil) { //Bottom Right
		if (map[Below].mapRight != -1) {
			map[BottomRight] = [maps objectAtIndex:map[Below].mapRight];
		} else {map[BottomRight] = nil;}
	} else {map[BottomRight] = nil;}
	if (map[BottomRight] == nil) {
		if (map[Right] != nil) { //Right Bottom - Couldn't connect so try another map
			if (map[Right].mapDown != -1) {
				map[BottomRight] = [maps objectAtIndex:map[Right].mapDown];
			} else {map[BottomRight] = nil;}
		} else {map[BottomRight] = nil;}
	}
}

- (void) touchedBegan1:(CGPoint)touchPosition {
	switch (currentView) {
		case GameScreen:
		{
			CGPoint playerTilePos = playerData.playerTilePos;
			//Arrow Pad Buttons
			//RIGHT BUTTON
			if (touchPosition.x >= 427 && touchPosition.x <= 472 && touchPosition.y >= 242 && touchPosition.y <= 272) {
				[self movePlayer:2];
			} 
			//LEFT BUTTON
			else if (touchPosition.x >= 358 && touchPosition.x <= 402 && touchPosition.y >= 245 && touchPosition.y <= 278) {
				[self movePlayer:1];
			}
			//UP BUTTON
			else if (touchPosition.x >= 400 && touchPosition.x <= 440 && touchPosition.y >= 203 && touchPosition.y <= 242) {
				[self movePlayer:3];
			}
			//Down BUTTON
			else if (touchPosition.x >= 398 && touchPosition.x <= 434 && touchPosition.y >= 272 && touchPosition.y <= 314) {
				[self movePlayer:4];
			}
			//Toggle BUTTON
			else if (touchPosition.x >= 364 && touchPosition.x <= 464 && touchPosition.y >= 139 && touchPosition.y <= 180) {
				if ( playerData.displayToggle == 1) {
					playerData.displayToggle = 0;
				} else {playerData.displayToggle = 1;}
			}
			break;
		}
		case PlayerDead:
		{
			currentView = GameScreen;
			//Now do death stuff.
			playerData.currentMap = 0;
			playerData.hp = playerData.hpmax;
			playerData.mp = playerData.mpmax;
			playerData.gold = 0;
			playerData.playerTilePos = CGPointMake(8,8);
			updateScreen = TRUE;
			break;
		}
		default:
			break;
	}
}
- (void) touchedMoved1:(CGPoint)touchPosition {
	
}
- (void) touchedEnded1:(CGPoint)touchPosition {
	switch (currentView) {
		case MainMenu:
		{
			//Play Button
			if (touchPosition.x >= 180 && touchPosition.x <= 300 && 
				touchPosition.y >= 50 && touchPosition.y <= 106) {
				//Load games
				savedGames[0] = [self openFileInDocs:@"game1.txt"];
				savedGames[1] = [self openFileInDocs:@"game2.txt"];
				savedGames[2] = [self openFileInDocs:@"game3.txt"];
				//Switch to save screen
				currentView = SaveMenu;
			}
			//Instructions Button
			if (touchPosition.x >= 130 && touchPosition.x <= 335 && 
				touchPosition.y >= 110 && touchPosition.y <= 145) {currentView = InstructionsMenu;}
			//Options Button
			if (touchPosition.x >= 170 && touchPosition.x <= 295 && 
				touchPosition.y >= 150 && touchPosition.y <= 190) {currentView = OptionsMenu;}
			//Credits Button
			if (touchPosition.x >= 175 && touchPosition.x <= 290 && 
				touchPosition.y >= 191 && touchPosition.y <= 225) {currentView = CreditsMenu;}
			//To GMG Button
			//if (touchPosition.x >= 5 && touchPosition.x <= 130 && 
			//touchPosition.y >= 335 && touchPosition.y <= 290) 
			//{[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gamemakersgarage.com"]];}
			updateScreen = TRUE;
			break;
		}
		case GameScreen:
		{
			if (playerData.displayToggle == 0) {
				if (touchPosition.x >= 430 && touchPosition.y >= 90 && touchPosition.x <= 430+45 && touchPosition.y <= 90+45) {
					if (playerData.potions > 0 && (playerData.hp<playerData.hpmax || playerData.mp<playerData.mpmax)) {
						playerData.potions -= 1;
						playerData.hp += ceil((float)playerData.hpmax/4);
						playerData.mp += ceil((float)playerData.mpmax/4);
						if (playerData.hp > playerData.hpmax) {playerData.hp = playerData.hpmax;}
						if (playerData.mp > playerData.mpmax) {playerData.mp = playerData.mpmax;}
					}
				}
			}
			break;
		}
		case SaveMenu:
		{
			//NSLog(@"Click in Save Menu");
			//Deletebutton
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 90 && touchPosition.y < 130 ) {
				[self deleteFileInDocs:@"game1.txt"]; savedGames[0] = nil;
			}
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 160 && touchPosition.y < 200 ) {
				[self deleteFileInDocs:@"game2.txt"]; savedGames[1] = nil;
			}
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 230 && touchPosition.y < 270 ) {
				[self deleteFileInDocs:@"game3.txt"]; savedGames[2] = nil;
			}
			//Playbuton
			if (touchPosition.x > 370 && touchPosition.x < 470 && 
				touchPosition.y > 85 && touchPosition.y < 140 ) {
				[self loadGame:0];
			}
			if (touchPosition.x > 370 && touchPosition.x < 470 && 
				touchPosition.y > 156 && touchPosition.y < 210 ) {
				[self loadGame:1];
			}
			if (touchPosition.x > 370 && touchPosition.x < 470 && 
				touchPosition.y > 225 && touchPosition.y < 280 ) {
				[self loadGame:2];
			}
			updateScreen = TRUE;
			break;
		}
		case CreditsMenu:
		{
			currentView = MainMenu;
			updateScreen = TRUE;
			break;
		}
		case CharacterMenu:
		{
			break;
		}
		case OptionsMenu:
		{
			currentView = MainMenu;
			updateScreen = TRUE;
			break;
		}
		case InstructionsMenu:
		{
			currentView = MainMenu;
			updateScreen = TRUE;
			break;
		}
		default:
			break;
	}
}
- (void) touchedBegan2:(CGPoint)touchPosition {
	
}
- (void) touchedMoved2:(CGPoint)touchPosition {
	
}
- (void) touchedEnded2:(CGPoint)touchPosition {
	
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray* allTouches = [touches allObjects];
	NSArray* eventTouches = [[event allTouches] allObjects];
	
	for (int i = 0; i < [eventTouches count]; i +=1) {
		if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:0]) {
			//touchedScreenBegan1 = [[eventTouches objectAtIndex:i] locationInView:self];
			//Rotated touch to landscape
			CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
			touchedScreenBegan1 = touch;
			[self setNeedsDisplay];
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				//Rotated touch to landscape
				CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
				touchedScreenBegan2 = touch;
			}
		}
	}
	//CGPoint location = [touch locationInView:self];
	// tell the view to redraw
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	NSArray* allTouches = [touches allObjects];
	NSArray* eventTouches = [[event allTouches] allObjects];
	
	for (int i = 0; i < [eventTouches count]; i +=1) {
		if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:0]) {
			//Rotated touch to landscape
			CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
			touchedScreenMoved1 = touch;
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				//Rotated touch to landscape
				CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
				touchedScreenMoved2 = touch;
			}
		}
	}
	//CGPoint location = [touch locationInView:self];
	// tell the view to redraw
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray* allTouches = [touches allObjects];
	NSArray* eventTouches = [[event allTouches] allObjects];
	
	for (int i = 0; i < [eventTouches count]; i +=1) {
		if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:0]) {
			//Rotated touch to landscape
			CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
			touchedScreenEnded1 = touch;
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				//Rotated touch to landscape
				CGPoint touch = CGPointMake([[eventTouches objectAtIndex:i] locationInView:self].y, 320-[[eventTouches objectAtIndex:i] locationInView:self].x);
				touchedScreenEnded2 = touch;
			}
		}
	}
	//CGPoint location = [touch locationInView:self];
	// tell the view to redraw
}

- (NSMutableArray*) openFileAtApp:(NSString*)name type:(NSString*)type {
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:type];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if (fileExists) {
		NSMutableArray* openedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
		[openedObject retain];
		return openedObject;
	} else {
		return nil;
	}
}
- (NSMutableArray*) openFileInDocs:(NSString*)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	NSMutableArray* openedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	[openedObject retain];
	return openedObject;
}
- (BOOL) saveFileInDocs:(NSString*)name object:(NSMutableArray*)object {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	
	// save the people array
	BOOL saved=[NSKeyedArchiver archiveRootObject:object toFile:path];
	return saved;
}
- (void) deleteFileInDocs:(NSString*)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:NULL];
}
- (void) saveGame {
	//Save Game
	if (currentView == GameScreen ||currentView == PlayerDead) {//On gamescreen, save game
		NSMutableArray* gameToSave = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
		[gameToSave addObject:playerData];
		[gameToSave addObject:npcs];
		[gameToSave addObject:damageEffects];
		[gameToSave addObject:[NSNumber numberWithInt:currentView]];
		int selectedGame;
		if (savedGames[0]) {selectedGame = 1;}
		if (savedGames[1]) {selectedGame = 2;}
		if (savedGames[2]) {selectedGame = 3;}
		[self saveFileInDocs:[NSString stringWithFormat:@"game%d.txt",selectedGame] object:gameToSave];
	}
}
- (void) loadGame:(int)selectedGame {
	if (selectedGame != 0) {savedGames[0] = nil;}
	if (selectedGame != 1) {savedGames[1] = nil;}
	if (selectedGame != 2) {savedGames[2] = nil;}
	NSMutableArray* toLoad;
	toLoad = savedGames[selectedGame];
	if (toLoad != nil) {
		[toLoad retain];
		playerData = [toLoad objectAtIndex:0];
		npcs = [toLoad objectAtIndex:1];
		damageEffects = [toLoad objectAtIndex:2];
		NSLog(@"Damage on screen: %d", [damageEffects count]);
		currentView = [[toLoad objectAtIndex:3] intValue];
		updateScreen = TRUE;
	} else {
		savedGames[selectedGame] = [NSMutableArray new];
		playerData = [PlayerData new];
		npcs = [NSMutableArray new];
		//Create all World Npcs
		for (int i = 0; i < [maps count]; i ++) {
			MapData* npcMap = [maps objectAtIndex:i];
			for (int x = 0; x < [npcMap.mapTiles count]; x ++) {
				NSArray* column = [npcMap.mapTiles objectAtIndex:x];
				for (int y = 0; y < [column count]; y ++) {
					TileData* tile = [column objectAtIndex:y];
					if (tile.spawnNpc != -1) {
						WorldNpc* npc = [WorldNpc new];
						npc.npcNum = tile.spawnNpc;
						npc.currentMap = i;
						npc.currentTile = CGPointMake(x, y);
						npc.originalMap = i;
						npc.originalTile = CGPointMake(x, y);
						npc.permanent = tile.permanentNpc;
						[npcs addObject:npc];
						[npc release];
					}
				}
			}
		}
		
		currentView = CharacterMenu;
		
		textField.delegate = [[UIApplication sharedApplication] delegate];
		[self addSubview: textField ];
		[textField release];
		[textField becomeFirstResponder];
		updateScreen = TRUE;
	}
}

-(void) appQuit {
	[self saveGame];
}
-(void) textFieldFinished {
	[textField resignFirstResponder];
	currentView = GameScreen;
	playerData.playerName = textField.text;
	
	playerData.playerTilePos = CGPointMake(8,8);
	playerData.hp = 50;
	playerData.hpmax = 50;
	playerData.mp = 0;
	playerData.mpmax = 0;
	playerData.sprite = 3;
	playerData.att = 2;
	playerData.def = 10;
	playerData.weapon = @"Leafy Plant";
	playerData.armor = @"Plastic Wrap";
	playerData.trinket = @"Shoe Lace";
	updateScreen = TRUE;
	
	[textField removeFromSuperview]; 
}

- (void)drawImage:(Image*)image AtPoint:(CGPoint)point {
	[image renderAtPoint:CGPointMake(point.x, 320-point.y - image.imageHeight) centerOfImage:NO];
}
- (void)updateToggleStats:(int)number text:(NSString *)text AtPoint:(CGPoint)point Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color {
	if ([toggleStatsText[number] isEqualToString:text] == FALSE) {
		if (toggleStatsText[number] != nil) {[toggleStatsText[number] release];}
		if (toggleStats[number] != nil) {[toggleStats[number] release];}
		NSLog(@"Updated Text: %@",text);
		toggleStats[number] = [self drawTextToImage:text Alignment:alignment Font:font FontSize:size color:color];
		toggleStatsText[number] = text;
		[toggleStatsText[number] retain];
	}
	[self drawImage:toggleStats[number] AtPoint:point];
}
- (Image*)drawTextToImage:(NSString *)text Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color {
	Texture2D* statusTexture = [[Texture2D alloc] initWithString:text dimensions:[text sizeWithFont:[UIFont fontWithName:font size:size]] alignment:alignment fontName:font fontSize:size color:color];
	Image* test = [[Image alloc] initWithTexture:statusTexture];
	return test;
}
- (void)drawText:(NSString *)text AtPoint:(CGPoint)point Alignment:(int)alignment Font:(NSString*)font FontSize:(int)size color:(float[])color {
	Texture2D* statusTexture = [[Texture2D alloc] initWithString:text dimensions:[text sizeWithFont:[UIFont fontWithName:font size:size]] alignment:alignment fontName:font fontSize:size color:color];
	Image* test = [[Image alloc] initWithTexture:statusTexture];
	[self drawImage:test AtPoint:point];
	[test release];
}
- (void)drawRect:(CGRect)rect color:(float[])color {
	GLfloat vertx[4*2];
	
	vertx[2] = rect.origin.x;
	vertx[3] = 320-rect.origin.y;
	vertx[0] = rect.size.width;
	vertx[1] = 320-rect.origin.y;
	vertx[4] = rect.size.width;
	vertx[5] = 320-rect.size.height;
	vertx[6] = rect.origin.x;
	vertx[7] = 320-rect.size.height;
	
	GLfloat colors[4 * 4];
	
	for(int i = 0; i < 4 * 4; i++) {
		colors[i] = color[0];
		colors[++i] = color[1];
		colors[++i] = color[2];
		colors[++i] = color[3];
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertx);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glEnableClientState(GL_COLOR_ARRAY);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	glDisableClientState(GL_COLOR_ARRAY);	
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self renderScene];
}
- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}
- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


- (void)dealloc {
    
    gameTimer = nil;
	//******GAME VARIABLES
	for (int i ;i < 10;i++) {
		[interfaceView[i] release];
	}
	[eventBg release];
	[tileImages release];
	[characterImages release];
	[itemImages release];
	[tiles release];
	[maps release];
	[npcData release];
	[npcs release];
	[damageEffects release];
	for (int i ;i < 14;i++) {
		[toggleStats[i] release];
		[toggleStatsText[i] release];
	}
	for (int i ;i < 4;i++) {
		[originalLightning[i] release];
	}
	[textField release];
	for (int i ;i < 3;i++) {
		[savedGames[i] release];
	}
	//******END GAME VARIABLES
	
	
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end

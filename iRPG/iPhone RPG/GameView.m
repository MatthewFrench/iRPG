#import "GameView.h"
#import "mapData.h"
#import "tileData.h"
#define GameScreen 0
#define MainMenu 1
#define SaveMenu 2
#define CreditsMenu 3
#define CharacterMenu 4
#define OptionsMenu 5
#define InstructionsMenu 6
#define Loading 7
@implementation GameView
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame])
	{
	}
	return self;
}
- (void) awakeFromNib{
	currentView = Loading;
	interfaceView[Loading] = [self loadImage:@"loading" type:@"png"];
	originalLightning[0] = [self loadImage:@"Spell 0" type:@"png"];
	originalLightning[1] = [self loadImage:@"Spell 1" type:@"png"];
	originalLightning[2] = [self loadImage:@"Spell 2" type:@"png"];
	originalLightning[3] = [self loadImage:@"Spell 3" type:@"png"];
	loadingProgressMax = 6;
	lightningPosition = CGPointMake(139,115);
	[self setNeedsDisplay];
	
	// You have to explicity turn on multitouch for the view
	self.multipleTouchEnabled = YES;
	screenDimensions = CGPointMake([self bounds].size.width, [self bounds].size.height);
	//***Turn on Game Timer
	gameTimer = [NSTimer scheduledTimerWithTimeInterval: 1/20
												 target: self
											   selector: @selector(handleGameTimer:)
											   userInfo: nil
												repeats: YES];
}
- (void) handleGameTimer: (NSTimer *) gameTimer {
	if (touchedScreenBegan1.x != -1) {[self touchedBegan1:touchedScreenBegan1]; touchedScreenBegan1.x = -1;}
	if (touchedScreenMoved1.x != -1) {[self touchedMoved1:touchedScreenMoved1]; touchedScreenMoved1.x = -1;}
	if (touchedScreenEnded1.x != -1) {[self touchedEnded1:touchedScreenEnded1]; touchedScreenEnded1.x = -1;}
	if (touchedScreenBegan2.x != -1) {[self touchedBegan2:touchedScreenBegan2]; touchedScreenBegan2.x = -1;}
	if (touchedScreenMoved2.x != -1) {[self touchedMoved2:touchedScreenMoved2]; touchedScreenMoved2.x = -1;}
	if (touchedScreenEnded2.x != -1) {[self touchedEnded2:touchedScreenEnded2]; touchedScreenEnded2.x = -1+69;}
	 
	
	//Control all game elements
	if (currentView == GameScreen) {}
	if (currentView == Loading) {
		switch ((int)loadingProgress) {
			case 0:
			{
				tiles = [NSMutableArray new];
				
				//Load all the tile Images
				UIImage* transparentTile = [UIImage new];
				[tiles addObject:transparentTile];
				[transparentTile release];
				for (int i = 1; i > 0; i += 1) {
					UIImage* tileImage = [self loadImage:[NSString stringWithFormat:@"%d",i] type:@"png"];
					if (tileImage != nil) {
						[tiles addObject:tileImage];
						[tileImage release];
					} else {
						i= -2;
					}
				}
				//End load all tile Images
				loadingProgress = 1;
				updateScreen = TRUE;
				break;
			}
			case 1:
			{
				//Load all character Sprites
				characterImages = [NSMutableArray new];
				for (int e = 0;e > -1;e += 1) {
					UIImage* npcSpriteFile = [self loadImage:[NSString stringWithFormat:@"Npc %d",e] type:@"png"];
					if (npcSpriteFile != nil) {
						[characterImages addObject:npcSpriteFile];
						[npcSpriteFile release];
					} else {
						e= -2;
					}
				}
				//End load all character Sprites
				loadingProgress = 2;
				lightningNum = 2;
				updateScreen = TRUE;
				
				break;
			}
			case 2:
			{
				//Load all item Sprites
				itemImages = [NSMutableArray new];
				for (int e = 0;e > -1;e += 1) {
					UIImage* itemSpritesFile = [self loadImage:[NSString stringWithFormat:@"Item %d",e] type:@"png"];
					if (itemSpritesFile != nil) {
						[itemImages addObject:itemSpritesFile];
						[itemSpritesFile release];
					} else {
						e= -2;
					}
				}
				//End load all item Sprites
				loadingProgress = 3;
				lightningNum = 3;
				updateScreen = TRUE;
				
				break;
			}
			case 3:
			{
				eventBg = [NSMutableArray new];
				for(int i = 0; i > -1; i += 1) {
					UIImage* eventImage = [self loadImage:[NSString stringWithFormat:@"event %d",i] type:@"png"];
					if (eventImage != nil) {
						[eventBg addObject:eventImage];
						[eventImage release];
					} else {
						i= -2;
					}
				}
				//***END LOAD IMAGE
				loadingProgress = 4;
				lightningNum = 0;
				updateScreen = TRUE;
				
				break;
			}
			case 4:
			{
				//***LOAD Interface Images TO DRAW	
				interfaceView[MainMenu] = [self loadImage:@"mainmenu" type:@"png"];
				interfaceView[GameScreen] = [self loadImage:@"background" type:@"png"];
				interfaceView[InstructionsMenu] = [self loadImage:@"instructions" type:@"png"];
				interfaceView[OptionsMenu] = [self loadImage:@"options" type:@"png"];
				interfaceView[CreditsMenu] = [self loadImage:@"credits" type:@"png"];
				interfaceView[SaveMenu] = [self loadImage:@"savemenu" type:@"png"];
				interfaceView[CharacterMenu] = [self loadImage:@"charactermenu" type:@"png"];
				loadingProgress = 5;
				lightningNum = 1;
				updateScreen = TRUE;
				
				break;
			}
			case 5:	
			{
				//Load world
				NSMutableArray* world = [self openFileAtApp:@"World Data" type:@"gan"];
				if ([world count] > 1) {
					NSLog(@"World %d",[world count]);
					maps = [world objectAtIndex:0];
					npcData = [world objectAtIndex:1];
				} else {
					maps = [world objectAtIndex:0];
				}
				loadingProgress = 6;
				lightningNum = 2;
				updateScreen = TRUE;
				
				break;
			}
			case 6:
			{
				tileWidth = 45;
				tileHeight = 45;
				mapWidth = 765;
				mapHeight = 630;
				currentView = MainMenu;
				updateScreen = TRUE;
				break;
			}
		}
	}
	if (updateScreen) {updateScreen = FALSE; [self setNeedsDisplay];}
} // handleTimer
- (void) touchedBegan1:(CGPoint)touchPosition {
	if (currentView == GameScreen) {
		CGPoint playerTilePos = playerData.playerTilePos;
		//Arrow Pad Buttons
		//RIGHT BUTTON
		if (touchPosition.x >= 428 && touchPosition.x <= 466 && touchPosition.y >= 244 && touchPosition.y <= 270) {
			playerTilePos.x += 1;
		} 
		//LEFT BUTTON
		else if (touchPosition.x >= 360 && touchPosition.x <= 403 && touchPosition.y >= 244 && touchPosition.y <= 270) {
			playerTilePos.x -= 1;
		}
		//UP BUTTON
		else if (touchPosition.x >= 401 && touchPosition.x <= 429 && touchPosition.y >= 203 && touchPosition.y <= 243) {
			playerTilePos.y -= 1;
		}
		//Down BUTTON
		else if (touchPosition.x >= 401 && touchPosition.x <= 428 && touchPosition.y >= 273 && touchPosition.y <= 308) {
			playerTilePos.y += 1;
		}
		//Toggle BUTTON
		else if (touchPosition.x >= 364 && touchPosition.x <= 464 && touchPosition.y >= 139 && touchPosition.y <= 180) {
			if ( playerData.displayToggle == 1) {
				playerData.displayToggle = 0;
			} else {playerData.displayToggle = 1;}
		}
		playerData.playerTilePos = playerTilePos;
	}
}
- (void) touchedMoved1:(CGPoint)touchPosition {

}
- (void) touchedEnded1:(CGPoint)touchPosition {
	switch (currentView) {
		case MainMenu:
			//Play Button
			if (touchPosition.x >= 193 && touchPosition.x <= 290 && 
				touchPosition.y >= 66 && touchPosition.y <= 105) {
				//Load games
				//game1 = [self openFileInDocs:@"game1.txt"];
				//game2 = [self openFileInDocs:@"game2.txt"];
				//game3 = [self openFileInDocs:@"game3.txt"];
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
		case GameScreen:
			
			break;
		case SaveMenu:
			//NSLog(@"Click in Save Menu");
			//Deletebutton
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 90 && touchPosition.y < 130 ) {
				//[self deleteFileInDocs:@"game1.txt"]; game1 = nil;
			}
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 160 && touchPosition.y < 200 ) {
				//[self deleteFileInDocs:@"game2.txt"]; game2 = nil;
			}
			if (touchPosition.x > 280 && touchPosition.x < 360 && 
				touchPosition.y > 230 && touchPosition.y < 270 ) {
				//[self deleteFileInDocs:@"game3.txt"]; game3 = nil;
			}
			//Playbuton
			if (touchPosition.x > 380 && touchPosition.x < 460 && 
				touchPosition.y > 90 && touchPosition.y < 130 ) {
				//selectedGame = 1;
				//[self loadGame];
				playerData = [PlayerData new];
				currentView = GameScreen;
				//NSLog(@"Pressed play");
			}
			if (touchPosition.x > 380 && touchPosition.x < 460 && 
				touchPosition.y > 160 && touchPosition.y < 200 ) {
				//selectedGame = 2;
				//[self loadGame];
			}
			if (touchPosition.x > 380 && touchPosition.x < 460 && 
				touchPosition.y > 230 && touchPosition.y < 270 ) {
				//selectedGame = 3;
				//[self loadGame];
			}
			updateScreen = TRUE;
			break;
		case CreditsMenu:
			if (touchPosition.x >= 20 && touchPosition.x <= 145 &&
				touchPosition.y >= 435 && touchPosition.y <= 456) {currentView = MainMenu;} 
			updateScreen = TRUE;
			break;
		case CharacterMenu:
			if (textField.text != @"" && !textField.editing) {
				if (touchPosition.x > 40 && touchPosition.x < 160 && 
					touchPosition.y > 80 && touchPosition.y < 300 ) { //Warrior
					currentView = GameScreen;
					playerData.playerName = textField.text;
					playerData.playerClass = @"Warrior";
					
					playerData.playerTilePos = CGPointMake(4,4);
					playerData.hp = 50;
					playerData.hpmax = 50;
					playerData.mp = 0;
					playerData.mpmax = 0;
					playerData.sprite = 3;
					playerData.att = 10;
					playerData.def = 10;
					playerData.weapon = @"Leafy Plant";
					playerData.armor = @"Plastic Wrap";
					playerData.trinket = @"Shoe Lace";
					
					[textField removeFromSuperview]; 
					textField = nil;
				}
				if (touchPosition.x > 180 && touchPosition.x < 300 && 
					touchPosition.y > 80 && touchPosition.y < 300 ) {//Marksman
					currentView = GameScreen;
					playerData.playerName = textField.text;
					playerData.playerClass = @"Marksman";
					
					playerData.playerTilePos = CGPointMake(4,4);
					playerData.hp = 45;
					playerData.hpmax = 45;
					playerData.mp = 20;
					playerData.mpmax = 20;
					playerData.sprite = 4;
					playerData.att = 5;
					playerData.def = 5;
					playerData.weapon = @"Nerf Gun";
					playerData.armor = @"Piece of Bark";
					playerData.trinket = @"Arrow Head";
					
					[textField removeFromSuperview]; 
					textField = nil;
				}
				if (touchPosition.x > 320 && touchPosition.x < 440 && 
					touchPosition.y > 80 && touchPosition.y < 300 ) {//Sorcerer
					currentView = GameScreen;
					playerData.playerName = textField.text;
					playerData.playerClass = @"Sorcerer";
					
					playerData.playerTilePos = CGPointMake(4,4);
					playerData.hp = 30;
					playerData.hpmax = 30;
					playerData.mp = 50;
					playerData.mpmax = 50;
					playerData.sprite = 5;
					playerData.att = 3;
					playerData.def = 3;
					playerData.weapon = @"Branch";
					playerData.armor = @"Tattered Cloth";
					playerData.trinket = @"Medallion";
					
					[textField removeFromSuperview]; 
					textField = nil;
				}
			}
			updateScreen = TRUE;
			break;
		case OptionsMenu:
			if (touchPosition.x >= 20 && touchPosition.x <= 145 &&
				touchPosition.y >= 435 && touchPosition.y <= 456) {currentView = MainMenu;} 
			updateScreen = TRUE;
			break;
		case InstructionsMenu:
			if (touchPosition.x >= 20 && touchPosition.x <= 145 &&
				touchPosition.y >= 435 && touchPosition.y <= 456) {currentView = MainMenu;} 
			updateScreen = TRUE;
			break;
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
			[self touchedBegan1:[[eventTouches objectAtIndex:i] locationInView:self]];
			[self setNeedsDisplay];
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				touchedScreenBegan2 = [[eventTouches objectAtIndex:i] locationInView:self];
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
			touchedScreenMoved1 = [[eventTouches objectAtIndex:i] locationInView:self];
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				touchedScreenMoved2 = [[eventTouches objectAtIndex:i] locationInView:self];
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
			touchedScreenEnded1 = [[eventTouches objectAtIndex:i] locationInView:self];
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				touchedScreenEnded2 = [[eventTouches objectAtIndex:i] locationInView:self];
			}
		}
	}
	//CGPoint location = [touch locationInView:self];
	// tell the view to redraw
}
- (void) drawRect:(CGRect)rect{
	//DEFINE THE SCREEN'S DRAWING CONTEXT
	CGContextRef context;
	//[self drawImage:context translate:CGPointMake(0, 0) image:interfaceView[currentView] point:CGPointMake(0, 0) rotation:0.0];
	if (currentView == GameScreen) {
		CGPoint middleScreen = CGPointMake((177 - 46/2)*2,(160 - 46/2)*2);
		//Draw Maps
		if (playerData.currentMap > -1 && playerData.currentMap < [maps count]) {
			MapData* map;
			map = [maps objectAtIndex:playerData.currentMap]; //Selected Map
			if (map != nil) {
				NSArray* maptiles = [map mapTiles];
				for (int l = 0; l < 1; l ++) {
					if (l == 6 && map == [maps objectAtIndex:playerData.currentMap]) { //Before fringe draw player
						[self drawImage:context translate:CGPointMake(0, 0) image:[characterImages objectAtIndex:playerData.sprite] point:CGPointMake(middleScreen.x/2, middleScreen.y/2) rotation:0.0];
					}
					int tileStartx, tileEndx;
					if (playerData.playerTilePos.x - floor(middleScreen.x/45) > -1) {
						tileStartx = playerData.playerTilePos.x - floor(middleScreen.x/45);
					}
					if (playerData.playerTilePos.x + floor(middleScreen.x/45) < [maptiles count]) {
						tileEndx = playerData.playerTilePos.x + floor(middleScreen.x/45);
					} else {tileEndx = [maptiles count];}
					
					for (int x = tileStartx; x < tileEndx; x ++) {
						//for (int x = round(-45-middleScreen.x/2+playerData.playerTilePos.x*45)/45; x < round(750-middleScreen.x/2+playerData.playerTilePos.x*45)/45; x ++) {
						NSArray* column = [maptiles objectAtIndex:x];
						int tileStarty, tileEndy;
						if (playerData.playerTilePos.y - floor(middleScreen.y/45) > -1) {
							tileStarty = playerData.playerTilePos.y - floor(middleScreen.y/45);
						}
						if (playerData.playerTilePos.y + floor(middleScreen.y/45) < [column count]) {
							tileEndy = playerData.playerTilePos.y + floor(middleScreen.y/45);
						} else {tileEndy = [column count];}
						for (int y = tileStarty; y < tileEndy; y ++) {
							TileData* tile = [column objectAtIndex:y];
							if (round(x*45-playerData.playerTilePos.x*45+middleScreen.x/2) > -45 && round(x*45-playerData.playerTilePos.x*45+middleScreen.x/2) < 750 && round(y*45-playerData.playerTilePos.y*45+middleScreen.y/2) > -45 && round(y*45-playerData.playerTilePos.y*45+middleScreen.y/2) < 600) {
								if ([tile getTileOnLayer:l] != 0) {
									[self drawImage:context translate:CGPointMake(0, 0) image:[tiles objectAtIndex:[tile getTileOnLayer:l]] point:CGPointMake(round(x*45-playerData.playerTilePos.x*45+middleScreen.x/2),round(y*45-playerData.playerTilePos.y*45+middleScreen.y/2)) rotation:0.0];
								}
							}
						}
					}
				}
			}
		}
	}
	[self drawImage:context translate:CGPointMake(0, 0) image:interfaceView[currentView] point:CGPointMake(0, 0) rotation:0.0];
	if (currentView == Loading) {
		if (lightning[lightningNum] != nil) {[lightning[lightningNum] release];}
		lightning[lightningNum] = [self imageByCropping:originalLightning[lightningNum] toRect:CGRectMake(0, 0, (333 - lightningPosition.x)*(loadingProgress/loadingProgressMax), originalLightning[lightningNum].size.height)];
		[lightning[lightningNum] retain];
		[self drawImage:context translate:CGPointMake(0, 0) image:lightning[lightningNum] point:lightningPosition rotation:0.0];
	}
}

- (UIImage*)loadImage:(NSString *)name type:(NSString*)imageType {
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:imageType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		UIImage* imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
		return imageFile;
	} else {
		return nil;
	}
}
- (NSString*)loadText:(NSString *)name type:(NSString*)fileType  {
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:fileType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		NSString* txtFile = [[NSString alloc] initWithContentsOfFile:filePath];
		return txtFile;
	} else {
		return nil;
	}
}
- (void) drawImage:(CGContextRef)context translate:(CGPoint)translate image:(UIImage*)sprite point:(CGPoint)point rotation:(float)rotation {
	// Grab the drawing context
	
	//context = UIGraphicsGetCurrentContext();
	
	// like Processing pushMatrix
	
	//CGContextSaveGState(context);
	
	//CGContextTranslateCTM(context, translate.x, translate.y);
	
	// Uncomment to see the rotated square
	if (rotation != 0) {
	//CGContextRotateCTM(context, rotation * M_PI / 180);
	}
	//***DRAW THE IMAGE
	[sprite drawAtPoint:point];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	
	//CGContextRestoreGState(context);
}
- (void) drawLine:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point topoint:(CGPoint)topoint rotation:(float)rotation linesize:(float)linesize {
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//Set the width of the pen mark
	CGContextSetLineWidth(context, linesize);
	// Set red stroke
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
	// Draw a line
	//Starting point
	CGContextMoveToPoint(context, point.x, point.y);
	//Ending point
	CGContextAddLineToPoint(context,topoint.x, topoint.y);
	//Draw it
	CGContextStrokePath(context);
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawOval:(CGContextRef)context translate:(CGPoint)translate color:(float[])color point:(CGPoint)point dimensions:(CGPoint)dimensions rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize {
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	if (filled) {
		// Set red Fill
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		// Draw a circle (filled)
		CGContextFillEllipseInRect(context, CGRectMake(point.x, point.y, dimensions.x, dimensions.y));
	}else{
		//Set the width of the pen mark
		CGContextSetLineWidth(context, linesize);
		// Set red Fill
		CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
		// Draw a circle (filled)
		CGContextStrokeEllipseInRect(context, CGRectMake(point.x, point.y, dimensions.x, dimensions.y));
	}
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawString:(CGContextRef)context translate:(CGPoint)translate text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(NSString*)font color:(float[])color size:(int)textSize {
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation*M_PI/180);
	//Set Font
	UIFont* textFont = [UIFont fontWithName:font size:textSize];
	//Set the text color
	//CGContextSetFillColorWithColor(context, color);
	CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
	//***DRAW THE Text
	[text drawAtPoint:point withFont:textFont];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawRectangle:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize {
	//Positions/Dimensions of rectangle
	CGRect theRect = CGRectMake(point.x, point.y, widthheight.x, widthheight.y);
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation*M_PI/180);
	if (filled) {
		// Set red stroke
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		// Draw a rect with a red stroke
		CGContextFillRect(context, theRect);
	}else{
		//Set the width of the pen mark
		CGContextSetLineWidth(context, linesize);
		// Set red stroke
		CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
		// Draw a rect with a red stroke
		CGContextStrokeRect(context, theRect);
	}
	//CGContextStrokeRect(context, theRect);
	// like Processing popMatrix
	CGContextRestoreGState(context);
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
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect{
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	CGContextTranslateCTM(currentContext, 0.0, drawRect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
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

- (CGColorRef)createCGColor:(float[])rgba{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {rgba[0], rgba[1], rgba[2], rgba[3]};
	CGColorRef color = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	return color;
}
- (NSString*)getItemName:(int)itemNum{
	if (itemNum == 0) { return @"Gold";}	
	return @"";
}
- (NSMutableArray*)getItemDescription:(NSString*)itemName {
	NSMutableArray* description = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	if ([itemName isEqualToString:@"Gold"]) {
		[description addObject:@"A shiney substance that often catches"];
		[description addObject:@"the eye of primitivie beings such as"];
		[description addObject:@"monsters, animals and humans."];
	}
	return description;
}
- (void) saveGame {
		//NSMutableArray* gameToSave = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
		//[self saveFileInDocs:[NSString stringWithFormat:@"game%d.txt",selectedGame] object:gameToSave];
}
-(void) loadGame {
		/**
		textField = [ [ UITextField alloc ] initWithFrame: CGRectMake(160, 28, 150, 50) ];
		textField.adjustsFontSizeToFitWidth = YES;
		textField.textColor = [UIColor whiteColor];
		textField.font = [UIFont systemFontOfSize:17.0];
		textField.placeholder = @"Enter your name...";
		textField.autocorrectionType = UITextAutocorrectionTypeNo;        // no auto correction support
		//textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		textField.textAlignment = UITextAlignmentCenter;
		textField.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
		textField.returnKeyType = UIReturnKeyDone;
		textField.tag = 0;
		textField.delegate = [[[UIApplication sharedApplication] delegate] viewController];
		
		textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
		textField.text = @"";
		[ textField setEnabled: YES ];
		[self addSubview: textField ];
		[textField release];
		 **/
}

- (void) appQuit {
	[self saveGame];
}
- (void) dealloc {
	[interfaceView[0] release];
	[interfaceView[1] release];
	[interfaceView[2] release];
	[interfaceView[3] release];
	[interfaceView[4] release];
	[interfaceView[5] release];
	[interfaceView[6] release];
	[eventBg release];
	[eventItem release];
	[playerData release];
	[characterImages release];
	[itemImages release];
	[damageEffects release];
	[maps release];
	[gameTimer release];
	
	[super dealloc];
}

@end

//Possible easter eggs:
//Able to drag health bar to any amount, ONLY ONCE.
//
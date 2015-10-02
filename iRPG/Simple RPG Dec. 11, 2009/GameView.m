#import "GameView.h"
#import "mapData.h"
#import "tileData.h"
#define kAccelerometerFrequency        10 //Hz
@implementation GameView
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame])
	{
	}
	return self;
}
-(void)configureAccelerometer{
	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
	if(theAccelerometer)
	{
		theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
		theAccelerometer.delegate = self;
	}
	else
	{
		NSLog(@"Oops we're not running on the device!");
	}
}
- (void) awakeFromNib{
	currentview = 0;
	twoFingers = NO;
	playerData = [[PlayerData alloc] init];
	npcSprites = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	
	//Load all NPC Data
	npcData = [self loadText:@"Npcs" type:@"txt"];
	for (int e = 0;e > -1;e += 1) {
		UIImage* npcSpriteFile = [self loadImage:[NSString stringWithFormat:@"Npc %d",e] type:@"png"];
		if (npcSpriteFile != nil) {
			[npcSprites addObject:npcSpriteFile];
		} else {
			e= -2;
		}
	}
	
	maps = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	//LOAD Maps
	// Check if file exists
	for (int i = 1; i > 0; i += 1) {
		NSString *mapDataFile = [self loadText:[NSString stringWithFormat:@"Map %d",i] type:@"txt"];
		if (mapDataFile != nil) 
		{
			UIImage* mapImageFile = [self loadImage:[NSString stringWithFormat:@"Map %d",i] type:@"png"];
			NSMutableArray* tiles = [[NSMutableArray arrayWithCapacity:8] retain];
			
			//Create default "blank" tiles
			for (int e = 0; e < 8; e++) {
				NSMutableArray *row = [NSMutableArray arrayWithCapacity:7];
				
				for (int k = 0; k<7; k++) {
					TileData *loadTileData = [[TileData alloc] init];
					[row addObject:loadTileData];
				}
				
				[tiles addObject:row];
			}
			
			//LOAD GENERAL DATA ABOUT MAP I.E. NPCS
			NSArray* individualNpcData = [npcData componentsSeparatedByString:@"\n"];
			NSMutableArray* npcsToAdd = [[NSMutableArray alloc] init];
			NSArray* tileLineData = [mapDataFile componentsSeparatedByString:@"\n"];
			//First in array is the map name
			//Now go through whole array and distribute data to correct places
			//Map Attributes
			
			//If there are multiple attributes "," in the map first line then...
			if ([[tileLineData objectAtIndex:0] rangeOfString : @","].location != NSNotFound) {
				NSArray* mapAttributeData = [[tileLineData objectAtIndex:0] componentsSeparatedByString:@","];
				//Process each attribute
				for (int k = 1; k <[mapAttributeData count]; k +=1) {
					//Now split each attribute by ":" to get data
					NSArray* individualMapAttributeData = [[mapAttributeData objectAtIndex:k] componentsSeparatedByString:@":"];
					//If the attribute equals an NPC...
					if ([[individualMapAttributeData objectAtIndex:0] isEqualToString: @"NPC"]) 
					{
						//Create an empty NPC shell
						NpcData* newNpc = [[NpcData alloc] init];
						//Get the type of NPC it's stated as
						int typeOfNpc = [[individualMapAttributeData objectAtIndex:1] intValue];
						//Stick it where it's suppose to be on the map
						newNpc.position = CGPointMake([[individualMapAttributeData objectAtIndex:2] intValue],[[individualMapAttributeData objectAtIndex:3] intValue]);
						newNpc.moveCount = (arc4random() % 20) + 30; //150 50
						newNpc.moveTimer = 0;
						newNpc.movStyle = 0;
						newNpc.targetAttack = -2;
						
						NSArray* npcAttributeData = [[individualNpcData objectAtIndex:typeOfNpc] componentsSeparatedByString:@","];
						for (int m = 1; m <[npcAttributeData count]; m +=1) {
							NSArray* npcIndividualAttributeData = [[npcAttributeData objectAtIndex:m] componentsSeparatedByString:@":"];
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"SPRITE"]) 
							{
								newNpc.npcImageObj = [npcSprites objectAtIndex:[[npcIndividualAttributeData objectAtIndex:1] intValue]];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"MOVESTYLE"]) 
							{
								newNpc.movStyle = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"HP"]) 
							{
								newNpc.hp = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"HPMAX"]) 
							{
								newNpc.hpmax = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"MP"]) 
							{
								newNpc.mp = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"MPMAX"]) 
							{
								newNpc.mpmax = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"LVL"]) 
							{
								newNpc.lvl = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"EXP"]) 
							{
								newNpc.exp = [[npcIndividualAttributeData objectAtIndex:1] intValue];
							}
							if ([[npcIndividualAttributeData objectAtIndex:0] isEqualToString: @"TALK"]) 
							{
								newNpc.talk = [npcIndividualAttributeData objectAtIndex:1];
							}
						}
						[npcsToAdd addObject:newNpc];
					}
				}	
			}
			
			//Load data about tiles
			for (int e = 1; e <[tileLineData count]; e +=1)
			{
				if ([tileLineData objectAtIndex:e] != @"") {
					
					//Search if contains multiple attributes
					NSString *searchForMe = @",";
					NSRange range = [[tileLineData objectAtIndex:e] rangeOfString : searchForMe];
					
					if (range.location != NSNotFound) {
						
						//Line of tile data
						NSArray* tileAttributeData = [[tileLineData objectAtIndex:e] componentsSeparatedByString:@","];
						
						//Get TileX, TileY which is the first attribute
						int tilex = [[[tileAttributeData objectAtIndex:0] substringToIndex:1] intValue];
						int tiley = [[[[tileAttributeData objectAtIndex:0] substringFromIndex:2] substringToIndex:1] intValue];
						TileData *tileFound = [[tiles objectAtIndex:tilex] objectAtIndex:tiley];
						tileFound.npcOn = 0;
						
						//Process each attribute
						for (int k = 1; k <[tileAttributeData count]; k +=1) {
							NSArray* attributeData = [[tileAttributeData objectAtIndex:k] componentsSeparatedByString:@":"];
							//If attribute BLOCK exists
							if ([[attributeData objectAtIndex:0] isEqualToString: @"B"]) {
								//IF it is blocked
								if ([[attributeData objectAtIndex:1] isEqualToString: @"T"]) 
								{
									tileFound.blocked = 1;
								} else //IF it isn't blocked
									if ([[attributeData objectAtIndex:1] isEqualToString: @"F"]) {
										tileFound.blocked = 0;
									}
							} else //Now check if it's a Warp When HIT
								if ([[attributeData objectAtIndex:0] isEqualToString: @"WWH"]) {
									tileFound.warpWhenHitToMap = [[attributeData objectAtIndex:1] intValue];
									tileFound.warpWhenHitTo = CGPointMake([[attributeData objectAtIndex:2] intValue], [[attributeData objectAtIndex:3] intValue]);
								} else //Now check if it's a Warp To Right
									if ([[attributeData objectAtIndex:0] isEqualToString: @"WTR"]) {
										tileFound.warpLeaveToRightMap = [[attributeData objectAtIndex:1] intValue];
										tileFound.warpLeaveToRight = CGPointMake([[attributeData objectAtIndex:2] intValue], [[attributeData objectAtIndex:3] intValue]);
									} else //Now check if it's a Warp To Down
										if ([[attributeData objectAtIndex:0] isEqualToString: @"WTD"]) {
											tileFound.warpLeaveToDownMap = [[attributeData objectAtIndex:1] intValue];
											tileFound.warpLeaveToDown = CGPointMake([[attributeData objectAtIndex:2] intValue], [[attributeData objectAtIndex:3] intValue]);
										} else //Now check if it's a Warp To Up
											if ([[attributeData objectAtIndex:0] isEqualToString: @"WTU"]) {
												tileFound.warpLeaveToUpMap = [[attributeData objectAtIndex:1] intValue];
												tileFound.warpLeaveToUp = CGPointMake([[attributeData objectAtIndex:2] intValue], [[attributeData objectAtIndex:3] intValue]);
											} else //Now check if it's a Warp To Left
												if ([[attributeData objectAtIndex:0] isEqualToString: @"WTL"]) {
													tileFound.warpLeaveToLeftMap = [[attributeData objectAtIndex:1] intValue];
													tileFound.warpLeaveToLeft = CGPointMake([[attributeData objectAtIndex:2] intValue], [[attributeData objectAtIndex:3] intValue]);
												}
						}
					}
				}
			}
			
			for (int e = 0; e < [npcsToAdd count]; e +=1) {
				NpcData* npcToProcess = [npcsToAdd objectAtIndex:e];
				CGPoint npcTilePosition = npcToProcess.position;
				TileData *npcTile = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y];
				npcTile.npcOn = 1;
			}
			
			//Create an empty map to fill
			MapData *loadmapdata = [[MapData alloc] init];
			loadmapdata.mapDataFile = mapDataFile;
			loadmapdata.mapImageFile = mapImageFile;
			loadmapdata.mapTiles = tiles;
			loadmapdata.npcData = npcsToAdd;
			
			[maps addObject:loadmapdata];
		} else {i = -1;}
	}
	
	//***LOAD Interface IMAGE TO DRAW	
	interfaceImageObj[0] = [self loadImage:@"mainmenu" type:@"png"];
	interfaceImageObj[1] = [self loadImage:@"background" type:@"png"];
	interfaceImageObj[2] = [self loadImage:@"instructions" type:@"png"];
	interfaceImageObj[3] = [self loadImage:@"options" type:@"png"];
	interfaceImageObj[4] = [self loadImage:@"credits" type:@"png"];
	
	//***END LOAD IMAGE
	//***LOAD Player TO DRAW
	mapPos = CGPointMake(0, 3);
	playerData.playerTilePos = CGPointMake(2,3);
	playerData.sprite = 1;
	//***END LOAD IMAGE
	
	// You have to explicity turn on multitouch for the view
	self.multipleTouchEnabled = YES;
	
	// configure for accelerometer
	[self configureAccelerometer];
	
	//***Turn on Game Timer
	gameTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
												 target: self
											   selector: @selector(handleGameTimer:)
											   userInfo: nil
												repeats: YES];
}
- (void) handleGameTimer: (NSTimer *) gameTimer {
	BOOL updateScreen = FALSE;
	
	MapData *currentMap = [maps objectAtIndex:playerData.currentMap - 1];
	NSArray *tiles = currentMap.mapTiles;
	
	//Control touch input for player
	if (touchedScreen.x != -1) {
		if (currentview == 0) {  //Main Menu
			//Play Button
			if (touchedScreen.x >= 115 && touchedScreen.x <= 210 && touchedScreen.y >= 60 && touchedScreen.y <= 105) {currentview = 1;}
			//Instructions Button
			if (touchedScreen.x >= 55 && touchedScreen.x <= 255 && touchedScreen.y >= 110 && touchedScreen.y <= 145) {currentview = 2;}
			//Options Button
			if (touchedScreen.x >= 95 && touchedScreen.x <= 220 && touchedScreen.y >= 150 && touchedScreen.y <= 180) {currentview = 3;}
			//Credits Button
			if (touchedScreen.x >= 100 && touchedScreen.x <= 215 && touchedScreen.y >= 190 && touchedScreen.y <= 225) {currentview = 4;}
			//To GMG Button
			if (touchedScreen.x >= 5 && touchedScreen.x <= 315 && touchedScreen.y >= 335 && touchedScreen.y <= 355) {[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gamemakersgarage.com"]];}
		} else
			if (currentview == 1) {  //Gameplay Screen
				CGPoint playerTilePos = playerData.playerTilePos;
				TileData *thisTile = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y];
				//Arrow Pad Buttons
				//RIGHT BUTTON
				if (touchedScreen.x >= 50 && touchedScreen.x <= 75 && touchedScreen.y >= 430 && touchedScreen.y <= 470) {
					if (thisTile.warpLeaveToRightMap != -1) {
						playerData.currentMap = thisTile.warpLeaveToRightMap;
						playerTilePos = thisTile.warpLeaveToRight;
					} else
						if (playerTilePos.x + 1.0 < [tiles count]) {
							TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x + 1.0] objectAtIndex:playerTilePos.y];
							if (tileToGo.blocked == 0) {
								if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x += 1.0; } else {
									playerData.currentMap = tileToGo.warpWhenHitToMap;
									playerTilePos = tileToGo.warpWhenHitTo;
								}
							}
						}
				} 
				//LEFT BUTTON
				else if (touchedScreen.x >= 48 && touchedScreen.x <= 75 && touchedScreen.y >= 364 && touchedScreen.y <= 400) {
					if (thisTile.warpLeaveToLeftMap != -1) {
						playerData.currentMap = thisTile.warpLeaveToLeftMap;
						playerTilePos = thisTile.warpLeaveToLeft;
					} else
						if (playerTilePos.x - 1.0 > -1) {
							TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x - 1.0] objectAtIndex:playerTilePos.y];
							if (tileToGo.blocked==0) {
								if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x -= 1.0; } else {
									playerData.currentMap = tileToGo.warpWhenHitToMap;
									playerTilePos = tileToGo.warpWhenHitTo;
								}
							}
						}
				}
				//UP BUTTON
				else if (touchedScreen.x >= 75 && touchedScreen.x <= 110 && touchedScreen.y >= 400 && touchedScreen.y <= 430) {
					if (thisTile.warpLeaveToUpMap != -1) {
						playerData.currentMap = thisTile.warpLeaveToUpMap;
						playerTilePos = thisTile.warpLeaveToUp;
					} else
						if (playerTilePos.y - 1.0 > -1) {
							TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y - 1.0];
							if (tileToGo.blocked==0) {
								if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y -= 1.0; } else {
									playerData.currentMap = tileToGo.warpWhenHitToMap;
									playerTilePos = CGPointMake(tileToGo.warpWhenHitTo.x,tileToGo.warpWhenHitTo.y);
								}
							}
						}
				}
				//Down BUTTON
				else if (touchedScreen.x >= 10 && touchedScreen.x <= 50 && touchedScreen.y >= 405 && touchedScreen.y <= 430) {
					if (thisTile.warpLeaveToDownMap != -1) {
						playerData.currentMap = thisTile.warpLeaveToDownMap;
						playerTilePos = thisTile.warpLeaveToDown;
					} else
						if (playerTilePos.y + 1.0 < [[tiles objectAtIndex:playerTilePos.x] count]) {
							TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y + 1.0];
							if (tileToGo.blocked==0) {
								if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y += 1.0; } else {
									playerData.currentMap = tileToGo.warpWhenHitToMap;
									playerTilePos = tileToGo.warpWhenHitTo;
								}
							}
						}
				}
				//Toggle BUTTON
				else if (touchedScreen.x >= 140 && touchedScreen.x <= 180 && touchedScreen.y >= 365 && touchedScreen.y <= 462) {
					if (playerData.displayToggle == 1) {
						playerData.displayToggle = 0;} else
							if (playerData.displayToggle == 0)
							{playerData.displayToggle = 1;}
				}
				playerData.playerTilePos = playerTilePos;
				
			} else
				if (currentview == 2 || currentview == 3 || currentview == 4) {
					//Back to main menu button
					if (touchedScreen.x >= 20 && touchedScreen.x <= 145 && touchedScreen.y >= 435 && touchedScreen.y <= 456) {currentview = 0;} 
				}
		touchedScreen.x = -1;
		updateScreen =TRUE;
	}
	
	//Control all game elements
	currentMap = [maps objectAtIndex:playerData.currentMap - 1];
	tiles = currentMap.mapTiles;
	if (currentview == 1) { //Gameplay Screen
		//NPCs
		for (int i = 0; i < [currentMap.npcData count]; i +=1) {
			NpcData* npcToProcess = [currentMap.npcData objectAtIndex:i];
			//NPC Move Timer
			if (npcToProcess.moveTimer != npcToProcess.moveCount) {npcToProcess.moveTimer += 1;} else
				if (npcToProcess.moveTimer == npcToProcess.moveCount) {
					npcToProcess.moveTimer = 0;
					//**Run NPC targeting code
					if (npcToProcess.movStyle == 1) {//Target Player only
						if (npcToProcess.targetAttack == -1) {if (playerData.hp > 0) {npcToProcess.targetAttack = -2;}}
					}
					//**End NPC targeting code
					[self moveNpc:npcToProcess currentMapTiles:tiles movementStyle:npcToProcess.movStyle allNpcs:currentMap.npcData];
					updateScreen = TRUE;
				}
		}
	}
	else if (currentview == 0 || currentview == 2 || currentview == 3 || currentview == 4) {
	} else if (currentview == 5) { //Talking
	
	} 
	
	if (updateScreen) {[self setNeedsDisplay];}
} // handleTimer
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	//	UIAccelerationValue x, y, z;
	//	x = acceleration.x;
	//	y = acceleration.y;
	//	z = acceleration.z;
	
	// Do something with the values.
	//	xField.text = [NSString stringWithFormat:@"%.5f", x];
	//	yField.text = [NSString stringWithFormat:@"%.5f", y];
	//	zField.text = [NSString stringWithFormat:@"%.5f", z];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	
	if([touches count] > 1)
	{
		twoFingers = YES;
	}
	
	// tell the view to redraw
	//[self setNeedsDisplay];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	if([touches count] > 1)
	{
		twoFingers = YES;
	}
	if (twoFingers) {
	} else {
	}
	
	// tell the view to redraw
	//[self setNeedsDisplay];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	touchedScreen = location;
	// reset the var
	twoFingers = NO;
	// tell the view to redraw
	//[self setNeedsDisplay];
}
- (void) drawRect:(CGRect)rect{
	//DEFINE THE SCREEN'S DRAWING CONTEXT
	CGContextRef context;
	
	if (currentview == 1) {
		[self drawImage:context translateX:320 translateY:0 image:interfaceImageObj[currentview] point:CGPointMake(0, 0) rotation:90 * M_PI / 180];
	} else {
		[self drawImage:context translateX:0 translateY:0 image:interfaceImageObj[currentview] point:CGPointMake(0, 0) rotation:0];
	}
	//DRAW STRING -> [@"Hello" drawAtPoint:CGPointMake(0.0f, 0.0f) withFont:[UIFont fontWithName:@"Helvetica" size:12]];
	
	[self drawImage:context translateX:0 translateY:0 image:interfaceImageObj[currentview] point:CGPointMake(0, 0) rotation:90 * M_PI / 180];
	
	if (currentview == 0) { //Main Menu
	} else
		if (currentview == 1) { //Gameplay Screen
			MapData *currentmap = [maps objectAtIndex:playerData.currentMap - 1];
			[self drawImage:context translateX:320 translateY:0 image:currentmap.mapImageFile point:mapPos rotation:90 * M_PI / 180];
			
			//**Draw ALL NPCs
			NSMutableArray* npcs = currentmap.npcData;
			for(int i = 0; i < [npcs count]; i += 1) 
			{
				NpcData* currentNpc = [npcs objectAtIndex:i];
				CGPoint npcPosition = currentNpc.position;
				[self drawImage:context translateX:320 translateY:0 image:currentNpc.npcImageObj point:CGPointMake(npcPosition.x*45.0 + mapPos.x, npcPosition.y*45.0 + mapPos.y) rotation:90 * M_PI / 180];
			}
			
			[self drawImage:context translateX:320 translateY:0 image:[npcSprites objectAtIndex:playerData.sprite] point:CGPointMake(playerData.playerTilePos.x*45.0 + mapPos.x,playerData.playerTilePos.y*45.0 + mapPos.y) rotation:90 * M_PI / 180];
			//Draw Stats
			if (playerData.displayToggle == 0) {
				[self drawString:context translateX:320 translateY:0 text:@"Stats" point:CGPointMake(395,5) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:18]];
				[self drawString:context translateX:320 translateY:0 text:[NSString stringWithFormat:@"HP: %d/%d",playerData.hp,playerData.hpmax] point:CGPointMake(375,40) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
				[self drawString:context translateX:320 translateY:0 text:[NSString stringWithFormat:@"MP: %d/%d",playerData.mp,playerData.mpmax] point:CGPointMake(375,57) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
				[self drawString:context translateX:320 translateY:0 text:[NSString stringWithFormat:@"LVL: %d",playerData.lvl] point:CGPointMake(375,74) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
				[self drawString:context translateX:320 translateY:0 text:[NSString stringWithFormat:@"EXP: %d",playerData.exp] point:CGPointMake(375,91) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
				[self drawString:context translateX:320 translateY:0 text:[NSString stringWithFormat:@"Gold: %d",playerData.gold] point:CGPointMake(375,108) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
			} else if (playerData.displayToggle == 1) {
				[self drawString:context translateX:320 translateY:0 text:@"Inventory" point:CGPointMake(380,5) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:18]];
				[self drawString:context translateX:320 translateY:0 text:@"No Weapon" point:CGPointMake(375,40) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
				[self drawString:context translateX:320 translateY:0 text:@"No Armor" point:CGPointMake(375,57) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
				[self drawString:context translateX:320 translateY:0 text:@"No Trinket" point:CGPointMake(375,74) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
				[self drawString:context translateX:320 translateY:0 text:@"0 Potions" point:CGPointMake(375,108) rotation:90 * M_PI / 180 font:[UIFont fontWithName:@"Helvetica" size:14]];
			}
		} else
			if (currentview == 2) { //Instructions Screen
			} else
				if (currentview == 3) { //Options Screen
				} else
					if (currentview == 4) { //Credits Screen
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
- (NSString*)loadText:(NSString *)name type:(NSString*)fileType {
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:fileType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		NSString* txtFile = [[NSString alloc] initWithContentsOfFile:filePath];
		return txtFile;
	} else {
		return nil;
	}
}
- (void) drawImage:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY image:(UIImage*)sprite point:(CGPoint)point rotation:(float)rotation {
	//****INDIVIDUAL DRAW IMAGE PLAYER
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translateX, translateY);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation);
	//***DRAW THE IMAGE
	[sprite drawAtPoint:point];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
	//***END INDIVIDUAL DRAW IMAGE CODE
}
- (void) drawString:(CGContextRef)context translateX:(int)translateX translateY:(int)translateY text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(UIFont*)font {
	//****INDIVIDUAL DRAW IMAGE PLAYER
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translateX, translateY);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation);
	//Set the text color
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	//***DRAW THE Text
	[text drawAtPoint:point withFont:font];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
	//***END INDIVIDUAL DRAW IMAGE CODE
}
- (void) moveNpc:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles movementStyle:(int)movStyle allNpcs:(NSArray*)allNpcs {
	CGPoint npcTilePosition = npcToProcess.position;
	TileData* npcTile = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y];
	if (movStyle == 0) //RANDOM
	{
		int vertOrHorz = arc4random() % 2;
		int moveDirection = arc4random() % 2;
		if (moveDirection == 0) {moveDirection = -1;}
		if (vertOrHorz == 0) { //Vertical
			if (npcTilePosition.y + moveDirection >= 0 && npcTilePosition.y + moveDirection < [[tiles objectAtIndex:0] count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + moveDirection];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x || playerData.playerTilePos.y != npcTilePosition.y + moveDirection)) {
					npcTilePosition.y += moveDirection;
					npcTile.npcOn = 0;
					tileToGo.npcOn = 1;
				}
			}
		} else { //Horizontal
			if (npcTilePosition.x + moveDirection >= 0 && npcTilePosition.x + moveDirection < [tiles count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x + moveDirection] objectAtIndex:npcTilePosition.y];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x + moveDirection || playerData.playerTilePos.y != npcTilePosition.y)) {
					npcTilePosition.x += moveDirection;
					npcTile.npcOn = 0;
					tileToGo.npcOn = 1;
				}
			}
		}
	} else {//Move towards target
		CGPoint targetPosition;
		BOOL nextToTarget = NO;
		if (npcToProcess.targetAttack == -2) {
			targetPosition = playerData.playerTilePos;
		} else if (npcToProcess.targetAttack >= 0) {
			NpcData* targetNpc = [allNpcs objectAtIndex:npcToProcess.targetAttack];
			targetPosition = targetNpc.position;}
		int vertOrHorz = arc4random() % 2;
		int moveDirection = 0;
		BOOL npcMoved = YES;
		if (abs(npcTilePosition.x - targetPosition.x) <= 1 && abs(npcTilePosition.y - targetPosition.y) <= 1 && !(abs(npcTilePosition.x - targetPosition.x) == 1 && abs(npcTilePosition.y - targetPosition.y) == 1)) {
			vertOrHorz = 2;
			nextToTarget = YES;
		} else
			if (npcTilePosition.x == targetPosition.x) {vertOrHorz = 0;} else
				if (npcTilePosition.y == targetPosition.y) {vertOrHorz = 1;}
		if (vertOrHorz == 0) { //Vertical
			if (npcTilePosition.y < targetPosition.y) {moveDirection = 1;} else {moveDirection = -1;}
			if (npcTilePosition.y + moveDirection >= 0 && npcTilePosition.y + moveDirection < [[tiles objectAtIndex:0] count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + moveDirection];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0   && (playerData.playerTilePos.x != npcTilePosition.x || playerData.playerTilePos.y != npcTilePosition.y + moveDirection)) {
					npcTilePosition.y += moveDirection;
					npcTile.npcOn = 0;
					tileToGo.npcOn = 1;
				} else {npcMoved = NO; vertOrHorz = 1;}
			}
		} else if (vertOrHorz == 1) { //Horizontal
			if (npcTilePosition.x < targetPosition.x) {moveDirection = 1;} else {moveDirection = -1;}
			if (npcTilePosition.x + moveDirection >= 0 && npcTilePosition.x + moveDirection < [tiles count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x + moveDirection] objectAtIndex:npcTilePosition.y];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0  && (playerData.playerTilePos.x != npcTilePosition.x + moveDirection || playerData.playerTilePos.y != npcTilePosition.y)) {
					npcTilePosition.x += moveDirection;
					npcTile.npcOn = 0;
					tileToGo.npcOn = 1;
				} else {npcMoved = NO; vertOrHorz = 0;}
			}
		}
		if (npcMoved == NO) {//Move randomly cause can't move
			moveDirection = arc4random() % 2;
			if (moveDirection == 0) {moveDirection = -1;}
			if (vertOrHorz == 0) { //Vertical
				if (npcTilePosition.y + moveDirection >= 0 && npcTilePosition.y + moveDirection < [[tiles objectAtIndex:0] count]) {
					TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + moveDirection];
					if (tileToGo.npcOn==0 && tileToGo.blocked==0  && (playerData.playerTilePos.x != npcTilePosition.x || playerData.playerTilePos.y != npcTilePosition.y + moveDirection)) {
						npcTilePosition.y += moveDirection;
						npcTile.npcOn = 0;
						tileToGo.npcOn = 1;
					}
				}
			} else { //Horizontal
				if (npcTilePosition.x + moveDirection >= 0 && npcTilePosition.x + moveDirection < [tiles count]) {
					TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x + moveDirection] objectAtIndex:npcTilePosition.y];
					if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x + moveDirection || playerData.playerTilePos.y != npcTilePosition.y)) {
						npcTilePosition.x += moveDirection;
						npcTile.npcOn = 0;
						tileToGo.npcOn = 1;
					}
				}
			}
		}
		if (nextToTarget) {
			if (movStyle == 1) {//INITIATE BATTLE SEQUENCE!! ATTACK! ATTACK!
				[self npcAttack:npcToProcess currentMapTiles:tiles allNpcs:allNpcs];
			}
		}
	}
	npcToProcess.position = npcTilePosition;
}
- (void) npcAttack:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs {
	if (npcToProcess.targetAttack == -2) {
		playerData.hp -= 1;
		if (playerData.hp <= 0) {npcToProcess.targetAttack = -1;}
	} else if (npcToProcess.targetAttack >= 0) {
		NpcData* targetNpc = [allNpcs objectAtIndex:npcToProcess.targetAttack];
		/**targetNpc.hp -= 1;
		if (targetNpc.hp <= 0) {npcToProcess.targetAttack = -1;} **/
	}
}
- (void) dealloc {
	[maps release];
	[gameTimer release];
	[super dealloc];
}
@end

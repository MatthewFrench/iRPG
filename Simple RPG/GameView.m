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
	selectedGame = 1;
	spellEffects = [NSMutableArray new];
	battleGfx = [NSMutableArray new];
	
	
	//Load all the battle Gfx
	NSMutableArray* lightningAnim = [NSMutableArray new];
	for (int i = 1; i > 0; i += 1) {
		UIImage* lightningImage = [self loadImage:[NSString stringWithFormat:@"Lightning %d",i] type:@"png"];
		if (lightningImage != nil) {
			[lightningAnim addObject:lightningImage];
			[lightningImage release];
		} else {
			i= -2;
		}
	}
	[battleGfx addObject:lightningAnim];
	[lightningAnim release];
	//End load all battle Gfx
	
	//Load all character Sprites
	npcSprites = [NSMutableArray new];
	for (int e = 0;e > -1;e += 1) {
		UIImage* npcSpriteFile = [self loadImage:[NSString stringWithFormat:@"Npc %d",e] type:@"png"];
		if (npcSpriteFile != nil) {
			[npcSprites addObject:npcSpriteFile];
			[npcSpriteFile release];
		} else {
			e= -2;
		}
	}
	//End load all character Sprites
	
	//Load all item Sprites
	itemSprites = [NSMutableArray new];
	for (int e = 0;e > -1;e += 1) {
		UIImage* itemSpritesFile = [self loadImage:[NSString stringWithFormat:@"Item %d",e] type:@"png"];
		if (itemSpritesFile != nil) {
			[itemSprites addObject:itemSpritesFile];
			[itemSpritesFile release];
		} else {
			e= -2;
		}
	}
	//End load all item Sprites
	
	//Load all map Images
	mapImages = [NSMutableArray new];
	for (int e = 0;e > -1;e += 1) {
		UIImage* mapImagesFile = [self loadImage:[NSString stringWithFormat:@"Map %d",e] type:@"png"];
		if (mapImagesFile != nil) {
			[mapImages addObject:mapImagesFile];
			[mapImagesFile release];
		} else {
			e= -2;
		}
	}
	//End load all map Images
	
	//***LOAD Interface IMAGE TO DRAW	
	interfaceImageObj[0] = [self loadImage:@"mainmenu" type:@"png"];
	interfaceImageObj[1] = [self loadImage:@"background" type:@"png"];
	interfaceImageObj[2] = [self loadImage:@"instructions" type:@"png"];
	interfaceImageObj[3] = [self loadImage:@"options" type:@"png"];
	interfaceImageObj[4] = [self loadImage:@"credits" type:@"png"];
	interfaceImageObj[5] = [self loadImage:@"savemenu" type:@"png"];
	interfaceImageObj[6] = [self loadImage:@"charactermenu" type:@"png"];
	
	eventImages = [NSMutableArray new];
	for(int i = 0; i > -1; i += 1) {
		UIImage* eventImage = [self loadImage:[NSString stringWithFormat:@"event %d",i] type:@"png"];
		if (eventImage != nil) {
			[eventImages addObject:eventImage];
			[eventImage release];
		} else {
			i= -2;
		}
	}
	//***END LOAD IMAGE
	
	//***LOAD Player TO DRAW
	mapPos = CGPointMake(0, 3);
	//***END LOAD IMAGE
	
	// You have to explicity turn on multitouch for the view
	//self.multipleTouchEnabled = YES;
	
	// configure for accelerometer
	//[self configureAccelerometer];
	
	//***Turn on Game Timer
	gameTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
												 target: self
											   selector: @selector(handleGameTimer:)
											   userInfo: nil
												repeats: YES];
}
- (void) handleGameTimer: (NSTimer *) gameTimer {
	BOOL updateScreen = FALSE;	MapData *currentMap = [maps objectAtIndex:playerData.currentMap];
	NSArray *tiles = currentMap.mapTiles;
	NSMutableArray* mapItems = currentMap.items;
	
	//Control touch input for player
	/**if (touchedScreen.x != -1) {
		if (currentview == 0) {  //Main Menu
			//Play Button
			if (touchedScreen.x >= 193 && touchedScreen.x <= 290 && touchedScreen.y >= 66 && touchedScreen.y <= 105) {
				//Load games
				game1 = [self openFileInDocs:@"game1.txt"];
				game2 = [self openFileInDocs:@"game2.txt"];
				game3 = [self openFileInDocs:@"game3.txt"];
				//Switch to save screen
				currentview = 5;
			} //Savescreen = 5, gameplay screen = 1 Let's go to save screen first
			//Instructions Button
			if (touchedScreen.x >= 130 && touchedScreen.x <= 335 && touchedScreen.y >= 110 && touchedScreen.y <= 145) {currentview = 2;}
			//Options Button
			if (touchedScreen.x >= 170 && touchedScreen.x <= 295 && touchedScreen.y >= 150 && touchedScreen.y <= 190) {currentview = 3;}
			//Credits Button
			if (touchedScreen.x >= 175 && touchedScreen.x <= 290 && touchedScreen.y >= 191 && touchedScreen.y <= 225) {currentview = 4;}
			//To GMG Button
			//if (touchedScreen.x >= 5 && touchedScreen.x <= 130 && touchedScreen.y >= 335 && touchedScreen.y <= 290) {[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gamemakersgarage.com"]];}
		} 
		else if (currentview == 1 && eventOn == -1) {  //Gameplay Screen
			CGPoint playerTilePos = playerData.playerTilePos;
			TileData *thisTile = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y];
			//Arrow Pad Buttons
			//RIGHT BUTTON
			if (touchedScreen.x >= 428 && touchedScreen.x <= 466 && touchedScreen.y >= 244 && touchedScreen.y <= 270) {
				if (thisTile.warpLeaveToRightMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToRightMap;
					playerTilePos = thisTile.warpLeaveToRight;
				} else
					if (playerTilePos.x + 1.0 < [tiles count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x + 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked == 0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x + 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			} 
			//LEFT BUTTON
			else if (touchedScreen.x >= 360 && touchedScreen.x <= 403 && touchedScreen.y >= 244 && touchedScreen.y <= 270) {
				if (thisTile.warpLeaveToLeftMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToLeftMap;
					playerTilePos = thisTile.warpLeaveToLeft;
				} else
					if (playerTilePos.x - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x - 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x - 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//UP BUTTON
			else if (touchedScreen.x >= 401 && touchedScreen.x <= 429 && touchedScreen.y >= 203 && touchedScreen.y <= 243) {
				if (thisTile.warpLeaveToUpMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToUpMap;
					playerTilePos = thisTile.warpLeaveToUp;
				} else
					if (playerTilePos.y - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y - 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = CGPointMake(tileToGo.warpWhenHitTo.x,tileToGo.warpWhenHitTo.y);
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y - 1.0) {
									
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Down BUTTON
			else if (touchedScreen.x >= 401 && touchedScreen.x <= 428 && touchedScreen.y >= 273 && touchedScreen.y <= 308) {
				if (thisTile.warpLeaveToDownMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToDownMap;
					playerTilePos = thisTile.warpLeaveToDown;
				} else
					if (playerTilePos.y + 1.0 < [[tiles objectAtIndex:playerTilePos.x] count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y + 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y + 1.0) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Toggle BUTTON
			else if (touchedScreen.x >= 364 && touchedScreen.x <= 464 && touchedScreen.y >= 139 && touchedScreen.y <= 180) {
				playerData.displayToggle += 1;
				if ([playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 2) {
					playerData.displayToggle = 0;
				} else if (![playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 1) {playerData.displayToggle = 0;}
			}
			//Detect wether player is stepping upon item
			if (!(playerData.playerTilePos.x == playerTilePos.x && playerData.playerTilePos.y == playerTilePos.y)) {
				if ([mapItems count]>0) {
					for (int i = 0; i <= [mapItems count]-1; i += 1) {
						Item* currentItem = [mapItems objectAtIndex:i];
						if (playerTilePos.x == currentItem.position.x && playerTilePos.y == currentItem.position.y) {
							[self itemEvents:currentItem itemNum:i event:0]; //stepped on item
						}
					}
				}
			}
			playerData.playerTilePos = playerTilePos;
			
			//Detect if touching game area to cast spell
			if (touchedScreen.x >= 0 && touchedScreen.x <= mapPos.x + 360 && touchedScreen.y >= 0 && touchedScreen.y <= mapPos.y + 315) {
				SpellEffect* newSpell = [[SpellEffect alloc] init];
				newSpell.type = 1;
				newSpell.position1 = CGPointMake(playerTilePos.x * 45 + mapPos.x + 20,playerTilePos.y * 45 + mapPos.y + 20);
				newSpell.position2 = touchedScreen;
				newSpell.rotation = atan2(newSpell.position2.y - newSpell.position1.y,newSpell.position2.x - newSpell.position1.x) / M_PI * 180;
				float width = sqrt(pow(newSpell.position2.x-newSpell.position1.x,2) + pow(newSpell.position2.y-newSpell.position1.y,2));
				
				for (int i = 0; i < [[battleGfx objectAtIndex:0] count]; i += 1) {
					[newSpell.spellAnim addObject:[self imageByCropping:[[battleGfx objectAtIndex:0] objectAtIndex:i] toRect:CGRectMake(0, 0, width, 36)]];
				}
				[spellEffects addObject:newSpell];
			}
			
		} else
			if (currentview == 2 || currentview == 3 || currentview == 4) {
				//Back to main menu button
				if (touchedScreen.x >= 20 && touchedScreen.x <= 145 && touchedScreen.y >= 435 && touchedScreen.y <= 456) {currentview = 0;} 
			} else
				if (currentview == 1 && eventOn > -1) {
					//***TOUCHED SOMETHING IN THE EVENT/TALK SCREEN, DO SOMETHING!
					NSLog(@"Touched someting with event happening");
					if (eventOn == 1) { //Item window, detect if pick up item
						NSLog(@"Event is item with x:%f and y:%f", touchedScreen.x, touchedScreen.y);
						if (touchedScreen.x > 56 && touchedScreen.x < 287 && touchedScreen.y > 226 && touchedScreen.y < 280 ) {
							//Pick up item
							NSLog(@"Touched within button to pick up");
							[self itemEvents:eventItem itemNum:eventItemNum event:1]; //Event 1 means pick up item
						}
					}
					eventOn = -1; //Let us close the event window
					eventItem = nil;
					eventItemNum = -1;
				} else
					if (currentview == 5) {
						//Deletebutton
						if (touchedScreen.x > 280 && touchedScreen.x < 360 && touchedScreen.y > 90 && touchedScreen.y < 130 ) {
							[self deleteFileInDocs:@"game1.txt"]; game1 = nil;
						}
						if (touchedScreen.x > 280 && touchedScreen.x < 360 && touchedScreen.y > 160 && touchedScreen.y < 200 ) {
							[self deleteFileInDocs:@"game2.txt"]; game2 = nil;
						}
						if (touchedScreen.x > 280 && touchedScreen.x < 360 && touchedScreen.y > 230 && touchedScreen.y < 270 ) {
							[self deleteFileInDocs:@"game3.txt"]; game3 = nil;
						}
						//Playbuton
						if (touchedScreen.x > 380 && touchedScreen.x < 460 && touchedScreen.y > 90 && touchedScreen.y < 130 ) {
							selectedGame = 1;
							[self loadGame];
						}
						if (touchedScreen.x > 380 && touchedScreen.x < 460 && touchedScreen.y > 160 && touchedScreen.y < 200 ) {
							selectedGame = 2;
							[self loadGame];
						}
						if (touchedScreen.x > 380 && touchedScreen.x < 460 && touchedScreen.y > 230 && touchedScreen.y < 270 ) {
							selectedGame = 3;
							[self loadGame];
						}
					} else
						if (currentview == 6) {
							if (textField.text != @"" && !textField.editing) {
								if (touchedScreen.x > 40 && touchedScreen.x < 160 && touchedScreen.y > 80 && touchedScreen.y < 300 ) { //Warrior
									currentview = 1;
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
								if (touchedScreen.x > 180 && touchedScreen.x < 300 && touchedScreen.y > 80 && touchedScreen.y < 300 ) {//Marksman
									currentview = 1;
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
								if (touchedScreen.x > 320 && touchedScreen.x < 440 && touchedScreen.y > 80 && touchedScreen.y < 300 ) {//Sorcerer
									currentview = 1;
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
						}
		if (textField != nil) {[textField resignFirstResponder]; }
		touchedScreen.x = -1;
		updateScreen =TRUE;
	} **/
	
	if (touchedScreenBegan1.x != -1) {
		NSLog(@"Touch 1 Began");
		if (currentview == 1 && eventOn == -1) {  //Gameplay Screen
			CGPoint playerTilePos = playerData.playerTilePos;
			TileData *thisTile = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y];
			//Arrow Pad Buttons
			//RIGHT BUTTON
			if (touchedScreenBegan1.x >= 428 && touchedScreenBegan1.x <= 466 && touchedScreenBegan1.y >= 244 && touchedScreenBegan1.y <= 270) {
				if (thisTile.warpLeaveToRightMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToRightMap;
					playerTilePos = thisTile.warpLeaveToRight;
				} else
					if (playerTilePos.x + 1.0 < [tiles count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x + 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked == 0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x + 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			} 
			//LEFT BUTTON
			else if (touchedScreenBegan1.x >= 360 && touchedScreenBegan1.x <= 403 && touchedScreenBegan1.y >= 244 && touchedScreenBegan1.y <= 270) {
				if (thisTile.warpLeaveToLeftMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToLeftMap;
					playerTilePos = thisTile.warpLeaveToLeft;
				} else
					if (playerTilePos.x - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x - 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x - 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//UP BUTTON
			else if (touchedScreenBegan1.x >= 401 && touchedScreenBegan1.x <= 429 && touchedScreenBegan1.y >= 203 && touchedScreenBegan1.y <= 243) {
				if (thisTile.warpLeaveToUpMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToUpMap;
					playerTilePos = thisTile.warpLeaveToUp;
				} else
					if (playerTilePos.y - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y - 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = CGPointMake(tileToGo.warpWhenHitTo.x,tileToGo.warpWhenHitTo.y);
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y - 1.0) {
									
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Down BUTTON
			else if (touchedScreenBegan1.x >= 401 && touchedScreenBegan1.x <= 428 && touchedScreenBegan1.y >= 273 && touchedScreenBegan1.y <= 308) {
				if (thisTile.warpLeaveToDownMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToDownMap;
					playerTilePos = thisTile.warpLeaveToDown;
				} else
					if (playerTilePos.y + 1.0 < [[tiles objectAtIndex:playerTilePos.x] count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y + 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y + 1.0) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Toggle BUTTON
			else if (touchedScreenBegan1.x >= 364 && touchedScreenBegan1.x <= 464 && touchedScreenBegan1.y >= 139 && touchedScreenBegan1.y <= 180) {
				playerData.displayToggle += 1;
				if ([playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 2) {
					playerData.displayToggle = 0;
				} else if (![playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 1) {playerData.displayToggle = 0;}
			}
			//Detect wether player is stepping upon item
			if (!(playerData.playerTilePos.x == playerTilePos.x && playerData.playerTilePos.y == playerTilePos.y)) {
				if ([mapItems count]>0) {
					for (int i = 0; i <= [mapItems count]-1; i += 1) {
						Item* currentItem = [mapItems objectAtIndex:i];
						if (playerTilePos.x == currentItem.position.x && playerTilePos.y == currentItem.position.y) {
							[self itemEvents:currentItem itemNum:i event:0]; //stepped on item
						}
					}
				}
			}
			playerData.playerTilePos = playerTilePos;
			
			//Detect if touching game area to cast spell
			if (touchedScreenBegan1.x >= 0 && touchedScreenBegan1.x <= mapPos.x + 360 && touchedScreenBegan1.y >= 0 && touchedScreenBegan1.y <= mapPos.y + 315) {
				SpellEffect* newSpell = [[SpellEffect alloc] init];
				newSpell.spellType = 1;
				newSpell.touchNum = 1;
				newSpell.position1 = CGPointMake(playerTilePos.x * 45 + mapPos.x + 20,playerTilePos.y * 45 + mapPos.y + 20);
				newSpell.position2 = touchedScreenBegan1;
				newSpell.rotation = atan2(newSpell.position2.y - newSpell.position1.y,newSpell.position2.x - newSpell.position1.x) / M_PI * 180;
				float width = sqrt(pow(newSpell.position2.x-newSpell.position1.x,2) + pow(newSpell.position2.y-newSpell.position1.y,2));
				
				for (int i = 0; i < [[battleGfx objectAtIndex:0] count]; i += 1) {
					[newSpell.spellAnim addObject:[self imageByCropping:[[battleGfx objectAtIndex:0] objectAtIndex:i] toRect:CGRectMake(0, 0, width, 36)]];
				}
				[spellEffects addObject:newSpell];
			}
			
		}
		touchedScreenBegan1.x = -1;
		updateScreen =TRUE;
	}
	if (touchedScreenMoved1.x != -1) {
		NSLog(@"Touch 1 Moved");
		
		//Move Spell
		if (touchedScreenMoved1.x >= 0 && touchedScreenMoved1.x <= mapPos.x + 360 && touchedScreenMoved1.y >= 0 && touchedScreenMoved1.y <= mapPos.y + 315) {
			
			for (int i = 0; i < [spellEffects count]; i += 1) {
				SpellEffect* spell = [spellEffects objectAtIndex:i];
				if (spell.touchNum == 1 && spell.spellType == 1) {
					[spell.spellAnim removeAllObjects];
					
					spell.position2 = touchedScreenMoved1;
					spell.rotation = atan2(spell.position2.y - spell.position1.y,spell.position2.x - spell.position1.x) / M_PI * 180;
					float width = sqrt(pow(spell.position2.x-spell.position1.x,2) + pow(spell.position2.y-spell.position1.y,2));
					
					for (int i = 0; i < [[battleGfx objectAtIndex:0] count]; i += 1) {
						[spell.spellAnim addObject:[self imageByCropping:[[battleGfx objectAtIndex:0] objectAtIndex:i] toRect:CGRectMake(0, 0, width, 36)]];
					}
					
					i = [spellEffects count];
				}
			}
		}
		
		touchedScreenMoved1.x = -1;
	}
	if (touchedScreenEnded1.x != -1) {
		NSLog(@"Touch 1 Ended");
		if (currentview == 0) {  //Main Menu
			//Play Button
			if (touchedScreenEnded1.x >= 193 && touchedScreenEnded1.x <= 290 && touchedScreenEnded1.y >= 66 && touchedScreenEnded1.y <= 105) {
				//Load games
				game1 = [self openFileInDocs:@"game1.txt"];
				game2 = [self openFileInDocs:@"game2.txt"];
				game3 = [self openFileInDocs:@"game3.txt"];
				//Switch to save screen
				currentview = 5;
			} //Savescreen = 5, gameplay screen = 1 Let's go to save screen first
			//Instructions Button
			if (touchedScreenEnded1.x >= 130 && touchedScreenEnded1.x <= 335 && touchedScreenEnded1.y >= 110 && touchedScreenEnded1.y <= 145) {currentview = 2;}
			//Options Button
			if (touchedScreenEnded1.x >= 170 && touchedScreenEnded1.x <= 295 && touchedScreenEnded1.y >= 150 && touchedScreenEnded1.y <= 190) {currentview = 3;}
			//Credits Button
			if (touchedScreenEnded1.x >= 175 && touchedScreenEnded1.x <= 290 && touchedScreenEnded1.y >= 191 && touchedScreenEnded1.y <= 225) {currentview = 4;}
			//To GMG Button
			//if (touchedScreenEnded1.x >= 5 && touchedScreenEnded1.x <= 130 && touchedScreenEnded1.y >= 335 && touchedScreenEnded1.y <= 290) {[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gamemakersgarage.com"]];}
		} else
		if (currentview == 2 || currentview == 3 || currentview == 4) {
				//Back to main menu button
				if (touchedScreenEnded1.x >= 20 && touchedScreenEnded1.x <= 145 && touchedScreenEnded1.y >= 435 && touchedScreenEnded1.y <= 456) {currentview = 0;} 
			} else
		if (currentview == 1 && eventOn > -1) {
					//***TOUCHED SOMETHING IN THE EVENT/TALK SCREEN, DO SOMETHING!
					NSLog(@"Touched someting with event happening");
					if (eventOn == 1) { //Item window, detect if pick up item
						NSLog(@"Event is item with x:%f and y:%f", touchedScreenEnded1.x, touchedScreenEnded1.y);
						if (touchedScreenEnded1.x > 56 && touchedScreenEnded1.x < 287 && touchedScreenEnded1.y > 226 && touchedScreenEnded1.y < 280 ) {
							//Pick up item
							NSLog(@"Touched within button to pick up");
							[self itemEvents:eventItem itemNum:eventItemNum event:1]; //Event 1 means pick up item
						}
					}
					eventOn = -1; //Let us close the event window
					eventItem = nil;
					eventItemNum = -1;
				} else
		if (currentview == 5) {
						//Deletebutton
						if (touchedScreenEnded1.x > 280 && touchedScreenEnded1.x < 360 && touchedScreenEnded1.y > 90 && touchedScreenEnded1.y < 130 ) {
							[self deleteFileInDocs:@"game1.txt"]; game1 = nil;
						}
						if (touchedScreenEnded1.x > 280 && touchedScreenEnded1.x < 360 && touchedScreenEnded1.y > 160 && touchedScreenEnded1.y < 200 ) {
							[self deleteFileInDocs:@"game2.txt"]; game2 = nil;
						}
						if (touchedScreenEnded1.x > 280 && touchedScreenEnded1.x < 360 && touchedScreenEnded1.y > 230 && touchedScreenEnded1.y < 270 ) {
							[self deleteFileInDocs:@"game3.txt"]; game3 = nil;
						}
						//Playbuton
						if (touchedScreenEnded1.x > 380 && touchedScreenEnded1.x < 460 && touchedScreenEnded1.y > 90 && touchedScreenEnded1.y < 130 ) {
							selectedGame = 1;
							[self loadGame];
						}
						if (touchedScreenEnded1.x > 380 && touchedScreenEnded1.x < 460 && touchedScreenEnded1.y > 160 && touchedScreenEnded1.y < 200 ) {
							selectedGame = 2;
							[self loadGame];
						}
						if (touchedScreenEnded1.x > 380 && touchedScreenEnded1.x < 460 && touchedScreenEnded1.y > 230 && touchedScreenEnded1.y < 270 ) {
							selectedGame = 3;
							[self loadGame];
						}
					} else
		if (currentview == 6) {
							if (textField.text != @"" && !textField.editing) {
								if (touchedScreenEnded1.x > 40 && touchedScreenEnded1.x < 160 && touchedScreenEnded1.y > 80 && touchedScreenEnded1.y < 300 ) { //Warrior
									currentview = 1;
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
								if (touchedScreenEnded1.x > 180 && touchedScreenEnded1.x < 300 && touchedScreenEnded1.y > 80 && touchedScreenEnded1.y < 300 ) {//Marksman
									currentview = 1;
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
								if (touchedScreenEnded1.x > 320 && touchedScreenEnded1.x < 440 && touchedScreenEnded1.y > 80 && touchedScreenEnded1.y < 300 ) {//Sorcerer
									currentview = 1;
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
						} else 
		if (currentview == 1 && eventOn == -1) {  //Gameplay Screen
			//Detect if end spell
			//if (touchedScreenEnded1.x >= 0 && touchedScreenEnded1.x <= mapPos.x + 360 && touchedScreenEnded1.y >= 0 && touchedScreenEnded1.y <= mapPos.y + 315) {
				for (int i = 0; i < [spellEffects count]; i += 1) {
					SpellEffect* spell = [spellEffects objectAtIndex:i];
					if (spell.touchNum == 1 && spell.spellType == 1) {
						[spellEffects removeObjectAtIndex:i];
						i = [spellEffects count];
					}
				}
			//}
								
		}

		if (textField != nil) {[textField resignFirstResponder]; }
		touchedScreenEnded1.x = -1;
		updateScreen =TRUE;
	}
	
	if (touchedScreenBegan2.x != -1) {
		NSLog(@"Touch 2 Begin");
		if (currentview == 1 && eventOn == -1) {  //Gameplay Screen
			CGPoint playerTilePos = playerData.playerTilePos;
			TileData *thisTile = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y];
			//Arrow Pad Buttons
			//RIGHT BUTTON
			if (touchedScreenBegan2.x >= 428 && touchedScreenBegan2.x <= 466 && touchedScreenBegan2.y >= 244 && touchedScreenBegan2.y <= 270) {
				if (thisTile.warpLeaveToRightMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToRightMap;
					playerTilePos = thisTile.warpLeaveToRight;
				} else
					if (playerTilePos.x + 1.0 < [tiles count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x + 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked == 0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x + 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			} 
			//LEFT BUTTON
			else if (touchedScreenBegan2.x >= 360 && touchedScreenBegan2.x <= 403 && touchedScreenBegan2.y >= 244 && touchedScreenBegan2.y <= 270) {
				if (thisTile.warpLeaveToLeftMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToLeftMap;
					playerTilePos = thisTile.warpLeaveToLeft;
				} else
					if (playerTilePos.x - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x - 1.0] objectAtIndex:playerTilePos.y];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.x -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x - 1.0 && npcPos.y == playerTilePos.y) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//UP BUTTON
			else if (touchedScreenBegan2.x >= 401 && touchedScreenBegan2.x <= 429 && touchedScreenBegan2.y >= 203 && touchedScreenBegan2.y <= 243) {
				if (thisTile.warpLeaveToUpMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToUpMap;
					playerTilePos = thisTile.warpLeaveToUp;
				} else
					if (playerTilePos.y - 1.0 > -1) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y - 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y -= 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = CGPointMake(tileToGo.warpWhenHitTo.x,tileToGo.warpWhenHitTo.y);
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y - 1.0) {
									
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Down BUTTON
			else if (touchedScreenBegan2.x >= 401 && touchedScreenBegan2.x <= 428 && touchedScreenBegan2.y >= 273 && touchedScreenBegan2.y <= 308) {
				if (thisTile.warpLeaveToDownMap != -1) {
					playerData.currentMap = thisTile.warpLeaveToDownMap;
					playerTilePos = thisTile.warpLeaveToDown;
				} else
					if (playerTilePos.y + 1.0 < [[tiles objectAtIndex:playerTilePos.x] count]) {
						TileData *tileToGo = [[tiles objectAtIndex:playerTilePos.x] objectAtIndex:playerTilePos.y + 1.0];
						if (tileToGo.blocked==0 && tileToGo.npcOn == 0) {
							if (tileToGo.warpWhenHitToMap == -1) {playerTilePos.y += 1.0; } else {
								playerData.currentMap = tileToGo.warpWhenHitToMap;
								playerTilePos = tileToGo.warpWhenHitTo;
							}
						} else if (tileToGo.npcOn == 1) {
							//Find NPC
							for (int i = 0; i <= [currentMap.npcData count]-1; i+=1) {
								NpcData* npcCollided = [currentMap.npcData objectAtIndex:i];
								CGPoint npcPos = npcCollided.position;
								if (npcPos.x == playerTilePos.x && npcPos.y == playerTilePos.y + 1.0) {
									[self playerCollision:npcCollided];
								}
							}
						}
					}
			}
			//Toggle BUTTON
			else if (touchedScreenBegan2.x >= 364 && touchedScreenBegan2.x <= 464 && touchedScreenBegan2.y >= 139 && touchedScreenBegan2.y <= 180) {
				playerData.displayToggle += 1;
				if ([playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 2) {
					playerData.displayToggle = 0;
				} else if (![playerData.playerClass isEqual:@"Sorcerer"] && playerData.displayToggle > 1) {playerData.displayToggle = 0;}
			}
			//Detect wether player is stepping upon item
			if (!(playerData.playerTilePos.x == playerTilePos.x && playerData.playerTilePos.y == playerTilePos.y)) {
				if ([mapItems count]>0) {
					for (int i = 0; i <= [mapItems count]-1; i += 1) {
						Item* currentItem = [mapItems objectAtIndex:i];
						if (playerTilePos.x == currentItem.position.x && playerTilePos.y == currentItem.position.y) {
							[self itemEvents:currentItem itemNum:i event:0]; //stepped on item
						}
					}
				}
			}
			playerData.playerTilePos = playerTilePos;
			
			//Detect if touching game area to cast spell
			if (touchedScreenBegan2.x >= 0 && touchedScreenBegan2.x <= mapPos.x + 360 && touchedScreenBegan2.y >= 0 && touchedScreenBegan2.y <= mapPos.y + 315) {
				SpellEffect* newSpell = [[SpellEffect alloc] init];
				newSpell.spellType = 1;
				newSpell.touchNum = 2;
				newSpell.position1 = CGPointMake(playerTilePos.x * 45 + mapPos.x + 20,playerTilePos.y * 45 + mapPos.y + 20);
				newSpell.position2 = touchedScreenBegan2;
				newSpell.rotation = atan2(newSpell.position2.y - newSpell.position1.y,newSpell.position2.x - newSpell.position1.x) / M_PI * 180;
				float width = sqrt(pow(newSpell.position2.x-newSpell.position1.x,2) + pow(newSpell.position2.y-newSpell.position1.y,2));
				
				for (int i = 0; i < [[battleGfx objectAtIndex:0] count]; i += 1) {
					[newSpell.spellAnim addObject:[self imageByCropping:[[battleGfx objectAtIndex:0] objectAtIndex:i] toRect:CGRectMake(0, 0, width, 36)]];
				}
				[spellEffects addObject:newSpell];
			}
			
		}
		touchedScreenBegan2.x = -1;
		updateScreen =TRUE;
	}
	if (touchedScreenMoved2.x != -1) {
		NSLog(@"Touch 2 Moved");
		
		//Move Spell
		if (touchedScreenMoved2.x >= 0 && touchedScreenMoved2.x <= mapPos.x + 360 && touchedScreenMoved2.y >= 0 && touchedScreenMoved2.y <= mapPos.y + 315) {
			
			for (int i = 0; i < [spellEffects count]; i += 1) {
				SpellEffect* spell = [spellEffects objectAtIndex:i];
				if (spell.touchNum == 2 && spell.spellType == 1) {
					[spell.spellAnim removeAllObjects];
					
					spell.position2 = touchedScreenMoved2;
					spell.rotation = atan2(spell.position2.y - spell.position1.y,spell.position2.x - spell.position1.x) / M_PI * 180;
					float width = sqrt(pow(spell.position2.x-spell.position1.x,2) + pow(spell.position2.y-spell.position1.y,2));
					
					for (int i = 0; i < [[battleGfx objectAtIndex:0] count]; i += 1) {
						[spell.spellAnim addObject:[self imageByCropping:[[battleGfx objectAtIndex:0] objectAtIndex:i] toRect:CGRectMake(0, 0, width, 36)]];
					}
					
					i = [spellEffects count];
				}
			}
		}
		
		touchedScreenMoved2.x = -1;
	}
	if (touchedScreenEnded2.x != -1) {
		NSLog(@"Touch 2 Ended");
		if (currentview == 1 && eventOn == -1) {  //Gameplay Screen
			//Detect if end spell
			//if (touchedScreenEnded2.x >= 0 && touchedScreenEnded2.x <= mapPos.x + 360 && touchedScreenEnded2.y >= 0 && touchedScreenEnded2.y <= mapPos.y + 315) {
				for (int i = 0; i < [spellEffects count]; i += 1) {
					SpellEffect* spell = [spellEffects objectAtIndex:i];
					if (spell.touchNum == 2 && spell.spellType == 1) {
						[spellEffects removeObjectAtIndex:i];
						i = [spellEffects count];
					}
				}
			//}
			
		}
		touchedScreenEnded2.x = -1;
	}
	 
	
	//Control all game elements
	currentMap = [maps objectAtIndex:playerData.currentMap];
	tiles = currentMap.mapTiles;
	if (currentview == 1 && eventOn == -1) { //Gameplay Screen
		//NPCs
		for (int i = 0; i < [currentMap.npcData count]; i +=1) {
			NpcData* npcToProcess = [currentMap.npcData objectAtIndex:i];
			//NPC Move Timer
			if (npcToProcess.moveTimer != npcToProcess.moveCount) {npcToProcess.moveTimer += 1;} else
				if (npcToProcess.moveTimer == npcToProcess.moveCount) {
					npcToProcess.moveTimer = 0;
					//**Run NPC targeting code
					if (npcToProcess.movStyle == 1) {//Target/Follow Object
						if (npcToProcess.target == -1) {
							//Target player to move towards
							if (playerData.hp > 0) {npcToProcess.target = -2;}
						}
					} else if (npcToProcess.movStyle == 2) {
						if (npcToProcess.target == -1) {
							int randomnum = arc4random() % 2;
							if (randomnum == 0) {
								//Target player to move towards
								if (playerData.hp > 0) {npcToProcess.target = -2;}
							} else {
								if ([currentMap.npcData count]-1 > 0) {
									int targetnpc = arc4random() % ([currentMap.npcData count]-1);
									if (targetnpc >= i) {targetnpc += 1;}
									NpcData* targetNpc = [currentMap.npcData objectAtIndex:targetnpc];
									if (targetNpc.hp > 0) {npcToProcess.target = targetnpc;}
								}
							}
						}
					} else if (npcToProcess.movStyle == 3) {
						if (npcToProcess.target == -1) {
							if ([currentMap.npcData count]-1 > 0) {
								int targetnpc = arc4random() % ([currentMap.npcData count]-1);
								if (targetnpc >= i) {targetnpc += 1;}
								NpcData* targetNpc = [currentMap.npcData objectAtIndex:targetnpc];
								
								if (targetNpc.hp > 0) {npcToProcess.target = targetnpc;}
							}
						}
					}
					//**End NPC targeting code
					[self moveNpc:npcToProcess currentMapTiles:tiles allNpcs:currentMap.npcData];
					if (npcToProcess.aggressive == 1) {[self npcAttack:npcToProcess currentMapTiles:tiles allNpcs:currentMap.npcData];}
					updateScreen = TRUE;
				}
			//Check for npc death
			if (npcToProcess.hp <= 0) {
				int npcnum = [currentMap.npcData count];
				[self npcDeath:npcToProcess npcNumber:i];
				if (npcnum < [currentMap.npcData count]) {i -= 1;}
			}
		}
		//Check for player death
		if (playerData.hp <= 0) {[self playerDeath];}
		
		//Check for drawing damage
		if ([damageEffects count] > 0) {updateScreen = YES;}
		
		//****TEST FOR PERFORMANCE PURPOSES ONLY UNLESS OTHERWISE APPROVED
		updateScreen = YES;
		//****TEST FOR PERFORMANCE PURPOSES ONLY UNLESS OTHERWISE APPROVED
	}
	else if (currentview == 0 || currentview == 2 || currentview == 3 || currentview == 4) {} 
	
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
	NSArray* allTouches = [touches allObjects];
	NSArray* eventTouches = [[event allTouches] allObjects];
	
	for (int i = 0; i < [eventTouches count]; i +=1) {
		if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:0]) {
			touchedScreenBegan1 = [[eventTouches objectAtIndex:i] locationInView:self];
		}
		if ([allTouches count] > 1) {
			if ([eventTouches objectAtIndex:i] == [allTouches objectAtIndex:1]) {
				touchedScreenBegan2 = [[eventTouches objectAtIndex:i] locationInView:self];
			}
		}
	}
		//CGPoint location = [touch locationInView:self];
	// tell the view to redraw
	//[self setNeedsDisplay];
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
	//[self setNeedsDisplay];
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
	//[self setNeedsDisplay];
}
- (void) drawRect:(CGRect)rect{
	//DEFINE THE SCREEN'S DRAWING CONTEXT
	CGContextRef context;
	
	//Draw the interface
	[self drawImage:context translate:CGPointMake(0,0) image:interfaceImageObj[currentview] point:CGPointMake(0, 0) rotation:0];
	
	if (currentview == 0) { //Main Menu
	} else
		if (currentview == 1) { //Gameplay Screen
			MapData *currentmap = [maps objectAtIndex:playerData.currentMap];
			UIImage* currentMapImage = [mapImages objectAtIndex:playerData.currentMap];
			[self drawImage:context translate:CGPointMake(0,0) image:currentMapImage point:mapPos rotation:0];
			
			//Draw all tile items
			for (int i = 0; i < [currentmap.items count]; i += 1) {
				Item* item = [currentmap.items objectAtIndex:i];
				CGPoint itempos = item.position;
				[self drawImage:context translate:CGPointMake(0,0) image:[itemSprites objectAtIndex:item.itemnum] point:CGPointMake(itempos.x*45.0 + mapPos.x, itempos.y*45.0 + mapPos.y) rotation:0];
			}
			
			//**Draw ALL NPCs
			NSMutableArray* npcs = currentmap.npcData;
			for(int i = 0; i < [npcs count]; i += 1) 
			{
				NpcData* currentNpc = [npcs objectAtIndex:i];
				CGPoint npcPosition = currentNpc.position;
				[self drawImage:context translate:CGPointMake(0,0) image:[npcSprites objectAtIndex:currentNpc.sprite] point:CGPointMake(npcPosition.x*45.0 + mapPos.x, npcPosition.y*45.0 + mapPos.y) rotation:0];
				if (currentNpc.hp < currentNpc.hpmax) {
					float rectcolor[4] = {1.0,0.0,0.0,1.0};
					[self drawRectangle:context translate:CGPointMake(0,0) point:CGPointMake((npcPosition.x + .06)*45.0 + mapPos.x, (npcPosition.y+.95)*45.0 + mapPos.y) widthheight:CGPointMake((.9)*45.0, (.1)*45.0) color:rectcolor rotation:0 filled:TRUE linesize:0];
					rectcolor[0] = 0.0;
					rectcolor[1] = 1.0;
					[self drawRectangle:context translate:CGPointMake(0,0) point:CGPointMake((npcPosition.x + .06)*45.0 + mapPos.x, (npcPosition.y+.95)*45.0 + mapPos.y) widthheight:CGPointMake((.9)*45.0*currentNpc.hp/currentNpc.hpmax, (.1)*45.0) color:rectcolor rotation:0  filled:TRUE linesize:0];
				}
			}
			
			[self drawImage:context translate:CGPointMake(0,0) image:[npcSprites objectAtIndex:playerData.sprite] point:CGPointMake(playerData.playerTilePos.x*45.0 + mapPos.x,playerData.playerTilePos.y*45.0 + mapPos.y) rotation:0];
			if (playerData.hp < playerData.hpmax) {
				float rectcolor[4] = {1.0,0.0,0.0,1.0};
				[self drawRectangle:context translate:CGPointMake(0,0) point:CGPointMake((playerData.playerTilePos.x + .06)*45.0 + mapPos.x, (playerData.playerTilePos.y+.95)*45.0 + mapPos.y) widthheight:CGPointMake((.9)*45.0, (.1)*45.0) color:rectcolor rotation:0  filled:TRUE linesize:0];
				rectcolor[0] = 0.0;
				rectcolor[1] = 1.0;
				[self drawRectangle:context translate:CGPointMake(0,0) point:CGPointMake((playerData.playerTilePos.x + .06)*45.0 + mapPos.x, (playerData.playerTilePos.y+.95)*45.0 + mapPos.y) widthheight:CGPointMake((.9)*45.0*playerData.hp/playerData.hpmax, (.1)*45.0) color:rectcolor rotation:0  filled:TRUE linesize:0];
			}
			//Draw Damage stats
			for (int i = 0; i < [damageEffects count]; i += 1) {
				DamageEffect* damage = [damageEffects objectAtIndex:i];
				damage.ticks += 0.1;;
				float damagecolor[4] = {1.0,0.0,0.0,1.0};
				[self drawString:context translate:CGPointMake(0,0) text:damage.text point:CGPointMake((damage.position.x+.5)*45.0, (damage.position.y+.5 - (damage.ticks/damage.ticksMax*0.6))*45.0) rotation:0 font:@"Helvetica" color:damagecolor size:16];
				if (damage.ticks >= damage.ticksMax) {[damageEffects removeObjectAtIndex:i]; i-=1;}
			}
			float textcolor[4] = {1.0,1.0,1.0,1.0};
			//Draw Stats
			if (playerData.displayToggle == 0) {
				
				[self drawString:context translate:CGPointMake(0,0) text:@"Stats" point:CGPointMake(395,5) rotation:0 font:@"Helvetica" color:textcolor size:18];
				[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"HP: %d/%d",playerData.hp,playerData.hpmax] point:CGPointMake(375,40) rotation:0 font:@"Helvetica" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"MP: %d/%d",playerData.mp,playerData.mpmax] point:CGPointMake(375,57) rotation:0 font:@"Helvetica" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"LVL: %d",playerData.lvl] point:CGPointMake(375,74) rotation:0 font:@"Helvetica" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"EXP: %d",playerData.exp] point:CGPointMake(375,91) rotation:0 font:@"Helvetica" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"Gold: %d",playerData.gold] point:CGPointMake(375,108) rotation:0 font:@"Helvetica" color:textcolor size:14];
			} else if (playerData.displayToggle == 1) {
				[self drawString:context translate:CGPointMake(0,0) text:@"Inventory" point:CGPointMake(380,5) rotation:0 font:@"Helvetica" color:textcolor size:18];
				if ([playerData.weapon isEqual:@""]) {
					[self drawString:context translate:CGPointMake(0,0) text:@"No Weapon" point:CGPointMake(375,40) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				} else {
					[self drawString:context translate:CGPointMake(0,0) text:@"Weapon:" point:CGPointMake(375,28) rotation:0 font:@"Helvetica" color:textcolor size:13];
					[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@", playerData.weapon] point:CGPointMake(375,42) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:13];
				}
				if ([playerData.armor isEqual:@""]) {
					[self drawString:context translate:CGPointMake(0,0) text:@"No Armor" point:CGPointMake(375,57) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				} else {
					[self drawString:context translate:CGPointMake(0,0) text:@"Armor:" point:CGPointMake(375,57) rotation:0 font:@"Helvetica" color:textcolor size:13];
					[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@",playerData.armor] point:CGPointMake(375,71) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:13];
				}
				if ([playerData.trinket isEqual:@""]) {
					[self drawString:context translate:CGPointMake(0,0) text:@"No Trinket" point:CGPointMake(375,74) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				} else {
					[self drawString:context translate:CGPointMake(0,0) text:@"Trinket:" point:CGPointMake(375,86) rotation:0 font:@"Helvetica" color:textcolor size:13];
					[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@",playerData.trinket] point:CGPointMake(375,100) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:13];
				}
					[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%d Potions",playerData.potions] point:CGPointMake(375,117) rotation:0 font:@"Helvetica" color:textcolor size:14];
			} else if (playerData.displayToggle == 2) {
				[self drawString:context translate:CGPointMake(0,0) text:@"Spells" point:CGPointMake(385,10) rotation:0 font:@"Helvetica" color:textcolor size:18];
				[self drawString:context translate:CGPointMake(0,0) text:@"Blank" point:CGPointMake(375,40) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:@"Blank" point:CGPointMake(375,57) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:@"Blank" point:CGPointMake(375,74) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:@"Blank" point:CGPointMake(375,91) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
				[self drawString:context translate:CGPointMake(0,0) text:@"Blank" point:CGPointMake(375,108) rotation:0 font:@"Helvetica-Oblique" color:textcolor size:14];
			}
			
			//Draw spell
			for (int i = 0; i < [spellEffects count]; i += 1) {
				SpellEffect* currentSpell = [spellEffects objectAtIndex:i];
				NSMutableArray* spellAnim = currentSpell.spellAnim;
				[self drawImage:context translate:currentSpell.position1 image:[spellAnim objectAtIndex:currentSpell.animNum] point:CGPointMake(0,-18) rotation:currentSpell.rotation];
				currentSpell.ticks += 1;
				if (currentSpell.ticks > currentSpell.ticksMax) {currentSpell.ticks = 0; currentSpell.animNum += 1;}
				if (currentSpell.animNum > [spellAnim count]-1) {currentSpell.animNum = 0;}
			}
			
			//Draw talk window if open
			if (eventOn != -1) {
				UIImage* eventImage = [eventImages objectAtIndex:eventOn];
				CGPoint eventWindowOrigin = CGPointMake(mapPos.x - eventImage.size.width/2 + currentMapImage.size.width/2, mapPos.y - eventImage.size.height/2 + currentMapImage.size.height/2);
				[self drawImage:context translate:CGPointMake(0,0) image:eventImage point:eventWindowOrigin rotation:0];
				if (eventOn == 1) { //Item event
					//Draw item
					[self drawImage:context translate:CGPointMake(0,0) image:[itemSprites objectAtIndex:eventItem.itemnum] point:CGPointMake(eventWindowOrigin.x + 40, eventWindowOrigin.y + 6) rotation:0];
					float colors[] = {1.0, .9, 0.0, 1.0};
					//Draw item name.
					CGSize textSize = [[self getItemName:eventItem.itemnum] sizeWithFont:[UIFont fontWithName:@"Helvetica-Oblique" size:22]];
					[self drawString:context translate:CGPointMake(0,0) text:[self getItemName:eventItem.itemnum] point:CGPointMake(eventWindowOrigin.x + eventImage.size.width/2 - (textSize.width/2), eventWindowOrigin.y + 20) rotation:0 font:@"Helvetica-Oblique" color:colors size:22];
					//Draw item description
					NSMutableArray* description = [self getItemDescription:[self getItemName:eventItem.itemnum]];
					for (int i = 0; i < [description count]; i += 1) {
						textSize = [[description objectAtIndex:i] sizeWithFont:[UIFont fontWithName:@"Helvetica-Oblique" size:16]];
						[self drawString:context translate:CGPointMake(0,0) text:[description objectAtIndex:i] point:CGPointMake(eventWindowOrigin.x + eventImage.size.width/2 - (textSize.width/2), eventWindowOrigin.y + 50 + (i*textSize.height)) rotation:0 font:@"Helvetica" color:colors size:16];
					}
					[description release];
				}
			}
		} else
			if (currentview == 2) { //Instructions Screen
			} else
				if (currentview == 3) { //Options Screen
				} else
					if (currentview == 4) { //Credits Screen
					} else 
						if (currentview == 5) {
							float color[] = {1.0,1.0,1.0,1.0};
							//Draw profiles
							if (game1 == nil) {
								CGSize textSize = [@"Game 1: Empty" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]];
								[self drawString:context translate:CGPointMake(0,0) text:@"Game 1: Empty" point:CGPointMake(140-textSize.width/2,100) rotation:0 font:@"Helvetica" color:color size:16];
							} else {
								PlayerData* viewGame = [game1 objectAtIndex:0];
								CGSize textSize = [viewGame.playerName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
								[self drawString:context translate:CGPointMake(0,0) text:viewGame.playerName point:CGPointMake(140-textSize.width/2,87) rotation:0 font:@"Helvetica" color:color size:18];
								textSize = [[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]];
								[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] point:CGPointMake(140-textSize.width/2,110) rotation:0 font:@"Helvetica" color:color size:14];
							}
							if (game2 == nil) {
								CGSize textSize = [@"Game 2: Empty" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]];
								[self drawString:context translate:CGPointMake(0,0) text:@"Game 2: Empty" point:CGPointMake(140-textSize.width/2,170) rotation:0 font:@"Helvetica" color:color size:16];
							} else {
								PlayerData* viewGame = [game2 objectAtIndex:0];
								CGSize textSize = [viewGame.playerName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
								[self drawString:context translate:CGPointMake(0,0) text:viewGame.playerName point:CGPointMake(140-textSize.width/2,157) rotation:0 font:@"Helvetica" color:color size:18];
								textSize = [[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]];
								[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] point:CGPointMake(140-textSize.width/2,180) rotation:0 font:@"Helvetica" color:color size:14];
							}
							if (game3 == nil) {
								CGSize textSize = [@"Game 3: Empty" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]];
								[self drawString:context translate:CGPointMake(0,0) text:@"Game 3: Empty" point:CGPointMake(140-textSize.width/2,240) rotation:0 font:@"Helvetica" color:color size:16];
							} else {
								PlayerData* viewGame = [game3 objectAtIndex:0];
								CGSize textSize = [viewGame.playerName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
								[self drawString:context translate:CGPointMake(0,0) text:viewGame.playerName point:CGPointMake(140-textSize.width/2,227) rotation:0 font:@"Helvetica" color:color size:18];
								textSize = [[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]];
								[self drawString:context translate:CGPointMake(0,0) text:[NSString stringWithFormat:@"%@  Lvl:%d  Gold:%d",viewGame.playerClass ,viewGame.lvl,viewGame.gold] point:CGPointMake(140-textSize.width/2,250) rotation:0 font:@"Helvetica" color:color size:14];
							}
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
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//***DRAW THE IMAGE
	[sprite drawAtPoint:point];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
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

- (void) moveNpc:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs {
	int target = npcToProcess.target;
	CGPoint npcTilePosition = npcToProcess.position;
	TileData* npcTile = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y];
	if (target == -1) //RANDOM
	{
		int vertOrHorz = arc4random() % 2;
		int moveDirection = arc4random() % 2;
		if (moveDirection == 0) {moveDirection = -1;}
		if (vertOrHorz == 0) { //Vertical
			if (npcTilePosition.y + moveDirection >= 0 && npcTilePosition.y + moveDirection < [[tiles objectAtIndex:0] count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + moveDirection];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x || playerData.playerTilePos.y != npcTilePosition.y + moveDirection)) {
					npcTilePosition.y += moveDirection;
				}
			}
		} else { //Horizontal
			if (npcTilePosition.x + moveDirection >= 0 && npcTilePosition.x + moveDirection < [tiles count]) {
				TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x + moveDirection] objectAtIndex:npcTilePosition.y];
				if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x + moveDirection || playerData.playerTilePos.y != npcTilePosition.y)) {
					npcTilePosition.x += moveDirection;
				}
			}
		}
	} else //Move towards target
	{
		CGPoint targetPos;
		if (target == -2) {targetPos = playerData.playerTilePos;} else {
			NpcData* npcTarget = [allNpcs objectAtIndex:target];
			targetPos = npcTarget.position;}
		TileData* tilesAround[4] = {nil, nil, nil, nil}; //Up down left right
		if (npcTilePosition.y > 0) {tilesAround[0] = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y - 1];}
		if (npcTilePosition.y < 6) {tilesAround[1] = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + 1];}
		if (npcTilePosition.x > 0) {tilesAround[2] = [[tiles objectAtIndex:npcTilePosition.x - 1] objectAtIndex:npcTilePosition.y];}
		if (npcTilePosition.x < 7) {tilesAround[3] = [[tiles objectAtIndex:npcTilePosition.x + 1] objectAtIndex:npcTilePosition.y];}
		BOOL moveableDirections[4] = {YES, YES, YES, YES}; //Up down left right
		if (tilesAround[0] == nil) {moveableDirections[0] = NO;}
		if (tilesAround[1] == nil) {moveableDirections[1] = NO;}
		if (tilesAround[2] == nil) {moveableDirections[2] = NO;}
		if (tilesAround[3] == nil) {moveableDirections[3] = NO;}
		
		//Place in movement restrictions
		CGPoint playerPos = playerData.playerTilePos;
		if (playerPos.x == npcTilePosition.x && playerPos.y == npcTilePosition.y - 1) {moveableDirections[0] = NO;}
		if (playerPos.x == npcTilePosition.x && playerPos.y == npcTilePosition.y + 1) {moveableDirections[1] = NO;}
		if (playerPos.x == npcTilePosition.x - 1 && playerPos.y == npcTilePosition.y) {moveableDirections[2] = NO;}
		if (playerPos.x == npcTilePosition.x + 1 && playerPos.y == npcTilePosition.y) {moveableDirections[3] = NO;}

		if (moveableDirections[0]) {moveableDirections[0] = !(tilesAround[0].blocked==1 || tilesAround[0].npcOn==1);}
		if (moveableDirections[1]) {moveableDirections[1] = !(tilesAround[1].blocked==1 || tilesAround[1].npcOn==1);}
		if (moveableDirections[2]) {moveableDirections[2] = !(tilesAround[2].blocked==1 || tilesAround[2].npcOn==1);}
		if (moveableDirections[3]) {moveableDirections[3] = !(tilesAround[3].blocked==1 || tilesAround[3].npcOn==1);}
		
		//Aim to move towards player, if can't, move randomly
		BOOL ablemovetotargetx = (targetPos.x < npcTilePosition.x && moveableDirections[2])||(targetPos.x > npcTilePosition.x && moveableDirections[3]);
		BOOL ablemovetotargety = (targetPos.y < npcTilePosition.y && moveableDirections[0])||(targetPos.y > npcTilePosition.y && moveableDirections[1]);
		int movedir = -1; // 0 = x, 1 = y
		if (ablemovetotargetx && ablemovetotargety) {movedir = arc4random() % 2;}
		else if (ablemovetotargetx) {movedir = 0;} else if (ablemovetotargety) {movedir = 1;}
		
		if (movedir == 0) {
			if (targetPos.x < npcTilePosition.x && moveableDirections[2]) {npcTilePosition.x -= 1;}
			if (targetPos.x > npcTilePosition.x && moveableDirections[3]) {npcTilePosition.x += 1;}
		} else if (movedir == 1) {
			if (targetPos.y < npcTilePosition.y && moveableDirections[0]) {npcTilePosition.y -= 1;}
			if (targetPos.y > npcTilePosition.y && moveableDirections[1]) {npcTilePosition.y += 1;}
		} else  //Move randomly as to get around barrier
			if (!(abs(targetPos.x - npcTilePosition.x) <= 1 && abs(targetPos.y - npcTilePosition.y) == 0) && !(abs(targetPos.x - npcTilePosition.x) == 0 && abs(targetPos.y - npcTilePosition.y) <= 1)) {
			int vertOrHorz = arc4random() % 2;
			int moveDirection = arc4random() % 2;
			if (moveDirection == 0) {moveDirection = -1;}
			if (vertOrHorz == 0) { //Vertical
				if (npcTilePosition.y + moveDirection >= 0 && npcTilePosition.y + moveDirection < [[tiles objectAtIndex:0] count]) {
					TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y + moveDirection];
					if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x || playerData.playerTilePos.y != npcTilePosition.y + moveDirection)) {
						npcTilePosition.y += moveDirection;
					}
				}
			} else { //Horizontal
				if (npcTilePosition.x + moveDirection >= 0 && npcTilePosition.x + moveDirection < [tiles count]) {
					TileData *tileToGo = [[tiles objectAtIndex:npcTilePosition.x + moveDirection] objectAtIndex:npcTilePosition.y];
					if (tileToGo.npcOn==0 && tileToGo.blocked==0 && (playerData.playerTilePos.x != npcTilePosition.x + moveDirection || playerData.playerTilePos.y != npcTilePosition.y)) {
						npcTilePosition.x += moveDirection;
					}
				}
			}
		}
	}
	npcTile.npcOn = 0;
	TileData *nowOn = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y];
	nowOn.npcOn = 1;
	npcToProcess.position = npcTilePosition;
}
- (void) npcAttack:(NpcData*)npcToProcess currentMapTiles:(NSArray*)tiles allNpcs:(NSArray*)allNpcs {
	CGPoint target;
	CGPoint npcPosition = npcToProcess.position;
	if (npcToProcess.target == -2) {
		target = playerData.playerTilePos;
		if (abs(target.x - npcPosition.x) <= 1 && abs(target.y - npcPosition.y) <= 1 && abs(target.x - npcPosition.x) != abs(target.y - npcPosition.y)) {
			playerData.hp -= 1;
			DamageEffect* damage = [[DamageEffect alloc] init];
			damage.position = CGPointMake(playerData.playerTilePos.x,playerData.playerTilePos.y);
			damage.text = @"-1";
			[damageEffects addObject:damage];
			if (playerData.hp <= 0) {npcToProcess.target = -1;}
		}
	} else if (npcToProcess.target >= 0) {
		NpcData* targetNpc = [allNpcs objectAtIndex:npcToProcess.target];
		target = targetNpc.position;
		if (abs(target.x - npcPosition.x) <= 1 && abs(target.y - npcPosition.y) <= 1 && abs(target.x - npcPosition.x) != abs(target.y - npcPosition.y)) {
			targetNpc.hp -= 1;
			DamageEffect* damage = [[DamageEffect alloc] init];
			damage.position = CGPointMake(target.x,target.y);
			damage.text = @"-1";
			[damageEffects addObject:damage];
			if (targetNpc.hp <= 0) {npcToProcess.target = -1;}
		}
	}
}
- (void) playerCollision:(NpcData*)npcCollided {
	if (npcCollided.aggressive == 1) {
		npcCollided.hp -= 1;
		DamageEffect* damage = [[DamageEffect alloc] init];
		damage.position = CGPointMake(npcCollided.position.x,npcCollided.position.y);
		damage.text = @"-1";
		[damageEffects addObject:damage];
	}
	if (npcCollided.collisionEvent > 0) {[self npcEvents:npcCollided];}
}
- (void) loadmaps {
	maps = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	//LOAD Maps
	for (int i = 0; i < [mapImages count]; i += 1) {
		NSMutableArray* tiles = [[NSMutableArray arrayWithCapacity:8] retain];
		NSMutableArray* npcsToAdd = [[NSMutableArray alloc] init];
		
		//Create default "blank" tiles
		for (int e = 0; e < 8; e++) {
			NSMutableArray *row = [NSMutableArray arrayWithCapacity:7];
			
			for (int k = 0; k<7; k++) {
				TileData *loadTileData = [[TileData alloc] init];
				[row addObject:loadTileData];
			}
			
			[tiles addObject:row];
		}
		
		if (i == 0) {
			//Load NPCS for map
			[npcsToAdd addObject:[self loadnpcs:1 xpos:0 ypos:4]];
			[npcsToAdd addObject:[self loadnpcs:1 xpos:4 ypos:5]];
			//Load tiles for map
			TileData *tileFound;
			//Create warp to...
			tileFound = [[tiles objectAtIndex:0] objectAtIndex:0];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:1] objectAtIndex:0];
			tileFound.blocked = 1;
			
			tileFound = [[tiles objectAtIndex:0] objectAtIndex:1];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:1] objectAtIndex:1];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:3] objectAtIndex:1];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:5] objectAtIndex:1];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:7] objectAtIndex:1];
			tileFound.blocked = 1;
			
			tileFound = [[tiles objectAtIndex:4] objectAtIndex:2];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:7] objectAtIndex:2];
			tileFound.blocked = 1;
			
			tileFound = [[tiles objectAtIndex:1] objectAtIndex:3];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:2] objectAtIndex:3];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:4] objectAtIndex:3];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:7] objectAtIndex:3];
			tileFound.blocked = 1;
			
			tileFound = [[tiles objectAtIndex:1] objectAtIndex:4];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:2] objectAtIndex:4];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:6] objectAtIndex:4];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:7] objectAtIndex:4];
			tileFound.blocked = 1;
			
			tileFound = [[tiles objectAtIndex:1] objectAtIndex:5];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:6] objectAtIndex:5];
			tileFound.blocked = 1;
			tileFound = [[tiles objectAtIndex:7] objectAtIndex:5];
			tileFound.blocked = 1;
		}
		
		//Make tiles know if npc is on them
		for (int e = 0; e < [npcsToAdd count]; e +=1) {
			NpcData* npcToProcess = [npcsToAdd objectAtIndex:e];
			CGPoint npcTilePosition = npcToProcess.position;
			TileData *npcTile = [[tiles objectAtIndex:npcTilePosition.x] objectAtIndex:npcTilePosition.y];
			npcTile.npcOn = 1;
		}
		
		//Create an empty map
		MapData *loadmapdata = [[MapData alloc] init];
		//Fill empty map
		loadmapdata.mapTiles = tiles;
		loadmapdata.npcData = npcsToAdd;
		
		[maps addObject:loadmapdata];
	}	
}
- (NpcData*) loadnpcs:(int)npcnum xpos:(int)xpos ypos:(int)ypos {
	//Create an empty NPC shell
	NpcData* newNpc = [[NpcData alloc] init];
	if (npcnum == 1) {
	//Get the type of NPC it's stated as
	//int typeOfNpc = [[individualMapAttributeData objectAtIndex:1] intValue];
	//Stick it where it's suppose to be on the map
	newNpc.position = CGPointMake(xpos,ypos);
	newNpc.moveCount = (arc4random() % 20) + 30; //150 50
	newNpc.moveTimer = 0;
	newNpc.movStyle = 2;
	newNpc.target = -1;
		newNpc.sprite = 0;
	newNpc.hp = 100;
	newNpc.hpmax = 100;
	newNpc.mp = 0;
	newNpc.mpmax = 0;
	newNpc.lvl = 0;
	newNpc.exp = 0;
		//newNpc.collisionEvent = 1;
		newNpc.aggressive = 1;
	} else if (npcnum == 2) {
		newNpc.position = CGPointMake(xpos,ypos);
		newNpc.moveCount = (arc4random() % 40) + 20; //150 50
		newNpc.moveTimer = 0;
		newNpc.movStyle = 2;
		newNpc.target = -1;
		newNpc.sprite = 2;
		newNpc.hp = 20;
		newNpc.hpmax = 20;
		newNpc.mp = 0;
		newNpc.mpmax = 0;
		newNpc.lvl = 0;
		newNpc.exp = 0;
		newNpc.aggressive = 1;
	}
	return newNpc;
}
- (void) npcDeath:(NpcData*)deadNpc npcNumber:(int)npcNum {
	CGPoint npcpos = deadNpc.position;
	MapData* map = [maps objectAtIndex:playerData.currentMap];
	TileData* tile = [[map.mapTiles objectAtIndex:npcpos.x] objectAtIndex:npcpos.y];
	tile.npcOn = 0;
	//Lets put some gold on this tile
	Item* newitem = [[Item alloc] init];
	newitem.itemnum = 0;
	newitem.position = npcpos;
	[map.items addObject:newitem];
	//Now lets get rid of the dead npc carcass
	[map.npcData removeObjectAtIndex:npcNum];
	//[map.npcData removeObjectAtIndex:deadNpc];
	//remove traces of npc
	if ([map.npcData count] > 0) {
		for(int i = 0; i <= [map.npcData count] - 1; i += 1) {
			NpcData* updatenpc = [map.npcData objectAtIndex:i];
			if (updatenpc.target == npcNum) {updatenpc.target = -1;}
		}
	}
}
- (void) playerDeath {
	//Not decided yet
	NSLog(@"Player dead.");
}
- (void) itemEvents:(Item*)item itemNum:(int)itemNum event:(int)event {
	if (event == 0) { //Stepped on item
		eventOn = 1;
		eventItem = item;
		eventItemNum = itemNum;
	} else if (event == 1) { //Used Item
		MapData* currentmap = [maps objectAtIndex:playerData.currentMap];
		switch(item.itemnum)
		{
			case 0: //Gold
				playerData.gold += 1;
				[currentmap.items removeObjectAtIndex:itemNum];
				break;
			case 1:
				
				break;
			default:
				break;
		}
	}
}
- (void) npcEvents:(NpcData*)eventNpc {
	switch(eventNpc.collisionEvent)
	{
		case 1:
			eventOn = 0;
			break;
		case 2:
			break;
		default:
			break;
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
	//Save Game
	if (currentview == 1) {//On gamescreen, save game
		NSMutableArray* gameToSave = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
		[gameToSave addObject:playerData];
		[gameToSave addObject:maps];
		[gameToSave addObject:damageEffects];
		if (eventItem == nil) {
			[gameToSave addObject:@"nil"];
		} else {[gameToSave addObject:eventItem];}
		[gameToSave addObject:[NSNumber numberWithInt:eventOn]];
		[gameToSave addObject:[NSNumber numberWithInt:eventItemNum]];
		[self saveFileInDocs:[NSString stringWithFormat:@"game%d.txt",selectedGame] object:gameToSave];
	}
}
-(void) loadGame {
	NSMutableArray* toLoad;
	if (selectedGame == 1) {
		toLoad = game1;
	}
	if (selectedGame == 2) {
		toLoad = game2;
	}
	if (selectedGame == 3) {
		toLoad = game3;
	}
	if (toLoad != nil) {
		[toLoad retain];
		playerData = [toLoad objectAtIndex:0];
		maps = [toLoad objectAtIndex:1];
		damageEffects = [toLoad objectAtIndex:2];
		if ([toLoad objectAtIndex:3] == @"nil") {} else {eventItem = [toLoad objectAtIndex:3];}
		eventOn = [[toLoad objectAtIndex:4] intValue];
		eventItemNum = [[toLoad objectAtIndex:5] intValue];
		currentview = 1;
	} else {		
		eventOn = -1;
		playerData = [[PlayerData alloc] init];
		damageEffects = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
		eventItem = nil;
		eventItemNum = -1;
		
		//Load all maps
		[self loadmaps];

		//***END LOAD IMAGE
		currentview = 6;
		
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
	}
}

- (void) appQuit {
	[self saveGame];
}
- (void) dealloc {
	[interfaceImageObj[0] release];
	[interfaceImageObj[1] release];
	[interfaceImageObj[2] release];
	[interfaceImageObj[3] release];
	[interfaceImageObj[4] release];
	[interfaceImageObj[5] release];
	[interfaceImageObj[6] release];
	[game1 release];
	[game2 release];
	[game3 release];
	[eventImages release];
	[eventItem release];
	[mapImages release];
	[playerData release];
	[npcSprites release];
	[itemSprites release];
	[damageEffects release];
	[maps release];
	[gameTimer release];
	
	[super dealloc];
}
@end

//Possible easter eggs:
//Able to drag health bar to any amount, ONLY ONCE.
//
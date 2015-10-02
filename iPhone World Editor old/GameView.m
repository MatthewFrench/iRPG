#import "GameView.h"

@implementation GameView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (void)awakeFromNib{
	screenDimensions = CGPointMake([self bounds].size.width, [self bounds].size.height);
	
	//Load world map
	NSMutableArray* loadData = [self openFileAtApp:@"World Data.gan"];
	if (loadData == nil) {
		maps = [NSMutableArray new];
		npcs = [NSMutableArray new];
	} else {
		maps = [loadData objectAtIndex:0];
		if ([loadData count] > 1) {
			npcs = [loadData objectAtIndex:1];
		} else {
			npcs = [NSMutableArray new];
			for (int i = 0; i < [maps count]; i ++) {
				MapData* map = [maps objectAtIndex:i];
				for (int x = 0; x < [map.mapTiles count]; x ++) {
					NSArray* column = [map.mapTiles objectAtIndex:x];
					for (int y = 0; y < [column count]; y ++) {
						TileData* tile = [column objectAtIndex:y];
						tile.spawnNpc = -1;
					}
				}
			}
		}
	}
	
	tiles = [NSMutableArray new];
	NSImage* transparentTile = [NSImage new];
	[tiles addObject:transparentTile];
	[transparentTile release];
	for (int i = 1; i > 0; i += 1) {
		NSImage* tile = [self loadImageAtApp:[NSString stringWithFormat:@"tiles/%d", i] type:@"png"];
		if (tile == nil) {i = -1;} else {
		[tiles addObject: tile];
			[tile release];
		}
	}
	tileView.tiles = tiles;
	
	sprites = [NSMutableArray new];
	transparentTile = [NSImage new];
	[sprites addObject:transparentTile];
	[transparentTile release];
	for (int i = 1; i > 0; i += 1) {
		NSImage* tile = [self loadImageAtApp:[NSString stringWithFormat:@"sprites/%d", i] type:@"png"];
		if (tile == nil) {i = -1;} else {
			[sprites addObject: tile];
			[tile release];
		}
	}
	spriteView.tiles = sprites;
	
	items = [NSMutableArray new];
	transparentTile = [NSImage new];
	[items addObject:transparentTile];
	[transparentTile release];
	for (int i = 1; i > 0; i += 1) {
		NSImage* tile = [self loadImageAtApp:[NSString stringWithFormat:@"items/%d", i] type:@"png"];
		if (tile == nil) {i = -1;} else {
			[items addObject: tile];
			[tile release];
		}
	}
	itemView.tiles = items;
	previouslySelectedTile = CGPointMake(-1,-1);
	
	player = [self loadImage:@"stickman" type:@"png"];
	
	[newMapBtn setTarget:self];
	[newMapBtn setAction:@selector(newMap:)];
	[deleteMapBtn setTarget:self];
	[deleteMapBtn setAction:@selector(deleteMap:)];
	[mapTableView setDataSource:self];
	[mapTableView setTarget:self];
	[mapTableView setAction:@selector(mapTableClick:)];
	[playMap setTarget:self];
	[playMap setAction:@selector(playCurrentMap:)];
	[mapNameTxt setTarget:self];
	[mapNameTxt setAction:@selector(changedMapName:)];
	[mapUpTxt setTarget:self];
	[mapUpTxt setAction:@selector(changedMapUp:)];
	[mapDownTxt setTarget:self];
	[mapDownTxt setAction:@selector(changedMapDown:)];
	[mapLeftTxt setTarget:self];
	[mapLeftTxt setAction:@selector(changedMapLeft:)];
	[mapRightTxt setTarget:self];
	[mapRightTxt setAction:@selector(changedMapRight:)];
	
	[tileLayers setTarget:self];
	[tileLayers setAction:@selector(changedLayer:)];

	[blockedCheckBox setTarget:self];
	[blockedCheckBox setAction:@selector(pressedBlockedCheckBox:)];
	
	[setTileNpc setTarget:self];
	[setTileNpc setAction:@selector(settedTileNpc:)];
	
	[setPermanentNpc setTarget:self];
	[setPermanentNpc setAction:@selector(settedPermanentNpc:)];

	[drawAttributes setTarget:self];
	[drawAttributes setAction:@selector(pressedDrawAttributes:)];
	
	[saveWorld setTarget:self];
	[saveWorld setAction:@selector(pressedSaveWorld:)];
	
	[newNPCBtn setTarget:self];
	[newNPCBtn setAction:@selector(newNPC:)];
	[deleteNPCBtn setTarget:self];
	[deleteNPCBtn setAction:@selector(deleteNPC:)];
	[npcTableView setDataSource:self];
	[npcTableView setTarget:self];
	[npcTableView setAction:@selector(npcTableClick:)];
	
	[npcNameLabel setTarget:self];
	[npcNameLabel setAction:@selector(writeNpcStats:)];
	[healthLabel setTarget:self];
	[healthLabel setAction:@selector(writeNpcStats:)];
	[levelLabel setTarget:self];
	[levelLabel setAction:@selector(writeNpcStats:)];
	[attackLabel setTarget:self];
	[attackLabel setAction:@selector(writeNpcStats:)];
	[speedLabel setTarget:self];
	[speedLabel setAction:@selector(writeNpcStats:)];
	[weaponLabel setTarget:self];
	[weaponLabel setAction:@selector(writeNpcStats:)];
	[trinketLabel setTarget:self];
	[trinketLabel setAction:@selector(writeNpcStats:)];
	[manaLabel setTarget:self];
	[manaLabel setAction:@selector(writeNpcStats:)];
	[goldLabel setTarget:self];
	[goldLabel setAction:@selector(writeNpcStats:)];
	[defenseLabel setTarget:self];
	[defenseLabel setAction:@selector(writeNpcStats:)];
	[potionsLabel setTarget:self];
	[potionsLabel setAction:@selector(writeNpcStats:)];
	[armorLabel setTarget:self];
	[armorLabel setAction:@selector(writeNpcStats:)];
	[specialLabel setTarget:self];
	[specialLabel setAction:@selector(writeNpcStats:)];
	[canDropWeapon setTarget:self];
	[canDropWeapon setAction:@selector(writeNpcStats:)];
	[canDropTrinket setTarget:self];
	[canDropTrinket setAction:@selector(writeNpcStats:)];
	[canLevelUp setTarget:self];
	[canLevelUp setAction:@selector(writeNpcStats:)];
	[canDropArmor setTarget:self];
	[canDropArmor setAction:@selector(writeNpcStats:)];
	[canDropGold setTarget:self];
	[canDropGold setAction:@selector(writeNpcStats:)];
	[canDropPotions setTarget:self];
	[canDropPotions setAction:@selector(writeNpcStats:)];
	[canMove setTarget:self];
	[canMove setAction:@selector(writeNpcStats:)];
	[tranMapTravel setTarget:self];
	[tranMapTravel setAction:@selector(writeNpcStats:)];
	[moveRand setTarget:self];
	[moveRand setAction:@selector(writeNpcStats:)];
	[moveToPlayer setTarget:self];
	[moveToPlayer setAction:@selector(writeNpcStats:)];
	[moveToNPC setTarget:self];
	[moveToNPC setAction:@selector(writeNpcStats:)];
	[moveToAnything setTarget:self];
	[moveToAnything setAction:@selector(writeNpcStats:)];
	[attackNothing setTarget:self];
	[attackNothing setAction:@selector(writeNpcStats:)];
	[attackPlayer setTarget:self];
	[attackPlayer setAction:@selector(writeNpcStats:)];
	[attackNPC setTarget:self];
	[attackNPC setAction:@selector(writeNpcStats:)];
	[attackAnything setTarget:self];
	[attackAnything setAction:@selector(writeNpcStats:)];
	
	scrollX = -125;
	scrollY = -50;
	
	selectedMap = -1;
	selectedNpc = -1;
	tileWidth = 45;
	tileHeight = 45;
	mapWidth = 765;
	mapHeight = 630;
	
	updateScreen = TRUE;
	
	moveTimer = 0;
	
	player = [sprites objectAtIndex:1];
	
	
	//***Turn on Game Timer
	gameTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
												 target: self
											   selector: @selector(handleGameTimer:)
											   userInfo: nil
												repeats: YES];

}

- (void) handleGameTimer: (NSTimer *) gameTimer {
	//All game logic goes here, this is updated 60 times a second
	if (!playingWorld) {
		if (round(scrollAccelX) != 0) {
			scrollX += scrollAccelX;
			scrollAccelX *= .9;
			//Switch map focus depending on location
			MapData* map = [maps objectAtIndex:selectedMap];
			if (-scrollX > 750/2 && map.mapLeft != -1) {selectedMap = map.mapLeft;scrollX += mapWidth;
				[self updateMapStats];
			} else
				if (scrollX > mapWidth-750/2 && map.mapRight != -1) {selectedMap = map.mapRight;scrollX -= mapWidth;
					[self updateMapStats];
				}
			updateScreen = TRUE;
		}
		if (round(scrollAccelY) != 0) {
			scrollY += scrollAccelY;
			scrollAccelY *= .9;
			//Switch map focus depending on location
			MapData* map = [maps objectAtIndex:selectedMap];
			if (-scrollY > 300 && map.mapUp != -1) {selectedMap = map.mapUp;scrollY += mapHeight;
				[self updateMapStats];
			} else
				if (scrollY > mapHeight-300  && map.mapDown != -1) {selectedMap = map.mapDown;scrollY -= mapHeight;
					[self updateMapStats];
				}
			updateScreen = TRUE;
		}
		if (keysPressed['a']) {scrollAccelX-=1;updateScreen = TRUE;}
		if (keysPressed['d']) {scrollAccelX+=1;updateScreen = TRUE;}
		if (keysPressed['s']) {scrollAccelY+=1;updateScreen = TRUE;}
		if (keysPressed['w']) {scrollAccelY-=1;updateScreen = TRUE;}
		NSString* identifier = [[tabView selectedTabViewItem] identifier];
		if (![identifier isEqualToString:selectedTab] && identifier) {
			updateScreen = TRUE;
			selectedTab = identifier;
			NSLog(@"%@", identifier);
		}
	} else 
	{
		MapData* map = [maps objectAtIndex:playerMap];
		if (moveTimer > 5) {
			if (keysPressed['a']) {
				if (playerTile.x > 0) {
					TileData* tile = [[map.mapTiles objectAtIndex:playerTile.x - 1] objectAtIndex:playerTile.y];
					if (!tile.blocked) {
						playerTile.x-=1;
						updateScreen = TRUE;
					}
				} else if (map.mapLeft != -1) {
					MapData* newMap = [maps objectAtIndex:map.mapLeft];
					TileData* tile = [[newMap.mapTiles objectAtIndex:playerTile.x - 1 + mapWidth/45] objectAtIndex:playerTile.y];
					if (!tile.blocked) {
						playerTile.x = playerTile.x - 1 + mapWidth/45;
						playerMap = map.mapLeft;
						updateScreen = TRUE;
					}
				}
			}
			if (keysPressed['d']) {
				if (playerTile.x < mapWidth/45 - 1) {
					TileData* tile = [[map.mapTiles objectAtIndex:playerTile.x + 1] objectAtIndex:playerTile.y];
					if (!tile.blocked) {
						playerTile.x+=1;
						updateScreen = TRUE;
					}
				} else if (map.mapRight != -1) {
					MapData* newMap = [maps objectAtIndex:map.mapRight];
					TileData* tile = [[newMap.mapTiles objectAtIndex:playerTile.x - mapWidth/45 + 1] objectAtIndex:playerTile.y];
					if (!tile.blocked) {
						playerTile.x = playerTile.x - mapWidth/45 + 1;
						playerMap = map.mapRight;
						updateScreen = TRUE;
					}
				}
			}
			if (keysPressed['w']) {
				if (playerTile.y > 0) {
					TileData* tile = [[map.mapTiles objectAtIndex:playerTile.x] objectAtIndex:playerTile.y-1];
					if (!tile.blocked) {
						playerTile.y-=1;
						updateScreen = TRUE;
					}
				} else if (map.mapUp != -1) {
					MapData* newMap = [maps objectAtIndex:map.mapUp];
					TileData* tile = [[newMap.mapTiles objectAtIndex:playerTile.x] objectAtIndex:playerTile.y - 1 + mapHeight/45];
					if (!tile.blocked) {
						playerTile.y = playerTile.y - 1 + mapHeight/45;
						playerMap = map.mapUp;
						updateScreen = TRUE;
					}
				}
			}
			if (keysPressed['s']) {
				if (playerTile.y < mapHeight/45 - 1) {
					TileData* tile = [[map.mapTiles objectAtIndex:playerTile.x] objectAtIndex:playerTile.y + 1];
					if (!tile.blocked) {
						playerTile.y+=1;
						updateScreen = TRUE;
					}
				} else if (map.mapDown != -1) {
					MapData* newMap = [maps objectAtIndex:map.mapDown];
					TileData* tile = [[newMap.mapTiles objectAtIndex:playerTile.x] objectAtIndex:playerTile.y - mapHeight/45 + 1];
					if (!tile.blocked) {
						playerTile.y = playerTile.y - mapHeight/45 + 1;
						playerMap = map.mapDown;
						updateScreen = TRUE;
					}
				}
			}
			moveTimer = 0;
		}
		moveTimer += 1;
	} //Playing world
	//This updates the screen
	if (updateScreen) {
		[self setNeedsDisplay:YES];
		updateScreen = FALSE;
	}
}

- (void)mouseDown:(NSEvent*)theEvent{
	
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	selectedTile = CGPointMake(floor((aMousePoint.x+scrollX)/45),floor((aMousePoint.y+scrollY)/45));
	mouseDown = aMousePoint;
	if (!playingWorld) {
	//Switch selected map depending on where you are
	if (selectedTile.x < 0) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapLeft != -1) {
				selectedMap = map.mapLeft;
				selectedTile.x += mapWidth/45;
				scrollX += mapWidth;
				updateScreen = TRUE;
			}
		}
	} else if (selectedTile.x >= mapWidth/45) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapRight != -1) {
				selectedMap = map.mapRight;
				selectedTile.x -= mapWidth/45;
				scrollX -= mapWidth;
				updateScreen = TRUE;
			}
		}
	}
	if (selectedTile.y < 0) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapUp != -1) {
				selectedMap = map.mapUp;
				selectedTile.y += mapHeight/45;
				scrollY += mapHeight;
				updateScreen = TRUE;
			}
		}
	} else if (selectedTile.y >= mapHeight/45) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapDown != -1) {
				selectedMap = map.mapDown;
				selectedTile.y -= mapHeight/45;
				scrollY -= mapHeight;
				updateScreen = TRUE;
			}
		}
	}
	if (([theEvent modifierFlags] & (NSShiftKeyMask | NSAlphaShiftKeyMask)) != 0  || [[[tabView selectedTabViewItem] identifier] isEqualToString:@"Map Tab"]) { 
		//shiftKey pressed
		updateScreen = TRUE;
	} else if ([[[tabView selectedTabViewItem] identifier] isEqualToString:@"Tile Tab"]) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			int selectedTileX = selectedTile.x;
			int selectedTileY = selectedTile.y;
			MapData* map = [maps objectAtIndex:selectedMap];
			NSArray* maptiles = [map mapTiles];
			NSArray* column = [maptiles objectAtIndex:selectedTile.x];
			TileData* tile = [column objectAtIndex:selectedTile.y];
			if (![fillTool state]) { //Change one tile
				if ([theEvent modifierFlags] & NSControlKeyMask != 0) {
				[tile setLayer:currentLayer To:0];
				} else {
				[tile setLayer:currentLayer To:tileView.selectedTile];
				}
				updateScreen = TRUE;
			} else { //Fill
				int findFillColor = [tile getTileOnLayer:currentLayer];
				int fillArray[mapWidth/tileWidth][mapHeight/tileHeight];
				//Make an array with 1s as the correct color
				for (int x = 0; x < [maptiles count];x++) {
					column = [maptiles objectAtIndex:x];
					for (int y = 0; y<[column count];y++) {
						tile = [column objectAtIndex:y];
						fillArray[x][y] = 0;
						if ([tile getTileOnLayer:currentLayer] == findFillColor) {
							fillArray[x][y] = 1;
						}
					}
				}
				fillArray[selectedTileX][selectedTileY] = 2;
				int i = 0;
				//Go through array and change 1s to 2s if they touch
				while (i == 0) {
					i = 1;
					for (int x = 0; x<mapWidth/tileWidth;x++) {
						for (int y = 0; y<mapHeight/tileHeight;y++) {
							if (fillArray[x][y] == 1) {
								if (x != 0) {
									if (fillArray[x-1][y] == 2) {
										fillArray[x][y] = 2;
										i = 0;
									}
								}
								if (x != [maptiles count]-1) {
									if (fillArray[x+1][y] == 2) {
										fillArray[x][y] = 2;
										i = 0;
									}
								}
								if (y != 0) {
									if (fillArray[x][y-1] == 2) {
										fillArray[x][y] = 2;
										i = 0;
									}
								}
								if (y != [column count]-1) {
									if (fillArray[x][y+1] == 2) {
										fillArray[x][y] = 2;
										i = 0;
									}
								}
							}
						}
						
					}
					
				}
				//Fill all colors that are 2
				for (int x = 0; x<mapWidth/tileWidth;x++) {
					column = [maptiles objectAtIndex:x];
					for (int y = 0; y<mapHeight/tileHeight;y++) {
						tile = [column objectAtIndex:y];
						if (fillArray[x][y] == 2) {
							[tile setLayer:currentLayer To:tileView.selectedTile];
						}
					}
				}
				updateScreen = TRUE;
			} //Fill
		}
	} else if ([[[tabView selectedTabViewItem] identifier] isEqualToString:@"Attributes Tab"]) {
		MapData* map = [maps objectAtIndex:selectedMap];
		TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex:selectedTile.y];
		if ([[drawAttributes selectedCell] tag] == 1) { //Blocked
			tile.blocked = !tile.blocked;
		}
		updateScreen = TRUE;
	}
		[self updateMapStats];
		[self updateTileStats];
	}
	previouslySelectedTile.x = selectedTile.x;
	previouslySelectedTile.y = selectedTile.y;
}
- (void)mouseDragged:(NSEvent*)theEvent{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	selectedTile = CGPointMake(floor((aMousePoint.x+scrollX)/45),floor((aMousePoint.y+scrollY)/45));
	
	if (!playingWorld) {
	if (selectedTile.x < 0) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapLeft != -1) {
				selectedMap = map.mapLeft;
				selectedTile.x += mapWidth/45;
				scrollX += mapWidth;
				updateScreen = TRUE;
			}
		}
	} else 
		if (selectedTile.x >= mapWidth/45) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapRight != -1) {
				selectedMap = map.mapRight;
				selectedTile.x -= mapWidth/45;
				scrollX -= mapWidth;
				updateScreen = TRUE;
			}
		}
	}
	if (selectedTile.y < 0) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapUp != -1) {
				selectedMap = map.mapUp;
				selectedTile.y += mapHeight/45;
				scrollY += mapHeight;
				updateScreen = TRUE;
			}
		}
	} else 
		if (selectedTile.y >= mapHeight/45) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			if (map.mapDown != -1) {
				selectedMap = map.mapDown;
				selectedTile.y -= mapHeight/45;
				scrollY -= mapHeight;
				updateScreen = TRUE;
			}
		}
	}
	
	if (([theEvent modifierFlags] & (NSShiftKeyMask | NSAlphaShiftKeyMask)) != 0  || [[[tabView selectedTabViewItem] identifier] isEqualToString:@"Map Tab"]) { 
		//shiftKey pressed
		scrollAccelY = mouseDown.y - aMousePoint.y;
		scrollAccelX = mouseDown.x - aMousePoint.x;
		mouseDown = aMousePoint;
	} else if ([[[tabView selectedTabViewItem] identifier] isEqualToString:@"Tile Tab"]) {
		if ([maps count] > selectedMap && selectedMap > -1) {
			MapData* map = [maps objectAtIndex:selectedMap];
			NSArray* maptiles = [map mapTiles];
			NSArray* column = [maptiles objectAtIndex:selectedTile.x];
			TileData* tile = [column objectAtIndex:selectedTile.y];
			if ([theEvent modifierFlags] & NSControlKeyMask != 0) {
				[tile setLayer:currentLayer To:0];
			} else {
				[tile setLayer:currentLayer To:tileView.selectedTile];
			}
			updateScreen = TRUE;
		}
	} else if ([[[tabView selectedTabViewItem] identifier] isEqualToString:@"Attributes Tab"]) {
		int oldTileX = previouslySelectedTile.x;
		int oldTileY = previouslySelectedTile.y;
		int newTileX = selectedTile.x;
		int newTileY = selectedTile.y;
		if (oldTileX != newTileX || oldTileY != newTileY) {
			MapData* map = [maps objectAtIndex:selectedMap];
			TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex:selectedTile.y];
			if ([[drawAttributes selectedCell] tag] == 1) { //Blocked
				tile.blocked = !tile.blocked;
			}
		}
		updateScreen = TRUE;
		[self updateMapStats];
		[self updateTileStats];
	}
	}
	previouslySelectedTile.x = selectedTile.x;
	previouslySelectedTile.y = selectedTile.y;
}
- (void)mouseUp:(NSEvent*)theEvent{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
}

- (void)keyDown:(NSEvent*)theEvent{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if (aKey == NSUpArrowFunctionKey) {
		aKey = 'w';
	}
	if (aKey == NSDownArrowFunctionKey) {
		aKey = 's';
	}
	if (aKey == NSLeftArrowFunctionKey) {
		aKey = 'a';
	}
	if (aKey == NSRightArrowFunctionKey) {
		aKey = 'd';
	}
	if (aKey < 178) {
		keysPressed[aKey] = TRUE;
	}
}
- (void)keyUp:(NSEvent*)theEvent{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if (aKey == NSUpArrowFunctionKey) {
		aKey = 'w';
	}
	if (aKey == NSDownArrowFunctionKey) {
		aKey = 's';
	}
	if (aKey == NSLeftArrowFunctionKey) {
		aKey = 'a';
	}
	if (aKey == NSRightArrowFunctionKey) {
		aKey = 'd';
	}
	if (aKey < 178) {
		keysPressed[aKey] = FALSE;
	}
}
- (void)drawRect:(NSRect)theRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	float color[] = {0.0,0.0,1.0,1.0};

	if (!playingWorld) {
		//Draw Maps
		if (selectedMap > -1 && selectedMap < [maps count]) {
			MapData* map[9];
			map[0] = [maps objectAtIndex:selectedMap]; //Selected Map
			
			if (map[0].mapUp != -1) { //Map Above
				map[1] = [maps objectAtIndex:map[0].mapUp];
			} else {map[1] = nil;}
			
			if (map[0].mapDown != -1) { //Map Below
				map[2] = [maps objectAtIndex:map[0].mapDown];
			} else {map[2] = nil;}
			
			if (map[0].mapLeft != -1) { //Map left
				map[3] = [maps objectAtIndex:map[0].mapLeft];
			} else {map[3] = nil;}
			
			if (map[0].mapRight != -1) { //Map Right
				map[4] = [maps objectAtIndex:map[0].mapRight];
			} else {map[4] = nil;}
			
			if (map[1] != nil) { //Top Left Map
				if (map[1].mapLeft != -1) {
					map[5] = [maps objectAtIndex:map[1].mapLeft];
				} else {map[5] = nil;}
			} else {map[5] = nil;}
			if (map[5] == nil) {
				if (map[3] != nil) { //Left Top - Couldn't connect so try another map
					if (map[3].mapUp != -1) {
						map[5] = [maps objectAtIndex:map[3].mapUp];
					} else {map[5] = nil;}
				} else {map[5] = nil;}
			}
			
			if (map[1] != nil) { //Top Right
				if (map[1].mapRight != -1) {
					map[6] = [maps objectAtIndex:map[1].mapRight];
					//NSLog(@"TOP Right exists");
				} else {map[6] = nil;}
			} else {map[6] = nil;}
			if (map[6] == nil) {
				if (map[4] != nil) { //Right Top - Couldn't connect so try another map
					if (map[4].mapUp != -1) {
						map[6] = [maps objectAtIndex:map[4].mapUp];
					} else {map[6] = nil;}
				} else {map[6] = nil;}
			}
			
			if (map[2] != nil) { //Bottom Left
				if (map[2].mapLeft != -1) {
					map[7] = [maps objectAtIndex:map[2].mapLeft];
				} else {map[7] = nil;}
			} else {map[7] = nil;}
			if (map[7] == nil) {
				if (map[3] != nil) { //Left Bottom - Couldn't connect so try another map
					if (map[3].mapDown != -1) {
						map[7] = [maps objectAtIndex:map[3].mapDown];
					} else {map[7] = nil;}
				} else {map[7] = nil;}
			}
			
			if (map[2] != nil) { //Bottom Right
				if (map[2].mapRight != -1) {
					map[8] = [maps objectAtIndex:map[2].mapRight];
				} else {map[8] = nil;}
			} else {map[8] = nil;}
			if (map[8] == nil) {
				if (map[4] != nil) { //Right Bottom - Couldn't connect so try another map
					if (map[4].mapDown != -1) {
						map[8] = [maps objectAtIndex:map[4].mapDown];
					} else {map[8] = nil;}
				} else {map[8] = nil;}
			}
			
			for (int i = 0; i < 9; i ++) {
				if (map[i] != nil) {
					NSArray* maptiles = [map[i] mapTiles];
					int addX = 0;
					int addY = 0;
					if (i == 1) {addY = -mapHeight;}
					if (i == 2) {addY = mapHeight;}
					if (i == 3) {addX = -mapWidth;}
					if (i == 4) {addX = mapWidth;}
					if (i == 5) {addY = -mapHeight;addX = -mapWidth;} //Top Left
					if (i == 6) {addY = -mapHeight;addX = mapWidth;} //Top Right
					if (i == 7) {addY = mapHeight;addX = -mapWidth;} //Bottom Left
					if (i == 8) {addY = mapHeight;addX = mapWidth;} //Bottom Right
					for (int l = 0; l < 10; l++) {
					for (int x = 0; x < [maptiles count]; x ++) {
						NSArray* column = [maptiles objectAtIndex:x];
						for (int y = 0; y < [column count]; y ++) {
							TileData* tile = [column objectAtIndex:y];
							if (round(x*45 - scrollX+addX) > -45 && round(x*45 - scrollX+addX) < 750 && round(y*45 - scrollY+addY) > -45 && round(y*45 - scrollY+addY) < 600) {
								if ([tile getTileOnLayer:l] != 0) {
									[self drawImage:context translate:CGPointMake(0, 0) image:[tiles objectAtIndex:[tile getTileOnLayer:l]] point:CGPointMake(round(x*45 - scrollX+addX),round(y*45 - scrollY+addY)) rotation:0.0];
								}
								if ([[[tabView selectedTabViewItem] identifier] isEqualToString:@"Attributes Tab"]) { //Highlight attributes
									if ([[drawAttributes selectedCell] tag] == 1 && tile.blocked) { //Blocked
										float fillColor[] = {1.0,0.0,0.0,0.03};
										[self drawRectangle:context translate:CGPointMake(0, 0) point:CGPointMake(round(x*45 - scrollX+addX),round(y*45 - scrollY+addY)) widthheight:CGPointMake(tileWidth, tileHeight) color:fillColor rotation:0.0 filled:TRUE linesize:0.0];
									}
									if (l == 5 && map[i] == [maps objectAtIndex:selectedMap]) { //Before fringe draw player
										//Draw NPCS
										if (tile.spawnNpc != -1 && tile.spawnNpc < [npcs count]) {
											NpcData* npc = [npcs objectAtIndex:tile.spawnNpc];
											[self drawImage:context translate:CGPointMake(0, 0) image:[sprites objectAtIndex:npc.sprite] point:CGPointMake(round(x*45 - scrollX+addX),round(y*45 - scrollY+addY)) rotation:0.0];
										}
									}
								}
							}
						}
					}
					}
				}
			}
			[self drawRectangle:context translate:CGPointMake(0, 0) point:CGPointMake(-scrollX, -scrollY) widthheight:CGPointMake(mapWidth, mapHeight) color:color rotation:0.0 filled:FALSE linesize:2.0];
			color[0] = 1.0;
			color[2] = 0.0;
			[self drawRectangle:context translate:CGPointMake(0, 0) point:CGPointMake(selectedTile.x*45-scrollX,selectedTile.y*45-scrollY) widthheight:CGPointMake(tileWidth, tileHeight) color:color rotation:0.0 filled:FALSE linesize:1.0];
			
		}
	} else 
	{
		//Draw Maps
		if (playerMap > -1 && playerMap < [maps count]) {
			MapData* map[9];
			map[0] = [maps objectAtIndex:playerMap]; //Selected Map
			
			if (map[0].mapUp != -1) { //Map Above
				map[1] = [maps objectAtIndex:map[0].mapUp];
			} else {map[1] = nil;}
			
			if (map[0].mapDown != -1) { //Map Below
				map[2] = [maps objectAtIndex:map[0].mapDown];
			} else {map[2] = nil;}
			
			if (map[0].mapLeft != -1) { //Map left
				map[3] = [maps objectAtIndex:map[0].mapLeft];
			} else {map[3] = nil;}
			
			if (map[0].mapRight != -1) { //Map Right
				map[4] = [maps objectAtIndex:map[0].mapRight];
			} else {map[4] = nil;}
			
			if (map[1] != nil) { //Top Left Map
				if (map[1].mapLeft != -1) {
					map[5] = [maps objectAtIndex:map[1].mapLeft];
				} else {map[5] = nil;}
			} else {map[5] = nil;}
			if (map[5] == nil) {
				if (map[3] != nil) { //Left Top - Couldn't connect so try another map
					if (map[3].mapUp != -1) {
						map[5] = [maps objectAtIndex:map[3].mapUp];
					} else {map[5] = nil;}
				} else {map[5] = nil;}
			}
			
			if (map[1] != nil) { //Top Right
				if (map[1].mapRight != -1) {
					map[6] = [maps objectAtIndex:map[1].mapRight];
					//NSLog(@"TOP Right exists");
				} else {map[6] = nil;}
			} else {map[6] = nil;}
			if (map[6] == nil) {
				if (map[4] != nil) { //Right Top - Couldn't connect so try another map
					if (map[4].mapUp != -1) {
						map[6] = [maps objectAtIndex:map[4].mapUp];
					} else {map[6] = nil;}
				} else {map[6] = nil;}
			}
			
			if (map[2] != nil) { //Bottom Left
				if (map[2].mapLeft != -1) {
					map[7] = [maps objectAtIndex:map[2].mapLeft];
				} else {map[7] = nil;}
			} else {map[7] = nil;}
			if (map[7] == nil) {
				if (map[3] != nil) { //Left Bottom - Couldn't connect so try another map
					if (map[3].mapDown != -1) {
						map[7] = [maps objectAtIndex:map[3].mapDown];
					} else {map[7] = nil;}
				} else {map[7] = nil;}
			}
			
			if (map[2] != nil) { //Bottom Right
				if (map[2].mapRight != -1) {
					map[8] = [maps objectAtIndex:map[2].mapRight];
				} else {map[8] = nil;}
			} else {map[8] = nil;}
			if (map[8] == nil) {
				if (map[4] != nil) { //Right Bottom - Couldn't connect so try another map
					if (map[4].mapDown != -1) {
						map[8] = [maps objectAtIndex:map[4].mapDown];
					} else {map[8] = nil;}
				} else {map[8] = nil;}
			}
			
			for (int i = 0; i < 9; i ++) {
				if (map[i] != nil) {
					NSArray* maptiles = [map[i] mapTiles];
					int addX = 0;
					int addY = 0;
					if (i == 1) {addY = -mapHeight;}
					if (i == 2) {addY = mapHeight;}
					if (i == 3) {addX = -mapWidth;}
					if (i == 4) {addX = mapWidth;}
					if (i == 5) {addY = -mapHeight;addX = -mapWidth;} //Top Left
					if (i == 6) {addY = -mapHeight;addX = mapWidth;} //Top Right
					if (i == 7) {addY = mapHeight;addX = -mapWidth;} //Bottom Left
					if (i == 8) {addY = mapHeight;addX = mapWidth;} //Bottom Right
					for (int l = 0; l < 10; l ++) {
						if (l == 6 && map[i] == [maps objectAtIndex:playerMap]) { //Before fringe draw player
							[self drawImage:context translate:CGPointMake(0, 0) image:player point:CGPointMake(screenDimensions.x/2, screenDimensions.y/2) rotation:0.0];
							//Also Draw NPCS
							for (int i = 0; i < [worldNpcs count]; i ++) {
								WorldNpc* npc = [worldNpcs objectAtIndex:i];
								if (playerMap == npc.currentMap) {
									NpcData* npcData = [npcs objectAtIndex:npc.npcNum];
									[self drawImage:context translate:CGPointMake(0, 0) image:[sprites objectAtIndex:npcData.sprite] point:CGPointMake(round(npc.currentTile.x*45 - playerTile.x*45+addX+screenDimensions.x/2),round(npc.currentTile.y*45 - playerTile.y*45+addY+screenDimensions.y/2)) rotation:0.0];
								}
							}
						}
						for (int x = 0; x < [maptiles count]; x ++) {
							NSArray* column = [maptiles objectAtIndex:x];
							for (int y = 0; y < [column count]; y ++) {
								TileData* tile = [column objectAtIndex:y];
								if (round(x*45+addX-playerTile.x*45+screenDimensions.x/2) > -45 && round(x*45+addX-playerTile.x*45+screenDimensions.x/2) < 750 && round(y*45+addY-playerTile.y*45+screenDimensions.y/2) > -45 && round(y*45+addY-playerTile.y*45+screenDimensions.y/2) < 600) {
									if ([tile getTileOnLayer:l] != 0) {
										[self drawImage:context translate:CGPointMake(0, 0) image:[tiles objectAtIndex:[tile getTileOnLayer:l]] point:CGPointMake(round(x*45+addX-playerTile.x*45+screenDimensions.x/2),round(y*45+addY-playerTile.y*45+screenDimensions.y/2)) rotation:0.0];
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

- (void)newMap:(id)sender {
	//Fill empty map
	MapData* map = [[MapData alloc] init];
	map.mapTiles = [[NSMutableArray alloc] init];
	//Create default "blank" tiles
	for (int e = 0; e < mapWidth/tileWidth; e++) {
		NSMutableArray *row = [[NSMutableArray alloc] init];
		for (int k = 0; k<mapHeight/tileHeight; k++) {
			TileData *tile = [[TileData alloc] init];
			[row addObject:tile];
			[tile release];
		}
		[map.mapTiles addObject:row];
		[row release];
	}
	if ([maps count] > 0) {
	MapData* currentMap = [maps objectAtIndex:selectedMap];
	int num = NSRunInformationalAlertPanel( @"How would you like to connect this new map?"
										   , @"", @"Vertically", @"Not Linked", @"Horizontally", nil );
	BOOL cancelled = FALSE;
	if (num == 1) {
		NSLog(@"Vertically");
		int num2 = NSRunInformationalAlertPanel( @"How would you like to connect it vertically?"
												, @"", @"Below Current Map", @"Cancel", @"Above Current Map", nil );
		if (num2 == 1) { //Below Current map
			map.mapUp = selectedMap;
			currentMap.mapDown = [maps count];
			if (currentMap.mapLeft != -1) {
				MapData* leftOfSelected = [maps objectAtIndex:currentMap.mapLeft];
				if (leftOfSelected.mapDown != -1) {
					map.mapLeft = leftOfSelected.mapDown;
					if (leftOfSelected.mapDown != -1) {
						MapData* left = [maps objectAtIndex:leftOfSelected.mapDown];
						left.mapRight = [maps count];
					}
				}
			}
			if (currentMap.mapRight != -1) {
				MapData* rightOfSelected = [maps objectAtIndex:currentMap.mapRight];
				if (rightOfSelected.mapDown != -1) {
					map.mapRight = rightOfSelected.mapDown;
					if (rightOfSelected.mapDown != -1) {
						MapData* right = [maps objectAtIndex:rightOfSelected.mapDown];
						right.mapRight = [maps count];
					}
				}
			}
		} //Below Current Map
		if (num2 == -1) { //Above Current map
			map.mapDown = selectedMap;
			currentMap.mapUp = [maps count];
			if (currentMap.mapLeft != -1) {
				MapData* leftOfSelected = [maps objectAtIndex:currentMap.mapLeft];
				if (leftOfSelected.mapUp != -1) {
					map.mapLeft = leftOfSelected.mapUp;
					if (leftOfSelected.mapUp != -1) {
						MapData* left = [maps objectAtIndex:leftOfSelected.mapUp];
						left.mapRight = [maps count];
					}
				}
			}
			if (currentMap.mapRight != -1) {
				MapData* rightOfSelected = [maps objectAtIndex:currentMap.mapRight];
				if (rightOfSelected.mapUp != -1) {
					map.mapRight = rightOfSelected.mapUp;
					if (rightOfSelected.mapUp != -1) {
						MapData* right = [maps objectAtIndex:rightOfSelected.mapUp];
						right.mapLeft = [maps count];
					}
				}
			}
		} //Above Current Map
		if (num2 == 0) {cancelled = TRUE;}
	}
	if (num == -1) {
		NSLog(@"Horizontally");
		int num2 = NSRunInformationalAlertPanel( @"How would you like to connect it vertically?"
												, @"", @"Right of Current Map", @"Cancel", @"Left of Current Map", nil );
		if (num2 == 1) {
			map.mapLeft = selectedMap;
			currentMap.mapRight = [maps count];
			if (currentMap.mapUp != -1) {
				MapData* aboveSelected = [maps objectAtIndex:currentMap.mapUp];
				if (aboveSelected.mapRight != -1) {
					map.mapUp = aboveSelected.mapRight;
					
					if (aboveSelected.mapRight != -1) {
						MapData* above = [maps objectAtIndex:aboveSelected.mapRight];
						above.mapDown = [maps count];
					}
					
				}
			}
			if (currentMap.mapDown != -1) {
				MapData* belowSelected = [maps objectAtIndex:currentMap.mapDown];
				if (belowSelected.mapRight != -1) {
					map.mapDown = belowSelected.mapRight;
					if (belowSelected.mapRight != -1) {
						MapData* below = [maps objectAtIndex:belowSelected.mapRight];
						below.mapUp = [maps count];
					}
				}
			}
			if (num2 == 0) {cancelled = TRUE;}
		} //Right of Current Map
		if (num2 == -1) {
			map.mapRight = selectedMap;
			currentMap.mapLeft = [maps count];
			if (currentMap.mapUp != -1) {
				MapData* aboveSelected = [maps objectAtIndex:currentMap.mapUp];
				if (aboveSelected.mapLeft != -1) {
					map.mapUp = aboveSelected.mapLeft;
					
					if (aboveSelected.mapLeft != -1) {
						MapData* above = [maps objectAtIndex:aboveSelected.mapLeft];
						above.mapUp = [maps count];
					}
					
				}
			}
			if (currentMap.mapDown != -1) {
				MapData* belowSelected = [maps objectAtIndex:currentMap.mapDown];
				if (belowSelected.mapLeft != -1) {
					map.mapDown = belowSelected.mapLeft;
					
					if (belowSelected.mapLeft != -1) {
						MapData* below = [maps objectAtIndex:belowSelected.mapLeft];
						below.mapUp = [maps count];
					}
					
				}
			}
		} //Left of Current Map
	}
	
	if (!cancelled) {
		[maps addObject:map];
		[map release];
		selectedMap = [maps count] - 1;
		updateScreen=TRUE;
		[mapTableView reloadData];
		[self updateMapStats];
		[self updateTileStats];
	} else {
		[map release];
	}
} else {
	[maps addObject:map];
	[map release];
	selectedMap = [maps count] - 1;
	updateScreen=TRUE;
	[mapTableView reloadData];
	[self updateMapStats];
	[self updateTileStats];
}
}
- (void)deleteMap:(id)sender {
	MapData* deletemap = [maps objectAtIndex:selectedMap];
	for (int e = 0; [deletemap.mapTiles count] > 0; e) {
		NSMutableArray *row = [deletemap.mapTiles objectAtIndex:e];
		for (int k = 0; [row count] > 0; k) {
			TileData *tile = [row objectAtIndex:k];
			[row removeObject:tile];
		}
		[deletemap.mapTiles removeObject:row];
	}
	[maps removeObject:deletemap];
	
	for (int i = 0; i < [maps count]; i ++) {
		MapData* map = [maps objectAtIndex:i];
		if (map.mapUp == selectedMap) {map.mapUp = -1;} else if (map.mapUp > selectedMap) {map.mapUp -=1;}
		if (map.mapDown == selectedMap) {map.mapDown = -1;} else if (map.mapDown > selectedMap) {map.mapDown -=1;}
		if (map.mapLeft == selectedMap) {map.mapLeft = -1;} else if (map.mapLeft > selectedMap) {map.mapLeft -=1;}
		if (map.mapRight == selectedMap) {map.mapRight = -1;} else if (map.mapRight > selectedMap) {map.mapRight -=1;}
	}
	[mapTableView reloadData];
	selectedMap = [maps count]-1;
	updateScreen = TRUE;
}
- (void)updateMapStats {
	MapData* map = [maps objectAtIndex:selectedMap];
	[mapNumLabel setStringValue:[NSString stringWithFormat:@"%d",selectedMap]];
	[mapNameTxt setStringValue:map.name];
	[mapUpTxt setStringValue:[NSString stringWithFormat:@"%d",map.mapUp]];
	[mapDownTxt setStringValue:[NSString stringWithFormat:@"%d",map.mapDown]];
	[mapLeftTxt setStringValue:[NSString stringWithFormat:@"%d",map.mapLeft]];
	[mapRightTxt setStringValue:[NSString stringWithFormat:@"%d",map.mapRight]];
}
- (void)updateTileStats {
	MapData* map = [maps objectAtIndex:selectedMap];
	TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex: selectedTile.y];
	int tilex = selectedTile.x;
	int tiley = selectedTile.y;
	[tileTxt setStringValue:[NSString stringWithFormat:@"(%d, %d)", tilex, tiley]];
	if (tile.blocked) {[blockedCheckBox setState:1];} else {[blockedCheckBox setState:0];}
	if (tile.permanentNpc) {[setPermanentNpc setState:1];} else {[setPermanentNpc setState:0];}
	[setTileNpc setStringValue:[NSString stringWithFormat:@"%d", tile.spawnNpc]];
}
- (void)playCurrentMap:(id)sender {
	if (selectedMap != -1) {
	playingWorld = !playingWorld;
	if (playingWorld) {
		[mapTableView setEnabled:FALSE];
		[deleteMapBtn setEnabled:FALSE];
		[newMapBtn setEnabled:FALSE];
		[mapNumLabel setEnabled:FALSE];
		[mapNameTxt setEnabled:FALSE];
		[mapLeftTxt setEnabled:FALSE];
		[mapRightTxt setEnabled:FALSE];
		[mapUpTxt setEnabled:FALSE];
		[mapDownTxt setEnabled:FALSE];
		[fillTool setEnabled:FALSE];
		[saveWorld setEnabled:FALSE];
		[tileLayers setEnabled:FALSE];
		[drawAttributes setEnabled:FALSE];
		[tileTxt setEnabled:FALSE];
		[blockedCheckBox setEnabled:FALSE];
		
		[playMap setTitle:@"Stop Test Playing Current Map"];
		playerTile = selectedTile;
		playerMap = selectedMap;
		worldNpcs = [NSMutableArray new];
		MapData* map = [maps objectAtIndex:playerMap];
		for (int x = 0; x < [map.mapTiles count]; x ++) {
			NSArray* column = [map.mapTiles objectAtIndex:x];
			for (int y = 0; y < [column count]; y ++) {
				TileData* tile = [column objectAtIndex:y];
				if (tile.spawnNpc != -1) {
					WorldNpc* npc = [WorldNpc new];
					npc.npcNum = tile.spawnNpc;
					npc.currentMap = playerMap;
					npc.currentTile = CGPointMake(x, y);
					[worldNpcs addObject:npc];
					[npc release];
				}
			}
		}
	} else {
		[mapTableView setEnabled:TRUE];
		[deleteMapBtn setEnabled:TRUE];
		[newMapBtn setEnabled:TRUE];
		[mapNumLabel setEnabled:TRUE];
		[mapNameTxt setEnabled:TRUE];
		[mapLeftTxt setEnabled:TRUE];
		[mapRightTxt setEnabled:TRUE];
		[mapUpTxt setEnabled:TRUE];
		[mapDownTxt setEnabled:TRUE];
		[fillTool setEnabled:TRUE];
		[saveWorld setEnabled:TRUE];
		[tileLayers setEnabled:TRUE];
		[drawAttributes setEnabled:TRUE];
		[tileTxt setEnabled:TRUE];
		[blockedCheckBox setEnabled:TRUE];
		
		[playMap setTitle:@"Test Play Current Map"];
		[worldNpcs release];
	}
	}
	updateScreen = TRUE;
}
- (void)pressedBlockedCheckBox:(id)sender {
	NSLog(@"ok");
	MapData* map = [maps objectAtIndex:selectedMap];
	TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex: selectedTile.y];
	if ([blockedCheckBox state] == 0) {tile.blocked = FALSE;} else {tile.blocked = TRUE;}
	updateScreen = TRUE;
}
- (void)settedTileNpc:(id)sender {
	MapData* map = [maps objectAtIndex:selectedMap];
	TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex: selectedTile.y];
	if ([setTileNpc intValue] < -1 || [setTileNpc intValue] > [npcs count] - 1) {
		[setTileNpc setStringValue:@"-1"];
		tile.spawnNpc = -1;
	} else {
		tile.spawnNpc = [setTileNpc intValue];
	}
	updateScreen = TRUE;
}
- (void)settedPermanentNpc:(id)sender {
	MapData* map = [maps objectAtIndex:selectedMap];
	TileData* tile = [[map.mapTiles objectAtIndex:selectedTile.x] objectAtIndex: selectedTile.y];
	if ([setPermanentNpc state] == 0) {tile.permanentNpc = FALSE;} else {tile.permanentNpc = TRUE;}
	updateScreen = TRUE;
}
- (void)pressedDrawAttributes:(id)sender {
	updateScreen = TRUE;
}
- (void)pressedSaveWorld:(id)sender {
	NSMutableArray* toSave = [[NSMutableArray alloc] init];
	[toSave addObject: maps];
	[toSave addObject: npcs];
	[self saveFileAtApp:@"World Data.gan" object:toSave];
	[toSave release];
}

- (void)changedMapName:(id)sender {
	MapData* map = [maps objectAtIndex:selectedMap];
	map.name = [mapNameTxt stringValue];
	[mapTableView reloadData];
}
- (void)changedMapUp:(id)sender {
	if ([mapUpTxt intValue] > -2 && [mapUpTxt intValue] < [maps count] && [mapUpTxt intValue] != selectedMap) {
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapUp = [[mapUpTxt stringValue] intValue];
		MapData* connectedMap = [maps objectAtIndex:map.mapUp];
		connectedMap.mapDown = selectedMap;
	} else {
		[mapUpTxt setStringValue:@"-1"];
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapUp = [[mapUpTxt stringValue] intValue];
	}
	[mapTableView reloadData];
	updateScreen = TRUE;
}
- (void)changedMapDown:(id)sender {
	if ([mapDownTxt intValue] > -2 && [mapDownTxt intValue] < [maps count] && [mapDownTxt intValue] != selectedMap) {
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapDown = [mapDownTxt intValue];
		MapData* connectedMap = [maps objectAtIndex:map.mapDown];
		connectedMap.mapUp = selectedMap;
	} else {
		[mapDownTxt setStringValue:@"-1"];
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapDown = [mapDownTxt intValue];
	}
	[mapTableView reloadData];
	updateScreen = TRUE;
}
- (void)changedMapLeft:(id)sender {
	if ([mapLeftTxt intValue] > -2 && [mapLeftTxt intValue] < [maps count] && [mapLeftTxt intValue] != selectedMap) {
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapLeft = [mapLeftTxt intValue];
		MapData* connectedMap = [maps objectAtIndex:map.mapLeft];
		connectedMap.mapRight = selectedMap;
	} else {
		[mapLeftTxt setStringValue:@"-1"];
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapLeft = [mapLeftTxt intValue];
	}
	[mapTableView reloadData];
	updateScreen = TRUE;
}
- (void)changedMapRight:(id)sender {
	if ([mapRightTxt intValue] > -2 && [mapRightTxt intValue] < [maps count] && [mapRightTxt intValue] != selectedMap) {
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapRight = [mapRightTxt intValue];
		MapData* connectedMap = [maps objectAtIndex:map.mapRight];
		connectedMap.mapLeft = selectedMap;
	} else {
		[mapRightTxt setStringValue:@"-1"];
		MapData* map = [maps objectAtIndex:selectedMap];
		map.mapRight = [mapRightTxt intValue];
	}
	[mapTableView reloadData];
	updateScreen = TRUE;
}
- (void)changedLayer:(id)sender {
	if ([[[tileLayers selectedCell] title] isEqualToString:@"Ground"]) {currentLayer = 0;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Ground Anim"]) {currentLayer = 1;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Mask"]) {currentLayer = 2;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Mask Anim"]) {currentLayer = 3;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Mask 2"]) {currentLayer = 4;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Mask 2 Anim"]) {currentLayer = 5;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Fringe"]) {currentLayer = 6;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Fringe Anim"]) {currentLayer = 7;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Fringe 2"]) {currentLayer = 8;}
 if ([[[tileLayers selectedCell] title] isEqualToString:@"Fringe 2 Anim"]) {currentLayer = 9;}
}
- (void)mapTableClick:(id)sender {
	int clickedRow =[mapTableView clickedRow];
	
	if (clickedRow != -1) {
			selectedMap =  clickedRow;
			[self updateMapStats];
			scrollX = -125;
			scrollY = -50;
			updateScreen = TRUE;
	}
}

- (void)newNPC:(id)sender {
	//Fill empty map
	NpcData* npc = [[NpcData alloc] init];
	[npcs addObject:npc];
	[npc release];
	selectedNpc = [npcs count] -1;
	[self updateNpcStats];
	NSLog(@"Npcs:%d", [npcs count]);
}
- (void)deleteNPC:(id)sender {
	NpcData* deleteNPC = [npcs objectAtIndex:selectedNpc];
	[npcs removeObjectAtIndex:selectedNpc];
	[npcTableView reloadData];
	selectedNpc = [maps count]-1;
	[self updateNpcStats];
}
- (void)npcTableClick:(id)sender {
	int clickedRow =[npcTableView clickedRow];
	
	if (clickedRow != -1) {
		selectedNpc =  clickedRow;
		[self updateNpcStats];
	}
}
- (void)updateNpcStats {
	NSLog(@"Reading");
	if (selectedNpc > -1 && selectedNpc < [npcs count]) {
	NpcData* npc = [npcs objectAtIndex:selectedNpc];
	[npcNameLabel setStringValue:npc.name];
	[healthLabel setStringValue:[NSString stringWithFormat:@"%d",npc.hpmax]];
	[levelLabel setStringValue:[NSString stringWithFormat:@"%d",npc.lvl]];
	[attackLabel setStringValue:[NSString stringWithFormat:@"%d",npc.attack]];
	[speedLabel setStringValue:[NSString stringWithFormat:@"%d",npc.speed]];
	[weaponLabel setStringValue:[NSString stringWithFormat:@"%d",npc.weapon]];
	[trinketLabel setStringValue:[NSString stringWithFormat:@"%d",npc.trinket]];
	[manaLabel setStringValue:[NSString stringWithFormat:@"%d",npc.mpmax]];
	[goldLabel setStringValue:[NSString stringWithFormat:@"%d",npc.gold]];
	[defenseLabel setStringValue:[NSString stringWithFormat:@"%d",npc.defense]];
	[potionsLabel setStringValue:[NSString stringWithFormat:@"%d",npc.potions]];
	[armorLabel setStringValue:[NSString stringWithFormat:@"%d",npc.armor]];
	[specialLabel setStringValue:[NSString stringWithFormat:@"%d",npc.special]];
	[canDropWeapon setState:npc.canDropWeapon];
	[canDropTrinket setState:npc.canDropTrinket];
	[canLevelUp setState:npc.canLevelUp];
	[canDropArmor setState:npc.canDropArmor];
	[canDropGold setState:npc.canDropGold];
	[canDropPotions setState:npc.canDropPotions];

	[moveRand setState:(npc.movementStyles == 1)];
	[moveToPlayer setState:(npc.movementStyles == 2)];
	[moveToNPC setState:(npc.movementStyles == 3)];
	[moveToAnything setState:(npc.movementStyles == 4)];
	[attackNothing setState:(npc.attackStyles == 1)];
	[attackPlayer setState:(npc.attackStyles == 2)];
	[attackNPC setState:(npc.attackStyles == 3)];
	[attackAnything setState:(npc.attackStyles == 4)];
	[canMove setState:npc.canMove];
	[tranMapTravel setState:npc.tranMapTravel];
	[spriteView setTile:npc.sprite];
	spriteView.npc = npc;
	[npcTableView reloadData];
	}
}
- (void)writeNpcStats:(id)sender {
	NSLog(@"Writing");
	if (selectedNpc > -1 && selectedNpc < [npcs count]) {
	NpcData* npc = [npcs objectAtIndex:selectedNpc];
	npc.name = [npcNameLabel stringValue];
	npc.hpmax = [healthLabel intValue];
	npc.lvl = [levelLabel intValue];
	npc.attack = [attackLabel intValue];
	npc.speed = [speedLabel intValue];
	npc.weapon = [weaponLabel intValue];
	npc.trinket = [trinketLabel intValue];
	npc.mpmax = [manaLabel intValue];
	npc.gold = [goldLabel intValue];
	npc.defense = [defenseLabel intValue];
	npc.potions = [potionsLabel intValue];
	npc.armor = [armorLabel intValue];
	npc.special = [specialLabel intValue];
	
	npc.canDropWeapon = [canDropWeapon state];
	npc.canDropTrinket = [canDropTrinket state];
	npc.canLevelUp = [canLevelUp state];
	npc.canDropArmor = [canDropArmor state];
	npc.canDropGold = [canDropGold state];
	npc.canDropPotions = [canDropPotions state];
	
	if (moveRand == sender) {npc.movementStyles = 1;}
	if (moveToPlayer == sender) {npc.movementStyles = 2;}
	if (moveToNPC  == sender) {npc.movementStyles = 3;}
	if (moveToAnything == sender) {npc.movementStyles = 4;}
	if (attackNothing == sender) {npc.attackStyles = 1;}
	if (attackPlayer == sender) {npc.attackStyles = 2;}
	if (attackNPC == sender) {npc.attackStyles = 3;}
	if (attackAnything == sender) {npc.attackStyles = 4;}
	[moveRand setState:(npc.movementStyles == 1)];
	[moveToPlayer setState:(npc.movementStyles == 2)];
	[moveToNPC setState:(npc.movementStyles == 3)];
	[moveToAnything setState:(npc.movementStyles == 4)];
	[attackNothing setState:(npc.attackStyles == 1)];
	[attackPlayer setState:(npc.attackStyles == 2)];
	[attackNPC setState:(npc.attackStyles == 3)];
	[attackAnything setState:(npc.attackStyles == 4)];
	npc.canMove = [canMove state];
	npc.tranMapTravel = [tranMapTravel state];
	npc.sprite = spriteView.selectedTile;
		[self updateNpcStats];
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)aTable{
	if (aTable == mapTableView) {return ([maps count]);}
	if (aTable == npcTableView) {return ([npcs count]);}
}
- (id)tableView:(NSTableView *)aTable objectValueForTableColumn:(NSTableColumn *)aCol row:(int)aRow{
	if (aTable == mapTableView) {
		MapData* map = [maps objectAtIndex:aRow];
		if ([[aCol identifier] isEqualToString:@"number"]) {
			return ([NSString stringWithFormat:@"%d", aRow]);
		} else {
			return (map.name);
		}
	}
	if (aTable == npcTableView) {
		NpcData* npc = [npcs objectAtIndex:aRow];
		if ([[aCol identifier] isEqualToString:@"number"]) {
			return ([NSString stringWithFormat:@"%d", aRow]);
		} else {
			return (npc.name);
		}
	}
}
- (NSImage*)loadImage:(NSString *)name type:(NSString*)imageType {
	//printf("File Exists!");
	//NSBundle *bundle;
	//NSString *path;
	
	//bundle = [NSBundle bundleForClass: [self class]];
	//path = [bundle pathForResource: @"atomsymbol"  ofType: @"jpg"];
	//return [[NSImage alloc] initWithContentsOfFile: path];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:imageType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		NSImage* imageFile = [[NSImage alloc] initWithContentsOfFile:filePath];
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
- (void) drawImage:(CGContextRef)context translate:(CGPoint)translate image:(NSImage*)sprite point:(CGPoint)point rotation:(float)rotation {
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//***DRAW THE IMAGE
	//[sprite drawAtPoint:point];
	
	NSRect imageRect = NSMakeRect(0,0,[sprite size].width, [sprite size].height);
	[sprite setFlipped:YES];
	[sprite drawAtPoint:NSMakePoint(point.x,point.y) fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 ];
	
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawLine:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point topoint:(CGPoint)topoint rotation:(float)rotation linesize:(float)linesize color:(float[])color {
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context,rotation * M_PI / 180);
	//Set the width of the pen mark
	CGContextSetLineWidth(context, linesize);
	// Set red stroke
	CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
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
	context = [[NSGraphicsContext currentContext] graphicsPort];
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
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//***DRAW THE Text
	//[text drawAtPoint:point withFont:textFont];
	
	
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	NSDictionary *textAttribs = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:font size:textSize],
								 NSFontAttributeName, [NSColor     colorWithDeviceRed:color[0] green:color[1] blue:color[2] alpha:color[3]], NSForegroundColorAttributeName, nil];
	[text drawAtPoint: NSMakePoint(point.x, point.y) withAttributes:textAttribs];
	[paragraphStyle release];
	
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawRectangle:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize {
	//Positions/Dimensions of rectangle
	CGRect theRect = CGRectMake(point.x, point.y, widthheight.x, widthheight.y);
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
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
- (BOOL) saveFileAtApp:(NSString*)name object:(NSMutableArray*)object {
	// save the people array
	NSArray* splitPath = [[[NSBundle mainBundle] bundlePath] componentsSeparatedByString:@"/"];
	NSString* path = @"";
	for (int i = 0; i < [splitPath count]-1; i ++) {
		path = [NSString stringWithFormat:@"%@/%@",path,[splitPath objectAtIndex:i]];
	}
	path = [NSString stringWithFormat:@"%@/%@",path,name];
	BOOL saved=[NSKeyedArchiver archiveRootObject:object toFile:path];
	return saved;
}
- (NSMutableArray*) openFileAtApp:(NSString*)name {
	NSArray* splitPath = [[[NSBundle mainBundle] bundlePath] componentsSeparatedByString:@"/"];
	NSString* path = @"";
	for (int i = 0; i < [splitPath count]-1; i ++) {
		path = [NSString stringWithFormat:@"%@/%@",path,[splitPath objectAtIndex:i]];
	}
	path = [NSString stringWithFormat:@"%@/%@",path,name];
	NSMutableArray* openedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	[openedObject retain];
	return openedObject;
}
- (NSImage*)loadImageAtApp:(NSString *)name type:(NSString*)imageType {
	NSArray* splitPath = [[[NSBundle mainBundle] bundlePath] componentsSeparatedByString:@"/"];
	NSString* path = @"";
	for (int i = 0; i < [splitPath count]-1; i ++) {
		path = [NSString stringWithFormat:@"%@/%@",path,[splitPath objectAtIndex:i]];
	}
	path = [NSString stringWithFormat:@"%@/%@.%@",path,name,imageType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if (fileExists) {
		NSImage* imageFile = [[NSImage alloc] initWithContentsOfFile:path];
		return imageFile;
	} else {
		return nil;
	}
}

- (BOOL)isFlipped{
    return YES;
}
- (BOOL)acceptsFirstResponder {
	return YES;
}

- (NSImage*)imageByCropping:(NSImage *)imageToCrop toRect:(CGRect)rect{
	//Init target image
	NSImage *target = [[NSImage alloc]initWithSize:NSMakeSize(rect.size.width,rect.size.height)];
	
	//start drawing on target
	[target lockFocus];
	//draw the portion of the source image on target image
	[imageToCrop drawInRect:NSMakeRect(0,0,rect.size.width,rect.size.height)
				   fromRect:NSMakeRect(0,0,rect.size.width,rect.size.height)
				  operation:NSCompositeCopy
				   fraction:1.0];
	//end drawing
	[target unlockFocus];
	
	//create a NSBitmapImageRep
	NSBitmapImageRep *bmpImageRep = [[NSBitmapImageRep alloc] initWithData:[target TIFFRepresentation]];
	//add the NSBitmapImage to the representation list of the target
	[target addRepresentation:bmpImageRep];
	[bmpImageRep release];
	return target;
}
- (CGColorRef)createCGColor:(float[])rgba{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
	float myColor[4];
	myColor[0] = rgba[0];
	myColor[1] = rgba[1];
	myColor[2] = rgba[2];
	myColor[3] = rgba[3];
#else
	CGFloat myColor[4];
	myColor[0] = rgba[0];
	myColor[1] = rgba[1];
	myColor[2] = rgba[2];
	myColor[3] = rgba[3];
#endif
	CGColorRef color = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	return color;
}

-(void) quit {
	
	NSString *theAlertMessage = [NSString stringWithFormat:
								 @"You'll lose all progress if you don't."];
	int num = NSRunAlertPanel( @"Would you like to save before quitting?", theAlertMessage, @"Yes", @"NO!", nil );
	if (num == 1) {
		[self pressedSaveWorld:nil];
	}
}

- (void) dealloc{
	//This is where you release global variables with a * in them
	//Just make a [variablename release];
	//Allows you to free memory and not kill the player's device
	[tiles release];
	
	for (int r = 0; [maps count] > 0; r) {
		MapData* deletemap = [maps objectAtIndex:r];
		for (int e = 0; [deletemap.mapTiles count] > 0; e) {
			NSMutableArray *row = [deletemap.mapTiles objectAtIndex:e];
			for (int k = 0; [row count] > 0; k) {
				TileData *tile = [row objectAtIndex:k];
				[row removeObject:tile];
			}
			[deletemap.mapTiles removeObject:row];
		}
		[maps removeObject:deletemap];
	}
	[maps release];
	
	[tileView release];
	[mapTableView release];
	[deleteMapBtn release];
	[newMapBtn release];
	[mapNumLabel release];
	[mapNameTxt release];
	[mapLeftTxt release];
	[mapRightTxt release];
	[mapUpTxt release];
	[mapDownTxt release];
	[gameTimer release];
	[super dealloc];
}

@end

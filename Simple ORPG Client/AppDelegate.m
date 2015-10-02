//
//  Simple_ORPG_ClientAppDelegate.m
//  Simple ORPG Client
//
//  Created by Matthew French on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#define tileBlock 1
#define tileHouse 4

@implementation AppDelegate

@synthesize window, worldView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mapGrid" ofType:@"txt"];  
	NSString *worldGridString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

	worldGridString = [worldGridString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	
	for (int line = 0; line <25; line++) {
		for (int i = 0; i <25;i++) {
			int row = line*25 + i;
			worldGrid[i][line] = [[worldGridString substringWithRange:NSMakeRange(row, 1)] intValue];
		}
	}
	
	playerPosition = CGPointMake(9, 13);
	
	NSImage* worldImage = [NSImage imageNamed:@"room1.gif"];
	worldLayer = [CALayer layer];
	[worldLayer retain];
	worldLayer.contents = worldImage;
	[worldLayer setFrame:CGRectMake(0, 0, worldImage.size.width, worldImage.size.height)];
	[worldLayer setPosition:CGPointMake(360, 198)];
	[worldView.rootLayer addSublayer:worldLayer];
	
	NSImage* playerImage = [NSImage imageNamed:@"humanM1.gif"];
	player = [CALayer layer];
	[player retain];
	player.contents = playerImage;
	[player setFrame:CGRectMake(0, 0, playerImage.size.width, playerImage.size.height)];
	[player setPosition:CGPointMake(worldView.bounds.size.width/2.0, worldView.bounds.size.height/2.0)];
	[worldView.rootLayer addSublayer:player];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}
- (void)timerTick {
	if (moveCount == 0) {
		if (leftArrow && 
			worldGrid[(int)playerPosition.x - 1][(int)playerPosition.y] != tileBlock &&
			worldGrid[(int)playerPosition.x - 1][(int)playerPosition.y] != tileHouse) {
			worldLayer.position = CGPointMake(worldLayer.position.x + 44, worldLayer.position.y);
			playerPosition.x -= 1;
		}
		if (rightArrow && 
			worldGrid[(int)playerPosition.x + 1][(int)playerPosition.y] != tileBlock &&
			worldGrid[(int)playerPosition.x + 1][(int)playerPosition.y] != tileHouse) {
			worldLayer.position = CGPointMake(worldLayer.position.x - 44, worldLayer.position.y);
			playerPosition.x += 1;
		}
		if (downArrow && 
			worldGrid[(int)playerPosition.x][(int)playerPosition.y + 1] != tileBlock &&
			worldGrid[(int)playerPosition.x][(int)playerPosition.y + 1] != tileHouse) {
			worldLayer.position = CGPointMake(worldLayer.position.x, worldLayer.position.y+44);
			playerPosition.y += 1;
		}
		if (upArrow && 
			worldGrid[(int)playerPosition.x][(int)playerPosition.y - 1] != tileBlock &&
			worldGrid[(int)playerPosition.x][(int)playerPosition.y - 1] != tileHouse) {
			worldLayer.position = CGPointMake(worldLayer.position.x, worldLayer.position.y-44);
			playerPosition.y -= 1;
		}
		moveCount = 5;
	} else {
		moveCount -= 1;
	}
}
- (void)keydown:(UniChar)key {
	if (key == NSLeftArrowFunctionKey) {
		leftArrow = TRUE;
	}
	if (key == NSRightArrowFunctionKey) {
		rightArrow = TRUE;
	}
	if (key == NSUpArrowFunctionKey) {
		upArrow = TRUE;
	}
	if (key == NSDownArrowFunctionKey) {
		downArrow = TRUE;
	}
}
- (void)keyup:(UniChar)key {
	if (key == NSLeftArrowFunctionKey) {
		leftArrow = FALSE;
	}
	if (key == NSRightArrowFunctionKey) {
		rightArrow = FALSE;
	}
	if (key == NSUpArrowFunctionKey) {
		upArrow = FALSE;
	}
	if (key == NSDownArrowFunctionKey) {
		downArrow = FALSE;
	}
}
- (void)mouseDown:(CGPoint)point {
}
- (void)mouseDragged:(CGPoint)point {
}
- (void)mouseUp:(CGPoint)point {
}

- (void) dealloc {
	[timer invalidate];
	[worldLayer removeFromSuperlayer];
	[worldLayer release];
	[player removeFromSuperlayer];
	[player release];
	[super dealloc];
}

@end

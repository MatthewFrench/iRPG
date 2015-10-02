//
//  Simple_ORPG_ClientAppDelegate.h
//  Simple ORPG Client
//
//  Created by Matthew French on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "WorldView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window; // The main window.
	WorldView* worldView; //The canvas in the window that our game is drawn on.
	
	CALayer* worldLayer; //The world, houses, trees, grass, ect.
	CALayer* player; //The guy standing in the world that can move around.
	
	int worldGrid[25][25]; //The tile grid that determines where the player can walk.
	
	NSTimer* timer; //The timer for logic that runs 60 fps.
	
	int moveCount;
	BOOL leftArrow,rightArrow,upArrow,downArrow;
	
	CGPoint playerPosition; //The player's position in the world.
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WorldView *worldView;

- (void)keydown:(UniChar)key;
- (void)keyup:(UniChar)key;
- (void)mouseDown:(CGPoint)point;
- (void)mouseDragged:(CGPoint)point;
- (void)mouseUp:(CGPoint)point;
- (void)timerTick;

@end

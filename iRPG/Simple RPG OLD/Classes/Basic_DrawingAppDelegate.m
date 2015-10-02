//
//  Basic_DrawingAppDelegate.m
//  Basic Drawing
//
//  Created by Matthew on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Basic_DrawingAppDelegate.h"
#import "Basic_DrawingViewController.h"

@implementation Basic_DrawingAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	//MADE STATUS BAR INVISIBLE
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

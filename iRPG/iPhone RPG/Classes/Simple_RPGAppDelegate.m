#import "Simple_RPGAppDelegate.h"
#import "Simple_RPGViewController.h"

@implementation Simple_RPGAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	//MADE STATUS BAR INVISIBLE
	// Rotates the view.
	viewController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
	
	// Repositions and resizes the view.
	viewController.view.bounds = CGRectMake(0,0, 480, 320);
	[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
}

- (void)applicationWillTerminate:(UIApplication*)application {
	// Save data if appropriate
	UIView* gameView = viewController.view;
	[gameView appQuit];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

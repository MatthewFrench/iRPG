#import "Simple_RPGAppDelegate.h"
#import "Simple_RPGViewController.h"

@implementation Simple_RPGAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	//MADE STATUS BAR INVISIBLE
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

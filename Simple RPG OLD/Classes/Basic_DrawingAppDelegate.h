//
//  Basic_DrawingAppDelegate.h
//  Basic Drawing
//
//  Created by Matthew on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Basic_DrawingViewController;

@interface Basic_DrawingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Basic_DrawingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Basic_DrawingViewController *viewController;

@end


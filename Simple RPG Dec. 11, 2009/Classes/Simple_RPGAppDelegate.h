//
//  Simple_RPGAppDelegate.h
//  Simple RPG
//
//  Created by Matthew on 10/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Simple_RPGViewController;

@interface Simple_RPGAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Simple_RPGViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Simple_RPGViewController *viewController;

@end


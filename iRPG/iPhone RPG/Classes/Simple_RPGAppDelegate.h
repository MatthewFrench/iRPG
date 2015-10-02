#import <UIKit/UIKit.h>

@class Simple_RPGViewController;

@interface Simple_RPGAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Simple_RPGViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Simple_RPGViewController *viewController;

@end


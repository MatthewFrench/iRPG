//
//  Avisaria_Map_EditorAppDelegate.h
//  Avisaria Map Editor
//
//  Created by Matthew on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameView.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
	@interface Avisaria_Map_EditorAppDelegate : NSObject {
#else
		@interface Avisaria_Map_EditorAppDelegate : NSObject <NSApplicationDelegate> {
#endif
			int test; //If this is moved it won't see mainView in Interface Builder.
	
	IBOutlet GameView *mainView;
	IBOutlet NSWindow *window;
}

@end

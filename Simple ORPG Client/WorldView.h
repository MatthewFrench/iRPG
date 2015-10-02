//
//  WorldView.h
//  Simple ORPG Client
//
//  Created by Matthew French on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface WorldView : NSView {
	CALayer* rootLayer;
}
@property(nonatomic,retain) CALayer* rootLayer;

@end

//
//  WorldView.m
//  Simple ORPG Client
//
//  Created by Matthew French on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WorldView.h"
#import "AppDelegate.h"


@implementation WorldView
@synthesize rootLayer;

- (void)awakeFromNib {
	rootLayer = [CALayer layer];
	[rootLayer retain];
	
	[self setLayer: rootLayer];
	[self setWantsLayer:YES];
}
- (void)mouseDown:(NSEvent*)theEvent{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
	[delegate mouseDown:aMousePoint];
}
- (void)mouseDragged:(NSEvent*)theEvent{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
	[delegate mouseDragged:aMousePoint];
}
- (void)mouseUp:(NSEvent*)theEvent{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
	[delegate mouseUp:aMousePoint];
}

- (void)keyDown:(NSEvent*)theEvent{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
	[delegate keydown:aKey];
}
- (void)keyUp:(NSEvent*)theEvent{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
	[delegate keyup:aKey];
}

- (BOOL)isFlipped{
    return YES;
}
- (BOOL)acceptsFirstResponder {
	return YES;
}
- (void) dealloc {
	[rootLayer release];
	[super dealloc];	
}

@end

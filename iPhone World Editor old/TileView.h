#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "NpcData.h"

/*** Variable types
 BOOL test;
	test = TRUE;
	test = FALSE;
	Holds a true or false value
 int test;
	test = 1;
	Holds a number.
 NSString* test;
	test = @"Why Hello there..."
	Holds a string of text
 CGPoint test;
	test = CGPointMake(2.0, 5.0);
	Holds 2 float values, an X and Y. To retrieve:
	test.x OR test.y
 float test;
	test = 0.8478494834948;
 NSMutableArray* test;
	test = [[NSMutableArray alloc] init];
	Let's add an object:
	[test addObject:@"Hello"];
	Let's get an object:
	[test objectAtIndex:0];
	Let's count how many objects we have:
	[test count];
 NSSound *mySound = [[NSSound alloc] initWithContentsOfFile:@"/path/to/soundfile.aiff" byReference:YES];
	[mySound play];
 ***/


@interface TileView : NSView {
	//Don't touch these variables unless you wish a slow and painful death.
	NSTimer *gameTimer;
	CGPoint screenDimensions;
	
	//Put your global game variables here, but don't set a value to them!!
	//This works: int test;
	//This doesn't: int test = 0;
	
	BOOL keysPressed[178];
	
	BOOL updateScreen;
	
	//TileView
	NSMutableArray* tiles;
	
	CGPoint mouseDown;
	float scroll;
	float scrollAccel;
	int selectedTile;
	CGPoint selectedTilePos;
	
	NpcData* npc;
}
@property(nonatomic) int selectedTile;
@property(nonatomic, retain) NSMutableArray* tiles;
@property(nonatomic, retain) NpcData* npc;

-(void) setTile:(int)tile;

- (NSImage*) loadImage:(NSString*)name type:(NSString*)imageType;
- (NSString*) loadText:(NSString*)name type:(NSString*)fileType;
- (void) drawLine:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point topoint:(CGPoint)topoint rotation:(float)rotation linesize:(float)linesize color:(float[])color;
- (void) drawImage:(CGContextRef)context translate:(CGPoint)translate image:(NSImage*)sprite point:(CGPoint)point rotation:(float)rotation;
- (void) drawOval:(CGContextRef)context translate:(CGPoint)translate color:(float[])color point:(CGPoint)point dimensions:(CGPoint)dimensions rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize;
- (void) drawString:(CGContextRef)context translate:(CGPoint)translate text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(NSString*)font color:(float[])color size:(int)textSize;
- (void) drawRectangle:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize;
- (NSMutableArray*) openFileInDocs:(NSString*)name;
- (BOOL) saveFileInDocs:(NSString*)name object:(NSMutableArray*)object;
- (void) deleteFileInDocs:(NSString*)name;
- (NSImage*)imageByCropping:(NSImage *)imageToCrop toRect:(CGRect)rect;
- (CGColorRef)createCGColor:(float[])rgba;

@end

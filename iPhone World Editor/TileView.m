#import "TileView.h"

//This is where you can set variables as things.
//int test = 0; WILL WORK IN ANY OF THE METHODS HERE

//Now for some basic syntax:

//IF STATEMENT:
//if (test == 2) {} //You can trade the ==(equal to) for <=(less then or equal to) >=(greater then or equal to) <(less) >(Greater) !=(Not equal to)
//To make an OR statement add a || in between statements:
//if (test == 1 || test == 2 || test == 3) {}
//To make an AND statement add a && in between statements:
//if (test > 0 && test < 10 && test != 5) {}

//FOR statement
//for (int i = 0; i < 10; i += 1) {} //This means that i starts at zero and will go until i is not less then ten. It will count up in 1s.


@implementation TileView
@synthesize tiles,selectedTile, npc;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
	screenDimensions = CGPointMake([self bounds].size.width, [self bounds].size.height);
	//Set any global variables you have made here.
	//For example, test = 10;
	mouseDown.x = -1;
	updateScreen = TRUE;
		
	//***Turn on Game Timer
	gameTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02
												 target: self
											   selector: @selector(handleGameTimer:)
											   userInfo: nil
												repeats: YES];

}

- (void) handleGameTimer: (NSTimer *) gameTimer {
	//All game logic goes here, this is updated 60 times a second
	if (scrollAccel != 0) {
		scroll += scrollAccel;
		scrollAccel *= .9;
		if (scroll < 0) { scroll = 0;}
		updateScreen = TRUE;
	}
	if (updateScreen) {
	//This updates the screen
	[self setNeedsDisplay:YES];
		updateScreen = FALSE;
	}
}

- (void)mouseDown:(NSEvent*)theEvent
{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	mouseDown = aMousePoint;
}


- (void)mouseDragged:(NSEvent*)theEvent
{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	scrollAccel = mouseDown.y - aMousePoint.y;
	mouseDown = aMousePoint;
}


- (void)mouseUp:(NSEvent*)theEvent
{
	CGPoint aMousePoint = CGPointMake([self convertPoint:[theEvent locationInWindow] fromView:nil].x, [self convertPoint:[theEvent locationInWindow] fromView:nil].y);
	selectedTile = floor((aMousePoint.y+ scroll)/45)*floor(screenDimensions.x/45) + floor(aMousePoint.x/45);
	if (selectedTile > [tiles count] - 1) {selectedTile = 0;}
	selectedTilePos = CGPointMake(floor(aMousePoint.x/45),floor((aMousePoint.y + scroll)/45));
	updateScreen = TRUE;
	if (npc != nil) {npc.sprite = selectedTile;}
}



- (void)keyDown:(NSEvent*)theEvent
{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if (aKey == NSUpArrowFunctionKey) {
		aKey = 'w';
		scrollAccel += 5;
	}
	if (aKey == NSDownArrowFunctionKey) {
		aKey = 's';
		scrollAccel -= 5;
	}
	if (aKey == NSLeftArrowFunctionKey) {
		aKey = 'a';
	}
	if (aKey == NSRightArrowFunctionKey) {
		aKey = 'd';
	}
	if (aKey < 178) {
		keysPressed[aKey] = TRUE;
	}
}

- (void)keyUp:(NSEvent*)theEvent
{
	unichar aKey = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if (aKey == NSUpArrowFunctionKey) {
		aKey = 'w';
	}
	if (aKey == NSDownArrowFunctionKey) {
		aKey = 's';
	}
	if (aKey == NSLeftArrowFunctionKey) {
		aKey = 'a';
	}
	if (aKey == NSRightArrowFunctionKey) {
		aKey = 'd';
	}
	if (aKey < 178) {
		keysPressed[aKey] = FALSE;
	}
}
- (BOOL)isFlipped
{
    return YES;
}
- (BOOL)acceptsFirstResponder {
	return YES;
}

-(void) setTile:(int)tile {
	selectedTile = tile;
	selectedTilePos = CGPointMake((tile/(screenDimensions.x/45) - floor(tile/(screenDimensions.x/45)))*(screenDimensions.x/45),floor(tile/(screenDimensions.x/45)));
	scroll = selectedTilePos.y*45;
	updateScreen = TRUE;
}

- (void)drawRect:(NSRect)theRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	float color[] = {1.0,0.0,0.0,1.0};
	if (tiles) {
		int x = 0;
		int y = 0;
		for (int i = 0;i < [tiles count]; i++) {
			if (x == floor(screenDimensions.x/45)) {
				y += 1;
				x = 0;
			}
			if (y*45-scroll > -46 && y*45-scroll < screenDimensions.y) {
			[self drawImage:context translate:CGPointMake(0, 0) image:[tiles objectAtIndex:i] point:CGPointMake(x*45, round(y*45 - scroll)) rotation:0.0];
			}
				x += 1;
			}
	}
	[self drawRectangle:context translate:CGPointMake(0, 0) point:CGPointMake(selectedTilePos.x * 45, round(selectedTilePos.y * 45 - scroll)) widthheight:CGPointMake(45, 45) color:color rotation:0.0 filled:FALSE linesize:1.0];
}

- (NSImage*)loadImage:(NSString *)name type:(NSString*)imageType {
	//printf("File Exists!");
	//NSBundle *bundle;
	//NSString *path;
	
	//bundle = [NSBundle bundleForClass: [self class]];
	//path = [bundle pathForResource: @"atomsymbol"  ofType: @"jpg"];
	//return [[NSImage alloc] initWithContentsOfFile: path];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:imageType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		NSImage* imageFile = [[NSImage alloc] initWithContentsOfFile:filePath];
		return imageFile;
	} else {
		return nil;
	}
}
- (NSString*)loadText:(NSString *)name type:(NSString*)fileType  {
	NSString* filePath = [[NSBundle mainBundle] pathForResource:name ofType:fileType];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (fileExists) {
		NSString* txtFile = [[NSString alloc] initWithContentsOfFile:filePath];
		return txtFile;
	} else {
		return nil;
	}
}
- (void) drawImage:(CGContextRef)context translate:(CGPoint)translate image:(NSImage*)sprite point:(CGPoint)point rotation:(float)rotation {
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//***DRAW THE IMAGE
	//[sprite drawAtPoint:point];
	
	NSRect imageRect = NSMakeRect(0,0,[sprite size].width, [sprite size].height);
	[sprite setFlipped:YES];
	[sprite drawAtPoint:NSMakePoint(point.x,point.y) fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 ];
	
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawLine:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point topoint:(CGPoint)topoint rotation:(float)rotation linesize:(float)linesize color:(float[])color {
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context,rotation * M_PI / 180);
	//Set the width of the pen mark
	CGContextSetLineWidth(context, linesize);
	// Set red stroke
	CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
	// Draw a line
	//Starting point
	CGContextMoveToPoint(context, point.x, point.y);
	//Ending point
	CGContextAddLineToPoint(context,topoint.x, topoint.y);
	//Draw it
	CGContextStrokePath(context);
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawOval:(CGContextRef)context translate:(CGPoint)translate color:(float[])color point:(CGPoint)point dimensions:(CGPoint)dimensions rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize {
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	if (filled) {
		// Set red Fill
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		// Draw a circle (filled)
		CGContextFillEllipseInRect(context, CGRectMake(point.x, point.y, dimensions.x, dimensions.y));
	}else{
		//Set the width of the pen mark
		CGContextSetLineWidth(context, linesize);
		// Set red Fill
		CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
		// Draw a circle (filled)
		CGContextStrokeEllipseInRect(context, CGRectMake(point.x, point.y, dimensions.x, dimensions.y));
	}
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawString:(CGContextRef)context translate:(CGPoint)translate text:(NSString*)text point:(CGPoint)point rotation:(float)rotation font:(NSString*)font color:(float[])color size:(int)textSize {
	
	
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation * M_PI / 180);
	//***DRAW THE Text
	//[text drawAtPoint:point withFont:textFont];
	
	
	
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	NSDictionary *textAttribs = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:font size:textSize],
								 NSFontAttributeName, [NSColor     colorWithDeviceRed:color[0] green:color[1] blue:color[2] alpha:color[3]], NSForegroundColorAttributeName, nil];
	[text drawAtPoint: NSMakePoint(point.x, point.y) withAttributes:textAttribs];
	[paragraphStyle release];
	
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (void) drawRectangle:(CGContextRef)context translate:(CGPoint)translate point:(CGPoint)point widthheight:(CGPoint)widthheight color:(float[])color rotation:(float)rotation filled:(BOOL)filled linesize:(float)linesize {
	//Positions/Dimensions of rectangle
	CGRect theRect = CGRectMake(point.x, point.y, widthheight.x, widthheight.y);
	// Grab the drawing context
	context = [[NSGraphicsContext currentContext] graphicsPort];
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, translate.x, translate.y);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, rotation*M_PI/180);
	if (filled) {
		// Set red stroke
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		// Draw a rect with a red stroke
		CGContextFillRect(context, theRect);
	}else{
		//Set the width of the pen mark
		CGContextSetLineWidth(context, linesize);
		// Set red stroke
		CGContextSetRGBStrokeColor(context, color[0], color[1], color[2], color[3]);
		// Draw a rect with a red stroke
		CGContextStrokeRect(context, theRect);
	}
	//CGContextStrokeRect(context, theRect);
	// like Processing popMatrix
	CGContextRestoreGState(context);
}
- (NSMutableArray*) openFileInDocs:(NSString*)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	NSMutableArray* openedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	[openedObject retain];
	return openedObject;
}
- (BOOL) saveFileInDocs:(NSString*)name object:(NSMutableArray*)object {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	
	// save the people array
	BOOL saved=[NSKeyedArchiver archiveRootObject:object toFile:path];
	return saved;
}
- (void) deleteFileInDocs:(NSString*)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *path=[documentsDirectoryPath stringByAppendingPathComponent:name];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:NULL];
}

- (NSImage*)imageByCropping:(NSImage *)imageToCrop toRect:(CGRect)rect{
	//Init target image
	NSImage *target = [[NSImage alloc]initWithSize:NSMakeSize(rect.size.width,rect.size.height)];
	
	//start drawing on target
	[target lockFocus];
	//draw the portion of the source image on target image
	[imageToCrop drawInRect:NSMakeRect(0,0,rect.size.width,rect.size.height)
				   fromRect:NSMakeRect(0,0,rect.size.width,rect.size.height)
				  operation:NSCompositeCopy
				   fraction:1.0];
	//end drawing
	[target unlockFocus];
	
	//create a NSBitmapImageRep
	NSBitmapImageRep *bmpImageRep = [[NSBitmapImageRep alloc] initWithData:[target TIFFRepresentation]];
	//add the NSBitmapImage to the representation list of the target
	[target addRepresentation:bmpImageRep];
	[bmpImageRep release];
	return target;
}
- (CGColorRef)createCGColor:(float[])rgba{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
	float myColor[4];
	myColor[0] = rgba[0];
	myColor[1] = rgba[1];
	myColor[2] = rgba[2];
	myColor[3] = rgba[3];
#else
	CGFloat myColor[4];
	myColor[0] = rgba[0];
	myColor[1] = rgba[1];
	myColor[2] = rgba[2];
	myColor[3] = rgba[3];
#endif
	CGColorRef color = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	return color;
}


- (void) dealloc
{
	//This is where you release global variables with a * in them
	//Just make a [variablename release];
	//Allows you to free memory and not kill the player's device
	[gameTimer release];
	[super dealloc];
}

@end

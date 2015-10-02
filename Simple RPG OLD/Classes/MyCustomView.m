//
//  MyCustomView.m
//  RotateMe
//
//  Created by David Nolen on 2/16/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import "MyCustomView.h"

#define kAccelerometerFrequency        10 //Hz

@implementation MyCustomView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
	}
	return self;
}

-(void)configureAccelerometer
{
	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
	if(theAccelerometer)
	{
		theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
		theAccelerometer.delegate = self;
	}
	else
	{
		NSLog(@"Oops we're not running on the device!");
	}
}


- (void) awakeFromNib
{
	// you have to initialize your view here since it's getting
	// instantiated by the nib
	twoFingers = NO;
	
	//***LOAD IMAGE TO DRAW
	imagePath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"];
	myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
	//***END LOAD IMAGE
	//***LOAD Player TO DRAW
	playerPos = CGPointMake(9, 6);
	playerImagePath = [[NSBundle mainBundle] pathForResource:@"player" ofType:@"png"];
	myPlayerImageObj = [[UIImage alloc] initWithContentsOfFile:playerImagePath];
	//***END LOAD IMAGE
	
	// You have to explicity turn on multitouch for the view
	self.multipleTouchEnabled = YES;
	
	// configure for accelerometer
	[self configureAccelerometer];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
//	UIAccelerationValue x, y, z;
//	x = acceleration.x;
//	y = acceleration.y;
//	z = acceleration.z;
	
	// Do something with the values.
//	xField.text = [NSString stringWithFormat:@"%.5f", x];
//	yField.text = [NSString stringWithFormat:@"%.5f", y];
//	zField.text = [NSString stringWithFormat:@"%.5f", z];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches began count %d, %@", [touches count], touches);
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	
	if([touches count] > 1)
	{
		twoFingers = YES;
	}
	
	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"touches moved count %d, %@", [touches count], touches);
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	if([touches count] > 1)
	{
		twoFingers = YES;
	}
	if (twoFingers) {
	} else {
	}
	
	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches moved count %d, %@", [touches count], touches);
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	CGPoint location = [touch locationInView:self];
	
	// reset the var
	twoFingers = NO;
	
	//Arrow Pad Buttons
	//RIGHT
	if (location.x >= 50 && location.x <= 70 && location.y >= 450 && location.y <= 475) {playerPos.x += 44.0;} 
	//LEFT
	else if (location.x >= 50 && location.x <= 70 && location.y >= 405 && location.y <= 430) {playerPos.x -= 44.0;} 
	//UP
	else if (location.x >= 65 && location.x <= 90 && location.y >= 435 && location.y <= 450) {playerPos.y -= 44.0;}
	//Down
	else if (location.x >= 25 && location.x <= 50 && location.y >= 430 && location.y <= 445) {playerPos.y += 44.0;}

	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{	
	NSLog(@"drawRect");
	
	//DEFINE THE SCREEN'S DRAWING CONTEXT
	CGContextRef context;
	
	//****INDIVIDUAL DRAW IMAGE
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 320, 0);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, 90 * M_PI / 180);
	//***DRAW THE IMAGE
	[myImageObj drawAtPoint:CGPointMake(0, 0)];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
	//***END INDIVIDUAL DRAW IMAGE CODE
	
	//****INDIVIDUAL DRAW IMAGE PLAYER
	// Grab the drawing context
	context = UIGraphicsGetCurrentContext();
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 320, 0);
	// Uncomment to see the rotated square
	CGContextRotateCTM(context, 90 * M_PI / 180);
	//***DRAW THE IMAGE
	[myPlayerImageObj drawAtPoint:playerPos];
	//***END DRAW THE IMAGE
	// like Processing popMatrix
	CGContextRestoreGState(context);
	//***END INDIVIDUAL DRAW IMAGE CODE
	

}

- (void) dealloc
{
	[super dealloc];
}

@end

@end

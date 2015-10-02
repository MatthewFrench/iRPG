#import "DamageEffect.h"
#import <UIKit/UIKit.h>

@implementation DamageEffect
@synthesize text, position, ticks, ticksMax, color;
- (id)init 
{
	//if (self = [super init])
	ticks = 0;
	ticksMax = 5;
	position = CGPointMake(0, 0);
	text = @"";
	color = [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	return self;
}
-(void)dealloc {
	[text release];
	[color release];
	[super dealloc];
}
@end
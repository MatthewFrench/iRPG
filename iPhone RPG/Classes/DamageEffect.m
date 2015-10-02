#import "DamageEffect.h"
#import <UIKit/UIKit.h>

@implementation DamageEffect
@synthesize text, position, ticks, ticksMax;
- (id)init 
{
	//if (self = [super init])
	ticks = 0;
	ticksMax = 5;
	position = CGPointMake(0, 0);
	text = @"";
	return self;
}
//encode the damage data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:position.x] forKey:@"position.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:position.y] forKey:@"position.y" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticks] forKey:@"ticks" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticksMax] forKey:@"ticksMax" ];
	[coder encodeObject: text forKey:@"text"];
} 
//init a damage from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    position.x = [[coder decodeObjectForKey:@"position.x"] floatValue];
	position.y = [[coder decodeObjectForKey:@"position.y"] floatValue];
	ticks = [[coder decodeObjectForKey:@"ticks"] floatValue];
	ticksMax = [[coder decodeObjectForKey:@"ticksMax"] floatValue];
	text = [coder decodeObjectForKey:@"text"];
	[text retain];
    return self;
}
-(void)dealloc {
	[text release];
	[super dealloc];
}
@end
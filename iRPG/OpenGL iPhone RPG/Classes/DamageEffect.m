#import "DamageEffect.h"
#import <UIKit/UIKit.h>

@implementation DamageEffect
@synthesize text, tilePosition, ticks, ticksMax, textImage, mapPosition,offSet;
- (id)init 
{
	//if (self = [super init])
	ticks = 0;
	ticksMax = 5;
	tilePosition = CGPointMake(0, 0);
	text = @"";
	return self;
}
//encode the damage data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:tilePosition.x] forKey:@"tilePosition.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:tilePosition.y] forKey:@"tilePosition.y" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticks] forKey:@"ticks" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticksMax] forKey:@"ticksMax" ];
	[coder encodeObject: [NSNumber numberWithFloat:offSet] forKey:@"offSet" ];
	[coder encodeObject: [NSNumber numberWithInt:mapPosition] forKey:@"mapPosition" ];
	[coder encodeObject: text forKey:@"text"];
} 
//init a damage from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    tilePosition.x = [[coder decodeObjectForKey:@"position.x"] floatValue];
	tilePosition.y = [[coder decodeObjectForKey:@"position.y"] floatValue];
	ticks = [[coder decodeObjectForKey:@"ticks"] floatValue];
	ticksMax = [[coder decodeObjectForKey:@"ticksMax"] floatValue];
	offSet = [[coder decodeObjectForKey:@"offSet"] floatValue];
	mapPosition = [[coder decodeObjectForKey:@"mapPosition"] intValue];
	text = [coder decodeObjectForKey:@"text"];
	[text retain];
    return self;
}
-(void)dealloc {
	[text release];
	[textImage release];
	[super dealloc];
}
@end
#import "SpellEffect.h"
#import <UIKit/UIKit.h>

@implementation SpellEffect
@synthesize spellType, position1, position2, ticks, ticksMax, rotation, spellAnim, animNum,touchNum;
- (id)init 
{
	//if (self = [super init])
	ticks = 0;
	ticksMax = 5;
	animNum = 0;
	position1 = CGPointMake(0, 0); //Where spells starts
	position2 = CGPointMake(0, 0); //Where spell ends
	spellType = 0;
	rotation = 0;
	touchNum = 0;
	spellAnim = [[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	
	return self;
}

//Spell types:
//spellType = 0 means thrown
//spellType = 1 means beam, extends from one place to another

//encode the damage data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:position1.x] forKey:@"position1.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:position1.y] forKey:@"position1.y" ];
	[coder encodeObject: [NSNumber numberWithFloat:position2.x] forKey:@"position2.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:position2.y] forKey:@"position2.y" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticks] forKey:@"ticks" ];
	[coder encodeObject: [NSNumber numberWithFloat:ticksMax] forKey:@"ticksMax" ];
	[coder encodeObject: [NSNumber numberWithFloat:rotation] forKey:@"rotation" ];
	[coder encodeObject: [NSNumber numberWithInt:spellType] forKey:@"spellType" ];
	[coder encodeObject: spellAnim forKey:@"spellAnim" ];
	[coder encodeObject: [NSNumber numberWithInt:animNum] forKey:@"animNum" ];
	[coder encodeObject: [NSNumber numberWithInt:touchNum] forKey:@"touchNum" ];
} 
//init a damage from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    position1.x = [[coder decodeObjectForKey:@"position1.x"] floatValue];
	position1.y = [[coder decodeObjectForKey:@"position1.y"] floatValue];
	position2.x = [[coder decodeObjectForKey:@"position2.x"] floatValue];
	position2.y = [[coder decodeObjectForKey:@"position2.y"] floatValue];
	ticks = [[coder decodeObjectForKey:@"ticks"] floatValue];
	ticksMax = [[coder decodeObjectForKey:@"ticksMax"] floatValue];
	rotation = [[coder decodeObjectForKey:@"rotation"] floatValue];
	spellType = [[coder decodeObjectForKey:@"spellType"] intValue];
	spellAnim = [coder decodeObjectForKey:@"spellAnim"];
	animNum = [[coder decodeObjectForKey:@"animNum"] intValue];
	touchNum = [[coder decodeObjectForKey:@"touchNum"] intValue];
    return self;
}
-(void)dealloc {
	[spellAnim release];
	[super dealloc];
}
@end
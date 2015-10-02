#import "Item.h"
#import <UIKit/UIKit.h>

@implementation Item
@synthesize position, itemnum;
- (id)init 
{
	//if (self = [super init])
	return self;
}
//encode the item data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    [coder encodeObject: [NSNumber numberWithFloat:position.x] forKey:@"position.x" ];
	[coder encodeObject: [NSNumber numberWithFloat:position.y] forKey:@"position.y" ];
	[coder encodeObject: [NSNumber numberWithInt:itemnum] forKey:@"itemnum" ];
} 
//init a item from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    position.x = [[coder decodeObjectForKey:@"position.x"] floatValue];
	position.y = [[coder decodeObjectForKey:@"position.y"] floatValue];
	itemnum = [[coder decodeObjectForKey:@"itemnum"] intValue];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

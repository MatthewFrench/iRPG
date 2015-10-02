#import "MapData.h"

@implementation MapData
@synthesize mapTiles, name, mapUp, mapDown, mapLeft, mapRight;

- (id)init 
{
	name = @"New Map";
	mapUp = -1;
	mapDown = -1;
	mapLeft = -1;
	mapRight = -1;
	return self;
}
- (void) encodeWithCoder: (NSCoder *)coder
{   
	[coder encodeObject: mapTiles forKey:@"mapTiles" ];
	[coder encodeObject: name forKey:@"name" ];
	[coder encodeObject: [NSNumber numberWithInt:mapUp] forKey:@"mapUp" ];
	[coder encodeObject: [NSNumber numberWithInt:mapDown] forKey:@"mapDown" ];
	[coder encodeObject: [NSNumber numberWithInt:mapLeft] forKey:@"mapLeft" ];
	[coder encodeObject: [NSNumber numberWithInt:mapRight] forKey:@"mapRight" ];
} 
//init a player from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
	mapTiles = [coder decodeObjectForKey:@"mapTiles" ];
	[mapTiles retain];
	NSLog(@"Loaded MapTiles");
	name = [coder decodeObjectForKey:@"name" ];
	[name retain];
	NSLog(@"Loaded Name");
    mapUp = [[coder decodeObjectForKey:@"mapUp"] intValue];
	NSLog(@"Loaded MapUp");
	mapDown = [[coder decodeObjectForKey:@"mapDown"] intValue];
	NSLog(@"Loaded MapDown");
	mapLeft = [[coder decodeObjectForKey:@"mapLeft"] intValue];
	NSLog(@"Loaded MapLeft");
	mapRight = [[coder decodeObjectForKey:@"mapRight"] intValue];
	NSLog(@"Loaded MapRight");
    return self;
}

-(void)dealloc {
	[mapTiles release];
	[name release];
	[super dealloc];
}
@end

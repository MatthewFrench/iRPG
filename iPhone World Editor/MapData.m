#import "MapData.h"

@implementation MapData
@synthesize mapTiles, name,xStart,xEnd,yStart,yEnd;

- (id)init 
{
	name = @"New Map";
	mapTiles = [NSMutableArray new];
	xStart = 0;
	yStart = 0;
	for (int x = 0; x < 10; x ++) {
		NSMutableArray* column = [NSMutableArray new];
		for (int y = 0; y < 10; y ++) {
			TileData* newTile = [TileData new];
			[column addObject:newTile];
			[newTile release];
		}
		[mapTiles addObject:column];
		[column release];
	}
	xEnd = [mapTiles count]-1;
	yEnd = xEnd;
	return self;
}
- (void) encodeWithCoder: (NSCoder *)coder
{   
	[coder encodeObject: mapTiles forKey:@"mapTiles" ];
	[coder encodeObject: name forKey:@"name" ];
	[coder encodeObject: [NSNumber numberWithInt:xStart] forKey:@"xStart" ];
	[coder encodeObject: [NSNumber numberWithInt:yStart] forKey:@"yStart" ];
	[coder encodeObject: [NSNumber numberWithInt:xEnd] forKey:@"xEnd" ];
	[coder encodeObject: [NSNumber numberWithInt:yEnd] forKey:@"yEnd" ];
} 
//init a player from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
	mapTiles = [coder decodeObjectForKey:@"mapTiles" ];
	[mapTiles retain];
	name = [coder decodeObjectForKey:@"name" ];
	[name retain];
    xStart = [[coder decodeObjectForKey:@"xStart"] intValue];
	yStart = [[coder decodeObjectForKey:@"yStart"] intValue];
	xEnd = [[coder decodeObjectForKey:@"xEnd"] intValue];
	yEnd = [[coder decodeObjectForKey:@"yEnd"] intValue];
    return self;
}

-(void)dealloc {
	[mapTiles release];
	[name release];
	[super dealloc];
}
@end

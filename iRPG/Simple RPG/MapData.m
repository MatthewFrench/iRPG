#import "MapData.h"
#import <UIKit/UIKit.h>

@implementation MapData
@synthesize mapTiles, npcData, items;

- (id)init 
{
	//if (self = [super init])
	items =[[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	return self;
}
//encode the map data
- (void) encodeWithCoder: (NSCoder *)coder
{   
    //code the tiles
    [coder encodeObject: mapTiles forKey:@"mapTiles" ];
	
    // code the npcs
    [coder encodeObject: npcData forKey:@"npcData" ];
	
    // code the items
    [coder encodeObject: items forKey:@"items" ]; 
} 
//Map.m
//init a map from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    // load the tiles
    self.mapTiles = [coder decodeObjectForKey:@"mapTiles"]; 
    
	// load the tiles
    self.npcData = [coder decodeObjectForKey:@"npcData"]; 
	
	// load the tiles
    self.items = [coder decodeObjectForKey:@"items"]; 
    return self;
}
-(void)dealloc {
	[items release];
		[mapTiles release];
	[npcData release];
	[super dealloc];
}
@end

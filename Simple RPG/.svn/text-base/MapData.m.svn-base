#import "MapData.h"
#import <UIKit/UIKit.h>

@implementation MapData
@synthesize mapImageFile,mapTiles, npcData, items;

- (id)init 
{
	//if (self = [super init])
	items =[[NSMutableArray arrayWithCapacity: NSNotFound] retain];
	return self;
}
-(void)dealloc {
	[items release];
		[mapImageFile release];
		[mapTiles release];
	[npcData release];
	[super dealloc];
}
@end

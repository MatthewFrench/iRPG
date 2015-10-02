#import "MapData.h"
#import <UIKit/UIKit.h>

@implementation MapData
@synthesize mapImageFile;
@synthesize mapTiles, npcData;

-(void)dealloc {
		[mapImageFile release];
		[mapTiles release];
	[npcData release];
	[super dealloc];
}
@end

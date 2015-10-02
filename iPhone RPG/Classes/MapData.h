#import "tileData.h"
#import <UIKit/UIKit.h>
@class MapData;


@interface MapData : NSObject {
	NSMutableArray *mapTiles;
	NSString* name;
	int mapUp, mapDown, mapLeft, mapRight;
};

-(void) dealloc;
@property(nonatomic, retain) NSMutableArray *mapTiles;
@property(nonatomic, retain) NSString *name;
@property(nonatomic) int mapUp, mapDown, mapLeft, mapRight;

@end
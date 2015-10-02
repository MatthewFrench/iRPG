#import <Foundation/Foundation.h>
#import "tileData.h"
#import <UIKit/UIKit.h>
@class MapData;


@interface MapData : NSObject {
	NSArray *mapTiles;
	NSMutableArray* npcData;
	NSMutableArray* items;
};

-(void) dealloc;
@property(nonatomic, retain) NSArray *mapTiles;
@property(nonatomic, retain) NSMutableArray *npcData;
@property(nonatomic, retain) NSMutableArray *items;

@end
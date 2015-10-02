#import "tileData.h"
#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@class MapData;


@interface MapData : NSObject {
	NSMutableArray *mapTiles;
	NSString* name;
	int xStart,xEnd,yStart,yEnd;
};

-(void) dealloc;
@property(nonatomic, retain) NSMutableArray *mapTiles;
@property(nonatomic, retain) NSString *name;
@property(nonatomic) int xStart,xEnd,yStart,yEnd;

@end
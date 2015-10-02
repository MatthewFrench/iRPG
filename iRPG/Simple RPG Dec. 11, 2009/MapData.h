//
//  mapData.h
//  Simple RPG
//
//  Created by Matthew on 10/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tileData.h"
#import <UIKit/UIKit.h>
@class MapData;


@interface MapData : NSObject {
	NSString* mapDataFile;
	UIImage* mapImageFile;
	NSArray *mapTiles;
	NSMutableArray* npcData;
};

-(void) dealloc;
@property(nonatomic, retain) NSString *mapDataFile;
@property(nonatomic, retain) UIImage *mapImageFile;
@property(nonatomic, retain) NSArray *mapTiles;
@property(nonatomic, retain) NSMutableArray *npcData;

@end
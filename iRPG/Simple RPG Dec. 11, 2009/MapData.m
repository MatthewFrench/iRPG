//
//  mapData.m
//  Simple RPG
//
//  Created by Matthew on 10/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapData.h"
#import <UIKit/UIKit.h>

@implementation MapData
@synthesize mapDataFile, mapImageFile;
@synthesize mapTiles, npcData;

-(void)dealloc {
	[mapDataFile release];
		[mapImageFile release];
		[mapTiles release];
	[npcData release];
	[super dealloc];
}
@end

#import "TileData.h"
#import "MapData.h"

@implementation TileData
@synthesize groundTile,groundAnimTile,maskTile,maskAnimTile,mask2Tile,
mask2AnimTile,fringeTile,fringeAnimTile,fringe2Tile,fringe2AnimTile, blocked,spawnNpc, permanentNpc;
- (id)init 
{
	spawnNpc = -1;
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{   
	[coder encodeObject: [NSNumber numberWithInt:groundTile] forKey:@"groundTile" ];
	[coder encodeObject: [NSNumber numberWithInt:groundAnimTile] forKey:@"groundAnimTile" ];
	[coder encodeObject: [NSNumber numberWithInt:maskTile] forKey:@"maskTile" ];
	[coder encodeObject: [NSNumber numberWithInt:maskAnimTile] forKey:@"maskAnimTile" ];
	[coder encodeObject: [NSNumber numberWithInt:mask2Tile] forKey:@"mask2Tile" ];
	[coder encodeObject: [NSNumber numberWithInt:mask2AnimTile] forKey:@"mask2AnimTile" ];
	[coder encodeObject: [NSNumber numberWithInt:fringeTile] forKey:@"fringeTile" ];
	[coder encodeObject: [NSNumber numberWithInt:fringeAnimTile] forKey:@"fringeAnimTile" ];
	[coder encodeObject: [NSNumber numberWithInt:fringe2Tile] forKey:@"fringe2Tile" ];
	[coder encodeObject: [NSNumber numberWithInt:fringe2AnimTile] forKey:@"fringe2AnimTile" ];
	[coder encodeObject: [NSNumber numberWithBool:blocked] forKey:@"blocked" ];
	[coder encodeObject: [NSNumber numberWithInt:spawnNpc] forKey:@"spawnNpc" ];
	[coder encodeObject: [NSNumber numberWithBool:permanentNpc] forKey:@"permanentNpc" ];
} 
//init a player from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    groundTile = [[coder decodeObjectForKey:@"groundTile"] intValue];
	groundAnimTile = [[coder decodeObjectForKey:@"groundAnimTile"] intValue];
	maskTile = [[coder decodeObjectForKey:@"maskTile"] intValue];
	maskAnimTile = [[coder decodeObjectForKey:@"maskAnimTile"] intValue];
	mask2Tile = [[coder decodeObjectForKey:@"mask2Tile"] intValue];
	mask2AnimTile = [[coder decodeObjectForKey:@"mask2AnimTile"] intValue];
	fringeTile = [[coder decodeObjectForKey:@"fringeTile"] intValue];
	fringeAnimTile = [[coder decodeObjectForKey:@"fringeAnimTile"] intValue];
	fringe2Tile = [[coder decodeObjectForKey:@"fringe2Tile"] intValue];
	fringe2AnimTile = [[coder decodeObjectForKey:@"fringe2AnimTile"] intValue];
	blocked = [[coder decodeObjectForKey:@"blocked"] boolValue];
	spawnNpc = [[coder decodeObjectForKey:@"spawnNpc"] intValue];
	permanentNpc = [[coder decodeObjectForKey:@"permanentNpc"] boolValue];
    return self;
}

-(void)dealloc {
	[super dealloc];
}
-(int) getTileOnLayer:(int)currentLayer {
	switch (currentLayer) {
		case 0:
			return groundTile;
			break;
		case 1:
			return groundAnimTile;
			break;
		case 2:
			return maskTile;
			break;
		case 3:
			return maskAnimTile;
			break;
		case 4:
			return mask2Tile;
			break;
		case 5:
			return mask2AnimTile;
			break;
		case 6:
			return fringeTile;
			break;
		case 7:
			return fringeAnimTile;
			break;
		case 8:
			return fringe2Tile;
			break;
		case 9:
			return fringe2AnimTile;
			break;
	}
	return 0;
}
-(void) setLayer:(int)currentLayer To:(int)tileNum {
	switch (currentLayer) {
		case 0:
			groundTile = tileNum;
			break;
		case 1:
			 groundAnimTile = tileNum;
			break;
		case 2:
			 maskTile = tileNum;
			break;
		case 3:
			 maskAnimTile = tileNum;
			break;
		case 4:
			 mask2Tile = tileNum;
			break;
		case 5:
			 mask2AnimTile = tileNum;
			break;
		case 6:
			 fringeTile = tileNum;
			break;
		case 7:
			 fringeAnimTile = tileNum;
			break;
		case 8:
			 fringe2Tile = tileNum;
			break;
		case 9:
			 fringe2AnimTile = tileNum;
			break;
	}
}

@end

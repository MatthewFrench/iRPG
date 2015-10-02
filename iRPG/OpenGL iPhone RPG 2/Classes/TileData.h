#import <UIKit/UIKit.h>
@class TileData;


@interface TileData : NSObject {
	BOOL blocked;
	int spawnNpc;
	BOOL permanentNpc;
	int groundTile;
	int groundAnimTile;
	int maskTile;
	int maskAnimTile;
	int mask2Tile;
	int mask2AnimTile;
	int fringeTile;
	int fringeAnimTile;
	int fringe2Tile;
	int fringe2AnimTile;
};
-(void) dealloc;
-(int) getTileOnLayer:(int)currentLayer;
-(void) setLayer:(int)currentLayer To:(int)tileNum;

@property(nonatomic) int groundTile,groundAnimTile,maskTile,maskAnimTile,mask2Tile,
mask2AnimTile,fringeTile,fringeAnimTile,fringe2Tile,fringe2AnimTile, spawnNpc;
@property(nonatomic) BOOL blocked, permanentNpc;

@end

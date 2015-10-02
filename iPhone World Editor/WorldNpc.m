#import "WorldNpc.h"

@implementation WorldNpc
@synthesize npcNum, hp, mp, originalMap,originalTile, currentMap, currentTile;
- (id)init 
{
	//if (self = [super init])
	return self;
}
//encode the npc data
- (void) encodeWithCoder: (NSCoder *)coder
{   
	[coder encodeObject: [NSNumber numberWithInt:npcNum] forKey:@"npcNum" ];
	[coder encodeObject: [NSNumber numberWithInt:hp] forKey:@"hp" ];
	[coder encodeObject: [NSNumber numberWithInt:mp] forKey:@"mp" ];
	[coder encodeObject: [NSNumber numberWithInt:originalMap] forKey:@"originalMap" ];
	[coder encodeObject: [NSNumber numberWithInt:originalTile.x] forKey:@"originalTile.x" ];
	[coder encodeObject: [NSNumber numberWithInt:originalTile.y] forKey:@"originalTile.y" ];
	[coder encodeObject: [NSNumber numberWithInt:currentMap] forKey:@"currentMap" ];
	[coder encodeObject: [NSNumber numberWithInt:currentTile.x] forKey:@"currentTile.x" ];
	[coder encodeObject: [NSNumber numberWithInt:currentTile.y] forKey:@"currentTile.y" ];
} 
//init a npc from a coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
	npcNum = [[coder decodeObjectForKey:@"npcNum"] intValue];
	hp = [[coder decodeObjectForKey:@"hp" ] intValue];
	mp = [[coder decodeObjectForKey:@"mp" ] intValue];
	originalMap = [[coder decodeObjectForKey:@"originalMap" ] intValue];
	originalTile.x = [[coder decodeObjectForKey:@"originalTile.x" ] intValue];
	originalTile.y = [[coder decodeObjectForKey:@"originalTile.y" ] intValue];
	currentMap = [[coder decodeObjectForKey:@"currentMap" ] intValue];
	currentTile.x = [[coder decodeObjectForKey:@"currentTile.x" ] intValue];
	currentTile.y = [[coder decodeObjectForKey:@"currentTile.y" ] intValue];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end

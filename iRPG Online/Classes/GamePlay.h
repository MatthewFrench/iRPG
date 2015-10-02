#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCCharacter.h"
@interface GamePlay : CCLayer {
	CCLayer* gameLayer,*hudLayer;
	CCTMXTiledMap *tileMap;
	CCTMXLayer *ground,*mask,*fringe;
	CCCharacter *hero;
	CCMenu *PauseButton;
	CCSpriteBatchNode *spriteSheet;
	
	CGPoint touchPos;
	BOOL moveTouch;
}
+(id) scene;
-(void)setViewpointCenter:(CGPoint) position;
- (CGPoint)coordinatesAtPosition:(CGPoint)point;
- (unsigned int)getGIDAtPosition:(CGPoint)point AtLayer:(CCTMXLayer*)layer;
- (void)updateWorld;
@end
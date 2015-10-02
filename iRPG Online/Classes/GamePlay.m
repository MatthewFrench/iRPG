//
//  GamePlay.m
//  iRPG Online
//
//  Created by Matthew French on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GamePlay.h"
#import "GameOver.h"
#import "PauseScene.h"

enum {
	kTagHero,
	kTagEnemy
};
@implementation GamePlay
+(id) scene {
	// ‘scene’ is an autorelease object.
	CCScene *scene = [CCScene node];
	// ‘layer’ is an autorelease object.
	GamePlay *layer = [GamePlay node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}
-(id) init {
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		
		spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Sprite Sheet.png"];
		
		hero = [CCCharacter spriteWithBatchNode:spriteSheet rect:CGRectMake(0,0,45,45)];
		//hero.anchorPoint = ccp(0,0);
		hero.position = ccp(45.0/2.0,45.0/2.0);
		[[hero texture] setAliasTexParameters];
		[spriteSheet addChild:hero z:0 tag:kTagHero];
		
		gameLayer = [CCLayer node];
		[self addChild:gameLayer z:0];

		hudLayer = [CCLayer node];
		[self addChild:hudLayer z:1];
		
		CCMenuItem *Pause = [CCMenuItemImage
							 itemFromNormalImage:@"pausebutton.png" 
							 selectedImage: @"pausebutton.png"
							 target:self selector:@selector(pause:)];
		PauseButton = [CCMenu menuWithItems: Pause, nil];
		PauseButton.position = ccp(25, 295);
		[hudLayer addChild:PauseButton z:0];

		tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"World Map.tmx"];
		for( CCSpriteBatchNode* child in [tileMap children] ) {
			[[child texture] setAliasTexParameters];
		}
		tileMap.anchorPoint = ccp(0,0);
		tileMap.position = ccp(0,0);
		ground = [tileMap layerNamed:@"Ground"];
		mask = [tileMap layerNamed:@"Mask"];
		fringe = [tileMap layerNamed:@"Fringe"];
		[gameLayer addChild:tileMap z:-1];
		
		[tileMap reorderChild:ground z:1];
		[tileMap reorderChild:mask z:2];
		[tileMap addChild:spriteSheet z:3];
		[tileMap reorderChild:fringe z:4];
		
		[self setViewpointCenter:hero.position];
		
		moveTouch = FALSE;
		
		[self schedule:@selector(updateWorld) interval:1.0/60.0];
	}
	return self;
}
- (void)updateWorld {
	NSLog(@"%f %f",hero.position.x,hero.position.y);
	
	if (moveTouch && !hero.moving) {
		CGPoint point = touchPos;
		//Add scene pos to it.
		point = [tileMap convertToNodeSpace:point];
		BOOL move = FALSE;
		
		CGPoint addPos = CGPointMake(0, 0);
		if (point.x > hero.position.x + tileMap.tileSize.width) {
			addPos.x += tileMap.tileSize.width;
			move = TRUE;
		} else if (point.x < hero.position.x - tileMap.tileSize.width) {
			addPos.x -= tileMap.tileSize.width; 
			move = TRUE;
		}    
		if (point.y > hero.position.y + tileMap.tileSize.height) {
			addPos.y += tileMap.tileSize.height;
			move = TRUE;
		} else if (point.y < hero.position.y - tileMap.tileSize.height) {
			addPos.y -= tileMap.tileSize.height;
			move = TRUE;
		}
		CGPoint newPos = ccpAdd(addPos, hero.position);
		
		unsigned int groundTile = [self getGIDAtPosition:newPos AtLayer:ground];
		unsigned int maskTile = [self getGIDAtPosition:newPos AtLayer:mask];
		
		NSDictionary* groundTileProp = [tileMap propertiesForGID:groundTile];
		if ([[groundTileProp objectForKey:@"blocked"] isEqualToString:@"yes"]) {move = FALSE;}
		NSDictionary* maskTileProp = [tileMap propertiesForGID:maskTile];
		if ([[maskTileProp objectForKey:@"blocked"] isEqualToString:@"yes"]) {move = FALSE;}
		
		if (move) {
			hero.moving = TRUE;
			id moveAction = [CCMoveTo actionWithDuration:1.0/4.0 position:newPos];
			[moveAction setTag:1];
			[hero runAction: [CCSequence actions:moveAction, [CCCallFunc actionWithTarget:hero selector:@selector(finishedMove)], nil]];
			hero.endPosition = newPos;
			//[hero runAction:moveAction];
			//hero.position = newPos;
			[self setViewpointCenter:newPos];
		}
	}
}
-(void) pause: (id) sender {
	
	[[CCDirector sharedDirector] pushScene:[PauseScene node]];
}
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *myTouch = [touches anyObject];
	CGPoint point = [myTouch locationInView:[myTouch view]];
	//Flip for Gl coord
	point = [[CCDirector sharedDirector] convertToGL:point];
	moveTouch = TRUE;
	touchPos = point;
}
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *myTouch = [touches anyObject];
	CGPoint point = [myTouch locationInView:[myTouch view]];
	//Flip for Gl coord
	point = [[CCDirector sharedDirector] convertToGL:point];
	touchPos = point;
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *myTouch = [touches anyObject];
	CGPoint point = [myTouch locationInView:[myTouch view]];
	//Flip for Gl coord
	point = [[CCDirector sharedDirector] convertToGL:point];
	touchPos = point;
	moveTouch = FALSE;
}

- (void)setViewpointCenter:(CGPoint)point {
	CGPoint centerPoint = ccp(240, 160);
	CGPoint viewPoint = ccpSub(centerPoint, point);
	
	// dont scroll so far so we see anywhere outside the visible map which would show up as black bars
	if(point.x < centerPoint.x)
		viewPoint.x = 0;
	if(point.y < centerPoint.y)
		viewPoint.y = 0;
	if(point.x > tileMap.mapSize.width*tileMap.tileSize.width - centerPoint.x)
		viewPoint.x = -tileMap.mapSize.width*tileMap.tileSize.width + centerPoint.x*2;
	if(point.y > tileMap.mapSize.height*tileMap.tileSize.height - centerPoint.y)
		viewPoint.y = -tileMap.mapSize.height*tileMap.tileSize.height + centerPoint.y*2;
	// while zoomed out, don't adjust the viewpoint
	//if(!isZoomedOut)
	id moveAction = [CCMoveTo actionWithDuration:1.0/4.0 position:viewPoint];
	[gameLayer runAction:moveAction];
		//gameLayer.position = viewPoint;
}
- (CGPoint)coordinatesAtPosition:(CGPoint)point {
	CGPoint pos = ccp((int)(point.x / tileMap.tileSize.width), (int)(tileMap.mapSize.height - (point.y / tileMap.tileSize.height)));
	return pos;
	//return ccp((int)(point.x / tileMap.tileSize.width), (int)(point.y / tileMap.tileSize.height));
}

- (unsigned int)getGIDAtPosition:(CGPoint)point AtLayer:(CCTMXLayer*)layer {
	return [layer tileGIDAt:[self coordinatesAtPosition:point]];
}
/**
-(void) SpritesDidCollide {
	
	CCNode *enemy = [self getChildByTag:kTagEnemy];
	CCNode *hero = [self getChildByTag:kTagHero];
	
	if (distance < 45) {
		[self unschedule:@selector(SpritesDidColide)];
		[[CCDirector sharedDirector]
		 replaceScene:
		 [CCTransitionFade
		  transitionWithDuration:1
		  scene:[GameOver node]
		  ]];
	}
	
}
 **/
@end

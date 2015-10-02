//
//  CCCharacter.h
//  iRPG Online
//
//  Created by Matthew French on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@interface CCCharacter : CCSprite {
	int moveCount;
	CGPoint endPosition;
	BOOL moving;
}
@property(nonatomic) int moveCount;
@property(nonatomic) CGPoint endPosition;
@property(nonatomic) BOOL moving;

- (void)finishedMove;

@end

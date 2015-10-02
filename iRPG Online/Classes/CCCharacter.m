//
//  CCCharacter.m
//  iRPG Online
//
//  Created by Matthew French on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCCharacter.h"


@implementation CCCharacter
@synthesize endPosition, moveCount, moving;
- (void)finishedMove {
	moving = FALSE;
}
@end

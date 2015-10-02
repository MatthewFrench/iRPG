#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Image.h"
@class DamageEffect;


@interface DamageEffect : NSObject {
	//*****Npc Vars***
	CGPoint tilePosition;
	int mapPosition;
	NSString* text;
	Image* textImage;
	float ticks,ticksMax, offSet;
};
-(void) dealloc;

@property(nonatomic, retain) NSString* text;
@property(nonatomic, retain) Image* textImage;
@property(nonatomic) CGPoint tilePosition;
@property(nonatomic) float ticks,ticksMax,offSet;
@property(nonatomic) int mapPosition;
@end

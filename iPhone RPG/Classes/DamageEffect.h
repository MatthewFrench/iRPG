#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DamageEffect;


@interface DamageEffect : NSObject {
	//*****Npc Vars***
	CGPoint position;
	NSString* text;
	float ticks,ticksMax;
};
-(void) dealloc;

@property(nonatomic, retain) NSString* text;
@property(nonatomic) CGPoint position;
@property(nonatomic) float ticks,ticksMax;
@end

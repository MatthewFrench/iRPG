#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SpellEffect;


@interface SpellEffect : NSObject {
	//*****Npc Vars***
	CGPoint position1;
	CGPoint position2;
	float rotation;
	int spellType,ticks,ticksMax,animNum, touchNum;
	NSMutableArray* spellAnim;
};
-(void) dealloc;

@property(nonatomic) CGPoint position1, position2;
@property(nonatomic) float rotation;
@property(nonatomic) int spellType,ticks,ticksMax,animNum, touchNum;
@property(nonatomic, retain) NSMutableArray* spellAnim;
@end

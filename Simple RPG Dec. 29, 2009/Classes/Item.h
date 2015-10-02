#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Item;


@interface Item : NSObject {
	//*****Npc Vars***
	CGPoint position;
	int itemnum;
};
-(void) dealloc;

@property(nonatomic) CGPoint position;
@property(nonatomic) int itemnum;

@end

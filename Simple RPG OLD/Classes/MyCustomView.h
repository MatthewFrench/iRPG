#import <UIKit/UIKit.h>

@interface MyCustomView : UIView
{
	//CGFloat                    squareSize;
	//CGFloat                    rotation;
	//CGFloat squareX;
	//CGFloat squareY;
	//CGColorRef                 aColor;
	//*****PREPARE VARIABLES FOR IMAGE
	NSString* imagePath;
	UIImage* myImageObj;
	//***END PREPARE VARIABLES FOR IMAGE
	//*****Player Vars***
	CGPoint playerPos;
	NSString* playerImagePath;
	UIImage* myPlayerImageObj;
	BOOL                       twoFingers;
	
	//IBOutlet UILabel           *squareR;
	//IBOutlet UILabel           *touchX;
	//IBOutlet UILabel           *touchY;
	//IBOutlet UILabel           *squareXval;
	//IBOutlet UILabel           *squareYval;
}

@end
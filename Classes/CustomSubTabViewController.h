//
//  CustomSubTabViewController.h
//  MobileKate2.0_iPad
//
//  Created by nicejin on 11. 3. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileKate2_0_iPadAppDelegate.h"
//#import "MainMenuController.h"
#import "Communication.h"

@interface CustomSubTabViewController : UIViewController<CommunicationDelegate, UIAlertViewDelegate> {
	UIView *dataView;
	
	UIScrollView *tabScrollView;
	UIImageView *leftArrowImage;
	UIImageView *rightArrowImage;
	IBOutlet UIButton *btn_menu_1;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *dateLabel;
    
    Communication *cm;
}

//--- button action ---//
-(IBAction)button_action:(id)sender;
-(void)changeContentsMenu;

//--- view outlet ---//
@property (nonatomic, retain) IBOutlet UIView *dataView;
@property (nonatomic, retain) IBOutlet UIScrollView *tabScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *leftArrowImage;
@property (nonatomic, retain) IBOutlet UIImageView *rightArrowImage;

-(void)AIACallInSub:(int)tagNum;

@end

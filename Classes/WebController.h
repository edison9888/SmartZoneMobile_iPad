//
//  WebController.h
//  MobileKate2.0_iPad
//
//  Created by nicejin on 11. 3. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clipboard.h"
#import "CustomSubTabViewController.h"

@class CustomSubTabViewController;

@interface WebController : UIViewController<UIWebViewDelegate> {

	IBOutlet UIWebView *contentWebView;
	CustomSubTabViewController  *tabBarViewController;
	UIView *menuTabbarView;
	IBOutlet UILabel *toolBarTitle;
	
	IBOutlet UIToolbar *mToolbar;

	IBOutlet UIActivityIndicatorView *indicator;

	IBOutlet UISegmentedControl *segmentControl;
	IBOutlet UIView *contentFrameView;
	
	IBOutlet UIButton *hiddenButton;
	
}

-(void)createViewControllers;
-(IBAction) backForwardButtonClicked:(id)sender;
-(IBAction) returnHomeAction;
-(IBAction) candyHomeButton:(id)sender;

@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property (nonatomic, retain) UIWebView *contentWebView;
@property (nonatomic, retain) CustomSubTabViewController *tabBarViewController;
@property (nonatomic, retain) IBOutlet UIView *contentFrameView;
@property (nonatomic, retain) IBOutlet UIButton *hiddenButton;

@end

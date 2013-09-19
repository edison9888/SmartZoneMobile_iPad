//
//  eisWebViewController.h
//  MobileKate2.0_iPad
//
//  Created by Baek Kyung Wook on 11. 11. 29..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clipboard.h"

@interface eisWebViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *contentWebView;
    IBOutlet UILabel *toolBarTitle;
    
    IBOutlet UIToolbar *mToolbar;
    
    IBOutlet UIActivityIndicatorView *indicator;
    
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UIView *contentFrameView;
    
    IBOutlet UIButton *hiddenButton;

	UIBarButtonItem *temporaryBarButtonItem;
    UIBarButtonItem *flexible;
    UIBarButtonItem *menuBarButtonItem;
    UIBarButtonItem *segmentBarItem;
    
    NSArray *arr_segTmp;

    
    
    
}
-(void)createViewControllers;
-(IBAction) backForwardButtonClicked:(id)sender;
-(IBAction) returnHomeAction;
-(IBAction) candyHomeButton:(id)sender;

@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIWebView *contentWebView;
@property (nonatomic, retain) IBOutlet UIView *contentFrameView;
@property (nonatomic, retain) IBOutlet UIButton *hiddenButton;


@end

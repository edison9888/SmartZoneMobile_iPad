//
//  QnAWriteViewController.h
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface QnAWriteViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, CommunicationDelegate> {
	
	IBOutlet UIBarButtonItem *writeButton;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UILabel *titleNavigationBar;
	
	IBOutlet UITextField *titleField;
	IBOutlet UITextView *contentView;
	
	NSString *contentIndex;
	NSInteger writeMode;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	UIAlertView *indicatorAlert;
	IBOutlet UILabel *placeholderLabel;
	IBOutlet UIButton *backgroundButton;
	
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *writeButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
@property(nonatomic,retain) IBOutlet UILabel *titleNavigationBar;

@property(nonatomic,retain) IBOutlet UITextField *titleField;
@property(nonatomic,retain) IBOutlet UITextView *contentView;

@property(nonatomic,retain) NSString *contentIndex;
@property(nonatomic,assign) NSInteger writeMode;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) UIAlertView *indicatorAlert;
@property(nonatomic,retain) IBOutlet UILabel *placeholderLabel;
@property(nonatomic,retain) IBOutlet UIButton *backgroundButton;

-(IBAction) writeButtonClicked;
-(IBAction) backButtonClicked;

-(IBAction) resignResponder;

@end

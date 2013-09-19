//
//  FAQCommentWriteViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 7. 3..
//  Copyright 2011 Insang. All rights reserved.
//

// ***************************************************
// 미사용 클래스!!!
// ***************************************************

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface FAQCommentWriteViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, CommunicationDelegate> {
	
	IBOutlet UIBarButtonItem *writeButton;
	IBOutlet UIBarButtonItem *backButton;
	//IBOutlet UILabel *titleNavigationBar;
	
	IBOutlet UITextField *titleField;
	
	IBOutlet UILabel *nicknameLabel;
	IBOutlet UITextField *nicknameField;
	/*
	IBOutlet UILabel *passwordLabel;
	IBOutlet UITextField *passwordField;
	*/
	
	//IBOutlet UISwitch *prioritySwitch;
	IBOutlet UISwitch *nicknameSwitch;
	
	IBOutlet UILabel *contentsLabel;
	
	BOOL nicknameFlag;
	
	IBOutlet UITextView *contentView;
	
	NSString *contentIndex;
	//NSInteger writeMode;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	UIAlertView *indicatorAlert;
	IBOutlet UILabel *placeholderLabel;
	IBOutlet UIButton *backgroundButton;
	
	NSString *boardId;
	NSString *bullId;
	
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *writeButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
//@property(nonatomic,retain) IBOutlet UILabel *titleNavigationBar;

@property(nonatomic,retain) IBOutlet UITextField *titleField;

@property(nonatomic,retain) IBOutlet UILabel *nicknameLabel;
@property(nonatomic,retain) IBOutlet UITextField *nicknameField;
/*
@property(nonatomic,retain) IBOutlet UILabel *passwordLabel;
@property(nonatomic,retain) IBOutlet UITextField *passwordField;
*/

//@property(nonatomic,retain) IBOutlet UISwitch *prioritySwitch;
@property(nonatomic,retain) IBOutlet UISwitch *nicknameSwitch;

@property(nonatomic,retain) IBOutlet UILabel *contentsLabel;

@property(nonatomic,retain) IBOutlet UITextView *contentView;

@property(nonatomic,retain) NSString *contentIndex;
//@property(nonatomic,assign) NSInteger writeMode;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) UIAlertView *indicatorAlert;
@property(nonatomic,retain) IBOutlet UILabel *placeholderLabel;
@property(nonatomic,retain) IBOutlet UIButton *backgroundButton;

@property (nonatomic, retain) NSString *boardId;
@property (nonatomic, retain) NSString *bullId;

-(IBAction) writeButtonClicked;
-(IBAction) backButtonClicked;

-(IBAction) resignResponder;

//-(IBAction) prioritySwitchChanged:(id)sender;
-(IBAction) nicknameSwitchChanged:(id)sender;

-(void) resetInputFields;

@end

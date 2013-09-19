//
//  FAQCommentViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 7. 6..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Communication.h"

#define NONE_COMMENT 0
#define WRITE_COMMENT 1
#define DELETE_COMMENT 2

@interface FAQCommentViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, CommunicationDelegate, UITableViewDelegate, UITableViewDataSource> {

	//IBOutlet UITextField *titleField;
	IBOutlet UITextField *nicknameField;
	IBOutlet UISwitch *nicknameSwitch;
	
	IBOutlet UITableView *commentTableView;
	IBOutlet UITableViewCell *noContentsCell;
	
	//IBOutlet UILabel *contentsLabel;
	
	BOOL nicknameFlag;
	int commentIndex;
	
	IBOutlet UITextView *contentView;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	UIAlertView *indicatorAlert;
	
	NSString *boardId;
	NSString *bullId;
	
	NSArray *commentArray;
	
	int communicationFlag;
	
}

//@property(nonatomic,retain) IBOutlet UITextField *titleField;
@property(nonatomic,retain) IBOutlet UITextField *nicknameField;
@property(nonatomic,retain) IBOutlet UISwitch *nicknameSwitch;
@property(nonatomic,retain) IBOutlet UITableView *commentTableView;

//@property(nonatomic,retain) IBOutlet UILabel *contentsLabel;
@property(nonatomic,retain) IBOutlet UITextView *contentView;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) UIAlertView *indicatorAlert;

@property (nonatomic, retain) NSString *boardId;
@property (nonatomic, retain) NSString *bullId;

@property (nonatomic, retain) NSArray *commentArray;
@property (nonatomic, assign) int commentIndex;

-(IBAction) writeButtonClicked;
-(IBAction) backButtonClicked;
-(IBAction) resignResponder;

-(IBAction) nicknameSwitchChanged:(id)sender;

@end

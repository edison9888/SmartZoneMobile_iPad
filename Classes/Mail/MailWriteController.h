//
//  MailWriteController.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 20..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "ContactModel.h"
#import "CalendarModel.h"
#import "ContentCell.h"
@interface MailWriteController :UIViewController <UITableViewDelegate, UITableViewDataSource, CommunicationDelegate, UIActionSheetDelegate, UITextViewDelegate, ContentCellDelegate> {
	UITableView *contentTableView;
	UITextView *contentTextView;
	UIScrollView *contentScrollView;
	UITableViewCell *mainContentCell;
	UITableViewCell *toCell;
	UITableViewCell *ccCell;
	UITableViewCell *bccCell;
	UITableViewCell *titleCell;
	NSMutableArray *toRecipientList;
	NSMutableArray *ccRecipientList;
	NSMutableArray *bccRecipientList;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	ContactModel *contactModel;	
	CalendarModel *model;
	
	
	NSString *contentIndex;
	
	CGFloat keyboardHeight;
	UITextField *subjectField;
	UILabel *torecipientsLabel;
	UILabel *ccrecipientsLabel;
	UILabel *bccrecipientsLabel;
	NSString *toRecipientString;
	UIAlertView *indicatorAlert;
	UILabel *titleNavigationBar;
	UIScrollView *contentScrolView;
	UIView *activeView;
	int CustomTextViewHeight;
	ContentCell *contentCell;
	NSRange textviewFocus;
    BOOL attachment;
    NSString *mailID;
    NSMutableArray *attachmentFileArray;//포워딩 시 첨부 표시 해주기 위해 
    BOOL contactMode;
}
@property(nonatomic,retain) NSString *contentIndex;

@property(nonatomic,retain) IBOutlet UITableView *contentTableView;
@property(nonatomic,retain) IBOutlet 	UITextView *contentTextView;
@property(nonatomic, retain) NSString *toRecipientString;

@property(nonatomic,retain) IBOutlet UILabel *titleNavigationBar;
@property(nonatomic,retain) IBOutlet UIScrollView *contentScrollView;
@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *toCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *ccCell;
@property(nonatomic, retain)IBOutlet UITableViewCell *bccCell;
@property(nonatomic, retain)IBOutlet UITableViewCell *titleCell;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableArray *toRecipientList;	// 받는사람
@property (nonatomic, retain) NSMutableArray *ccRecipientList;
@property (nonatomic, retain) NSMutableArray *bccRecipientList;


@property(nonatomic,retain) IBOutlet UITextField *subjectField;
@property(nonatomic,retain) IBOutlet UILabel *torecipientsLabel;

@property(nonatomic,retain) IBOutlet UILabel *ccrecipientsLabel;
@property(nonatomic,retain) IBOutlet UILabel *bccrecipientsLabel;
@property(nonatomic,retain) UIAlertView *indicatorAlert;
@property(nonatomic, assign) NSRange textviewFocus;
@property(nonatomic, assign) BOOL contactMode;
@property(nonatomic,retain) IBOutlet 	UIScrollView *contentScrolView;
@property(nonatomic, assign)int CustomTextViewHeight;
@property(nonatomic,retain) ContentCell *contentCell;
@property(nonatomic, assign) BOOL attachment;
@property (nonatomic, retain) NSString *mailID;
@property(nonatomic,retain) NSMutableArray *attachmentFileArray;

-(IBAction) writeButtonClicked;
-(IBAction) backButtonClicked;
-(IBAction)showActionSheet;
-(void)mailForwardfileArray:(NSMutableArray *)fileArrayList;

- (void)resizeViews;
@end

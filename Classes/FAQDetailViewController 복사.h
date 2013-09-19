//
//  FAQDetailViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

// flag for delegate
#define NO_ACT 0
#define AGREE 1
#define DISAGREE 2
#define DELETE_COMMENT 3
#define DELETE_FAQ 4
#define DELETE_REGISTRANT_FAQ 5
#define CHECK_PASSWORD 6

@class CustomSubTabViewController;
@class FAQListViewController;

@interface FAQDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CommunicationDelegate> {

	UIPopoverController *popoverController;
	UIToolbar *toolbar;
	
	NSNotificationCenter *noti;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;	
	
	UIView *menuTabbarView;
	CustomSubTabViewController *subMenu;
	
	FAQListViewController *listView;
	
	UITableView *contentTableView;
	UITableViewCell *mainContentCell;
	UITableViewCell *titleCell;
	UITableViewCell *nameCell;
	UITableViewCell *answarLineCell;
	
	NSDictionary *contentDictionary;
	NSDictionary *resultDictionary;
	
	NSString *boardId;
	NSString *orderBy;
	NSString *sortBy;
	
	NSString *bullid;
	
	//IBOutlet UIBarButtonItem *commentBarButton;
	IBOutlet UIBarButtonItem *deleteBarButton;
	
	int delegate_flag;
	int commentIndex;
	
	IBOutlet UIImageView *imageView;
	
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property(nonatomic,retain) CustomSubTabViewController *subMenu;
@property(assign) FAQListViewController *listView;

@property(nonatomic,retain) IBOutlet UITableView *contentTableView;

@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *titleCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *nameCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *answarLineCell;

@property(nonatomic,retain) NSDictionary *contentDictionary;
@property(nonatomic,retain) NSDictionary *resultDictionary;

@property (nonatomic, retain) NSString *boardId;
@property (nonatomic, retain) NSString *orderBy;
@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSString *bullid;

@property (nonatomic, assign) int delegate_flag;
@property (nonatomic, assign) int commentIndex;

-(IBAction) mainButtonClicked;

-(IBAction) yesButtonClicked;
-(IBAction) noButtonClicked;
-(IBAction) replyButtonClicked;
-(IBAction) commentButtonClicked;

-(void) popForFirstAppear;
-(void) popoverDismiss;

-(void) loadDetailContentAtIndex:(NSString *)index;
-(void) loadDetailContent;

-(BOOL)checkPassword:(NSString *)password;
- (IBAction)clickedDeleteComment:(id)sender;
- (IBAction)clickedDeleteFaq;

@end

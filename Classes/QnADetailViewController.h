//
//  QnADetailViewController.h
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

// flag for delegate
#define NO_ACT 0
#define INSERT_ANSWER 1
#define DELETE_ANSWER 2
#define CHOOSE_ANSWER 3
#define DELETE_QUSETION 4

@class CustomSubTabViewController;

@interface QnADetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,
												UITableViewDelegate, UITableViewDataSource,
												UIWebViewDelegate, CommunicationDelegate> {

    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
	UIBarButtonItem *mainButton;
	UIImageView *imageView;
	UIBarButtonItem *answarButton;
	UIBarButtonItem *deleteButton;
	
	UITableView *contentTableView;
	
	UITableViewCell *mainContentCell;
	UITableViewCell *titleCell;
	UITableViewCell *nameCell;
	UITableViewCell *answarLineCell;
	NSNotificationCenter *noti;
													
	NSDictionary *contentDictionary;
	UIAlertView *progressAlert;
	UIActivityIndicatorView *progressIndicator;
	
	NSString *itemid;
	int delegate_flag;
	int delete_id;
	int select_id;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;	
													
	UIView *menuTabbarView;
	CustomSubTabViewController *subMenu;

}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *answarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UITableView *contentTableView;

@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *titleCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *nameCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *answarLineCell;

@property(nonatomic,retain) NSDictionary *contentDictionary;
@property(nonatomic,retain) UIAlertView *progressAlert;
@property(nonatomic,retain) UIActivityIndicatorView *progressIndicator;

@property(nonatomic,retain) NSString *itemid;
@property(nonatomic,assign) int delegate_flag;
@property(nonatomic,assign) int delete_id;
@property(nonatomic,assign) int select_id;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property(nonatomic,retain) CustomSubTabViewController *subMenu;

-(IBAction) mainButtonClicked;
-(IBAction) answarButtonClicked;
-(IBAction) deleteButtonClicked;
-(void) loadDetailContentAtIndex:(NSString *)index;
-(void) reloadDetailContent;
-(void) popForFirstAppear;
-(void) popoverDismiss;

@end

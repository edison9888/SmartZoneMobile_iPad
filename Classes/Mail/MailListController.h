//
//  MailListController.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 19..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"
#import "MobileKate2_0_iPadAppDelegate.h"
#define num_pageSize 20
@class OverlayViewController;
@class MailDetailController;
@class SplitOverlayViewController;
@interface MailListController : UIViewController<UITableViewDelegate, UITableViewDataSource> {

    MailDetailController *detailViewController;
    MobileKate2_0_iPadAppDelegate *appDelegate;
	NSUserDefaults *userDefault;
	NSMutableArray *mailList;
	
	UITableView *currentTableView;
	UIActivityIndicatorView *indicator;
	
	IBOutlet UITableViewCell *nextCell;
	IBOutlet UIButton *nextCellButton;
	int num_pageNum;

	int result_totalCount;
	int result_totalPage;
	BOOL mode_search;

	BOOL mode_nextCell;
	BOOL mode_edit;
	BOOL mode_oneRowDelete;
	BOOL mode_unRead;
	BOOL mode_reset;

	
	NSIndexPath *oneRowDeleteIndex;

	Communication *cm;
	UIBarButtonItem  *temporaryBarRightButtonItem;
	UIToolbar *editModeToolbar;

	NSString *folderID;
	NSMutableArray *selectedRows;
	
	OverlayViewController *ovController;
    SplitOverlayViewController *splitOverlayViewController;
	UISearchBar *mailSearchBar;
	NSString *searchStype;
	UIBarButtonItem *refreshBarButton;
    NSString *detailMailID;
	
    NSNotificationCenter *noti;
}

-(void) loadDetailContentAtIndex:(NSString *)index;
-(IBAction)action_nextCell:(id)sender;
-(IBAction) writeButtonClicked ;
-(void) loadMoreListComm;
-(IBAction) trashButtonClicked;
- (void) doneSearching_Clicked:(id)sender;
-(IBAction)resetListClicked;
-(IBAction)mailBoxClicked;
-(IBAction) unReadButtonClicked;
-(IBAction)mailMove;
- (void)overlayView;
-(void)tableUpdate;

@property (nonatomic, assign) MobileKate2_0_iPadAppDelegate *appDelegate;

@property (nonatomic, retain) NSUserDefaults *userDefault;
@property (nonatomic, retain) NSMutableArray *mailList;
@property (nonatomic, retain) IBOutlet UITableView *currentTableView;
@property (nonatomic) int	num_pageNum;

@property (nonatomic) int	result_totalCount;
@property (nonatomic) int	result_totalPage;
@property (nonatomic) BOOL mode_nextCell;
@property (nonatomic) BOOL mode_reset;

@property (nonatomic, retain)	NSString *folderID;
@property (nonatomic, retain)	UIBarButtonItem  *temporaryBarRightButtonItem;
@property (nonatomic, retain) IBOutlet UIToolbar *editModeToolbar;

@property (nonatomic, retain)	NSMutableArray *selectedRows;

@property (nonatomic) BOOL mode_edit;
@property (nonatomic) BOOL mode_search;
@property (nonatomic) BOOL mode_oneRowDelete;
@property (nonatomic) BOOL mode_unRead;	
@property (nonatomic, retain) NSIndexPath *oneRowDeleteIndex;


@property (nonatomic, retain) OverlayViewController *ovController;
@property (nonatomic, retain) SplitOverlayViewController *splitOverlayViewController;

@property (nonatomic, retain) IBOutlet UISearchBar *mailSearchBar;
@property (nonatomic, retain) NSString *searchStype;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *refreshBarButton;
@property (nonatomic, retain) IBOutlet MailDetailController *detailViewController;
@property (nonatomic, retain) NSString *detailMailID;
@end



		
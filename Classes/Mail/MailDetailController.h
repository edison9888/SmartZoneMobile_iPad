//
//  MailDetailController.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 24..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "ContactModel.h"
//#import "MailListController.h"
@class CustomSubTabViewController;


@interface MailDetailController : UIViewController <UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, CommunicationDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate>  {
    
	UIWebView *contentWebView;	
	UITableView *contentTableView;
	
	NSDictionary *contentDictionary;
	BOOL currentRowShowMode;
	UITableViewCell *mainContentCell;
	UITableViewCell *titleCell;
	UITableViewCell *nameCell;
	UITableViewCell *toNameCell;
	UITableViewCell *ccCell;
    UITableViewCell *isInlineCell;
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	CGFloat webViewHeight;
	int webviewLoadFlag; // 0 = make table load, 1 = start load
	NSURL *webopen;
	
	NSMutableString *contentString;
	NSMutableArray *currentTableList;
	UISegmentedControl *segmentedControl;
	int currentRow;
	int clientHeight;
	int clientWidth;
	BOOL mode_trash;
	BOOL mode_unRead;
    
	UIBarButtonItem *trashButton;
	UIButton *markUnRead;
	UIImageView *markUnReadImage;
	ContactModel *contactModel;	
    NSMutableArray *attachmentArray;
    NSMutableArray *attachmentFileArray;
    
    int isInLineIndex;
    int isInLineCountIndex;
    BOOL isInLineMode;
    NSString *realMailBody;
    NSString *isInLineMailBody;
    int isInLineEnable;
    
    NSFileHandle *handle;
    int receivedLength;
    NSMutableData *receivedData;
    NSNumber *filesize;
    UIProgressView *progressView;
    
    NSString *folderID;
    //ipad
    UIPopoverController *popoverController;
	UIToolbar *mailToolbar;
    
	UIBarButtonItem *mainButton;
    UIBarButtonItem *listButton;

	UIImageView *imageView;
    UIView *menuTabbarView;
	CustomSubTabViewController *subMenu;
    NSNotificationCenter *noti;
    BOOL imageViewHiddenMode;
//    MailListController *mailListController;
    UILabel *toolbarLabel;

    
    NSString *detailRowType;
    BOOL detailRowBool;
    UIButton *detailRowButton;
    UIButton *hideRowButton;


}
@property (nonatomic, retain)	NSString *folderID;
@property(nonatomic,assign) BOOL currentRowShowMode;
@property(nonatomic,retain) IBOutlet UIWebView *contentWebView;
@property(nonatomic,retain) IBOutlet UITableView *contentTableView;

@property(nonatomic,retain) NSDictionary *contentDictionary;

@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *titleCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *nameCell;
@property(nonatomic, retain)IBOutlet UITableViewCell *toNameCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *ccCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *isInlineCell;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

@property(nonatomic,assign) CGFloat webViewHeight;
@property(nonatomic,assign) int webviewLoadFlag;

@property(nonatomic,retain) NSURL *webopen;

@property(nonatomic,retain) NSMutableString *contentString;

@property(nonatomic,assign) int clientHeight;
@property(nonatomic,assign) int clientWidth;
@property(nonatomic,retain) NSMutableArray *currentTableList;
@property(nonatomic,assign) int currentRow;
@property(nonatomic,retain) UISegmentedControl *segmentedControl;
@property (nonatomic) BOOL mode_trash;
@property (nonatomic) BOOL mode_unRead;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *trashButton;
@property(nonatomic,retain) IBOutlet UIButton *markUnRead;
@property(nonatomic,retain) IBOutlet UIImageView *markUnReadImage;
@property(nonatomic,retain) NSMutableArray *attachmentArray;
@property(nonatomic,retain) NSMutableArray *attachmentFileArray;

@property(nonatomic,assign) int isInLineIndex;
@property(nonatomic,assign) int isInLineCountIndex;
@property(nonatomic,assign)BOOL isInLineMode;
@property(nonatomic,retain) NSString *realMailBody;
@property(nonatomic,retain) NSString *isInLineMailBody;
@property(nonatomic,assign) int isInLineEnable;

@property(nonatomic,retain) NSFileHandle *handle;
@property(nonatomic,assign) int receivedLength;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSNumber *filesize;
@property(nonatomic, retain) UIProgressView *progressView;
//ipad
@property (nonatomic, retain) IBOutlet UIToolbar *mailToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *listButton;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property(nonatomic,retain) CustomSubTabViewController *subMenu;
@property(nonatomic,assign)BOOL imageViewHiddenMode;
//@property(nonatomic,retain)    MailListController *mailListController;
@property(nonatomic,retain) IBOutlet UILabel *toolbarLabel;





@property(nonatomic, retain) NSString *detailRowType;
@property(nonatomic,assign) BOOL detailRowBool;
@property(nonatomic, retain) IBOutlet UIButton *detailRowButton;
@property(nonatomic, retain) IBOutlet UIButton *hideRowButton;

-(void) loadDetailContentTableList:(NSMutableArray *)tableList forIndexPath:(int)indexPathRow folderID:(NSString *)forderIdString;
-(IBAction)showActionSheet:(id)sender;
-(IBAction) writeButtonClicked;
-(IBAction) trashButtonClicked;
-(IBAction) markUnReadClcked;
-(void) loadAttachmentMailID:(NSString *)mailID attachmentIndex:(NSString *)index;
//ipad
-(IBAction) mainButtonClicked;
-(void) popForFirstAppear;
//-(void) loadDetailContentAtIndex:(NSInteger)index;
-(void) popoverDismiss;
-(void)imagehidden;
-(void)loadDetailTableList:(NSMutableArray *)tableList;
@end

//
//  NoticeDetailViewController.h
//  MKate_iPad
//
//  Created by park on 11. 2. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@class CustomSubTabViewController;

@interface BoardDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, CommunicationDelegate> {


	UIPopoverController *popoverController;
	UIToolbar *toolbar;
    
	UIBarButtonItem *mainButton;
	UIImageView *imageView;
	// added by kwbaek
	NSNotificationCenter *noti;
	/*
	UILabel *titleLabel;
	UILabel *nameLabel;
	UILabel *timeLabel;
	UIWebView *contentWebView;
	 */
	UITableView *contentTableView;
	
	NSDictionary *contentDictionary;
	
	UITableViewCell *mainContentCell;
	UITableViewCell *titleCell;
	UITableViewCell *nameCell;
	
	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	CGFloat webViewHeight;
	int webviewLoadFlag; // 0 = make table load, 1 = start load, 2 = load ended
	
	UIView *menuTabbarView;
	CustomSubTabViewController *subMenu;
    
    NSMutableArray *attachmentArray;
	
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
/*
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIWebView *contentWebView;
*/

@property(nonatomic,retain) IBOutlet UITableView *contentTableView;

@property(nonatomic,retain) NSDictionary *contentDictionary;

@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *titleCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *nameCell;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) NSMutableArray *attachmentArray;

@property(nonatomic,assign) CGFloat webViewHeight;
@property(nonatomic,assign) int webviewLoadFlag;
@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property(nonatomic,retain) CustomSubTabViewController *subMenu;

-(void) loadDetailContentAtIndex:(NSString *)index forCategory:(NSString *)category;
-(IBAction) mainButtonClicked;
-(void) popForFirstAppear;
//-(void) loadDetailContentAtIndex:(NSInteger)index;
-(void) popoverDismiss;
-(void) resetContent;
@end

//
//  ConfirmController.h
//  MobileKate2.0_iPad
//
//  Created by kakadais on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "ConfirmFileViewController.h"
#import "RejectController.h"
#import "OpinionViewController.h"
#import "PaymentStateController.h"

@class CustomSubTabViewController;

@interface ConfirmController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, CommunicationDelegate, UITableViewDelegate, UITableViewDataSource> {
    
	UIPopoverController *popoverController;
	UIToolbar *toolbar;
    
	UIBarButtonItem *mainButton;
	UILabel *titleLabel;
	UILabel *nameLabel;
	UILabel *timeLabel;
	UIWebView *contentWebView;
	UIImageView *imageView;
	
	IBOutlet UIImageView *confirmImgView;
	
    // added by kwbaek
	NSNotificationCenter *noti;
	
	//--- outlet
	UITableViewCell *paymentOriginalPdfCell;
	IBOutlet UITableViewCell *paymentAttachFileCell;
	IBOutlet UIImageView *tabImageView;	
	IBOutlet UIWebView *mWebView;
	IBOutlet UIButton *btn_1;
	IBOutlet UIButton *btn_2;
	IBOutlet UIButton *btn_3;
	IBOutlet UIButton *btn_attachFile;
	IBOutlet UIView *viewContainner;
	
	
	//--- data
	NSMutableDictionary *dic_docattachlistinfo;
	NSMutableDictionary *approvaldocinfo;	//결재문서
	NSMutableDictionary *dic_selectedItem;
	NSArray *arr_docLinkListInfo;	//첨부문서리스트
	NSArray *arr_docattachlistinfo;	//첨부링크리스트
	
	NSString *selectedCategory;
	
	BOOL approve_mode;
	
	IBOutlet UIActivityIndicatorView *indicator;
	UITableView *currentTableView;
	Communication *cm;

	CustomSubTabViewController *miniMenuController;
	UIView *miniMenu;
	
}

@property (nonatomic, retain) CustomSubTabViewController *miniMenuController;
@property (nonatomic, retain) IBOutlet UIView *miniMenu;

@property (nonatomic, retain) IBOutlet UITableViewCell *paymentOriginalPdfCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *paymentAttachFileCell;

@property (nonatomic, retain) NSMutableDictionary *dic_docattachlistinfo;
@property (nonatomic, retain) NSMutableDictionary *approvaldocinfo;	//결재문서
@property (nonatomic, retain) NSMutableDictionary *dic_selectedItem;
@property (nonatomic, retain) NSArray *arr_docLinkListInfo;	//첨부문서리스트
@property (nonatomic, retain) NSArray *arr_docattachlistinfo;	//첨부링크리스트
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) IBOutlet UITableView *currentTableView;


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIWebView *contentWebView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

-(void)loadPaymentDetailData;
-(void) popForFirstAppear;
-(void) popoverDismiss;
-(IBAction) mainButtonClicked;
-(IBAction)action_paymentOriginalPdfCell;

-(IBAction)action_approve;
-(IBAction)action_reject;
-(IBAction)action_comment;

-(void)reloadUnderbar;




@end

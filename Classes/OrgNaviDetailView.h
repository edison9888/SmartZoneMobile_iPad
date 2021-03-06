//
//  OrgNaviDetailView.h
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clipboard.h"
#import "CustomSubTabViewController.h"
#import "Communication.h"
#import "ContactModel.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@class MainMenuController;
@class MobileKate2_0_iPadAppDelegate;
@class CustomSubTabViewController;


@interface OrgNaviDetailView : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
	Communication *cm;
	
	UILabel *corp;
	UILabel *email;
	UILabel *mobile;
	UILabel *name;
	UILabel *phone1;
	UILabel *pos;
	UILabel *reserv1;
	UILabel *reserv2;	
	UILabel *webmail;	
	UILabel *roll;
	UIImageView *base64image;
	
	NSArray *streams;
	NSArray *detailData;
	NSNotificationCenter *noti;
	UIActivityIndicatorView *indicator;
	UIView *indicatorModalView;
	
	UIView *EmployeeDetailView;
	
	
	UIToolbar *mainToolbar;
	UIBarButtonItem *mainButton;
	UIBarButtonItem *saveButton;
	
	CustomSubTabViewController  *tabBarViewController;
	UIView *menuTabbarView;
	UIImageView *EmployeeDetailImage;
	UIPopoverController *popoverController;
	NSString *dept;
    ContactModel *model; //연락처 메인 인스턴스 모델

}
@property (nonatomic, retain) IBOutlet UILabel *corp;
@property (nonatomic, retain) IBOutlet UILabel *email;
@property (nonatomic, retain) IBOutlet UILabel *mobile;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *phone1;
@property (nonatomic, retain) IBOutlet UILabel *pos;
@property (nonatomic, retain) IBOutlet UILabel *reserv1;
@property (nonatomic, retain) IBOutlet UILabel *reserv2;	
@property (nonatomic, retain) IBOutlet UILabel *webmail;
@property (nonatomic, retain) IBOutlet UILabel *roll;
@property (nonatomic, retain) IBOutlet UIImageView *base64image;
@property (nonatomic, retain) NSArray *streams;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) IBOutlet 	UIView *indicatorModalView;
@property (nonatomic, retain) CustomSubTabViewController *tabBarViewController;
@property(nonatomic,retain) IBOutlet UIView *menuTabbarView;
@property(nonatomic,retain) IBOutlet UIView *EmployeeDetailView;
@property(nonatomic,retain) NSString *dept;
@property (nonatomic, retain) Communication *cm;
@property (nonatomic, retain) NSArray *detailData;


@property (nonatomic, retain) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;
@property (nonatomic, retain) IBOutlet UIImageView *EmployeeDetailImage;

-(IBAction) mainButtonClicked;

-(void) popForFirstAppear;

-(void) popoverDismiss;
-(void) loadDetailContentAtIndex:(NSString *)userid;


- (IBAction)call:(id)sender;
- (IBAction)mobile:(id)sender;
- (IBAction)sms:(id)sender;
- (IBAction)email:(id)sender;
- (IBAction)saveButtonClicked;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

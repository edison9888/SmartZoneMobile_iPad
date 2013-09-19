//
//  SettingAccountController.h
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"
#import "Base64.h"



#define TR_LOGIN		1
#define TR_AUTH_INFO	2


@interface SettingAccountController : UIViewController<UIAlertViewDelegate, CommunicationDelegate, UITextFieldDelegate> {

	IBOutlet UITextField *idField;
	IBOutlet UITextField *passField;
	
	IBOutlet UIBarButtonItem *saveButton;
	
	IBOutlet UIActivityIndicatorView *indicator;
	
	int tr_mode;
	
	Communication *cm;
}

@property(nonatomic,retain) IBOutlet UITextField *idField;
@property(nonatomic,retain) IBOutlet UITextField *passField;

@property(nonatomic,retain) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic) int tr_mode;

-(void)showChangeSuccessAlert;
-(void)showNoticeAlert:(int)_currentNoticeNumber;
-(IBAction) saveButtonClicked;
-(void)trLoginGo;
-(void)trAuthGo;

@end

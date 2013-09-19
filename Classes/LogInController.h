//
//  LogInController.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 3..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clipboard.h"
#import "Communication.h"
#import "MainMenuController.h"
#import "PureCheck.h"


#define TR_LOGIN		1
#define TR_AUTH_INFO	2

@interface LogInController : UIViewController<UIAlertViewDelegate, CommunicationDelegate, UITextFieldDelegate> {
	//--- added by kakadais ---//
	UITextField *tf_ID;
	UITextField *tf_Password;
	UITextField *tf_PIN;
	
	UITextField *tf_FirstPin;
	UITextField *tf_ConfirmFirstPin;
	
	int tr_mode;
	
	NSString *login_id;
	NSString *login_password;
	NSString *login_pin;
	
	IBOutlet UIActivityIndicatorView *indicator;
	
	IBOutlet UIImageView *backgroundImage;
	
}

-(void)showFirstPinNotEqualError;
-(void)showPinAlert;
-(void)showFirstPinAlert;
-(void)showLogInAlert;
-(void)showNoticeAlert:(int)_int_noticeCnt;

-(void)trAuthGo;
-(void)trLoginGo;

@property int tr_mode;
@property (nonatomic, retain) NSString *login_id;
@property (nonatomic, retain) NSString *login_password;
@property (nonatomic, retain) NSString *login_pin;

@end

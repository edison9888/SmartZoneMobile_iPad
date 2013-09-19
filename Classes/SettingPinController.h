//
//  SettingPinController.h
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingPinController : UIViewController  <UITextFieldDelegate, UIAlertViewDelegate> {

	IBOutlet UITextField *oldField;
	IBOutlet UITextField *newField;
	IBOutlet UITextField *newConfirmField;
	
	IBOutlet UIBarButtonItem *saveButton;
	
	IBOutlet UIActivityIndicatorView *indicator;
}

@property(nonatomic,retain) IBOutlet UITextField *oldField;
@property(nonatomic,retain) IBOutlet UITextField *newField;
@property(nonatomic,retain) IBOutlet UITextField *newConfirmField;

@property(nonatomic,retain) IBOutlet UIBarButtonItem *saveButton;

-(IBAction) saveButtonClicked;

@end

//
//  SettingPinController.m
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingPinController.h"
#import "SHA1.h"


@implementation SettingPinController

@synthesize oldField;
@synthesize newField;
@synthesize newConfirmField;

@synthesize saveButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(void)viewDidLoad {
	self.title = @"PIN 인증 설정";
	self.navigationItem.rightBarButtonItem = saveButton;
	[self.oldField becomeFirstResponder];
	self.oldField.delegate = self;
	self.newField.delegate = self;
	self.newConfirmField.delegate = self;
	    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.navigationItem.rightBarButtonItem = nil;
}


- (void)dealloc {
	[oldField release];
	[newField release];
	[newConfirmField release];
	[saveButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods


- (void)showFirstPinNotEqualError {
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"PIN입력 오류" message:@"설정할 핀번호를 확인해주세요"
												  delegate:self cancelButtonTitle:nil  otherButtonTitles:@"확인", nil];
	alert.tag = 333;
	[alert show];
}


-(IBAction) saveButtonClicked {
	//NSLog(@"save Button Clicked.");
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *oldPin = oldField.text;
	NSString *newPin = newField.text;
	NSString *newConfirmPin = newConfirmField.text;
	NSString *currentPin = [userDefault objectForKey:@"login_pin"];
	
	if ([oldPin length] < 4 || [newPin length] < 4 || [newConfirmPin length] < 4) {
		if ([oldPin length] < 4) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"기존 PIN 번호 4자리를\n 입력하여 주시기 바랍니다." 
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			[alert show];
			[alert release];			
		}
		else if ([newPin length] < 4) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"변경하실 PIN 번호 4자리를\n 입력하여 주시기 바랍니다." 
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else if ([newConfirmPin length] < 4) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"확인 PIN 번호 4자리를\n 입력하여 주시기 바랍니다." 
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		return;
	}
	
	NSString *encryptOldPin = [SHA1 stringToSha1:oldPin];
	if (![currentPin isEqualToString:encryptOldPin]) {
		//--- 기존 핀 입력이 잘못 되면
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"기존 PIN 번호를\n 잘못 입력하셨습니다." 
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}

	if(![newPin isEqualToString:newConfirmPin]) {
		//새로운 핀 확정 핀이 다르면
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"새로운 PIN 번호와\n PIN 번호 확인이\n 일치하지 않습니다." 
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if([oldPin isEqualToString:newPin]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"변경하실 PIN 번호가\n기존 PIN 번호와 동일합니다.\n다시 입력하여 주시기 바랍니다." 
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSString *str_pin = newField.text;
	Byte firstChar = [str_pin characterAtIndex:0];
	BOOL allEqual = YES;
	
	for(int i = 0; i < 4; i++) {
		if([str_pin characterAtIndex:i] != firstChar)
			allEqual = NO;
	}
	
	if (allEqual == NO) {
		//--- 조건이 모두 맞으면 변경 한다 ---//
		NSString *encryptNewPin = [SHA1 stringToSha1:newPin];
		[userDefault setObject:encryptNewPin forKey:@"login_pin"];
		[userDefault synchronize];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"새로운 인증번호로 저장하였습니다." 
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
		alert.tag = 1122;
		[alert show];
		[alert release];
	}
	else {
		//--- 같은 숫자 4자리 설정시
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"알림" message:@"동일한 4자리 PIN 번호는\n입력이 불가합니다.\n다시 입력하여 주시기 바랍니다."
													  delegate:self cancelButtonTitle:nil  otherButtonTitles:@"확인", nil];
		alert.tag = 333;
		[alert show];
		
	}

	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1122) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

// PIN 글자 수 4글자 제한
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:
(NSRange)range replacementString:(NSString *)string 
{
	//제한 할 글자 수
	int maxLength = 4;
	
	//string은 현재 키보드에서 입력한 문자 한개를 의미한다.
	if(string && [string length] && ([textField.text length] >= maxLength))   return NO;
	
	return TRUE;
}

@end

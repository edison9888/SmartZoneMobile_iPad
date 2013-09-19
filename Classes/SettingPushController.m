//
//  SettingPushController.m
//  MobileOffice2.0
//
//  Created by Insang Park on 11. 6. 16..
//  Copyright 2011 Insang. All rights reserved.
//

#import "SettingPushController.h"


@implementation SettingPushController
@synthesize paymentSwitch;
@synthesize candySwitch;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"알림 설정";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self sendPushSettingCommunication:nil Flag:YES];
	
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	[indicator stopAnimating];
	
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
	[super viewWillDisappear:animated];
	
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
}


- (void)dealloc {
	[self.paymentSwitch release];
	[self.candySwitch release];
    [super dealloc];
}

-(IBAction)paymentSwitchChanged:(id)sender {
	
	//UISwitch *tempSwitch = (UISwitch *)sender;
	//NSLog(@"paymentSwitchChanged result : %@", tempSwitch.on);
	if ([self.paymentSwitch isOn]) {
		//NSLog(@"YES");
		[self sendPushSettingCommunication:@"approval" Flag:YES];
	} else {
		//NSLog(@"NO");
		[self sendPushSettingCommunication:@"approval" Flag:NO];
	}
	
	//NSLog(@"paymentSwitchChanged result : %@", [self.paymentSwitch isOn]);
	
}

-(IBAction)candySwitchChanged:(id)sender {
	
	//UISwitch *tempSwitch = (UISwitch *)sender;
	//NSLog(@"candySwitchChanged result : %@", tempSwitch.on);
	if ([self.candySwitch isOn]) {
		//NSLog(@"YES");
		[self sendPushSettingCommunication:@"candy" Flag:YES];
	} else {
		//NSLog(@"NO");
		[self sendPushSettingCommunication:@"candy" Flag:NO];
	}
	
}


#pragma mark -
#pragma mark Communication Delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
	self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
	self.paymentSwitch.enabled = NO;
	self.candySwitch.enabled = NO;
	
	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
	
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	//--- 통신 완료 확인 ---//
	
	self.navigationController.navigationItem.backBarButtonItem.enabled = YES;
	self.paymentSwitch.enabled = YES;
	self.candySwitch.enabled = YES;
	
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	NSNumber *rsltCode = [resultDic objectForKey:@"code"];
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		//self.saveButton.enabled = YES;
		
		return;		
	}	
	
	if ([rsltCode intValue] != 0) {
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		//self.saveButton.enabled = YES;
		
	}
	else {
		NSArray *pushinfoArr = (NSArray *)[_resultDic objectForKey:@"pushuserinfos"];
		if (pushinfoArr) {
			//NSLog(@"dic : %@", pushinfoArr);
			NSDictionary *temp = nil;
			for( temp in pushinfoArr ) {
				if ([[temp objectForKey:@"systemid"] isEqualToString:@"10"]) {
					// 결재
					if ([[temp objectForKey:@"status"] isEqualToString:@"0"]) {
						self.paymentSwitch.on = YES;
					} else {
						self.paymentSwitch.on = NO;
					}
					
				} else if ([[temp objectForKey:@"systemid"] isEqualToString:@"70"]) {
					// 올레터
					if ([[temp objectForKey:@"status"] isEqualToString:@"0"]) {
						self.candySwitch.on = YES;
					} else {
						self.candySwitch.on = NO;
					}
				} 
			}
			
		} else {
			// 없으면 둘다 on 
			self.paymentSwitch.on = YES;
			self.candySwitch.on = YES;
			
		}
		
		
		
	}	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[indicator stopAnimating];
	//self.saveButton.enabled = YES;
	self.navigationController.navigationItem.backBarButtonItem.enabled = YES;
	self.paymentSwitch.enabled = YES;
	self.candySwitch.enabled = YES;
	
}

-(void)sendPushSettingCommunication:(NSString *)type Flag:(BOOL)yesno {
	//--- login transaction ---//
	if (cm) {
		[cm release];
	}
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *pushRequest = [[NSMutableDictionary alloc] init];
	
	if (type == nil) {
		pushRequest = nil;
		
	} else {
		// 10 : 결재, 70 : 올레터
		if ([type isEqualToString:@"approval"]) {
			[pushRequest setObject:@"10" forKey:@"systemid"];
		} else if ([type isEqualToString:@"candy"]) {
			[pushRequest setObject:@"70" forKey:@"systemid"];
		}
		// 0 : on(YES) , 1 : off(NO)
		if (yesno == YES) {
			[pushRequest setObject:@"0" forKey:@"status"];
		} else {
			[pushRequest setObject:@"1" forKey:@"status"];
		}
		
	}
	
	int rslt = [cm callWithArray:pushRequest serviceUrl:URL_getPushUser];
	
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		
		
	}
	[pushRequest release];
}


@end

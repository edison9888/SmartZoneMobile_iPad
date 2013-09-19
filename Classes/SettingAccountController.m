//
//  SettingAccountController.m
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingAccountController.h"
#import "MobileKate2_0_iPadAppDelegate.h"
#import "Clipboard.h"


@implementation SettingAccountController

@synthesize idField, passField, saveButton, tr_mode;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	textField.placeholder = @"";
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1122) {
		//[self.navigationController popViewControllerAnimated:YES];
		MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if ([appdelegate.window.rootViewController isKindOfClass:[MainMenuController class]]) {
			/*
			[self dismissModalViewControllerAnimated:YES];
			 
			//NSLog(@"Class : %@", appdelegate.window.rootViewController);
			//NSLog(@"reload");
			[(MainMenuController *)appdelegate.window.rootViewController firstComm];
			*/
		} else {
			[self dismissModalViewControllerAnimated:YES];
			
			NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			[noti postNotificationName:@"returnHomeView" object:nil];
			
		}
	}
}

#pragma mark -
#pragma mark Communication Delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	//--- 통신 완료 확인 ---//
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	NSNumber *rsltCode = [resultDic objectForKey:@"code"];
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		self.saveButton.enabled = YES;

		return;		
	}	
	
	
	if ([rsltCode intValue] != 0) {
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		self.saveButton.enabled = YES;

	}
	else {
		//--- login success ---//		
		//--- ID 모드이면 ID데이터 저장
		
		if(self.tr_mode == TR_LOGIN) {
			//로긴 통신
			NSDictionary *authinfoDic = (NSDictionary *)[_resultDic objectForKey:@"authinfo"];
			
			//--- Login Data NSUserDefault에 셋팅 ---//
			NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
			if(userDefault) {
				[userDefault setObject:[authinfoDic objectForKey:@"compcd"] forKey:@"login_compcd"];
				[userDefault setObject:[authinfoDic objectForKey:@"key1"] forKey:@"login_key1"];
				[userDefault setObject:[authinfoDic objectForKey:@"key2"] forKey:@"login_key2"];
				[userDefault setObject:[authinfoDic objectForKey:@"key3"] forKey:@"login_key3"];
				[userDefault setObject:[authinfoDic objectForKey:@"reserved1"] forKey:@"login_reserved1"];
				[userDefault setObject:[authinfoDic objectForKey:@"reserved2"] forKey:@"login_reserved2"];
				[userDefault setObject:[authinfoDic objectForKey:@"reserved3"] forKey:@"login_reserved3"];
				[userDefault setObject:[authinfoDic objectForKey:@"userName"] forKey:@"login_userName"];
                [userDefault setObject:[authinfoDic objectForKey:@"lastcontacttime"] forKey:@"login_lastcontacttime"];
				[userDefault setObject:[authinfoDic objectForKey:@"organizationid"] forKey:@"login_organizationid"];

				[userDefault synchronize];
			}
			
			//--- 인증통신 태움 ---//
			[self trAuthGo];
		}
		else if(self.tr_mode == TR_AUTH_INFO) {
			//인증 통신
			NSDictionary *authinfoDic = (NSDictionary *)[_resultDic objectForKey:@"initsyncvaluesinfo"];
			
			NSArray *arr_noticeInfo = [authinfoDic objectForKey:@"noticeinfo"];
			NSArray *arr_webInfo = [authinfoDic objectForKey:@"webinfo"];
			NSString *noticeCnt = [authinfoDic objectForKey:@"noticecnt"];
			
			Clipboard *clip = [Clipboard sharedClipboard];
			if(arr_noticeInfo != nil && noticeCnt != nil) {
				[clip clipValue:arr_noticeInfo clipKey:@"MainNoticeArray"];
				[clip clipValue:noticeCnt clipKey:@"MainNoticeArrayCount"];
			}
			
//			if([noticeCnt intValue] > 0) {
//				[self showNoticeAlert:0];
//			}
			
			//--- Login Data NSUserDefault에 셋팅 ---//
			NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
			if(userDefault) {
				int webInfoCount = [arr_webInfo count];
				NSDictionary *tmpDic;
				
				NSMutableString *str_tmpKey;
				NSString *str_content;
				NSString *str_name;
				
				for(int i = 0; i < webInfoCount; i++) {
					tmpDic = [arr_webInfo objectAtIndex:i];
					str_content = [tmpDic objectForKey:@"content"];
					str_name = [tmpDic objectForKey:@"url"];
					
					str_tmpKey = [[NSMutableString alloc] init];
					[str_tmpKey appendString:@"URL_"];
					[str_tmpKey appendString:str_name];
					
					/*
					 URL_BPM
					 URL_CRM
					 URL_EDU
					 URL_KBN
					 URL_WITH
					 */
					
					[userDefault setObject:str_content forKey:str_tmpKey];
				}
				
				//--- 초기정보까지 올바르게 들어와야 변경해준다.
				NSString *encryptID = [Base64 encode:[idField.text UTF8String] length:[idField.text length]];
				NSString *encryptPW = [Base64 encode:[passField.text UTF8String] length:[passField.text length]];
				
				[userDefault setObject:encryptID forKey:@"login_id"];
				[userDefault setObject:encryptPW forKey:@"login_password"];
				
				[userDefault synchronize]; 
				
				
				
				[self showChangeSuccessAlert];
				
//				MainMenuControl *mainMenu = [[MainMenuControl alloc] init];
//				
//				[self.navigationController popToRootViewControllerAnimated:YES];
//				[self.navigationController pushViewController:mainMenu animated:YES];
				
			}
		}
		else {
			// 기타 통신
		}
	}	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[indicator stopAnimating];
	self.saveButton.enabled = YES;
}

-(void)trAuthGo {
	
	//	SBJSON *jsonParser = [SBJSON new];
	//	
	//	NSString *tmpStrData = @"{\"result\":{\"code\":0,\"errDesc\":\"\",\"totalCount\":0,\"totalPage\":0},\"initSyncValuesInfo\":{\"noticeCnt\":3,\"reserved1\":\"\",\"reserved2\":\"\",\"reserved3\":\"\",\"noticeInfo\":[{\"noticeId\":1,\"content\":\"공지사항1\"},{\"noticeId\":3,\"content\":\"공지사항3입니다\"},{\"noticeId\":2,\"content\":\"공지사항2입니당!!!\"}],\"webInfo\":[{\"url\":\"BPM\",\"content\":\"http://bp.kt.com/bizflow/KTFBPM/mobile/mobile_worklist_count.jsp?login_idu003d532002ac7d2b04569ced5b3553dbeea07c6b691a9c41939a3b44192799eee067\"},{\"url\":\"CRM\",\"content\":\"http://mcrm.kt.com:8077/l2smob/smartMain.jsp?returnValueu003d62add7cda1d796503c03166405ffbbb0e20d4df8e2ebebd3abe0d3d47256b9b24304341b237e3d393b44192799eee067u0026appl003dAPP\"},{\"url\":\"EDU\",\"content\":\"http://121.189.62.234:8999/cb/index.ju003de3d532002ac7d2b04569ced5b3553dbeea07c6b691a9c41939a3b44192799e3defc1b2e26df977c6835a0548c671de2d2ca67bfe8b6cf9133b44192799eee067\"},{\"url\":\"KBN\",\"content\":\"https://kbn.dmzone.co.kr/mKbn.asp?returnVa002ac7d2b04569ced5b3553dbeea07c6b691a9c41939a3b44192799eee06efc1b2e26df977c6835a0548c671de2d2ca67bfe8b6cf9133b44192799eee067\"},{\"url\":\"WITH\",\"content\":\"http://bp.kt.com/bizflow/SSOLogin_Cert_Mobile.3dbc6b691a9c41939a3b44192799eee067\"}]}}";
	//	
	//	//NSLog(@"### Communication Receive String : %@", tmpStrData);
	//	id tmpID = [jsonParser objectWithString:tmpStrData error:NULL];
	//	NSDictionary *tmpDic = (NSDictionary *)tmpID;
	//	
	//	self.tr_mode = TR_AUTH_INFO;
	//	[self didEndCommunication:tmpDic requestDictionary:nil];
	
	Communication *authCm = [[Communication alloc] init];
	[authCm setDelegate:self];
	authCm.login_process = YES;
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *authRequest = [[NSMutableDictionary alloc] init];
	
	//--- 향후 자체 device 정보로 교체 ---//
	Clipboard *clipboard = [Clipboard sharedClipboard];
	//NSString *strKey1 = [userDefault objectForKey:@"login_key1"];
	//[authRequest setObject:@"12345" forKey:@"appid"];
	NSString *strKey1 = [userDefault objectForKey:@"login_key1"];
	if([clipboard clipKey:@"devTokens"]) {
		[authRequest setObject:[clipboard clipKey:@"devTokens"] forKey:@"appid"];
	} else {
		[authRequest setObject:@"<>" forKey:@"appid"];
	}
	
	[authRequest setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appver"];	
	[authRequest setObject:@"4" forKey:@"platform"];	//0:WIPI, 1:WM, 2:iPhone,3:Android 4:iPad by 김성태
	[authRequest setObject:@"noticeid" forKey:@"noticeId"];
	[authRequest setObject:@"iOS 4.2" forKey:@"osver"];
	[authRequest setObject:strKey1 forKey:@"key1"];
	[authRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"deviceid"];
	
	self.tr_mode = TR_AUTH_INFO;
	int rslt = [authCm callWithArray:authRequest serviceUrl:URL_AuthService];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		
	}
}

-(void)trLoginGo {
	//--- login transaction ---//
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	cm.login_process = YES;
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
//	[loginRequest setObject:self.login_id forKey:@"userid"];
//	[loginRequest setObject:self.login_password forKey:@"userpw"];
	
	[loginRequest setObject:idField.text forKey:@"userid"];
	[loginRequest setObject:passField.text forKey:@"userpw"];
	
	NSString *tmpOsVer = [NSString stringWithFormat:@"%@%@",[userDefault objectForKey:@"device_os"], 
						  [userDefault objectForKey:@"device_os_version"], nil];
	
	
	//--- 향후 자체 device정보로 교체 ---//
//	[loginRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"deviceid"];
//	[loginRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"macid"];
	[loginRequest setObject:@"0" forKey:@"jailbreak"];
//	[loginRequest setObject:@"01099667038" forKey:@"mobile"];
	[loginRequest setObject:@"mobilekate" forKey:@"serviceid"];
	[loginRequest setObject:tmpOsVer forKey:@"osver"];
	[loginRequest setObject:@"4" forKey:@"platform"];
	
	self.tr_mode = TR_LOGIN;
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_LogInService];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];

		[alert show];	
		[alert release];
		
	}
}

#pragma mark Alert
-(void)showNoticeAlert:(int)_currentNoticeNumber {
	NSDictionary *tmpNoticeDic;
	NSString *tmpNoticeContent;
	Clipboard *clip = [Clipboard sharedClipboard];
	
	if(_currentNoticeNumber < [[clip clipKey:@"MainNoticeArrayCount"] intValue]) {
		tmpNoticeDic = [(NSArray *)[clip clipKey:@"MainNoticeArray"] objectAtIndex:_currentNoticeNumber];
		
		tmpNoticeContent = [tmpNoticeDic objectForKey:@"content"];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"공지사항" message:tmpNoticeContent delegate:self 
												  cancelButtonTitle:@"확인" otherButtonTitles:nil];		
		alertView.tag = _currentNoticeNumber + 10000;
		[alertView show];
	}	
}
-(void)showChangeSuccessAlert {
	UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"SmartZone 계정을 저장 하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
	successAlert.tag = 1122;
	[successAlert show];
	self.saveButton.enabled = YES;

}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	
//	if(alertView.tag >= 10000){
//		//--- 10000번 이상대는 공지사항이 index로 사용한다.
//		[self showNoticeAlert:alertView.tag - 10000 + 1];
//	}
//}	

//// Called when a button is clicked. The view will be automatically dismissed after this call returns
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
//
//// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(UIAlertView *)alertView;
//
//- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
//- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation



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
	self.title = @"사용자 계정 설정";
	self.navigationItem.rightBarButtonItem = saveButton;
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	self.idField.text = str_ID;
	self.idField.clearButtonMode = YES; 
	self.passField.placeholder = @"********";
	self.passField.clearButtonMode = YES;

	[self.idField becomeFirstResponder];
	[super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated {
	//	[self.view removeFromSuperview];
	
	[indicator stopAnimating];
	self.saveButton.enabled = YES;
	
	if (cm != nil) {
		[cm cancelCommunication];
	}		
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
	[idField release];
	[passField release];
	[saveButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods


-(IBAction) saveButtonClicked {
	//NSLog(@"save Button Clicked.");
	self.saveButton.enabled = NO;
	if([idField.text length] <= 0 || [passField.text length] <= 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"아이디와 비밀번호를\n입력해야 합니다."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];				
		self.saveButton.enabled = YES;

		return;
	}
	[self resignFirstResponder];

	[self trLoginGo];
}

@end

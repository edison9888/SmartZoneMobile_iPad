//
//  LogInController.m
//  MobileOffice2.0
//  Created by nicejin on 11. 2. 3..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "LogInController.h"
#import "URL_Define.h"
#import "SBJSON.h"
#import "SHA1.h"
#import "MobileKate2_0_iPadAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCryptor.h>


#include <arpa/inet.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#import "IPAddress.h"

#if ! defined(IFT_ETHER)
	#define IFT_ETHER 24	/* Ethernet CSMACD */
#endif

//#define debug_no_login 1

@implementation LogInController
@synthesize tr_mode, login_id, login_password, login_pin;

#pragma mark -
#pragma mark Communication Delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
//	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//
//    indicator.hidesWhenStopped = YES;
//	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [self.view addSubview:indicator];
//	indicator.center = self.view.center;
	
	CGRect rect = indicator.frame;
	rect.size.height = 50;
	rect.size.width = 50;
	indicator.frame = rect;
	
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	[indicator startAnimating];
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	//--- 통신 완료 확인 ---//
	
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
//	//NSLog(@"LogInController result : %@", resultDic);
//	//NSLog(@"LogInController code : %@", [resultDic objectForKey:@"code"]);
//	//NSLog(@"LogInController errDesc: %@", [resultDic objectForKey:@"errdesc"]);
//	//NSLog(@"LogInController totalCount: %@", [resultDic objectForKey:@"totalcount"]);
//	//NSLog(@"LogInController totalPage: %@", [resultDic objectForKey:@"totalpage"]);
	
	NSNumber *rsltCode = [resultDic objectForKey:@"code"];
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 666;
		[alert show];	
		[alert release];
		return;
		
	}

	
	if([rsltCode intValue] == 0){
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

				if ([tf_ID.text length] > 0 && [tf_Password.text length] > 0) {
					
					//--- id encrypt ---//
					NSString *encryptID = [Base64 encode:[tf_ID.text UTF8String] length:[tf_ID.text length]];
					NSString *encryptPW = [Base64 encode:[tf_Password.text UTF8String] length:[tf_Password.text length]];
					
					[userDefault setObject:encryptID forKey:@"login_id"];
//					[userDefault setObject:tf_ID.text forKey:@"login_id"];
					[userDefault setObject:encryptPW forKey:@"login_password"];
				}

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

			if([noticeCnt intValue] > 0) {
				[self showNoticeAlert:0];
			}

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
				
                //주소록 설정 세팅 default 1
				NSString *contactDefault = [userDefault objectForKey:@"ContactDefault"];
				if ([contactDefault length] <= 0 || contactDefault == nil )
					[userDefault setObject:[NSString stringWithFormat:@"1"] forKey:@"ContactDefault"];
                // 메인화면 리스트 및 아이콘 형식 세팅 default 1 (아이콘)

                
                
                
                
				[userDefault synchronize]; 
				
				//--- main menu call 
				
				[self.view removeFromSuperview];				
				
				//MainMenuController *mainMenuController = [[MainMenuController alloc] init];
				MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
				//appdelegate.window.rootViewController = mainMenuController;
				appdelegate.window.rootViewController = appdelegate.mainMenuController;
				
					/*
				CATransition *myTransition = [CATransition animation];
				myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
				myTransition.type = kCATransitionFade;
				myTransition.duration = 0.125;
				[self.view.layer addAnimation:myTransition forKey:nil];
					*/
				
				
				
//				NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
//				[noti postNotificationName:@"returnNoticeView" object:self];
				
			}
		}
		else {
			// 기타 통신
		}
	}
	else if([rsltCode intValue] == 3){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"App이 업데이트 되었습니다. 업데이트 하시겠습니까?"
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
		
		alert.tag = 999;
		
		Clipboard *clip = [Clipboard sharedClipboard];
		NSString *urltemp = [resultDic objectForKey:@"errdesc"];
		[clip clipValue:urltemp clipKey:@"UpgradeURL"];
		
		[alert show];	
		[alert release];
	}
	else if([rsltCode intValue] == 4){
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"로그인 정보를 확인 후 다시 시도 해 주십시오"
		//													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 667;
		[alert show];	
		[alert release];
	}
	else if([rsltCode intValue] == 2){
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 668;
		[alert show];	
		[alert release];
	}
	else {
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"로그인 정보를 확인 후 다시 시도 해 주십시오"
//													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 666;
		[alert show];	
		[alert release];
	}
	
}

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	
}


-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[indicator stopAnimating];
	
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
	
		//devicetoken
	Clipboard *clipboard = [Clipboard sharedClipboard];
		//NSString *devTokens = [clipboard clipKey:@"devTokens"];
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:devTokens
		//											   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];

		//[alert show];	
		//[alert release];
	
	
	//--- 향후 자체 device 정보로 교체 ---//
	NSString *strKey1 = [userDefault objectForKey:@"login_key1"];
	if([clipboard clipKey:@"devTokens"]) {
		[authRequest setObject:[clipboard clipKey:@"devTokens"] forKey:@"appid"];
	} else {
		[authRequest setObject:@"<>" forKey:@"appid"];
	}
	
	NSString *tmpOsVer = [NSString stringWithFormat:@"%@%@",[userDefault objectForKey:@"device_os"], 
						  [userDefault objectForKey:@"device_os_version"], nil];
	
	//[authRequest setObject:[clipboard clipKey:@"devTokens"] forKey:@"appid"];
	//[authRequest setObject:@"0.0.9" forKey:@"appver"];	
	[authRequest setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appver"];	
//	[authRequest setObject:@"0.0.9" forKey:@"appver"];	
	[authRequest setObject:@"4" forKey:@"platform"];	//0:WIPI, 1:WM, 2:iPhone,3:Android 4:iPad by 김성태
//	[authRequest setObject:@"noticeid" forKey:@"noticeId"];
	//[authRequest setObject:@"iOS 4.2" forKey:@"osver"];
	[authRequest setObject:tmpOsVer forKey:@"osver"];
	[authRequest setObject:strKey1 forKey:@"key1"];
//	[authRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"deviceid"];
	
	self.tr_mode = TR_AUTH_INFO;
	int rslt = [authCm callWithArray:authRequest serviceUrl:URL_AuthService];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"통신 장애 발생"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 666;
		[alert show];	
		[alert release];
		
	}
}

-(void)trLoginGo {
	//--- login transaction ---//
	Communication *cm = [[Communication alloc] init];
	[cm setDelegate:self];
	cm.login_process = YES;

	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
		
	[loginRequest setObject:self.login_id forKey:@"userid"];
	[loginRequest setObject:self.login_password forKey:@"userpw"];
	
	NSString *tmpOsVer = [NSString stringWithFormat:@"%@%@",[userDefault objectForKey:@"device_os"], 
						  [userDefault objectForKey:@"device_os_version"], nil];
	
	//--- 향후 자체 device정보로 교체 ---//
	//[loginRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"deviceid"];
//	[loginRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"deviceid"];
//	[loginRequest setObject:@"00:21:6A:BF:0C:F0" forKey:@"macid"];
	[loginRequest setObject:[userDefault objectForKey:@"flag_jailbreak"] forKey:@"jailbreak"];
//	[loginRequest setObject:@"0" forKey:@"jailbreak"];
//	[loginRequest setObject:@"01099667038" forKey:@"mobile"];
	[loginRequest setObject:@"mobilekate" forKey:@"serviceid"];
	[loginRequest setObject:tmpOsVer forKey:@"osver"];
	[loginRequest setObject:@"4" forKey:@"platform"];
	//
	
	self.tr_mode = TR_LOGIN;
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_LogInService];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 연결 상태를 확인 해주세요."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 3838;
		[alert show];	
		[alert release];
		
	}
}


#pragma mark Login Alert

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 3838) {
		[[UIApplication sharedApplication] terminateWithSuccess];
	}
	if(alertView.tag == 123) {
		//--- login cancel clicked
		[[UIApplication sharedApplication] terminateWithSuccess];
	}
	else if (alertView.tag == 333) {
		//--- 최초 핀번호 설정 오류 시
		[self showFirstPinAlert];
	}
	else if (alertView.tag == 222) {
		//--- 최초 핀번호 설정 (4자리만 인정)
		UIAlertView *alert;
		switch (buttonIndex) {
			case 0:
				// cancel
				alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN 번호 인증이 필요합니다 \nPIN 번호를 분실하였을 경우, \napp을 삭제 후\n재설치 해주십시오."
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 123;
				[alert show];	
				[alert release];
				break;
			case 1:
				if([tf_FirstPin.text isEqualToString:tf_ConfirmFirstPin.text] &&
				   [tf_FirstPin.text length] == 4 && [tf_ConfirmFirstPin.text length] == 4) {
					//--- 두 값이 일치하면 저장후 진행
					
					NSString *str_pin = tf_FirstPin.text;
					Byte firstChar = [str_pin characterAtIndex:0];
					BOOL allEqual = YES;
					
					for(int i = 0; i < 4; i++) {
						if([str_pin characterAtIndex:i] != firstChar)
							allEqual = NO;
					}
					
					if (allEqual == NO) {
						NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
						NSString *encryptPin = [SHA1 stringToSha1:tf_FirstPin.text];
						[userDefault setObject:encryptPin forKey:@"login_pin"];
						[userDefault synchronize];
						
						[self showLogInAlert];
					}else {
//						[self showFirstPinNotEqualError];
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"동일한 4자리 PIN 번호는\n입력이 불가합니다.\n다시 입력하여 주시기 바랍니다."
																	   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
						alert.tag = 333;
						[alert show];	
						
					}
				}
				else {
					//--- 일치하지 않음 에러
					
					if ([tf_FirstPin.text length] == 0 && [tf_ConfirmFirstPin.text length] == 0) {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"핀번호를 입력하지 않으셨습니다.\nApp에서 사용하실\n PIN 번호를 입력하여\n주시기 바랍니다."
														  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
						alert.tag = 333;
						[alert show];	
					}
					else {
						[self showFirstPinNotEqualError];
					}
				}
				
				// confirm
				break;
			default:
				break;
		}

	}
	else if(alertView.tag == 666) {
		//--- 로그인 실패 확인 ---//
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSString *encryptString = [userDefault objectForKey:@"login_id"];
		NSData *tmpID = [Base64 decode:encryptString];
		NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
		
		NSString *strLoginId = str_ID;
		NSString *strLoginPw = [userDefault objectForKey:@"login_password"];
		if([strLoginId length] > 0 && [strLoginPw length] > 0) {
			//--- 입력된 값 없으면 pin화면 
			[self showPinAlert];			
		}
		else {
			[self showLogInAlert];
		}
	}
	else if(alertView.tag == 667) {
		//--- ID/PW 오류시 무조건 계정 입력창 띄우도록 변경. 저장되어있던 ID/PW 삭제함 ---//
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		[userDefault removeObjectForKey:@"login_id"];
		[userDefault removeObjectForKey:@"login_password"];
		//NSLog(@"id : %@, pw : %@", [userDefault objectForKey:@"login_id"], [userDefault objectForKey:@"login_password"]);
		
		[self showLogInAlert];
	}
	else if(alertView.tag == 668) {
		[[UIApplication sharedApplication] terminateWithSuccess];
	}
	else if(alertView.tag >= 10000){
		//--- 10000번 이상대는 공지사항이 index로 사용한다.
		[self showNoticeAlert:alertView.tag - 10000 + 1];
	}
	else if(alertView.tag == 777) {
		UIAlertView *alert;
		NSUserDefaults *userDefault;
		NSString *textPin;
		NSString *tmpEncryptPin;
		switch (buttonIndex) {
			case 0:
				// cancel
				alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN 번호 인증이 필요합니다 \nPIN 번호를 분실하였을 경우, \nApp을 삭제 후\n재설치 해주십시오."
												  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 123;
				[alert show];	
				[alert release];				
				break;
			case 1:
				// confirm
				//--- PIN 입력 ---//
				userDefault = [NSUserDefaults standardUserDefaults];
				textPin = tf_PIN.text;
				tmpEncryptPin = [SHA1 stringToSha1:textPin];
				
				
				if([[userDefault objectForKey:@"login_pin"] isEqualToString:tmpEncryptPin]) {
					if ([self.login_id length] > 0 && [self.login_password length] > 0) {
						//--- 저장된 id/pw 있으면 로긴
						[self trLoginGo];
					}
					else {
						//--- 저장된게 없으면 받아야지
						[self showLogInAlert];
					}
					
				}
				else {
					if([textPin length] == 0) {
						// pin 입력 안했음
						alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"핀번호를 입력하지 않으셨습니다.\nApp에서 사용하실\n PIN 번호를 입력하여\n주시기 바랍니다."
														  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
						alert.tag = 888;
						[alert show];	
						[alert release];
					}
					else {
						// pin 입력은 했지만 내용이 다름
						if ([(NSString *)[userDefault objectForKey:@"login_pinCount"] isEqualToString:@"0"]) {
							alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN 번호가 틀립니다.\nApp을 삭제 후 새로 설치하시기 바랍니다."
															  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
							alert.tag = 123;
							[alert show];	
							[alert release];
							
							NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
							[userDefault setObject:@"disabled" forKey:@"disabled"];
						}
						else {
//							NSString *str_err;
//							if ([textPin length] < 4) {
//								// 4자리 이하
//								str_err = @"PIN 번호 4자리를\n입력하여 주시기 바랍니다.";
//							}
//							else {
//								// 핀 틀렸을 경우
//								str_err = @"PIN 번호를 잘못 입력하셨습니다. 다시 확인하여 입력해 주시기 바랍니다.";
//							}

							
							NSString *pinCount = [userDefault objectForKey:@"login_pinCount"];
							NSString *str_err = [NSString stringWithFormat:@"PIN 번호가 틀립니다.\n%@회 남았습니다.", pinCount];
							
							
							alert = [[UIAlertView alloc] initWithTitle:@"알림" message:str_err
															  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
							alert.tag = 888;
							[alert show];	
							[alert release];							
							
							//--- decrease pin count
							int tmpPin = [pinCount intValue];
							tmpPin--;
							pinCount = [NSString stringWithFormat:@"%d", tmpPin];
							[userDefault setObject:pinCount forKey:@"login_pinCount"];
							
						}
					}					
				}
				
				break;
			default:
				break;
		}
	}
	else if(alertView.tag == 888) {
		//--- PIN Error ---//
       [self showPinAlert];
	}
	else if(alertView.tag == 111) {
		// Clicked the Submit button
		UIAlertView *alert;
		
		switch (buttonIndex) {
			case 0:
				// cancel
				alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"본 서비스는 로그인 후 \n사용이 가능합니다."
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 123;
				[alert show];	
				[alert release];
				break;
			case 1:
				// confirm
				if(buttonIndex !=[alertView cancelButtonIndex])
				{	
					if([tf_ID.text length] > 0 && [tf_Password.text length] > 0) {
						self.login_id = tf_ID.text;
						self.login_password = tf_Password.text;
						
						[self trLoginGo];
					}
					else {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"아이디와 비밀번호를\n입력해야 합니다."
																	   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
						alert.tag = 666;
						[alert show];	
						[alert release];
					}	
				}
				break;
			default:
				break;
		}
	}
	else if (alertView.tag == 999) {
		//--- 버전 오류 ; 업그레이드로 리다이렉트
		if(buttonIndex !=[alertView cancelButtonIndex])
		{	
			Clipboard *clip = [Clipboard sharedClipboard];
			NSURL *url = [NSURL URLWithString:[clip clipKey:@"UpgradeURL"]];
			[[UIApplication sharedApplication] openURL:url];
			//if (![[UIApplication sharedApplication] openURL:url])
		} else {
			[[UIApplication sharedApplication] terminateWithSuccess];
		}

			
	}
	else {
		//--- nothing tag ---//
	}
}

- (void)showFirstPinNotEqualError {
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 PIN 번호와\nPIN 확인 번호가\n일치하지 않습니다.\n다시 입력하여 주시기 바랍니다."
												  delegate:self cancelButtonTitle:nil  otherButtonTitles:@"확인", nil];
	alert.tag = 333;
	[alert show];
}

- (void)showPinErrorAlert {
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN정보를 입력해주세요"
												  delegate:self cancelButtonTitle:nil  otherButtonTitles:@"확인", nil];
	//--- login 111 error 666 pin 777 pinError 888
	alert.tag = 888;
	
	[alert addTextFieldWithValue:@"" label:@"PIN을 입력하세요"];
	
	// PIN
	tf_PIN =[alert textFieldAtIndex:0];
	tf_PIN.tag = 444;
	tf_PIN.delegate = self;
	tf_PIN.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf_PIN.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	tf_PIN.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_PIN.autocorrectionType = UITextAutocorrectionTypeNo;
	tf_PIN.secureTextEntry =YES;
	
	[alert show];
}

- (void)showPinAlert {
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"SmartZone Mobile" message:@"PIN 번호를 입력하세요"
												  delegate:self cancelButtonTitle:@"취소"  otherButtonTitles:@"확인", nil];
	//--- login 111 error 666 pin 777
	alert.tag = 777;
	
	[alert addTextFieldWithValue:@"" label:@"PIN"];
	
	// PIN
	tf_PIN =[alert textFieldAtIndex:0];
	tf_PIN.tag = 444;
	tf_PIN.delegate = self;
	tf_PIN.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf_PIN.keyboardType = UIKeyboardTypeNumberPad;
	tf_PIN.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_PIN.autocorrectionType = UITextAutocorrectionTypeNo;
	tf_PIN.secureTextEntry =YES;
	

	
	[alert show];
}

- (void)showLogInAlert {
	
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"SmartZone Mobile" message:@""
												  delegate:self cancelButtonTitle:@"취소"  otherButtonTitles:@"확인", nil];
	alert.tag = 111;
	
	[alert addTextFieldWithValue:@"" label:@"사번을 입력하세요"];
	[alert addTextFieldWithValue:@"" label:@"비밀번호를 입력하세요"];

	// Username
	tf_ID =[alert textFieldAtIndex:0];
	tf_ID.keyboardType = UIKeyboardTypeAlphabet;
	tf_ID.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_ID.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// Password
	tf_Password =[alert textFieldAtIndex:1];
	tf_Password.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf_Password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	tf_Password.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_Password.autocorrectionType = UITextAutocorrectionTypeNo;
	tf_Password.secureTextEntry =YES;
	

	[alert show];
}

-(void)showFirstPinAlert {
	UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"PIN 번호를 입력하세요."
												  delegate:self cancelButtonTitle:@"취소"  otherButtonTitles:@"확인", nil];
	alert.tag = 222;
	
	[alert addTextFieldWithValue:@"" label:@"PIN"];
	[alert addTextFieldWithValue:@"" label:@"PIN 확인"];

	
	// Username
	tf_FirstPin =[alert textFieldAtIndex:0];
	tf_FirstPin.tag = 444;
	tf_FirstPin.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf_FirstPin.delegate = self;
	tf_FirstPin.keyboardType = UIKeyboardTypeNumberPad;
	tf_FirstPin.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_FirstPin.autocorrectionType = UITextAutocorrectionTypeNo;
	tf_FirstPin.secureTextEntry =YES;
	
	// Password
	tf_ConfirmFirstPin =[alert textFieldAtIndex:1];
	tf_ConfirmFirstPin.tag = 444;
	tf_ConfirmFirstPin.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf_ConfirmFirstPin.delegate = self;
	tf_ConfirmFirstPin.keyboardType = UIKeyboardTypeNumberPad;
	tf_ConfirmFirstPin.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf_ConfirmFirstPin.autocorrectionType = UITextAutocorrectionTypeNo;
	tf_ConfirmFirstPin.secureTextEntry =YES;
	
	[alert show];
	
}

#pragma mark TextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 444) {
		NSUInteger newLength = [textField.text length] + [string length] - range.length;
		return (newLength > 4) ? NO : YES;
	}
	return YES;
}

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


- (void)getHardwareInfo {

	//--- get the hardware information ---//
	//	NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"]; 
	//	//NSLog(@"Phone Number: %@", num);
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	UIDevice *crt_device = [UIDevice currentDevice];
	
	NSString *str_systemName = crt_device.systemName;
	NSString *str_systemVersion = crt_device.systemVersion;
	NSString *str_wifiMac = @"";
	
	
	InitAddresses();
	GetIPAddresses();
	GetHWAddresses();
	
	int i;
//	NSString *deviceIP = nil;
	for (i=0; i<MAXADDRS; ++i)
	{
        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
        unsigned long theAddr;
		
        theAddr = ip_addrs[i];
		
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
		
        //NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
		//--- name == en0 => WIFI
		
        //decided what adapter you want details for
		//printf("#####################  %s", if_names[i]);
        if (strncmp(if_names[i], "en", 2) == 0)
        {
			str_wifiMac = [NSString stringWithFormat:@"%s", hw_addrs[i]];
			//NSLog(@"Adapter en has a IP of %@", [NSString stringWithFormat:@"%s", ip_names[i]]);
        }
	}

	if([str_systemName length] > 0)
		[userDefault setObject:str_systemName forKey:@"device_os"]; // iPhone OS
	if([str_systemVersion length] > 0)
		[userDefault setObject:str_systemVersion forKey:@"device_os_version"]; // 4.2
	if([str_wifiMac length] > 0)
		[userDefault setObject:str_wifiMac forKey:@"device_mac_address"];	//xx:xx:xx:xx:xx:xx
	
}
- (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key {
	return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
}

- (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
	return [[[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
								  encoding:NSUTF8StringEncoding] autorelease];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*

#ifdef debug_no_login
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSString *wefwef = [userDefault objectForKey:@"login_compcd"];
	NSString *wef32rwefd = [userDefault objectForKey:@"login_key1"];
	NSString *dfwef = [userDefault objectForKey:@"login_key2"];
	NSString *wewefeffwef = [userDefault objectForKey:@"login_key3"];
	NSString *wfwfdfwefeefwef = [userDefault objectForKey:@"login_reserved1"];
	NSString *wedfffwef = [userDefault objectForKey:@"login_reserved2"];
	NSString *wedfsfafdfwef = [userDefault objectForKey:@"login_reserved3"];
	NSString *wefvfvewef = [userDefault objectForKey:@"login_userName"];
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];

	NSString *wefweffffewf = str_ID;
	NSString *jjfjef = [userDefault objectForKey:@"login_password"];
	
	[self.view removeFromSuperview];				
	
	MainMenuController *mainMenuController = [[MainMenuController alloc] init];
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	appdelegate.window.rootViewController = mainMenuController;
	
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionFade;
	myTransition.duration = 0.125;
	[self.view.layer addAnimation:myTransition forKey:nil];
	
	
	
#endif
	
#ifndef debug_no_login
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	//--- jail breaking check ---//
	PureCheck *pureClass = [[PureCheck alloc] init];
	int flag = [pureClass isPure];
	[pureClass release];
	
	NSString *tmpJailFlag = [NSString stringWithFormat:@"%d", flag];
	
	[userDefault setObject:tmpJailFlag forKey:@"flag_jailbreak"];
	

	NSString *str_disabled = [userDefault objectForKey:@"disabled"];
	if ([str_disabled isEqualToString:@"disabled"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN 번호 입력이 3번 틀렸습니다.\nmobile kate를 삭제 후\n새로 설치하시기 바랍니다."
										  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 3838;
		[alert show];	
		[alert release];
		return;
	}

	[self getHardwareInfo];
	
	NSString *tmpPin = [userDefault objectForKey:@"login_pin"];
	

	[userDefault setObject:@"2" forKey:@"login_pinCount"];
	
	if([tmpPin length] <= 0 || tmpPin == nil) {
		[self showFirstPinAlert];
	}
	else {
		[self showPinAlert];
	}
	
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	NSString *encryptPassword = [userDefault objectForKey:@"login_password"];
	NSData *tmpPW = [Base64 decode:encryptPassword];
	NSString *str_PW = [[NSString alloc] initWithData:tmpPW encoding:NSUTF8StringEncoding];
	
	
	self.login_id = str_ID;
	self.login_password = str_PW;
	
	
	
#endif
	
//	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//	temporaryBarButtonItem.title = @"홈";
//	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];	
	
	*/
}


- (void)viewWillAppear:(BOOL)animated
{

#ifdef debug_no_login
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSString *wefwef = [userDefault objectForKey:@"login_compcd"];
	NSString *wef32rwefd = [userDefault objectForKey:@"login_key1"];
	NSString *dfwef = [userDefault objectForKey:@"login_key2"];
	NSString *wewefeffwef = [userDefault objectForKey:@"login_key3"];
	NSString *wfwfdfwefeefwef = [userDefault objectForKey:@"login_reserved1"];
	NSString *wedfffwef = [userDefault objectForKey:@"login_reserved2"];
	NSString *wedfsfafdfwef = [userDefault objectForKey:@"login_reserved3"];
	NSString *wefvfvewef = [userDefault objectForKey:@"login_userName"];
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	NSString *wefweffffewf = str_ID;
	NSString *jjfjef = [userDefault objectForKey:@"login_password"];
	
	[self.view removeFromSuperview];				
	
	MainMenuController *mainMenuController = [[MainMenuController alloc] init];
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	appdelegate.window.rootViewController = mainMenuController;
	
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionFade;
	myTransition.duration = 0.125;
	[self.view.layer addAnimation:myTransition forKey:nil];
	
	
	
#endif
	
#ifndef debug_no_login
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	//--- jail breaking check ---//
	PureCheck *pureClass = [[PureCheck alloc] init];
	int flag = [pureClass isPure];
	[pureClass release];
	
	NSString *tmpJailFlag = [NSString stringWithFormat:@"%d", flag];
	
	[userDefault setObject:tmpJailFlag forKey:@"flag_jailbreak"];
	
	
	NSString *str_disabled = [userDefault objectForKey:@"disabled"];
	if ([str_disabled isEqualToString:@"disabled"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PIN 번호 입력이 3번 틀렸습니다.\nApp 삭제 후\n새로 설치하시기 바랍니다."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 3838;
		[alert show];	
		[alert release];
		return;
	}
	
	[self getHardwareInfo];
	
	NSString *tmpPin = [userDefault objectForKey:@"login_pin"];
	
	
	[userDefault setObject:@"2" forKey:@"login_pinCount"];
	
	if([tmpPin length] <= 0 || tmpPin == nil) {
		[self showFirstPinAlert];
	}
	else {
		[self showPinAlert];
	}
	
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	NSString *encryptPassword = [userDefault objectForKey:@"login_password"];
	NSData *tmpPW = [Base64 decode:encryptPassword];
	NSString *str_PW = [[NSString alloc] initWithData:tmpPW encoding:NSUTF8StringEncoding];
	
	
	self.login_id = str_ID;
	self.login_password = str_PW;
	
	
	
#endif
	
	//	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	//	temporaryBarButtonItem.title = @"홈";
	//	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	//	[temporaryBarButtonItem release];	
	

	[super viewWillAppear:animated];
}

	
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
	 if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		 // landscape!
		 backgroundImage.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
	 } else {
		 // portrait
		 backgroundImage.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
	 }

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
    [super dealloc];
}

@end

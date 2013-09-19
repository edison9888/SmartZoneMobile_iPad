//
//  CustomSubTabViewController.m
//  MobileKate2.0_iPad
//
//  Created by nicejin on 11. 3. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomSubTabViewController.h"
#import "URL_Define.h"
#import "MainMenuController.h"
#import "WebController.h"
#import "SettingTableController.h"
#import "ContactMainViewController.h"
@implementation CustomSubTabViewController
@synthesize dataView, tabScrollView;
@synthesize leftArrowImage, rightArrowImage;

#pragma mark -
#pragma mark button action

-(IBAction)button_action:(id)sender {
	int btn_tag = [(UIButton *)sender tag];
	
	//MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	//MainMenuController *mainMenuController = [[MainMenuController alloc] init];
	Clipboard *clip = [Clipboard sharedClipboard];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	
	SettingTableController *settingTableController;
	UINavigationController *settingNavigationController;
    ContactMainViewController *contactMainViewController;
    UINavigationController *contactsNavigationController;
	//--- button tag 에 따라 move move
	switch (btn_tag) {
		case 0:		//홈
			[noti postNotificationName:@"returnHomeView" object:nil];
			//[self.view removeFromSuperview];
			
			//appdelegate.window.rootViewController = mainMenuController;
			/*
			 CATransition *myTransition = [CATransition animation];
			 myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
			 myTransition.type = kCATransitionFade;
			 myTransition.duration = 0.125;
			 [self.view.layer addAnimation:myTransition forKey:nil];
			 */
			break;
		case 1:		//임직원조회 detail 화면
			[noti postNotificationName:@"SearchEmployeeCtrl" object:nil];
			break;
		case 2:		//공지사항
			[noti postNotificationName:@"BoardCtrl" object:self];
			break;
		case 3:		//결재
			[noti postNotificationName:@"PaymentCtrl" object:self];
			break;
		case 4:		//BPM
			//[mainMenuController changeContentsMenu:@"webXib"];
			[noti postNotificationName:@"MailCtrl" object:nil];
			
			break;
		case 5:		//WITH

            [noti postNotificationName:@"EISCtrl" object:nil];
			break;
		case 6:		//복무
            
            [noti postNotificationName:@"CalendarCtrl" object:nil];

			break;
		case 7:		//알려주세요
            contactMainViewController = [[ContactMainViewController alloc] initWithNibName:@"ContactMainViewController" bundle:nil];
            contactsNavigationController = [[UINavigationController alloc] initWithRootViewController:contactMainViewController];
            contactsNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            contactsNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [contactMainViewController release];
            
            [self presentModalViewController:contactsNavigationController animated:YES];
            
            //appdelegate.window.rootViewController = settingNavigationController;
            
            [contactsNavigationController release];

			break;
		case 8:		//주가정보
//			[clip clipValue:URL_iPadStock clipKey:@"WEB_LINK_URL"];
//			[clip clipValue:@"주가 정보" clipKey:@"WEB_LINK_NAME"];
//			//[mainMenuController changeContentsMenu:@"webXib"];
//			[noti postNotificationName:@"customTabWebView" object:nil];
            [noti postNotificationName:@"ORGNaviCtrl" object:nil];
			break;
		case 9:		//CRM
            
            
//			[clip clipValue:[userDefault objectForKey:@"URL_CRM"] clipKey:@"WEB_LINK_URL"];
//			[clip clipValue:@"m-CRM" clipKey:@"WEB_LINK_NAME"];
//			//	[mainMenuController changeContentsMenu:@"webXib"];
//			[noti postNotificationName:@"customTabWebView" object:nil];
            settingTableController = [[SettingTableController alloc] initWithNibName:@"SettingTableController" bundle:nil];
			settingNavigationController = [[UINavigationController alloc] initWithRootViewController:settingTableController];
			settingNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
			settingNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
			[settingTableController release];
			
			[self presentModalViewController:settingNavigationController animated:YES];
			
			//appdelegate.window.rootViewController = settingNavigationController;
			
			[settingNavigationController release];

			break;
		case 10:	//M-Learning
			[clip clipValue:[userDefault objectForKey:@"URL_EDU"] clipKey:@"WEB_LINK_URL"];
			[clip clipValue:@"m-Learning" clipKey:@"WEB_LINK_NAME"];
			//[mainMenuController changeContentsMenu:@"webXib"];
			[noti postNotificationName:@"customTabWebView" object:nil];
			
			break;
		case 11:	//KBN
			[clip clipValue:[userDefault objectForKey:@"URL_KBN"] clipKey:@"WEB_LINK_URL"];
			[clip clipValue:@"KBN" clipKey:@"WEB_LINK_NAME"];
			//[mainMenuController changeContentsMenu:@"webXib"];
			[noti postNotificationName:@"customTabWebView" object:nil];
			
			break;
		case 12:	//업무프로세스
			[clip clipValue:[userDefault objectForKey:@"URL_MPRCSS"] clipKey:@"WEB_LINK_URL"];
			[clip clipValue:@"업무표준" clipKey:@"WEB_LINK_NAME"];
			//[mainMenuController changeContentsMenu:@"webXib"];
			[noti postNotificationName:@"customTabWebView" object:nil];
			
			
			break;
		case 13:	//ktls
			[clip clipValue:[userDefault objectForKey:@"URL_KTLS"] clipKey:@"WEB_LINK_URL"];
			[clip clipValue:@"KTLS" clipKey:@"WEB_LINK_NAME"];
			//[self changeContentsMenu];
			[noti postNotificationName:@"customTabWebView" object:nil];
			//[mainMenuController loadDetailContentAtIndex:[NSString stringWithFormat:@"%@", [[streams objectAtIndex:indexPath.row] objectForKey:@"userid"]]];
			//[mainMenuController changeContentsMenu:@"webXib"];
			//[self changeContentsMenu:@"webXib"];
			
			break;
		case 14:	//올레터
			[clip clipValue:[userDefault objectForKey:@"URL_CANDY"] clipKey:@"WEB_LINK_URL"];
			[clip clipValue:@"올레터" clipKey:@"WEB_LINK_NAME"];
			//[self changeContentsMenu];
			[noti postNotificationName:@"customTabWebView" object:nil];
			
			break;
			
		case 15:	//설정
			//[noti postNotificationName:@"SettingCtrl" object:self];
			
			settingTableController = [[SettingTableController alloc] initWithNibName:@"SettingTableController" bundle:nil];
			settingNavigationController = [[UINavigationController alloc] initWithRootViewController:settingTableController];
			settingNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
			settingNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
			[settingTableController release];
			
			[self presentModalViewController:settingNavigationController animated:YES];
			
			//appdelegate.window.rootViewController = settingNavigationController;
			
			[settingNavigationController release];
			
			break;
			
			// 이후 홈부문 어플통합 
			
		case 16:	//세일즈꾸러미
		case 17:	//
		case 18:	//
		case 19:	//
		case 20:	//
		case 21:	//
		case 22:	//
			[self AIACallInSub:btn_tag];
			break;
			
		default:
			break;
	}
	//[mainMenuController release];
	
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

-(void)changeContentsMenu {
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[self.view.superview removeFromSuperview];
	//[self.view removeFromSuperview];
	
	
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	//myTransition.type = kCATransitionFade;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	myTransition.duration = 0.25;
	
	//[appdelegate.window.layer addAnimation:myTransition forKey:nil];
	
	WebController *webXib = [[WebController alloc] initWithNibName:@"WebController" bundle:nil];
	appdelegate.window.rootViewController = webXib;
	[webXib release];
	/*
	 CATransition *myTransition = [CATransition animation];
	 myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	 myTransition.type = kCATransitionFade;
	 myTransition.duration = 0.125;
	 [self.view.layer addAnimation:myTransition forKey:nil];
	 */
}
/*
 -(void)changeContentsMenu:(NSString *)contentsName {
 MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
 [self.view.superview removeFromSuperview];
 [self.view removeFromSuperview];
 
 appdelegate.window.rootViewController = [menuObject objectForKey:contentsName];
 if ([contentsName isEqualToString:@"noticeXib"] || [contentsName isEqualToString:@"qnaXib"] || 
 [contentsName isEqualToString:@"searchEmployeeXib"] || [contentsName isEqualToString:@"paymentXib"]) {
 [[[menuObject objectForKey:contentsName] detailView] popForFirstAppear];
 }
 
 if ([contentsName isEqualToString:@"paymentXib"]) {
 [[menuObject objectForKey:contentsName] rootView].flag_reload = YES;
 
 }
 
 CATransition *myTransition = [CATransition animation];
 myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
 myTransition.type = kCATransitionPush;
 myTransition.subtype = kCATransitionFromLeft;
 myTransition.duration = 0.25;
 
 [appdelegate.window.layer addAnimation:myTransition forKey:nil];
 
 appdelegate.window.rootViewController = [menuObject objectForKey:contentsName];
 
 }
 */






- (void)viewWillDisappear:(BOOL)animated
{
	if (cm != nil) {
		[cm cancelCommunication];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *now = [[NSDate alloc] init];
	NSLog(@"asdh;flaksdf%@", now);
    
    // 날짜 포맷.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM-dd"];
	
	
	NSString *theDate = [dateFormat stringFromDate:now];
//	NSLog(@"theDate[%@]",theDate);
    NSArray *tempArray = [theDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    NSString *stringMonth =  [tempArray objectAtIndex:0];
    NSString *stringDay =  [tempArray objectAtIndex:1];
    if ([stringMonth isEqualToString:@"01"]) {
        monthLabel.text = @"JAN";
    }else if([stringMonth isEqualToString:@"02"]){
        monthLabel.text = @"FEB";
    }else if([stringMonth isEqualToString:@"03"]){
        monthLabel.text = @"MAR";
    }else if([stringMonth isEqualToString:@"04"]){
        monthLabel.text = @"APR";
    }else if([stringMonth isEqualToString:@"05"]){
        monthLabel.text = @"MAY";
    }else if([stringMonth isEqualToString:@"06"]){
        monthLabel.text = @"JUN";
    }else if([stringMonth isEqualToString:@"07"]){
        monthLabel.text = @"JUL";
    }else if([stringMonth isEqualToString:@"08"]){
        monthLabel.text = @"AUG";
    }else if([stringMonth isEqualToString:@"09"]){
        monthLabel.text = @"SEP";
    }else if([stringMonth isEqualToString:@"10"]){
        monthLabel.text = @"OCT";
    }else if([stringMonth isEqualToString:@"11"]){
        monthLabel.text = @"NOV";
    }else if([stringMonth isEqualToString:@"12"]){
        monthLabel.text = @"DEC";
    }
    
    
    dateLabel.text =  stringDay;
    
    
    
	
    
    [dateFormat release];
	[now release];
	//	CGRect scrollRect = [[UIScreen mainScreen] bounds]; 
	//	
	//	//--- 하단부로 좌표 이동 ---//
	//	scrollRect.origin.y = scrollRect.size.height - 150;
	//	scrollRect.size.height = 74;
	//	
	//	self.tabScrollView.frame = scrollRect;
	
	
	self.tabScrollView.frame = CGRectMake(0, 30, 768, 100) ;
	self.tabScrollView.contentSize = CGSizeMake(1225, 100) ;
	
	[tabScrollView addSubview:dataView];
	[self.view addSubview:tabScrollView];
	[self.view bringSubviewToFront:self.rightArrowImage];
	[self.view bringSubviewToFront:self.leftArrowImage];
	
	if( tabScrollView.contentOffset.x > 204 ) { 
		self.leftArrowImage.hidden = NO ;
		self.rightArrowImage.hidden = YES; 
	}
	else {
		self.leftArrowImage.hidden = YES ;
		self.rightArrowImage.hidden = NO ; 
	}
	/*
	 CGAffineTransform oriT;
	 oriT = rightArrowImage.transform;
	 // 대상 view의 transform 초기화
	 rightArrowImage.transform = CGAffineTransformIdentity;
	 // 50만큼 내리기
	 CGRect aRect = rightArrowImage.frame;
	 aRect.origin.y = aRect.origin.x - 50;
	 rightArrowImage.frame = aRect;
	 // 원래 transform을 넣어주기
	 rightArrowImage.transform = oriT;
	 */
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [monthLabel release];
    monthLabel = nil;
    [dateLabel release];
    dateLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { 
	//	//NSLog(@"scrollviewDidScroll !!!!!!!!! offSet X: %f  Y: %f" , scrollView.contentOffset.x ,  scrollView.contentOffset.y);	
	
	int width = scrollView.frame.size.width;
	// -30 (153)
	if( scrollView.contentOffset.x > (1200 - width) ) { 
		//--- end
		self.leftArrowImage.hidden = NO ;
		self.rightArrowImage.hidden = YES ; 
	}
	else if( scrollView.contentOffset.x > 72 &&  scrollView.contentOffset.x <= (1200 - width) ) {
		//--- middle
		self.leftArrowImage.hidden = NO ;
		self.rightArrowImage.hidden = NO ; 
	}
	else {
		//--- start
		self.leftArrowImage.hidden = YES ;
		self.rightArrowImage.hidden = NO ; 
	}
	
}

- (void)dealloc {
    [monthLabel release];
    [dateLabel release];
    [super dealloc];
	[dataView release];
	
	[tabScrollView release];
	
}

-(void)AIACallInSub:(int)tagNum {
	
	cm = [[Communication alloc] init];
	cm.delegate = self;
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *urlString = nil;
	
	switch (tagNum) {
		case 16:
			// 세일즈꾸러미
			urlString = [userDefault objectForKey:@"URL_SALESPACK"];
			
			break;
		case 17:
			// 영상카탈로그 
			urlString = [userDefault objectForKey:@"URL_SALESCATALOG"];
			
			break;
		case 18:
			// 마이캘린더
			urlString = [userDefault objectForKey:@"URL_MYCALENDAR"];
			
			break;
		case 19:
			// 스마트컨설팅
			urlString = [userDefault objectForKey:@"URL_SMARTCONSULTING"];
			
			break;
			
			/* 반영제외 
		case 20:
			// 모바일네오스
			urlString = [userDefault objectForKey:@"URL_MOBILENEOSS"];
			
			break;
		case 21:
			// 모바일샵
			urlString = [userDefault objectForKey:@"URL_MOBILESHOP"];
			
			break;
		case 22:
			// 전자청약
			urlString = [userDefault objectForKey:@"URL_MOBILEAPPLICANT"];
			
			break;
			 */
		default:
			break;
	}
	
	BOOL rslt = [cm callWithArray:nil serviceUrl:urlString];	
	if(rslt != YES) {
		//--- there's no network error message on main menu
	}
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 999) {
		//--- 다운로드페이지로 리다이렉트
		if(buttonIndex !=[alertView cancelButtonIndex])
		{	
			Clipboard *clip = [Clipboard sharedClipboard];
			NSURL *url = [NSURL URLWithString:[clip clipKey:@"customDownloadURL"]];
			[[UIApplication sharedApplication] openURL:url];
		}
		
	}
	else {
		//--- nothing tag ---//
	}
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	NSDictionary *singles = (NSDictionary *)[_resultDic valueForKey:@"result"];
	
	NSString *rsltCode = [singles objectForKey:@"code"];
	if(rsltCode == nil) {
		return;
	}	
	if([rsltCode intValue] == 0){
		// App-In-App Communication mode
		NSString *downUrlInfo = [_resultDic objectForKey:@"downurl"];
		NSString *customUrlInfo = [_resultDic objectForKey:@"customurl"];
		
		NSURL *testUrl = [NSURL URLWithString:customUrlInfo];
		BOOL testURLOpen = [[UIApplication sharedApplication] canOpenURL:testUrl];
		
		if (testURLOpen) {
			
			[[UIApplication sharedApplication] openURL:testUrl];
		} else {
			
			Clipboard *clipboard = [Clipboard sharedClipboard];
			[clipboard clipValue:downUrlInfo clipKey:@"customDownloadURL"];
			
			//NSString *message = [NSString stringWithFormat:@"fail open URL: %@", testString];
			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"애플리케이션 설치"
																   message:@"해당 애플리케이션이 설치되어 있지 않습니다. 확인 버튼을 누르시면 다운로드 페이지로 이동합니다." delegate:self
														 cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
			
			openURLAlert.tag = 999;
			[openURLAlert show];
			[openURLAlert release];
			
			// open download page
		}
		
		
	}
	else if([rsltCode intValue] == 1) {
		NSString *string3 = [singles objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:string3 delegate:nil
											  cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release]; 
	}
}

@end

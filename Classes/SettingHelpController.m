//
//  SettingHelpController.m
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingHelpController.h"
#import "Communication.h"
#import "URL_Define.h"


@implementation SettingHelpController

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
	/*
	//NSLog(@"LogInController result : %@", resultDic);
	//NSLog(@"LogInController code : %@", [resultDic objectForKey:@"code"]);
	//NSLog(@"LogInController errDesc: %@", [resultDic objectForKey:@"errdesc"]);
	//NSLog(@"LogInController totalCount: %@", [resultDic objectForKey:@"totalcount"]);
	//NSLog(@"LogInController totalPage: %@", [resultDic objectForKey:@"totalpage"]);
	*/
	
	NSNumber *rsltCode = [resultDic objectForKey:@"code"];
	
	if ([rsltCode intValue] != 0) {
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}
	else {
		//--- login success ---//		
		//--- ID 모드이면 ID데이터 저장
		
//		NSDictionary *authinfoDic = (NSDictionary *)[_resultDic objectForKey:@"authinfo"];
	}	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[indicator stopAnimating];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

-(void)viewDidLoad {
	self.title = @"이용 안내";
	
	/*
	CGRect temp =  self.view.frame;
	temp.size.width = 500.0;
	self.view.frame = temp;
*/
	
	NSURL *url = [[NSURL alloc] initWithString:URL_getsettingHelp];
	//NSURL *url = [[NSURL alloc] initWithString:@"http://m.naver.com"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[webView loadRequest:request];
	
	//temp =  self.view.frame;

	//self.navigationController.view.frame

	
//	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_setting_help.png"]];
//	CGRect tmpRect = imageView.frame;
//	
//	scrollView.contentSize = tmpRect.size;
//	
//	[scrollView addSubview:imageView];
	
	
//	Communication *cm = [[Communication alloc] init];
//	NSMutableDictionary *authRequest = [[NSMutableDictionary alloc] init];
//	int rslt = [cm callWithArray:authRequest serviceUrl:URL_getsettingHelp];
//	if(rslt != YES) {
//		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"<통신 장애 발생>"
//													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//		[alert show];	
//		[alert release];
//	}
	
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
}


- (void)dealloc {
    [super dealloc];
}


@end

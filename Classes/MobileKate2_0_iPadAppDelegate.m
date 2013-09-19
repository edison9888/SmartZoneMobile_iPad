	//
	//  MobileKate2_0_iPadAppDelegate.m
	//  MobileKate2.0_iPad
	//
	//  Created by nicejin on 11. 2. 14..
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import "MobileKate2_0_iPadAppDelegate.h"
#import "Clipboard.h"
#import "URL_Define.h"
#import "MainMenuController.h"
#import "SearchEmployeeSplitView.h"

	//#import "MobileKate2_0_iPadViewController.h"

@implementation MobileKate2_0_iPadAppDelegate

@synthesize window;
@synthesize loginController;
@synthesize comm;
@synthesize firstStartFlag;
@synthesize mainMenuController;

#pragma mark -
#pragma mark APNS

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{ 
	/*
	//NSLog(@"APNS Device Token before: %@", deviceToken); 
	
	
	NSMutableString *deviceId = [NSMutableString string]; 
	const unsigned char* ptr = (const unsigned char*) [deviceToken bytes]; 
	
	for(int i = 0 ; i < 32 ; i++) 
	{ 
		[deviceId appendFormat:@"%02x", ptr[i]]; 
	} 
	
	//NSLog(@"APNS Device Token: %@", deviceId); 
	*/
	//NSString *devTokens = (NSString *)devToken;
	Clipboard *clipboard = [Clipboard sharedClipboard];
	[clipboard clipValue:[NSString stringWithFormat:@"%@", deviceToken] clipKey:@"devTokens"];
	
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", deviceToken]
												   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	
	[alert show];	
	[alert release];
	*/
	
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	/*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"두글자 이상 입력하세요."
	 delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	 
	 [alert show];	
	 [alert release];
	 
	 */
	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{ 
	/*
	 NSString *string = [NSString stringWithFormat:@"%@", userInfo]; 
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil
	 cancelButtonTitle:@"OK"
	 otherButtonTitles:nil]; 
	 [alert show]; 
	 [alert release]; 
	 */
	NSString *string3 = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"badge"] ]; 
	/*
	 UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:nil message:string3 delegate:nil
	 cancelButtonTitle:@"OK"
	 otherButtonTitles:nil]; 
	 [alert3 show]; 
	 [alert3 release]; 
	 */	
	NSInteger badge = [string3 intValue];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//[Clipboard alloc];

		// Override point for customization after app launch. 
    [self.window addSubview:loginController.view];
    [self.window makeKeyAndVisible];
	//[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	
	NSDictionary *userInfo = [launchOptions objectForKey:
							  UIApplicationLaunchOptionsRemoteNotificationKey]; 
	
	if(userInfo != nil) 
	{ 
		[self application:application didFinishLaunchingWithOptions:userInfo]; 
		/*
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", userInfo]
		 delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		 
		 [alert show];	
		 [alert release];
		 */
	} 
	
	// APNS에 디바이스를 등록한다. 
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: 
	 UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound]; 

	self.firstStartFlag = YES;
	
	self.mainMenuController = [[MainMenuController alloc] init];
	[mainMenuController retain];
	noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(sessionTimeoutAction) name:@"SessionTimeout" object:nil];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	//UIViewController *tempview = self.window.rootViewController;
	//NSLog(@"%@", self.window.rootViewController);
	
	if(self.firstStartFlag == NO && self.window.rootViewController != nil && [self.window.rootViewController isKindOfClass:[LogInController class]] == false) {
		//NSLog(@"active! do ping check!");
		//NSLog(@"enter foreground!");
		//UIViewController *tempview = [self.navigationController visibleViewController];
		//NSLog(@"%@", [[self.navigationController visibleViewController] class]);
		/*
		 if([[self.navigationController visibleViewController] isKindOfClass:[MainMenuControl class]]){
		 // no ping!
		 } else {
		 */
		// ping to server
		if(comm != nil){
			//NSLog(@"Release communication class!!");
			comm = nil;
		}
		
		comm = [[Communication alloc] init];
		comm.delegate = self;
		
		// call communicate method
		BOOL result = [comm callWithArray:nil serviceUrl:URL_getPing];
		
		if (!result) {
			// error occurred
			
		}
		//}
		
	} else {
		//NSLog(@"first load");
		self.firstStartFlag = NO;
	}
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	/*
	//NSLog(@"Memory warning!!");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"메모리가 부족하여 프로그램을 종료합니다. 다른 앱들을 완전히 종료한 후에 다시 실행해주세요."
												   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	alert.tag = 998877;
	[alert show];	
	[alert release];
	*/
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 998877) {
		//[[UIApplication sharedApplication] terminateWithSuccess];
	}
}	

- (void)dealloc {
    [loginController release];
    [window release];
	[mainMenuController release];
    [super dealloc];
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	//NSLog(@"Receive Ping result!");
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void) sessionTimeoutAction {
	
	if(self.window.rootViewController != nil && [self.window.rootViewController isKindOfClass:[SearchEmployeeSplitView class]] == TRUE) {
		//SearchEmployeeSplitView *temp = (SearchEmployeeSplitView *)self.window.rootViewController;
		//[temp.view removeFromSuperview];
		[self.window.rootViewController.view removeFromSuperview];
		self.window.rootViewController = nil;
		//temp = nil;
		[self.window.rootViewController release];
	}
	
	[self.mainMenuController.view removeFromSuperview];
	self.mainMenuController = nil;
	[self.mainMenuController release];
	
	self.mainMenuController = [[MainMenuController alloc] init];
	[mainMenuController retain];
	
	self.window.rootViewController = nil;
	self.window.rootViewController = loginController;
}



@end

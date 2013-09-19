	//
	//  MobileKate2_0_iPadAppDelegate.h
	//  MobileKate2.0_iPad
	//
	//  Created by nicejin on 11. 2. 14..
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import <UIKit/UIKit.h>
#import "LogInController.h"
#import "Communication.h"
//#import "SettingNavigationController.h"

@class LogInController;
@class MainMenuController;

@interface MobileKate2_0_iPadAppDelegate : NSObject <UIApplicationDelegate> {

	LogInController *loginController;

	UIWindow *window;
	MainMenuController *mainMenuController;
	NSNotificationCenter *noti;
	Communication *comm;
	BOOL firstStartFlag;
//	SettingNavigationController *settingNaviController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LogInController *loginController;
@property (nonatomic, retain) MainMenuController *mainMenuController;
//@property (nonatomic, retain) IBOutlet SettingNavigationController *settingNaviController;
@property (nonatomic, retain) Communication *comm;
@property (nonatomic, assign) BOOL firstStartFlag;

@end


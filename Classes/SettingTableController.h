//
//  SettingController.h
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileKate2_0_iPadAppDelegate.h"


@interface SettingTableController : UITableViewController {
    
	NSMutableArray *menuList;
	
	UIBarButtonItem *barBtn_home;
	
}

//-(IBAction)action_barBtn_home;

@property (nonatomic, retain) NSMutableArray *menuList;


@end

//
//  OrgNaviRootController.h
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface OrgNaviRootController : UIViewController <CommunicationDelegate, UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView *dataTable;
	NSMutableArray *menuList;
	NSMutableArray *lowerorginfoList;
	NSMutableArray *rowdataList;

	IBOutlet UIActivityIndicatorView *indicator;
	Communication *clipboard;
	
	//UIBarButtonItem *upBarButton;
}
@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) NSMutableArray *lowerorginfoList;
@property (nonatomic, retain) NSMutableArray *userinfo;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *upBarButton;
-(void) loadDetailContentAtIndex:(NSString *)companycd forOrgcd:(NSString *)orgcd;
-(IBAction)myTeamButtonClicked;

@end

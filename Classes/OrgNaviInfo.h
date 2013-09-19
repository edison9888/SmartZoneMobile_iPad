//
//  OrgNaviInfo.h
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "OrgNaviDetailView.h"
@class SplitOverlayViewController;
@interface OrgNaviInfo : UIViewController <CommunicationDelegate, UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView *dataTable;
	NSMutableArray *menuList;
	NSDictionary *currentorginfo;
	
	IBOutlet UIActivityIndicatorView *indicator;
	Communication *clipboard;
	OrgNaviDetailView *detailViewController;

	BOOL companyMode;
	//UIBarButtonItem *upBarButton;
    BOOL isMyDivision;
    SplitOverlayViewController *splitOverlayViewController;
}
@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) NSDictionary *currentorginfo;
@property (nonatomic, assign) BOOL companyMode;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *upBarButton;
@property (nonatomic, retain) OrgNaviDetailView *detailViewController;

@property (nonatomic) BOOL isMyDivision;
@property (nonatomic, retain) SplitOverlayViewController *splitOverlayViewController;

-(void) loadDetailContentAtIndex:(NSString *)companycd forOrgcd:(NSString *)orgcd;
-(IBAction)myTeamButtonClicked;
-(IBAction)companyButtonClicked;
-(IBAction)upBarButtonClicked;

@end

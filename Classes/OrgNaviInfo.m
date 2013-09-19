//
//  OrgNaviInfo.m
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import "OrgNaviInfo.h"
#import "SearchEmployeeDetail.h"
#import "URL_Define.h"
#import "OrgNaviRootController.h"
#import "OrgNaviInfoCustomCell.h"
//#import "OrgNaviDetailView.h"
#import "SplitOverlayViewController.h"
@implementation OrgNaviInfo

@synthesize dataTable;
@synthesize menuList;
@synthesize indicator;
@synthesize clipboard;
@synthesize companyMode;
//@synthesize upBarButton;
@synthesize currentorginfo;
@synthesize detailViewController;
@synthesize isMyDivision;
@synthesize splitOverlayViewController;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"조직도";
	self.dataTable.delegate = self;
	self.dataTable.dataSource = self;
	
	self.clipboard = nil;
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 660);
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	companyMode = NO;
    
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(overlayView) name:@"orgOverlayView" object:nil];
    [noti addObserver:self selector:@selector(overlayViewCancel) name:@"orgOverlayViewCancel" object:nil];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	
	[self.indicator stopAnimating];
	
	if (self.clipboard != nil && self.menuList != nil) {
		[self.clipboard cancelCommunication];
	}
	
}
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
    
    cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrgNaviInfoCustomCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
    }
    //		cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
    
    OrgNaviInfoCustomCell *tmpCell = (OrgNaviInfoCustomCell *)cell;
    //		CalendarScheduleRegisterListCell2 *tmpCell = (CalendarScheduleRegisterListCell2 *)cell;
    
    tmpCell.orgLabel.text = @"";
    tmpCell.iconImageView.image = nil;
    
    tmpCell.iconTitleLabel.text = @"";
    tmpCell.subLabel.text = @"";
    tmpCell.backgroundCustomView.backgroundColor = [UIColor whiteColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	
	
    NSString *rowtype = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"rowtype"];
    if ([rowtype isEqualToString:@"O"]) {//조직일경우
        tmpCell.orgLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"label"];
    }else if([rowtype isEqualToString:@"U"]){
        tmpCell.iconImageView.image = [UIImage imageNamed:@"icon_people.png"];
        tmpCell.iconTitleLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"label"];
        tmpCell.subLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"sublabel"];
        if ([[[self.menuList objectAtIndex:indexPath.row] objectForKey:@"highlightyn"] isEqualToString:@"Y"]) {
            //				tmpCell.backgrondCustomView.backgroundColor = [UIColor whiteColor];
            //				tmpCell.backgroundColor = [UIColor colorWithRed:255/255 green:204/255 blue:102/255 alpha:1];
//            tmpCell.backgroundCustomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            tmpCell.backgroundCustomView.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:0/255 alpha:0.1];

            //				tmpCell.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
            //				
            //				[tmpCell.backgroundView setNeedsDisplay];
            
        }
    }else{
        tmpCell.orgLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"label"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
	
	
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	
	if ([[[self.menuList objectAtIndex:indexPath.row] objectForKey:@"rowtype"]isEqualToString:@"U"]) {
        detailViewController = (OrgNaviDetailView *)[[self.splitViewController.viewControllers objectAtIndex:1] visibleViewController];
		[detailViewController loadDetailContentAtIndex:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"rowkey"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[detailViewController popoverDismiss];
		
		
	}else if([[[self.menuList objectAtIndex:indexPath.row] objectForKey:@"rowtype"]isEqualToString:@"O"]) {
		OrgNaviInfo *orgNaviInfo = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
		[orgNaviInfo loadDetailContentAtIndex:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"companycd"] forOrgcd:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"rowkey"] ];
		[self.navigationController pushViewController:orgNaviInfo animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[orgNaviInfo release];
		
		
	}else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
	
	
	
	
}


#pragma mark -
#pragma mark View comm


-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.dataTable.hidden = NO;
	self.dataTable.userInteractionEnabled = NO;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
    // get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
    ////NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
    // get value dictionary form result dictionary
    
    //	self.userinfo =[NSArray arrayWithArray:[_resultDic objectForKey:@"userinfo"]]
	
    // -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
		[self.menuList removeAllObjects];
		self.currentorginfo = nil;
        
		self.menuList = [NSArray arrayWithArray:[_resultDic objectForKey:@"rowdata"]];
        if ([self.menuList count] == 0) {//조직 정보가 없을 경우 임의의 data 추가해줌
            NSMutableArray *dummyArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
            [requestDictionary setObject:@"" forKey:@"companycd"];
            [requestDictionary setObject:@"" forKey:@"highlightyn"];
            [requestDictionary setObject:@"조직정보가 없습니다." forKey:@"label"];
            [requestDictionary setObject:@"" forKey:@"rowkey"];
            [requestDictionary setObject:@"S" forKey:@"rowtype"];
            
            [requestDictionary setObject:@"" forKey:@"sublabel"];
            [dummyArray addObject:requestDictionary];
            [requestDictionary release];
            self.menuList = [NSArray arrayWithArray:dummyArray];
        }
		self.currentorginfo =  (NSDictionary *)[_resultDic objectForKey:@"currentorginfo"];
        self.title = [currentorginfo objectForKey:@"orgnm"];
        
		[self.dataTable reloadData];
		self.dataTable.hidden = NO;
		self.dataTable.userInteractionEnabled = YES;
		self.clipboard = nil;
		/*	} else if (resultNum == 2) {
		 NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
		 [noti postNotificationName:@"SessionFailed" object:self];*/
	} else {
        // -- error handling -- //
        // Show alert view to user
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator stopAnimating];
	self.dataTable.userInteractionEnabled = YES;
    // Alert network error message
    ////NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 접속에 실패하였습니다."
												   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alert show];	
	[alert release];
 }
#pragma mark -
#pragma mark View event

-(void) loadData{
	companyMode = YES;
	
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	[self.menuList removeAllObjects];
	
    // make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
 	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getCompanyInfo];
	
	if (!result) {
        // error occurred
		
	}
	
}
-(IBAction)myTeamButtonClicked{
     if(isMyDivision != YES) {

	OrgNaviInfo *orgNaviInfo = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
    //	[orgNaviInfo loadDetailContentAtIndex:compcd forOrgcd:login_organizationid];
    //서버 수정으로 아무것도 안넘김
    [orgNaviInfo loadDetailContentAtIndex:@"" forOrgcd:@""];
        orgNaviInfo.isMyDivision = YES;
	[self.navigationController pushViewController:orgNaviInfo animated:YES];
	[orgNaviInfo release];
	}
}
-(IBAction)companyButtonClicked{
	OrgNaviRootController *orgNaviRootController = [[OrgNaviRootController alloc] initWithNibName:@"OrgNaviRootController" bundle:nil];
	[orgNaviRootController loadData];
	[self.navigationController pushViewController:orgNaviRootController animated:YES];
	[orgNaviRootController release];
	
}
-(IBAction)upBarButtonClicked{
	if ([currentorginfo objectForKey:@"upperorgcd"] !=nil) {
		NSString *companycd= [currentorginfo objectForKey:@"companycd"];
		NSString *upperorgcd= [currentorginfo objectForKey:@"upperorgcd"];
		OrgNaviInfo *orgNaviInfo = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
		[orgNaviInfo loadDetailContentAtIndex:companycd forOrgcd:upperorgcd];
//		[self.navigationController pushViewController:orgNaviInfo transition:8];//위로 올라가는 애니메이션
        [self.navigationController pushViewController:orgNaviInfo animated:YES];

		[orgNaviInfo release];
		
	}else {
		OrgNaviRootController *orgNaviRootController = [[OrgNaviRootController alloc] initWithNibName:@"OrgNaviRootController" bundle:nil];
		[orgNaviRootController loadData];
		[self.navigationController pushViewController:orgNaviRootController animated:YES];
		[orgNaviRootController release];
		
	}
    
	
}
-(void) loadDetailContentAtIndex:(NSString *)companycd forOrgcd:(NSString *)orgcd{
    //Communication *
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	self.menuList = nil;
	
    // make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:companycd forKey:@"companycd"];
	[requestDictionary setObject:orgcd forKey:@"orgcd"];
    //	[requestDictionary setObject:@"10" forKey:@"maxrow"];
    //NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    ////NSLog(@"%@", [tempDefaults stringForKey:@"login_id"]);
	
    //[requestDictionary setObject:[tempDefaults stringForKey:@"login_id"] forKey:@"userid"];
    //[requestDictionary setObject:@"b55555555" forKey:@"userid"];
	
    // call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getOrgInfo];
	
	if (!result) {
        // error occurred
		
	}
	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[dataTable release];
	[self.menuList release];
	[indicator release];
	[clipboard release];
	
    [super dealloc];
}
#pragma overay event
- (void)overlayView{
    
    // View의 폭에 맞게 툴바를 설정한다.
    
    //Add the overlay view.
	if(splitOverlayViewController == nil)
		splitOverlayViewController = [[SplitOverlayViewController alloc] initWithNibName:@"SplitOverlayViewController" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
    
	CGFloat width = self.view.frame.size.width;
    //	CGFloat height = self.view.frame.size.height;
    CGFloat height = 800;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 0, width, height);
	splitOverlayViewController.view.frame = frame;	
	splitOverlayViewController.view.backgroundColor = [UIColor grayColor];
	splitOverlayViewController.view.alpha = 0.5;
	
	
	[self.view addSubview:splitOverlayViewController.view ];
    
    
}
- (void)overlayViewCancel{
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
	[splitOverlayViewController.view removeFromSuperview];
	[splitOverlayViewController release];
	splitOverlayViewController = nil;
    
//	self.currentTableView.contentOffset = CGPointMake(0, 0);
//	CGFloat width = self.view.frame.size.width;
//    
//	self.currentTableView.tableHeaderView.frame = CGRectMake(0, 0, width, 44);
}


@end


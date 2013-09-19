//
//  OrgNaviRootController.m
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import "OrgNaviRootController.h"
#import "SearchEmployeeDetail.h"
#import "URL_Define.h"
#import "OrgNaviInfo.h"
#import "OrgNaviInfoCustomCell.h"
@implementation OrgNaviRootController

@synthesize dataTable;
@synthesize menuList;
@synthesize indicator;
@synthesize clipboard;
@synthesize lowerorginfoList;
@synthesize userinfo;
//@synthesize upBarButton;
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
	tmpCell.orgLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"orgnm"];
    
	
	
    return cell;
	
	
	
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
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
	self.menuList = nil;
    //	self.userinfo =[NSArray arrayWithArray:[_resultDic objectForKey:@"userinfo"]]
	
    
    
    // -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
        self.menuList = [NSArray arrayWithArray:[_resultDic objectForKey:@"companyinfo"]];
        
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
	/*
	 // test for non comm
	 
	 NSMutableArray *tempNoticeArray = [[NSMutableArray alloc] init];
	 NSMutableDictionary *tempNoticeDictionary = [[NSMutableDictionary alloc] init];
	 [tempNoticeDictionary setObject:@"A" forKey:@"boardid"];
	 [tempNoticeDictionary setObject:@"전체 공지사항" forKey:@"boardname"];
	 [tempNoticeArray addObject:tempNoticeDictionary];
	 tempNoticeDictionary = nil;
	 
	 tempNoticeDictionary = [[NSMutableDictionary alloc] init];
	 [tempNoticeDictionary setObject:@"B" forKey:@"boardid"];
	 [tempNoticeDictionary setObject:@"부문 공지사항" forKey:@"boardname"];
	 [tempNoticeArray addObject:tempNoticeDictionary];
	 
	 self.menuList = tempNoticeArray;
	 
	 [self.tableView reloadData];
	 */
}

-(void) loadData{
    
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	self.menuList = nil;
	
    // make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
 	
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getCompanyInfo];
	
	if (!result) {
        // error occurred
		
	}
	
}
-(IBAction)myTeamButtonClicked{
    //	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //	NSString *compcd = [userDefault stringForKey:@"login_compcd"];
    //	NSString *login_organizationid = [userDefault stringForKey:@"login_organizationid"];

	OrgNaviInfo *orgNaviInfo = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
    //	[orgNaviInfo loadDetailContentAtIndex:compcd forOrgcd:login_organizationid];
    //서버 수정됨. 그래서 아무것도 안넘김
    [orgNaviInfo loadDetailContentAtIndex:@"" forOrgcd:@""];
    orgNaviInfo.isMyDivision = YES;
	[self.navigationController pushViewController:orgNaviInfo animated:YES];
	[orgNaviInfo release];
	
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
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getOrgInfo];
	
	if (!result) {
        // error occurred
		
	}
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    // Navigation logic may go here. Create and push another view controller.
    OrgNaviInfo *orgNaviInfo = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
    //	orgNaviRootController.title = [[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"boardname"] ;
    //	orgNaviRootController.categoryCode = [[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"boardid"] ;
	[orgNaviInfo loadDetailContentAtIndex:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"companycd"] forOrgcd:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"orgcd"] ];
    //	companycd = 1001;
    //	companynm = KT;
    //	orgcd = 000001;
    //	
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:orgNaviInfo animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [orgNaviInfo release];
	
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


@end


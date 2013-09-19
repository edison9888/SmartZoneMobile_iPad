    //
//  FAQRootViewController.m
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import "FAQRootViewController.h"
#import "FAQListViewController.h"
#import "FAQDetailViewController.h"
#import "URL_Define.h"

@implementation FAQRootViewController

@synthesize dataTable;
@synthesize menuList;
@synthesize indicator;
@synthesize clipboard;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"열린토론방";
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
	
	if (self.clipboard != nil && self.menuList != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];
}

- (void)dealloc {
	
	[dataTable release];
	[self.menuList release];
	[indicator release];
	[clipboard release];
	
    [super dealloc];
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	//NSDictionary *tmpDic = [self.menuList objectAtIndex:indexPath.row];
	//NSString *tmpString = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"boardname"];
	cell.textLabel.font = [UIFont fontWithName:@"Helvatica" size:4.0f];
	cell.textLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"boardname"];
	//cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	//cell.indentationLevel = indexPath.row;
    
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Navigation logic may go here. Create and push another view controller.
    FAQListViewController *detailListController = [[FAQListViewController alloc] initWithNibName:@"FAQListViewController" bundle:nil];
	//detailListController.title = [[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"boardname"] ;
	detailListController.boardId = [NSString stringWithString:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"boardid"]] ;
	detailListController.orderBy = [NSString stringWithString:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"orderby"]] ;
	detailListController.sortBy = [NSString stringWithString:[[self.menuList objectAtIndex:[indexPath row]]objectForKey:@"sortby"]] ;
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailListController animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [detailListController release];
	 
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.dataTable.hidden = NO;
	self.dataTable.userInteractionEnabled = NO;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	//NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
	self.menuList = nil;
	self.menuList = [NSArray arrayWithArray:[_resultDic objectForKey:@"boardlist"]];
	
	// -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
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
	//NSLog(@"%@", error);
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

-(void) loadData {
	
	//Communication *
	if (self.clipboard) {
		[self.clipboard release];
	}
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	self.menuList = nil;
	
	// make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:@"1" forKey:@"cpage"];
	[requestDictionary setObject:@"10" forKey:@"maxrow"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQAllBoardListEx];
	
	if (!result) {
		// error occurred
		
	}
	
}


@end

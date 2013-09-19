//
//  BoardDetailListController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "BoardDetailListController.h"
#import "BoardDetailContentController.h"

#import "URL_Define.h"

@implementation BoardDetailListController
@synthesize dataTable;
@synthesize indicator;
@synthesize boardList;
@synthesize categoryCode;
@synthesize nextCell;

@synthesize currentPage;
@synthesize clipboard;
@synthesize morePageFlag;
@synthesize nextButton;
@synthesize resultDictionary;
@synthesize detailViewController;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    resultDictionary = [[NSMutableDictionary alloc ]initWithCapacity:0];

    self.contentSizeForViewInPopover = CGSizeMake(320, 660);
    
    self.detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
	self.dataTable.delegate = self;
	self.dataTable.dataSource = self;
	self.clipboard = nil;
	self.morePageFlag = YES;
	
//	CGRect oldFrame = self.indicator.frame;
//	oldFrame.size.width = 30;
//	oldFrame.size.height = 30;
//	self.indicator.frame = oldFrame;
//    CGPoint center_point;
//    center_point.x = 100;
//    center_point.y = 100;
//	self.indicator.center = center_point;
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = NSLocalizedString(@"btn_back", @"뒤로");
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"list_focus.png"] forState:UIControlStateHighlighted];
	
	//Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	self.currentPage = 1;
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//	[requestDictionary setObject:@"1001" forKey:@"compcd"];
	[requestDictionary setObject:self.categoryCode forKey:@"boardid"];
//	[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"cpage"];
	[requestDictionary setObject:MAXROW forKey:@"pcount"];
	//[requestDictionary setObject:@"b55555555" forKey:@"userid"];
	[requestDictionary setObject:@"" forKey:@"searchkeyword"];
	[requestDictionary setObject:@"" forKey:@"searchtype"];
	[requestDictionary setObject:@"" forKey:@"sortorder"];
	[requestDictionary setObject:@"" forKey:@"sorttype"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:getBoardList];
	
	if (!result) {
		// error occurred
		
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ( [self.boardList count] > 0) {
		if (self.morePageFlag) {
			return [self.boardList count]+1;
		} else {
			return [self.boardList count];
		}
        
	}
    return 0;//[self.menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
	if (indexPath.row == [self.boardList count]) {
		cell = nextCell;
	} else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ListCustomCell" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		
		// Configure the cell...
        
		NSDictionary *tmpDic = [self.boardList objectAtIndex:indexPath.row];
        
		UIView *tempBgView = (UIView *)[cell viewWithTag:10];
		if (indexPath.row == 0 || indexPath.row%2 == 0) {
			tempBgView.backgroundColor = [UIColor whiteColor];
		} else {
			tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
		}

//		UILabel *tempTitleLabel = (UILabel *)[cell viewWithTag:11];
//		tempTitleLabel.text = [tmpDic objectForKey:@"title"];
		UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:12];
		tempNameLabel.text = [tmpDic objectForKey:@"author"];
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];
		tempDateLabel.text = [tmpDic objectForKey:@"createdtime"];
        tempNameLabel.backgroundColor = [UIColor clearColor];

        
        
        NSString *mail_hasattachment = [tmpDic objectForKey:@"isAttachment"];
		if ([mail_hasattachment isEqualToString:@"1"]) {
			CGRect loadImageRect = CGRectMake(7,4,15,15);
            //		CGRect mailFromeIdRect = mailFromID.frame 
            //		mailFromID.frame.size.width
			UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
			cellImage.image = [UIImage imageNamed:@"img_clip.png"];
			
			
			[cell.contentView addSubview:cellImage];
			
			[cellImage release];
			
			
			
			CGRect loadValueRect = CGRectMake(28,0,260,21);
			UILabel *mailFromID = [[UILabel alloc] initWithFrame:loadValueRect];
			mailFromID.font = [UIFont boldSystemFontOfSize:14];
			mailFromID.text = [tmpDic objectForKey:@"title"];
			mailFromID.backgroundColor = [UIColor clearColor];

			[cell.contentView addSubview:mailFromID];
			[mailFromID release];
		}else {
            
			CGRect loadValueRect = CGRectMake(7,0,260,21);
			UILabel *mailFromID = [[UILabel alloc] initWithFrame:loadValueRect];
			mailFromID.font = [UIFont boldSystemFontOfSize:14];
			mailFromID.text = [tmpDic objectForKey:@"title"];
            mailFromID.backgroundColor = [UIColor clearColor];

			[cell.contentView addSubview:mailFromID];
			[mailFromID release];
            
		}

        
        
        
        
	}
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
    
    if (indexPath.row == [self.boardList count]) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
		[detailViewController loadDetailContentAtIndex:[[self.boardList objectAtIndex:indexPath.row] objectForKey:@"attachid"] forCategory:self.categoryCode];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[detailViewController popoverDismiss];
	}

    
    // Navigation logic may go here. Create and push another view controller.
//    if (indexPath.row == [self.boardList count]) {
//		[tableView deselectRowAtIndexPath:indexPath animated:NO];
//	} else {
//		
//		BoardDetailContentController *detailContentController = [[BoardDetailContentController alloc] initWithNibName:@"BoardDetailContentController" bundle:nil];
//		detailContentController.title = self.title;
//		//[detailContentController loadDetailContentAtIndex:[indexPath row]];
//		// Pass the selected object to the new view controller.
//		[self.navigationController pushViewController:detailContentController animated:YES];
//        
//		[detailContentController loadDetailContentAtIndex:[[self.boardList objectAtIndex:indexPath.row] objectForKey:@"attachid"] forCategory:self.categoryCode];
//		[detailContentController release];
//		[tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
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
	[indicator release];
	[boardList release];
	[categoryCode release];
	[nextCell release];
	[clipboard release];
	[nextButton release];
    [resultDictionary release];
    [super dealloc];
    
    
    
    
    

}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
    //	self.dataTable.hidden = YES;
	self.dataTable.userInteractionEnabled = NO;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	// get result data from result dictionary
    [self.resultDictionary removeAllObjects];
	self.resultDictionary = [_resultDic objectForKey:@"result"];
	////NSLog(@"%@", resultDictionary);
	int resultNum = [(NSString *)[resultDictionary objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
	if (resultNum == 0 && resultDictionary != nil) {
		NSArray *tmpResult = [NSArray arrayWithArray:(NSArray *)[_resultDic objectForKey:@"blist"]];
		////NSLog(@"%@", tmpResult);
		if (self.boardList == nil) {
			self.boardList = (NSMutableArray *)tmpResult;
		} else {
			//[self.noticeList addObjectsFromArray:[NSArray arrayWithArray:(NSArray *)[_resultDic objectForKey:@"boardlistinfo"]]];
			self.boardList = (NSMutableArray *)[self.boardList arrayByAddingObjectsFromArray:tmpResult];
		}
		if ([tmpResult count] < [MAXROW intValue]) {
			self.morePageFlag = NO;
		}
		if ([tmpResult count] > 0) {
			[self.dataTable reloadData];
			self.dataTable.hidden = NO;
			self.clipboard = nil;
		}
        self.dataTable.userInteractionEnabled = YES;

	} else {
		// -- error handling -- //
		// Show alert view to user
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDictionary objectForKey:@"errdesc"]
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;
	
}

-(IBAction) nextCellClicked {
//    NSLog(@"%@", self.resultDictionary);
	NSString *nextPage = [resultDictionary objectForKey:@"nextpage"];
    NSLog(@"nextpage[%@]", nextPage);
	self.morePageFlag = YES;
	
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//	[requestDictionary setObject:@"1001" forKey:@"compcd"];
	[requestDictionary setObject:nextPage forKey:@"page"];
	[requestDictionary setObject:self.categoryCode forKey:@"boardid"];
	[requestDictionary setObject:MAXROW forKey:@"pcount"];
	//[requestDictionary setObject:@"b55555555" forKey:@"userid"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:getBoardList];
	
	if (!result) {
		// error occurred
		
	}
}

@end



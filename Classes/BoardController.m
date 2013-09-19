//
//  BoardController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "BoardController.h"
#import "URL_Define.h"
#import "BoardDetailListController.h"

@implementation BoardController
@synthesize menulist;
@synthesize afterProcessBoardList;
@synthesize indicator;
@synthesize clipboard;



#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    //	[self.currentTableView reloadData];	
    
//	[self tr_data]; 
	
	
}

-(void)viewDidLoad {
	self.title = NSLocalizedString(@"board_title", @"게시판");
    
    self.afterProcessBoardList = [[NSMutableArray alloc ]initWithCapacity:0];
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 660);
    
	self.menulist.delegate = self;
	self.menulist.dataSource = self;
	
	self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = NSLocalizedString(@"btn_back", @"뒤로");
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];

    [self tr_data]; 
	/*
     // JB test start
     //	PureCheck *pureClass = [[PureCheck alloc] init];
     //	int flag = [pureClass isPure];
     //	[pureClass release];
     //	
     //	if (flag == 1) {
     //		// jailbreaked phone!!
     //		//NSLog(@"jailbreaked phone!!");
     //		// show alert!
     //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안 내" message:@"탈옥된 기기에서는 사용하실 수 없습니다. 확인을 누르시면 mobile kate를 종료합니다."
     //													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
     //		alert.tag = 99999;
     //		[alert show];	
     //		[alert release];
     //		// termination code
     //		[[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
     //	}
     //	
     // JB test end
	 */
	
	[super viewDidLoad];
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
    return [afterProcessBoardList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([[[self.afterProcessBoardList objectAtIndex:indexPath.row] objectForKey:@"isvisible"]isEqualToString:@"1"]) {
        // Configure the cell...
        cell.textLabel.font = [UIFont fontWithName:@"Helvatica" size:4.0f];
        cell.textLabel.text = [[self.afterProcessBoardList objectAtIndex:indexPath.row] objectForKey:@"title"];	
        cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if (indexPath.row == 0 || indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];	
            cell.textLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		

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
    // Navigation logic may go here. Create and push another view controller.
    
    BoardDetailListController *detailListController = [[BoardDetailListController alloc] initWithNibName:@"BoardDetailListController" bundle:nil];
	detailListController.title = [[self.afterProcessBoardList objectAtIndex:[indexPath row]]objectForKey:@"title"] ;
	detailListController.categoryCode = [[self.afterProcessBoardList objectAtIndex:[indexPath row]]objectForKey:@"boardid"] ;
    // ...
    // Pass the selected object to the new view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:detailListController animated:YES];
    [detailListController release];
    
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
	[menulist release];
	[afterProcessBoardList release];
	[indicator release];
	[clipboard release];
    
    [super dealloc];
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.menulist.hidden = YES;
	self.menulist.userInteractionEnabled = NO;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	////NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc]initWithCapacity:0];
    
	tempMutableArray = (NSMutableArray *)[_resultDic objectForKey:@"boplist"];
	
	[self saveProcess:tempMutableArray];
    
	
	// -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
		[self.menulist reloadData];
		self.menulist.hidden = NO;
		self.menulist.userInteractionEnabled = YES;
		self.clipboard = nil;
	} else {
		// -- error handling -- //
		// Show alert view to user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator stopAnimating];
	self.menulist.userInteractionEnabled = YES;
	// Alert network error message
	//NSLog(@"%@", error);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];

}

-(void) tr_data {
	
	//Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;

    
    
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //	[requestDictionary setObject:@"1001" forKey:@"compcd"];
    //	[requestDictionary setObject:@"1" forKey:@"cpage"];
    //	[requestDictionary setObject:@"10" forKey:@"maxrow"];
	int rslt = [clipboard callWithArray:requestDictionary serviceUrl:getBoardListCollection];
	if (rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}		

	
}

-(void) saveProcess: (NSMutableArray *)commArray{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault objectForKey:@"settingBoard"] != nil) {
        
    }else{
        [userDefault setObject:commArray forKey:@"settingBoard"];
        [userDefault synchronize];
        
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    for (int i=0; i < [commArray count]; i++) {
        dic1 = nil;
        dic1 = [commArray objectAtIndex:i];
        NSString *dic1String = [dic1 objectForKey:@"isdefault"];
        
        if([dic1String isEqualToString:@"1"]){
            [tempArray addObject:dic1];
        }else{
            BOOL findMatchingObject = NO;
            for (int j=0; j < [[userDefault objectForKey:@"settingBoard"] count]; j++) {
                dic2 = nil;
                dic2 = [[userDefault objectForKey:@"settingBoard"] objectAtIndex:j];
                NSString *dic1String = [dic1 objectForKey:@"boardid"];
                NSString *dic2String = [dic2 objectForKey:@"boardid"];
                
                if ([dic1String isEqualToString:dic2String]) {
                    
                    if([dic2 objectForKey:@"isvisible"] !=nil){//서버에서 온 data에 사용자 저장값만 추가 
                        [dic1 setObject:[dic2 objectForKey:@"isvisible"] forKey:@"isvisible"];
                        [tempArray addObject:dic1];
                    }else{
                        [dic1 setObject:@"0" forKey:@"isvisible"];//사용자 저장값이 없으면 view를 추가해 준다.
                        [tempArray addObject:dic1];
                    }
                    
                    findMatchingObject = YES;
                    break;
                }
                //서버에서 새로 추가된 것일 경우
                if (findMatchingObject == YES) {
                    [tempArray addObject:dic1];
                }
            }
        }
    }
    [userDefault setObject:tempArray forKey:@"settingBoard"];
    [userDefault synchronize];
    
    [afterProcessBoardList removeAllObjects];
    [afterProcessBoardList setArray:tempArray];
    NSLog(@"afterProcessBoardList[%@]", afterProcessBoardList);

    for (int i=[afterProcessBoardList count]-1; i >= 0; i--) {
        NSLog(@"%@",[[afterProcessBoardList objectAtIndex:i] objectForKey:@"isvisible"]);

        if ([[[afterProcessBoardList objectAtIndex:i] objectForKey:@"isvisible"] isEqualToString:@"1"]) {
            
            
        }else{
            [afterProcessBoardList removeObjectAtIndex:i];

        }
    }
    
    
    
    
    NSLog(@"afterProcessBoardList[%@]", afterProcessBoardList);
    
    //    tempArray = nil;
    //    dic1 = nil;
    //    dic2 = nil;
    //
    //    [tempArray release];
    //    [dic1 release];
    //    [dic2 release];
    [menulist reloadData];
}


@end



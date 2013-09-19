//
//  PaymentStateController.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentStateController.h"


@implementation PaymentStateController
@synthesize dic_selectedItem, dic_approvalLineHeaderInfo, arr_approvalLineListInfo, selectedCategory;

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(IBAction)backButtonPressed {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
	
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	//NSLog(@"PaymentStateController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;		
	}	
	
	if([rsltCode intValue] == 0){
		//--- save document list
		self.dic_approvalLineHeaderInfo = [_resultDic objectForKey:@"approvallineheaderinfo"];
		self.arr_approvalLineListInfo = [_resultDic objectForKey:@"approvallinelistinfo"];
		[currentTableView reloadData];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
}

#pragma mark -
#pragma mark View lifecycle
-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	

	
	
	switch ([self.selectedCategory intValue]) {
		case 1: //category 1 결재할 문서
			//--- UI가 좀 다르다
			self.title = @"결재할 문서";
			break;
		case 2: //category 2 결재한 문서
			self.title = @"결재한 문서";
			break;
		case 9:	//category 9 수신문서
			self.title = @"수신문서";
			break;
		case 10: // category 10 부서수신문서
			self.title = @"부서수신문서";
			break;
		case 5:	// category 5 기안한 문서
			self.title = @"기안한 문서";
			break;
		default:
			break;
	}
	
	
	currentTableView.allowsSelection = NO;
	
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
	
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalLineListInfo];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
	}
	

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
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arr_approvalLineListInfo count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"StateCell" owner:self options:nil];
		cell = [topObject objectAtIndex:0];
    }
	
    // Configure the cell...
	[(UILabel *)[cell viewWithTag:1] setText:[(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"aprmembername"]];
	[(UILabel *)[cell viewWithTag:2] setText:[(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"aprstate"]];
	[(UILabel *)[cell viewWithTag:3] setText:[(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"receiveddate"]];
	
	
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//	NSMutableString *str_cell = [[NSMutableString alloc] init];
//	[str_cell appendFormat:@"%@ ", [(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"aprmembername"]];
//	[str_cell appendFormat:@"%@ ", [(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"aprstate"]];
//	[str_cell appendFormat:@"%@ ", [(NSDictionary *)[arr_approvalLineListInfo objectAtIndex:indexPath.row] objectForKey:@"receiveddate"]];
//	
//	cell.textLabel.text = str_cell;
//	UIFont *tmpFont = cell.textLabel.font;
//	cell.textLabel.font = [tmpFont fontWithSize:15.0];
	
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
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
    [super dealloc];
}


@end


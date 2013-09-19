    //
//  QnARootViewController.m
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QnARootViewController.h"
#import "QnADetailViewController.h"
#import "QnAWriteViewController.h"
#import "URL_Define.h"

#import "CustomBadge2.h"

@implementation QnARootViewController

@synthesize askButton;
@synthesize menuList;
@synthesize tableList;
@synthesize detailViewController;

@synthesize pickerList;
@synthesize currentPage;
@synthesize searchingMode;
@synthesize morePageFlag;

@synthesize pickerBody;
@synthesize pickerView;

@synthesize pickerButton;
@synthesize pickerLabel;
@synthesize searchField;
@synthesize searchButton;
@synthesize nextCell;
@synthesize nextButton;

@synthesize indicatorView;
@synthesize clipboard;
@synthesize reloadflag;

@synthesize pickerToolbar;
@synthesize pickerSelectButton;

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
	self.title = @"알려주세요";
	self.navigationItem.rightBarButtonItem = askButton;
	self.detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
	
	self.pickerList = [NSArray arrayWithObjects:@"전 체", @"제 목", @"내 용", @"작성자",  nil];	
	self.tableList.delegate = self;
	self.tableList.dataSource = self;
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.searchField.delegate = self;
	
	self.currentPage = 1;
	self.morePageFlag = YES;
	self.clipboard = nil;
	self.reloadflag = NO;
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 660);
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	CGRect oldFrame = self.indicatorView.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicatorView.frame = oldFrame;
	self.indicatorView.center = self.view.center;
	
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"list_focus.png"] forState:UIControlStateHighlighted];
	
	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(loadData) name:@"QnAListReload" object:nil];
	[self registerForKeyboardNotifications];
	
	[super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	[self resignKeyboardnPicker];
	[self.indicatorView stopAnimating];
	
	if (self.clipboard != nil && self.menuList != nil) {
		[self.clipboard cancelCommunication];
	}	
	
	[super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated {
	
	if (self.reloadflag == YES) {
		[self loadData];
		self.reloadflag = NO;
	}	
	
	[super viewWillAppear:YES];
}

-(void) setReloadYes {
	self.reloadflag = YES;
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


- (void)dealloc {
	[askButton release];
	[menuList release];
	[tableList release];
	[pickerList release];
	[pickerBody release];
	[pickerView release];
	
	[pickerButton release];
	[pickerLabel release];
	[searchField release];
	[searchButton release];
	[nextCell release];
	[clipboard release];
	[nextButton release];
	
	[indicatorView release];
	[detailViewController release];
	//[popoverController release];
	[pickerToolbar release];
	[pickerSelectButton release];
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
	if ( [self.menuList count] > 0) {
		if (self.morePageFlag) {
			return [self.menuList count]+1;
		} else {
			return [self.menuList count];
		}
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell;
	if (indexPath.row == [self.menuList count]) {
		cell = self.nextCell;
	} else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ListCustomCell" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		
		NSDictionary *tmpDic = [self.menuList objectAtIndex:indexPath.row];
		
		// Configure the cell...
		UIView *tempBgView = (UIView *)[cell viewWithTag:10];
		if (indexPath.row == 0 || indexPath.row%2 == 0) {
			tempBgView.backgroundColor = [UIColor whiteColor];
		} else {
			tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
		}
		
		UILabel *tempTitleLabel = (UILabel *)[cell viewWithTag:11];
		tempTitleLabel.text = [tmpDic objectForKey:@"title"];
		UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:12];
		tempNameLabel.text = [tmpDic objectForKey:@"authname"];
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];
		
		// -- set date -- //
		//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		//[dateFormatter setDateFormat:@"yyyyMMddHHmm"];
		//NSString *dateString = [tmpDic objectForKey:@"date"];
		//NSDate *myDate = [dateFormatter dateFromString:dateString];
		//[dateFormatter setDateFormat:@"yyyy.MM.dd"];
		//tempDateLabel.text = [dateFormatter stringFromDate:myDate];
		tempDateLabel.text = [tmpDic objectForKey:@"date"];
		
		if ([[tmpDic objectForKey:@"replycnt"] intValue] > 0 ) {
			/*
			UIView *tempBadgeView = (UIView *)[cell viewWithTag:14];
			tempBadgeView.hidden = NO;
			UILabel *tempBadgeLabel = (UILabel *)[cell viewWithTag:15];
			//NSLog(@"%@", [[self.menuList objectAtIndex:[indexPath row]] objectForKey:@"replycnt"]);
			//tempBadgeLabel.text = [[tmpDic objectForKey:@"replycnt"] stringValue];
			tempBadgeLabel.text = [tmpDic objectForKey:@"replycnt"];
			 */
			// add badge view 
			CustomBadge2 *replyBadge = [CustomBadge2 customBadgeWithString:[tmpDic objectForKey:@"replycnt"]];
			[replyBadge setFrame:CGRectMake(280, 1, /*replyBadge.frame.size.width*/32, 20)];
			[cell addSubview:replyBadge];
		} else {
			UIView *tempBadgeView = (UIView *)[cell viewWithTag:14];
			tempBadgeView.hidden = YES;
		}
	}
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }∂
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
        // ...
    // Pass the selected object to the new view controller.
	if (indexPath.row == [self.menuList count]) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
		[detailViewController loadDetailContentAtIndex:[[self.menuList objectAtIndex:indexPath.row] objectForKey:@"itemid"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[detailViewController popoverDismiss];
	}
		
	
}



-(IBAction) askButtonClicked {
	
	QnAWriteViewController *qnaWriteViewController = [[QnAWriteViewController alloc] initWithNibName:@"QnAWriteViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	qnaWriteViewController.modalPresentationStyle = UIModalPresentationFormSheet;//UIModalPresentationPageSheet;
	[self presentModalViewController:qnaWriteViewController animated:YES];
	qnaWriteViewController.titleNavigationBar.text = @"새글 작성";
	qnaWriteViewController.writeMode = 0;
	
	[qnaWriteViewController release];
	
}

-(void) loadData {
	
	[self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
	self.searchField.text = @"";
	
	//Communication *
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	
	self.currentPage = 1;
	self.searchingMode = NO;
	self.menuList = nil;
	self.morePageFlag = YES;
	
	// make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:@"1" forKey:@"page"];
	[requestDictionary setObject:PCOUNT forKey:@"pcount"];
	[requestDictionary setObject:@"all" forKey:@"stype"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getSOSList];
	
	if (!result) {
		// error occurred
		
	}
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicatorView startAnimating];
	self.tableList.userInteractionEnabled = NO;
	//self.tableList.hidden = YES;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicatorView stopAnimating];
	self.tableList.userInteractionEnabled = YES;
	// get result data from result dictionary
	//NSLog(@"%@", _resultDic);
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	//NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
	if (resultNum == 0 && rslt != nil) {

		NSArray *tmpResult = [NSArray arrayWithArray:(NSArray *)[_resultDic objectForKey:@"soslistinfo"]];
		if (self.menuList == nil) {
			//self.menuList = [NSArray arrayWithArray:(NSArray *)[_resultDic valueForKey:@"soslistinfo"]];
			self.menuList = (NSMutableArray *)tmpResult;
		} else {
			if (tmpResult) {
				//[self.menuList addObjectsFromArray:tmpResult];
				self.menuList = (NSMutableArray *)[self.menuList arrayByAddingObjectsFromArray:tmpResult];
			}
		}
		if ([tmpResult count] < 20) {
			self.morePageFlag = NO;
		}
		self.clipboard = nil;
		[self.tableList reloadData];
		self.tableList.hidden = NO;
/*	} else if (resultNum == 2) {
		[detailViewController popoverDismiss];
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
	// Alert network error message
	[self.indicatorView stopAnimating];
	self.tableList.userInteractionEnabled = YES;
	
	//NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 접속에 실패하였습니다."
												   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
	//return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.pickerList count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.pickerList objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.pickerLabel.text = [self.pickerList objectAtIndex:row];
}

-(IBAction) resignKeyboardnPicker {
	[self.searchField resignFirstResponder];
	[self.pickerBody removeFromSuperview];
	
}

- (void)registerForKeyboardNotifications
{
	/*
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	*/
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.pickerBody removeFromSuperview];
}

-(IBAction) pickerButtonClicked {
	[self.searchField resignFirstResponder];
	
	if (!self.pickerBody.superview) {
		CGRect temp = self.tableList.frame;
		self.pickerBody.frame = temp;
		[self.view addSubview:self.pickerBody];
	}
	self.pickerView.hidden = NO;
	self.pickerToolbar.hidden = NO;
}

-(IBAction) searchButtonClicked {
	if([self.searchField.text length] > 0) {
		//do search
		[self resignKeyboardnPicker];
		self.searchingMode = YES;
		self.currentPage = 1;
		//NSLog(@"검색 서비스 호출");
		//Communication *
		
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
		// make request object
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		//[requestDictionary setObject:@"KT" forKey:@"compcd"];
		[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
		[requestDictionary setObject:PCOUNT forKey:@"pcount"];
		[requestDictionary setObject:self.searchField.text forKey:@"sword"];
		
		if ([self.pickerLabel.text isEqualToString:@"전 체"]) {
			[requestDictionary setObject:@"all" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"제 목"]) {
			[requestDictionary setObject:@"title" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"내 용"]) {
			[requestDictionary setObject:@"content" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"작성자"]) {
			[requestDictionary setObject:@"auth" forKey:@"stype"];
		}

		// call communicate method
		BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getSOSList];
		//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
		
		if (!result) {
			// error occurred
			self.searchingMode = NO;
		}
		
		if (self.searchingMode) {
			// reset current page count
			self.currentPage = 1;
			self.morePageFlag = YES;
			self.menuList = nil;
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오 류" message:@"검색어를 입력해 주세요"
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	
}

-(IBAction) nextCellClicked {
	//NSLog(@"Load Next list!!");
	
	NSString *nextPage = [NSString stringWithFormat:@"%d", ++self.currentPage];
	//NSLog(@"Next page : %@", nextPage);
	
	// get Communication object
	//Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	
	[requestDictionary setObject:nextPage forKey:@"page"];
	[requestDictionary setObject:PCOUNT forKey:@"pcount"];
	
	if (self.searchingMode) {
		[requestDictionary setObject:self.searchField.text forKey:@"sword"];
		if ([self.pickerLabel.text isEqualToString:@"전 체"]) {
			[requestDictionary setObject:@"all" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"제 목"]) {
			[requestDictionary setObject:@"title" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"내 용"]) {
			[requestDictionary setObject:@"content" forKey:@"stype"];
		} else if ([self.pickerLabel.text isEqualToString:@"작성자"]) {
			[requestDictionary setObject:@"auth" forKey:@"stype"];
		}
	} else {
		[requestDictionary setObject:@"all" forKey:@"stype"];
	}
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getSOSList];
	
	if (!result) {
		// error occurred
		
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self searchButtonClicked];
	return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (!self.pickerBody.superview) {
		CGRect temp = self.tableList.frame;
		self.pickerBody.frame = temp;
		//
		[self.view addSubview:self.pickerBody];
	}
	self.pickerView.hidden = YES;
	self.pickerToolbar.hidden = YES;
}

@end

    //
//  FAQListViewController.m
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import "FAQListViewController.h"
#import "FAQDetailViewController.h"
#import "FAQWriteViewController.h"
#import "CustomBadge2.h"
#import "URL_Define.h"


// string constant
#define SEARCH_NAME_KEY @"REGNAME"
#define SEARCH_TITLE_KEY @"BULLTITLE"

@implementation FAQListViewController

@synthesize dataTable;
@synthesize indicator;
@synthesize faqList;
@synthesize boardId;
@synthesize orderBy;
@synthesize sortBy;
@synthesize nextCell;

@synthesize currentPage;
@synthesize clipboard;
@synthesize morePageFlag;
@synthesize detailViewController;
@synthesize nextButton;

@synthesize askButton;

@synthesize pickerList;
@synthesize searchingMode;

@synthesize pickerBody;
@synthesize pickerView;

@synthesize pickerButton;
@synthesize pickerLabel;
@synthesize searchField;
@synthesize searchButton;

@synthesize reloadflag;
@synthesize deleteFlag;

@synthesize pickerToolbar;
@synthesize pickerSelectButton;
@synthesize categoryList;

 
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
	//self.dataTable.editing = YES;
	
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
	
	//self.navigationItem.rightBarButtonItem = askButton;
	self.detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
	self.pickerList = [NSArray arrayWithObjects:@"제 목", @"작성자",  nil];	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.searchField.delegate = self;
	
	self.currentPage = 1;
	self.morePageFlag = YES;
	self.clipboard = nil;
	self.reloadflag = NO;
	
	deleteIndex = -1;
	deleteFlag = NO;
	
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"list_focus.png"] forState:UIControlStateHighlighted];
	
	noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(loadData) name:@"FAQListReload" object:nil];
	[self registerForKeyboardNotifications];
	
    [super viewDidLoad];
	
	[self loadData];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
	//[self.navigationController popToRootViewControllerAnimated:NO];
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];
	
	[self resignKeyboardnPicker];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	//[self resignKeyboardnPicker];
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
	[dataTable release];
	[indicator release];
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
	[faqList release];
	[boardId release];
	[orderBy release];
	[sortBy release];
	
	[detailViewController release];
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
	if ( [self.faqList count] > 0) {
		if (self.morePageFlag) {
			return [self.faqList count]+1;
		} else {
			return [self.faqList count];
		}
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell;
	if (indexPath.row == [self.faqList count]) {
		cell = self.nextCell;
	} else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ListCustomCellFAQ" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		
		NSDictionary *tmpDic = [self.faqList objectAtIndex:indexPath.row];
		
		// Configure the cell...
		UIView *tempBgView = (UIView *)[cell viewWithTag:10];
		if (indexPath.row == 0 || indexPath.row%2 == 0) {
			tempBgView.backgroundColor = [UIColor whiteColor];
		} else {
			tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
		}
		
		UILabel *tempTitleLabel = (UILabel *)[cell viewWithTag:11];
		tempTitleLabel.text = [tmpDic objectForKey:@"bulltitle"];
		
		// set indentation level
		float indentPoint = 20 * [[tmpDic objectForKey:@"depth"] intValue];
		tempTitleLabel.frame = 
		CGRectMake(8.0+indentPoint, tempTitleLabel.frame.origin.y, tempTitleLabel.frame.size.width - indentPoint, tempTitleLabel.frame.size.height);
		
		// set reply image
		if ([[tmpDic objectForKey:@"depth"] intValue] > 0) {
			UIImageView *tempReplyImage = (UIImageView *)[cell viewWithTag:20];
			tempReplyImage.frame = 
			CGRectMake(-17.0+indentPoint, tempReplyImage.frame.origin.y, tempReplyImage.frame.size.width, tempReplyImage.frame.size.height);
			tempReplyImage.hidden = NO;
		
		}
		
		UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:12];
		//if ([[tmpDic objectForKey:@"registrant"] isEqualToString:@""] || [tmpDic objectForKey:@"registrant"] == nil) {
		if ([[tmpDic objectForKey:@"incognitoflag"] isEqualToString:@"N"]) {
			tempNameLabel.text = [tmpDic objectForKey:@"regname"];
		} else {
			tempNameLabel.text = [tmpDic objectForKey:@"registrant"];
		}
		
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];		
		tempDateLabel.text = [tmpDic objectForKey:@"regdate"];
		UILabel *tempYnLabel = (UILabel *)[cell viewWithTag:16];		
		//tempYnLabel.text = [NSString stringWithFormat:@"찬성 : %@ 반대 : %@", [tmpDic objectForKey:@"voteyes"], [tmpDic objectForKey:@"voteno"]];
		tempYnLabel.text = [NSString stringWithFormat:@"조회수 : %@", [tmpDic objectForKey:@"hitno"]];
		
		//cell.indentationLevel = [[tmpDic objectForKey:@"depth"] intValue];
		cell.indentationLevel = indexPath.row;
		//NSLog(@"depth : %@", [tmpDic objectForKey:@"depth"]);
		
		if ([[tmpDic objectForKey:@"commentcnt"] intValue] > 0 ) {
			// add badge view 			
			CustomBadge2 *replyBadge = [CustomBadge2 customBadgeWithString:[tmpDic objectForKey:@"commentcnt"]];
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
	// ...
    // Pass the selected object to the new view controller.
	if (indexPath.row == [self.faqList count]) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
		//[detailViewController loadDetailContentAtIndex:[[self.faqList objectAtIndex:indexPath.row] objectForKey:@"itemid"]];
		detailViewController.boardId = [NSString stringWithString:self.boardId];
		detailViewController.orderBy = [NSString stringWithString:self.orderBy];
		detailViewController.sortBy = [NSString stringWithString:self.sortBy];
		
		detailViewController.listView = self;
		
		[detailViewController loadDetailContentAtIndex:[[self.faqList objectAtIndex:indexPath.row] objectForKey:@"bullid"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[detailViewController popoverDismiss];
	}
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	// swipe 후 삭제버튼 클릭시 호출되는 함수이다 
	// 현재 목록에 삭제플래그 넘어오지 않음. 비실명글은 비밀번호 입력창 팝업
	NSDictionary *tmpDic = [self.faqList objectAtIndex:indexPath.row];
	if ([[tmpDic objectForKey:@"childflag"] isEqualToString:@"1"]) {
		// childflag 값이 1이면 삭제불가라고 함.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"해당 게시물은 하위 게시물이 존재하므로 삭제 불가합니다."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		
	} else {
		UIAlertView *alert = nil;
		
		deleteIndex = indexPath.row;
		
		if ([[tmpDic objectForKey:@"incognitoflag"] isEqualToString:@"Y"]) {
			// 비실명 글이면 비밀번호 입력창 팝업
			alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 게시물을 삭제하시겠습니까?\n" 
											  delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
			alert.tag = 99;
			[alert addTextFieldWithValue:@"" label:@"비밀번호를 입력하십시요."];
			UITextField *temp = [alert textFieldAtIndex:0];
			temp.secureTextEntry = YES;
		} else {
			// 무조건 삭제요청
			alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 게시물을 삭제하시겠습니까?" 
											  delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
			alert.tag = 100;
		}
		[alert show];	
		[alert release];

	}
	
	tmpDic = nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(IBAction) askButtonClicked {
	
	FAQWriteViewController *faqWriteViewController = [[FAQWriteViewController alloc] initWithNibName:@"FAQWriteViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	faqWriteViewController.modalPresentationStyle = UIModalPresentationFormSheet;//UIModalPresentationPageSheet;
	[self presentModalViewController:faqWriteViewController animated:YES];
	faqWriteViewController.titleNavigationBar.text = @"새글 작성";
	faqWriteViewController.writeMode = 0;
	
	faqWriteViewController.boardId = self.boardId;
	faqWriteViewController.sortBy = self.sortBy;
	faqWriteViewController.orderBy = self.orderBy;	
	//faqWriteViewController.categoryData = categoryList;
	faqWriteViewController.categoryLabel.text = [[self.categoryList objectAtIndex:0] objectForKey:@"categoryname"];
	faqWriteViewController.categoryID = [[self.categoryList objectAtIndex:0] objectForKey:@"categoryid"];
	faqWriteViewController.categoryData = [NSArray arrayWithArray:self.categoryList];
	faqWriteViewController.categoryButton.enabled = YES;
	
	[faqWriteViewController release];
	
}

-(void) loadData {
	
	[self.pickerView.delegate pickerView:self.pickerView didSelectRow:0 inComponent:0];
	self.searchField.text = @"";
	
	//Communication *
	self.clipboard = [[Communication alloc] init];
	self.clipboard.delegate = self;
	
	self.currentPage = 1;
	self.searchingMode = NO;
	self.faqList = nil;
	self.morePageFlag = YES;
	
	// make request object
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:@"1" forKey:@"cpage"];
	[requestDictionary setObject:MAXROW forKey:@"maxrow"];
	[requestDictionary setObject:self.boardId forKey:@"boardid"];
	[requestDictionary setObject:self.orderBy forKey:@"orderby"];
	[requestDictionary setObject:self.sortBy forKey:@"sortby"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQBulletinsEx];
	
	if (!result) {
		// error occurred
		
	}
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.dataTable.userInteractionEnabled = NO;
	//self.tableList.hidden = YES;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	self.dataTable.userInteractionEnabled = YES;
	// get result data from result dictionary
	//NSLog(@"%@", _resultDic);
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	//NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
	if (resultNum == 0 && rslt != nil) {
		
		if (deleteFlag == YES) {
			NSArray *tmpResult = [NSArray arrayWithArray:(NSArray *)[_resultDic objectForKey:@"boardlistinfo"]];
			self.faqList = nil;
			self.faqList = (NSMutableArray *)tmpResult;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 게시물에 대한 삭제 처리를 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			
			self.clipboard = nil;
			[self.dataTable reloadData];
			self.dataTable.hidden = NO;
			
			deleteFlag = NO;
			
			// NOTI 날리기
			[detailViewController screenContent];
			
		} else {
			
			// 등록가능시 등록버튼 추가 
			if ([[_resultDic objectForKey:@"regyn"] isEqualToString:@"Y"]) {
				self.navigationItem.rightBarButtonItem = askButton;
			} else {
				self.navigationItem.rightBarButtonItem = nil;
			}
			
			// 카테고리 획득 		
			if ([_resultDic objectForKey:@"categorylist"]) {
				self.categoryList = [_resultDic objectForKey:@"categorylist"];
				//NSLog(@"%@", categoryList);
			}
			
			/*
			 if ([[rslt objectForKey:@"regyn"] isEqualToString:@"Y"]) {
			 self.navigationItem.rightBarButtonItem = askButton;
			 } else {
			 self.navigationItem.rightBarButtonItem = nil;
			 }
			 */
			
			NSArray *tmpResult = [NSArray arrayWithArray:(NSArray *)[_resultDic objectForKey:@"boardlistinfo"]];
			if (self.faqList == nil) {
				//self.faqList = [NSArray arrayWithArray:(NSArray *)[_resultDic valueForKey:@"soslistinfo"]];
				self.faqList = (NSMutableArray *)tmpResult;
			} else {
				if (tmpResult) {
					//[self.faqList addObjectsFromArray:tmpResult];
					self.faqList = (NSMutableArray *)[self.faqList arrayByAddingObjectsFromArray:tmpResult];
				}
			}
			if ([tmpResult count] < 20) {
				self.morePageFlag = NO;
			}
			self.clipboard = nil;
			[self.dataTable reloadData];
			self.dataTable.hidden = NO;
			/*	} else if (resultNum == 2) {
			 [detailViewController popoverDismiss];
			 NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			 [noti postNotificationName:@"SessionFailed" object:self];*/
		}
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
	[self.indicator stopAnimating];
	self.dataTable.userInteractionEnabled = YES;
	
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
		CGRect temp = self.dataTable.frame;
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
		
		[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"cpage"];
		[requestDictionary setObject:MAXROW forKey:@"maxrow"];
		[requestDictionary setObject:self.boardId forKey:@"boardid"];
		[requestDictionary setObject:self.orderBy forKey:@"orderby"];
		[requestDictionary setObject:self.sortBy forKey:@"sortby"];
		
		[requestDictionary setObject:self.searchField.text forKey:@"search_keyword"];
		
		if ([self.pickerLabel.text isEqualToString:@"제 목"]) {
			[requestDictionary setObject:SEARCH_TITLE_KEY forKey:@"searchtype"];
		} else if ([self.pickerLabel.text isEqualToString:@"작성자"]) {
			[requestDictionary setObject:SEARCH_NAME_KEY forKey:@"searchtype"];
		}
		
		// call communicate method
		BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQBulletinsEx];
		//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
		
		if (!result) {
			// error occurred
			self.searchingMode = NO;
		}
		
		if (self.searchingMode) {
			// reset current page count
			self.currentPage = 1;
			self.morePageFlag = YES;
			self.faqList = nil;
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"검색어를 입력해 주세요"
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
	if (clipboard) {
		[clipboard release];
	}
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	
	[requestDictionary setObject:nextPage forKey:@"cpage"];
	[requestDictionary setObject:MAXROW forKey:@"maxrow"];
	[requestDictionary setObject:self.boardId forKey:@"boardid"];
	[requestDictionary setObject:self.orderBy forKey:@"orderby"];
	[requestDictionary setObject:self.sortBy forKey:@"sortby"];
	
	if (self.searchingMode) {
		[requestDictionary setObject:self.searchField.text forKey:@"search_keyword"];
		if ([self.pickerLabel.text isEqualToString:@"제 목"]) {
			[requestDictionary setObject:SEARCH_TITLE_KEY forKey:@"searchtype"];
		} else if ([self.pickerLabel.text isEqualToString:@"작성자"]) {
			[requestDictionary setObject:SEARCH_NAME_KEY forKey:@"searchtype"];
		}
	} else {
		//[requestDictionary setObject:@"all" forKey:@"stype"];
	}
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQBulletinsEx];
	
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
		CGRect temp = self.dataTable.frame;
		self.pickerBody.frame = temp;
		//
		[self.view addSubview:self.pickerBody];
	}
	self.pickerView.hidden = YES;
	self.pickerToolbar.hidden = YES;
}

#pragma mark -
#pragma mark AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if(alertView.tag == 99) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			
			if ([[[alertView textFieldAtIndex:0] text] length] <= 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비밀번호를 입력하십시요" 
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 6661;
				[alert show];	
				[alert release];
				
			} else {
				
				clipboard = [[Communication alloc] init];
				clipboard.delegate = self;
				
				// make request dictionary
				NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
				[requestDictionary setObject:[[self.faqList objectAtIndex:deleteIndex] objectForKey:@"boardid"] forKey:@"boardid"];
				[requestDictionary setObject:[[self.faqList objectAtIndex:deleteIndex] objectForKey:@"bullid"] forKey:@"bullid"];
				[requestDictionary setObject:self.sortBy forKey:@"sortby"];
				[requestDictionary setObject:self.orderBy forKey:@"orderby"];
				[requestDictionary setObject:[[alertView textFieldAtIndex:0] text] forKey:@"password"];
				
				[requestDictionary setObject:@"1" forKey:@"cpage"];
				[requestDictionary setObject:@"20" forKey:@"maxrow"];
				
				// call communicate method
				BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBull];
				
				if (!result) {
					// error occurred
					
				}
				//self.faqList = nil;
				deleteFlag = YES;
			}
		} else {
			deleteIndex = -1;
		}
		
	} else if(alertView.tag == 100) {
		if(buttonIndex != [alertView cancelButtonIndex]) {
			
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:[[self.faqList objectAtIndex:deleteIndex] objectForKey:@"boardid"] forKey:@"boardid"];
			[requestDictionary setObject:[[self.faqList objectAtIndex:deleteIndex] objectForKey:@"bullid"] forKey:@"bullid"];
			[requestDictionary setObject:self.sortBy forKey:@"sortby"];
			[requestDictionary setObject:self.orderBy forKey:@"orderby"];
			
			[requestDictionary setObject:@"1" forKey:@"cpage"];
			[requestDictionary setObject:@"20" forKey:@"maxrow"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBull];
			
			if (!result) {
				// error occurred
				
			}
			
			//self.faqList = nil;
			deleteFlag = YES;
		} else {
			deleteIndex = -1;
		}
	} else if(alertView.tag == 6661) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 게시물을 삭제하시겠습니까?\n" 
										  delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
		alert.tag = 99;
		[alert addTextFieldWithValue:@"" label:@"비밀번호를 입력하십시요."];
		UITextField *temp = [alert textFieldAtIndex:0];
		temp.secureTextEntry = YES;
		[alert show];	
		[alert release];
	}

}

@end

//
//  PaymentListController.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentListController.h"
#import "PaymentController.h"


@implementation PaymentListController
@synthesize confirmController, userDefault, selectedCategory, num_pageNum, arr_docListInfo, currentTableView;
@synthesize result_totalCount, result_totalPage, mode_nextCell;

#pragma mark -
#pragma mark communication delegate



-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
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
	
	//NSLog(@"PaymentListController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
		
		self.result_totalPage = [[resultDic objectForKey:@"totalpage"] intValue];
		self.result_totalCount = [[resultDic objectForKey:@"totalcount"] intValue];
		
		[self.arr_docListInfo addObjectsFromArray:[_resultDic objectForKey:@"doclistinfo"]];
		
		[self.currentTableView reloadData];
		
		self.currentTableView.hidden = NO;
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
}

-(void)action_nextCell:(id)sender {
	self.num_pageNum++;
	[self listComm];
}

#pragma mark -
#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if((self.num_pageNum < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.arr_docListInfo count])) {
		//--- nextCell의 빈공간을 누르면 아무 처리도 하지 않는다.
	}
	else {
		//--- selected 된 row 를 dic에 저장해 둔다. (readed or not 표시를 위해)
		[dic_flag_readded setObject:[NSString stringWithFormat:@"%d", indexPath.row] 
							 forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
		
		// confirm 객체에 선택된 object를 넘긴다.
		
		self.confirmController.dic_selectedItem = (NSMutableDictionary *)[[self.arr_docListInfo objectAtIndex:indexPath.row] copy];
		self.confirmController.selectedCategory = self.selectedCategory;
		
//		[self.view deselectRowAtIndexPath:indexPath animated:YES];
		[self.confirmController reloadUnderbar];
		[self.confirmController loadPaymentDetailData];
		[self.confirmController popoverDismiss];

		
	}
}

#pragma mark -
#pragma mark tableview datasource
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//--- 현재 페이지가 토탈 페이지 보다 작으면 nextCell 보여줌
	if(self.num_pageNum < self.result_totalPage) {
		self.mode_nextCell = YES;
		return [self.arr_docListInfo count] + 1;
	}
	else {
		return [self.arr_docListInfo count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
		//--- nextCell 모드이고, 현재 페이지가 토탈 페이지보다 작고, 마지막 라인이면 nextCell
	if((self.num_pageNum < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.arr_docListInfo count])) {
		cell = nextCell;
	}
	else {
		if (cell == nil) {
				//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"PaymentListCustomCell" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		
			// Configure the cell.
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		NSDictionary *dic_current = [self.arr_docListInfo objectAtIndex:indexPath.row];
		
		UIView *tempBgView = (UIView *)[cell viewWithTag:10];
		if (indexPath.row == 0 || indexPath.row%2 == 0) {
			tempBgView.backgroundColor = [UIColor whiteColor];
		} 
		else {
			tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
		}
		UILabel *tempTitleLabel = (UILabel *)[cell viewWithTag:11];
		tempTitleLabel.text = [dic_current objectForKey:@"title"];
		
			//--- receiptdate check for italic font (수신문서일때)
		if([self.selectedCategory isEqualToString:@"9"]) {
			NSString *str_tmpReceiveData = [dic_current objectForKey:@"receiptdate"];
			
			NSString *tmpReadedFlag = [dic_flag_readded objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
			//receiptdata 이 없거나 tmpReadedFlag 가 없어야 not readed 로 보고 이탤릭체로 표시한다.
			if(str_tmpReceiveData == nil || [str_tmpReceiveData length] <= 0) {
				tempTitleLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:14];
			}
			
			if(tmpReadedFlag != nil || [tmpReadedFlag length] > 0) {
				tempTitleLabel.font = [UIFont fontWithName:@"Verdana" size:14];
			}
			//			if(tmpReadedFlag == nil || [tmpReadedFlag length] <= 0) {
			//				tempTitleLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:14];
			//			}
		}
		
		UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:12];
		tempNameLabel.text = [dic_current objectForKey:@"writername"];
		
			// -- set date -- //
		//		NSDateFormatter *dateFormatter = ㅎ[[[NSDateFormatter alloc] init] autorelease];
		//		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		//		NSString *dateString = [dic_current objectForKey:@"listdate"];
		//		NSDate *myDate = [dateFormatter dateFromString:dateString];
		//		[dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
		//		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];
		//		tempDateLabel.text = [dateFormatter stringFromDate:myDate];
		NSString *dateString = [dic_current objectForKey:@"listdate"];
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];
		tempDateLabel.text = dateString;
		
	}
	
	
	
    return cell;
}

#pragma mark -
#pragma mark system method

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


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(void)returnToPayment {
	[self.navigationController popViewControllerAnimated:YES];
//	NSArray *arr_controllers = [self.navigationController viewControllers];
//	PaymentController *tmp_controller = [arr_controllers objectAtIndex:1];
//	tmp_controller.flag_reload = YES;
//	
//	[self.navigationController popToViewController:tmp_controller animated:YES];
	
}

-(void)resetList {
	self.num_pageNum = 1;	//최초 페이지 1
	[self.arr_docListInfo removeAllObjects];
	[self listComm];
}

-(void)viewDidLoad {
	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(returnToPayment) name:@"returnToPayment" object:nil];
	[noti addObserver:self selector:@selector(resetList) name:@"PaymentResetList" object:nil];
	
	dic_flag_readded = [[NSMutableDictionary alloc] init];
	
	self.currentTableView.hidden = YES;
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 660);
	
	//--- get detail view
	self.confirmController = [self.splitViewController.viewControllers objectAtIndex:1];
	
	//--- back bar button setting
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	self.arr_docListInfo = [[NSMutableArray alloc] init];
	
	switch ([self.selectedCategory intValue]) {
		case 1: //category 1 결재할 문서
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
	
	self.userDefault = [NSUserDefaults standardUserDefaults];
	self.num_pageNum = 1;	//최초 페이지 1
	
	[self listComm];
}

-(void)listComm {
	
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	
	[loginRequest setObject:self.selectedCategory forKey:@"listtype"];    //category
	[loginRequest setObject:[NSString stringWithFormat:@"%d", self.num_pageNum] forKey:@"pagenum"];    
	[loginRequest setObject:[NSString stringWithFormat:@"%d", num_pageSize] forKey:@"pagesize"];    
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalListInfo];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];
		[alert release];
	}
}
-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
}
-(void)viewWillAppear:(BOOL)animated {
	[self.currentTableView reloadData];
	
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
	[self.confirmController release];
    [super dealloc];
}


@end

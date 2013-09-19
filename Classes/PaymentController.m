
//
//  PaymentController.m
//  MobileKate2.0_iPad
//
//  Created by 김일호 on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentController.h"

@implementation PaymentController
@synthesize userDefault, listCountDic, currentTableView, listUnreadCountDic, payList, flag_reload;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
#pragma mark tableView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	if(alertView.tag == 9876) {
//		[self.navigationController popViewControllerAnimated:YES];
//	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//	PaymentController *paymentXib = [[PaymentController alloc]initWithNibName:@"PaymentController" bundle:nil];
	
	//--- setting for each menu ---//
	
	self.payList = [[PaymentListController alloc] initWithNibName:@"PaymentListController" bundle:nil];
	
	switch ([indexPath row]) {
		case 0:
			self.payList.selectedCategory = @"1";
			break;
		case 1:
			self.payList.selectedCategory = @"2";
			break;
		case 2:
			self.payList.selectedCategory = @"9";
			break;
		case 3:
			self.payList.selectedCategory = @"10";
			break;
		case 4:
			self.payList.selectedCategory = @"5";
			break;
		default:
			break;
	}
	
	[self.currentTableView deselectRowAtIndexPath:indexPath animated:YES];

	
	[self.navigationController pushViewController:self.payList animated:YES];
	[self.payList release];
	
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSMutableString *str_cell = [[NSMutableString alloc] init];
	
	switch ([indexPath row]) {
		case 0: //category 1 [count] <there's count display in category 1 & 9 only>
			[str_cell appendString:@"결재할 문서"];	
			[str_cell appendFormat:@" [%@]", [self.listCountDic objectForKey:@"1"]];
			break;
		case 1:	//category 2
			[str_cell appendString:@"결재한 문서"];
			break;
		case 2:	//category 9 [unread/count]
			[str_cell appendString:@"수신문서"];
			[str_cell appendFormat:@" [%@/%@]", [self.listUnreadCountDic objectForKey:@"9"], [self.listCountDic objectForKey:@"9"]];
			break;
		case 3:	//category 10
			[str_cell appendString:@"부서수신문서"];
			break;
		case 4:	//category 5
			[str_cell appendString:@"기안한 문서"];
			break;			
		default:
			break;
	}
	cell.textLabel.text = str_cell;
	cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
	
    return cell;
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//

	indicator.frame = CGRectMake(0, 0, 30, 30);
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
	
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
	
	NSArray *arrResult = (NSArray *)[_resultDic objectForKey:@"approvalcountinlistinfo"];
	
	//--- array 없으면 통신 실패 간주
	if(arrResult == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[[_resultDic objectForKey:@"result"] objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];
		[alert release];
		return;		
	}
	else {
		//--- receive success
		NSDictionary *dic_each;
		NSDictionary *dic_eachResult;
		NSDictionary *dic_eachApprovalListCountInfo;
		
		for(int i = 0; i < [arrResult count]; i++) {
			dic_each = [arrResult objectAtIndex:i];
			dic_eachResult = [dic_each objectForKey:@"result"];
			
			if([[dic_eachResult objectForKey:@"code"] isEqualToString:@"0"]) {	//save only success category
				dic_eachApprovalListCountInfo = [dic_each objectForKey:@"approvallistcountinfo"];
				
				// category : key / count : value
				[listCountDic setObject:[dic_eachApprovalListCountInfo objectForKey:@"count"] 
								 forKey:[dic_eachApprovalListCountInfo objectForKey:@"category"]];
				
				[listUnreadCountDic setObject:[dic_eachApprovalListCountInfo objectForKey:@"unreadcount"] 
									   forKey:[dic_eachApprovalListCountInfo objectForKey:@"category"]];
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[dic_eachResult objectForKey:@"errdesc"]
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 9876;
				[alert show];
				[alert release];
				return;		
			}
			
		}
		[self.currentTableView reloadData];
		self.currentTableView.hidden = NO;
	}
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
}

-(void)viewDidLoad {
	self.title = @"결재";
	
	self.currentTableView.hidden = YES;
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 660);
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	self.userDefault = [NSUserDefaults standardUserDefaults];
	self.listCountDic = [[NSMutableDictionary alloc] init];
	self.listUnreadCountDic = [[NSMutableDictionary alloc] init];
	
	
	
//	flag_reload = YES; // 최초 통신은 허용
//	[self tr_data];
}

-(void)tr_data {
	//--- view 생성 될 때 통신 
	//--- 결재 리스트는 항상 리로드 하도록 다시 수정 -_- 제길 
//	if(flag_reload == YES) {
		cm = [[Communication alloc] init];
		[cm setDelegate:self];
		
		NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
		
		//	[loginRequest setObject:[self.userDefault stringForKey:@"login_id"] forKey:@"userid"];   
		int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalInfo];
		if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
														   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
			[alert show];	
			[alert release];
		}		
		
		flag_reload = NO;
//	}
	
	//--- 통신 한 후에는 
}

-(void)viewWillAppear:(BOOL)animated {
	
//	[self.currentTableView reloadData];	

	
	[self tr_data]; //이후 통신은 flag yes일때만 허용
	
	
}

-(void)viewWillDisappear:(BOOL)animated {
	//	[self.view removeFromSuperview];
	
	[indicator stopAnimating];
	
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
}


/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	[payList release];
    [super dealloc];
}


@end

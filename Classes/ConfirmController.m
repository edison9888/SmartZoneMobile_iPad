//
//  ConfirmController.m
//  MobileKate2.0_iPad
//
//  Created by kakadais on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmController.h"
#import "PaymentController.h"

#import "MobileKate2_0_iPadAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomSubTabViewController.h"

@interface ConfirmController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@implementation ConfirmController

@synthesize toolbar, popoverController;
@synthesize mainButton;
@synthesize titleLabel;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize contentWebView;
@synthesize imageView;
@synthesize dic_docattachlistinfo, approvaldocinfo, dic_selectedItem, arr_docLinkListInfo, arr_docattachlistinfo, selectedCategory;
@synthesize currentTableView, paymentOriginalPdfCell, paymentAttachFileCell, miniMenu;
@synthesize miniMenuController;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case 111:	//결재 승인
			if(buttonIndex == 1) { 
				//승인
				//--- 승인 통신 모드
				approve_mode = YES;
				
				cm = [[Communication alloc] init];
				//NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
				[cm setDelegate:self];
				
				NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
				[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
				[loginRequest  setObject:@"1" forKey:@"type"]; 
				/*
				 2011.6.7 대리결재 오류에 대한 수정 (올레개발팀 박인상)
				//				[loginRequest  setObject:@"" forKey:@"opinion"]; //--- there's no opinion
				NSString *encryptString = [userDefault objectForKey:@"login_id"];
				NSData *tmpID = [Base64 decode:encryptString];
				NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
				
				[loginRequest  setObject:str_ID forKey:@"aprmemberid"];
				*/
				[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"aprmemberid"] forKey:@"aprmemberid"]; 
				
				int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalDecisionInfo];
				if(rslt != YES) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
																   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
					
					[alert show];
					[alert release];
					return;		
					
				}				
			}
			else {
				//취소
			}
			
			break;
		case 666:
//			[self.navigationController popViewControllerAnimated:YES];
			break;
			
		default:
			break;
	}
}


#pragma mark -
#pragma mark perform action
-(IBAction)action_approve {
	if([self.selectedCategory isEqualToString:@"1"]) {
		//--- 결재
		RejectController *rejectController = [[RejectController alloc] initWithNibName:nil bundle:nil];
		rejectController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		rejectController.modalPresentationStyle = UIModalPresentationFormSheet;
		rejectController.flag_approval = YES;
		
		// data set
		rejectController.dic_selectedItem = self.dic_selectedItem;
		rejectController.selectedCategory = self.selectedCategory;
		
		[self presentModalViewController:rejectController animated:YES];
		[rejectController release];
		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"승인 하시겠습니까?"
//													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//		alert.tag = 111;
//		[alert show];
//		[alert release];
	}
	else {
		
		PaymentStateController *stateController = [[PaymentStateController alloc] initWithNibName:@"PaymentStateController" bundle:nil];
		stateController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		stateController.modalPresentationStyle = UIModalPresentationFormSheet;

		stateController.dic_selectedItem = self.dic_selectedItem;
		stateController.selectedCategory = self.selectedCategory;
		[self presentModalViewController:stateController animated:YES];
		//		[self.navigationController pushViewController:stateController animated:YES];
		
	}
	
}



-(IBAction)action_reject {
	
	RejectController *rejectController = [[RejectController alloc] initWithNibName:nil bundle:nil];
	rejectController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	rejectController.modalPresentationStyle = UIModalPresentationFormSheet;

	// data set
	rejectController.dic_selectedItem = self.dic_selectedItem;
	rejectController.selectedCategory = self.selectedCategory;

	[self presentModalViewController:rejectController animated:YES];
	[rejectController release];
	
}

-(IBAction)action_comment {
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	OpinionViewController *opViewController = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController" bundle:nil];
	opViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	opViewController.modalPresentationStyle = UIModalPresentationFormSheet;

	opViewController.dic_selectedItem = self.dic_selectedItem;
	opViewController.selectedCategory = self.selectedCategory;
	
	[self presentModalViewController:opViewController animated:YES];
	//	[self.navigationController pushViewController:opViewController animated:YES];
	[opViewController release];
	
}

-(void)reloadUnderbar {

	
	if ([self.selectedCategory isEqualToString:@"1"]) {
		confirmImgView.image = [UIImage imageNamed:@"payment_confirm.png"];
		btn_1.enabled = YES;
		btn_2.enabled = YES;
		btn_3.enabled = YES;
	}
	else {
		confirmImgView.image = [UIImage imageNamed:@"Payment_specific_bar.png"];
		btn_1.enabled = YES;
		btn_2.enabled = NO;
		btn_3.enabled = YES;
	}
}


-(IBAction)action_paymentOriginalPdfCell {
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];

    ConfirmFileViewController *fileViewController = [[ConfirmFileViewController alloc] initWithNibName:@"ConfirmFileViewController" bundle:nil];
    fileViewController.selectedCategory = self.selectedCategory;
    fileViewController.dic_selectedItem = self.dic_selectedItem;
    fileViewController.dic_approvaldocinfo = self.approvaldocinfo;
    fileViewController.dic_docattachlistinfo = self.dic_docattachlistinfo;
    
    [self presentModalViewController:fileViewController animated:YES];
    
    //	[self.navigationController pushViewController:fileViewController animated:YES];
    [fileViewController release];

}

-(void)action_paymentAttachFile:(id)sender {
	UIButton *btn_tmp = (UIButton *)sender;
	int index = btn_tmp.tag;
	if ([[[arr_docattachlistinfo objectAtIndex:index] objectForKey:@"filesize"]intValue] > 3145728) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"3MB 이상의 첨부 파일은 지원하지 않습니다. PC에서 이용해 주십시오."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];
		[alert release];
    }else{
        self.dic_docattachlistinfo = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dic_tmp = [arr_docattachlistinfo objectAtIndex:index];
        [self.dic_docattachlistinfo setDictionary:dic_tmp];
        
        //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"docid"] forKey:@"docid"];
        //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"attachdocurl"] forKey:@"href"];
        
        [self action_paymentOriginalPdfCell];

    }
}


#pragma mark -
#pragma mark tableview delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//default 2 + 결재문서 1 + 첨부파일 갯수
	int lineCount = 3;
	
	lineCount += [self.arr_docattachlistinfo count];	//첨부파일 갯수
	
	return lineCount;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = nil;
	
	if(indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.contentView.backgroundColor = [UIColor grayColor];
		cell.textLabel.backgroundColor = [UIColor grayColor];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.backgroundColor = [UIColor grayColor];
		cell.detailTextLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = [self.dic_selectedItem objectForKey:@"title"];
	}
	else if(indexPath.row == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}		
		
		cell.contentView.backgroundColor = [UIColor grayColor];
		cell.textLabel.backgroundColor = [UIColor grayColor];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.backgroundColor = [UIColor grayColor];
		cell.detailTextLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = [self.dic_selectedItem objectForKey:@"writername"];
		
		// -- set date -- //
		NSString *dateString = [self.approvaldocinfo objectForKey:@"startdate"];
		dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
		
		cell.detailTextLabel.text = dateString;

		
	}
	else if(indexPath.row == 2) {
		cell = self.paymentOriginalPdfCell;
		
	}
	else {
		NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"PaymentAttachFileCell" owner:self options:nil];
		cell = [topObject objectAtIndex:0];
		
		UIButton *btn_tmp = (UIButton *)[cell viewWithTag:111];


		btn_tmp.tag = indexPath.row	- 3;
		[btn_tmp addTarget:self action:@selector(action_paymentAttachFile:) forControlEvents:UIControlEventTouchUpInside];
		
		NSDictionary *dic_tmp = [self.arr_docattachlistinfo objectAtIndex:(indexPath.row - 3)];
		NSString *str_title = [dic_tmp objectForKey:@"attachdocname"];
		[btn_tmp setTitle:str_title forState:UIControlStateNormal];
	}

    return cell;
}

#pragma mark -
#pragma mark Communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
//	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [self.view addSubview:indicator];
//	indicator.center = self.view.center;
	
	[indicator startAnimating];
	
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	//NSLog(@"ConfirmController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 666;
		[alert show];
		[alert release];
		approve_mode = NO;
		return;
	}	
	
	if([rsltCode intValue] == 0){
		
		if(approve_mode == NO) {
			//--- Confirm 화면결과
			self.approvaldocinfo = [_resultDic objectForKey:@"approvaldocinfo"];
			if(self.approvaldocinfo == nil || [self.approvaldocinfo count] <= 0) {
				//--- 문서가 없다면 에러
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"결재 문서 정보가 없습니다.\n 관리자에게 확인해주세요."
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				alert.tag = 666;
				[alert show];	
				[alert release];
				approve_mode = NO;
				return;		
				
				
			}
			self.arr_docattachlistinfo = [_resultDic objectForKey:@"docattachlistinfo"];
			
			[self.currentTableView reloadData];				
			self.currentTableView.allowsSelection = NO;
			self.currentTableView.hidden = NO;
			self.imageView.hidden = YES;	//hidden when the comm is success

			
		}
		else {
			//--- Approve 결과
			noti = [NSNotificationCenter defaultCenter];
			[noti postNotificationName:@"returnToPayment" object:nil];
			
			if(self.currentTableView != nil) {
				[self.currentTableView release];
				[self.currentTableView removeFromSuperview];	

			}
			self.imageView.hidden = NO;

//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@""]
//														   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//			alert.tag = 666;
//			[alert show];	
//			[alert release];
		}
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 666;
		[alert show];	
		[alert release];
		approve_mode = NO;
		return;		
	}
	approve_mode = NO;
}


-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
}



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

- (void)viewWillDisappear:(BOOL)animated {
    if (cm != nil) {
		[cm cancelCommunication];
	}
}

-(void)viewWillAppear:(BOOL)animated {
	[self.dic_docattachlistinfo removeAllObjects];
}

-(void)resetPage {
	imageView.hidden = NO;
    [self.view bringSubviewToFront:self.imageView];
    btn_1.enabled = NO;
    btn_2.enabled = NO;
    btn_3.enabled = NO;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
	 indicator.hidden = YES;
	 
	 noti = [NSNotificationCenter defaultCenter];
	 [noti addObserver:self selector:@selector(resetPage) name:@"resetPage" object:nil];
	 
	 self.dic_selectedItem = [[NSMutableDictionary alloc] init];

	 btn_1.enabled = NO;
	 btn_2.enabled = NO;
	 btn_3.enabled = NO;
	 
	 self.currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	 self.currentTableView.hidden = YES;
	 self.imageView.hidden = NO;
	 confirmImgView.image = [UIImage imageNamed:@"payment_confirm.png"];
	 
	 self.miniMenuController = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
//	 [self.miniMenuController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
	 CGRect miniRect = miniMenuController.view.frame;
	 miniRect.origin.y += 43;
	 miniMenuController.view.frame = miniRect;
	 
	 [self.miniMenu addSubview:self.miniMenuController.view];
}
 
 - (void)configureView {
 // Update the user interface for the detail item.
 // detailDescriptionLabel.text = [detailItem description];   
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"결재";
    NSMutableArray *items = [[toolbar items] mutableCopy];
	if([items objectAtIndex:0] == barButtonItem){
		// do nothing
		//NSLog(@"%@, %@", [items objectAtIndex:0], barButtonItem);
	} else {		
		[items insertObject:barButtonItem atIndex:0];
		[toolbar setItems:items animated:YES];
	}
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	indicator.center = self.view.center;

	switch (fromInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			break;
		case UIInterfaceOrientationLandscapeLeft:
			break;
		case UIInterfaceOrientationLandscapeRight:
			break;
		default:
			break;
	}
//	CGRect tableRect = [[UIScreen mainScreen] bounds];
//	tableRect.size.height = 800;
//	tableRect.size.height = 400;
//	self.currentTableView.frame = tableRect;
//	self.currentTableView reload]
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
	self.popoverController = nil;
}


- (void)dealloc {
	[popoverController release];
	[toolbar release];
	[mainButton release];
	[titleLabel release];
	[nameLabel release];
	[timeLabel release];
	[contentWebView release];
	[imageView release];
    [super dealloc];
}

-(IBAction) mainButtonClicked {
	
	[[self.splitViewController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
	
	if (self.popoverController != nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
	
	[noti postNotificationName:@"returnHomeView" object:self];

	
}

-(void)loadPaymentDetailData {
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	
	
	[loginRequest setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"];    //category
	[loginRequest setObject:self.selectedCategory forKey:@"listtype"];    
	[loginRequest setObject:@"true" forKey:@"convertpdf"];  //--- 항상 true Mr.park
	[loginRequest setObject:@"002" forKey:@"receipttype"];    // what is this?
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalDocInfo];
	if (rslt != YES) {
		//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}
	
	
}

-(void) popForFirstAppear {
	
	self.imageView.hidden = NO;
	
	if(self.popoverController != nil){
		if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
			|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			[self.popoverController	 presentPopoverFromBarButtonItem:[[toolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}
	
}

-(void) popoverDismiss {
	if(self.popoverController != nil && [self.popoverController isPopoverVisible]){
		[self.popoverController dismissPopoverAnimated:YES];
	}
}

@end

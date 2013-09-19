    //
//  RejectController.m
//  MobileKate2.0_iPad
//
//  Created by nicejin on 11. 3. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RejectController.h"
#import "PaymentController.h"


@implementation RejectController

@synthesize cancelButton;
@synthesize rejectButton;
@synthesize dic_selectedItem;
@synthesize selectedCategory;
@synthesize flag_approval;


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	CGRect frame;
//	UIInterfaceOrientation orientation = [self interfaceOrientation];
	if(fromInterfaceOrientation == UIDeviceOrientationPortrait || fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		frame = tf_rejectComment.frame;
		frame.size.height = 200;

	}
	else {
		frame = tf_rejectComment.frame;
		frame.size.height = 330;

	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	
	tf_rejectComment.frame = frame;
	
	[UIView commitAnimations];
	
	
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	/*
	 typedef enum {
	 UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
	 UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
	 UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
	 UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
	 } UIInterfaceOrientation;
	 */	 
	
	CGRect frame;
	UIInterfaceOrientation orientation = [self interfaceOrientation];
	if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
		frame = tf_rejectComment.frame;
		frame.size.height = 330;
	}
	else {
		frame = textView.frame;
		frame.size.height = 200;
	}

	
//	CGRect frame = textView.frame;
//	frame.size.height = 300;
	
	
//	CGRect frame = CGRectMake(15, 147, 295, 105);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	
	tf_rejectComment.frame = frame;
	
	[UIView commitAnimations];
	
	return YES;
}

#pragma mark -
#pragma mark Communication delegate
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
	
	//NSLog(@"RejectController result : %@", resultDic);
	
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
		NSString *str_tmp_message;
		if(flag_approval == YES) {
			str_tmp_message = @"결재를 승인하였습니다.";
		}
		else {
			str_tmp_message = @"결재를 반려하였습니다.";
		}
		
		//-- 승인 반려 후 리스트 reset&reload
		NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
		[noti postNotificationName:@"PaymentResetList" object:nil];
		[noti postNotificationName:@"resetPage" object:nil];
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:str_tmp_message
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 123;
		[alert show];	
		[alert release];
		
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
	
	tf_rejectComment.delegate = self;
	
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
	
	if(flag_approval == YES) {
		rightBarButton.title = @"승인";
		textLabel1.text = @"승인";
		textLabel2.text = @"승인";
	}
		
	else {
		rightBarButton.title = @"반려";
		textLabel1.text = @"반려";
		textLabel2.text = @"반려";
		
	}		
	
//	UIBarButtonItem *temporaryBarButtonItem;
//	if(flag_approval == YES)
//		temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"승인" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_reject)];
//	else
//		temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"반려" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_reject)];
//	self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];
}
-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 123) {
		[self dismissModalViewControllerAnimated:YES];
		
		
		
//		NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
//		[noti postNotificationName:@"returnToPayment" object:nil];
		
	}
	else if(buttonIndex == 1 && alertView.tag == 111) {
		[self go_reject];
	}
}

- (IBAction)btn_reject {
	
	if([tf_rejectComment.text length] <= 0 && flag_approval == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"메모를 입력해 주세요."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];
		[alert release];
	}
	else {
		NSString *str_tmp_message;
		if(flag_approval == YES)
			str_tmp_message = @"승인 하시겠습니까?";
		else
			str_tmp_message = @"반려 하시겠습니까?";
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:str_tmp_message
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
		alert.tag = 111;
		[alert show];
		[alert release];
		
	}
}

- (void)go_reject {
	NSString *str_rejectComment = tf_rejectComment.text;
	//NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	
	[loginRequest setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"];
	if(flag_approval == YES)
		[loginRequest setObject:@"1" forKey:@"type"];    //결재 type : 1승인 2반려 3후결
	else
	    [loginRequest setObject:@"2" forKey:@"type"];    //결재 type : 1승인 2반려 3후결
	[loginRequest setObject:str_rejectComment forKey:@"opinion"]; 

	/*action_approve
	 2011.6.7 대리결재 오류에 대한 수정 (올레개발팀 박인상)
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	[loginRequest setObject:str_ID forKey:@"aprmemberid"]; 
	*/
	[loginRequest setObject:[self.dic_selectedItem objectForKey:@"aprmemberid"] forKey:@"aprmemberid"];
//    [loginRequest setObject:@"b11111111" forKey:@"aprmemberid"];

	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getApprovalDecisionInfo];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
}


// Override to allow orientations other than the default portrait orientation.
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
    [super dealloc];
}


-(IBAction) cancelButtonClicked {
	[self dismissModalViewControllerAnimated:YES];
}

//-(IBAction) rejectButtonClicked {
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"질문 삭제" message:@"질문을 삭제하시겠습니까?" 
//												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
//	alert.tag = 999;
//	[alert show];	
//	[alert release];
//}

@end

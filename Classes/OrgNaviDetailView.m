//
//  OrgNaviDetailView.m
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import "OrgNaviDetailView.h"

#import "SearchEmployeeRoot.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchEmployeeDetail.h"
#import "MobileKate2_0_iPadAppDelegate.h"
#import "Base64.h"
#import "Clipboard.h"
#import <AddressBook/AddressBook.h>
#import "MailWriteController.h"
@interface OrgNaviDetailView ()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end


@implementation OrgNaviDetailView
@synthesize corp;
@synthesize email;
@synthesize mobile;
@synthesize name;
@synthesize phone1;
@synthesize pos;
@synthesize reserv1;
@synthesize reserv2;	
@synthesize webmail;
@synthesize base64image;
@synthesize streams;
@synthesize saveButton;
@synthesize indicator;
@synthesize indicatorModalView;
@synthesize roll;

@synthesize mainToolbar, popoverController;
@synthesize mainButton;
@synthesize EmployeeDetailView;
@synthesize tabBarViewController;
@synthesize menuTabbarView;
@synthesize EmployeeDetailImage;
@synthesize dept;
@synthesize cm;
@synthesize detailData;

#pragma mark -
#pragma mark Split view support
-(void)createViewControllers {
	
	self.tabBarViewController = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
	
    //CGRect tabbarRect = tabBarViewController.view.frame;
    //tabbarRect.origin.y = 900.0;
    //self.tabBarViewController.view.frame = tabbarRect;
	
    //[self.view addSubview:self.tabBarViewController.view];
	[self.tabBarViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    //self.subMenu.view.contentMode = UIViewContentModeBottom|UIViewContentModeLeft|UIViewContentModeRight;
	[self.menuTabbarView addSubview:self.tabBarViewController.view];
	
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    self.mainToolbar = (UIToolbar *)[self.view viewWithTag:767];//detail navi 에서는 toolbar를 못찾음 그래서 직접 태그로 지정

    barButtonItem.title = @"조직도";
    NSMutableArray *items = [[mainToolbar items] mutableCopy];
	if([items objectAtIndex:0] == barButtonItem){
        // do nothing
        ////NSLog(@"%@, %@", [items objectAtIndex:0], barButtonItem);
	} else {
		[items insertObject:barButtonItem atIndex:0];
		[mainToolbar setItems:items animated:YES];
	}
    //[items insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:items animated:YES];
    [items release];
	
    self.popoverController = pc;
	
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSMutableArray *items = [[mainToolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [mainToolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

-(IBAction) mainButtonClicked {
	[[self.splitViewController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
    
	if (self.popoverController != nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
	
	
	
	noti = [NSNotificationCenter defaultCenter];
	
	[noti postNotificationName:@"returnHomeView" object:self];
	
	
}

-(void) loadDetailContentAtIndex:(NSString *)userid {
	cm = [[Communication alloc] init];
	self.cm.delegate= self;
    //NSLog(@"pushed index : %@", userid);
	
	NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
	
	[tmpDic setValue:@"loginid" forKey:@"stype"];
	[tmpDic setValue:userid forKey:@"sword"];
	
	
	
	BOOL rslt = [self.cm callWithArray:tmpDic serviceUrl:URL_getAddressDetail];
	
	if (rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 오류 발생"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		
	}
	
}

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	if (!self.indicatorModalView.superview) {
		CGRect cg = 		self.EmployeeDetailView.bounds;
		cg.origin.y+=43;
		self.indicatorModalView.frame = cg;
		[self.view addSubview:self.indicatorModalView];
		[self.indicator startAnimating];
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	
	
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator stopAnimating];
	
	NSDictionary *singles = (NSDictionary *)[_resultDic valueForKey:@"result"];
    //NSLog(@"detail total count: %@", [singles valueForKey:@"totalcount"]);
	
	NSNumber *rsltCode = [singles objectForKey:@"code"];
	
	if ([rsltCode intValue] != 0) {
		NSString *strErrDesc = [singles objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
		[self.indicatorModalView removeFromSuperview];
		self.EmployeeDetailView.hidden = NO;
		[self.indicator stopAnimating];
	}
	else {
        //NSString *totalcount = [singles valueForKey:@"totalcount"];
        //self.totalcounts = [totalcount intValue];
		
		self.detailData = (NSArray *)[_resultDic valueForKey:@"personinfo"];
		if ([detailData count] > 0) {
            if ([[detailData objectAtIndex:0] objectForKey:@"reserv3"]!=nil) {
                NSString *base64EncodedString =[[detailData objectAtIndex:0] objectForKey:@"reserv3"];
                NSData	*b64DecData = [Base64 decode:base64EncodedString];
                UIImage* base64images = [UIImage imageWithData:b64DecData];
                if (base64images!= nil) {
                    self.base64image.image = base64images;
                    
                }
                else {
                    self.base64image.image = [UIImage imageNamed:@"nobody.png"];
                }
            }
			
			
			self.corp.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"corp"]];
			self.email.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"email"]];
			self.mobile.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"mobile"]];
			self.name.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"name"]];
			self.phone1.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"phone1"]];
			self.reserv1.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"reserv1"]];
			self.reserv2.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"reserv2"]];
			self.roll.text = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"roll"]];
			self.dept = [NSString stringWithFormat:@"%@", [[detailData objectAtIndex:0] objectForKey:@"dept"]];
			
			
			
			
            //[self.popoverController dismissPopoverAnimated:YES];
			
			[self.indicatorModalView removeFromSuperview];
			self.EmployeeDetailView.hidden = YES;
		}
		
		else {
            //NSLog(@"errmesage : %@", [singles objectForKey:@"errdesc"]);
			NSString *errdesc = [singles objectForKey:@"errdesc"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errdesc
														   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
			
			[alert show];	
			[alert release];
			[self.indicatorModalView removeFromSuperview];
			self.EmployeeDetailView.hidden = NO;
            self.name.text = nil;
            
			
		}
		
	}
	
}	


#pragma mark -
#pragma mark Rotation support


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
//	self.EmployeeDetailView.hidden = NO;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    // Call again when view appear to refresh the data
    
    if (cm != nil) {
		[cm cancelCommunication];
	}

	[self.popoverController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.EmployeeDetailView.hidden = NO;
	[self EmployeeDetailView];
	[self createViewControllers];
	noti = [NSNotificationCenter defaultCenter];

	[noti addObserver:self selector:@selector(detailViewClear) name:@"detailViewClear" object:nil];
	
    [super viewDidLoad];
	
	
}
-(void)detailViewClear{
	self.base64image.image = nil;
	self.corp.text = nil;
	self.email.text = nil;
	self.mobile.text = nil;
	self.name.text = nil;
	self.phone1.text = nil;
	self.reserv1.text = nil;
	self.reserv2.text = nil;
	self.roll.text = nil;
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) // "취소" 버튼
    {
        // 처리 내용
        //NSLog(@"cancel");
    }
    else // buttonIndex == 0 // "확인" 버튼
    {
		if ([alertView tag] == 11) {
			NSString *call = [NSString stringWithFormat:@"tel:%@",phone1.text];
			[[UIApplication sharedApplication] openURL:[NSURL  URLWithString:call]];
		}
		if ([alertView tag] == 22) {
			NSString *call = [NSString stringWithFormat:@"tel:%@",mobile.text];
			[[UIApplication sharedApplication] openURL:[NSURL  URLWithString:call]];
			
		}
		if ([alertView tag] == 33) {
//			NSString *sms = [NSString stringWithFormat:@"sms:%@",mobile.text];
//			[[UIApplication sharedApplication] openURL:[NSURL  URLWithString:sms]];
            //ios4x
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText]) {
                controller.body = @""; //메시지 바디
                controller.recipients = [NSArray arrayWithObjects:mobile.text, nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }

            
		}
		if ([alertView tag] == 44) {
//			NSString *emails = [NSString stringWithFormat:@"mailto:%@",email.text];
//			[[UIApplication sharedApplication] openURL:[NSURL  URLWithString:emails]];
            
            
            // 임직원의 경우 이메일이다.
            NSMutableArray *mailFromDics = [[NSMutableArray alloc] initWithCapacity:0];
            NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name.text,@"name",email.text,@"email",nil];
            [mailFromDics addObject:valueDic];
            [valueDic release];
            
            //NSLog(@"임직원 이메일 전송 mailFromDics[%@]", mailFromDics);
            
            model.contactOptionDic = nil; //초기화
            model.contactOptionDic = [[NSMutableDictionary alloc] init];
            [model.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
            [model.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
            
            [model.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
            [model.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")] forKey:@"items"];
            //[model.contactOptionDic setObject:@"Y" forKey:@"select"];
            
            
            MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
            mailWriteController.titleNavigationBar.text = @"새로운 메시지";
            mailWriteController.contentIndex = @"";
            mailWriteController.subjectField.text = @"";
            [self.navigationController pushViewController:mailWriteController transition:8];
//            [self presentModalViewController:mailWriteController animated:YES];
            [noti postNotificationName:@"orgOverlayView" object:self];

            //[self.navigationController pushViewController:mailWriteController animated:YES];
            [mailWriteController release];

            
            
            
            
            
            
		}
		if ([alertView tag] == 55) {
			
			/*
			 //성 이름 분리
			 NSString *nameFirstLast = name.text;
			 NSMutableArray *nameArray = [[NSMutableArray alloc] initWithCapacity:[nameFirstLast length]];
			 
			 for (int i = 0; i < [nameFirstLast length]; i++) {
			 NSString *ichar  = [NSString stringWithFormat:@"%C", [nameFirstLast characterAtIndex:i]];
			 
			 [nameArray addObject:ichar];
			 
			 }
			 
			 NSString *nameLast = [nameArray objectAtIndex:0];
			 
			 [nameArray removeObjectAtIndex:0];
			 NSString *nameFirst = [nameArray componentsJoinedByString:@""];
			 
			 */
			
			
			
			ABAddressBookRef addressBook = ABAddressBookCreate();
			ABRecordRef person = ABPersonCreate();
			
			ABRecordSetValue(person, kABPersonFirstNameProperty, dept , nil);
			ABRecordSetValue(person, kABPersonLastNameProperty, name.text , nil);
			ABRecordSetValue(person, kABPersonJobTitleProperty, reserv2.text , nil);
			ABRecordSetValue(person, kABPersonDepartmentProperty, reserv1.text , nil);
			ABRecordSetValue(person, kABPersonOrganizationProperty, corp.text , nil);
			
			
			ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
			ABMultiValueAddValueAndLabel(phoneNumberMultiValue, mobile.text, kABPersonPhoneMobileLabel, nil);
			ABMultiValueAddValueAndLabel(phoneNumberMultiValue, phone1.text, kABWorkLabel, nil);
			ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
			
			ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
			ABMultiValueAddValueAndLabel(emailMultiValue, email.text, kABWorkLabel, nil);
			ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
			
			NSData * dataRef = UIImagePNGRepresentation(base64image.image);
			ABPersonSetImageData(person, (CFDataRef)dataRef, nil);
			
			ABAddressBookAddRecord(addressBook, person, nil);
			ABAddressBookSave(addressBook, nil);
			
			
			
			CFRelease(person);
			CFRelease(phoneNumberMultiValue);
			CFRelease(emailMultiValue);
            // 처리 내용
			UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"알림" message:@"연락처를 저장 하였습니다."
															delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
			[alerts show];	
			[alerts release];
		}
        //[alertView release];
	}
	
	
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            //NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //NSLog(@"Result: sent");
            break;
        case MessageComposeResultFailed:
            //NSLog(@"Result: failed");
            break;
        default:
            //NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)call:(id)sender{//1
    //NSLog(@"%@", phone1.text);
	if (![phone1.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:phone1.text
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"통화", nil];
		[alert setTag:11];
		[alert show];
		[alert release];
		
	}
	
}

- (IBAction)mobile:(id)sender{//2
	if (![mobile.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mobile.text
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"통화", nil];
		[alert setTag:22];
		[alert show];	
		[alert release];
		
	}
}
- (IBAction)sms:(id)sender{//3
	if (![mobile.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mobile.text
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"SMS", nil];
		[alert setTag:33];
		[alert show];	
		[alert release];
		
	}
}
- (IBAction)email:(id)sender{//4
	if (![email.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:email.text
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"Email", nil];
		[alert setTag:44];
		[alert show];	
		[alert release];
		
	}
}
-(IBAction) saveButtonClicked {//5
	if (self.name.text == nil || [self.name.text isEqualToString:@""]) {
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"연락처를 저장 하시겠습니까?"
													   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
		[alert setTag:55];
		[alert show];	
	}
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
- (void)imagepush {
	
}

- (void)dealloc {
	[corp release];
	[email release ];
	[mobile release];
	[name release];
	[phone1 release];
	[pos release];
	[reserv1 release];
	[reserv2 release];	
	[webmail release];
	[base64image release];
	[streams release];
	[saveButton release];
	[streams release];
	[saveButton release];
	[indicator release];
	[tabBarViewController release];
	[menuTabbarView release];
	[EmployeeDetailView release];
	[dept release];
	[cm release];
	[detailData release];
	
    [super dealloc];
}
-(void) popForFirstAppear {
	
	if(self.popoverController != nil){
		if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
			|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            if (self.view.window != nil) {//네비게이션 디테일에서는 타이밍이 안맞아서 거의 nil임 그래서 에러 방지
                [self.popoverController	 presentPopoverFromBarButtonItem:[[self.mainToolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }else{
                [self performSelector:@selector(popForFirstAppear) withObject:nil afterDelay:0.1f];
                

            }

//			[self.popoverController	 presentPopoverFromBarButtonItem:[[mainToolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}
	
}

-(void) popoverDismiss {
	if (self.popoverController != nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
}

@end

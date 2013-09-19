    //
//  QnAWriteViewController.m
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QnAWriteViewController.h"
#import "URL_Define.h"

@implementation QnAWriteViewController

@synthesize writeButton;
@synthesize backButton;
@synthesize titleNavigationBar;

@synthesize titleField;
@synthesize contentView;

@synthesize writeMode;
@synthesize contentIndex;
@synthesize clipboard;
@synthesize indicator;
@synthesize indicatorAlert;
@synthesize placeholderLabel;
@synthesize backgroundButton;

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
	
	self.contentView.delegate = self;
	self.titleField.delegate = self;
	self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	//CGRect framet = self.backgroundButton.frame;

}

- (void)viewWillDisappear:(BOOL)animated
{
	// Call again when view appear to refresh the data
	if (clipboard != nil) {
		[clipboard cancelCommunication];
	}	
	
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.

	if ([self.contentView isFirstResponder]) {
		if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			CGRect frame = CGRectMake(10, 114, 530, 280);
			CGRect frame2 = CGRectMake(9, 117, 523, 270);
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.3f];
			self.contentView.frame = frame;
			self.backgroundButton.frame = frame2;
			
			[UIView commitAnimations];
		} else {
			CGRect frame = CGRectMake(10, 114, 530, 440);
			CGRect frame2 = CGRectMake(9, 117, 523, 430);
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.3f];
			self.contentView.frame = frame;
			self.backgroundButton.frame = frame2;
			
			[UIView commitAnimations];
		}
	}
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
	[writeButton release];
	[backButton release];
	[titleNavigationBar release];
	[titleField release];
	[contentView release]; 	
	[contentIndex release];
	[clipboard release];
	[indicator release];
	[indicatorAlert release];
	[placeholderLabel release];
	[backgroundButton release];
    [super dealloc];
}

-(IBAction) writeButtonClicked {
	if([self.titleField.text length] > 0 && [self.contentView.text length] > 0) {
		// get clipboard module		
		//Communication *
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
		//NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
		//NSLog(@"%@", [tempDefaults stringForKey:@"login_id"]);
		
		// make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		BOOL result;
		switch (self.writeMode) {
			case 0: // ask mode
				//NSLog(@"ask request");
				//[requestDictionary setObject:@"200000079" forKey:@"userid"];
				//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
				//[requestDictionary setObject:[tempDefaults stringForKey:@"login_id"] forKey:@"userid"];
				[requestDictionary setObject:self.titleField.text forKey:@"title"];
				[requestDictionary setObject:self.contentView.text forKey:@"contents"];
				
				// call communicate method
				result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertSOSQuestion];
				
				if (!result) {
					// error occurred
					
				}
				break;
			case 1: // answar mode
				//NSLog(@"answar request");
				//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
				//[requestDictionary setObject:@"200000079" forKey:@"userid"];
				//[requestDictionary setObject:[tempDefaults stringForKey:@"login_id"] forKey:@"userid"];
				[requestDictionary setObject:self.contentIndex forKey:@"itemid"];
				[requestDictionary setObject:self.titleField.text forKey:@"title"];
				[requestDictionary setObject:self.contentView.text forKey:@"contents"];
				
				// call communicate method
				result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertSOSAnswer];
				
				if (!result) {
					// error occurred
					
				}
				break;			
			default:
				break;
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"제목과 내용을 작성해주세요"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}
}

-(IBAction) backButtonClicked {
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) resignResponder {
	[self.contentView resignFirstResponder];
	[self.titleField resignFirstResponder];
	@try
	{
		Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
		id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
		[activeInstance performSelector:@selector(dismissKeyboard)];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"%@", exception);
	}
}

#pragma mark -
#pragma mark UITextViewDelegate and UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	//CGRect framet = self.backgroundButton.frame;
	
	// Landscape Mode
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
		CGRect frame = CGRectMake(10, 114, 530, 280);
		CGRect frame2 = CGRectMake(9, 117, 523, 270);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		self.contentView.frame = frame;
		self.backgroundButton.frame = frame2;
		
		[UIView commitAnimations];
		
	} else { // Portrait Mode
		CGRect frame = CGRectMake(10, 114, 530, 440);
		CGRect frame2 = CGRectMake(9, 117, 523, 430);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		self.contentView.frame = frame;
		self.backgroundButton.frame = frame2;
		
		[UIView commitAnimations];
	}
	
	
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	
	CGRect frame = CGRectMake(10, 114, 530, 530);
	CGRect frame2 = CGRectMake(9, 117, 523, 494);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	self.contentView.frame = frame;
	self.backgroundButton.frame = frame2;
	
	[UIView commitAnimations];

	return YES;	
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.indicatorAlert = [[UIAlertView alloc] initWithTitle:@"작성중입니다...." message:nil
													delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	[self.indicatorAlert show];	
	[self.indicatorAlert release];
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	//NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	[self.indicatorAlert dismissWithClickedButtonIndex:[self.indicatorAlert cancelButtonIndex] animated:NO];
	// get value dictionary form result dictionary
	if (resultNum == 0) {
		self.clipboard = nil;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"작성 완료" message:@"작성을 완료하였습니다"
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		alert.tag = 12345;
		[alert show];	
		[alert release];
/*	} else if (resultNum == 2) {
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
	[self.indicator stopAnimating];
	//NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 접속에 실패하였습니다."
												   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark Login Alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//NSLog(@"%d", alertView.tag);
	//NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
	//NSLog(@"%@", [tempDefaults stringForKey:@"login_id"]);
	
	// if delete qusetion alert
	if(alertView.tag == 12345) {
		// delete confirm
		if(buttonIndex == [alertView cancelButtonIndex]) {
			[self dismissModalViewControllerAnimated:YES];
			NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			if (self.writeMode==0) {
				[noti postNotificationName:@"QnAListReload" object:self];
			} else {
				[noti postNotificationName:@"QnADetailReload" object:self];
				[noti postNotificationName:@"QnAListReload" object:self];
			}
		}
	}
	
}

#pragma mark -
#pragma mark Placeholder for UITextView

- (void)textViewDidChange:(UITextView *)textView {
    if(self.contentView.text.length == 0)
        self.placeholderLabel.hidden = NO;
    else 
        self.placeholderLabel.hidden = YES;
}

@end

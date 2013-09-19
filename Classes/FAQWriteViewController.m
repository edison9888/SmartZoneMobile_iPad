    //
//  FAQWriteViewController.m
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 23..
//  Copyright 2011 Insang. All rights reserved.
//

#import "FAQWriteViewController.h"
#import "URL_Define.h"

@implementation FAQWriteViewController

@synthesize writeButton;
@synthesize backButton;
@synthesize titleNavigationBar;

@synthesize titleField;

@synthesize nicknameLabel;
@synthesize nicknameField;
@synthesize passwordLabel;
@synthesize passwordField;

@synthesize prioritySwitch;
@synthesize nicknameSwitch;
@synthesize contentsLabel;

@synthesize contentView;

@synthesize writeMode;
@synthesize contentIndex;
@synthesize clipboard;
@synthesize indicator;
@synthesize indicatorAlert;
@synthesize placeholderLabel;
@synthesize backgroundButton;

@synthesize boardId;
@synthesize orderBy;
@synthesize sortBy;
@synthesize bullId;
@synthesize depthBull;
@synthesize topBull;
@synthesize categoryData;
@synthesize categoryID;
@synthesize categoryLabel;
@synthesize categoryButton;


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
	
	// default writemode;
	self.writeMode = 0;
	
	nicknameFlag = NO;
	//[self resetInputFields];
	
	self.titleField.delegate = self;
	self.passwordField.delegate = self;
	self.nicknameField.delegate = self;
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
	
	if (categoryPopover) {
		[categoryPopover dismissPopoverAnimated:NO];
	}
	
    if ([self.contentView isFirstResponder]) {
		
		CGRect frame;
		CGRect frame2;
		//CGRect frame3;
		//CGRect frame4;
		
		if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			
			if (nicknameFlag == YES) {
				if ([self.contentView isFirstResponder]) {
					// 가로모드이고 비실명작성이며 현재 작성중
					frame = CGRectMake(10, 245, 530, 140);
					frame2 = CGRectMake(9, 245, 523, 146);
				} else {
					// 가로모드이고 비실명작성이며 키보드 안올라옴
					frame = CGRectMake(10, 245, 530, 285);
					frame2 = CGRectMake(9, 245, 523, 366);
				}
			} else {
				if ([self.contentView isFirstResponder]) {
					// 가로모드이고 실명작성이며 현재 작성중 
					frame = CGRectMake(10, 164, 530, 250);
					frame2 = CGRectMake(9, 163, 523, 230);
				} else {
					// 가로모드이고 비실명작성이며 키보드 안올라옴
					frame = CGRectMake(10, 163, 530, 396+82);
					frame2 = CGRectMake(9, 163, 523, 366+82);
				}
			}
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.3f];
			self.contentView.frame = frame;
			self.backgroundButton.frame = frame2;
			
			[UIView commitAnimations];
		} else {
			if (nicknameFlag == YES) {
				if ([self.contentView isFirstResponder]) {
					frame = CGRectMake(10, 245, 530, 316);
					frame2 = CGRectMake(9, 245, 523, 296);
				} else {
					frame = CGRectMake(10, 245, 530, 396);
					frame2 = CGRectMake(9, 245, 523, 366);
				}
				//frame3 = CGRectMake(0, 217, 530, 21);
				//frame4 = CGRectMake(19, 249, 211, 21);
			} else {
				if ([self.contentView isFirstResponder]) {
					frame = CGRectMake(10, 163, 530, 408);
					frame2 = CGRectMake(9, 163, 523, 378);
				} else {
					frame = CGRectMake(10, 163, 530, 396+82);
					frame2 = CGRectMake(9, 163, 523, 366+82);
				}
				//frame3 = CGRectMake(0, 217-82, 530, 21);
				//frame4 = CGRectMake(19, 249-82, 211, 21);
			}
			
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
	writeButton = nil;
	backButton = nil;
	titleNavigationBar = nil;
	titleField = nil;
	
	nicknameLabel = nil;
	nicknameField = nil;
	passwordLabel = nil;
	passwordField = nil;
	
	prioritySwitch = nil;
	nicknameSwitch = nil;
	
	nicknameField = nil;
	contentsLabel = nil;
	
	contentView = nil;
	contentIndex = nil;
	clipboard = nil;
	indicator = nil;
	indicatorAlert = nil;
	placeholderLabel = nil;
	backgroundButton = nil;
	
	boardId = nil;
	orderBy = nil;
	sortBy = nil;
	
	bullId = nil;
	depthBull = nil;
	topBull = nil;
	categoryData = nil;
	categoryID = nil;
	
	categoryLabel = nil;
	categoryButton = nil;
	
    [super dealloc];
}

-(IBAction) writeButtonClicked {
	
	if([self.titleField.text length] > 0 && [self.contentView.text length] > 0) {
		if ([self.nicknameSwitch isOn]) {
			if([self.passwordField.text length] > 0 && [self.nicknameField.text length] > 0) {
				// ok
			} else {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비실명 작성시 비실명과 비밀번호를 입력하셔야 합니다."
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				[alert show];	
				[alert release];
				
				return;
				 /*
				if([nicknameField.text length] <= 0){
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"비실명을 입력하세요."
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
					[alert show];	
					[alert release];
					
					return;
				}
				if ([passwordField.text length] <= 0) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"비밀번호를 입력하세요."
																   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
					[alert show];	
					[alert release];
					return;
				}
				 */
			}	
		}
		// get clipboard module		
		//Communication *
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
		// make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		
		[requestDictionary setObject:self.boardId forKey:@"boardid"];
		[requestDictionary setObject:self.sortBy forKey:@"sortby"];
		[requestDictionary setObject:self.orderBy forKey:@"orderby"];
		
		//categoryid = BCI201104261504142844570;
		//[requestDictionary setObject:@"BCI201104261504142844570" forKey:@"categoryid"];
		
		[requestDictionary setObject:@"1" forKey:@"cpage"];
		[requestDictionary setObject:@"20" forKey:@"maxrow"];
		
		// 긴급 1 일반 0 
		if ([self.prioritySwitch isOn]) {
			[requestDictionary setObject:@"1" forKey:@"emergency"];
		} else {
			[requestDictionary setObject:@"0" forKey:@"emergency"];
		}
		
		if ([self.nicknameSwitch isOn]) {
			[requestDictionary setObject:self.nicknameField.text forKey:@"registrant"];
			[requestDictionary setObject:self.passwordField.text forKey:@"password"];
			[requestDictionary setObject:@"Y" forKey:@"incognitoflag"];
		} else {
			[requestDictionary setObject:@"N" forKey:@"incognitoflag"];
		}
		
		[requestDictionary setObject:self.titleField.text forKey:@"bulltitle"];
		[requestDictionary setObject:self.contentView.text forKey:@"content"];
		
		//NSLog(@"test : %@", self.contentView.text);
		
		BOOL result;
		
		switch (self.writeMode) {
			case 0: // ask mode
				//NSLog(@"ask request");
				// call communicate method
				//[requestDictionary setObject:@"0" forKey:@"depth"];
				// 선택된 카테고리ID 입력 
				[requestDictionary setObject:self.categoryID forKey:@"categoryid"];
				
				result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertFAQBull];				
				
				if (!result) {
					// error occurred
				}
				break;
			case 1: // answar mode
				//NSLog(@"answar request");
				//[requestDictionary setObject:self.contentIndex forKey:@"itemid"];
				//NSLog(@"%@", self.depthBull);
				//NSInteger depthtemp = [self.depthBull intValue];
				//NSLog(@"depth : %d", depthtemp);
				
				[requestDictionary setObject:self.depthBull forKey:@"depth"];
				[requestDictionary setObject:self.bullId forKey:@"pbullid"];
				[requestDictionary setObject:self.topBull forKey:@"bulltopid"];
				[requestDictionary setObject:self.categoryID forKey:@"categoryid"];
				
				// call communicate method
				result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertFAQBullReply];
				
				if (!result) {
					// error occurred
				}
				break;	
			default:
				break;
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"제목과 내용을 작성해주세요"
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
	CGRect frame;
	CGRect frame2;
	//CGRect frame3;
	//CGRect frame4;
	// Landscape Mode
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
		
		if (nicknameFlag == YES) {
			frame = CGRectMake(10, 245, 530, 140);
			frame2 = CGRectMake(9, 245, 523, 146);
			//frame3 = CGRectMake(0, 217, 540, 21);
			//frame4 = CGRectMake(19, 249, 211, 21);
		} else {
			frame = CGRectMake(10, 164, 530, 250);
			frame2 = CGRectMake(9, 163, 523, 230);
			//frame3 = CGRectMake(0, 135, 540, 21);//
			//frame4 = CGRectMake(19, 167, 211, 21);//
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		self.contentView.frame = frame;
		self.backgroundButton.frame = frame2;
		
		[UIView commitAnimations];
		
	} else { // Portrait Mode
		
		if (nicknameFlag == YES) {
			frame = CGRectMake(10, 245, 530, 316);
			frame2 = CGRectMake(9, 245, 523, 296);
			//frame3 = CGRectMake(0, 217, 540, 21);
			//frame4 = CGRectMake(19, 249, 211, 21);
		} else {
			frame = CGRectMake(10, 163, 530, 408);
			frame2 = CGRectMake(9, 163, 523, 378);
			//frame3 = CGRectMake(0, 135, 540, 21);//
			//frame4 = CGRectMake(19, 167, 211, 21);//
		}
		
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
	
	CGRect frame;
	CGRect frame2;
	CGRect frame3;
	CGRect frame4;
	
	if (nicknameFlag == YES) {
		frame = CGRectMake(10, 245, 530, 396);
		frame2 = CGRectMake(9, 245, 523, 366);
		frame3 = CGRectMake(0, 217, 540, 21);
		frame4 = CGRectMake(19, 249, 211, 21);
	} else {
		frame = CGRectMake(10, 163, 530, 396+82);
		frame2 = CGRectMake(9, 163, 523, 366+82);
		frame3 = CGRectMake(0, 135, 540, 21);//
		frame4 = CGRectMake(19, 167, 211, 21);//
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	
	self.contentView.frame = frame;
	self.backgroundButton.frame = frame2;
	self.contentsLabel.frame = frame3;
	self.placeholderLabel.frame = frame4;
	
	[UIView commitAnimations];
	
	return YES;	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    //if(textField.tag == 444) {
	//NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"] invertedSet];
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	// newLength가 n보다 큰 경우 입력불가 ; n만큼만의 글자만 입력받는다
	if (textField == self.titleField) {
		if (newLength > 400) {
			return NO;
		}
	} else if (textField == self.passwordField) {
		if (newLength > 25) {
			return NO;
		}
	} else if (textField == self.nicknameField) {
		if (newLength > 80) {
			return NO;
		}
	}
	
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
				[noti postNotificationName:@"FAQListReload" object:self];
			} else {
				//[noti postNotificationName:@"FAQDetailReload" object:self];
				[noti postNotificationName:@"FAQListReload" object:self];
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

-(IBAction) prioritySwitchChanged:(id)sender {
	if ([self.prioritySwitch isOn]) {
		//NSLog(@"긴급!");
	} else {
		//NSLog(@"일반~");
	}
	
}

-(IBAction) nicknameSwitchChanged:(id)sender {
	if ([self.nicknameSwitch isOn]) {
		//NSLog(@"필명!");
		nicknameFlag = YES;
	} else {
		//NSLog(@"실명~");
		nicknameFlag = NO;
	}
	[self resetInputFields];
}

-(void) resetInputFields {

	// y가 217 -> 135 = 82px
	if (nicknameFlag == YES) {
		self.passwordField.hidden = NO;
		self.passwordLabel.hidden = NO;
		self.nicknameField.hidden = NO;
		self.nicknameLabel.hidden = NO;
	} else {
		self.passwordField.hidden = YES;
		self.passwordLabel.hidden = YES;
		self.nicknameField.hidden = YES;
		self.nicknameLabel.hidden = YES;
	}
	
	CGRect frame;
	CGRect frame2;
	CGRect frame3;
	CGRect frame4;
	
	// Landscape Mode
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
		
		if (nicknameFlag == YES) {	
			if ([self.contentView isFirstResponder]) {
				// 가로모드이고 비실명작성이며 현재 작성중
				frame = CGRectMake(10, 245, 530, 140);
				frame2 = CGRectMake(9, 245, 523, 146);
			} else {
				// 가로모드이고 비실명작성이며 키보드 안올라옴
				frame = CGRectMake(10, 245, 530, 285);
				frame2 = CGRectMake(9, 245, 523, 366);
			}
			
			// 가로모드이고 비실명작성일때 내용선과 안내글 
			frame3 = CGRectMake(0, 217, 540, 21);//
			frame4 = CGRectMake(19, 249, 211, 21);//
		} else {
			if ([self.contentView isFirstResponder]) {
			// 가로모드이고 실명작성이며 현재 작성중 
				frame = CGRectMake(10, 164, 530, 250);
				frame2 = CGRectMake(9, 163, 523, 230);
			} else {
			// 가로모드이고 실명작성이며 키보드 안올라옴
				frame = CGRectMake(10, 163, 530, 396+82);
				frame2 = CGRectMake(9, 163, 523, 366+82);
			}
			
			// 가로모드이고 실명작성일때 내용선과 안내글 
			frame3 = CGRectMake(0, 135, 540, 21);//
			frame4 = CGRectMake(19, 167, 211, 21);//
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		self.contentView.frame = frame;
		self.backgroundButton.frame = frame2;
		self.contentsLabel.frame = frame3;
		self.placeholderLabel.frame = frame4;
		
		[UIView commitAnimations];
		
	} else { // Portrait Mode
		
		if (nicknameFlag == YES) {
			if ([self.contentView isFirstResponder]) {
				frame = CGRectMake(10, 245, 530, 316);
				frame2 = CGRectMake(9, 245, 523, 296);
			} else {
				frame = CGRectMake(10, 245, 530, 396);
				frame2 = CGRectMake(9, 245, 523, 366);			
			}
			
			// 세로모드이고 비실명작성일때 내용선과 안내글 
			frame3 = CGRectMake(0, 217, 540, 21);//
			frame4 = CGRectMake(19, 249, 211, 21);//
		} else {
			if ([self.contentView isFirstResponder]) {
				frame = CGRectMake(10, 163, 530, 408);
				frame2 = CGRectMake(9, 163, 523, 378);
			} else {
				frame = CGRectMake(10, 163, 530, 396+82);
				frame2 = CGRectMake(9, 163, 523, 366+82);
			}
			
			// 세로모드이고 실명작성일때 내용선과 안내글 
			frame3 = CGRectMake(0, 135, 540, 21);//
			frame4 = CGRectMake(19, 167, 211, 21);//
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		self.contentView.frame = frame;
		self.backgroundButton.frame = frame2;
		self.contentsLabel.frame = frame3;
		self.placeholderLabel.frame = frame4;
		
		[UIView commitAnimations];
	}
	
}


#pragma mark -
#pragma mark Category popover

-(IBAction) categoryPopoverClicked {
	
    FAQCategoryViewController *categoryTable = [[FAQCategoryViewController alloc] initWithStyle:UITableViewStylePlain];
	categoryTable.categoryList = (NSMutableArray *)self.categoryData;
	categoryTable.delegate = self;
	
    categoryPopover = [[UIPopoverController alloc] initWithContentViewController:categoryTable];      
	
	[categoryTable release];
	
	
	CGRect cgv = CGRectMake(109, 94, 72, 32);
	/*
	if ([self.orientations isEqualToString:@"1"] || [self.orientations isEqualToString:@"2"]) {
		cgv.size.width+=800;
		cgv.size.height+=45;
		
	}
	else if ([self.orientations isEqualToString:@"3"] || [self.orientations isEqualToString:@"4"]) {
		cgv.size.width+=1315;
		cgv.size.height+=45;
		
	}
	*/
	
	[categoryPopover presentPopoverFromRect:cgv inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

- (void)categorySelected:(NSString *)category categoryID:(NSString *)categoryCome {
	//NSLog(@"category : %@", category);

	self.categoryLabel.text = category;
	self.categoryID = categoryCome;
	/*
	if ([categoryLabel.text isEqualToString:@"자유"]) {
		//categoryID = @"BCI201104261504142844570";
		self.categoryID = categoryCome;
	} else if ([categoryLabel.text isEqualToString:@"주제"]) {
		//categoryID = @"BCI201104261504142754569";
		self.categoryID = categoryCome;
	}
	 */

	[categoryPopover dismissPopoverAnimated:YES];
}

@end

    //
//  FAQCommentViewController.m
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 7. 6..
//  Copyright 2011 Insang. All rights reserved.
//

#import "FAQCommentViewController.h"
#import "URL_Define.h"

@implementation FAQCommentViewController

//@synthesize titleField;
@synthesize nicknameField;
@synthesize nicknameSwitch;
@synthesize commentTableView;

//@synthesize contentsLabel;
@synthesize contentView;

@synthesize clipboard;
@synthesize indicator;
@synthesize indicatorAlert;

@synthesize boardId;
@synthesize bullId;
@synthesize commentArray;
@synthesize commentIndex;

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

- (void)viewWillDisappear:(BOOL)animated
{
	if (clipboard != nil) {
		[clipboard cancelCommunication];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.contentView.delegate = self;
	self.nicknameField.delegate = self;
	self.clipboard = nil;
	self.commentTableView.delegate = self;
	self.commentTableView.dataSource = self;
	
	self.commentTableView.allowsSelection = NO;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	nicknameFlag = NO;
	communicationFlag = NONE_COMMENT;
}

-(void)viewDidAppear:(BOOL)animated {
	//[self.commentTableView reloadData];
	[super viewDidAppear:animated];
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
	
	nicknameField = nil;
	nicknameSwitch = nil;
	commentTableView = nil;
	
	//contentsLabel;
	contentView = nil;
	
	clipboard = nil;
	indicator = nil;
	indicatorAlert = nil;
	
	boardId = nil;
	bullId = nil;
	commentArray = nil;
	
    [super dealloc];
}



-(IBAction) backButtonClicked {
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) writeButtonClicked {
	if([self.contentView.text length] > 0) {
		if ([self.nicknameSwitch isOn]) {
			if([self.nicknameField.text length] > 0) {
				// ok
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비실명을 입력하세요"
															   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
				[alert show];	
				[alert release];
				
				return;
			}
		}
		// get clipboard module		
		//Communication *
		
		communicationFlag = WRITE_COMMENT;
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
		// make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		
		[requestDictionary setObject:self.boardId forKey:@"boardid"];
		[requestDictionary setObject:self.bullId forKey:@"bullid"];
		
		if ([self.nicknameSwitch isOn]) {
			[requestDictionary setObject:self.nicknameField.text forKey:@"registrant"];
			[requestDictionary setObject:@"Y" forKey:@"incognitoflag"];
		} else {
			[requestDictionary setObject:@"N" forKey:@"incognitoflag"];
		}
		
		[requestDictionary setObject:self.contentView.text forKey:@"bullcomment"];
		
		BOOL result;
		
		result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertBullComment];				
		
		if (!result) {
			// error occurred
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"내용을 작성해주세요"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}
}

-(IBAction) resignResponder {
	[self.contentView resignFirstResponder];
	[self.nicknameField resignFirstResponder];
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

-(IBAction) nicknameSwitchChanged:(id)sender {
	if ([self.nicknameSwitch isOn]) {
		//NSLog(@"필명!");
		nicknameFlag = YES;
		self.nicknameField.hidden = NO;
		self.nicknameField.text = @"";
	} else {
		//NSLog(@"실명~");
		nicknameFlag = NO;
		self.nicknameField.hidden = YES;
		self.nicknameField.text = @"";
	}
	//[self resetInputFields];
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	
	if (communicationFlag == WRITE_COMMENT) {
		self.indicatorAlert = [[UIAlertView alloc] initWithTitle:@"작성중입니다...." message:nil
													delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	} else if (communicationFlag == DELETE_COMMENT) {
		self.indicatorAlert = [[UIAlertView alloc] initWithTitle:@"삭제중입니다...." message:nil
														delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	}

	[self.indicatorAlert show];	
	[self.indicatorAlert release];
	
	[self resignResponder];
	
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
		UIAlertView *alert = nil;
		
		if (communicationFlag == WRITE_COMMENT) {
			alert = [[UIAlertView alloc] initWithTitle:@"작성 완료" message:@"작성을 완료하였습니다"
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		} else if (communicationFlag == DELETE_COMMENT) {
			alert = [[UIAlertView alloc] initWithTitle:@"삭제 완료" message:@"해당 댓글에 대한 삭제를 완료하였습니다"
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];	
		}
		alert.tag = 12345;
		[alert show];	
		[alert release];
		
		
		self.commentArray = nil;
		self.commentArray = [_resultDic objectForKey:@"recommentlistinfo"];
		
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
			//[self dismissModalViewControllerAnimated:YES];
			NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			/*
			 if (self.writeMode==0) {
			 [noti postNotificationName:@"FAQListReload" object:self];
			 } else {
			 */
			//[noti postNotificationName:@"FAQDetailReload" object:self];
			[noti postNotificationName:@"FAQListReload" object:self];
			//}
			
			// 입력창 리셋
			nicknameFlag = NO;
			self.nicknameField.hidden = YES;
			self.nicknameField.text = @"";
			self.contentView.text = @"";
			self.nicknameSwitch.on = NO;
			
			[self.commentTableView reloadData];
		}
	} else if(alertView.tag == 5554) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			
			communicationFlag = DELETE_COMMENT;
			
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.boardId forKey:@"boardid"];
			[requestDictionary setObject:self.bullId forKey:@"bullid"];
			[requestDictionary setObject:[[self.commentArray objectAtIndex:self.commentIndex] objectForKey:@"commentid"]
								  forKey:@"commentid"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBullComment];
			
			if (!result) {
				// error occurred
				
			}
			
		}
	}
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	/*
	if (self.commentArray) {
		if ([[self.commentArray objectForKey:@"commentcnt"] intValue] > 0) {
			return 2;
		}
		//return 1;
	}
	 */
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	// return 7;//[self.noticeList count];
	/*
	switch (section) {
		case 0:
			if (self.commentArray) {
				return 3;
			} else {
				return 0;
			}
			break;
		case 1:
			return [[self.commentArray objectForKey:@"commentcnt"] intValue] + 1;
			break;			
		default:
			return 0;
			break;
	}
	 */
	
	if ([self.commentArray count] == 0) {
		return 1;
	}
	else {
		return [self.commentArray count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;
	/*= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	 if (cell == nil) {
	 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	 }*/
	
	if ([self.commentArray count] == 0) {
		cell = noContentsCell;
	} else {
		// Configure the cell...
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"FAQAnswarCell" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		// get temp reply dictionary
		NSDictionary *tempReply = [self.commentArray objectAtIndex:indexPath.row];
		
		// set background color 
		UIView *tempBgView = (UIView *)[cell viewWithTag:20];
		if (indexPath.row == 0 || indexPath.row%2 == 0) {
			tempBgView.backgroundColor = [UIColor whiteColor];
		} else {
			tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
		}
		
		UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:23];
		if ([[tempReply objectForKey:@"incognitoflag"] isEqualToString:@"Y"]) {
			tempNameLabel.text = [tempReply objectForKey:@"registrant"];
		}else {
			tempNameLabel.text = [tempReply objectForKey:@"username"];
		}
		
		// -- set date -- //
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:24];
		tempDateLabel.text = [tempReply objectForKey:@"bulldate"];
		
		
		UITextView *tempTextView = (UITextView *)[cell viewWithTag:22];
		//[tempTextView setContentToHTMLString:[tempReply objectForKey:@"bullcomment"]]; // hidden method
		tempTextView.text = [tempReply objectForKey:@"bullcomment"]; // hidden method
		
		
		// 댓글 삭제 버튼 활성화 여부
		UIButton *tempDeleteCommentBtn = (UIButton *)[cell viewWithTag:25];
		if ([[tempReply objectForKey:@"delyn"] isEqualToString:@"N"]) {
			tempDeleteCommentBtn.hidden = YES;
		}else {
			tempDeleteCommentBtn.tag = indexPath.row;
			tempDeleteCommentBtn.hidden = NO;
			[tempDeleteCommentBtn addTarget:self action:@selector(clickedDeleteComment:) forControlEvents:UIControlEventTouchUpInside];
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
	/*
	 NoticeDetailContentController *detailContentController = [[NoticeDetailContentController alloc] initWithNibName:@"NoticeDetailContentController" bundle:nil];
	 detailContentController.title = self.title;
	 //[detailContentController loadDetailContentAtIndex:[indexPath row]];
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailContentController animated:YES];
	 [detailContentController loadDetailContentAtIndex:[indexPath row]];
	 [detailContentController release];
	 */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize newSize;
	
	if ([self.commentArray count] == 0) {
		return 60.0;
	} else {
		
		NSDictionary *tempReply = [self.commentArray objectAtIndex:indexPath.row];
		newSize = [[tempReply objectForKey:@"bullcomment"]
				   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
				   constrainedToSize:CGSizeMake(700,99999)
				   lineBreakMode:UILineBreakModeWordWrap];
		
		return newSize.height + 70.0;// 65px for other labels & 25px margin
	}
}

- (IBAction)clickedDeleteComment:(id)sender {
	self.commentIndex = [sender tag];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 댓글을 삭제하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 5554;
	//self.delegate_flag = DELETE_COMMENT;
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark UITextViewDelegate and UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    //if(textField.tag == 444) {
	//NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"] invertedSet];
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	// newLength가 n보다 큰 경우 입력불가 ; n만큼만의 글자만 입력받는다
	if (textField == self.nicknameField) {
		if (newLength > 320) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	//if(textField.tag == 444) {
	//NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"] invertedSet];
	NSUInteger newLength = [textView.text length] + [text length] - range.length;
	// newLength가 n보다 큰 경우 입력불가 ; n만큼만의 글자만 입력받는다
	if (textView == self.contentView) {
		if (newLength > 800) {
			return NO;
		}
	}
	
	return YES;
	
}


@end

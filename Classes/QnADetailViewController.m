    //
//  QnADetailViewController.m
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QnADetailViewController.h"
#import "QnARootViewController.h"
#import "QnAWriteViewController.h"
#import "URL_Define.h"

#import "CustomSubTabViewController.h"

#import "MobileKate2_0_iPadAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface QnADetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
//- (void)configureView;
@end


@implementation QnADetailViewController

@synthesize toolbar, popoverController;
@synthesize mainButton;
@synthesize imageView;
@synthesize answarButton;
@synthesize deleteButton;

@synthesize contentTableView;
@synthesize mainContentCell;
@synthesize titleCell;
@synthesize nameCell;
@synthesize answarLineCell;
@synthesize contentDictionary;

@synthesize progressAlert;
@synthesize progressIndicator;

@synthesize itemid;
@synthesize delegate_flag;
@synthesize delete_id;
@synthesize select_id;

@synthesize clipboard;
@synthesize indicator;

@synthesize menuTabbarView;
@synthesize subMenu;

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
-(void)createViewControllers {
	
	self.subMenu = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
	
	//CGRect tabbarRect = subMenu.view.frame;
	//tabbarRect.origin.y = 500.0;
	//self.subMenu.view.frame = tabbarRect;
	//self.subMenu.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
	[self.subMenu.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
	//self.subMenu.view.contentMode = UIViewContentModeBottom|UIViewContentModeLeft|UIViewContentModeRight;
	[self.menuTabbarView addSubview:self.subMenu.view];
	//[self.view addSubview:self.subMenu.view];
	//NSLog(@"%d", [self.view.subviews count]);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
	self.contentTableView.allowsSelection = NO;
	self.contentTableView.backgroundView = nil;
	
	self.delegate_flag = NO_ACT;
	self.delete_id = 0;
	self.select_id = 0;
	
	self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	[self createViewControllers];
	
	noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(reloadDetailContent) name:@"QnADetailReload" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.imageView.hidden = NO;
	[super viewWillAppear:animated];
}
	
- (void)viewWillDisappear:(BOOL)animated
{
	// Call again when view appear to refresh the data
	[self.indicator stopAnimating];
	//[self.view addSubview:self.imageView];
	self.imageView.hidden = NO;
	if (clipboard != nil) {
		[clipboard cancelCommunication];
	}	
	
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
		// Landscape mode
		//if ([[toolbar items] count] < 2) {
		NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
							 nil];
		[toolbar setItems:newArray];
		/*
		} else {
		 NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
		 [[toolbar items] objectAtIndex:1], nil];
		 [toolbar setItems:newArray];
		 }*/
	} else {
		// Portrait mode
		//if ([[toolbar items] count] < 3) {
		NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
							 [[toolbar items] objectAtIndex:1], nil];
		[toolbar setItems:newArray];	
		/*
		} else {
		 NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0],
		 [[toolbar items] objectAtIndex:1], answarButton, nil];
		 [toolbar setItems:newArray];
		 }*/
		
	}
	self.contentDictionary = nil;
	[self.contentTableView reloadData];
	
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
	if(self.popoverController != nil){
		[self.popoverController	 presentPopoverFromBarButtonItem:[[toolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
    [super viewDidAppear:animated];
}
*/

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"알려주세요";
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
	[popoverController release];
	[toolbar release];
	[mainButton release];
	[imageView release];
	[answarButton release];
	[deleteButton release];
	
	[contentTableView release];
	[mainContentCell release];
	[titleCell release];
	[nameCell release];
	[answarLineCell release];
	
	[contentDictionary release];
	[progressAlert release];
	[progressIndicator release];
	
	[itemid release];
	[clipboard release];
	[indicator release];
	
	[menuTabbarView release];
	[subMenu release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.contentDictionary) {
		if ([[self.contentDictionary objectForKey:@"replycnt"] intValue] > 0) {
			return 2;
		}
		//return 1;
	}
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   // return 7;//[self.noticeList count];
	switch (section) {
		case 0:
			if (self.contentDictionary) {
				return 3;
			} else {
				return 0;
			}
			break;
		case 1:
			return [[self.contentDictionary objectForKey:@"replycnt"] intValue] + 1;
			break;			
		default:
			return 0;
			break;
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
    
    // Configure the cell...
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			UILabel *tempTitle = (UILabel *)[titleCell viewWithTag:111];
			tempTitle.text = [self.contentDictionary objectForKey:@"title"];
			cell = titleCell;
		} else if (indexPath.row == 1) {
			UILabel *tempName = (UILabel *)[nameCell viewWithTag:222];
			tempName.text = [self.contentDictionary objectForKey:@"name"];
			UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];
			// -- set date -- //
			//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			//[dateFormatter setDateFormat:@"yyyyMMddHHmm"];
			//NSDate *myDate = [dateFormatter dateFromString:[self.contentDictionary objectForKey:@"date"]];
			//[dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
			//tempDate.text = [dateFormatter stringFromDate:myDate];
			tempDate.text = [self.contentDictionary objectForKey:@"date"];
			
			cell = nameCell;
		} else if (indexPath.row == 2) {			
			UITextView *tempView = (UITextView *)[mainContentCell viewWithTag:777];
			[tempView setContentToHTMLString:[self.contentDictionary objectForKey:@"contents"]]; // hidden method
			/*
			 UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
			 tempView.delegate = self;
			 //NSLog([self.contentDictionary objectForKey:@"content"]);
			 [tempView loadHTMLString:[self.contentDictionary objectForKey:@"contents"] baseURL:nil];
			 */
			cell = mainContentCell;
			
		}
	} else {
		if (indexPath.row == 0) {
			cell = answarLineCell;
		} else {
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"QnAAnswarCell" owner:self options:nil];
				cell = [topObject objectAtIndex:0];
			}
			// get temp reply dictionary
			NSDictionary *tempReply = [[self.contentDictionary objectForKey:@"sosdetailiteminfo"] objectAtIndex:(indexPath.row-1)];
			
			// set background color 
			UIView *tempBgView = (UIView *)[cell viewWithTag:20];
			if (indexPath.row == 0 || indexPath.row%2 == 0) {
				tempBgView.backgroundColor = [UIColor whiteColor];
			} else {
				tempBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];		
			}
			/*
			 if ([[tempReply objectForKey:@"choiceyn"] isEqualToString:@"true"]) {
			 tempBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.4];
			 }
			 */
			
			UILabel *tempTitleLabel = (UILabel *)[cell viewWithTag:21];
			tempTitleLabel.text = [tempReply objectForKey:@"title"];
			UILabel *tempNameLabel = (UILabel *)[cell viewWithTag:23];
			tempNameLabel.text = [tempReply objectForKey:@"name"];
			
			// -- set date -- //
			//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			//[dateFormatter setDateFormat:@"yyyyMMddHHmm"];
			//NSDate *myDate = [dateFormatter dateFromString:[tempReply objectForKey:@"date"]];
			//[dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
			UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:24];
			//tempDateLabel.text = [dateFormatter stringFromDate:myDate];
			tempDateLabel.text = [tempReply objectForKey:@"date"];
			
			
			UITextView *tempTextView = (UITextView *)[cell viewWithTag:22];
			[tempTextView setContentToHTMLString:[tempReply objectForKey:@"contents"]]; // hidden method
			//tempTextView.font = [UIFont fontWithName:@"Helvetica" size:14];
			//tempTextView.text = [tempReply objectForKey:@"contents"];
			//UIWebView *tempWebView = (UIWebView *)[cell viewWithTag:22];
			//tempWebView.delegate = self;
			//tempWebView.backgroundColor = [UIColor blackColor];
			//tempWebView.backgroundColor = [UIColor clearColor];
			//NSLog([self.contentDictionary objectForKey:@"content"]);
			//[tempWebView loadHTMLString:[tempReply objectForKey:@"contents"] baseURL:nil];
			
			UIButton *tempButton;
			UIImageView *tempImage;
			CGRect tempFrameRect;
			// ----------------------------------- set if clause for dynamic button setting
			if ([[self.contentDictionary objectForKey:@"choiceyn"] isEqualToString:@"true"]) {
				// choose button
				tempButton = (UIButton *)[cell viewWithTag:26];
				tempButton.hidden = NO;
				tempButton.tag = [[tempReply objectForKey:@"itemid"] intValue];
				[tempButton addTarget:self action:@selector(selectChooseButton:) forControlEvents:UIControlEventTouchUpInside];
			} else if ([[tempReply objectForKey:@"deleteyn"] isEqualToString:@"true"]) {
				//delete button
				tempButton = (UIButton *)[cell viewWithTag:25];
				tempButton.hidden = NO;
				tempButton.tag = [[tempReply objectForKey:@"itemid"] intValue];
				[tempButton addTarget:self action:@selector(selectDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
			} else if ([[tempReply objectForKey:@"choiceyn"] isEqualToString:@"true"]) {
				// no buttons and choosed
				tempImage = (UIImageView *)[cell viewWithTag:27];
				//tempImage.hidden = NO;
				tempFrameRect = tempTitleLabel.frame;
				tempFrameRect.origin.x += 48.0;
				tempTitleLabel.frame = tempFrameRect;
				tempImage.hidden = NO;
			}
			
			/*
			 // Add answar button if not added
			 if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
			 || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
			 // Landscape mode
			 if ([[toolbar items] count] < 3) {
			 NSArray *newArray = [NSArray arrayWithObjects:answarButton, [[toolbar items] objectAtIndex:0], 
			 [[toolbar items] objectAtIndex:1], nil];
			 [toolbar setItems:newArray];
			 }
			 } else {
			 // Portrait mode
			 if ([[toolbar items] count] < 4) {
			 NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], answarButton, 
			 [[toolbar items] objectAtIndex:1], [[toolbar items] objectAtIndex:2], nil];
			 [toolbar setItems:newArray];	
			 }
			 
			 }
			 */
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
	UITextView *tempView;
	CGSize newSize;
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				//return 40.0;
				newSize = [[self.contentDictionary objectForKey:@"title"]
						   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]
						   constrainedToSize:CGSizeMake(700,99999)
						   lineBreakMode:UILineBreakModeWordWrap];
				if (newSize.height < 40.0f) {
					return 40.0;
				} else {
					return newSize.height + 10.0;// 10px margin
				}
				break;
			case 1:
				return 44.0;
				break;
			case 2:
				tempView = (UITextView *)[mainContentCell viewWithTag:777];
				[tempView setContentToHTMLString:[self.contentDictionary objectForKey:@"contents"]]; // hidden method
				newSize = tempView.contentSize;
				if ([[self.contentDictionary objectForKey:@"replycnt"] intValue] > 0) {	
					if (newSize.height + 30.0 < 410.0) {
						return 410.0;
					} else {
						return newSize.height + 30.0;// 30px margin
					}
				} else {
					//return 510.0;
					if (newSize.height + 30.0 < 410.0) {
						return 410.0;
					} else {
						return newSize.height + 30.0;// 30px margin
					}
				}
				
				break;
			case 3:
				return 25.0;
				break;
			default:
				/*
				 tempCell = [tableView cellForRowAtIndexPath:indexPath];
				 tempView = (UITextView *)[tempCell viewWithTag:22];
				 newSize = [tempView.text
				 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
				 constrainedToSize:CGSizeMake(320,99999)
				 lineBreakMode:UILineBreakModeWordWrap];
				 */
				return 0.0; //newSize.height + 60.0;
				break;
		}
	} else {
		if (indexPath.row == 0) {
			return 25.0;
		} else {
			
			NSDictionary *tempReply = [[self.contentDictionary objectForKey:@"sosdetailiteminfo"] objectAtIndex:(indexPath.row-1)];
			//CGRect tempFrame = answarLineCell.frame;
			//tempFrame.size.height = 10.0f;
			//tempView = [[UITextView alloc] initWithFrame:tempFrame];
			tempView = (UITextView *)[mainContentCell viewWithTag:777];
			//tempView.frame = tempFrame;
			[tempView setContentToHTMLString:[tempReply objectForKey:@"contents"]]; // hidden method
			/*
			 newSize = [[self.contentDictionary objectForKey:@"contents"]
			 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
			 constrainedToSize:CGSizeMake(320,99999)
			 lineBreakMode:UILineBreakModeWordWrap];
			 */
			newSize = tempView.contentSize;
			/*
			 newSize = [[tempReply objectForKey:@"contents"]
			 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]
			 constrainedToSize:CGSizeMake(320,99999)
			 lineBreakMode:UILineBreakModeWordWrap];
			 */
			return newSize.height + 90.0;// 65px for other labels & 25px margin
		}
	}
}

#pragma mark -
#pragma mark IBAction Supports

-(IBAction) mainButtonClicked {
	if (self.popoverController != nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
	/*
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// 버튼 입력시 화면 전환
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.5;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	/*
	 Selectable types :
	 types = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade}
	 subtypes = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom}
	 *
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromLeft;
	transition.delegate = self;
	
	[appdelegate.window.layer addAnimation:transition forKey:nil];
	
	// -- Push NoticeSplitViewController -- //
	//NoticeSplitViewController *temp = [[[NoticeSplitViewController alloc] init] autorelease];
	[self.splitViewController.view removeFromSuperview];
	appdelegate.window.rootViewController = (UIViewController *)appdelegate.viewController;
	*/
	
}

-(IBAction) answarButtonClicked {
	QnAWriteViewController *qnaWriteViewController = [[QnAWriteViewController alloc] initWithNibName:@"QnAWriteViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	qnaWriteViewController.modalPresentationStyle = UIModalPresentationFormSheet;//UIModalPresentationPageSheet;
	[self presentModalViewController:qnaWriteViewController animated:YES];
	qnaWriteViewController.titleNavigationBar.text = @"답변 작성";
	qnaWriteViewController.titleField.text = [(UILabel*)[titleCell viewWithTag:111] text];
	qnaWriteViewController.writeMode = 1;
	qnaWriteViewController.contentIndex = self.itemid;
	[qnaWriteViewController release];
	
}

-(IBAction) deleteButtonClicked {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"질문 삭제" message:@"해당 질문을 삭제하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 999;
	[alert show];	
	[alert release];
}

-(void) loadDetailContentAtIndex:(NSString *)index {
	
	//NSLog(@"pushed index : %d", index);
	[self.itemid release];
	self.itemid = index;
	[self.itemid retain];
	self.delegate_flag = NO_ACT;
	//Communication *
	
	if(self.clipboard != nil) {
		[self.clipboard cancelCommunication];
		self.clipboard.delegate = nil;
		self.clipboard = nil;
	}
	
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:self.itemid forKey:@"itemid"];
	//[requestDictionary setObject:@"200000079" forKey:@"userid"];
	//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
	//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getSOSDetail];
	//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
	
	if (!result) {
		// error occurred
		
	}
}

-(void) reloadDetailContent {
	self.delegate_flag = NO_ACT;
	//Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:self.itemid forKey:@"itemid"];
	//[requestDictionary setObject:@"200000079" forKey:@"userid"];
	//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
	//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getSOSDetail];
	//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
	
	if (!result) {
		// error occurred
		
	}
	
}

-(IBAction) selectDeleteButton:(id)sender {
	//NSLog(@"%d", [sender tag]);
	self.delete_id = [sender tag];
	self.delegate_flag = DELETE_ANSWER;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"답변 삭제" message:@"선택하신 답변을 삭제하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 888;
	[alert show];	
	[alert release];
	
	
}

-(IBAction) selectChooseButton:(id)sender {
	//NSLog(@"%d", [sender tag]);
	self.delegate_flag = CHOOSE_ANSWER;
	self.select_id = [sender tag];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"답변 채택" message:@"선택하신 답변을 채택하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 777;
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
	if(alertView.tag == 999) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			self.delegate_flag = DELETE_QUSETION;
			// start communicate with 
			//Communication *
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.itemid forKey:@"itemid"];
			//[requestDictionary setObject:@"200000079" forKey:@"userid"];
			//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
			//[requestDictionary setObject:[tempDefaults stringForKey:@"login_id"] forKey:@"userid"];
			//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteSOSQuestion];
			
			if (!result) {
				// error occurred
				
			}
			
		}
	} else if (alertView.tag == 888) { // if delete answer alert
		// delete answer confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			self.delegate_flag = DELETE_ANSWER;
			// start communicate with 
			if (self.delete_id == 0) {
				// error !!
			} else {
				//Communication *
				clipboard = [[Communication alloc] init];
				clipboard.delegate = self;
				
				// make request dictionary
				NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
				[requestDictionary setObject:self.itemid forKey:@"itemid"];
				[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.delete_id] forKey:@"answerid"];
				//[requestDictionary setObject:@"200000079" forKey:@"userid"];
				//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
				//[requestDictionary setObject:[tempDefaults stringForKey:@"login_id"] forKey:@"userid"];
				//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
				
				// call communicate method
				BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteSOSAnswer];
				
				if (!result) {
					// error occurred
					
				}
				self.delete_id = 0;
			}
		}	
	} else if (alertView.tag == 777) { // if  select answer alert
		// delete answer confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			self.delegate_flag = CHOOSE_ANSWER;
			// start communicate with 
			if (self.select_id == 0) {
				// error !!
			} else {
				clipboard = [[Communication alloc] init];
				clipboard.delegate = self;
				
				// make request dictionary
				NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
				[requestDictionary setObject:self.itemid forKey:@"itemid"];
				//[requestDictionary setObject:@"200000079" forKey:@"userid"];
				//[requestDictionary setObject:@"b11111111" forKey:@"userid"];
				[requestDictionary setObject:[NSString stringWithFormat:@"%d", select_id] forKey:@"aitemid"];
				
				// call communicate method
				BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_setSOSChoice];
				//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
				
				if (!result) {
					// error occurred
					
				}
				self.select_id = 0;
			}
			
		}
	} else if (alertView.tag == 7979) { // delete success!
		noti = [NSNotificationCenter defaultCenter];
		[noti postNotificationName:@"QnAListReload" object:self];
		//[self.view addSubview:self.imageView];
		self.imageView.hidden = NO;
		if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
			|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
			// Landscape mode
			NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
								 nil];
			[toolbar setItems:newArray];					
		} else {
			// Portrait mode					
			NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
								 [[toolbar items] objectAtIndex:1], nil];
			[toolbar setItems:newArray];						
		}
	}	
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType==UIWebViewNavigationTypeLinkClicked) {
		// null
		//NSLog(@"%@", request);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"mobilekate에서는 지원하지 않습니다. PC에서 이용해 주세요."
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		return NO;
		
	}
	return YES;
}


#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.contentTableView.hidden = YES;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	//NSLog(@"%@", rslt);
	
	if (rslt == nil) { // result of delete
		rslt = _resultDic;
		//NSLog(@"%@", rslt);
	} else {// result of contents
		// get value dictionary form result dictionary
		self.contentDictionary = nil;
		self.contentDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_resultDic objectForKey:@"sosdetailinfo"]];
		//NSLog(@"%@", self.contentDictionary);
	}
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	//self.contentDictionary = _resultDic;
	//NSDictionary *stockDictionary = (NSDictionary *)[_resultDic valueForKey:@"stockinfo"];
	
	// -- set label if success -- //
	if (resultNum == 0 && rslt!=nil) {
		//NSLog(@"%@", _dic);
		self.clipboard = nil;
		if (self.delegate_flag == DELETE_QUSETION) { // result of delete
			self.delegate_flag = NO_ACT;
			//[self.navigationController popViewControllerAnimated:YES];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 질문을 삭제 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			alert.tag = 7979;
			[alert show];	
			[alert release];
			
			//NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			//[noti postNotificationName:@"QnAListReload" object:self];
			//[self.view addSubview:self.imageView];
		} else if (self.delegate_flag == NO_ACT || self.delegate_flag == CHOOSE_ANSWER) {
			[self.contentTableView reloadData];
			self.contentTableView.hidden = NO;
			//[self.imageView removeFromSuperview];
			self.imageView.hidden = YES;
			// if same with user, change button to delete button
			if ([[self.contentDictionary objectForKey:@"deleteyn"] isEqualToString:@"true"]) {
				//self.navigationItem.rightBarButtonItem = self.deleteButton;
				// Add answar button if not added
				/*
				if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
					|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
					// Landscape mode
					if ([[toolbar items] count] < 3) {
						NSArray *newArray = [NSArray arrayWithObjects:deleteButton, [[toolbar items] objectAtIndex:0], 
											 [[toolbar items] objectAtIndex:1], nil];
						[toolbar setItems:newArray];
					} else {
						NSArray *newArray = [NSArray arrayWithObjects:deleteButton, [[toolbar items] objectAtIndex:1], 
											 [[toolbar items] objectAtIndex:2], nil];
						[toolbar setItems:newArray];
					}

				} else {
					// Portrait mode
					if ([[toolbar items] count] < 4) {
						NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], deleteButton, 
											 [[toolbar items] objectAtIndex:1], [[toolbar items] objectAtIndex:2], nil];
						[toolbar setItems:newArray];	
					} else {
						NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], deleteButton, 
											 [[toolbar items] objectAtIndex:2], [[toolbar items] objectAtIndex:3], nil];
						[toolbar setItems:newArray];
					}
					
				}*/
				if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
					|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
					// Landscape mode
					NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
										 deleteButton, nil];
					[toolbar setItems:newArray];					
				} else {
					// Portrait mode					
					NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
										 [[toolbar items] objectAtIndex:1], deleteButton, nil];
					[toolbar setItems:newArray];						
				}
			} else if ([[self.contentDictionary objectForKey:@"replyyn"] isEqualToString:@"true"]) {
				//self.navigationItem.rightBarButtonItem = self.answarButton;
				// Add answar button if not added
				if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
					|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
					// Landscape mode
					//if ([[toolbar items] count] < 2) {
						NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
											 answarButton, nil];
						[toolbar setItems:newArray];
					/*} else {
						NSArray *newArray = [NSArray arrayWithObjects:answarButton, [[toolbar items] objectAtIndex:1], 
											 [[toolbar items] objectAtIndex:2], nil];
						[toolbar setItems:newArray];
					}*/
				} else {
					// Portrait mode
					//if ([[toolbar items] count] < 3) {
						NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
											 [[toolbar items] objectAtIndex:1], answarButton, nil];
						[toolbar setItems:newArray];	
					/*} else {
						NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0],
											 [[toolbar items] objectAtIndex:1], answarButton, nil];
						[toolbar setItems:newArray];
					}*/
					
				}
			} else if ([[self.contentDictionary objectForKey:@"replyyn"] isEqualToString:@"false"] && [[self.contentDictionary objectForKey:@"deleteyn"] isEqualToString:@"false"])  {
				//self.navigationItem.rightBarButtonItem = nil;
				if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
					|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
					// Landscape mode
					NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
										 nil];
					[toolbar setItems:newArray];
				} else {
					// Portrait mode
					NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
										 [[toolbar items] objectAtIndex:1], nil];
					[toolbar setItems:newArray];	
				}
			}
		} else if (self.delegate_flag == DELETE_ANSWER || self.delegate_flag == INSERT_ANSWER) {
			self.delegate_flag = NO_ACT;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"선택하신 답변을 삭제하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			[noti postNotificationName:@"QnAListReload" object:self];
			[self loadDetailContentAtIndex:self.itemid];
		}  else {
			self.delegate_flag = NO_ACT;
			[self loadDetailContentAtIndex:self.itemid];
		} 
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

-(void) popForFirstAppear {
	
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

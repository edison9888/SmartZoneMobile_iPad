    //
//  FAQDetailViewController.m
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import "FAQDetailViewController.h"
#import "URL_Define.h"
#import "FAQWriteViewController.h"
#import "FAQListViewController.h"
#import "FAQCommentWriteViewController.h"
#import "FAQCommentViewController.h"

#import "CustomSubTabViewController.h"

#import "MobileKate2_0_iPadAppDelegate.h"
//#import <QuartzCore/QuartzCore.h>
#define MAXROW @"20"

@interface FAQDetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
//- (void)configureView;
@end

@implementation FAQDetailViewController

@synthesize toolbar;
@synthesize popoverController;
@synthesize clipboard;
@synthesize indicator;

@synthesize menuTabbarView;
@synthesize listView;
@synthesize subMenu;

@synthesize contentTableView;
@synthesize mainContentCell;
@synthesize titleCell;
@synthesize nameCell;
@synthesize answarLineCell;
@synthesize contentDictionary;
@synthesize resultDictionary;

@synthesize boardId;
@synthesize orderBy;
@synthesize sortBy;
@synthesize bullid;

@synthesize delegate_flag;
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
	////NSLog(@"%d", [self.view.subviews count]);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.clipboard = nil;
	
	/*
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	*/
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
	self.contentTableView.allowsSelection = NO;
	self.contentTableView.backgroundView = nil;
	
	self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	deleteBarButton.enabled = NO;
	//deleteBarButton.hidden = YES;
	
	[self createViewControllers];
	
	imageView.hidden = NO;
	
	noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(loadDetailContent) name:@"FAQDetailReload" object:nil];

}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"알고싶습니다";
    NSMutableArray *items = [[toolbar items] mutableCopy];
	if([items objectAtIndex:0] == barButtonItem){
		// do nothing
		////NSLog(@"%@, %@", [items objectAtIndex:0], barButtonItem);
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

- (void)viewWillDisappear:(BOOL)animated
{
	imageView.hidden = NO;
	// Call again when view appear to refresh the data
	[self.indicator stopAnimating];
	//[self.view addSubview:self.imageView];
	//self.imageView.hidden = NO;
	if (clipboard != nil) {
		[clipboard cancelCommunication];
		clipboard.delegate = nil;
		clipboard=nil;
	}	
	
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
		// Landscape mode
		//if ([[toolbar items] count] < 2) {
		NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], [[toolbar items] objectAtIndex:1], [[toolbar items] objectAtIndex:2], 
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
							 [[toolbar items] objectAtIndex:1], [[toolbar items] objectAtIndex:2], [[toolbar items] objectAtIndex:3], nil];
		[toolbar setItems:newArray];	
		/*
		 } else {
		 NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0],
		 [[toolbar items] objectAtIndex:1], answarButton, nil];
		 [toolbar setItems:newArray];
		 }*/
		
	}
	//self.contentDictionary = nil;
	//[self.contentTableView reloadData];
	
    [super viewWillDisappear:animated];
}


- (void)dealloc {
	[popoverController release];
	[toolbar release];

	[clipboard release];
	[indicator release];
	
	[menuTabbarView release];
	[listView release];
	[subMenu release];
	
	[contentTableView release];
	[mainContentCell release];
	[titleCell release];
	[nameCell release];
	[answarLineCell release];
	
	[contentDictionary release];
	[resultDictionary release];
	
	[boardId release];
	[orderBy release];
	[sortBy release];
	[bullid release];
	
    [super dealloc];
}

-(IBAction) mainButtonClicked {
	if (self.popoverController != nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
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

-(void) loadDetailContent {
	self.delegate_flag = NO_ACT;
	
	if(self.clipboard != nil) {
		[self.clipboard cancelCommunication];
		self.clipboard.delegate = nil;
		self.clipboard = nil;
	}
	
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:self.boardId forKey:@"boardid"];
	[requestDictionary setObject:self.orderBy forKey:@"orderby"];
	[requestDictionary setObject:self.sortBy forKey:@"sortby"];
	[requestDictionary setObject:@"1" forKey:@"cpage"];
	[requestDictionary setObject:MAXROW forKey:@"maxrow"];
	[requestDictionary setObject:bullid forKey:@"bullid"];
	//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQBullFromBoardEx];
	//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
	
	if (!result) {
		// error occurred
		
	}
}

-(void) loadDetailContentAtIndex:(NSString *)index {
	/*
	////NSLog(@"pushed index : %d", index);
	[self.itemid release];
	self.itemid = index;
	[self.itemid retain];
	
	//Communication *
	*/
	
	self.delegate_flag = NO_ACT;
	
	self.bullid = index;
	
	if(self.clipboard != nil) {
		[self.clipboard cancelCommunication];
		self.clipboard.delegate = nil;
		self.clipboard = nil;
	}
	
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:self.boardId forKey:@"boardid"];
	[requestDictionary setObject:self.orderBy forKey:@"orderby"];
	[requestDictionary setObject:self.sortBy forKey:@"sortby"];
	[requestDictionary setObject:@"1" forKey:@"cpage"];
	[requestDictionary setObject:MAXROW forKey:@"maxrow"];
	[requestDictionary setObject:index forKey:@"bullid"];
	//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getFAQBullFromBoardEx];
	//BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:@""];
	
	if (!result) {
		// error occurred
		
	}
	
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	
	//self.contentTableView.hidden = YES;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	self.resultDictionary = [NSDictionary dictionaryWithDictionary:_resultDic];
	//NSLog(@"%@", rslt);
	
	
	if (rslt == nil) { // result of delete
		//rslt = _resultDic;
		////NSLog(@"%@", rslt);
	} else {// result of contents
		// get value dictionary form result dictionary
		if (self.delegate_flag != CHECK_PASSWORD) {
			if ([[rslt objectForKey:@"code"] intValue] == 0) {
				self.contentDictionary = nil;
				self.contentDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_resultDic objectForKey:@"boarditeminfo"]];
				
				self.bullid = [self.contentDictionary objectForKey:@"bullid"];
			}
		}
		NSLog(@"%@", self.contentDictionary);
	}
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	//self.contentDictionary = _resultDic;
	//NSDictionary *stockDictionary = (NSDictionary *)[_resultDic valueForKey:@"stockinfo"];
	
	// -- set label if success -- //
	if (resultNum == 0 && rslt!=nil) {
		////NSLog(@"%@", _dic);
		//[self.contentTableView reloadData];
		//게시물 삭제 버튼 활성화 여부
		if ([[self.contentDictionary objectForKey:@"delyn"] isEqualToString:@"Y"]) {
			//self.navigationItem.rightBarButtonItem = deleteBarButton;
			deleteBarButton.enabled = YES;
		}
		
		
		self.clipboard = nil;
		if (self.delegate_flag == AGREE) { // result of delete
			self.delegate_flag = NO_ACT;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 게시물에 대한 찬성 처리를 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			alert.tag = 7979;
			[alert show];	
			[alert release];
		}else if (self.delegate_flag == DISAGREE) { // result of delete
			self.delegate_flag = NO_ACT;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 게시물에 대한 반대 처리를 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			alert.tag = 7979;
			[alert show];	
			[alert release];
		}else if (self.delegate_flag == NO_ACT) {// || self.delegate_flag == CHOOSE_ANSWER) {
			imageView.hidden = YES;
			[self.contentTableView reloadData];
		}else if (self.delegate_flag == DELETE_COMMENT) {
			self.delegate_flag = NO_ACT;
			// ====================================================================
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 댓글에 대한 삭제 처리를 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			alert.tag = 7979;
			[alert show];	
			[alert release];
			
			//[self.contentTableView reloadData];
			
		}else if (self.delegate_flag == DELETE_FAQ || self.delegate_flag == DELETE_REGISTRANT_FAQ) {
			self.delegate_flag = NO_ACT;
			// 화면 가리기
			imageView.hidden = NO;
			
			// 데이터 삭제 
			self.contentDictionary = nil;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"해당 게시물에 대한 삭제 처리를 완료하였습니다."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
			alert.tag = 8989;
			[alert show];	
			[alert release];
		}else if (self.delegate_flag == CHECK_PASSWORD) {
			self.delegate_flag = DELETE_REGISTRANT_FAQ;
			//isPassword = YES;
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.boardId forKey:@"boardid"];
			[requestDictionary setObject:bullid forKey:@"bullid"];
			[requestDictionary setObject:self.sortBy forKey:@"sortby"];
			[requestDictionary setObject:self.orderBy forKey:@"orderby"];
			//[requestDictionary setObject:self.boardName forKey:@"boardname"];	
			[requestDictionary setObject:@"1" forKey:@"cpage"];
			[requestDictionary setObject:@"20" forKey:@"maxrow"];
			[requestDictionary setObject:[self.contentDictionary objectForKey:@"password"] forKey:@"password"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBull];
			
			if (!result) {
				// error occurred
				
			}
		}
		/* else if (self.delegate_flag == DELETE_ANSWER || self.delegate_flag == INSERT_ANSWER) {
		 self.delegate_flag = NO_ACT;
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성공" message:@"선택하신 답변을 삭제하였습니다."
		 delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		 [alert show];	
		 [alert release];
		 [noti postNotificationName:@"QnAReloadSet" object:self];
		 [self loadDetailContentAtIndex:self.itemid];
		 } else {
		 self.delegate_flag = NO_ACT;
		 [self loadDetailContentAtIndex:self.itemid];
		 }  
		 */
	} else {
		// -- error handling -- //
		// Show alert view to user
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
		/*
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
				} else {
					// Portrait mode
					//if ([[toolbar items] count] < 3) {
					NSArray *newArray = [NSArray arrayWithObjects:[[toolbar items] objectAtIndex:0], 
										 [[toolbar items] objectAtIndex:1], answarButton, nil];
					[toolbar setItems:newArray];	
					
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
	} else {
		// -- error handling -- //
		// Show alert view to user
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}*/
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	// Alert network error message
	[self.indicator stopAnimating];
	
	////NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 접속에 실패하였습니다."
												   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	if (self.contentDictionary) {
		if ([[self.contentDictionary objectForKey:@"commentcnt"] intValue] > 0) {
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
			return [[self.contentDictionary objectForKey:@"commentcnt"] intValue] + 1;
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
			tempTitle.text = [self.contentDictionary objectForKey:@"bulltitle"];
			cell = titleCell;
		} else if (indexPath.row == 1) {
			UILabel *tempName = (UILabel *)[nameCell viewWithTag:222];
			//if ([[self.contentDictionary objectForKey:@"registrant"] isEqualToString:@""] || [self.contentDictionary objectForKey:@"registrant"] == nil) {
			if ([[self.contentDictionary objectForKey:@"incognitoflag"] isEqualToString:@"N"]) {
				tempName.text = [self.contentDictionary objectForKey:@"regname"];
			} else {
				tempName.text = [self.contentDictionary objectForKey:@"registrant"];
			}
			
			UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];
			// -- set date -- //
			tempDate.text = [self.contentDictionary objectForKey:@"regdate"];
			
			UILabel *tempYesno = (UILabel *)[nameCell viewWithTag:444];
			tempYesno.text = [NSString stringWithFormat:@"찬성 : %@ 반대 : %@", [self.contentDictionary objectForKey:@"voteyes"], [self.contentDictionary objectForKey:@"voteno"]];
			
			UILabel *tempCategory = (UILabel *)[nameCell viewWithTag:555];
			tempCategory.text = [self.contentDictionary objectForKey:@"categoryname"];
			
			UILabel *tempHitno = (UILabel *)[nameCell viewWithTag:666];
			tempHitno.text = [NSString stringWithFormat:@"조회수 : %@", [self.contentDictionary objectForKey:@"hitno"]];
			
			cell = nameCell;
		} else if (indexPath.row == 2) {			
			UITextView *tempView = (UITextView *)[mainContentCell viewWithTag:777];
			[tempView setContentToHTMLString:[self.contentDictionary objectForKey:@"content"]]; // hidden method
			//tempView.text = @"rotate test";
			
			//tempView.text = [self.contentDictionary objectForKey:@"content"];
			/*
			 UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
			 tempView.delegate = self;
			 ////NSLog([self.contentDictionary objectForKey:@"content"]);
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
				NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"FAQAnswarCell" owner:self options:nil];
				cell = [topObject objectAtIndex:0];
			}
			// get temp reply dictionary
			NSDictionary *tempReply = [[self.resultDictionary objectForKey:@"recommentlistinfo"] objectAtIndex:(indexPath.row-1)];
			
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
				tempDeleteCommentBtn.tag = indexPath.row - 1;
				tempDeleteCommentBtn.hidden = NO;
				[tempDeleteCommentBtn addTarget:self action:@selector(clickedDeleteComment:) forControlEvents:UIControlEventTouchUpInside];
			}
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
				newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
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
				[tempView setContentToHTMLString:[self.contentDictionary objectForKey:@"content"]]; // hidden method
				//tempView.text = [self.contentDictionary objectForKey:@"contents"];
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
			
			//NSDictionary *tempReply = [[self.contentDictionary objectForKey:@"sosdetailiteminfo"] objectAtIndex:(indexPath.row-1)];
			NSDictionary *tempReply = [[self.resultDictionary objectForKey:@"recommentlistinfo"] objectAtIndex:(indexPath.row-1)];
			/*
			CGRect tempFrame = answarLineCell.frame;
			tempFrame.size.height = 10.0f;
			tempView = [[UITextView alloc] initWithFrame:tempFrame];
			//tempView = (UITextView *)[mainContentCell viewWithTag:777];
			tempView.frame = tempFrame;
			//[tempView setContentToHTMLString:[tempReply objectForKey:@"contents"]]; // hidden method
			tempView.text = [tempReply objectForKey:@"contents"];
			*/
			 newSize = [[tempReply objectForKey:@"bullcomment"]
			 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
			 constrainedToSize:CGSizeMake(700,99999)
			 lineBreakMode:UILineBreakModeWordWrap];
			 
			//newSize = tempView.contentSize;
			/*
			 newSize = [[tempReply objectForKey:@"contents"]
			 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]
			 constrainedToSize:CGSizeMake(700,99999)
			 lineBreakMode:UILineBreakModeWordWrap];
			 */
			//[tempView release];
			return newSize.height + 70.0;// 65px for other labels & 25px margin
		}
	}
}

-(IBAction) yesButtonClicked {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"찬성" message:@"해당 게시물에 찬성하십니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 5551;
	self.delegate_flag = AGREE;
	[alert show];	
	[alert release];
}

-(IBAction) noButtonClicked {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"반대" message:@"해당 게시물에 반대하십니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 5552;
	self.delegate_flag = DISAGREE;
	[alert show];	
	[alert release];
}

-(IBAction) replyButtonClicked {
	FAQWriteViewController *faqWriteViewController = [[FAQWriteViewController alloc] initWithNibName:@"FAQWriteViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	faqWriteViewController.modalPresentationStyle = UIModalPresentationFormSheet;//UIModalPresentationPageSheet;
	[self presentModalViewController:faqWriteViewController animated:YES];
	faqWriteViewController.titleNavigationBar.text = @"답글 작성";
	faqWriteViewController.writeMode = 1;
	
	faqWriteViewController.boardId = self.boardId;
	faqWriteViewController.sortBy = self.sortBy;
	faqWriteViewController.orderBy = self.orderBy;
	faqWriteViewController.bullId = bullid;
	faqWriteViewController.depthBull = [self.contentDictionary objectForKey:@"depth"];
	faqWriteViewController.topBull = [self.contentDictionary objectForKey:@"bulltopid"];
	faqWriteViewController.categoryID = [self.contentDictionary objectForKey:@"categoryid"];
	faqWriteViewController.categoryLabel.text = [self.contentDictionary objectForKey:@"categoryname"];
	faqWriteViewController.categoryButton.enabled = NO;
	
	[faqWriteViewController release];
}

-(BOOL)checkPassword:(NSString *)password {
	self.delegate_flag = CHECK_PASSWORD;
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:self.boardId forKey:@"boardid"];
	[requestDictionary setObject:bullid forKey:@"bullid"];
	[requestDictionary setObject:password forKey:@"password"];
	
	// call communicate method
	return [clipboard callWithArray:requestDictionary serviceUrl:URL_checkPass];
}

- (IBAction)clickedDeleteComment:(id)sender {
	self.commentIndex = [sender tag];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 댓글을 삭제하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
	alert.tag = 5554;
	self.delegate_flag = DELETE_COMMENT;
	[alert show];	
	[alert release];
}

-(IBAction) commentButtonClicked {
	/*
	FAQCommentWriteViewController *faqCommentWriteViewController = [[FAQCommentWriteViewController alloc] initWithNibName:@"FAQCommentWriteViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	faqCommentWriteViewController.modalPresentationStyle = UIModalPresentationFormSheet;//UIModalPresentationPageSheet;
	[self presentModalViewController:faqCommentWriteViewController animated:YES];
	
	faqCommentWriteViewController.titleField.text = [self.contentDictionary objectForKey:@"bulltitle"];
	faqCommentWriteViewController.boardId = self.boardId;
	faqCommentWriteViewController.bullId = bullid;

	[faqCommentWriteViewController release];
	 */
	FAQCommentViewController *faqCommentViewController = [[FAQCommentViewController alloc] initWithNibName:@"FAQCommentViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	
	faqCommentViewController.modalPresentationStyle = UIModalPresentationPageSheet;//UIModalPresentationPageSheet;
	faqCommentViewController.boardId = self.boardId;
	faqCommentViewController.bullId = bullid;
	faqCommentViewController.commentArray = [self.resultDictionary objectForKey:@"recommentlistinfo"];
	
	[self presentModalViewController:faqCommentViewController animated:YES];
	
	//[faqCommentViewController.commentTableView reloadData];
	

	[faqCommentViewController release];
}

- (IBAction)clickedDeleteFaq {
	UIAlertView *alert;
	if ([[self.contentDictionary objectForKey:@"childflag"] isEqualToString:@"1"]) {
		alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 게시물은 하위 게시물이 존재하므로 삭제 불가합니다." 
										  delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	}else {
		alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"해당 게시물을 삭제하시겠습니까?" 
										  delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
		alert.tag = 5555;
		//////*************** 비실명 테스트를 위해 Y값으로 임시 변경 - 테스트 후 N으로 변경 필요
		if ([[self.contentDictionary objectForKey:@"registrant"] length] > 0) {
			self.delegate_flag = DELETE_REGISTRANT_FAQ;
			[alert addTextFieldWithValue:@"" label:@"비밀번호"];
			/*
			passwordTf =[alert textFieldAtIndex:0];
			passwordTf.delegate = self;
			passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
			passwordTf.keyboardType = UIKeyboardTypeNumberPad;
			passwordTf.keyboardAppearance = UIKeyboardAppearanceAlert;
			passwordTf.autocorrectionType = UITextAutocorrectionTypeNo;
			passwordTf.secureTextEntry =YES;
			 */
		}else {
			self.delegate_flag = DELETE_FAQ;
		}	
	}
	
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	// if delete qusetion alert
	if(alertView.tag == 5551) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.boardId forKey:@"boardid"];
			[requestDictionary setObject:bullid forKey:@"bullid"];
			[requestDictionary setObject:@"Y" forKey:@"votetype"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertBullVote];
			
			if (!result) {
				// error occurred
				
			}
			
		}
	}else if(alertView.tag == 5552) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.boardId forKey:@"boardid"];
			[requestDictionary setObject:bullid forKey:@"bullid"];
			[requestDictionary setObject:@"N" forKey:@"votetype"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_insertBullVote];
			
			if (!result) {
				// error occurred
				
			}
			
		}
	}else if(alertView.tag == 5554) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			clipboard = [[Communication alloc] init];
			clipboard.delegate = self;
			
			// make request dictionary
			NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[requestDictionary setObject:self.boardId forKey:@"boardid"];
			[requestDictionary setObject:bullid forKey:@"bullid"];
			[requestDictionary setObject:[[[self.resultDictionary objectForKey:@"recommentlistinfo"] objectAtIndex:(self.commentIndex)] objectForKey:@"commentid"]
								  forKey:@"commentid"];
			
			// call communicate method
			BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBullComment];
			
			if (!result) {
				// error occurred
				
			}
			
		}
	}else if(alertView.tag == 5555) {
		// delete confirm
		if(buttonIndex != [alertView cancelButtonIndex]) {
			if (self.delegate_flag == DELETE_REGISTRANT_FAQ) {
				self.delegate_flag = CHECK_PASSWORD;
				clipboard = [[Communication alloc] init];
				clipboard.delegate = self;
				
				// make request dictionary
				NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
				[requestDictionary setObject:self.boardId forKey:@"boardid"];
				[requestDictionary setObject:bullid forKey:@"bullid"];
				[requestDictionary setObject:[[alertView textFieldAtIndex:0] text] forKey:@"password"];
				//[requestDictionary setObject:passwordTf.text forKey:@"password"];
				
				// call communicate method
				BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_checkPass];
				if (!result) {
					// error occurred
					
				}
			}else {
				clipboard = [[Communication alloc] init];
				clipboard.delegate = self;
				
				// make request dictionary
				NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
				[requestDictionary setObject:self.boardId forKey:@"boardid"];
				[requestDictionary setObject:bullid forKey:@"bullid"];
				[requestDictionary setObject:self.sortBy forKey:@"sortby"];
				[requestDictionary setObject:self.orderBy forKey:@"orderby"];
				//[requestDictionary setObject:self.boardName forKey:@"boardname"];
				[requestDictionary setObject:@"1" forKey:@"cpage"];
				[requestDictionary setObject:@"20" forKey:@"maxrow"];
				
				// call communicate method
				BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBull];
				
				if (!result) {
					// error occurred
					
				}
			}
			
			/*
			 if (self.delegate_flag == DELETE_REGISTRANT_FAQ && [self checkPassword:passwordTf.text]) {
			 if(!isPassword) {
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"실패" message:@"비밀번호가 틀렸습니다. 다시 확인 후 입력하십시요." 
			 delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인" , nil];
			 alert.tag = 6661;
			 [alert show];
			 [alert release];
			 }
			 }
			 
			 if(self.delegate_flag == DELETE_FAQ || isPassword){
			 
			 clipboard = [[Communication alloc] init];
			 clipboard.delegate = self;
			 
			 // make request dictionary
			 NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
			 [requestDictionary setObject:self.boardId forKey:@"boardid"];
			 [requestDictionary setObject:self.bullId forKey:@"bullid"];
			 [requestDictionary setObject:self.sortBy forKey:@"sortby"];
			 [requestDictionary setObject:self.orderBy forKey:@"orderby"];
			 [requestDictionary setObject:self.boardName forKey:@"boardname"];
			 if (self.delegate_flag == DELETE_REGISTRANT_FAQ)
			 [requestDictionary setObject:[self.faqInfo objectForKey:@"password"] forKey:@"password"];
			 
			 // call communicate method
			 BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteBull];
			 
			 if (!result) {
			 // error occurred
			 
			 }
			 }
			 */
		}
	}else if (alertView.tag == 6661) { // 비밀번호 잘 못 입력 시 한번 더 입력
		[self clickedDeleteFaq];
	}else if (alertView.tag == 7979) { // reload current page
		//[self loadDetailContentAtIndex:bullid];
		[self.contentTableView reloadData];
		[listView loadData];
		
	}else if (alertView.tag == 8989) { // move previous page
		//[self.navigationController popViewControllerAnimated:YES];
		//noti = [NSNotificationCenter defaultCenter];
		//[noti postNotificationName:@"FAQListReload" object:self];
		[listView loadData];
	}
}

@end

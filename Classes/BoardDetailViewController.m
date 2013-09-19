//
//  NoticeDetailViewController.m
//  MKate_iPad
//
//  Created by park on 11. 2. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardDetailViewController.h"
#import "CustomSubTabViewController.h"
#import "AttachmentCustomCell.h"
#import "BoardAttachmentViewController.h"

#import "URL_Define.h"
/*
 #import "MobileKate2_0_iPadAppDelegate.h"
 #import <QuartzCore/QuartzCore.h>
 */

@interface BoardDetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
//- (void)configureView;
@end

@implementation BoardDetailViewController

@synthesize toolbar, popoverController;
@synthesize mainButton;
//@synthesize titleLabel;
//@synthesize nameLabel;
//@synthesize timeLabel;
//@synthesize contentWebView;
@synthesize imageView;
@synthesize contentTableView;
@synthesize contentDictionary;
@synthesize mainContentCell;
@synthesize titleCell;
@synthesize nameCell;
@synthesize clipboard;
@synthesize indicator;
@synthesize webViewHeight;
@synthesize webviewLoadFlag;
@synthesize menuTabbarView;
@synthesize subMenu;
@synthesize attachmentArray;

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
 }*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
	self.contentTableView.allowsSelection = NO;
	//self.contentWebView.delegate = self;
	self.contentDictionary = nil;
	self.clipboard = nil;
	self.webviewLoadFlag = 0;
	self.webViewHeight = 535.0f;
    
    self.attachmentArray = [[NSMutableArray alloc]initWithCapacity:0];
	
//	CGRect oldFrame = self.indicator.frame;
//	oldFrame.size.width = 30;
//	oldFrame.size.height = 30;
//	self.indicator.frame = oldFrame;
//	self.indicator.center = self.view.center;
	/*
     // add custom uibarbuttonitem
     UIImage *homeImage = [UIImage imageNamed:@"homeBtn.png"];
     UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     tempBtn.frame = CGRectMake(0, 0, homeImage.size.width, homeImage.size.height);
     [tempBtn setBackgroundImage:homeImage forState:UIControlStateNormal];
     tempBtn.titleLabel.text = @"홈";
     UIBarButtonItem *tmpBbtn = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
     tmpBbtn.title = @"홈";
     NSMutableArray *items = [[toolbar items] mutableCopy];
     [items insertObject:tmpBbtn atIndex:0];
     [toolbar setItems:items animated:YES];
     [items release];
     */
	//[self createViewControllers];
	self.subMenu = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
	[self.subMenu.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
	[self.menuTabbarView addSubview:self.subMenu.view];
	
	// [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.co.kr"]];
	/*
     self.subMenu = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
     
     CGRect tabbarRect = subMenu.view.frame;
     tabbarRect.origin.y = 500.0;
     self.subMenu.view.frame = tabbarRect;
     self.subMenu.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;//UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
     //[self.subMenu.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
     //self.subMenu.view.contentMode = UIViewContentModeBottom|UIViewContentModeLeft|UIViewContentModeRight;
     [self.view addSubview:self.subMenu.view];
     //self.subMenu.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
     //NSLog(@"%d", [self.view.subviews count]);
     */
	//subMenu = [[[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil] autorelease];
	//self.menuTabbarView = [[[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil] autorelease];
	//self.menuTabbarView = tempSubview.view;
	//CGRect *tempFrame = self.menuTabbarView.frame;
	
	//subMenu.view.frame = self.menuTabbarView.frame;
	//CGRect tempFrame = subMenu.view.frame;
	//[self.view addSubview:subMenu.view];
	//[self.menuTabbarView addSubview:tempSubview.view];
	//[self.view addSubview:tempSubview.view];
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
//	self.imageView.hidden = NO;

    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
	self.contentDictionary = nil;
//	[self resetContent];
	//[self.view addSubview:self.imageView];
//	self.imageView.hidden = NO;
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 if(self.popoverController != nil){
 [self.popoverController	 presentPopoverFromBarButtonItem:[[toolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
 }
 //[super viewDidAppear:animated];
 }
 */


/*
 
 - (void)configureView {
 // Update the user interface for the detail item.
 // detailDescriptionLabel.text = [detailItem description];   
 }
 */

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @" 게시판 ";
    NSMutableArray *items = [[toolbar items] mutableCopy];
	if([items objectAtIndex:0] == barButtonItem){
		// do nothing
		//NSLog(@"%@, %@", [items objectAtIndex:0], barButtonItem);
	} else {		
		[items insertObject:barButtonItem atIndex:0];
		[toolbar setItems:items animated:YES];
	}
    //[items insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:items animated:YES];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    CGPoint centerPoint = (UIInterfaceOrientationIsPortrait(self.splitViewController.interfaceOrientation) ?
//                           CGPointMake(384, 512) : CGPointMake(512, 384));
//
//    CGRect oldFrame = self.indicator.frame;
//    oldFrame.origin = centerPoint;
//    self.indicator.frame = oldFrame;
    
//    CGRect oldFrame = self.indicator.frame;
//    oldFrame.size.width = 30;
//    oldFrame.size.height = 30;
//    
//    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        oldFrame.origin = CGPointMake(330.0f, 300.0f); 
//        self.indicator.frame = oldFrame;
//    }
//    else {
//        CGRect oldFrame = self.indicator.frame;
//        oldFrame.size.width = 30;
//        oldFrame.size.height = 30;
//        self.indicator.frame = oldFrame;
//        self.indicator.center = self.view.center;
//    }
    
}

 - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//     CGRect oldFrame = self.indicator.frame;
//     oldFrame.size.width = 30;
//     oldFrame.size.height = 30;
//
//     if(fromInterfaceOrientation == UIInterfaceOrientationPortrait ||
//        fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        oldFrame.origin = CGPointMake(330.0f, 300.0f); 
//        self.indicator.frame = oldFrame;
//     }
//     else {
//         CGRect oldFrame = self.indicator.frame;
//         oldFrame.size.width = 30;
//         oldFrame.size.height = 30;
//         self.indicator.frame = oldFrame;
//         self.indicator.center = self.view.center;
//     }
//     
     
//     self.indicator.frame.origin = self.view.center;

     
// UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
// 
// UIView *scrollerView = [tempView.subviews objectAtIndex:0];
// if (scrollerView.subviews.count > 0)
// [scrollerView setZoomScale:1.0];
 
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
	[imageView release];
	[contentTableView release];
	[contentDictionary release];
	[mainContentCell release];
	[titleCell release];
	[nameCell release];
	[clipboard release];
	[indicator release];
	[menuTabbarView release];
	[subMenu release];
    [attachmentArray release];
    
    [super dealloc];
}

-(IBAction) mainButtonClicked {
	//added by kwbaek
	
	//[[self.splitViewController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
	
	if (self.popoverController != nil && [self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
	//[[self.view superview] removeFromSuperview];
	/*
	 MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	 
	 // 버튼 입력시 화면 전환
	 CATransition *transition = [CATransition animation];
	 // Animate over 3/4 of a second
	 transition.duration = 0.5;
	 // using the ease in/out timing function
	 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	 
	 
	 Selectable types :
	 types = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade}
	 subtypes = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom}
	 
	 
	 transition.type = kCATransitionPush;
	 transition.subtype = kCATransitionFromLeft;
	 transition.delegate = self;
	 
	 [appdelegate.window.layer addAnimation:transition forKey:nil];
	 
	 // -- Push NoticeSplitViewController -- //
	 //NoticeSplitViewController *temp = [[[NoticeSplitViewController alloc] init] autorelease];
	 [self.splitViewController.view removeFromSuperview];
	 appdelegate.window.rootViewController = (UIViewController *)appdelegate.mainController;
	 */
	
	
	
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.attachmentArray count]>0) {
        return section == 0 ? 3 : [self.attachmentArray count] ;
        
    }else{
        return section == 0 ? 3 : 0 ;
        
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";

	UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = titleCell;
        } else if (indexPath.row == 1) {
            cell = nameCell;
        } else if (indexPath.row == 2) {
            cell = mainContentCell;
        }
    }
    else if (indexPath.section == 1 ) {//첨부
        
        cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachmentCustomCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"AttachmentCustomCell")]) {
                    cell = oneObject;
                }
            }
        }
        //		NSLog(@"asdfasdfasdfasdfadsf%d",indexPath.row);
		AttachmentCustomCell *tmpCell = (AttachmentCustomCell *)cell;
		NSDictionary *dic_current = [self.attachmentArray objectAtIndex:indexPath.row];
        //        tmpCell.iconTitleLabel.text = nil;
        //        tmpCell.iconTitleLabel.text = [dic_current objectForKey:@"attachment_name"];
        UILabel *tempDate = (UILabel *)[tmpCell viewWithTag:111];//받은시간 4번셀
        tempDate.text = [dic_current objectForKey:@"title"];
        UILabel *tempSize = (UILabel *)[tmpCell viewWithTag:333];//받은시간 4번셀
        
        tempSize.text =  @"";
        UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
        btn_tmp.tag = indexPath.row;
        [btn_tmp addTarget:self action:@selector(action_paymentAttachFile:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = tmpCell;
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
	//UITextView *tempView;
	CGSize newSize;
	switch (indexPath.row) {
		case 0:
			//return 40.0;
			newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
					   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
					   constrainedToSize:CGSizeMake(700,99999)
					   lineBreakMode:UILineBreakModeWordWrap];
			if (newSize.height <= 40.0f) {
				return 40.0;
			} else {
				return newSize.height + 10.0;// 5px margin
			}
			
			//NSLog(@"%f", newSize.height);
			return newSize.height + 5.0;// 5px margin
			break;
		case 1:
			return 44.0;
			break;
		case 2:
			/*
			 //tempView = (UITextView *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:777];
			 tempView = (UIWebView *)[mainContentCell viewWithTag:777];
			 newSize = [tempView.text
			 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
			 constrainedToSize:CGSizeMake(320,99999)
			 lineBreakMode:UILineBreakModeWordWrap];
			 //NSLog(@"%f", newSize.height);
			 return newSize.height + 20.0;// 20px margin
			 */
			/*
             //NSLog(@"==============================");
             //			//NSLog(@"tableview height : %f", self.contentTableView.frame.size.height);
             //			//NSLog(@"saved webview height : %f", self.webViewHeight);
             UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
             //			//NSLog(@"real webview height : %f", tempView.frame.size.height);
             CGRect webRect = tempView.frame;
             webRect.size.height = self.webViewHeight;
             tempView.frame = webRect;
             //			//NSLog(@"fixed webview height : %f", tempView.frame.size.height);
             UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
             CGSize scrollRect = scrollerView.contentSize;
             //			//NSLog(@"scroll height : %f", scrollRect.height);
             scrollerView.contentSize = CGSizeMake(scrollRect.width, tempView.frame.size.height);
             //			//NSLog(@"scroll height after  : %f", scrollerView.contentSize.height);
             if (self.webViewHeight <= 535.0f) {
             return 535.0f;
             } else {
             return self.webViewHeight + 30.0f; // 30 px for padding
             }
			 */
            
            
			if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
				|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
				// Landscape mode
				return 505.0f;

			} else {
				// Portrait mode
				return 765.0f;
			}
			break;
		default:
			return 0.0;
			break;
	}
}

-(void) loadDetailContentAtIndex:(NSString *)index forCategory:(NSString *)category {
	//[self.imageView removeFromSuperview];
	//[self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	// get clipboard module
	//Communication *
    
    clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	self.webviewLoadFlag = 0;
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	//[requestDictionary setObject:@"KT" forKey:@"userid"];
	[requestDictionary setObject:category forKey:@"boardid"];
	[requestDictionary setObject:index forKey:@"attachid"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:getBoardDetail];
	
	if (!result) {
		// error occurred
		
	}
    
    //	if(self.clipboard != nil) {
    //		[self.clipboard cancelCommunication];
    //		self.clipboard.delegate = nil;
    //		self.clipboard = nil;
    //	}
    //	clipboard = [[Communication alloc] init];
    //	clipboard.delegate = self;
    //	self.webviewLoadFlag = 0;
    //	// make request dictionary
    //	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //	//[requestDictionary setObject:@"KT" forKey:@"userid"];
    //	[requestDictionary setObject:category forKey:@"boardid"];
    //	[requestDictionary setObject:index forKey:@"bullid"];
    //	
    //	// call communicate method
    //	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getBoardContent];
    //	
    //	if (!result) {
    //		// error occurred
    //		
    //	}
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.indicator stopAnimating];
	self.imageView.hidden = YES;
	[self.contentTableView reloadData];
	self.contentTableView.hidden = NO;
	/*
     if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
     || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
     // Landscape mode
     self.webViewHeight = 405.0f;
     } else {
     // Portrait mode
     self.webViewHeight = 605.0f;
     }
     //self.webViewHeight = 605.0f;
     int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
     if (self.webviewLoadFlag == 0) {
     self.webviewLoadFlag = 1;
     self.webViewHeight = scrollHeight;
     UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
     // reset webview's height
     CGRect currentFrame = tempView.frame;
     CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, scrollHeight);
     tempView.frame = newFrame;
     [self.contentTableView reloadData];
     self.contentTableView.hidden = NO;
     }
	 */
	//self.webViewHeight = scrollHeight;
	/*
	 //CGFloat 
	 self.webViewHeight = 535.0f;
	 if (webView.subviews.count > 0) {
	 UIView *scrollerView = [webView.subviews objectAtIndex:0];
	 if (scrollerView.subviews.count > 0) {
	 UIView *webDocView = scrollerView.subviews.lastObject;
	 if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]])
	 self.webViewHeight = webDocView.frame.size.height;
	 if (self.webviewLoadFlag == 0) {
	 self.webviewLoadFlag = 1;
	 [self.contentTableView reloadData];
	 }
	 }
	 }*/
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	// check link click and prevent navatationing
	if (navigationType==UIWebViewNavigationTypeLinkClicked) {
		// null
		//NSLog(@"%@", request);
		//NSLog(@"baseurl : %@", [request.URL baseURL]);
		//NSLog(@"absolutestring :  %@", [request.URL absoluteString]);
		//NSLog(@"abs url :  %@", [request.URL absoluteURL]);
		if ([[request.URL scheme] isEqualToString:@"mailto"]) {
			/*
			 //NSLog(@"can mail : %@", request.URL);
			 self.webopen = [NSURL URLWithString:[request.URL absoluteString]];
			 //NSLog(@"webopen : %@", self.webopen);
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"메일 앱을 엽니다."
			 delegate:self cancelButtonTitle:@"취소" otherButtonTitles: @"확인", nil];
			 alert.tag = 777;
			 [alert show];	
			 [alert release];
			 */
			[[UIApplication sharedApplication] openURL:request.URL];
			return NO;
			/*
             } else if ([[request.URL scheme] isEqualToString:@"tel"]) {
             
			 //NSLog(@"can call : %@", request.URL);
			 self.webopen = [NSURL URLWithString:[request.URL absoluteString]];
			 //NSLog(@"webopen : %@", self.webopen);
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"전화를 합니다."
			 delegate:self cancelButtonTitle:@"취소" otherButtonTitles: @"확인", nil];
			 alert.tag = 777;
			 [alert show];	
			 [alert release];
			 
             [[UIApplication sharedApplication] openURL:request.URL];
             return NO;*/
		} else if ([[request.URL scheme] isEqualToString:@"http"] || [[request.URL scheme] isEqualToString:@"https"]) {
			/*
			 //NSLog(@"can open : %@", request.URL);
			 webopen = request.URL;
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"메일 앱을 엽니다."
			 delegate:self cancelButtonTitle:@"취소" otherButtonTitles: @"확인", nil];
			 alert.tag = 777;
			 [alert show];	
			 [alert release];
			 */
			[[UIApplication sharedApplication] openURL:request.URL];
			return NO;
		} else {
			
			//NSURLRequest *telReq = [NSURLRequest requestWithURL:[]
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"mobilekate에서는 지원하지 않습니다. PC에서 이용해 주세요."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			return NO;
		}
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
	
    self.contentTableView.userInteractionEnabled = YES;
    self.contentTableView.hidden = NO;
    
	[self.indicator stopAnimating];
    
	//[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	////NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
    
	// -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
		
        self.contentDictionary = nil;
        self.contentDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_resultDic objectForKey:@"BoardDetail"]];
        
        //[self.contentTableView reloadData];
        
        
        UILabel *tempTitle = (UILabel *)[titleCell viewWithTag:111];
        tempTitle.text = [self.contentDictionary objectForKey:@"title"];
        
        UILabel *tempName = (UILabel *)[nameCell viewWithTag:222];
        tempName.text = [self.contentDictionary objectForKey:@"author"];
        
        UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];
        tempDate.text = [self.contentDictionary objectForKey:@"createdtime"];
        
        UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
        // reset webview's height
//        CGRect currentFrame = tempView.frame;
//        CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, 750);
//        tempView.frame = newFrame;
//        
//        if (tempView.subviews.count > 0) {
//            UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
//            scrollerView.contentSize = CGSizeMake(320, 354);
//            //CGSize scrollFrame = scrollerView.contentSize;
//            
//        }
        [self.attachmentArray removeAllObjects];
        self.attachmentArray = (NSMutableArray *)[_resultDic objectForKey:@"urlList"];
//        NSLog(@"%@",self.contentDictionary);
//        NSLog(@"%@",self.attachmentArray);

        NSMutableString *attachmentString = [[NSMutableString alloc]init];
        //              [attachmentString appendFormat:@"document.body.style.zoom = 3.5"];
        
        [attachmentString appendFormat:@"\n%@", [self.contentDictionary objectForKey:@"body"]];
        NSLog(@"%@", [self.contentDictionary objectForKey:@"body"]);
        [attachmentString appendFormat:@"<br>"];
        [attachmentString appendFormat:@"<meta name='viewport' content='user-scalable=yes, initial-scale=0.8'/>"];
        
        
        [tempView loadHTMLString:attachmentString baseURL:nil];//웹뷰에 뿌려줌
        attachmentString = nil;
        [attachmentString release];
        
        
        tempView.delegate = self;
        self.clipboard = nil;
        
	} else {
		// -- error handling -- //
		// Show alert view to user
		[self.indicator stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];	
		[alert release];
        
	}
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator stopAnimating];
	// Alert network error message
	//NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 접속에 실패하였습니다."
												   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	/*
	 // test for non comm
	 NSMutableDictionary *tempNoticeDictionary = [[NSMutableDictionary alloc] init];
	 [tempNoticeDictionary setObject:@"공지사항 제목" forKey:@"title"];
	 [tempNoticeDictionary setObject:@"작성자" forKey:@"writer"];
	 [tempNoticeDictionary setObject:@"2011.02.14" forKey:@"date"];
	 [tempNoticeDictionary setObject:@"<HTML><BODY>공지사항 본문(HTML string)</BODY></HTML>" forKey:@"content"];
	 
	 self.contentDictionary = tempNoticeDictionary;
	 
	 [self.contentTableView reloadData];
	 */
}

/*
 -(void) loadDetailContentAtIndex:(NSInteger)index {
 
 //NSLog(@"pushed index : %d", index);
 [self.imageView removeFromSuperview];
 self.titleLabel.text = [NSString stringWithFormat:@"%d", index];
 
 // -- contentView test -- //
 //self.contentWebView.
 NSURL *url = [[NSURL alloc] initWithString:@"http://www.naver.com"];
 NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
 
 self.contentWebView.multipleTouchEnabled = YES;
 //self.contentWebView.delegate = self;
 [self.contentWebView loadRequest:urlRequest];
 }
 */

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

/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 
 // if URL open alert
 if(alertView.tag == 777) {
 // open if confirm clicked
 if(buttonIndex != [alertView cancelButtonIndex]) {
 //NSLog(@"open :  %@", self.webopen);
 [[UIApplication sharedApplication] openURL:self.webopen];
 }
 }
 }
 
 */

-(void)resetContent {
	UILabel *tempTitle = (UILabel *)[titleCell viewWithTag:111];
	tempTitle.text = @"";	
	UILabel *tempName = (UILabel *)[nameCell viewWithTag:222];
	tempName.text = @"";
	UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];
	tempDate.text = @"";
	UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
	[tempView loadHTMLString:@"<HTML><BODY></BODY></HTML>" baseURL:nil];
}

-(void)action_paymentAttachFile:(id)sender {
	UIButton *btn_tmp = (UIButton *)sender;
	int index = btn_tmp.tag;
	
    //	self.dic_docattachlistinfo = [[NSMutableDictionary alloc] init];
    //    
    //	NSDictionary *dic_tmp = [arr_docattachlistinfo objectAtIndex:index];
    //	
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"docid"] forKey:@"docid"];
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"attachdocurl"] forKey:@"href"];
    
    //	[self action_paymentOriginalPdfCell];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = NSLocalizedString(@"btn_back", @"뒤로");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];	
    
    
    NSDictionary *dic_current = [self.attachmentArray objectAtIndex:index];
    NSString *tempUrl = [dic_current objectForKey:@"url"];
    NSString *tempTitle = [dic_current objectForKey:@"title"];
    
    BoardAttachmentViewController *boardAttachmentViewController = [[BoardAttachmentViewController alloc] initWithNibName:@"BoardAttachmentViewController" bundle:nil];
    boardAttachmentViewController.title = self.title;
    //    
    //    // Pass the selected object to the new view controller.
    [self presentModalViewController:boardAttachmentViewController animated:YES];

//    [self.navigationController pushViewController:boardAttachmentViewController animated:YES];
    //    
    [boardAttachmentViewController boardAttachemntlink:tempUrl attachmentTitle:tempTitle];
    
    //    
    [boardAttachmentViewController release];
    
}


@end

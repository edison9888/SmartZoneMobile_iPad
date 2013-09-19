//
//  eisWebViewController.m
//  MobileKate2.0_iPad
//
//  Created by Baek Kyung Wook on 11. 11. 29..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "eisWebViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation eisWebViewController
@synthesize contentWebView ;
@synthesize indicator;
@synthesize contentFrameView;
@synthesize hiddenButton;



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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.contentWebView.delegate = self;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)returnHomeAction {
    //[self.contentWebView stopLoading];
	[contentWebView removeFromSuperview];
	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
} 

-(IBAction)backForwardButtonClicked:(id)sender {
	
	//NSLog(@"%d", [sender selectedSegmentIndex]);
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[self.contentWebView goBack];
			break;
		case 1:
			[self.contentWebView goForward];
			break;			
		default:
			break;
	}
}
-(IBAction)menuAction{
//     [ contentWebView stringByEvaluatingJavaScriptFromString:@"document.location.toggleMenu" ];
    [ contentWebView stringByEvaluatingJavaScriptFromString:@"toggleMenu()" ];

}
-(IBAction) candyHomeButton:(id)sender {
	//NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	//[userDefault objectForKey:@"URL_CANDY"]
	Clipboard *clip = [Clipboard sharedClipboard];
	NSURL *url = [[NSURL alloc] initWithString:[clip clipKey:@"WEB_LINK_URL"]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
	
	[self.contentWebView loadRequest:urlRequest];
    [urlRequest release]; 
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
	/*
     //NSLog(@"Memory warning!!");
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"메모리가 부족하여 프로그램을 종료합니다. 다른 앱들을 완전 종료 후 다시 실행해주세요."
     delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
     alert.tag = 998877;
     [alert show];	
     [alert release];
	 */
	
}
/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if(alertView.tag == 998877) {
 [[UIApplication sharedApplication] terminateWithSuccess];
 }
 }	
 */

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	Clipboard *clip = [Clipboard sharedClipboard];
	NSString *webTitle = [clip clipKey:@"WEB_LINK_NAME"];
	
	self.title = webTitle;
	toolBarTitle.text = webTitle;
	toolBarTitle.textAlignment = UITextAlignmentCenter;
	toolBarTitle.textColor = [UIColor whiteColor];
	
    
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 [UIImage imageNamed:@"left.png"],
											 [UIImage imageNamed:@"right.png"],
											 nil]];
	
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	[segmentedControl addTarget:self action:@selector(backForwardButtonClicked:) forControlEvents:UIControlEventValueChanged];
	
	temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"홈" style:UIBarButtonItemStyleBordered target:self action:@selector(returnHomeAction)];
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 메 뉴 " style:UIBarButtonItemStyleBordered target:self action:@selector(menuAction)];
    arr_segTmp = nil;
	
	self.hiddenButton.hidden = YES;
	if ([webTitle isEqualToString:@"올레터"]) {
		self.hiddenButton.hidden = NO;
	}
	
	//--- m-learning 은 segmentation 없앤다.
	if ([webTitle isEqualToString:@"m-Learning"]) {
		
		arr_segTmp = [NSArray arrayWithObjects:temporaryBarButtonItem, nil];	
	}
	else {
		segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
		[segmentedControl release];
		arr_segTmp = [NSArray arrayWithObjects:menuBarButtonItem, temporaryBarButtonItem, flexible, segmentBarItem, nil];
	}
	
//	[temporaryBarButtonItem release];
	
	[mToolbar setItems:arr_segTmp];
	/*
     CGRect webFrame = [[UIScreen mainScreen] bounds];
     webFrame.origin.y = 44;
     webFrame.size.height -= 200;
	 */
	//self.contentWebView = [[UIWebView alloc] init];
	self.contentWebView.multipleTouchEnabled = YES;
	self.contentWebView.delegate = self;
	self.contentWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
//	self.contentWebView.scalesPageToFit = YES;
	
	
	NSURL *url = [[NSURL alloc] initWithString:[clip clipKey:@"WEB_LINK_URL"]];
    //	NSURL *url = [[NSURL alloc] initWithString:@"http://www.naver.com"];
    //	NSURL *url = [[NSURL alloc] initWithString:@"http://gwdev.asgkorea.co.kr:8085/3/imain.asp?emp_no=sabun&ctn=telno"];
	//	NSURL *url = [[NSURL alloc] initWithString:[userDefault objectForKey:@"URL_BPM"]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
	
	[self.contentWebView loadRequest:urlRequest];
    [urlRequest release]; 
	
	
	
	
}
- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration { 
    //	MainMenuController *mainController = [[MainMenuController alloc] init];
    
    //	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
    //	CATransition *myTransition = [CATransition animation];
    arr_segTmp = nil;

    switch (self.interfaceOrientation) {

		case UIDeviceOrientationPortrait :
            NSLog(@"asdf");
            arr_segTmp = [NSArray arrayWithObjects:menuBarButtonItem, temporaryBarButtonItem, flexible, segmentBarItem, nil];
			break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"asdf");
            arr_segTmp = [NSArray arrayWithObjects:menuBarButtonItem, temporaryBarButtonItem, flexible, segmentBarItem, nil];

			break;
		case UIDeviceOrientationLandscapeLeft:
            NSLog(@"asdf");
            arr_segTmp = [NSArray arrayWithObjects: temporaryBarButtonItem, flexible, segmentBarItem, nil];

			break;

		case UIDeviceOrientationLandscapeRight:
            NSLog(@"asdf");
            arr_segTmp = [NSArray arrayWithObjects: temporaryBarButtonItem, flexible, segmentBarItem, nil];

			break;
			
	}
    [mToolbar setItems:arr_segTmp];


}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
    
	self.indicator.hidden = YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [indicator startAnimating];
	[self.view bringSubviewToFront:self.indicator];
    
	self.indicator.hidden = NO;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[self.contentWebView stopLoading];
    
    [indicator stopAnimating];
	self.indicator.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
	[self.indicator stopAnimating];
    //[self.contentWebView stopLoading];
	
    
	for (UIView *subview in self.view.subviews) {
		if ([subview isKindOfClass:[UIWebView class]]) 
			[subview removeFromSuperview];
		
	}
	NSArray * sarView = [self.view subviews];
	
	
	for (int i=0; i<[sarView count]; i++) {
        //NSLog(@"서브 뷰의 종료 : %@", [sarView objectAtIndex:i]);
		
	}
	
}
- (void)viewWillDisappear:(BOOL)animated {
	
	self.contentWebView = nil;
	//[self.contentWebView cle];
	//[self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    
    
    
    //	[self.contentWebView removeFromSuperview];
    //	self.contentWebView = nil;
    
    
    //	[self.contentWebView reload];
    //contentWebView = nil;
    //[contentWebView release];
	/*
     [self.menuTabbarView removeFromSuperview];
     
     
     for (UIView *ssubview in self.view.subviews) {
     if ([ssubview isKindOfClass:[contentWebView class]]) 
     [ssubview removeFromSuperview];
     
     }
     */
    
}

- (void)dealloc {
	[contentWebView release];
	[contentFrameView release];
	[hiddenButton release];
	//[3 release];
    [super dealloc];
    
}


@end

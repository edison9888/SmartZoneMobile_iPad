//
//  CalendarToolBarViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarToolBarViewController.h"


@implementation CalendarToolBarViewController

@synthesize displayTypeSegmentedControl;
@synthesize footer;
@synthesize buttonEnable;
#pragma mark -
#pragma mark Callback Method

- (void)backButtonDidPush:(id)sender {
//	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@".NetTree's message" 
//														 message:@"CalendarToolBarViewController의 backButtonDidPush함수에 홈으로 이동하는 코드 넣으시면 되여..." 
//													   delegate:nil 
//											  cancelButtonTitle:@"확인" 
//											   otherButtonTitles:nil] autorelease];
//	[alertView show];
    [model resetModel];
    model.selectedDate = nil;
    [super removeInNavigationStack:@"CalendarWeekViewController"];
    [super removeInNavigationStack:@"CalendarDayViewController"];
    [super removeInNavigationStack:@"CalendarListViewController"];
    [super removeInNavigationStack:@"CalendarMainViewController"];
    [super removeInNavigationStack:@"CalendarToolBarViewController"];
    //NSLog(@"backbutton go home");
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ([[userDefault objectForKey:@"MainViewSetting"]isEqualToString:@"1"]) {
//        [super popToViewControllerInFlow:@"MainMenuControl" animated:YES];
//    }else {
//        [super popToViewControllerInFlow:@"MainListController" animated:YES];
//    }
}

- (void)homeButtonDidPush {
    //NSLog(@"go home");
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ([[userDefault objectForKey:@"MainViewSetting"]isEqualToString:@"1"]) {
//        [super popToViewControllerInFlow:@"MainMenuControl" animated:YES];
//    }else {
//        [super popToViewControllerInFlow:@"MainListController" animated:YES];
//    }
}

#pragma mark -
#pragma mark Footer Action Method

// 맴버 버튼이 눌린 경우
- (IBAction)memberButtonDidPush:(id)sender {
	
	model.selectedDisplayType = -1;
	
	Class targetClass = NSClassFromString(@"CalendarMemberViewController");
	
	id viewController = [[targetClass alloc] initWithNibName:@"CalendarMemberViewController" bundle:nil]; 

	UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewController];

	[self.navigationController presentModalViewController:navBar animated:YES];
	[navBar release];
	navBar = nil;
	[viewController release];
	viewController = nil;

}

- (IBAction)todayButtonDidPush:(id)sender {
	
	// 각 화면에 따라 오늘버튼의 액션이 다르므로 각 화면에서 재구현해줘야 한다.
	//NSLog(@"go today");
        
}

- (IBAction)typeSegmentedDidSelect:(id)sender {
    if (buttonEnable == YES) {
        UISegmentedControl *segmented = (UISegmentedControl *)sender;
        
        NSLog(@"segmented.selectedSegmentIndex %d", segmented.selectedSegmentIndex);
        
        model.selectedDisplayType = segmented.selectedSegmentIndex;
        
        switch (segmented.selectedSegmentIndex) {
            case 0:	// 월
                [super popOrPushViewController:@"CalendarMainViewController" animated:NO];
                break;
            case 1:	// 주
                [super popOrPushViewController:@"CalendarWeekViewController" animated:NO];
                break;
            case 2:	// 일
                [super popOrPushViewController:@"CalendarDayViewController" animated:NO];
                break;
            case 3:	// 목록
                [super popOrPushViewController:@"CalendarListViewController" animated:NO];
                break;
            default:
                break;
        }

    }

}

#pragma mark -
#pragma mark XCode Generated

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

	model = [CalendarModel sharedInstance];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	self.footer.tintColor = [UIColor darkGrayColor];
	buttonEnable = YES;
    //	일단 네비게이션은 차후에 확인하자.
    isRetinaDrawing = YES;
	// 왼쪽버튼 홈버튼 생성
//	[super makeNavigationLeftBarButtonWithImageNamePrefix:@"btn_home" 
//										   selectedString:@"on" 
//										 unselectedString:@"" 
//										  extensionString:@"png"];
//    [super makeNavigationLeftBarButtonWithImageNamePrefix:@"btn_home_black" 
//										   selectedString:@"on" 
//										 unselectedString:@"" 
//										  extensionString:@"png"];
    
    
    
    
    
    UIImage *imageNormal	= [UIImage imageNamed:@"btn_home_black.png"];
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 45 , 28);
	button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	[button setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"btn_home", @"홈")] forState:UIControlStateNormal];
    
	[button setBackgroundImage:imageNormal	  forState:UIControlStateNormal];
	
	[button addTarget:self action:@selector(backButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	backButton = nil;

    
    
    

	isRetinaDrawing = NO;


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
	self.displayTypeSegmentedControl = nil;
	self.footer = nil;
}


- (void)dealloc {
	
	[displayTypeSegmentedControl release];
	[footer release];
	
    [super dealloc];
}


@end

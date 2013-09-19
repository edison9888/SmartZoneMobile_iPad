//
//  OrgNaviSpliviewController.m
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import "OrgNaviSpliviewController.h"
#import "OrgNaviInfo.h"
#import "OrgNaviDetailView.h"

@implementation OrgNaviSpliviewController

@synthesize rootViewNavi;
@synthesize detailViewNavi;

	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

		//NoticeRootViewController *
	rootViewNavi = [[OrgNaviInfo alloc] initWithNibName:@"OrgNaviInfo" bundle:nil];
		//NoticeDetailViewController *
	detailViewNavi = [[OrgNaviDetailView alloc] initWithNibName:@"OrgNaviDetailView" bundle:nil];
	UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:rootViewNavi];
	UINavigationController *detail = [[UINavigationController alloc] initWithRootViewController:detailViewNavi];
    detail.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.viewControllers = [NSArray arrayWithObjects:root, detail, nil];
	self.delegate = detailViewNavi;
	
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

- (void)viewWillAppear:(BOOL)animated {

//	[rootView.navigationController popToRootViewControllerAnimated:NO];
//	rootView.menuList=nil;
//	[rootView.dataTable reloadData];
//	[rootView loadData];
	[super viewWillAppear:animated];
	rootViewNavi.menuList = nil;
    
   
	[rootViewNavi loadDetailContentAtIndex:@"" forOrgcd:@""];
    rootViewNavi.isMyDivision = YES;

}
//
//- (void)viewDidAppear:(BOOL)animated {
// [detailView popForFirstAppear];
// [super viewDidAppear:animated];
//}
//
-(void)viewWillDisappear:(BOOL)animated{
//	[rootViewNavi.navigationController popToRootViewControllerAnimated:NO];

}
- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
	
}


	// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
}



- (void)dealloc {
	
	[rootViewNavi release];
	[detailViewNavi release];
	
    [super dealloc];
}


@end

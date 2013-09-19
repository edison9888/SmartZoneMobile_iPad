//
//  PaymentSplitViewController.m
//  MobileKate2.0_iPad
//
//  Created by 김일호 on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "PaymentSplitViewController.h"

@implementation PaymentSplitViewController
@synthesize rootView, detailView;

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
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.rootView = [[[PaymentController alloc] initWithNibName:@"PaymentController" bundle:nil] autorelease];
	self.detailView = [[[ConfirmController alloc] initWithNibName:@"ConfirmController" bundle:nil] autorelease];
//	ConfirmController *detail = [[[ConfirmController alloc] initWithNibName:@"ConfirmController" bundle:nil] autorelease];
	UINavigationController *root = [[[UINavigationController alloc] initWithRootViewController:rootView] autorelease];
	root.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	self.viewControllers = [NSArray arrayWithObjects:root, detailView, nil];
	self.delegate = detailView;
	
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

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
	
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
}



- (void)dealloc {
    [super dealloc];
}


@end
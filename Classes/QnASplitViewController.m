    //
//  QnASplitViewController.m
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QnASplitViewController.h"

#import "QnARootViewController.h"
#import "QnADetailViewController.h"

@implementation QnASplitViewController

@synthesize detailView;

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
	
	//QnARootViewController *
	rootView = [[[QnARootViewController alloc] initWithNibName:@"QnARootViewController" bundle:nil] autorelease];
	//QnADetailViewController *
	detailView = [[[QnADetailViewController alloc] initWithNibName:@"QnADetailViewController" bundle:nil] autorelease];
	UINavigationController *root = [[[UINavigationController alloc] initWithRootViewController:rootView] autorelease];
	
	self.viewControllers = [NSArray arrayWithObjects:root, detailView, nil];
	self.delegate = detailView;
	
}

- (void)viewWillAppear:(BOOL)animated {
	rootView.menuList = nil;
	[rootView.tableList reloadData];
	[rootView loadData];
	[super viewWillAppear:animated];
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
	[rootView release];
	[detailView release];
    [super dealloc];
}


@end

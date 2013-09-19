//
//  FAQRootViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface FAQRootViewController : UIViewController<CommunicationDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *dataTable;
	NSMutableArray *menuList;
	IBOutlet UIActivityIndicatorView *indicator;
	Communication *clipboard;
}

@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

-(void) loadData;

@end

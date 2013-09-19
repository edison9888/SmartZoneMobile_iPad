//
//  MailController.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 19..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailListController.h"
#import "Communication.h"
#import "URL_Define.h"

@interface MailController :  UIViewController<UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *currentTableView;
	
	UIActivityIndicatorView *indicator;
	
	Communication *cm;
	
	NSMutableArray *menuList;
	
	UIBarButtonItem *refreshButton;

}
-(void)tr_data;
-(IBAction)refresh;
-(IBAction) writeButtonClicked;

@property (nonatomic, retain) IBOutlet UITableView *currentTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) NSMutableArray *menuList;


@end





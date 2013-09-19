//
//  BoardDetailListController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

#define MAXROW @"20"

@class NoticeDetailViewController;

@interface BoardDetailListController : UIViewController<CommunicationDelegate, UITableViewDelegate, UITableViewDataSource>  {
    
	UITableView *dataTable;
	UIActivityIndicatorView *indicator;
	NSMutableArray *boardList;
	NSString *categoryCode;
	UITableViewCell *nextCell;
	
	int currentPage;
	Communication *clipboard;
	
	BOOL morePageFlag;
	IBOutlet UIButton *nextButton;
    NSMutableDictionary *resultDictionary;
    
    NoticeDetailViewController *detailViewController;
}
@property (nonatomic, retain) NoticeDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableArray *boardList;
@property (nonatomic, retain) NSString *categoryCode;
@property (nonatomic, retain) IBOutlet UITableViewCell *nextCell;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, assign) BOOL morePageFlag;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) NSMutableDictionary *resultDictionary;
-(IBAction) nextCellClicked;

@end

//
//  CalendarDayScheduleListViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 19..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"


@interface CalendarDayScheduleListViewController : TFUIViewController {

	// UI
	UITableView *tableView1;
	
	// data
	NSMutableArray *datasource;
	
    CalendarModel *model;
    
}

// UI
@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@end

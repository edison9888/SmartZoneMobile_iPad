//
//  CalendarScheduleRegisterRepeatViewController.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다. on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"

@interface CalendarScheduleRegisterRepeatViewController : TFUIViewController {

	// UI
	UITableView *tableView1;
	
	// data
	CalendarModel *model;
	NSArray *datasource;
	
}

// UI
@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@end

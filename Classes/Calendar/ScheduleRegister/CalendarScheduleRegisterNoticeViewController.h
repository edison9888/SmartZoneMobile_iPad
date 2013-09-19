//
//  CalendarScheduleRegisterNoticelViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"


@interface CalendarScheduleRegisterNoticeViewController : TFUIViewController {

	// UI
	UITableView *tableView1;
	
	// data
	CalendarModel *model;
	NSArray *datasource;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@end

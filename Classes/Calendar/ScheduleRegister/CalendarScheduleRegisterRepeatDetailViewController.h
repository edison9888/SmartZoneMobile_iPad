//
//  CalendarScheduleRegisterRepeatDetailViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"


@interface CalendarScheduleRegisterRepeatDetailViewController : TFUIViewController {

	// UI
	UITableView  *tableView1;
	UIDatePicker *datePicker1;
	
	// handling
	int selectedIndex;
	
	// data
	CalendarModel *model;
	NSMutableArray *datasource;
	
}

@property (nonatomic, retain) IBOutlet UITableView  *tableView1;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker1;

- (IBAction)datePicker1ValueChanged:(id)sender;

@end

//
//  CalendarScheduleRegisterTimeViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"

@interface CalendarScheduleRegisterTimeViewController : TFUIViewController {
	// UI
	UITableView *tableView1;
	UIDatePicker *datePicker1;
	UISwitch *switch1;
	
	// handling
	int selectedIndex;	// 선택된 인덱스
	NSDate *startDate;
	NSTimeInterval endDateTimeInterval;

	
	// data
	CalendarModel *model;
	
}

@property (nonatomic, retain) IBOutlet UITableView  *tableView1;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker1;
@property (nonatomic, retain) IBOutlet UISwitch *switch1;

- (IBAction)switch1ValueChaned:(id)sender;
- (IBAction)datePicker1ValueChanged:(id)sender;

@end

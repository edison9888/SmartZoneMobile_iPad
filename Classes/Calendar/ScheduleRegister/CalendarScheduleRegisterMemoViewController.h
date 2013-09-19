//
//  CalendarScheduleRegisterMemoViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"


@interface CalendarScheduleRegisterMemoViewController : TFUIViewController {

	// UI
	UITableView *tableView1;
	UITextView  *textView1;
	
	// data
	CalendarModel *model;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UITextView  *textView1;

@end

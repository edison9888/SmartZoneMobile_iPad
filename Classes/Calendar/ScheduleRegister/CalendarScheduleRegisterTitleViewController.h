//
//  CalendarScheduleRegisterTitleViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"

@interface CalendarScheduleRegisterTitleViewController : TFUIViewController <UITextFieldDelegate> {
	
	// UI
	UITableView *tableView1;
	UITextField *textField1;	// 제목
	UITextField *textField2;	// 위치
	
	// data
	CalendarModel *model;
	
}

// UI
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) UITextField *textField1;	// 제목
@property (nonatomic, retain) UITextField *textField2;	// 위치

@end

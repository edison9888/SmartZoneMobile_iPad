//
//  CalendarToolBarViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"

@interface CalendarToolBarViewController : TFUIViewController {
	
	// UI
	UIToolbar *footer;
	UISegmentedControl *displayTypeSegmentedControl;
	
	// data
	CalendarModel *model;
	BOOL buttonEnable;
}

@property (nonatomic, retain) IBOutlet UIToolbar *footer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *displayTypeSegmentedControl;
@property (nonatomic, assign)	BOOL buttonEnable;
- (IBAction)memberButtonDidPush:(id)sender;
- (IBAction)todayButtonDidPush:(id)sender;
- (IBAction)typeSegmentedDidSelect:(id)sender;

@end

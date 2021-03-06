//
//  CalendarWeekViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarToolBarViewController.h"
#import "Communication.h"

@interface CalendarWeekViewController : CalendarToolBarViewController <CommunicationDelegate> {

	// UI
	UITableView *tableView1;
	UILabel *label1;
	// data
	NSMutableArray *datasource;
    NSDate *currentDate;
    
    
    Communication *clipboard; //통신모듈 (주보기에서는 인디케이터 사용안함.)
    NSMutableArray *scheduleList; //통신 결과 목록을 임시로 담을 array
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터

    UIBarButtonItem *todayButton;
    UISegmentedControl *modeListButton;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UILabel *label1;

@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *todayButton;	// 오늘버튼
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeListButton;	// 월,주,일,목록
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)buttonDidPush:(id)sender;
- (IBAction)refreshCallCalendar:(id)sender;
- (NSDate *)getNextOrPrevMonthFirstDate:(NSDate *)aDate direction:(int)direction;
@end

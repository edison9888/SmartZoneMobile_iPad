//
//  CalendarListViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarToolBarViewController.h"
#import "Communication.h"


@interface CalendarListViewController : CalendarToolBarViewController <CommunicationDelegate> {
	//UI
	UITableView *tableView1;
	UISearchBar *searchBar1;
    
    UIButton *morePrevButton;
    UIButton *moreNextButton;
    UILabel *labelPrev;
    UILabel *labelPrevBottom;
    UILabel *labelNext;
    UILabel *labelNextBottom;
    
	
	// data
  	NSMutableDictionary *datasource;
	NSArray *datasourceAllKeys;
	
    NSArray *scheduleMMAllKeys;
    
    int todayInSection;
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
    Communication *clipboard; //통신모듈 
    NSMutableArray *scheduleList; //통신 결과 목록을 임시로 담을 array
    
    NSDate *currentDate;//조회월
    
    NSDate *prevDate;//이전월
    NSDate *nextDate;//다음월
    
    UIBarButtonItem *todayButton;
    UISegmentedControl *modeListButton;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar1;
@property (nonatomic, retain) IBOutlet UIButton *morePrevButton;
@property (nonatomic, retain) IBOutlet UIButton *moreNextButton;
@property (nonatomic, retain) IBOutlet UILabel *labelPrev;
@property (nonatomic, retain) IBOutlet UILabel *labelPrevBottom;
@property (nonatomic, retain) IBOutlet UILabel *labelNext;
@property (nonatomic, retain) IBOutlet UILabel *labelNextBottom;

@property (nonatomic, assign) int todayInSection;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *todayButton;	// 오늘버튼
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeListButton;	// 월,주,일,목록

- (IBAction)buttonDidPush:(id)sender;

@end

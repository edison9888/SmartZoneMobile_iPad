//
//  CalendarMainViewController.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 12..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarToolBarViewController.h"
#import "CalendarWeekView.h"
#import "CalendarModel.h"
#import "Communication.h"

@interface CalendarMainViewController : CalendarToolBarViewController <TFCalendarDelegate, CommunicationDelegate, UIActionSheetDelegate> {
	
	NSMutableArray *arrWeekViewPool;	// Ring형 Queue를 풀로 사용한다.
	
	CalendarWeekView *standardWeekView;	// 일자를 세팅할때 기준이 되는 WeekView
	CalendarWeekView *topWeekView;		// 현재 보여지는 달에서 가장 윗 WeekView
	CalendarWeekView *bottomWeekView;	// 현재 보여지는 달에서 가장 윗 WeekView
	
	NSMutableDictionary *buttonsDic;	// 모든 버튼의 정보를 담고 있는 Dictionary 객체(키는 yyyyMMdd타입의 날짜)
	NSMutableArray *hasScheduleImageViews;	// 스케쥴이 있어서 활성화 된 이미지뷰들 (화면 리드로잉이나 달이 넘어갈때 초기화 하기 위해 필요)
	BOOL isFirstDaySunDay;	// 현재 보여지는 달의 1일이 일요일인지 판단
	BOOL isLastDaySatDay;	// 현재 보여지는 달의 말일이 토요일인지 판단
	int correctionValue;	// 보정일수
	int currentDays;		// 현재달의 일수
	NSDate *currentDate;	// 현재달 1일
	
	NSDate *requestDate;	// 일정을 받아 오기 위한 기준이 되는 date
	
	CGRect rect4WeekCalendar;
	CGRect rect5WeekCalendar;
	CGRect rect6WeekCalendar;
	
	NSDate *selectedDate;			// 선택된 일자
	UIImageView *selectedImageView;	// 선택된 일자의 background ImageView
	UILabel *selectedLabel;			// 선택된 일자의 label
	
	UIImageView *todayImageView;	// 오늘날짜의 background ImageView
	UILabel *todayLabel;			// 오늘날짜의 label
	
	BOOL isButtonAction;
	BOOL isScrollAnimating;
	
	// UI
	UIView *viewCalendarMain;		// 날짜 출력되는 부분
	UILabel *label1;				// 현재달
	UITableView *tableView1;		// 일정이 출력되는 리스트
	UIImageView *imageViewShadow;	// 그림자
    
    
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    
    NSMutableArray *scheduleList; //통신 결과 목록을 임시로 담을 array
    
    
    UIBarButtonItem *todayButton;
    UISegmentedControl *modeListButton;
    
    UILabel *dayStr1;
    UILabel *dayStr2;
    UILabel *dayStr3;
    UILabel *dayStr4;
    UILabel *dayStr5;
    UILabel *dayStr6;
    UILabel *dayStr7;
    BOOL listNoti; //메인 list에서 일정 클릭했을 때 처음 viewdidload 여부 
    
}

@property (nonatomic, copy) NSDate *selectedDate;
@property (nonatomic, copy) NSDate *currentDate;
@property (nonatomic, copy) NSDate *requestDate;

@property (nonatomic, retain) IBOutlet UIView *viewCalendarMain;		// 날짜 출력되는 부분
@property (nonatomic, retain) IBOutlet UILabel *label1;					// 현재달
@property (nonatomic, retain) IBOutlet UITableView *tableView1;			// 일정이 출력되는 리스트
@property (nonatomic, retain) IBOutlet UIImageView *imageViewShadow;	// 그림자

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *todayButton;	// 오늘버튼
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeListButton;	// 월,주,일,목록
@property (nonatomic, retain) IBOutlet UILabel *dayStr1;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr2;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr3;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr4;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr5;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr6;	
@property (nonatomic, retain) IBOutlet UILabel *dayStr7;	

// 전달 또는 다음달 구하기
- (NSDate *)getNextOrPrevMonthFirstDate:(NSDate *)aDate direction:(int)direction;
- (void)setWeekWithDirection:(int)direction :(NSDate *)aDateLastDay;
- (void)redrawCalendar;
- (void)redrawHasSchedule;
- (void)gotoSomeDayWithDate:(NSDate *)aDate;

- (IBAction) refreshCallCalendar:(id)sender;
- (IBAction)buttonDidPush:(id)sender;

@end

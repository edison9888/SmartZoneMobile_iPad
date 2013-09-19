//
//  CalendarWeekView.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 12..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCalendarDelegate

@required

- (void)dayButtonDidPush:(id)sender 
						:(NSDate *)selectedDate;

@optional

@end


@interface CalendarWeekView : UIView {
	
	// UI
	UIImageView *imageView1;	// 일요일
	UIImageView *imageView2;	// 월요일
	UIImageView *imageView3;	// 화요일
	UIImageView *imageView4;	// 수요일
	UIImageView *imageView5;	// 목요일
	UIImageView *imageView6;	// 금요일
	UIImageView *imageView7;	// 토요일
	
	UIImageView *imageView101;	// 일요일
	UIImageView *imageView102;	// 월요일
	UIImageView *imageView103;	// 화요일
	UIImageView *imageView104;	// 수요일
	UIImageView *imageView105;	// 목요일
	UIImageView *imageView106;	// 금요일
	UIImageView *imageView107;	// 토요일
	
	UILabel *label1;	// 일요일
	UILabel *label2;	// 월요일
	UILabel *label3;	// 화요일
	UILabel *label4;	// 수요일
	UILabel *label5;	// 목요일
	UILabel *label6;	// 금요일
	UILabel *label7;	// 토요일
	
	int todayIndex;	// 만약 오늘날짜가 있으면 인덱스를 저장해 둔다.
	
	id <TFCalendarDelegate> calendarDelegate;
	NSMutableArray *arrDates;
	
	NSMutableDictionary *buttonsInfo;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView1;	// 일요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;	// 월요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView3;	// 화요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView4;	// 수요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView5;	// 목요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView6;	// 금요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView7;	// 토요일

@property (nonatomic, retain) IBOutlet UIImageView *imageView101;	// 일요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView102;	// 월요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView103;	// 화요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView104;	// 수요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView105;	// 목요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView106;	// 금요일
@property (nonatomic, retain) IBOutlet UIImageView *imageView107;	// 토요일

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 일요일
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 월요일
@property (nonatomic, retain) IBOutlet UILabel *label3;	// 화요일
@property (nonatomic, retain) IBOutlet UILabel *label4;	// 수요일
@property (nonatomic, retain) IBOutlet UILabel *label5;	// 목요일
@property (nonatomic, retain) IBOutlet UILabel *label6;	// 금요일
@property (nonatomic, retain) IBOutlet UILabel *label7;	// 토요일


@property (nonatomic, assign) id <TFCalendarDelegate> calendarDelegate;
@property BOOL isSetCompleted;

- (IBAction)buttonDidPush:(id)sender;
- (NSMutableDictionary *)setDays:(NSArray *)aDates;

@end

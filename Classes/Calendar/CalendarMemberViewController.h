//
//  CalendarMemberViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "TFUIViewController.h"
#import "CalendarMemberListCell.h"
#import "CalendarModel.h"

#define LOAD_DATA 1
#define CREATE_DATA 2
#define DELETE_DATA 3

@interface CalendarMemberViewController : TFUIViewController <CommunicationDelegate, CalendarMemberListCellDelegate> {
//@interface CalendarMemberViewController : TFUIViewController <UITableViewDelegate, UITableViewDataSource> {    
	// UI
	UIImageView *imageView1;	// 나의 일정 체크버튼
	UIImageView *imageView2;	// 공개된 다른사람 일정 백그라운드
	UITableView *tableView1;	// 맴버리스트
	
    
    UILabel *myLabel;
    UILabel *memberLabel;
    
    
	// flag
	BOOL isMyScheduleChecked;
	
	// handling
	UIButton *showingDeleteButton;
	
	// data
	NSMutableArray *datasource;
    NSMutableDictionary *selectMember;
	
	CalendarModel *model;
	
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    int communication_flag;
    
    NSArray *dotImage;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView1;	// 나의 일정 체크버튼
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;	// 공개된 다른사람 일정 백그라운드
@property (nonatomic, retain) IBOutlet UITableView *tableView1;	// 맴버리스트

@property (nonatomic, retain) IBOutlet UILabel *myLabel;
@property (nonatomic, retain) IBOutlet UILabel *memberLabel;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;
@property (nonatomic, assign) int communication_flag;

- (IBAction)myScheduleDidPush:(id)sender;	// 나의 일정 버튼 액선(check / unckeck)

@end

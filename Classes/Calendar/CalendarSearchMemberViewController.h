//
//  CalendarSearchMemberViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"
#import "Communication.h"
#import "ContactModel.h"

#define PAGE_COUNT 20
#define LOAD_DATA 1
#define CREATE_DATA 2

@interface CalendarSearchMemberViewController : TFUIViewController<CommunicationDelegate> {

	// UI
	UITableView *tableView1;
	
	//data
	NSMutableArray *datasource;
    
    //select data
    NSMutableDictionary *selectData;
    
	// data
	ContactModel *contactModel; //연락처 메인 인스턴스 모델
    CalendarModel *model;
	
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    int communication_flag;
    
    UISearchBar *searchBar;
    
    IBOutlet UITableViewCell *nextCell;
	IBOutlet UIButton *nextCellButton;
    int now_page;
	int result_totalCount; // 결과값으로 받은 토탈 검색 건수
	int result_totalPage; // 결과 값을 받은 총 페이지수
    BOOL mode_nextCell; // 더보기 셀 표현 여부.
}

// UI
@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;
@property (nonatomic, assign) int communication_flag;

@property (nonatomic) int now_page;
@property (nonatomic) int result_totalCount;
@property (nonatomic) int result_totalPage;
@property (nonatomic) BOOL mode_nextCell;


-(IBAction)action_nextCell:(id)sender;


@end

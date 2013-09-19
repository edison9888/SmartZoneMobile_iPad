//
//  ContactSearchResultViewController.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 15..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "Communication.h"

#define PAGE_COUNT 20

@interface ContactSearchResultViewController : TFUIViewController <CommunicationDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    
    NSMutableDictionary *param; //검색어 파라메터 
    
    
    UITableView *dataTable; //메인 테이블 뷰
    
    NSMutableArray *contactList; //테이블 뷰 에 가공될 연락처 목록
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    UILabel *searchOptionStr;
    
    IBOutlet UITableViewCell *nextCell;
	IBOutlet UIButton *nextCellButton;
    int now_page;
	int result_totalCount; // 결과값으로 받은 토탈 검색 건수
	int result_totalPage; // 결과 값을 받은 총 페이지수
    BOOL mode_nextCell; // 더보기 셀 표현 여부.
    
}

@property (nonatomic, retain) NSMutableDictionary *param;

@property (nonatomic, retain) IBOutlet UITableView *dataTable;

@property (nonatomic, retain) NSMutableArray *contactList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) IBOutlet UILabel *searchOptionStr;

@property (nonatomic) int now_page;
@property (nonatomic) int result_totalCount;
@property (nonatomic) int result_totalPage;
@property (nonatomic) BOOL mode_nextCell;

-(IBAction)action_nextCell:(id)sender;

@end

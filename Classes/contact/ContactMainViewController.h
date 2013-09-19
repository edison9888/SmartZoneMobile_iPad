//
//  ContactMainViewController.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 13..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "Communication.h"
#import "ContactModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#define PAGE_COUNT 20

@interface ContactMainViewController : TFUIViewController<ABPersonViewControllerDelegate, CommunicationDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    // data
	ContactModel *model; //연락처 메인 인스턴스 모델
    
    UIBarButtonItem *searchButton; //서치바 버튼
    UISearchBar *searchBar; //서치바
    
    UIButton *button1; //버튼1 (임직원)
    UIButton *button2; //버튼2 (내연락처)
    UIButton *button3; //버튼2 (폰북)
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    
    NSMutableArray *contactList; //테이블 뷰 에 가공될 연락처 목록
    
    NSMutableArray *data1; //임직원 데이터
    NSMutableArray *data2; //내연락처 데이터
    NSMutableArray *data3; //폰북 데이터
    
    UITableView *dataTable; //메인 테이블 뷰
    
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    BOOL delegate_flag;
    
    BOOL memberSearch_flag;
    
    NSMutableDictionary *selectedMember;
    
    BOOL mode_search;
    
    //페이징 관련.
    IBOutlet UITableViewCell *nextCell;
	IBOutlet UIButton *nextCellButton;
    int now_page;
	int result_totalCount; // 결과값으로 받은 토탈 검색 건수
	int result_totalPage; // 결과 값을 받은 총 페이지수
    BOOL mode_nextCell; // 더보기 셀 표현 여부.
    
}
@property(nonatomic,retain) IBOutlet UIBarButtonItem *searchButton;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UIButton *button1;
@property(nonatomic,retain) IBOutlet UIButton *button2;
@property(nonatomic,retain) IBOutlet UIButton *button3;
@property(nonatomic,retain) IBOutlet UILabel *label1;
@property(nonatomic,retain) IBOutlet UILabel *label2;
@property(nonatomic,retain) IBOutlet UILabel *label3;


@property (nonatomic,retain) NSMutableArray *contactList;

@property (nonatomic,retain) NSMutableArray *data1;
@property (nonatomic,retain) NSMutableArray *data2;
@property (nonatomic,retain) NSMutableArray *data3;

@property (nonatomic, retain) IBOutlet UITableView *dataTable;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property(nonatomic,assign) BOOL delegate_flag;
@property(nonatomic,assign) BOOL memberSearch_flag;


@property (nonatomic) int now_page;
@property (nonatomic) int result_totalCount;
@property (nonatomic) int result_totalPage;
@property (nonatomic) BOOL mode_nextCell;


-(void) contactDefault;
-(void) personView:(NSString *)recordId;
-(void) loadData;

-(void) resetData;

-(IBAction) tabButtonClicked:(id)sender;
-(IBAction) searchButtonClicked;

-(IBAction)action_nextCell:(id)sender;

@end

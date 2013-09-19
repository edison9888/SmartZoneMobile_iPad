//
//  CalendarModel.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 23..
//  Copyright 2011 두베. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarModel : NSObject {

    
    // 나의 일정 인지 구분 하기 위한 NSMutableDictionary
    NSMutableDictionary *scheduleOwnerInfo; 
    // ex) forKey "isMy" value "YES or NO" : 내 일정인지 여부.
    // ex) forKey "loginid" value "b55555555" : 로그인시 userid
    // ex) forKey "empnm" value "테스터" : 로그인후 username
    // ex) forKey "sharedemail" value "test@test.com" -> 타인 일정 조회시 이메일이 있어야함.
    NSMutableDictionary *sharedMemberList;/* 등록한 타인 일정 공유 목록 */
    
	// 시리얼 하게 들어오는 데이터를 재가공하여 yyyyMM 타입을 키로 하는 Dictionary로 만듬
	NSMutableDictionary *scheduleListDic;
	
	NSDate *dateStoredStartbound;	// 현재 보여질 달이 dateStoredStartbound와 같으면 스케쥴 전문을 실행
	NSDate *dateStoredEndbound;		// 현재 보여질 달이 dateStoredEndbound와 같으면 스케쥴 전문을 실행
	
	NSDate *selectedDate;			// 선택된 날(캘린더에서 눌렀을 때 바로 세팅됨)
	NSString *selectedDateString;	// 선택된 날
	int	selectedDateIndex;			// 선택된 날 스케쥴의 인덱스 
	BOOL isNeedUpdateSelectedDate;	// 선택된 날이 업데이트가 필요한지 판단
	
	// 캘린더 첫화면의 하단 툴바 아이템중 선택되어 있는 아이템
	int selectedDisplayType;		// 0 : 월,  1 : 주,  2 : 일,  3 : 목록
    
	
	/* 여기서부터 아래는 일정등록에서 사용 */
	NSMutableDictionary *selectedMember;/* 일정 등록, 수정의 초대 맴버관리 */
	
	// 제목 위치
	NSString *registerTitle;	// 제목
	NSString *registerLocation;	// 위치
	
	// 시작 종료
	NSDate *registerStartDate;					// 시작일
	NSTimeInterval registerEndDateInterval;		// 시작일로부터의 인터발(종료일)
    BOOL registerIsAllDayEvent;  // 하루종일
	
	// 반복
	int registerRepeatType;				// 반복형태 (0:없음, 1:매일, 2:주중(월~금), 3:매주(매주 X요일), 4:매월(매월 XX일), 5:매년(매년 XX월 XX일))
	NSString *registerRepeatTypeString;	// 표시용 반복형태 스트링
	NSDate *registerRepeatEndDate;		// 반복 종료일
	NSString *registerRepeatEndDateString;	// 표시용 반복형태 스트링
	
	// 제1알림, 제2알림
	int registerNotiType1;				// 제1알림 타입
	NSString *registerNotiType1String;	// 제1알림 타입 풀스트링
	int registerNotiType2;				// 제2알림 타입
	NSString *registerNotiType2String;	// 제2알림 타입 풀스트링
	int registerEdittingNoti;			// 현재 입력을 받고 있는 알림 (0:제1알림, 1:제2알림);
	
	// 메모
	NSString *registerMemo;	// 메모
	
	// 초대
	NSArray *registerInviteList;	// 초대목록
    
    
    // 일정목록 보기용
    NSMutableArray *viewScheduleList; //일정 목록 (일, 시간대등)
    // 상세보기용.
	NSDictionary *viewSchedule; //일정 상세 (1건의 일정)
    
    
    
    
}

@property (nonatomic, readonly) NSMutableDictionary *scheduleListDic;

@property (nonatomic, copy) NSDate *dateStoredStartbound;	// 현재 보여질 달이 dateStoredStartbound와 같으면 스케쥴 전문을 실행
@property (nonatomic, copy) NSDate *dateStoredEndbound;		// 현재 보여질 달이 dateStoredEndbound와 같으면 스케쥴 전문을 실행
@property (nonatomic, copy) NSDate *selectedDate;			// 선택된 날(캘린더에서 눌렀을 때 바로 세팅됨)
@property (nonatomic, copy) NSString *selectedDateString;	// 선택된 날
@property int	selectedDateIndex;							// 선택된 날 스케쥴의 인덱스 
@property BOOL	isNeedUpdateSelectedDate;					// 선택된 날이 업데이트가 필요한지 판단

// 캘린더 첫화면의 하단 툴바 아이템중 선택되어 있는 아이템
@property int selectedDisplayType;							// 0 : 월,  1 : 주,  2 : 일,  3 : 목록


/* 맴버관리 */
@property (nonatomic, retain) NSMutableDictionary *selectedMember;


/* 일정등록 */

// 제목 위치
@property (nonatomic, copy) NSString *registerTitle;	// 제목
@property (nonatomic, copy) NSString *registerLocation;	// 위치

// 시작 종료
@property (nonatomic, copy) NSDate *registerStartDate;	// 시작일
@property NSTimeInterval registerEndDateInterval;		// 시작일로부터의 인터발
@property BOOL registerIsAllDayEvent;  // 하루종일

// 반복
@property int registerRepeatType;								// 반복형태 (0:없음, 1:매일, 2:주중(월~금), 3:매주(매주 X요일), 4:매월(매월 XX일), 5:매년(매년 XX월 XX일))
@property (nonatomic, copy)	NSString *registerRepeatTypeString;	// 표시용 반복형태 스트링
@property (nonatomic, copy) NSDate *registerRepeatEndDate;		// 반복 종료일
@property (nonatomic, copy) NSString *registerRepeatEndDateString;	// 표시용 반복형태 스트링

// 제1알림, 제2알림
@property int registerNotiType1;								// 제1알림 타입
@property (nonatomic, copy)	NSString *registerNotiType1String;	// 제1알림 타입 풀스트링
@property int registerNotiType2;								// 제2알림 타입
@property (nonatomic, copy)	NSString *registerNotiType2String;	// 제2알림 타입 풀스트링
@property int registerEdittingNoti;								// 현재 입력을 받고 있는 알림 (0:제1알림, 1:제2알림);

// 메모
@property (nonatomic, copy)	NSString *registerMemo;	// 메모

// 초대
@property (nonatomic, copy)	NSArray *registerInviteList;	// 초대목록


// 약속 목록 용
@property (nonatomic, retain) NSMutableArray *viewScheduleList; // 약속목록용 어레이
// 상세보기용
@property (nonatomic, retain) NSDictionary *viewSchedule; // 상세보기용 딕셔너리

// 나의 일정 인지 구분 하기 위한 NSMutableDictionary
@property (nonatomic, retain) NSMutableDictionary *scheduleOwnerInfo;
@property (nonatomic, retain) NSMutableDictionary *sharedMemberList; // 등록된 타인 목록

+ (CalendarModel *)sharedInstance;	// Singleton creation method
+ (void)releaseSharedInstance;

- (void)setScheduleListDicWithLinearData:(NSArray *)linearData;	// 선형 데이터를 계층형 데이터로 변환한다.
- (NSDictionary *)getSelectedDateSchedule;						// 계층형 데이터를 탐색해 선택된 날짜의 스케쥴(NSDictionary type)을 가져온다.
- (void)setSeelectedDateAndSelectedDateIndexWithScheduleDic:(NSDictionary *)dic;	 // 목록보기에서 목록을 선택하면 해당 목록에 대한 값을 모델에 세팅해 줌
- (void)removeSchedule:(NSDictionary *)removeDic addSchedule:(NSDictionary *)addDic; // 일정하나를 삭제하고 추가한다.(수정)
- (void)removeSchedule:(NSDictionary *)removeDic;									 // 일정하나를 삭제한다.(삭제)
- (void)addSchedule:(NSDictionary *)addDic;											 // 일정하나를 추가한다.(등록)
- (void)resetModel;															// 모델을 초기화 시킨다.
- (NSArray *)requestBoundsWithTargetDateString:(NSString *)aTargetDateString;	// 현재까지 받은 영역을 넘으면 넘은 영역부터 1년단위로 계산하여 바운드를 넘겨준다.

@end

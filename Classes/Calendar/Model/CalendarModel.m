//
//  CalendarModel.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 23..
//  Copyright 2011 두베. All rights reserved.
//

#import "CalendarModel.h"
#import "CalendarFunction.h"

@implementation CalendarModel

@synthesize scheduleListDic;

@synthesize dateStoredStartbound;		// 현재 보여질 달이 dateStoredStartbound와 같으면 스케쥴 전문을 실행
@synthesize dateStoredEndbound;			// 현재 보여질 달이 dateStoredEndbound와 같으면 스케쥴 전문을 실행
@synthesize selectedDate;				// 선택된 날(캘린더에서 눌렀을 때 바로 세팅됨)
@synthesize selectedDateString;			// 선택된 날
@synthesize selectedDateIndex;			// 선택된 날 스케쥴의 인덱스 
@synthesize isNeedUpdateSelectedDate;	// 선택된 날이 업데이트가 필요한지 판단

@synthesize selectedDisplayType;		// 0 : 월,  1 : 주,  2 : 일,  3 : 목록

/* 맴버관리 */
@synthesize selectedMember;

/* 일정 등록 */

// 제목 위치
@synthesize registerTitle;		// 제목
@synthesize registerLocation;	// 위치

// 시작종료
@synthesize registerStartDate;			// 시작일
@synthesize registerEndDateInterval;	// 시작일로부터의 인터발
@synthesize registerIsAllDayEvent;  // 하루종일

// 반복
@synthesize registerRepeatType;			// 반복형태 (0:없음, 1:매일, 2:주중(월~금), 3:매주(매주 X요일), 4:매월(매월 XX일), 5:매년(매년 XX월 XX일))
@synthesize registerRepeatTypeString;	// 표시용 반복형태 스트링
@synthesize registerRepeatEndDate;		// 반복 종료일
@synthesize registerRepeatEndDateString;	// 표시용 반복형태 스트링

// 제1알림, 제2알림
@synthesize registerNotiType1;			// 제1알림 타입
@synthesize registerNotiType1String;	// 제1알림 타입 풀스트링
@synthesize registerNotiType2;			// 제2알림 타입
@synthesize registerNotiType2String;	// 제2알림 타입 풀스트링
@synthesize registerEdittingNoti;		// 현재 입력을 받고 있는 알림 (0:제1알림, 1:제2알림);

// 메모
@synthesize registerMemo;	// 메모

// 초대
@synthesize registerInviteList;	// 초대목록


// 약속목록용
@synthesize viewScheduleList; //약속목록용
// 상세보기용
@synthesize viewSchedule; //상세보기용

// 나의 일정 인지 구분 하기 위한 NSMutableDictionary
@synthesize scheduleOwnerInfo;
@synthesize sharedMemberList; //등록된 타인 목록


- (void)setScheduleListDicWithLinearData:(NSArray *)linearData mode:(int)mode {
	
	// scheduleListdic을 아래와 같이 맞추면 됨
	//	{
	//		201104 =     {
	//			20110403 =         (
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//		};
	//		201105 =     {
	//			20110502 =         (
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//			20110516 =         (
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//			20110524 =         (
	//								{
	//									"실데이터키" = value
	//								},
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//		};
	//		201106 =     {
	//			20110602 =         (
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//			20110616 =         (
	//								{
	//									"실데이터키" = value
	//								},
	//								{
	//									"실데이터키" = value
	//								}
	//								);
	//		};
	//	}
	
	
	if (scheduleListDic == nil) {
		scheduleListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	// 시작일과 종료일을 비교하여 다른경우 시작일부터 종료일까지 데이터를 강제로 복사하여 넣어준다.
	// (시작일부터 종료일까지 •을 찍기 위해서)
	NSMutableArray *extendLinearData = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (NSDictionary *fullDataDic in linearData) {
        
        NSDictionary *dic = [fullDataDic objectForKey:@"DATA"];
        
		NSString *strStartDate = [CalendarFunction getStringFromDate:[CalendarFunction getDateFromString:[dic objectForKey:@"starttime"] dateFormat:@"yyyy-MM-dd HH:mm"] 
														  dateFormat:@"yyyyMMdd"];
		NSString *strEndDate   = [CalendarFunction getStringFromDate:[CalendarFunction getDateFromString:[dic objectForKey:@"endtime"]   dateFormat:@"yyyy-MM-dd HH:mm"] 
														  dateFormat:@"yyyyMMdd"];
		
        // 1. 아웃룩에서 하루종일 플래그가 있으면 해당 데이터는 날짜가 같다고 본다. 1일 차이가 남.. 2011-01-01 00:00 ~ 2011-01-02 00:00 으로 데이터 들어옴.
        // 2. 위에꺼 정상 데이터 였음.
        // 예를 들어 아웃룩에서 2011-01-01 에 하루종일 체크 하면 2011-01-01 00:00 ~ 2011-01-02 00:00 으로 들어옴
        // 예를 들어 아웃룩에서 2011-01-01 에 하루종일 체크 하고 2011-01-02 까지 하면 2011-01-01 00:00 ~ 2011-01-03 00:00 으로 들어옴
        
        // 따라서 다음과 같은 데이터 체크를 해야함.
        // 만약 isalldayevent 값이 true 이고. 종료일의 시간값이 00:00 이면 종료일-1 일을 체크 하자.
        
        
        
        
		//1. if (![strStartDate isEqualToString:strEndDate] && [[dic objectForKey:@"isalldayevent"] isEqualToString:@"false"]) {
		//2.
        if ( ![strStartDate isEqualToString:strEndDate] ) {
            
			NSDate *startDate = [CalendarFunction getDateFromString:[dic objectForKey:@"starttime"] dateFormat:@"yyyy-MM-dd HH:mm"];
			NSDate *endDate   = [CalendarFunction getDateFromString:[dic objectForKey:@"endtime"]	  dateFormat:@"yyyy-MM-dd HH:mm"];
			
            
            if ( [[dic objectForKey:@"isalldayevent"] isEqualToString:@"true"] ) {                
                if ( [[[dic objectForKey:@"endtime"] substringWithRange:NSMakeRange(11, 5)] isEqualToString:@"00:00"] ) {
                    // 하루종일 이벤트에 걸린 날이므로 
                    // endDate 를 하루 감 한다.
                    NSDateComponents *dateComponentsEndDate = [[NSDateComponents alloc] init];
                    dateComponentsEndDate.day = -1;
                    endDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponentsEndDate 
                                                                            toDate:endDate 
                                                                           options:0];
                    [dateComponentsEndDate release];
                    dateComponentsEndDate = nil;
//NSLog(@"하루종일 이벤트 이고 종료일이 00시 00분임. 원본[%@] 시작 [%@] 따라서 종료시간. [%@]", [dic objectForKey:@"endtime"], startDate, endDate);                    
                }
            }
            
			// 일단 시작일을 넣고 본다.
			NSMutableDictionary *extendStartDic = nil;	
			extendStartDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
			[extendStartDic setObject:@"EXT_START" forKey:@"EXT_TYPE"];				// EXT_TYPE이 EXT_START이면 시작일
			[extendStartDic setObject:strStartDate forKey:@"DATE"];
			[extendLinearData addObject:extendStartDic];
			
			// 시작일과 종료일 사이의 일정을 extend한다.
			NSMutableDictionary *extendDic = nil;
			NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
			
			int i = 1;
			dateComponents.day = i;
			NSDate *extendDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																			   toDate:startDate 
																			  options:0];
			i++;
			
//NSLog(@"시작일과 종료일의 비교.[%@][%@][%d]",extendDate,endDate,[CalendarFunction compare:extendDate to:endDate]);			
//NSLog(@"하루종일 이벤트 인데 날짜가 같은지 체크 시작 [%@] 종료. [%@]", startDate, endDate);                    
            if ( [startDate compare:endDate] == NSOrderedSame ) {
                //시작일 종료일이 같으면 건너뛴다.
                continue;
            } else {            
                while ([CalendarFunction compare:extendDate to:endDate] < NSOrderedSame) {
                    
                    extendDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                    
                    [extendDic setObject:[CalendarFunction getStringFromDate:extendDate dateFormat:@"yyyyMMdd"]	forKey:@"DATE"];
                    [extendDic setObject:@"EXTED"		forKey:@"EXT_TYPE"];
                    [extendDic setObject:extendStartDic forKey:@"START_DIC"];
                    
                    [extendLinearData addObject:extendDic];
                    [extendDic release];
                    
                    dateComponents.day = i;
                    extendDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                               toDate:startDate 
                                                                              options:0];
                    i++;
                }
			}
			[dateComponents release];
			dateComponents = nil;
			
			// 종료일
			extendDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
			[extendDic setObject:[CalendarFunction getStringFromDate:extendDate dateFormat:@"yyyyMMdd"]	forKey:@"DATE"];
			[extendDic setObject:@"EXT_END"		forKey:@"EXT_TYPE"];
			[extendDic setObject:extendStartDic forKey:@"START_DIC"];
			
			[extendLinearData addObject:extendDic];
			[extendDic release];
			
			[extendStartDic release];
			
			continue;
		} else {
			
			NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
			[mutableDic setObject:strStartDate forKey:@"DATE"];
			[extendLinearData addObject:mutableDic];
			[mutableDic release];
			mutableDic = nil;
		}
        
	}
	
	
	for (NSDictionary *dic in extendLinearData) {
		
		if ([dic objectForKey:@"DATE"] != nil) {
			
			NSString *strStartDate = [dic objectForKey:@"DATE"];
			NSString *strYearMonth = [strStartDate substringToIndex:6];
			
			NSDictionary *dicMonthSchedule = [scheduleListDic objectForKey:strYearMonth];
			
			if (dicMonthSchedule == nil) {
				dicMonthSchedule = [[NSMutableDictionary alloc] initWithCapacity:0];
				
				NSMutableArray *arrDaySchedule = [[NSMutableArray alloc] initWithCapacity:0];
				
				[arrDaySchedule addObject:dic];
				
				[dicMonthSchedule setValue:arrDaySchedule forKey:strStartDate];
				[arrDaySchedule release];
				arrDaySchedule = nil;
				
				[scheduleListDic setValue:dicMonthSchedule forKey:strYearMonth];
				[dicMonthSchedule release];
				dicMonthSchedule = nil;
				
			} else {
				
				NSMutableArray *arrDaySchedule = [dicMonthSchedule objectForKey:strStartDate];
				
				if (arrDaySchedule == nil) {
					arrDaySchedule = [[NSMutableArray alloc] initWithCapacity:0];
					
					[dicMonthSchedule setValue:arrDaySchedule forKey:strStartDate];
					[arrDaySchedule release];
				}
				
				BOOL isAdded = NO;
				NSUInteger i, count = [arrDaySchedule count];
				for (i = 0; i < count; i++) {
					NSDictionary *obj = (NSDictionary *)[arrDaySchedule objectAtIndex:i];
					
					// 왼쪽이 더 큼 1NSOrderedDescending 오른쪽이 더 크면 -1NSOrderedAscending
					
//					if ([(NSString *)[obj objectForKey:@"subject"] compare:[dic objectForKey:@"subject"]] >= NSOrderedSame) {
                    if ([(NSString *)[obj objectForKey:@"starttime"] compare:[dic objectForKey:@"starttime"]] >= NSOrderedSame) {
						[arrDaySchedule insertObject:dic atIndex:i];
						isAdded = YES;
						break;
					}
					
				}
				
				if (!isAdded) {
					[arrDaySchedule addObject:dic];
				}
//				NSLog(@"%@", arrDaySchedule);
			}
		}
	}
//NSLog(@"%@", scheduleListDic);
	
	if (mode == 1) {
		
		NSDictionary *addedScheduleDic = [linearData lastObject];
		
		NSString *strSelectedDate  = [addedScheduleDic objectForKey:@"STR_DT"];
		NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
		
		NSMutableArray *arrDaySchedule = [[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
		
		self.selectedDateString = strSelectedDate;
		selectedDateIndex  = [arrDaySchedule indexOfObject:addedScheduleDic];
		
	}
	
	[extendLinearData release];
	extendLinearData = nil;
	
	
    //	if (scheduleListDic == nil) {
    //		scheduleListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //	}
    //	
    //	for (NSDictionary *dic in linearData) {
    //		
    //		if ([dic objectForKey:@"DATE"] != nil) {
    //			
    //			NSString *strStartDate = [dic objectForKey:@"DATE"];
    //			NSString *strYearMonth = [strStartDate substringToIndex:6];
    //			
    //			NSDictionary *dicMonthSchedule = [scheduleListDic objectForKey:strYearMonth];
    //			
    //			if (dicMonthSchedule == nil) {
    //				dicMonthSchedule = [[NSMutableDictionary alloc] initWithCapacity:0];
    //				
    //				NSMutableArray *arrDaySchedule = [[NSMutableArray alloc] initWithCapacity:0];
    //				
    //				[arrDaySchedule addObject:dic];
    //				
    //				[dicMonthSchedule setValue:arrDaySchedule forKey:strStartDate];
    //				[arrDaySchedule release];
    //				arrDaySchedule = nil;
    //				
    //				[scheduleListDic setValue:dicMonthSchedule forKey:strYearMonth];
    //				[dicMonthSchedule release];
    //				dicMonthSchedule = nil;
    //				
    //			} else {
    //				
    //				NSMutableArray *arrDaySchedule = [dicMonthSchedule objectForKey:strStartDate];
    //				
    //				if (arrDaySchedule == nil) {
    //					arrDaySchedule = [[NSMutableArray alloc] initWithCapacity:0];
    //					
    //					[dicMonthSchedule setValue:arrDaySchedule forKey:strStartDate];
    //					[arrDaySchedule release];
    //				}
    //				
    //				BOOL isAdded = NO;
    //				NSUInteger i, count = [arrDaySchedule count];
    //				for (i = 0; i < count; i++) {
    //					NSDictionary *obj = (NSDictionary *)[arrDaySchedule objectAtIndex:i];
    //					
    //					// 왼쪽이 더 큼 1NSOrderedDescending 오른쪽이 더 크면 -1NSOrderedAscending
    //					
    //					if ([(NSString *)[obj objectForKey:@"TITLE"] compare:[dic objectForKey:@"TITLE"]] >= NSOrderedSame) {
    //						[arrDaySchedule insertObject:dic atIndex:i];
    //						isAdded = YES;
    //						break;
    //					}
    //
    //				}
    //				
    //				if (!isAdded) {
    //					[arrDaySchedule addObject:dic];
    //				}
    //
    //			}
    //		}
    //	}
    //	NSLog(@"%@", scheduleListDic);
    //	
    //	if (mode == 1) {
    //		
    //		NSDictionary *addedScheduleDic = [linearData lastObject];
    //		
    //		NSString *strSelectedDate  = [addedScheduleDic objectForKey:@"DATE"];
    //		NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
    //		
    //		NSMutableArray *arrDaySchedule = [[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
    //		
    //		self.selectedDateString = strSelectedDate;
    //		selectedDateIndex  = [arrDaySchedule indexOfObject:addedScheduleDic];
    //		
    //	}
}

- (void)setScheduleListDicWithLinearData:(NSArray *)linearData {
	[self setScheduleListDicWithLinearData:linearData mode:0];
}

// 목록보기에서 목록을 선택하면 해당 목록에 대한 값을 모델에 세팅해 줌
- (void)setSeelectedDateAndSelectedDateIndexWithScheduleDic:(NSDictionary *)dic {

	NSString *strSelectedDate  = [dic objectForKey:@"DATE"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	
	NSMutableArray *arrDaySchedule = [[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];

	self.selectedDateString = strSelectedDate;
	self.selectedDateIndex = [arrDaySchedule indexOfObject:dic];
	
}

// 선택되어 있는 일정을 넘겨줌
- (NSDictionary *)getSelectedDateSchedule {
	
	NSString *strSelectedDate  = selectedDateString;
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	int index = selectedDateIndex;
	
	NSDictionary *dic = [[[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate] objectAtIndex:index];
	
	return dic;
	
}

// 일정하나를 삭제하고 추가한다.(수정)
- (void)removeSchedule:(NSDictionary *)removeDic addSchedule:(NSDictionary *)addDic {

	NSString *strSelectedDate  = [removeDic objectForKey:@"DATE"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	
	NSMutableArray *arrDaySchedule = [[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
	[arrDaySchedule removeObject:removeDic];
	
	if ([arrDaySchedule count] == 0) {
		[[scheduleListDic objectForKey:strSelectedMonth] removeObjectForKey:strSelectedDate];
	}
	
	[self setScheduleListDicWithLinearData:[NSArray arrayWithObject:addDic] mode:1];
	isNeedUpdateSelectedDate = YES;
	
//	NSLog(@"%@", scheduleListDic);
	
}

// 일정하나를 삭제한다.(삭제)
- (void)addSchedule:(NSDictionary *)addDic {
	
	[self setScheduleListDicWithLinearData:[NSArray arrayWithObject:addDic] mode:1];
	isNeedUpdateSelectedDate = YES;
	
}

// 일정하나를 추가한다.(등록)
- (void)removeSchedule:(NSDictionary *)removeDic {
	
	NSString *strSelectedDate  = [removeDic objectForKey:@"DATE"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	
	NSMutableArray *arrDaySchedule = [[scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
	[arrDaySchedule removeObject:removeDic];
	
	if ([arrDaySchedule count] == 0) {
		[[scheduleListDic objectForKey:strSelectedMonth] removeObjectForKey:strSelectedDate];
	}
	
	self.selectedDateString = strSelectedDate;
	selectedDateIndex = -1;
	
	isNeedUpdateSelectedDate = YES;
}

// 모델을 초기화 시킨다.
- (void)resetModel {
	
	[scheduleListDic removeAllObjects];
	self.dateStoredStartbound = nil;
	self.dateStoredEndbound   = nil;
	self.selectedDateString   = nil;
	self.selectedDateIndex    = -1;
	self.isNeedUpdateSelectedDate = NO;

}



// 전달 또는 다음달 구하기
- (NSDate *)getNextOrPrevMonthFirstDate:(NSDate *)aDate direction:(int)direction {
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	dateComponents.month = direction;
	
	NSDate *dateMonthFirstDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																				toDate:aDate 
																			   options:0];
	[dateComponents release];
	dateComponents = nil;
	return dateMonthFirstDate;
	
}

// 현재까지 받은 영역을 넘으면 넘은 영역부터 1년단위로 계산하여 바운드를 넘겨준다.
- (NSArray *)requestBoundsWithTargetDateString:(NSString *)aTargetDateString {
	
	// 일단 들어온 날짜를 1일로 만든다.
	NSString *strTargetMonthFirstDay = [NSString stringWithFormat:@"%@01", [aTargetDateString substringToIndex:6]];
	
	// 들어온 날짜가 어느쪽으로 벗어났는지 체크한다.(영역보다 작은지 큰지... 과거인지 미래인지...)
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSString *strStartBound = [dateFormat stringFromDate:self.dateStoredStartbound];
	NSString *strEndBound	= [dateFormat stringFromDate:self.dateStoredEndbound];
	NSDate *dateTargetMonthFirstDay = [dateFormat dateFromString:strTargetMonthFirstDay];
	
	NSDate *requestStartDate = nil;
	NSDate *requestEndDate	 = nil;
	
	BOOL hasChangeStartBounds = NO;
	
	if ([strStartBound intValue] - [strTargetMonthFirstDay intValue] >= 0) {
		// 과거 영역 바운드 밖인 경우
		requestStartDate = [self getNextOrPrevMonthFirstDate:self.dateStoredStartbound
												   direction:-12];	// 일단 시작날짜는 받아온 바운드의 일년으로 잡아 본다.
		requestEndDate	 = [self getNextOrPrevMonthFirstDate:self.dateStoredStartbound
														  direction:-1];

		while ([dateTargetMonthFirstDay compare:requestStartDate] == NSOrderedAscending) {
			requestStartDate = [self getNextOrPrevMonthFirstDate:requestStartDate
													   direction:-12];
		}
		
		hasChangeStartBounds = YES;
		
	} else if ([strEndBound intValue] - [strTargetMonthFirstDay intValue] <= 0) {
		// 미래 영역 바운드 밖인 경우
		requestStartDate = [self getNextOrPrevMonthFirstDate:self.dateStoredEndbound
												   direction:1];	
		requestEndDate	 = [self getNextOrPrevMonthFirstDate:self.dateStoredEndbound
												  direction:12];	// 일단 끝 날짜는 받아온 바운드의 일년으로 잡아 본다.

		while ([dateTargetMonthFirstDay compare:requestEndDate] == NSOrderedDescending) {
			requestEndDate = [self getNextOrPrevMonthFirstDate:requestEndDate
													 direction:12];
		}
	} else {
		return nil;
	}

	[dateFormat setDateFormat:@"yyyyMM"];
	
	NSArray *retArr = [[[NSArray alloc] initWithObjects:
					   [dateFormat stringFromDate:requestStartDate], 
					   [dateFormat stringFromDate:requestEndDate], 
						hasChangeStartBounds ? @"START" : @"END" ,nil] autorelease];
	
	dateFormat = nil;
	
	return retArr;
}

static CalendarModel *instance;

// Singleton creation method
+ (CalendarModel *)sharedInstance {
	
	@synchronized (self) {
		
		if (instance == nil) {
			instance = [[CalendarModel alloc] init];
			instance.selectedDateIndex = -1;
		}
        if (instance.selectedMember == nil) instance.selectedMember = [[NSMutableDictionary alloc] init];
        if (instance.scheduleOwnerInfo == nil) instance.scheduleOwnerInfo = [[NSMutableDictionary alloc] init];
        if (instance.sharedMemberList == nil) instance.sharedMemberList = [[NSMutableDictionary alloc] init];
	}
	
	return instance;
}

+ (void)releaseSharedInstance {
	
	@synchronized (self) {
		[instance release];
		instance = nil;
	}
	
}

- (void)dealloc {
	
	[scheduleListDic release];
	
	[dateStoredStartbound release];
	[dateStoredEndbound  release];
	[selectedDate release];				// 선택된 날(캘린더에서 눌렀을 때 바로 세팅됨)
	[selectedDateString release];
	
	/* 맴버관리 */
	[selectedMember release];
	
	// 일정 등록
	[registerTitle release];	// 제목
	[registerLocation release];	// 위치
	
	[registerStartDate release];			// 시작일
	
	[registerRepeatTypeString release];		// 표시용 반복형태 스트링
	[registerRepeatEndDate release];		// 반복 종료일
	[registerRepeatEndDateString release];	// 표시용 반복형태 스트링
	
	// 제1알림, 제2알림
	[registerNotiType1String release];	// 제1알림 타입 풀스트링
	[registerNotiType2String release];	// 제2알림 타입 풀스트링
	
	[registerMemo release];	// 메모
	
	[registerInviteList release];	// 초대목록
	
    [viewScheduleList   release]; // 약속목록용
    [viewSchedule       release]; //상세보기용
    
    [scheduleOwnerInfo  release];   // 현재 조회중인 일정 소유자 정보
    [sharedMemberList   release];   // 타인 공유 목록
    
	[super dealloc];
}

@end

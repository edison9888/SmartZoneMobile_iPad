//
//  CalendarMainViewController.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 12..
//  Copyright 2011 .NetTree. All rights reserved.
//
//	원래 캘린더 + 스캐쥴러는 CoreAnimation과 Quarts와 SQLite를 써야
//	높은 퍼포먼스와 유지보수의 편리함을 동시에 가져갈 수 있다.
//	하지만, 구글캘린더 연동 기준으로 러프하게 1.5M/M가 소요되므로(API 해석해야 하는 시간도 포함)
//	아래 소스는 최대한 비슷하게 구현하면서 빠르게 개발할 수 있도록 초점을 맞춰 개발함.
//	(참고로 아래 소스는 3일 걸림)

#import "CalendarMainViewController.h"
#import "NSMutableArray+QueueAdditions.h"
#import "NSDictionary+NotNilReturn.h"
#import "CalendarMainListCell.h"
#import "CalendarFunction.h"
#import "URL_Define.h"

//#define CALENDAR_DAY_CELL_HEIGHT	45.0
#define CALENDAR_DAY_CELL_HEIGHT	113.0

#define SPOOL_CAPACITY				11
#define SPOOL_MAX_INDEX				SPOOL_CAPACITY - 1

@implementation CalendarMainViewController

@synthesize currentDate;
@synthesize selectedDate;
@synthesize requestDate;

@synthesize viewCalendarMain;// 날짜 출력되는 부분
@synthesize label1;			 // 현재달
@synthesize tableView1;		 // 일정이 출력되는 리스트
@synthesize imageViewShadow; // 그림자

@synthesize indicator;
@synthesize clipboard;

@synthesize todayButton;
@synthesize modeListButton;	// 월,주,일,목록

@synthesize dayStr1;
@synthesize dayStr2;
@synthesize dayStr3;
@synthesize dayStr4;
@synthesize dayStr5;
@synthesize dayStr6;
@synthesize dayStr7;

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    //--- indicator setting ---//
    buttonEnable = NO;
    displayTypeSegmentedControl.enabled = NO;
    BOOL isIndicator = YES;
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [self.view bringSubviewToFront:uiView];
            isIndicator = NO;
            [indicator startAnimating];
        }
    }        
    if ( isIndicator ) {
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(360, 400, 50, 50)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview:indicator];
//        indicator.center = self.view.center;
        [indicator startAnimating];
    }
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
    
    
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
    //NSLog(@"result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
    
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
        buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;

	}
	
	if([rsltCode intValue] == 0) {
		
        if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) { 
            // 일정 데이터가 있다.
            //[self.contactList addObjectsFromArray:[_resultDic objectForKey:@"aptlistinfo"]];
            scheduleList = [_resultDic objectForKey:@"aptlistinfo"];
            
            //데이터를 갱신 표현한다.
            [self performSelector:@selector(receiveScheduleData)];
            
        } else {
            buttonEnable = YES; 
            displayTypeSegmentedControl.enabled = YES;
            //0건일수 있으므로 리드로 해준다.
            [self redrawHasSchedule];
            //테이블도 리로드 해준다.
            [self.tableView1 reloadData];

            //일정 데이터를 표현 해야 되는데 내 일정은 표현 하지 말고 타인 일정일 경우에만 표현하자.
            if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_no_events_are_saved",@"조회된 일정이 없습니다.")
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                
                [alert show];	
                [alert release];
                return;
            }
            
        }
        
	}
    else if ( [rsltCode intValue] == 1 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
        buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;

		return;		
        
    }
    else if ([rsltCode intValue] == 100){//공유 허용되지 않는 사용자 일때는 다시 캘린더 보기로 돌아가자
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 5555;
		[alert show];	
		[alert release];

		buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;

    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
        buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;

		return;		
	}
	
    
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
    //0건일수 있으므로 리드로 해준다.
    [self redrawHasSchedule];
	//테이블도 리로드 해준다.
    [self.tableView1 reloadData];
    buttonEnable = YES; 
    displayTypeSegmentedControl.enabled = YES;

    
}



#pragma mark -
#pragma mark Data Request & Receive

- (void)requestScheduleData {
	if (buttonEnable == NO) {
        return;
    }
    buttonEnable = NO;
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];
	
	//	SCH_MONTH	조회월			●	YYYYMM
	NSString *schMonth  = [dateFormat stringFromDate:self.requestDate];
	
    
    //NSLog(@"조회 월 정보 [%@]", schMonth);
    //http://10.225.133.134:8080/mKate/appointment/AppointmentController/getAppointmentList.do?comcd=1001&starttime=2011-06-01%2018:36:41&endtime=2011-06-27%2018:36:41
    
    
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    callUrl = URL_getAppointmentList; // 내일정
    //callUrl = URL_getSharedAppointmentList; // 타인일정
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    
    //월 셋팅을 하자.
    NSString *firstDay = [CalendarFunction getStringFromDate:[self getMonthFirstDate:self.currentDate] dateFormat:@"yyyy-MM-dd"];
    NSString *lastDay = [CalendarFunction getStringFromDate:[self getMonthLastDate:self.currentDate] dateFormat:@"yyyy-MM-dd"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",lastDay] forKey:@"endtime"];
    
    
    // 통신을 새로 타면 스케줄을 초기화 해준다.
    [model.scheduleListDic removeAllObjects];
    // 스케줄을 초기화 하지 말고.. 해당 월 데이터만 초기화 - 주, 일 조회시 해당 주, 일만 초기화 해야함.
//    [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[self getMonthFirstDate:self.currentDate] dateFormat:@"yyyyMM"]];

    // 타인 일졍일경우.
    if ( [[model.scheduleOwnerInfo notNilObjectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        callUrl = URL_getSharedAppointmentList;
        [requestDictionary setObject:[model.scheduleOwnerInfo notNilObjectForKey:@"sharedemail"] forKey:@"sharedemail"];
    }
    
    
    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    if (!result) {
        // error occurred
    } 
	
}

- (void)receiveScheduleData {

		
	NSMutableArray *arrTemp = nil;

	// 여기서부터 테스트 데이터 
	// !주의  실제로 사용할 떄는 arrTemp를 꼭 릴리즈 해줄 것
	arrTemp = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    
    
//  여기는 테스트 데이터임.. 	
//	NSDictionary *dic = nil;
//	dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//           @"", @"appointmentid",
//           @"Y", @"isMy",
//		   @"20110611", @"DATE",
//		   @"테스트1", @"TITLE", nil];
//	
//	[arrTemp addObject:dic];
//	[dic release];
//	dic = nil;
//	dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//           @"", @"appointmentid",
//           @"Y", @"isMy",
//		   @"20110611", @"DATE",
//		   @"테스트2", @"TITLE", nil];
//	
//	[arrTemp addObject:dic];
//	dic = nil;
//	dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//           @"", @"appointmentid",
//           @"Y", @"isMy",
//		   @"20110612", @"DATE",
//		   @"테스트3", @"TITLE", nil];
//	
//	[arrTemp addObject:dic];
//	[dic release];
	
    
    
    
    // 테스트 데이터 끝
	
    //NSLog(@"scheduleList count[%d]",[scheduleList count]);
    for (NSDictionary *scheduleDic in scheduleList) {
        
        NSDictionary *dic = nil;
        NSString *appointmentid = [scheduleDic notNilObjectForKey:@"appointmentid"];
        NSString *starttime = [CalendarFunction getFormatYyyyMMdd:[scheduleDic notNilObjectForKey:@"starttime"]];
        NSString *title = [scheduleDic notNilObjectForKey:@"subject"];
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:
               appointmentid, @"appointmentid",
               starttime, @"DATE",
               title, @"TITLE", 
               scheduleDic, @"DATA", nil];
        
        [arrTemp addObject:dic];
        [dic release];
                
    }
    // linear한 데이터를 계층형으로 바꾼다.(컨트롤 하기 쉽게)
    [model setScheduleListDicWithLinearData:arrTemp];
        
	
	// 첫번째 콜이라고 간주
	if (model.dateStoredStartbound == nil && model.dateStoredEndbound == nil) {
		model.dateStoredStartbound = [self getNextOrPrevMonthFirstDate:self.requestDate direction:-6];
		model.dateStoredEndbound  = [self getNextOrPrevMonthFirstDate:self.requestDate direction:5];
		self.selectedDate = [NSDate date];
		[self.tableView1 reloadData];

	} else {
		if ([CalendarFunction compare:self.requestDate to:model.dateStoredStartbound dateFormat:@"yyyyMM"] == NSOrderedAscending) {
			model.dateStoredStartbound = [self getNextOrPrevMonthFirstDate:self.requestDate direction:-6];
		}
		if ([CalendarFunction compare:self.requestDate to:model.dateStoredEndbound dateFormat:@"yyyyMM"] == NSOrderedDescending) {
			model.dateStoredEndbound  = [self getNextOrPrevMonthFirstDate:self.requestDate direction:5];
		}
	}
	
	//NSLog(@"dateStoredStartbound[%@], dateStoredEndbound[%@]", model.dateStoredStartbound, model.dateStoredEndbound);
    
    //NSLog(@"파싱결과 [%@]", model.scheduleListDic);
    
	[self redrawHasSchedule];
	
    
    //테이블도 리로드 해준다.
    [self.tableView1 reloadData];
    displayTypeSegmentedControl.enabled = YES;
    buttonEnable = YES; 

}


#pragma mark -
#pragma mark Local Method

- (void)setCalendarFrame {
	
	// 화면에 나타나야 하는 주가 몇개인지 체크 후 그에 맞춰서 캘린더를 늘려준다.
	int numberOfWeek = (currentDays + correctionValue) / 7;
	
	switch (numberOfWeek) {
		case 4: self.viewCalendarMain.frame = rect4WeekCalendar;
			break;
		case 5: self.viewCalendarMain.frame = rect5WeekCalendar;
			break;
		case 6: self.viewCalendarMain.frame = rect6WeekCalendar;
			break;
		default:
			break;
	}
	
//	self.tableView1.frame = CGRectMake(0, 
//									   44 + viewCalendarMain.frame.size.height,			// 상위 타이틀 + 달력바디
//									   320, 
//									   416 - viewCalendarMain.frame.size.height - 44 - 44);		// 전체 - 달력바디	- footer 높이.	
//	self.imageViewShadow.frame = CGRectMake(0,
//											44 + viewCalendarMain.frame.size.height,	// 상위 타이틀 + 달력바디
//											320, 
//											15);
//    NSLog(@"%f",self.tableView1.frame.origin.y );
    
//    NSLog(@"%f",self.viewCalendarMain.frame.size.height );
    tableView1.frame = CGRectMake(0, 88 + viewCalendarMain.frame.size.height,      // 상위 타이틀 + 달력바디
                                       768, 1004 - viewCalendarMain.frame.size.height - 44 - 88 - 44);		// 전체 - 달력바디	- footer 높이.	
    self.imageViewShadow.frame = CGRectMake(0,
											88 + viewCalendarMain.frame.size.height,	// 상위 타이틀 + 달력바디
											768, 
											15);

//    tempFrame.origin.y = (44 + [[NSString stringWithFormat:@"%f", viewCalendarMain.frame.size.height]intValue]);

//    NSLog(@"%f",self.tableView1.frame.origin.y );
//    NSLog(@"%f",self.viewCalendarMain.frame.size.height );

}

- (NSArray *)getCurrentYearMonthDay {

	NSString *strYearMonthDay = [CalendarFunction getStringFromDate:self.currentDate dateFormat:@"yyyyMMdd"];

	NSString *strYear  = [strYearMonthDay substringWithRange:NSMakeRange(0, 4)];	
	NSString *strMonth = [strYearMonthDay substringWithRange:NSMakeRange(4, 2)];	
	NSString *strDay   = [strYearMonthDay substringWithRange:NSMakeRange(6, 2)];
	
	
	return [[[NSArray alloc] initWithObjects:strYear, strMonth, strDay, nil] autorelease];
	
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

// 해당 달의 1일
- (NSDate *)getMonthFirstDate:(NSDate *)aDate {

	// 현재 일의 년월만 가져온다.
	NSString *strYearMonth = [CalendarFunction getStringFromDate:aDate dateFormat:@"yyyyMM"];	
	NSString *strFirstDay = [NSString stringWithFormat:@"%@01", strYearMonth];
	
	NSDate *retDate = [CalendarFunction getDateFromString:strFirstDay];
	
	return retDate;
	
}

// 해달 달의 마지막 날
- (NSDate *)getMonthLastDate:(NSDate *)aDate {
	
//	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//	
//	dateComponents.month = 1;
//	dateComponents.day	 = -1;
//	
//	NSDate *dateMonthLastDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
//																				toDate:aDate 
//																			   options:0];
//	[dateComponents release];
//	dateComponents = nil;
//	return dateMonthLastDate;
	
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:aDate]; // Get necessary date components
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:aDate]; // Get necessary date components
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSLog(@"%@", tDateMonth);
    
    return tDateMonth;

}

/*!
    @function
    @abstract   해당 일자를 포함하는 한주의 시작과 끝 일자를 구한다.
    @discussion 해당 일자를 포함하는 한주의 시작과 끝 일자를 구한다. !주의 release 필요
    @param      aDate :NSDate 타입 또는 yyyyMMdd포멧의 NSString타입
    @result     aDate를 포함하는 일요일과 토요일의 일자(NSDate형)를 반환
*/

- (NSArray *)getWeekRangeAtDate:(id)aDate {
	
	NSDate *date = nil;

	if ([aDate isKindOfClass:[NSDate class]]) {
		date = aDate;
	} else if ([aDate isKindOfClass:[NSString class]]) {
		date = [CalendarFunction getDateFromString:aDate];
	} else {
		return nil;
	}
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:date];

	NSInteger intWeekDay = [comp weekday];
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	// 일요일
	dateComponents.day = -intWeekDay + 1;
	NSDate *dateWeekFirstDay = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																			 toDate:date 
																			options:0];
	// 토요일
	dateComponents.day = 7 - intWeekDay;
	NSDate *dateWeekLastDay  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																			 toDate:date 
																			options:0];
	
	[dateComponents release];
	
	return [[[NSArray alloc] initWithObjects:dateWeekFirstDay, dateWeekLastDay, nil] autorelease];
	
}

// 1일이 일요일인지 말일이 토요일인지 판단
- (void)judgeFirstDaySundayAndLastDaySatDay:(NSDate *)aDate {
	
	NSDate *dateFirstDay = [self getMonthFirstDate:aDate];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:dateFirstDay];
	
	NSInteger intWeekDay = [comp weekday];
	
	correctionValue = 0;
	
	if (intWeekDay == 1) {	// 일요일
		isFirstDaySunDay = YES;
	} else {
		correctionValue += intWeekDay - 1;
		isFirstDaySunDay = NO;
	}
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	dateComponents.month = 1;
	dateComponents.day = -1;
	NSDate *dateWeekLastDay  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																			 toDate:dateFirstDay 
																			options:0];
	[dateComponents release];
	dateComponents = nil;
	
	comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:dateWeekLastDay];
	
	intWeekDay = [comp weekday];
	
	if (intWeekDay == 7) {	// 토요일
		isLastDaySatDay = YES;
	} else {
		correctionValue += 7 - intWeekDay;
		isLastDaySatDay = NO;
	}
	NSTimeInterval timeInterval = [dateWeekLastDay timeIntervalSinceDate:dateFirstDay];
	currentDays = timeInterval / (60 * 60 * 24);
	currentDays = currentDays + 1;
	
}

- (void)rearrangeRingTypeQueueButtonListWithDirection:(int)direction {
	
	// 현재 달의 일수 + 보정일수 / 7 이 현재 달의 총 주(week) 수
	int numberOfweek = (currentDays + correctionValue) / 7;
	
	switch (direction) {
			
		case -1: {	// 왼쪽 버튼이 눌린 경우
			int index = [arrWeekViewPool indexOfObject:bottomWeekView];
			
			// 큐와 포지션을 변경하여 마지막 인덱스로 만든다.
			for (int i = index; i < SPOOL_MAX_INDEX; i++) {
				
				int currentIndex = [arrWeekViewPool indexOfObject:bottomWeekView];
				
				// 꼬리에서 뽑아서 머리로 보낸다.
				CalendarWeekView *weekView = [arrWeekViewPool dequeueFromHeader:NO];
				[arrWeekViewPool enqueue:weekView toHeader:YES];
				
				weekView.frame = CGRectMake(weekView.frame.origin.x, 
											CALENDAR_DAY_CELL_HEIGHT * (numberOfweek - (currentIndex + 2)), 
											weekView.frame.size.width,
											weekView.frame.size.height);
				
			}
		} break;
			
		case 1: {	// 오른쪽 버튼이 눌린 경우
			int index = [arrWeekViewPool indexOfObject:topWeekView];
			
			// 큐와 포지션을 변경하여 첫번째 인덱스로 만든다.
			for (int i = index; i > 0; i--) {
				
				int currentIndex = [arrWeekViewPool indexOfObject:topWeekView];
				
				// 머리에서 뽑아서 꼬리로 보낸다.
				CalendarWeekView *weekView = [arrWeekViewPool dequeueFromHeader:YES];
				[arrWeekViewPool enqueue:weekView toHeader:NO];
				
				weekView.frame = CGRectMake(weekView.frame.origin.x, 
											CALENDAR_DAY_CELL_HEIGHT * (SPOOL_CAPACITY - currentIndex), 
											weekView.frame.size.width,
											weekView.frame.size.height);
				
			}
		}	break;
		default :
			break;
	}
}

- (void)rearrangeCalendarWithDicrection:(int)direction {

    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

    
	// 현재 달의 일수 + 보정일수 / 7 이 현재 달의 총 주(week) 수
	int numberOfweek = (currentDays + correctionValue) / 7;
	
	switch (direction) {
			
		case -1: {	// 왼쪽 버튼이 눌린 경우
			
			// 큐를 정리
			[self rearrangeRingTypeQueueButtonListWithDirection:-1];

			// bottomWeekView 인덱스를 가져온다.
			int index = [arrWeekViewPool indexOfObject:bottomWeekView];
			
			// 현재달의 마지막날을 기준으로 일자를 세팅한다.
			NSDate *dateLastDay = [self getMonthLastDate:self.currentDate];
			NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:dateLastDay];
			
			[self setWeekWithDirection:-1 :[arrWeekRangeAtDate objectAtIndex:1]];

			index = index - numberOfweek + (isFirstDaySunDay == YES ? 0 : 1);	
			
			self.currentDate = [self getNextOrPrevMonthFirstDate:self.currentDate direction:-1];

            
            
            
            // 날개 액션인 경우 강제로 이전달의 1일이 선택되게 한다.
            // 20110719 현재 달일경우 오늘 날짜 선택되게 한다.
            if (isButtonAction) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyyMMdd"];
                NSArray *arr = nil;
                if ([CalendarFunction compare:[NSDate date] to:self.currentDate dateFormat:@"yyyyMM"] == NSOrderedSame) {
                    
                    arr = [buttonsDic objectForKey:[dateFormat stringFromDate:[NSDate date]]];
                    if (arr != nil) {
                        selectedImageView.highlighted = NO;
                        
                        selectedImageView = [arr objectAtIndex:0];
                        selectedLabel = [arr objectAtIndex:1];
                        todayImageView = [arr objectAtIndex:0];
                        todayLabel = [arr objectAtIndex:1];
                    }
                    
                    self.selectedDate = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]];
                    
                } else {
                    arr = [buttonsDic objectForKey:[dateFormat stringFromDate:self.currentDate]];
                    if (arr != nil) {
                        selectedImageView.highlighted = NO;
                        
                        selectedImageView = [arr objectAtIndex:0];
                        selectedLabel = [arr objectAtIndex:1];
                    }
                    
                    self.selectedDate = self.currentDate;
                }
                
                [dateFormat release];
                dateFormat = nil;
                
                [tableView1 reloadData];
                
            }
            
            
//			// 날개 액션인 경우 강제로 이전달의 1일이 선택되게 한다. 
//			if (isButtonAction) {
//				
//				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//				[dateFormat setDateFormat:@"yyyyMMdd"];
//				NSArray *arr = nil;
//				if ([CalendarFunction compare:[NSDate date] to:self.currentDate dateFormat:@"yyyyMM"] == NSOrderedSame) {
//					
//					arr = [buttonsDic objectForKey:[dateFormat stringFromDate:[NSDate date]]];
//					if (arr != nil) {
//						selectedImageView.highlighted = NO;
//						
//						selectedImageView = [arr objectAtIndex:0];
//						selectedLabel = [arr objectAtIndex:1];
//						todayImageView = [arr objectAtIndex:0];
//						todayLabel = [arr objectAtIndex:1];
//					}
//					
//				} else {
//					arr = [buttonsDic objectForKey:[dateFormat stringFromDate:self.currentDate]];
//					if (arr != nil) {
//						selectedImageView.highlighted = NO;
//						
//						selectedImageView = [arr objectAtIndex:0];
//						selectedLabel = [arr objectAtIndex:1];
//					}
//				}
//
//				[dateFormat release];
//				dateFormat = nil;
//				
//				self.selectedDate = self.currentDate;
//				[tableView1 reloadData];
//			}
			
			// 현재달이 몇주이며, 첫날과 마지막날이 일요일과 토요일인지 판단한다.
			[self judgeFirstDaySundayAndLastDaySatDay:self.currentDate];
			
			numberOfweek = (currentDays + correctionValue) / 7;
			
			// 마지막 날이 토요일
			int correctWeek = 0;
			if (!isLastDaySatDay) {
				correctWeek = 1;
			}
			
			// 스크롤 애니메이션이 시작하면 각종 이벤트가 안들어오게 막아논다.
			isScrollAnimating = YES;
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(scrollingAnimationDidStop)];
			[UIView setAnimationDuration:TFUIViewAnimationDuration];
			
			for (CalendarWeekView *weekView in arrWeekViewPool) {
				weekView.frame = CGRectMake(weekView.frame.origin.x, 
											weekView.frame.origin.y + CALENDAR_DAY_CELL_HEIGHT * (numberOfweek - correctWeek), 
											weekView.frame.size.width,
											weekView.frame.size.height);
			}

			// 캘린더의 프레임을 다시 설정한다.
			[self setCalendarFrame];
			
			[UIView commitAnimations];
			
			[self redrawCalendar];
			
			bottomWeekView = [arrWeekViewPool objectAtIndex:index];
			topWeekView	   = [arrWeekViewPool objectAtIndex:(index - (numberOfweek - 1))];
			
			NSArray *arrCurrentYearMonthDay = [self getCurrentYearMonthDay];
			
            if ( isKr ) {
                label1.text = [NSString stringWithFormat:@"%@년 %@월", 
                               [arrCurrentYearMonthDay objectAtIndex:0],
                               [arrCurrentYearMonthDay objectAtIndex:1]];    
            } else {
                label1.text = [NSString stringWithFormat:@"%@. %@", 
                               [arrCurrentYearMonthDay objectAtIndex:0],
                               [arrCurrentYearMonthDay objectAtIndex:1]];
            }
            
			
			
			// 이미 받아온 일정 
			if ([CalendarFunction compare:self.currentDate to:model.dateStoredStartbound dateFormat:@"yyyyMM"] == NSOrderedSame) {
				// 내년꺼 받아오게 한다.
				self.requestDate = [self getNextOrPrevMonthFirstDate:self.currentDate direction:-6];
				[self requestScheduleData];
			}
			
		}	break;
			
		case 1: {	// 오른쪽 버튼이 눌린 경우
			
			// 큐를 정리
			[self rearrangeRingTypeQueueButtonListWithDirection:1];

			// topWeekView의 인덱스를 가져온다.
			int index = [arrWeekViewPool indexOfObject:topWeekView];
			
			// 현재달의 첫날을 기준으로 일자를 세팅한다.
			NSDate *dateFirstDay = [self getMonthFirstDate:self.currentDate];
			NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:dateFirstDay];
			
			[self setWeekWithDirection:1 :[arrWeekRangeAtDate objectAtIndex:1]];

			// 다음달 topWeekView의 인덱스를 잡아 놓는다.
			index = index + numberOfweek - (isLastDaySatDay == YES ? 0 : 1);
			
			// 현재달을 다음달로 바꾼다.
			self.currentDate = [self getNextOrPrevMonthFirstDate:self.currentDate direction:1];
			
            
            
            // 날개 액션인 경우 강제로 이전달의 1일이 선택되게 한다.
            // 20110719 현재 달일경우 오늘 날짜 선택되게 한다.
            if (isButtonAction) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyyMMdd"];
                NSArray *arr = nil;
                if ([CalendarFunction compare:[NSDate date] to:self.currentDate dateFormat:@"yyyyMM"] == NSOrderedSame) {
                    
                    arr = [buttonsDic objectForKey:[dateFormat stringFromDate:[NSDate date]]];
                    if (arr != nil) {
                        selectedImageView.highlighted = NO;
                        
                        selectedImageView = [arr objectAtIndex:0];
                        selectedLabel = [arr objectAtIndex:1];
                        todayImageView = [arr objectAtIndex:0];
                        todayLabel = [arr objectAtIndex:1];
                    }
                    
                    self.selectedDate = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]];
                    
                } else {
                    arr = [buttonsDic objectForKey:[dateFormat stringFromDate:self.currentDate]];
                    if (arr != nil) {
                        selectedImageView.highlighted = NO;
                        
                        selectedImageView = [arr objectAtIndex:0];
                        selectedLabel = [arr objectAtIndex:1];
                    }
                    
                    self.selectedDate = self.currentDate;
                }
                
                [dateFormat release];
                dateFormat = nil;
                
                [tableView1 reloadData];
                
            }
            
			
//			// 날개 액션인 경우 강제로 이전달의 1일이 선택되게 한다. 
//			if (isButtonAction) {
//				
//				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//				[dateFormat setDateFormat:@"yyyyMMdd"];
//				NSArray *arr = nil;
//				if ([CalendarFunction compare:[NSDate date] to:self.currentDate dateFormat:@"yyyyMM"] == NSOrderedSame) {
//					
//					arr = [buttonsDic objectForKey:[dateFormat stringFromDate:[NSDate date]]];
//					if (arr != nil) {
//						selectedImageView.highlighted = NO;
//						
//						selectedImageView = [arr objectAtIndex:0];
//						selectedLabel = [arr objectAtIndex:1];
//						todayImageView = [arr objectAtIndex:0];
//						todayLabel = [arr objectAtIndex:1];
//					}
//					
//				} else {
//					arr = [buttonsDic objectForKey:[dateFormat stringFromDate:self.currentDate]];
//					if (arr != nil) {
//						selectedImageView.highlighted = NO;
//						
//						selectedImageView = [arr objectAtIndex:0];
//						selectedLabel = [arr objectAtIndex:1];
//					}
//				}
//				
//				[dateFormat release];
//				dateFormat = nil;
//				
//				self.selectedDate = self.currentDate;
//				[tableView1 reloadData];
//				
//			}
			// 주의! 이하 현재달은 다음달임
			
			// 현재달이 몇주이며, 첫날과 마지막날이 일요일과 토요일인지 판단한다.
			[self judgeFirstDaySundayAndLastDaySatDay:self.currentDate];
			
			numberOfweek = (currentDays + correctionValue) / 7;
			
			// 스크롤 애니메이션이 시작하면 각종 이벤트가 안들어오게 막아논다.
			isScrollAnimating = YES;
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(scrollingAnimationDidStop)];
			[UIView setAnimationDuration:TFUIViewAnimationDuration];
			
			for (CalendarWeekView *weekView in arrWeekViewPool) {
				weekView.frame = CGRectMake(weekView.frame.origin.x, 
											weekView.frame.origin.y - CALENDAR_DAY_CELL_HEIGHT * index, 
											weekView.frame.size.width,
											weekView.frame.size.height);
			}
			
			// 캘린더의 프레임을 다시 설정한다.
			[self setCalendarFrame];
			
			[UIView commitAnimations];
			
			[self redrawCalendar];
			
			topWeekView		= [arrWeekViewPool objectAtIndex:index];
			bottomWeekView	= [arrWeekViewPool objectAtIndex:(index + (numberOfweek - 1))];
			
			NSArray *arrCurrentYearMonthDay = [self getCurrentYearMonthDay];
			
            if ( isKr ) { 
                label1.text = [NSString stringWithFormat:@"%@년 %@월", 
                               [arrCurrentYearMonthDay objectAtIndex:0],
                               [arrCurrentYearMonthDay objectAtIndex:1]];
            } else {
                label1.text = [NSString stringWithFormat:@"%@. %@", 
                               [arrCurrentYearMonthDay objectAtIndex:0],
                               [arrCurrentYearMonthDay objectAtIndex:1]];
            }
			

			// 이미 받아온 일정 
			if ([CalendarFunction compare:self.currentDate to:model.dateStoredEndbound dateFormat:@"yyyyMM"] == NSOrderedSame) {
				// 내년꺼 받아오게 한다.
				self.requestDate = [self getNextOrPrevMonthFirstDate:self.currentDate direction:7];
				[self requestScheduleData];
			}
			
		}	break;
		default:
			break;
	}
	//달이 이동 하였으면 데이터를 다시 수신하자.
    [self requestScheduleData];
	
}

- (void)redrawCalendar {
	
	for (NSString *buttonsInfoKey in [buttonsDic allKeys]) {
		NSArray *arr = [buttonsDic objectForKey:buttonsInfoKey];
		
		if (arr != nil) {
			[[arr objectAtIndex:0] setImage:[UIImage imageNamed:@"calendar_default_off@2x.png"]];
			[[arr objectAtIndex:0] setHighlightedImage:[UIImage imageNamed:@"calendar_default_on@2x.png"]];
			if ([CalendarFunction compare:[buttonsInfoKey substringWithRange:NSMakeRange(0, 6)] to:self.currentDate dateFormat:@"yyyyMM"] != NSOrderedSame) {
				[[arr objectAtIndex:1] setTextColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0]];
			} else {
				[[arr objectAtIndex:1] setTextColor:[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0]];
			}
		}
	}	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSArray *todayArr = [buttonsDic objectForKey:[dateFormat stringFromDate:[NSDate date]]];
	
	selectedImageView.highlighted = YES;
	selectedLabel.textColor = [UIColor whiteColor];
	
	if (todayArr != nil) {
		todayImageView = [todayArr objectAtIndex:0];
		todayLabel	   = [todayArr objectAtIndex:1];
		
		todayImageView.image = [UIImage imageNamed:@"calendar_today_off.png"];
		todayImageView.highlightedImage = [UIImage imageNamed:@"calendar_today_on.png"];
		
		todayLabel.textColor = [UIColor whiteColor];
	} else {
		todayImageView = nil;
		todayLabel	   = nil;
	}

	[self redrawHasSchedule];
	
	[dateFormat release];
	dateFormat = nil;
}

// 스케쥴이 있는 날에는 버튼을 그려준다.
- (void)redrawHasSchedule {
	
	// 이런식으로 무식하게 하면 안되는데...
	
	for (UIImageView *imageView in hasScheduleImageViews) {
		imageView.hidden = YES;
	}
	[hasScheduleImageViews removeAllObjects];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMM"];
	
	NSString *strPrevMonth	  = [dateFormat stringFromDate:[self getNextOrPrevMonthFirstDate:self.currentDate direction:-1]];
	NSString *strCurrentMonth = [dateFormat stringFromDate:self.currentDate];
	NSString *strNextMonth	  = [dateFormat stringFromDate:[self getNextOrPrevMonthFirstDate:self.currentDate direction:1]];
	
	NSArray *keys = nil;
	
	keys = [[model.scheduleListDic objectForKey:strPrevMonth] allKeys];
	
	if (keys != nil) {
		for (NSString *keyDay in keys) {
			NSArray *arrButtonInfo = [buttonsDic objectForKey:keyDay];
			
			if (arrButtonInfo != nil) {
				[[arrButtonInfo objectAtIndex:2] setHidden:NO];
				[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_lightgray.png"]];
				
				if ([CalendarFunction compare:keyDay to:[NSDate date]] == NSOrderedSame) {
					[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_white.png"]];
				}
				
				[hasScheduleImageViews addObject:[arrButtonInfo objectAtIndex:2]];
			}
		}
	}
	
	keys = [[model.scheduleListDic objectForKey:strCurrentMonth] allKeys];
	
	if (keys != nil) {
		for (NSString *keyDay in keys) {
			NSArray *arrButtonInfo = [buttonsDic objectForKey:keyDay];
			
			if (arrButtonInfo != nil) {
				[[arrButtonInfo objectAtIndex:2] setHidden:NO];
				[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_gray.png"]];
				
				if ([CalendarFunction compare:keyDay to:[NSDate date]] == NSOrderedSame ||
					[CalendarFunction compare:keyDay to:self.selectedDate] == NSOrderedSame) {
					[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_white.png"]];
				}
				
				[hasScheduleImageViews addObject:[arrButtonInfo objectAtIndex:2]];
			}
		}
	}
	
	keys = [[model.scheduleListDic objectForKey:strNextMonth] allKeys];
	
	if (keys != nil) {
		for (NSString *keyDay in keys) {
			NSArray *arrButtonInfo = [buttonsDic objectForKey:keyDay];
			
			if (arrButtonInfo != nil) {
				[[arrButtonInfo objectAtIndex:2] setHidden:NO];
				[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_lightgray.png"]];
				
				if ([CalendarFunction compare:keyDay to:[NSDate date]] == NSOrderedSame) {
					[[arrButtonInfo objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_white.png"]];
				}
				
				[hasScheduleImageViews addObject:[arrButtonInfo objectAtIndex:2]];
			}
		}
	}
	
	[dateFormat release];
	dateFormat = nil;
	
}

- (void)gotoSomeDayWithDate:(NSDate *)aDate {

    // 이렇게 고쳐야지.
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

    
    
	// redrawing이므로 선택된 이미지뷰와 라벨은 없는걸로 한다.
	selectedImageView.highlighted = NO;
	selectedImageView = nil;	todayImageView = nil;
	selectedLabel	  = nil;	todayLabel	   = nil;
	
	// selectedDate도 초기화 해논다.
	selectedDate = nil;
	
	// Ring형 큐를 재배열한다.
	[self rearrangeRingTypeQueueButtonListWithDirection:1];

	// 가장 위 WeekView를 큐의 0번 인덱스로 잡아 놓는다.
	topWeekView = [arrWeekViewPool objectAtIndex:0];
	
	// 현재달의 첫날을 구한다.
	self.currentDate = [self getMonthFirstDate:aDate];
	
	// 현재달의 첫날을 기준으로 일자를 세팅한다.
	NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:self.currentDate];
	
	// 버튼에 대한 정보와 날짜를 세팅
	[self setWeekWithDirection:1 :[arrWeekRangeAtDate objectAtIndex:1]];
	
	// 현재달이 몇주이며, 첫날과 마지막날이 일요일과 토요일인지 판단한다.
	[self judgeFirstDaySundayAndLastDaySatDay:self.currentDate];
	
	// 화면상에서 가장 아랫 WeekView를 잡아 놓는다.
	bottomWeekView = [arrWeekViewPool objectAtIndex:(0 + ((currentDays + correctionValue) / 7) - 1)];
	
	// 캘린더의 프레임을 다시 설정한다.
	[self setCalendarFrame];
	
    if ( isKr ) {
        label1.text = [NSString stringWithFormat:@"%@년 %@월", 
                       [[self getCurrentYearMonthDay] objectAtIndex:0],
                       [[self getCurrentYearMonthDay] objectAtIndex:1]];
        
    } else {
        label1.text = [NSString stringWithFormat:@"%@. %@", 
                       [[self getCurrentYearMonthDay] objectAtIndex:0],
                       [[self getCurrentYearMonthDay] objectAtIndex:1]];
    }
    
	
	// 선택한 날짜가 눌렀다고 액션을 보낸다.
	[self dayButtonDidPush:nil :aDate];
	
}

- (void)setWeekWithDirection:(int)direction :(NSDate *)aDateLastDay {
	
	[buttonsDic removeAllObjects];
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	switch (direction) {
			
		case 1: {
			for (int i = 0; i < [arrWeekViewPool count]; i++) {
				
				dateComponents.day = 1 + 7 * (i - 1);
				NSDate *dateWeekFirstDay = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																						 toDate:aDateLastDay 
																						options:0];
				
				NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:dateWeekFirstDay];
				[buttonsDic setValuesForKeysWithDictionary:[(CalendarWeekView *)[arrWeekViewPool objectAtIndex:i] setDays:arrWeekRangeAtDate]];
				
			}
		}	break;
			
		default: {
			for (int i = SPOOL_MAX_INDEX; i >= 0; i--) {
				
				dateComponents.day = -7 * (SPOOL_MAX_INDEX - i);
				NSDate *dateWeekFirstDay = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																						 toDate:aDateLastDay 
																						options:0];
				NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:dateWeekFirstDay];
				[buttonsDic setValuesForKeysWithDictionary:[(CalendarWeekView *)[arrWeekViewPool objectAtIndex:i] setDays:arrWeekRangeAtDate]];
				
			}
		}	break;
			
	}
	
	
	[dateComponents release];
	dateComponents = nil;
	
	[self redrawCalendar];
	
}
#pragma mark -
#pragma mark listNoti
- (void)mainListNoti{
    // 현재 날짜와 시간.
	NSDate *now = [[NSDate alloc] init];
	
    // 날짜 포맷.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	
	NSString *theDate = [dateFormat stringFromDate:now];
//	NSLog(@"theDate[%@]",theDate);
    NSString *selectedMonth = [theDate substringToIndex:6];
	NSArray *arrSelectedDateSchedules = [[model.scheduleListDic objectForKey:selectedMonth] objectForKey:theDate];
//    NSLog(@"model.scheduleListDic count[%d]",[model.scheduleListDic count] );
//    NSLog(@"%@",todayButton.title) ;
//    NSLog(@"%@",model) ;

//	if ([model.scheduleListDic count]>0) {
//        NSLog(@"model.scheduleListDic count[%d]",[model.scheduleListDic count] );
//        if ([arrSelectedDateSchedules count] > 0) {
//            [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[self getMonthFirstDate:self.currentDate] dateFormat:@"yyyyMM"]];
//            [self requestScheduleData]; 
//            [self redrawHasSchedule];
//
//        }
//    }else{
//
//    }
    if (listNoti == NO) {
        listNoti = YES;
    } else if(listNoti == YES){
        if ([model.scheduleListDic count]>0) {
//            NSLog(@"model.scheduleListDic count[%d]",[model.scheduleListDic count] );
            if ([arrSelectedDateSchedules count] > 0) {
                [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[self getMonthFirstDate:self.currentDate] dateFormat:@"yyyyMM"]];
                [self requestScheduleData]; 
                [self redrawHasSchedule];
                
            }
        }else{
            
        }

    }
	[dateFormat release];
	[now release];
    

}
    
#pragma mark -
#pragma mark TFCalendarDelegate Implement

- (void)dayButtonDidPush:(id)sender 
						:(NSDate *)aSelectedDate {

	// 스크롤 애니메이션 중이면 아무것도 하지 않는다.
	if (isScrollAnimating) {
		return;
	}
    //NSLog(@"aSelectedDate[%@]", aSelectedDate);	
	model.selectedDate = aSelectedDate;
	
	NSString *strSelectedDate = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	
	if ([buttonsDic objectForKey:strSelectedDate] != nil &&
		[[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate] != nil &&
		[CalendarFunction compare:strSelectedDate to:[NSDate date] dateFormat:@"yyyyMMdd"] != NSOrderedSame &&
		selectedImageView != nil) {
		
		NSArray *arr = [buttonsDic objectForKey:strSelectedDate];
		
		[[arr objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_gray.png"]];
	}
	
	// 선택되어 있던 이미지는 
	if (selectedImageView != nil && selectedLabel != nil) {
		
		if ([selectedImageView isEqual:todayImageView] && [selectedLabel isEqual:todayLabel]) {
		} else {
			selectedLabel.textColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
		}
		selectedImageView.highlighted = NO;

	}
	
	self.selectedDate = aSelectedDate;
	
	// 눌려진 버튼의 정보를 가져 온다.
	strSelectedDate = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	NSArray *arr = [buttonsDic objectForKey:strSelectedDate];
	
	if (arr != nil) {
		
		selectedImageView = [arr objectAtIndex:0];
		selectedLabel	  = [arr objectAtIndex:1];
		
	}
	
	
	NSComparisonResult direction = [CalendarFunction compare:aSelectedDate to:self.currentDate dateFormat:@"yyyyMM"];
	
	// 현재 보여지고 있는 달의 날짜가 눌렸을 경우에는 이쪽에서 드로잉을 해준다.
	if (direction == NSOrderedSame) {
		
		if ([CalendarFunction compare:[NSDate date] to:aSelectedDate] == NSOrderedSame) {
			selectedImageView.image = [UIImage imageNamed:@"calendar_today_off.png"];
			selectedImageView.highlightedImage = [UIImage imageNamed:@"calendar_today_on.png"];
		} else {
			selectedImageView.image = [UIImage imageNamed:@"calendar_default_off@2x.png"];
			selectedImageView.highlightedImage = [UIImage imageNamed:@"calendar_default_on@2x.png"];
		}
		selectedImageView.highlighted = YES;
		selectedLabel.textColor = [UIColor whiteColor];
		
	} else {
		[self rearrangeCalendarWithDicrection:direction];
	}
	
	strSelectedMonth = [strSelectedDate substringToIndex:6];
	if ([buttonsDic objectForKey:strSelectedDate] != nil &&
		[[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate] != nil) {
		
		NSArray *arr = [buttonsDic objectForKey:strSelectedDate];
		
		[[arr objectAtIndex:2] setImage:[UIImage imageNamed:@"calendar_dot_white.png"]];
	}

    
	[self.tableView1 reloadData];
	
}

#pragma mark -
#pragma mark Footer Action Method
- (IBAction)todayButtonDidPush:(id)sender {
    
    [currentDate release];
	currentDate = nil;
	currentDate = [[NSDate date] copy];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                toDate:[CalendarFunction getDateFromString:
                                                                        [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"]]
                                                               options:0];
    [dateComponents release];
    dateComponents = nil;
    
    // 선택되어진 날짜 화면에 뿌려준다.
    model.selectedDate = [currentDate copy];

    [self gotoSomeDayWithDate:currentDate];
    
    
    
    
    
//	[self gotoSomeDayWithDate:[NSDate date]];
    [self redrawHasSchedule]; // 일정을 드로잉한다.
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];
    
    NSString *schMonth  = [dateFormat stringFromDate:currentDate];
	
    if ( [model.scheduleListDic objectForKey:schMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
    } else {
        [self redrawHasSchedule];
		[self requestScheduleData];
        
    }

}
#pragma mark -
#pragma mark AlertView Method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // if URL open alert
    if(alertView.tag == 5555) {

        model.selectedDisplayType = -1;
        
        Class targetClass = NSClassFromString(@"CalendarMemberViewController");
        
        id viewController = [[targetClass alloc] initWithNibName:@"CalendarMemberViewController" bundle:nil]; 
        
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewController];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
        [navBar release];
        navBar = nil;
        [viewController release];
        viewController = nil;
    }
    
}

#pragma mark -
#pragma mark Action Method

- (IBAction)buttonDidPush:(id)sender {
    if (buttonEnable == YES) {
        // 스크롤 애니메이션 중이면 아무것도 하지 않는다.
        if (isScrollAnimating) {
            return ;
        }
        isButtonAction = YES;
        switch ([sender tag]) {
                
            case 1: {	// 왼쪽 버튼이 눌린 경우
                [self rearrangeCalendarWithDicrection:-1];
            }	break;
            case 2: {	// 오른쪽 버튼이 눌린 경우
                [self rearrangeCalendarWithDicrection:1];
            }	break;
            default:
                break;
        }
        
        isButtonAction = NO;

    }

	
}

- (IBAction) refreshCallCalendar:(id)sender {
    if (buttonEnable == YES) {
        [self requestScheduleData];
    }
}

#pragma mark -
#pragma mark CallBack Method

// 오른쪽 내비게이션 버튼이 눌렸을 때
- (void)naviRigthbtnPress:(id)sender {
    if ( model.selectedDate == nil ) {
        //[self gotoSomeDayWithDate:[NSDate date]]; // 선택 날짜가 없다면 일단 오늘 날짜 셀렉트 걸어준다.
        
        // 오늘 날짜를 .. NSDate date] -1 값에 시간은 15:00 로 셋팅하자.
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.day = -1;
        //[dateComponents setHour:15];
        model.selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                           toDate:[NSDate date] 
                                                                          options:0];
        [dateComponents release];
        dateComponents = nil;
        
    }
    
	[super pushViewController:@"CalendarScheduleRegisterViewController"];

}

// 왼쪽 내비게이션 버튼이 눌렸을 때 툴바에서 공통 처리됨.
//- (void)backButtonDidPush:(id)sender {
//}

- (void)scrollingAnimationDidStop {
	isScrollAnimating = NO;
}

#pragma mark -
#pragma mark UIActionSheetDelegate Implement

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
	} else {
	}

}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 88.0;	// default height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	model.selectedDateString = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	model.selectedDateIndex  = indexPath.row;
	
    
    //NSLog(@"selected Data Index = [%d]", model.selectedDateIndex);
    
    //일정 상세 보기 화면으로 이동한다.
    //key value = appointmentid
    //data dic = DATA
    
    //일단 모델에 값을 파싱하여 넣어준다.
    NSString *strSelectedDate = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
    //NSLog(@"strSelectedMonth[%@]strSelectedDate[%@]",strSelectedMonth,strSelectedDate);	
	NSArray *arrSelectedDateSchedule = [[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
    
//    NSLog(@"asdfasdfasdf[%@]",arrSelectedDateSchedule);
    if ( [arrSelectedDateSchedule objectAtIndex:indexPath.row] == nil ) {
        //일정없음.
    } else {
//        model.viewSchedule = [arrSelectedDateSchedule objectAtIndex:indexPath.row];
//        [super pushViewController:@"CalendarScheduleReadViewController"];
        
        
        [super pushViewController:@"CalendarScheduleReadViewController"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainScheduleRead" object:[[arrSelectedDateSchedule objectAtIndex:indexPath.row]objectForKey:@"appointmentid"]];

    }
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *strSelectedDate = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
    
    // 일정에 데이터 건수가 없을경우는 1을 리턴한다. (일정없음을 표현)
    if ( [[[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate] count] == 0 ) {
        return 1;
    } else {
        return [[[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";

	UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarMainListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarMainListCell")]) {
				cell = oneObject;
			}
		}
		
	}

	
    
	NSString *strSelectedDate = [CalendarFunction getStringFromDate:self.selectedDate dateFormat:@"yyyyMMdd"];
	NSString *strSelectedMonth = [strSelectedDate substringToIndex:6];
	NSArray *arrSelectedDateSchedule = [[model.scheduleListDic objectForKey:strSelectedMonth] objectForKey:strSelectedDate];
	NSDictionary *dic = [arrSelectedDateSchedule objectAtIndex:indexPath.row];
    
    CalendarMainListCell *tmpCell = (CalendarMainListCell *)cell;
	
    
    if ( dic == nil ) {
        //일정 없음
        tmpCell.label1.text = NSLocalizedString(@"calendar_no_event",@"일정없음");        
    } else {
        tmpCell.label1.text = [dic notNilObjectForKey:@"subject"];
    }
	
	return cell;
	
}

#pragma mark -
#pragma mark View Translation Process

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	//self.navigationLeftButton.hidden = YES;

    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        //타인 일정 호출의 경우
//        model.scheduleOwnerInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   @"YES", @"isMy",
//                                   [userDefault objectForKey:@"login_id"],@"loginid",
//                                   @"나의 일정",@"empnm",
//                                   @"",@"sharedemail",
//                                   nil];

        //타인 이라면 000님의 일정 으로 변경 되어야 한다.
        self.title = [NSString stringWithFormat:@"%@%@", [model.scheduleOwnerInfo notNilObjectForKey:@"empnm"], NSLocalizedString(@"calendar_xxxs_calendar",@"님의 일정")];
        
        // 오른쪽 일정 더하기 버튼 없다.
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    } else {
        self.title = NSLocalizedString(@"calendar_My_calendar",@"나의 일정");
        
        // 오른쪽 일정 더하기 버튼 생성 한다.
        // 오른쪽 + 버튼
        [super makeNavigationRightBarButtonWithBarButtonSystemItem:UIBarButtonSystemItemAdd];
    }
    
    
	//self.displayTypeSegmentedControl.selectedSegmentIndex = model.selectedDisplayType;
	//항상 월에 포커싱 시킨다. ( 이 화면은 메인화면..)
    self.displayTypeSegmentedControl.selectedSegmentIndex = 0;
    
    
	if (model.isNeedUpdateSelectedDate) {
        [self redrawHasSchedule];
		[self requestScheduleData];
		//[self gotoSomeDayWithDate:[CalendarFunction	getDateFromString:model.selectedDateString]];
        model.isNeedUpdateSelectedDate = NO;
	}
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];

    NSString *schMonth  = [dateFormat stringFromDate:currentDate];
	
    if ( [model.scheduleListDic objectForKey:schMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
    } else {
        [self redrawHasSchedule];
		[self requestScheduleData];

    }
    //변경분 반영을 위하여 테이블을 리로드 한다.
    [self.tableView1 reloadData];
    
//    NSLog(@"model.scheduleListDic count[%d]",[model.scheduleListDic count] );

    
}
#pragma mark -
#pragma mark XCode Generated

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    if (clipboard != nil) {
		[clipboard cancelCommunication];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"countryCode [%@]",[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]);
    //NSLog(@"language [%@]",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]);
    //NSLog(@"current language [%@]",[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]);
    // 이렇게 고쳐야지.
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	    
    //최초 Load는 나의 일정이다. 로그인 정보를 담아둔다.
    
    // ex) forKey "loginid" value "b55555555" : 로그인시 userid
    // ex) forKey "empnm" value "테스터" : 로그인후 username
    // ex) forKey "sharedemail" value "test@test.com" -> 타인 일정 조회시 이메일이 있어야함.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    model.scheduleOwnerInfo = nil;
    model.scheduleOwnerInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               @"YES", @"isMy",
                               [userDefault objectForKey:@"login_id"],@"loginid",
                               NSLocalizedString(@"calendar_My_calendar",@"나의 일정"),@"empnm",
                               @"",@"sharedemail",
                               nil];
    
    
        
    //타인 이라면 000님의 일정 으로 변경 되어야 한다.
	self.title = NSLocalizedString(@"calendar_My_calendar",@"나의 일정");
    	
	// 내비게이션 색깔을 바꾼다.
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	// 오른쪽 + 버튼
//	[super makeNavigationRightBarButtonWithBarButtonSystemItem:UIBarButtonSystemItemAdd]; //willAppear 에서
	
	// 왼쪽 홈 버튼
	//[super makeNavigationLeftBarButtonWithBarButtonSystemItem:UIBarButtonSystemItemCompose];
	
//	// 홈버튼
//	[super makeNavigationLeftBarButtonWithImageNamePrefix:@"btn_top_home" 
//										   selectedString:@"press" 
//										 unselectedString:@"" 
//										  extensionString:@"png"];
	
	
	model = [CalendarModel sharedInstance];
	[model resetModel];
    //최초 로드시에는 모델을 리셋한다.
    //if ( model.selectedDate == nil ) model.selectedDate = [NSDate date];
    //[self gotoSomeDayWithDate:[NSDate date]]; // 이걸 하면 selectedDate가 처리된다.
    
    
    
	buttonsDic = [[NSMutableDictionary alloc] init];
	hasScheduleImageViews = [[NSMutableArray alloc] init];
	
	rect4WeekCalendar = CGRectMake(viewCalendarMain.frame.origin.x,
								   viewCalendarMain.frame.origin.y, 
								   viewCalendarMain.frame.size.width, 
								   CALENDAR_DAY_CELL_HEIGHT * 4);	// 한주의 높이
	
	rect5WeekCalendar = CGRectMake(viewCalendarMain.frame.origin.x,
										  viewCalendarMain.frame.origin.y, 
										  viewCalendarMain.frame.size.width, 
										  CALENDAR_DAY_CELL_HEIGHT * 5);	// 한주의 높이
	
	rect6WeekCalendar = CGRectMake(viewCalendarMain.frame.origin.x,
										  viewCalendarMain.frame.origin.y, 
										  viewCalendarMain.frame.size.width, 
										  CALENDAR_DAY_CELL_HEIGHT * 6);	// 한주의 높이

	arrWeekViewPool = [[NSMutableArray alloc] initWithCapacity:SPOOL_CAPACITY];
	
	CGFloat weekViewYPoint = 0.0;
	
	// 일단 한주를 표현 할 수 있는 뷰를 SPOOL_CAPACITY개(최대 6주 표현가능 화면에 나타나지 않는 뷰는 버퍼로 이용)
	for (int i = 0; i < SPOOL_CAPACITY; i++) {
		
		NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:@"CalendarWeekView" owner:self options:nil];
		CalendarWeekView *viewWeek = (CalendarWeekView *)[arrViews objectAtIndex:0];
		
		viewWeek.frame = CGRectMake(viewWeek.frame.origin.x, 
									weekViewYPoint, 
									viewWeek.frame.size.width, 
									viewWeek.frame.size.height);
		viewWeek.calendarDelegate = self;						// 일련의 콜백처리는 이 ViewController에서 한다.
		
		[arrWeekViewPool enqueue:viewWeek toHeader:NO];		// 풀에 적재
		
		[viewCalendarMain addSubview:viewWeek];
		
		weekViewYPoint += CALENDAR_DAY_CELL_HEIGHT;	// 다음 week뷰의 weekViewYPoint를 설정
	}
	
	// 가장 위 WeekView를 큐의 0번 인덱스로 잡아 놓는다.
	topWeekView = [arrWeekViewPool objectAtIndex:0];
	
	// 현재달의 첫날을 구한다.
	self.currentDate = [self getMonthFirstDate:[NSDate date]];

	// 현재달의 첫날을 기준으로 일자를 세팅한다.
	NSArray *arrWeekRangeAtDate = [self getWeekRangeAtDate:self.currentDate];
	
	// 버튼에 대한 정보와 날짜를 세팅
	[self setWeekWithDirection:1 :[arrWeekRangeAtDate objectAtIndex:1]];
	
	// 일단 현재 날짜를 선택해논다.
	todayImageView.highlighted = YES;
	selectedImageView = todayImageView;
	selectedLabel = todayLabel;
	
	// 현재달이 몇주이며, 첫날과 마지막날이 일요일과 토요일인지 판단한다.
	[self judgeFirstDaySundayAndLastDaySatDay:self.currentDate];

	// 화면상에서 가장 아랫 WeekView를 잡아 놓는다.
	bottomWeekView = [arrWeekViewPool objectAtIndex:(0 + ((currentDays + correctionValue) / 7) - 1)];
	
	// 캘린더의 프레임을 다시 설정한다.
	[self setCalendarFrame];
	
    if ( isKr ) {
        label1.text = [NSString stringWithFormat:@"%@년 %@월", 
                       [[self getCurrentYearMonthDay] objectAtIndex:0],
                       [[self getCurrentYearMonthDay] objectAtIndex:1]];
	} else {
        label1.text = [NSString stringWithFormat:@"%@. %@", 
                       [[self getCurrentYearMonthDay] objectAtIndex:0],
                       [[self getCurrentYearMonthDay] objectAtIndex:1]];
	}
    
	
	// 모임방의 일정을 서버에 요청
	self.requestDate = self.currentDate;

    // 통신 초기화.
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    
    //최초 로그인시는 여기서 호출 한다.
    [self requestScheduleData];
    
    
    
    
    
    if ( model.selectedDate == nil ) {
        //[self gotoSomeDayWithDate:[NSDate date]]; // 선택 날짜가 없다면 일단 오늘 날짜 셀렉트 걸어준다.
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        //dateComponents.day = -1;
        //[dateComponents setHour:15];
        model.selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                           toDate:[CalendarFunction getDateFromString:
                              [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"]]
                                                                          options:0];
        [dateComponents release];
        dateComponents = nil;
        
    }
    //NSLog(@"model.selectedDate[%@], self.currentDate[%@]", model.selectedDate, self.currentDate);

    
    todayButton.title = NSLocalizedString(@"btn_today",@"오늘");
    todayButton.width = 45.0; //영문 크기고정.
    
    [modeListButton setTitle:NSLocalizedString(@"btn_month",@"월") forSegmentAtIndex:0];
    [modeListButton setTitle:NSLocalizedString(@"btn_week",@"주") forSegmentAtIndex:1];
    [modeListButton setTitle:NSLocalizedString(@"btn_date",@"일") forSegmentAtIndex:2];
    [modeListButton setTitle:NSLocalizedString(@"btn_list",@"목록") forSegmentAtIndex:3];
    
    modeListButton.frame = CGRectMake(modeListButton.frame.origin.x, modeListButton.frame.origin.y, 172.0, modeListButton.frame.size.height); // 영문 크기고정

    
    dayStr1.text = (isKr)?@"일":@"Sun";
    dayStr2.text = (isKr)?@"월":@"Mon";
    dayStr3.text = (isKr)?@"화":@"Tue";
    dayStr4.text = (isKr)?@"수":@"Wed";
    dayStr5.text = (isKr)?@"목":@"Thu";
    dayStr6.text = (isKr)?@"금":@"Fri";
    dayStr7.text = (isKr)?@"토":@"Sat";
    
    // 리스트에서 원래 달을 가져오는데 성능상의 문제로 수정 그래서 모델을 리프레쉬 하기위해서 노티 함수 만듬
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainListNoti) name:@"mainListNoti" object:nil];
//    NSLog(@"model.scheduleListDic count[%d]",[model.scheduleListDic count] );
    listNoti = NO;

}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.viewCalendarMain = nil;// 날짜 출력되는 부분
	self.label1 = nil;			// 현재달
	self.tableView1 = nil;		// 일정이 출력되는 리스트
	self.imageViewShadow = nil;	// 그림자
}

- (void)dealloc {
	
	[arrWeekViewPool release];
	[currentDate release];
	[selectedDate release];
	[requestDate release];
	
	[buttonsDic release];
	[hasScheduleImageViews release];
	
	[viewCalendarMain release];	// 날짜 출력되는 부분
	[label1 release];			// 현재달
	[tableView1 release];		// 일정이 출력되는 리스트
	[imageViewShadow release];	// 그림자

    [todayButton release]; //오늘버튼
    [modeListButton release];	// 월,주,일,목록
    [dayStr1 release];
    [dayStr2 release];
    [dayStr3 release];
    [dayStr4 release];
    [dayStr5 release];
    [dayStr6 release];
    [dayStr7 release];
    
    [super dealloc];
}


@end

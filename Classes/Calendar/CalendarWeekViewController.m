//
//  CalendarWeekViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarWeekViewController.h"
#import "CalendarWeekViewListCell.h"
#import "CalendarFunction.h"
#import "NSDictionary+NotNilReturn.h"
#import "CustomBadge.h"
#import "URL_Define.h"

@implementation CalendarWeekViewController

@synthesize tableView1;
@synthesize label1;

@synthesize clipboard; //주보기에서는 인디케이터 사용 안함.
@synthesize todayButton;
@synthesize modeListButton;	// 월,주,일,목록
@synthesize indicator;

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    buttonEnable = NO;
    displayTypeSegmentedControl.enabled = NO;
    //--- indicator setting ---//
    BOOL isIndicator = YES;
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [self.view bringSubviewToFront:uiView];
            isIndicator = NO;
        }
    }        
    if ( isIndicator ) {
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:indicator];
        indicator.center = self.view.center;
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

	//[indicator stopAnimating]; 주보기에서는 인디케이터 사용안함.
       
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
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
            
            //데이터를 표현한다.
            [self performSelector:@selector(receiveScheduleData)];
            
        } else {
            buttonEnable = YES; 
            displayTypeSegmentedControl.enabled = YES;
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
		return;		
        buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;
    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
        buttonEnable = YES; 
        displayTypeSegmentedControl.enabled = YES;
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
    [indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 

	//[indicator stopAnimating]; 주보기에선는 인디케이터 사용 안함.
        buttonEnable = YES;
    displayTypeSegmentedControl.enabled = YES;
}
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


#pragma mark -
#pragma mark Data Request & Receive

- (void)requestScheduleData {
	if (buttonEnable == NO) {
        return;
    }
    
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];
	
	//	SCH_MONTH	조회월			●	YYYYMM
	NSString *schMonth  = [dateFormat stringFromDate:currentDate];
    NSString *prevMonth = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]dateFormat:@"yyyyMM"];
    NSString *nextMonth = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:+1] ]dateFormat:@"yyyyMM"];
    
    NSLog(@"firstDay:%@", [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]dateFormat:@"yyyyMM"]);
    NSLog(@"lastDay:%@", [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:+1] ]dateFormat:@"yyyyMM"]);

    if ( [model.scheduleListDic objectForKey:schMonth] != nil && [model.scheduleListDic objectForKey:prevMonth] != nil && [model.scheduleListDic objectForKey:nextMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
        
        //주에서는 다음달 6일까지 data가 있기때문에 다시  조회함
//        int j = 0;
//        for (int i = 1; i < 7; i++) {
//            
//            
//            NSMutableArray *arr = [[model.scheduleListDic objectForKey:schMonth] objectForKey:[NSString stringWithFormat:@"%@0%d",schMonth,i ]];
//            
//            if (arr) {
//                j++;
//            } 
//            
//        }
//        int k = 0;
//        for (int l = 22; l < 32; l++) {
//            
//            
//            NSMutableArray *arr = [[model.scheduleListDic objectForKey:schMonth] objectForKey:[NSString stringWithFormat:@"%@%d",schMonth,l ]];
//            
//            if (arr) {
//                k++;
//            } 
//            
//        }
//
//        
//        
//        if (j > 0 || k > 0) {
//            buttonEnable = NO;
//            
//            // 통신을 새로 타면 스케줄을 초기화 해준다.
//            [model.scheduleListDic removeAllObjects];
//            // 스케줄을 초기화 하지 말고.. 해당 월 데이터만 초기화 - 주, 일 조회시 해당 주, 일만 초기화 해야함.
//            //        [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyyMM"]];
//            //        [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyyMM"]];
//            
//            
//            
//            //NSLog(@"조회 월 정보 [%@] 조회함", schMonth);
//            //Communication *
//            clipboard = [[Communication alloc] init];
//            clipboard.delegate = self;
//            NSString *callUrl = @"";
//            callUrl = URL_getAppointmentList; // 내일정
//            //callUrl = URL_getSharedAppointmentList; // 타인일정
//            NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//            //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
//            
//            //월 셋팅을 하자.
////            NSString *firstDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyy-MM-dd"];
////            NSString *lastDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyy-MM-dd"];
//            NSArray * firstarr= [self getWeekRangeAtDate:[CalendarFunction getMonthFirstDate:currentDate ]];
//            NSArray * lastarr= [self getWeekRangeAtDate:[CalendarFunction getMonthLastDate:currentDate ]];
//            
//            //        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
//            [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",[CalendarFunction getStringFromDate:[firstarr objectAtIndex:0]dateFormat:@"yyyy-MM-dd"]] forKey:@"starttime"];
//            
//            [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",[CalendarFunction getStringFromDate:[lastarr objectAtIndex:1]dateFormat:@"yyyy-MM-dd"] ] forKey:@"endtime"];
//            NSLog(@"firstDay:%@", [firstarr objectAtIndex:0]);
//            NSLog(@"lastDay:%@", [lastarr objectAtIndex:1]);
//
//            // 타인 일졍일경우.
//            if ( [[model.scheduleOwnerInfo notNilObjectForKey:@"isMy"] isEqualToString:@"NO"] ) {
//                callUrl = URL_getSharedAppointmentList;
//                [requestDictionary setObject:[model.scheduleOwnerInfo notNilObjectForKey:@"sharedemail"] forKey:@"sharedemail"];
//            }
//            
//            BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
//            if (!result) {
//                // error occurred
//            } 
//
//        }
    } else {
        buttonEnable = NO;
        
        // 통신을 새로 타면 스케줄을 초기화 해준다.
        [model.scheduleListDic removeAllObjects];
        // 스케줄을 초기화 하지 말고.. 해당 월 데이터만 초기화 - 주, 일 조회시 해당 주, 일만 초기화 해야함.
//        [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyyMM"]];
//        [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyyMM"]];

        
        
        //NSLog(@"조회 월 정보 [%@] 조회함", schMonth);
        //Communication *
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        NSString *callUrl = @"";
        callUrl = URL_getAppointmentList; // 내일정
        //callUrl = URL_getSharedAppointmentList; // 타인일정
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
        //월 셋팅을 하자.
//        NSString *firstDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyy-MM-dd"];
//        NSString *lastDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyy-MM-dd"];
//        NSArray * firstarr= [self getWeekRangeAtDate:[CalendarFunction getMonthFirstDate:currentDate ]];
//        NSArray * lastarr= [self getWeekRangeAtDate:[CalendarFunction getMonthLastDate:currentDate ]];
//
////        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
//        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",[CalendarFunction getStringFromDate:[firstarr objectAtIndex:0]dateFormat:@"yyyy-MM-dd"]] forKey:@"starttime"];
//
//        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",[CalendarFunction getStringFromDate:[lastarr objectAtIndex:1]dateFormat:@"yyyy-MM-dd"] ] forKey:@"endtime"];
//        NSLog(@"firstDay:%@", [firstarr objectAtIndex:0]);
//        NSLog(@"lastDay:%@", [lastarr objectAtIndex:1]);

//        NSArray * firstarr= [self getWeekRangeAtDate:[CalendarFunction getMonthFirstDate:currentDate ]];
//        NSArray * lastarr= [self getWeekRangeAtDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]];
        
        //        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
        
        //3달 일정을 가져옴
        
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]dateFormat:@"yyyy-MM-dd"]] forKey:@"starttime"];
        
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",[CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:+1] ]dateFormat:@"yyyy-MM-dd"]] forKey:@"endtime"];
       
        
        NSLog(@"firstDay:%@", [NSString stringWithFormat:@"%@ 00:00",[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]dateFormat:@"yyyy-MM-dd"]]);
        NSLog(@"lastDay:%@", [NSString stringWithFormat:@"%@ 23:59",[CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:+1] ]dateFormat:@"yyyy-MM-dd"]]);

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
}

- (void)receiveScheduleData {
    
    
	NSMutableArray *arrTemp = nil;
    
	// 여기서부터 테스트 데이터 
	// !주의  실제로 사용할 떄는 arrTemp를 꼭 릴리즈 해줄 것
	arrTemp = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    
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
    
    [datasource removeAllObjects];
    [self setDatasource];

//        [self.tableView1 reloadData];

    buttonEnable = YES;
    displayTypeSegmentedControl.enabled = YES;
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
- (NSArray *)getWeekFirstRangeAtDate:(id)aDate {
	
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


#pragma mark -
#pragma mark Local Method

- (NSString *)getKo_KRLocaleTimeStringWithTimeString:(NSString *)aStrTime {
	
	// 이거 로케일로 어떻게 하면 될꺼 같은데... 나중에 찾아서 고쳐야지...
	// 이렇게 고쳐야지.
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

	NSString *strReturnFullDate = nil;
	
	NSString *strAmPm = @"";
	NSString *strTime   = [aStrTime substringWithRange:NSMakeRange(0, 2)];
	NSString *strMinute = [aStrTime substringWithRange:NSMakeRange(2, 2)];
	
	strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	
	if (12 - [strTime intValue] > 0) {	// 오전
		strAmPm	= (isKr)?@"오전":@"AM";
		strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	} else {
		strAmPm = (isKr)?@"오후":@"PM";
		strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	}
	
	strReturnFullDate = [NSString stringWithFormat:@"%@ %@:%@", strAmPm, strTime, strMinute];
	
	return strReturnFullDate;
	
}

- (NSString *)getScheduleTimeStr:(NSDictionary *)dic {
    
    NSString *returnStr = @"";
    
    if ([[dic objectForKey:@"isalldayevent"] isEqualToString:@"true"]) {	// 하루종일 옵션 ON
		returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
	} else {
		
		if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXTED"]) {	// 시작일과 종료일의 중간에 낀 날짜
			returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
		} else {
			// 이쪽으로 온 경우에는 시작일이거나... 종료일이거나... 하루종일 옵션 OFF로 하고 시작일과 종료일이 같은날(시간만 다른)인 경우
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
			NSDate *startDate = [dateFormatter dateFromString:[dic objectForKey:@"starttime"]];
			NSDate *endDate	  = [dateFormatter dateFromString:[dic objectForKey:@"endtime"]];
			
			[dateFormatter setDateFormat:@"HHmm"];
			
			if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXT_START"]) {		// EXTEND 타입의 시작일
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:startDate]];
				returnStr = [NSString stringWithFormat:@"%@ ~", korLocaleTimeString1];
			} else if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXT_END"]) {	// EXTEND 타입의 종료일
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:endDate]];
				returnStr = [NSString stringWithFormat:@"~ %@", korLocaleTimeString1];
			} else {																	// 시작일과 종료일이 같은 경우
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:startDate]];
				NSString *korLocaleTimeString2 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:endDate]];
				returnStr = [NSString stringWithFormat:@"%@ ~ %@", korLocaleTimeString1, korLocaleTimeString2];
			}
            
			[dateFormatter release];
			dateFormatter = nil;
			
		}
        
	}
    
    return returnStr;
}

- (void)setDatasource {
	
	
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:currentDate];
	
	// 1, 2, 3, 4, 5, 6, 7
	NSInteger intDay = [comp weekday];
	
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	dateComponents.day = 1 - intDay;
	NSDate *dateWeekDay  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																		 toDate:currentDate 
																		options:0];
	
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMdd"];
	
	dateComponents.day = 1;
	
	for (int i = 0; i < 7; i++) {
		
		NSString *strYearMonthDay = [dateFormatter stringFromDate:dateWeekDay];
		NSString *strYearMonth = [strYearMonthDay substringWithRange:NSMakeRange(0, 6)];
		
		NSMutableArray *arr = [[model.scheduleListDic objectForKey:strYearMonth] objectForKey:strYearMonthDay];
		
		if (arr) {
			[datasource addObject:arr];
		} else {
			[datasource addObject:strYearMonthDay];
		}
		
		dateWeekDay  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																	 toDate:dateWeekDay 
																	options:0];
	}
	
	[dateFormatter release];
	dateFormatter = nil;
	
	[dateComponents release];
	dateComponents = nil;
	
	[self.tableView1 reloadData];

}

- (void) setWeekLabel {

    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

    
	NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
	[dateFomatter setDateFormat:@"yyyyMM"];
	
	NSDate *dateMonthFirstday = [dateFomatter dateFromString:[dateFomatter stringFromDate:currentDate]];
	
//	NSLog(@"%@", dateMonthFirstday);
	
	// 첫날이 무슨 요일인지 구한다.
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:dateMonthFirstday];
	
	// 1, 2, 3, 4, 5, 6, 7
	NSInteger intMonthFirstDay = [comp weekday];
	
	[dateFomatter setDateFormat:@"dd"];
	
	NSString *selectedDay = [dateFomatter stringFromDate:currentDate];
	
	//NSLog(@"selectedDay := %@", selectedDay);
    
    
	
	NSString *label = nil;

	switch (([selectedDay intValue] + intMonthFirstDay - 2) / 7) {
		case 0:
			label = NSLocalizedString(@"calendar_first_week",@"첫째주");
			break;
		case 1:
			label = NSLocalizedString(@"calendar_second_week",@"둘째주");
			break;
		case 2:
			label = NSLocalizedString(@"calendar_third_week",@"세째주");
			break;
		case 3:
			label = NSLocalizedString(@"calendar_fourth_week",@"네째주");
			break;
		case 4:
			label = NSLocalizedString(@"calendar_fifth_week",@"다섯째주");
			break;
		case 5:
			label = NSLocalizedString(@"calendar_sixth_week",@"여섯째주");
			break;
		default:
			break;
	}
	
	if ( isKr ) {
        [dateFomatter setDateFormat:@"MM"];
        NSString *selectedMonth = [dateFomatter stringFromDate:currentDate];
        
        self.label1.text = [NSString stringWithFormat:@"%@월 %@", selectedMonth, label] ;
    } else {
        [dateFomatter setDateFormat:@"MMMM"];
        NSString *selectedMonth = [dateFomatter stringFromDate:currentDate];
        
        self.label1.text = [NSString stringWithFormat:@"%@ %@", selectedMonth, label] ;
    }
	[dateFomatter release];
	dateFomatter = nil;
	
}

#pragma mark -
#pragma mark Action Method

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

    
    
    //NSLog(@"currentDate = [%@]", currentDate);    
    // 선택되어진 날짜가 몇번째 주인지 구한 후 화면에 뿌려준다.
    [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)

	[self setWeekLabel];
	[datasource removeAllObjects];
	[self setDatasource];
	
}

- (IBAction)buttonDidPush:(id)sender {
	if (buttonEnable == YES) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        if ([sender tag] == 1) {	// 왼쪽
            dateComponents.day = -7;
        } else {					// 오른쪽
            dateComponents.day = 7;
        }
        
        NSDate *nxtAndPrvWeekDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                                   toDate:currentDate 
                                                                                  options:0];
        
        [currentDate release];
        currentDate = nil;
        currentDate = [nxtAndPrvWeekDate copy];
        //다른 화면으로 이동했을때 포커싱을 맞춰주기 위하여 설정.
        model.selectedDate = currentDate;
        
        
        [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)
        
        
        [dateComponents release];
        dateComponents = nil;
        
        [self setWeekLabel];
        
        [datasource removeAllObjects];
        [self setDatasource];

    }
	
}

- (IBAction)refreshCallCalendar:(id)sender {
    if (buttonEnable == YES) {
        // 통신을 새로 타면 스케줄을 초기화 해준다.
        [model.scheduleListDic removeAllObjects];
        // 스케줄을 초기화 하지 말고.. 해당 월 데이터만 초기화 - 주, 일 조회시 해당 주, 일만 초기화 해야함.
//        [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyyMM"]];
        
        //NSLog(@"조회 월 정보 [%@] 조회함", schMonth);
        //Communication *
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        NSString *callUrl = @"";
        callUrl = URL_getAppointmentList; // 내일정
        //callUrl = URL_getSharedAppointmentList; // 타인일정
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
        
        //월 셋팅을 하자.
//        NSString *firstDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyy-MM-dd"];
//        NSString *lastDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyy-MM-dd"];
//        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
//        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",lastDay] forKey:@"endtime"];
        
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",[CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:[self getNextOrPrevMonthFirstDate:currentDate direction:-1] ]dateFormat:@"yyyy-MM-dd"]] forKey:@"starttime"];
        
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",[CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:[self getNextOrPrevMonthFirstDate:currentDate direction:+1] ]dateFormat:@"yyyy-MM-dd"]] forKey:@"endtime"];

        
        
        
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
    
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 118.0;	// CalendarWeekViewListCell.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 일정이 있는지 없는지 판단하자.
    id arr = [datasource objectAtIndex:indexPath.row];
    if ([arr isKindOfClass:[NSString class]]) {
        //일정 없음
    } else {
        
        model.viewScheduleList = nil;
        model.viewScheduleList = [[NSMutableArray alloc] initWithCapacity:0];
        model.viewScheduleList = arr;
        [super pushViewController:@"CalendarDayScheduleListViewController"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	cell = nil;// 뱃지 뷰제거 때문에.. 
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarWeekViewListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarWeekViewListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	id arr = [datasource objectAtIndex:indexPath.row];
	
	CalendarWeekViewListCell *tmpCell = (CalendarWeekViewListCell *)cell;
		
	// 요일
	switch (indexPath.row) {
		case 0:
			tmpCell.label1.text = NSLocalizedString(@"calendar_sun",@"일");
			break;
		case 1:
			tmpCell.label1.text = NSLocalizedString(@"calendar_mon",@"월");
			break;
		case 2:
			tmpCell.label1.text = NSLocalizedString(@"calendar_tue",@"화");
			break;
		case 3:
			tmpCell.label1.text = NSLocalizedString(@"calendar_wed",@"수");
			break;
		case 4:
			tmpCell.label1.text = NSLocalizedString(@"calendar_thu",@"목");
			break;
		case 5:
			tmpCell.label1.text = NSLocalizedString(@"calendar_fri",@"금");
			break;
		case 6:
			tmpCell.label1.text = NSLocalizedString(@"calendar_sat",@"토");
			break;
		default:
			break;
	}
	
	if ([arr isKindOfClass:[NSString class]]) {
		// 날짜
		tmpCell.label2.text = [arr substringWithRange:NSMakeRange(6, 2)];
		
		tmpCell.label3.text = @"";	// 일정1 시간
		tmpCell.label4.text = @"";	// 일정1 타이틀
		tmpCell.label5.text = @"";	// 일정2 시간
		tmpCell.label6.text = @"";	// 일정2 타이틀
		tmpCell.label7.text = @"";	// 표시되지 않은 일정 수
		
        tmpCell.image1.hidden = YES;
        tmpCell.image2.hidden = YES;
        
        return cell;
	}
	
    tmpCell.image1.hidden = YES;
    tmpCell.image2.hidden = YES;
    
	NSDictionary *dic = [arr objectAtIndex:0];
	
	// 날짜
	tmpCell.label2.text = [[dic objectForKey:@"DATE"] substringWithRange:NSMakeRange(6, 2)];	
	
    // 일정1 시간 표현.
    tmpCell.label3.text = [self getScheduleTimeStr:dic];
    // 일정1 타이틀
	tmpCell.label4.text = [dic objectForKey:@"subject"];
	
    tmpCell.image1.hidden = NO;
    
	
    if (!([arr count] > 1)) {
		// 일정2 시간
		tmpCell.label5.text = @"";
		// 일정2	타이틀
		tmpCell.label6.text = @"";
		// 표시되지 않은 일정 수
		tmpCell.label7.text = @"";
		return cell;
	}
	
	dic = [arr objectAtIndex:1];
	
	// 일정2 시간.
    tmpCell.label5.text = [self getScheduleTimeStr:dic];
    // 일정2	타이틀
	tmpCell.label6.text = [dic objectForKey:@"subject"];
	
    if ([arr count] > 1) {
        tmpCell.image2.hidden = NO;
    }
    
    
    // 표시되지 않은 일정 수
	if (!([arr count] > 2)) {
		tmpCell.label7.text = @"";
	} else {
		tmpCell.label7.text = [NSString stringWithFormat:@"+%d", ([arr count] - 2)];
	}
	
    tmpCell.label7.hidden = YES;
    // 뱃지 적용
    if ( [arr count] > 2 ) {
        
        // add badge view 
		CustomBadge *replysBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"+%d",([arr count] - 2)]withStringColor:[UIColor whiteColor] withInsetColor:[UIColor lightGrayColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor]];
        
		[replysBadge setFrame:CGRectMake(690, 20, replysBadge.frame.size.width, replysBadge.frame.size.height)];
		[cell addSubview:replysBadge];
	}
    
        
    
	return cell;
	
}

#pragma mark -
#pragma mark View Translation Process
- (void)viewWillAppearFunction {
    
    if (datasource == nil) {
		datasource = [[NSMutableArray alloc] initWithCapacity:7];
	} else {
		// 데이터소스를 초기화 한다.
		[datasource removeAllObjects];
	}
	
	[currentDate release];
	currentDate = nil;
	currentDate = [model.selectedDate copy];
    
    
    
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];
    
    NSString *schMonth  = [dateFormat stringFromDate:currentDate];
	
    if ( [model.scheduleListDic objectForKey:schMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
    } else {
		[self requestScheduleData];
        
    }

    
    
    
//    if (currentDate == nil) {
//        [currentDate release];
//        currentDate = nil;
//        currentDate = [[NSDate date] copy];
//        
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
//                                                                    toDate:[CalendarFunction getDateFromString:
//                                                                            [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"]]
//                                                                   options:0];
//        [dateComponents release];
//        dateComponents = nil;
//        
//        // 선택되어진 날짜 화면에 뿌려준다.
//        model.selectedDate = [currentDate copy];
//        [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)
//
//    }
    
	// 선택되어진 날짜가 몇번째 주인지 구한 후 화면에 뿌려준다.
	[self setWeekLabel];
	
	[self setDatasource];
    
    
    //항상 주에 포커싱 시킨다. ( 이 화면은 주화면..)
    self.displayTypeSegmentedControl.selectedSegmentIndex = 1;
	//self.displayTypeSegmentedControl.selectedSegmentIndex = model.selectedDisplayType;
	
    
    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        //타인 이라면 000님의 일정 으로 변경 되어야 한다.
        self.title = [NSString stringWithFormat:@"%@%@", [model.scheduleOwnerInfo notNilObjectForKey:@"empnm"], NSLocalizedString(@"calendar_xxxs_calendar",@"님의 일정")];
    } else {
        self.title = NSLocalizedString(@"calendar_My_calendar",@"나의 일정");
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
    
    //만약 타인 일정보기로 와서 데이터가리로드 되야 한다면.. 화면을 MainView 로 이동 시키자.
    if (model.isNeedUpdateSelectedDate) {
        [super popOrPushViewController:@"CalendarMainViewController" animated:NO];
    } else { 
        [self viewWillAppearFunction];
    }
        
    
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
    //self.title = @"나의 일정";
    
    todayButton.title = NSLocalizedString(@"btn_today",@"오늘");
    todayButton.width = 45.0; //영문 크기고정.
    
    [modeListButton setTitle:NSLocalizedString(@"btn_month",@"월") forSegmentAtIndex:0];
    [modeListButton setTitle:NSLocalizedString(@"btn_week",@"주") forSegmentAtIndex:1];
    [modeListButton setTitle:NSLocalizedString(@"btn_date",@"일") forSegmentAtIndex:2];
    [modeListButton setTitle:NSLocalizedString(@"btn_list",@"목록") forSegmentAtIndex:3];
    
    modeListButton.frame = CGRectMake(modeListButton.frame.origin.x, modeListButton.frame.origin.y, 172.0, modeListButton.frame.size.height); // 영문 크기고정
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tableView1 = nil;
	self.label1 = nil;
}


- (void)dealloc {
	
	// UI
	[tableView1 release];
	[label1 release];
	
	// data
	[datasource  release];
	[currentDate release];
    
    [todayButton release]; //오늘버튼
    [modeListButton release];	// 월,주,일,목록
    
	[super dealloc];
}


@end

//
//  CalendarDayViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarDayViewController.h"
#import "CalendarDayListCell.h"
#import "CalendarFunction.h"
#import "NSDictionary+NotNilReturn.h"
#import "CustomBadge.h"
#import "URL_Define.h"

@implementation CalendarDayViewController

@synthesize tableView1;
@synthesize label1;
@synthesize clipboard; //일보기에서는 인디케이터 사용 안함.
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

	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
    NSString *rsltCode = [resultDic objectForKey:@"code"];
    
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
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
        buttonEnable = YES;
        displayTypeSegmentedControl.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
        
    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
        displayTypeSegmentedControl.enabled = YES;
        buttonEnable = YES;
	}
    
    
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
    buttonEnable = YES;
    displayTypeSegmentedControl.enabled = YES;
    [indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 

	//[indicator stopAnimating]; 일보기에선는 인디케이터 사용 안함.
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;

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
	
    if ( [model.scheduleListDic objectForKey:schMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
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
        NSString *firstDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyy-MM-dd"];
        NSString *lastDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyy-MM-dd"];
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",lastDay] forKey:@"endtime"];
        
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
    
        [self setDatasource];
        //테이블도 리로드 해준다.
        
        [self.tableView1 reloadData];
}





#pragma mark -
#pragma mark Local Method

- (void)setDatasource {
    dispatch_queue_t dQueue = dispatch_queue_create("test", NULL);
    dispatch_async(dQueue, ^{
    dispatch_sync(dispatch_get_main_queue(), ^{
    //NSLog(@"currentDate[%@]",currentDate);	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];

	[dateFormatter setDateFormat:@"yyyyMMdd"];
	[dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter3 setDateFormat:@"HH"];
	[dateFormatter4 setDateFormat:@"mm"];	
    [dateFormatter5 setDateFormat:@"HH:mm"];
	NSString *strYearMonthDay = [dateFormatter stringFromDate:currentDate];
	NSString *strYearMonth = [strYearMonthDay substringWithRange:NSMakeRange(0, 6)];
		
	NSMutableArray *arr = [[model.scheduleListDic objectForKey:strYearMonth] objectForKey:strYearMonthDay];
//NSLog(@"arr [%@]",arr);	
	//해당 날짜에 대한 스케쥴 목록을 array 로 받은다음 파싱하자.. 시간대 별로..
    datasourceDay = nil;
    datasourceDay = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *timeArr = [[NSMutableArray alloc] initWithCapacity:0];
    

	for ( NSDictionary *dic in arr ) {
//            NSLog(@"datasourceDay [%@]", datasourceDay);
        // starttime 값에서 년월일 과 일치하는 데이터를 가져온다.
        // starttime 이 선택된날 과거 값인지 확인한다. - 과거 값이면 00시에 목록을 넣는다.
        // 해당 건수가 1건이면 1개 표현.. 2건이면 2개 표현.. 2개 이상이면 추가 갯수를 뱃지 표현한다.
        //datasourceDay 에 시간 을 키로 배열을 넣자..
        
//NSLog(@"strYearMonthDay[%@] time data [%@]", strYearMonthDay, dic);

        NSDate *startDate = [dateFormatter2 dateFromString:[dic objectForKey:@"starttime"]];
        NSString *startTime = [dateFormatter3 stringFromDate:startDate];
        NSDate *endDate = [dateFormatter2 dateFromString:[dic objectForKey:@"endtime"]];
        NSString *endTime = [dateFormatter3 stringFromDate:endDate];
        NSString *endMin = [dateFormatter4 stringFromDate:endDate];
        NSString *startDay = [dateFormatter stringFromDate:startDate];
        NSString *endDay = [dateFormatter stringFromDate:endDate];
        NSString *startHm = [dateFormatter5 stringFromDate:startDate];
//        NSString *dateString = [dateFormatter stringFromDate:currentDate];
//        NSString *dateString2 = [dateFormatter stringFromDate:startDate];

        
        
        timeArr = nil; //일단 리무브 시키고.
        timeArr = [[NSMutableArray alloc] initWithCapacity:0];
        if ([currentDate compare:startDate] >= NSOrderedSame) {
            if (![[dateFormatter stringFromDate:currentDate] isEqualToString:endDay]) {//하루종일, 날짜가 다른데 중간날짜라 하루종일, 
//                if ([[dic objectForKey:@"isalldayevent"]isEqualToString:@"true"]||![[dateFormatter stringFromDate:currentDate] isEqualToString:endDay]) {//하루종일, 날짜가 다른데 중간날짜라 하루종일, 
                
                //이건전날부터 넘어온 데이터.
                startTime = NSLocalizedString(@"calendar_all_day",@"하루종일");
                if ( [datasourceDay objectForKey:startTime] != nil ) {
                    // 데이터가 있다면.
                    timeArr = [datasourceDay notNilObjectForKey:startTime];
                    //NSLog(@"timeArr [%@]",timeArr);                
                    [timeArr addObject:dic];
                    [datasourceDay removeObjectForKey:startTime];
                    [datasourceDay setObject:timeArr forKey:startTime];
                } else {
                    [timeArr addObject:dic];
                    [datasourceDay setObject:timeArr forKey:startTime];
                }
                
                
                
                
//                if ([[dic objectForKey:@"isalldayevent"]isEqualToString:@"false"]) {
//                    
//                    
//                    
//                    
//                    int i = [startTime intValue];
//                    for ( i; i < 24; i++) {
//                        NSMutableArray *timeTempArr =  [[NSMutableArray alloc] initWithCapacity:0];
//                        
//                        NSString *tempString = [NSString stringWithFormat:@"%d", i] ;
//                        if ([tempString length] == 1) {
//                            tempString = [NSString stringWithFormat:@"0%@", tempString];
//                        }
//                        if ( [datasourceDay objectForKey:tempString] != nil ) {
//                            // 데이터가 있다면.
//                            timeTempArr = [datasourceDay notNilObjectForKey:tempString];
//                            [timeTempArr addObject:dic];
//                            [datasourceDay removeObjectForKey:tempString];
//                            [datasourceDay setObject:timeTempArr forKey:tempString];
//                            
//                        } else {
//                            [timeTempArr addObject:dic];
//                            [datasourceDay setObject:timeTempArr forKey:tempString];
//                            
//                            //                endTime
//                        }
//                        timeTempArr = nil;
//
//                    }
//                    
//                    
//                    
//                }else{
//                    //이건전날부터 넘어온 데이터.
//                    startTime = NSLocalizedString(@"calendar_all_day",@"하루종일");
//                    if ( [datasourceDay objectForKey:startTime] != nil ) {
//                        // 데이터가 있다면.
//                        timeArr = [datasourceDay notNilObjectForKey:startTime];
//                        //NSLog(@"timeArr [%@]",timeArr);                
//                        [timeArr addObject:dic];
//                        [datasourceDay removeObjectForKey:startTime];
//                        [datasourceDay setObject:timeArr forKey:startTime];
//                    } else {
//                        [timeArr addObject:dic];
//                        [datasourceDay setObject:timeArr forKey:startTime];
//                    }
//
//                }
            }else{//아니면 전날에서 들어온 일정이므로 끝나는 시간까지 표시 해줌
                
                if ([endMin intValue]>0) {
                    
                    endTime = [NSString stringWithFormat:@"%d",[endTime intValue]+1];
                }
                int i = 0;
                for ( i; i < [endTime intValue]; i++) {
                    NSMutableArray *timeTempArr =  [[NSMutableArray alloc] initWithCapacity:0];
                    
                    NSString *tempString = [NSString stringWithFormat:@"%d", i] ;
                    if ([tempString length] == 1) {
                        tempString = [NSString stringWithFormat:@"0%@", tempString];
                    }
                    if ( [datasourceDay objectForKey:tempString] != nil ) {
                        // 데이터가 있다면.
                        timeTempArr = [datasourceDay notNilObjectForKey:tempString];
                        [timeTempArr addObject:dic];
                        [datasourceDay removeObjectForKey:tempString];
                        [datasourceDay setObject:timeTempArr forKey:tempString];
                        
                    } else {
                        [timeTempArr addObject:dic];
                        [datasourceDay setObject:timeTempArr forKey:tempString];
                        
                        //                endTime
                    }
                    timeTempArr = nil;
                    
                }

            }
            
        } else {
            //이건 오늘자.
            if ([startDay isEqualToString:endDay]) {
                if ([startTime isEqualToString:endTime]) {
                    if ( [datasourceDay objectForKey:startTime] != nil ) {
                        // 데이터가 있다면.
                        timeArr = [datasourceDay notNilObjectForKey:startTime];
                        [timeArr addObject:dic];
                        [datasourceDay removeObjectForKey:startTime];
                        [datasourceDay setObject:timeArr forKey:startTime];
                    } else {
                        [timeArr addObject:dic];
                        [datasourceDay setObject:timeArr forKey:startTime];
                        
                        //                endTime
                    }
                    
                } else {
                    if ([endMin intValue]>0) {
                        
                        endTime = [NSString stringWithFormat:@"%d",[endTime intValue]+1];
                    }
                    int i = [startTime intValue];
                    for ( i; i < [endTime intValue]; i++) {
                        NSMutableArray *timeTempArr =  [[NSMutableArray alloc] initWithCapacity:0];
                        
                        NSString *tempString = [NSString stringWithFormat:@"%d", i] ;
                        if ([tempString length] == 1) {
                            tempString = [NSString stringWithFormat:@"0%@", tempString];
                        }
                        if ( [datasourceDay objectForKey:tempString] != nil ) {
                            // 데이터가 있다면.
                            timeTempArr = [datasourceDay notNilObjectForKey:tempString];
                            [timeTempArr addObject:dic];
                            [datasourceDay removeObjectForKey:tempString];
                            [datasourceDay setObject:timeTempArr forKey:tempString];
                            
                        } else {
                            [timeTempArr addObject:dic];
                            [datasourceDay setObject:timeTempArr forKey:tempString];
                            
                            //                endTime
                        }
                        timeTempArr = nil;
                        
                    }
                }

            }else{//날짜가 다르면 끝까지 표기 해줌
//                if (condition) {
//                    <#statements#>
//                }
                int i = [startTime intValue];
                for ( i; i < 24; i++) {
                    NSMutableArray *timeTempArr =  [[NSMutableArray alloc] initWithCapacity:0];
                    
                    NSString *tempString = [NSString stringWithFormat:@"%d", i] ;
                    if ([tempString length] == 1) {
                        tempString = [NSString stringWithFormat:@"0%@", tempString];
                    }
                    if ( [datasourceDay objectForKey:tempString] != nil ) {
                        // 데이터가 있다면.
                        timeTempArr = [datasourceDay notNilObjectForKey:tempString];
                        [timeTempArr addObject:dic];
                        [datasourceDay removeObjectForKey:tempString];
                        [datasourceDay setObject:timeTempArr forKey:tempString];
                        
                    } else {
                        [timeTempArr addObject:dic];
                        [datasourceDay setObject:timeTempArr forKey:tempString];
                        
                        //                endTime
                    }
                    timeTempArr = nil;
                    
                }

            }
            
            
        }
        
        
//        NSLog(@"datasourceDay [%@]", datasourceDay);
//        
//        NSLog(@"%d",[datasourceDay retainCount] );

        
        
        
        
        
        
        
//        if ([currentDate compare:startDate] >= NSOrderedSame) {
//            //이건전날부터 넘어온 데이터.
//            startTime = NSLocalizedString(@"calendar_all_day",@"하루종일");
//            if ( [datasourceDay objectForKey:startTime] != nil ) {
//                // 데이터가 있다면.
//                timeArr = [datasourceDay notNilObjectForKey:startTime];
//                //NSLog(@"timeArr [%@]",timeArr);                
//                [timeArr addObject:dic];
//                [datasourceDay removeObjectForKey:startTime];
//                [datasourceDay setObject:timeArr forKey:startTime];
//            } else {
//                [timeArr addObject:dic];
//                [datasourceDay setObject:timeArr forKey:startTime];
//            }
//        } else {
//            //이건 오늘자.
//            if ( [datasourceDay objectForKey:startTime] != nil ) {
//                // 데이터가 있다면.
//                timeArr = [datasourceDay notNilObjectForKey:startTime];
//                [timeArr addObject:dic];
//                [datasourceDay removeObjectForKey:startTime];
//                [datasourceDay setObject:timeArr forKey:startTime];
//            } else {
//                [timeArr addObject:dic];
//                [datasourceDay setObject:timeArr forKey:startTime];
//            }
//        }
//        NSLog(@"datasourceDay [%@]", datasourceDay);

        
        
        
        
    }
    
       
//NSLog(@"datasourceDay [%@]", datasourceDay);
    
    
	[dateFormatter release];
	[dateFormatter2 release];
	[dateFormatter3 release];
    [dateFormatter4 release];
    [dateFormatter5 release];
	dateFormatter = nil;
	dateFormatter2 = nil;
	dateFormatter3 = nil;
	dateFormatter4 = nil;
    dateFormatter5 = nil;
	[self.tableView1 reloadData];
    });
    });
    buttonEnable = YES;
    displayTypeSegmentedControl.enabled = YES;

    //NSLog(@"datasourceDay[%@]",datasourceDay);
}

- (void) setDayLabel {
    
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
	
    
    if ( isKr ) {
        [dateFomatter setDateFormat:@"EEEE YYYY년 MMMM dd일 "];
        [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        [dateFomatter setDateFormat:@"EEEE dd/MMMM/YYYY "];
    }
    
    NSString *dateString = [dateFomatter stringFromDate:currentDate];
    
	self.label1.text = dateString;
	
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
    
    [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)

	[self setDayLabel];
	[self setDatasource];
    
}

- (IBAction)buttonDidPush:(id)sender {
	if (buttonEnable == YES) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        if ([sender tag] == 1) {	// 왼쪽
            dateComponents.day = -1;
        } else {					// 오른쪽
            dateComponents.day = 1;
        }
        
        NSDate *nxtAndPrvDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                               toDate:currentDate 
                                                                              options:0];
        
        [currentDate release];
        currentDate = nil;
        currentDate = [nxtAndPrvDate copy];
        //다른 화면으로 이동했을때 포커싱을 맞춰주기 위하여 설정.
        model.selectedDate = [currentDate copy];
        
        [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)
        
        [dateComponents release];
        dateComponents = nil;
        
        [self setDayLabel];
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
        NSString *firstDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthFirstDate:currentDate] dateFormat:@"yyyy-MM-dd"];
        NSString *lastDay = [CalendarFunction getStringFromDate:[CalendarFunction getMonthLastDate:currentDate] dateFormat:@"yyyy-MM-dd"];
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 00:00",firstDay] forKey:@"starttime"];
        [requestDictionary setObject:[NSString stringWithFormat:@"%@ 23:59",lastDay] forKey:@"endtime"];
        
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
	
	return indexPath.section == 1 ? 88.0 : 44.0;	// CalendarDayListCell.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //NSLog(@"didselect");
    
    // 일정이 있는지 없는지 판단하자.
    if ( [datasourceDay objectForKey:[datasource objectAtIndex:indexPath.row]] != nil ) {
        model.viewScheduleList = nil;
        model.viewScheduleList = [[NSMutableArray alloc] initWithCapacity:0];
        model.viewScheduleList = [datasourceDay objectForKey:[datasource objectAtIndex:indexPath.row]];
        [super pushViewController:@"CalendarDayScheduleListViewController"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;	// 위쪽 공백용 1 + 실제 24시간 1 + 아랫쪽 공백용 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 1 ? [datasource count] : 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *DefaultCellIdentifier = @"DefaultCellIdentifier";
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	
	UITableViewCell *cell = nil;
	
	if (indexPath.section == 0 || indexPath.section == 2) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier];
		}
		
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
		cell = nil;// 뱃지 뷰제거 때문에.. 
		if (cell == nil) {
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarDayListCell" owner:self options:nil];
			
			for (id oneObject in nib) {
				if ([oneObject isKindOfClass:NSClassFromString(@"CalendarDayListCell")]) {
					cell = oneObject;
				}
			}
		}
        
        CalendarDayListCell *tmpCell = (CalendarDayListCell *)cell;
        // 시간 값을 가지고 온다.. 
//NSLog(@"time value = [%@]",[datasource objectAtIndex:indexPath.row]);
        
        tmpCell.label1.text = @"";
        tmpCell.label2.text = @"";
        tmpCell.image1.hidden = YES;
        tmpCell.image2.hidden = YES;
                
//NSLog(@"%@][%d", [datasource objectAtIndex:indexPath.row], [[datasourceDay objectForKey:[datasource objectAtIndex:indexPath.row]] count]);        
        if ( [[datasourceDay objectForKey:[datasource objectAtIndex:indexPath.row]] count] > 0 ) {
            
            NSMutableArray *arr = [[datasourceDay objectForKey:[datasource objectAtIndex:indexPath.row]] copy]; //타임 데이터 원본

//NSLog(@"arr[%@] count [%d]", arr, [arr count]);            

            NSDictionary *dic = [arr objectAtIndex:0];
            
            tmpCell.label1.text = [dic objectForKey:@"subject"];
            
            tmpCell.image1.hidden = NO;
            
            if ( [arr count] > 1 ) { 
                dic = [arr objectAtIndex:1];
                tmpCell.label2.text = [dic objectForKey:@"subject"];
                tmpCell.image2.hidden = NO;
            }
            
            if ( [arr count] > 2 ) { 
                // add badge view 
                CustomBadge *replysBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"+%d",([arr count] - 2)]withStringColor:[UIColor whiteColor] withInsetColor:[UIColor lightGrayColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor]];
                
                [replysBadge setFrame:CGRectMake(690, 20, replysBadge.frame.size.width, replysBadge.frame.size.height)];
                [tmpCell addSubview:replysBadge];
                
            }
            arr = nil;
            [arr release];
        }
	}
        
	return cell;
	
}


#pragma mark -
#pragma mark View Translation Process

- (void)viewWillAppearFunction {
    
    [currentDate release];
	currentDate = nil;
	currentDate = [model.selectedDate copy];
    
    if (currentDate == nil) {	
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
        [self requestScheduleData]; //데이터를 요청한다. (단. 메모리에 해당월 데이터가 없을 경우에만)

    }

    
    
	// 선택되어진 날짜 화면에 뿌려준다.
	[self setDayLabel];
	
	[self setDatasource];
    
    
    //항상 일에 포커싱 시킨다. ( 이 화면은 일화면..)
    self.displayTypeSegmentedControl.selectedSegmentIndex = 2;
	//self.displayTypeSegmentedControl.selectedSegmentIndex = model.selectedDisplayType;
	
    
    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        //타인 이라면 000님의 일정 으로 변경 되어야 한다.
        self.title = [NSString stringWithFormat:@"%@%@", [model.scheduleOwnerInfo notNilObjectForKey:@"empnm"], NSLocalizedString(@"calendar_xxxs_calendar", @"님의 일정")];
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
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	CGRectMake(10, 11, 20, 16);
	
	UILabel *label;
	
	for (int i = 0; i <= 25; i++) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 25 + (88 * i), 100, 21)];
		label.font = [UIFont fontWithName:@"Helvetica" size:22];
		label.textColor = [UIColor blackColor];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		
		if ( i == 0 ) {
            label.text = NSLocalizedString(@"calendar_all_day",@"하루종일");
        } else if ( i < 13 || i == 25 ) {
            int j = i-1;
            if ( isKr ) {
                label.text = [NSString stringWithFormat:@"오전 %d시", j != 24 ? j : 0]; 
            } else {
                label.text = [NSString stringWithFormat:@"AM %d:00", j != 24 ? j : 0];
            }
			
		} else {
            int j = i-1;
            if ( isKr ) {
                label.text = [NSString stringWithFormat:@"오후 %d시", j - 12];
            } else {
                label.text = [NSString stringWithFormat:@"PM %d:00", j - 12];
            }
		}

		
		[self.tableView1 addSubview:label];
		[label release];
	}
	
	datasource = [[NSArray alloc] initWithObjects:
				  NSLocalizedString(@"calendar_all_day",@"하루종일"),
                  @"00",@"01",@"02",@"03",@"04",@"05",
				  @"06",@"07",@"08",@"09",@"10",@"11",
				  @"12",@"13",@"14",@"15",@"16",@"17",
				  @"18",@"19",@"20",@"21",@"22",@"23", nil]; //24시간 기준데이터 생성
    
    
    self.title = @"나의 일정";
    
    
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

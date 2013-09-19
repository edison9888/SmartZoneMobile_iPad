//
//  CalendarListViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarListViewController.h"
#import "CalendarListListCell.h"
#import "CalendarFunction.h"
#import "NSDictionary+NotNilReturn.h"
#import "CalendarListSearchViewController.h"
#import "URL_Define.h"


@implementation CalendarListViewController

@synthesize tableView1;
@synthesize searchBar1;
@synthesize morePrevButton;
@synthesize moreNextButton;
@synthesize labelPrev;
@synthesize labelPrevBottom;
@synthesize labelNext;
@synthesize labelNextBottom;

@synthesize todayInSection;

@synthesize indicator;
@synthesize clipboard;

@synthesize todayButton;
@synthesize modeListButton;	// 월,주,일,목록

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    //--- indicator setting ---//
    BOOL isIndicator = YES;
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
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
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_no_events_are_saved",@"조회된 일정이 없습니다.")
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                
                [alert show];	
                [alert release];
                return;
           
            
        }
        
	}
    else if ( [rsltCode intValue] == 1 ) {
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
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating]; 
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;

}


#pragma mark -
#pragma mark Data Request & Receive

- (void)requestScheduleData {
	
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyyMM"];
	
	//	SCH_MONTH	조회월			●	YYYYMM
	NSString *schMonth  = [dateFormat stringFromDate:currentDate];
	
    if ( [model.scheduleListDic objectForKey:schMonth] != nil) {
        //해당 달에 데이터가 없을경우만 조회 한다.
        //NSLog(@"조회 월 정보 [%@] 조회하지 않음", schMonth);
    } else {
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
    
    // 통신을 새로 타면 스케줄을 초기화 해준다.
    //[model.scheduleListDic removeAllObjects];
    // 스케줄을 초기화 하지 말고.. 해당 월 데이터만 초기화 - 주, 일 조회시 해당 주, 일만 초기화 해야함.
    [model.scheduleListDic removeObjectForKey:[CalendarFunction getStringFromDate:currentDate dateFormat:@"yyyyMM"]];
    
    
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
    

    // 데이터를 재정렬 하여 새로 그려준다.
    [self viewWillAppearFunction];
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


#pragma mark -
#pragma mark UISearchBarDelegate Implement
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    	
    //테이블 리로드 시키자.
    [searchBar resignFirstResponder];
    [self.tableView1 reloadData];
    
	
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *tempString = [[searchBar text] stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];

//    NSString *searchText = [searchBar text];
    
    // 검색창 검색 하게 되면 일정 검색 화면으로 이동한다.
    // 이때 검색어도 넘겨주고 자동 실행 되게 하자.
    
    if ([tempString length] < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다.") 
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
    
        CalendarListSearchViewController *viewController = [[CalendarListSearchViewController alloc] initWithNibName:@"CalendarListSearchViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.searchBar1.text = tempString;
        [viewController searchSchedule:tempString];
        [viewController release];
        
        
        //혹시 키보드가 올라와 있을지 몰르니..
        searchBar1.text = @"";
        [searchBar1 resignFirstResponder];
    
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[searchBar1 resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 88.0;	// CalendarScheduleRegisterTitleListCell.xib에 설정되어있는 height
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"willSelectRowAtIndexPath");
    
    NSMutableArray *arr = [datasource objectForKey:[datasourceAllKeys objectAtIndex:indexPath.section]];
	
    
    if ([[[arr objectAtIndex:indexPath.row] notNilObjectForKey:@"NO_SCHEDULE"] isEqualToString:@"NO_SCHEDULE"]) {
        
        //일정없음.
        
    } else {
//        model.viewSchedule = [arr objectAtIndex:indexPath.row];
//        [super pushViewController:@"CalendarScheduleReadViewController"];
        
        
        [super pushViewController:@"CalendarScheduleReadViewController"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainScheduleRead" object:[[arr objectAtIndex:indexPath.row]objectForKey:@"appointmentid"]];

        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [datasourceAllKeys count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSString *strYearMonthDayKey = [datasourceAllKeys objectAtIndex:section];

	if ([[datasource objectForKey:strYearMonthDayKey] isKindOfClass:[NSMutableArray class]]) {
		return [[datasource objectForKey:strYearMonthDayKey] count];
	}
	
	return 0;//오늘 일정이 없는 달이여.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ( isKr ) {
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } 
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *sectionTitleDate = [dateFormatter dateFromString:[datasourceAllKeys objectAtIndex:section]];
    NSDate *sectionTitleDate2 = [dateFormatter dateFromString:[datasourceAllKeys objectAtIndex:section]];
    NSString *sectionTitleString = @"";
    if ( isKr ) {
        [dateFormatter setDateFormat:@"yyyy.M.d E"];
        sectionTitleString = [dateFormatter stringFromDate:sectionTitleDate];
    } else {
        [dateFormatter setDateFormat:@"yyyy.M.d"];
        sectionTitleString = [dateFormatter stringFromDate:[sectionTitleDate copy]];
        [dateFormatter setDateFormat:@"E"];
        sectionTitleString = [NSString stringWithFormat:@"%@ %@", sectionTitleString, [dateFormatter stringFromDate:sectionTitleDate2]];
    }
    

    [dateFormatter release];
    dateFormatter = nil;
    
    if ( 
        [[CalendarFunction getStringFromDate:sectionTitleDate dateFormat:@"yyyyMMdd"] isEqualToString:
         [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"]] ) {
            todayInSection = section;
        }
    
	return sectionTitleString;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section]; 
    if (sectionTitle == nil) { return nil; } 
    
    // Create label with section title 
    UILabel *label = [[[UILabel alloc] init] autorelease]; 
    label.frame = CGRectMake(400, 3, 260, 40); 
    label.backgroundColor = [UIColor clearColor];
    label.text = [[sectionTitle componentsSeparatedByString:@" "] objectAtIndex:0]; 
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor colorWithRed:26.0/255 green:84.0/255 blue:136.0/255 alpha:1];
    label.font = [UIFont systemFontOfSize:22.0];

    UILabel *label2 = [[[UILabel alloc] init] autorelease]; 
    label2.frame = CGRectMake(670, 3, 53, 40); 
    label2.backgroundColor = [UIColor clearColor];
    label2.text = [[sectionTitle componentsSeparatedByString:@" "] objectAtIndex:1]; 
    label2.textAlignment = UITextAlignmentLeft;
    label2.lineBreakMode = UILineBreakModeClip;
    label2.font = [UIFont systemFontOfSize:22.0];

    
    // Create header view and add label as a subview 
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)] autorelease]; 
    view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_list_blue.png"]];
    [view addSubview:label]; 
    [view addSubview:label2]; 
    return view;

//    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
//    view.image = [UIImage imageNamed:@"bg_list_blue.png"];
//    [view addSubview:label];
//    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];

	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarListListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarListListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarListListCell *tmpCell = (CalendarListListCell *)cell;

	NSMutableArray *arr = [datasource objectForKey:[datasourceAllKeys objectAtIndex:indexPath.section]];
	    
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];

    if ([[dic notNilObjectForKey:@"NO_SCHEDULE"] isEqualToString:@"NO_SCHEDULE"]) {
        tmpCell.label1.text = @"";
        tmpCell.label2.text = NSLocalizedString(@"calendar_no_event",@"일정없음");
        tmpCell.image1.hidden = YES;
    } else {
        tmpCell.label1.text = [self getScheduleTimeStr:dic];
        tmpCell.label2.text = [dic objectForKey:@"subject"];
    }
    
	return cell;
	
}

#pragma mark -
#pragma mark Footer Action Method
- (IBAction)todayButtonDidPush:(id)sender {
	//[self gotoSomeDayWithDate:[NSDate date]]; //오늘날짜로 포커싱 이동한다.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:todayInSection];//todayInSection
	
	[tableView1 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (IBAction)buttonDidPush:(id)sender {
    //NSLog(@"sender tag = [%d] 클릭함.", [sender tag]);
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    if ( isKr ) {
        [dateFomatter setDateFormat:@"YYYY년 MMMM"];
        [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        [dateFomatter setDateFormat:@"MMMM/YYYY"];
    }
    
    if ([sender tag] == 1) {
        //이전달 데이터 호출
        [currentDate release];
        currentDate = nil;
        currentDate = [prevDate copy];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = -1;
        NSDate *nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                            toDate:[prevDate copy]
                                                                           options:0];
        
        prevDate = [nxtAndPrvMonthDate copy];
        [nxtAndPrvMonthDate release];
        nxtAndPrvMonthDate = nil;
        
        
        //2011년 7월 이전 1개월 일정을
        //self.label1.text = @"";
        self.labelPrev.text = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:[prevDate copy]], NSLocalizedString(@"calendar_schedule", @"일정을")];

        
    } else {
        //다음달 데이터 호출
        [currentDate release];
        currentDate = nil;
        currentDate = [nextDate copy];
        
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 1;
        NSDate *nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                            toDate:[nextDate copy] 
                                                                           options:0];
        
        nextDate = [nxtAndPrvMonthDate copy];
        [nxtAndPrvMonthDate release];
        nxtAndPrvMonthDate = nil;
        
        
        //2011년 7월 이후 1개월 일정을
        //self.label1.text = @"";
        self.labelNext.text = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:[nextDate copy]], NSLocalizedString(@"calendar_schedule", @"일정을")];
        
    }
    //NSLog(@"currentDate [%@]", currentDate);
    [self requestScheduleData];
    
    [dateFomatter release];
    dateFomatter = nil;
    
    
}

#pragma mark -
#pragma mark View Translation Process
- (void)viewWillAppearFunction {
    //self.displayTypeSegmentedControl.selectedSegmentIndex = model.selectedDisplayType;
	//항상 목록에 포커싱 시킨다. ( 이 화면은 목록화면..)
    self.displayTypeSegmentedControl.selectedSegmentIndex = 3;
    
    
	// 새로운 데이터가 갱신 되었을 수도 있으므로 datasource를 다시 잡아 준다.
	[datasource removeAllObjects];
    
	
    
    // 년월-년월일-배열(DIC->DIC->ARRAY) 형태를 년월일-배열(DIC->ARRAY) 형태로 바꾼다.
	for (NSString *strYearMonthKey in [model.scheduleListDic allKeys]) {
		
		NSMutableDictionary *yearMonthDic = [model.scheduleListDic objectForKey:strYearMonthKey];
		
		for (NSString *strYearMonthDay in [yearMonthDic allKeys]) {
			[datasource setObject:[yearMonthDic objectForKey:strYearMonthDay] forKey:strYearMonthDay];
		}
		
	}    
    
    
	NSString *strYearMonthDay = [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"];
	
	// 오늘 스케쥴이 없다.
//	if ([datasource objectForKey:strYearMonthDay] == nil) {
//		[datasource setObject:[[NSMutableArray alloc] initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"NO_SCHEDULE",@"NO_SCHEDULE",nil],nil]
//                       forKey:strYearMonthDay];
//	}
	
	[datasourceAllKeys release];
	datasourceAllKeys = nil;
	
	datasourceAllKeys = [[[datasource allKeys] sortedArrayUsingSelector:@selector(compare:)] copy];
	
    
    //NSLog(@"일정 목록의 모든 데이터 : [%@]", datasourceAllKeys);
    //NSLog(@"수신된 스케줄 전체 데이터 : [%@]", model.scheduleListDic);
    
    
	[self.tableView1 reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }

    
	//만약 타인 일정보기로 와서 데이터가리로드 되야 한다면.. 화면을 MainView 로 이동 시키자.
    if (model.isNeedUpdateSelectedDate) {
        [super popOrPushViewController:@"CalendarMainViewController" animated:NO];
    } else { 
        [self viewWillAppearFunction];
    }
    //혹시 키보드가 올라와 있을지 몰르니..
    searchBar1.text = @"";
    [searchBar1 resignFirstResponder];
    
    
    // 하단 더보기를 셋팅하자.
    [prevDate release];
    prevDate = nil;
    [nextDate release];
    nextDate = nil;
    
    self.labelPrev.text = @"";
    self.labelNext.text = @"";
    scheduleMMAllKeys = [[[model.scheduleListDic allKeys] sortedArrayUsingSelector:@selector(compare:)] copy];
    if ( [scheduleMMAllKeys count] > 0  ) {
        
        NSDate *minDate =[CalendarFunction getDateFromString:[scheduleMMAllKeys objectAtIndex:0] dateFormat:@"yyyyMM"];
        NSDate *maxDate =[CalendarFunction getDateFromString:[scheduleMMAllKeys objectAtIndex:[scheduleMMAllKeys count]-1] dateFormat:@"yyyyMM"];
        
        //    sender tag 가 1 일 경우 현재까지 수집된 월의 전달
        //    sender tag 가 2 일 경우 현재까지 수집된 월의 다음달.
        
        // 이전달
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = -1;
        NSDate *nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                            toDate:[minDate copy] 
                                                                           options:0];
        
        prevDate = [nxtAndPrvMonthDate copy];
        
        // 다음달
        dateComponents.month = 1;
        nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                                toDate:[maxDate copy] 
                                                                               options:0];
        
        
        nextDate = [nxtAndPrvMonthDate copy];
        [nxtAndPrvMonthDate release];
        nxtAndPrvMonthDate = nil;
    } else {
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        // 이전달
        dateComponents.month = -1;
        NSDate *nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                            toDate:[NSDate date] 
                                                                           options:0];
        
        prevDate = [nxtAndPrvMonthDate copy];
        
        // 다음달
        dateComponents.month = 1;
        nxtAndPrvMonthDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                            toDate:[NSDate date] 
                                                                           options:0];
        
        
        nextDate = [nxtAndPrvMonthDate copy];
        [nxtAndPrvMonthDate release];
        nxtAndPrvMonthDate = nil;
    }
    //2011년 7월 이후 1개월 일정을
    //self.label1.text = @"";
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    if ( isKr ) {
        [dateFomatter setDateFormat:@"YYYY년 MMMM"];
        [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        [dateFomatter setDateFormat:@"MMMM/YYYY"];
    }
    self.labelPrev.text = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:[prevDate copy]], NSLocalizedString(@"calendar_schedule", @"일정을")];
    self.labelNext.text = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:[nextDate copy]], NSLocalizedString(@"calendar_schedule", @"일정을")];
    [dateFomatter release];
    dateFomatter = nil;
    
    
    // 유저 타입이 본인일 경우 나의 모든 일정 타인일 경우 xxx님의 모든 일정 으로 표기한다.
    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        //타인 이라면 000님의 일정 으로 변경 되어야 한다.
        self.title = [NSString stringWithFormat:@"%@%@", [model.scheduleOwnerInfo notNilObjectForKey:@"empnm"],NSLocalizedString(@"calendar_xxx_all_events", @"님의 모든 일정")];
    } else {
        self.title = NSLocalizedString(@"calendar_all_my_events",@"나의 모든 일정");
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
	
	datasource = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    todayButton.title = NSLocalizedString(@"btn_today",@"오늘");
    todayButton.width = 45.0; //영문 크기고정.
    
    [modeListButton setTitle:NSLocalizedString(@"btn_month",@"월") forSegmentAtIndex:0];
    [modeListButton setTitle:NSLocalizedString(@"btn_week",@"주") forSegmentAtIndex:1];
    [modeListButton setTitle:NSLocalizedString(@"btn_date",@"일") forSegmentAtIndex:2];
    [modeListButton setTitle:NSLocalizedString(@"btn_list",@"목록") forSegmentAtIndex:3];
    
    modeListButton.frame = CGRectMake(modeListButton.frame.origin.x, modeListButton.frame.origin.y, 172.0, modeListButton.frame.size.height); // 영문 크기고정
    
    self.labelNextBottom.text = NSLocalizedString(@"calendar_please_touch_if_you_want_to_see_more_results", @"더보시려면 터치하세요");
    self.labelPrevBottom.text = NSLocalizedString(@"calendar_please_touch_if_you_want_to_see_more_results", @"더보시려면 터치하세요");
    
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
}


- (void)dealloc {
	
	[datasource release];
	[datasourceAllKeys release];
    
    [tableView1 release];
    [searchBar1 release];
    [morePrevButton release];
    [moreNextButton release];
    [labelPrev release];
    [labelPrevBottom release];
    [labelNext release];
    [labelNextBottom release];
    
    [indicator release];
    [clipboard release];
    
    [todayButton release]; //오늘버튼
    [modeListButton release];	// 월,주,일,목록
    
    [super dealloc];
}


@end

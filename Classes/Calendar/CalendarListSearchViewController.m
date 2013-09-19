//
//  CalendarListSearchViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarListSearchViewController.h"
#import "CalendarListListCell.h"
#import "CalendarFunction.h"
#import "NSDictionary+NotNilReturn.h"

@implementation CalendarListSearchViewController

@synthesize tableView1;
@synthesize searchBar1;

@synthesize todayInSection;


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



- (void)searchSchedule:(NSString *)keyWord {

    if ( model == nil ) {
        model = [CalendarModel sharedInstance];
    }
    // 새로운 데이터가 갱신 되었을 수도 있으므로 datasource를 다시 잡아 준다.
	//[datasource removeAllObjects];
    datasource = nil;
    datasource = [[NSMutableDictionary alloc] initWithCapacity:0];
    
	// 년월-년월일-배열(DIC->DIC->ARRAY) 형태를 년월일-배열(DIC->ARRAY) 형태로 바꾼다.
	for (NSString *strYearMonthKey in [model.scheduleListDic allKeys]) {
		
		NSMutableDictionary *yearMonthDic = [model.scheduleListDic objectForKey:strYearMonthKey];
		
		for (NSString *strYearMonthDay in [yearMonthDic allKeys]) {
			[datasource setObject:[yearMonthDic objectForKey:strYearMonthDay] forKey:strYearMonthDay];
		}
		
	}  
    
    if ( keyWord == nil ) {
        
        
        NSString *strYearMonthDay = [CalendarFunction getStringFromDate:[NSDate date] dateFormat:@"yyyyMMdd"];
        
        // 오늘 스케쥴이 없다.
        if ([datasource objectForKey:strYearMonthDay] == nil) {
            [datasource setObject:[[NSMutableArray alloc] initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"NO_SCHEDULE",@"NO_SCHEDULE",nil],nil]
                           forKey:strYearMonthDay];
        }
        
        [datasourceAllKeys release];
        datasourceAllKeys = nil;
        
        datasourceAllKeys = [[[datasource allKeys] sortedArrayUsingSelector:@selector(compare:)] copy];
        

    } else {
    
        //NSLog(@"datasource [%@]", [[datasource allKeys] sortedArrayUsingSelector:@selector(compare:)]);
        
        NSMutableArray *source = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        
        // 제목으로 검색하여 검색 결과 반영.
        
        for (NSString *key in [[[datasource allKeys] sortedArrayUsingSelector:@selector(compare:)] copy]) {
            for ( NSDictionary *dic in [datasource objectForKey:key] ) {
                
                if ( [[dic notNilObjectForKey:@"EXT_TYPE"] isEqualToString:@"EXTED"] ) {
                    
                    
                } else if ( [[dic notNilObjectForKey:@"EXT_TYPE"] isEqualToString:@"EXT_END"] ) {
                    
                } else {
                
                    if ( [[dic notNilObjectForKey:@"subject"] rangeOfString:keyWord].length > 0 ) {
                        
//NSLog(@"search result dic [%@]",dic);
                        [source addObject:dic];
                        // dic 을 넣어주는데.. 이거 array 로 넣어줘야 테이블에서 날짜 별로 목록 마킹되서 나옴.. 
                        // [source setObject:dic forKey:[dic objectForKey:@"DATE"]];
                        
                    }
                    
                }
            }
        }
        
        // 시작일과 종료일을 비교하여 다른경우 시작일부터 종료일까지 데이터를 강제로 복사하여 넣어준다.
        // (시작일부터 종료일까지 •을 찍기 위해서)
        NSMutableArray *extendLinearData = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary *fullDataDic in source) {
            
            NSDictionary *dic = fullDataDic;
            
            NSString *strStartDate = [CalendarFunction getStringFromDate:[CalendarFunction getDateFromString:[dic objectForKey:@"starttime"] dateFormat:@"yyyy-MM-dd HH:mm"] 
                                                              dateFormat:@"yyyyMMdd"];
            NSString *strEndDate   = [CalendarFunction getStringFromDate:[CalendarFunction getDateFromString:[dic objectForKey:@"endtime"]   dateFormat:@"yyyy-MM-dd HH:mm"] 
                                                              dateFormat:@"yyyyMMdd"];
            
            // 아웃룩에서 하루종일 플래그가 있으면 해당 데이터는 날짜가 같다고 본다. 1일 차이가 남.. 2011-01-01 00:00 ~ 2011-01-02 00:00 으로 데이터 들어옴.
            
            if (![strStartDate isEqualToString:strEndDate] && [[dic objectForKey:@"isalldayevent"] isEqualToString:@"false"]) {
                
                NSDate *startDate = [CalendarFunction getDateFromString:[dic objectForKey:@"starttime"] dateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *endDate   = [CalendarFunction getDateFromString:[dic objectForKey:@"endtime"]	  dateFormat:@"yyyy-MM-dd HH:mm"];
                
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
                
                NSDictionary *dicMonthSchedule = [resultDic objectForKey:strYearMonth];
                
                if (dicMonthSchedule == nil) {
                    dicMonthSchedule = [[NSMutableDictionary alloc] initWithCapacity:0];
                    
                    NSMutableArray *arrDaySchedule = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    [arrDaySchedule addObject:dic];
                    
                    [dicMonthSchedule setValue:arrDaySchedule forKey:strStartDate];
                    [arrDaySchedule release];
                    arrDaySchedule = nil;
                    
                    [resultDic setValue:dicMonthSchedule forKey:strYearMonth];
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
                        
                        if ([(NSString *)[obj objectForKey:@"subject"] compare:[dic objectForKey:@"subject"]] >= NSOrderedSame) {
                            [arrDaySchedule insertObject:dic atIndex:i];
                            isAdded = YES;
                            break;
                        }
                        
                    }
                    
                    if (!isAdded) {
                        [arrDaySchedule addObject:dic];
                    }
                    
                }
            }
        }
        
        [datasource removeAllObjects];
        // 년월-년월일-배열(DIC->DIC->ARRAY) 형태를 년월일-배열(DIC->ARRAY) 형태로 바꾼다.
        for (NSString *strYearMonthKey in [resultDic allKeys]) {
            NSMutableDictionary *yearMonthDic = [resultDic objectForKey:strYearMonthKey];
            for (NSString *strYearMonthDay in [yearMonthDic allKeys]) {
                [datasource setObject:[yearMonthDic objectForKey:strYearMonthDay] forKey:strYearMonthDay];
            }
        } 
        
        
        // 오늘 스케쥴이 없다.
        if ([datasource count] < 1 ) {
            [datasource setObject:[[NSMutableArray alloc] initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"NO_SCHEDULE",@"NO_SCHEDULE",nil],nil]
                           forKey:@"NO_SCHEDULE"];
        }
        
        
        
        
        
        [datasourceAllKeys release];
        datasourceAllKeys = nil;
        datasourceAllKeys = [[[datasource allKeys] sortedArrayUsingSelector:@selector(compare:)] copy];
        
        
        
        
        
        
    }
    
//NSLog(@"keyword[%@] datasource[%@]", keyWord, datasource);
    [self.tableView1 reloadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate Implement
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    //NSLog(@"close");
    searchBar1.text = @"";
    [self searchSchedule:nil];
    [searchBar1 resignFirstResponder];
    //[self dismissModalViewControllerAnimated:YES];
    
	
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *tempString = [[searchBar text] stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];

//    NSString *searchText = [searchBar text];
    
    if ([tempString length] < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다.") 
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        // 내부 데이터 검색.
        //NSString *searchText = [searchBar text];
        [self searchSchedule:searchBar1.text];
        [searchBar1 resignFirstResponder];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[searchBar1 resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	return 20;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 40.0;	// CalendarScheduleRegisterTitleListCell.xib에 설정되어있는 height
	
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainScheduleRead" object:[[arr objectAtIndex:indexPath.row] objectForKey:@"appointmentid"]];

    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"didSelectRowAtIndexPath");
    
    
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [datasourceAllKeys count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSString *strYearMonthDayKey = [datasourceAllKeys objectAtIndex:section];

    
    if ( [[datasourceAllKeys objectAtIndex:section] isEqualToString:@"NO_SCHEDULE"] ) {
        return 1;
    } else {
        if ([[datasource objectForKey:strYearMonthDayKey] isKindOfClass:[NSMutableArray class]]) {
            return [[datasource objectForKey:strYearMonthDayKey] count];
        }
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
    NSString *sectionTitleString = @"   ";
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
    label.frame = CGRectMake(0, 0, 260, 25); 
    label.backgroundColor = [UIColor clearColor];
    label.text = [[sectionTitle componentsSeparatedByString:@" "] objectAtIndex:0]; 
    if ([label.text isEqualToString:@"(null)"]) label.text = @"";
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor colorWithRed:26.0/255 green:84.0/255 blue:136.0/255 alpha:1];
    
    UILabel *label2 = [[[UILabel alloc] init] autorelease]; 
    label2.frame = CGRectMake(265, 0, 53, 25); 
    label2.backgroundColor = [UIColor clearColor];
    label2.text = [[sectionTitle componentsSeparatedByString:@" "] objectAtIndex:1]; 
    if ([label2.text isEqualToString:@"(null)"])  label2.text = @"";
    label2.textAlignment = UITextAlignmentLeft;
    label2.lineBreakMode = UILineBreakModeClip;
    
    
    // Create header view and add label as a subview 
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease]; 
    view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_list_blue.png"]];
    [view addSubview:label]; 
    [view addSubview:label2]; 
    return view;


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

#pragma mark -
#pragma mark View Translation Process
- (void)viewWillAppearFunction {
        
    //datasource 에서 키워드 검색 결과를 반환한다.
    //[self searchSchedule:[self.searchBar1.text copy]];
    
	
	//[self.tableView1 reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	//만약 타인 일정보기로 와서 데이터가리로드 되야 한다면.. 화면을 MainView 로 이동 시키자.
    if (model.isNeedUpdateSelectedDate) {
        [super popOrPushViewController:@"CalendarMainViewController" animated:NO];
    } else { 
        //[self viewWillAppearFunction];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	datasource = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    model = [CalendarModel sharedInstance];
    
    //[self viewWillAppearFunction];
    
    self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"btn_calendar", @"일정"), NSLocalizedString(@"btn_search", @"검색")];
   
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
	
	[tableView1 release];
	[searchBar1 release];
	
	[datasource release];
	[datasourceAllKeys release];
    [super dealloc];
}


@end

//
//  CalendarScheduleRegisterViewController.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterViewController.h"
#import "CalendarScheduleRegisterListCell1.h"
#import "CalendarScheduleRegisterListCell2.h"
#import "CalendarFunction.h"
#import "TITokenFieldView.h"
#import "URL_Define.h"

#import "MailWriteController.h"

@implementation CalendarScheduleRegisterViewController

@synthesize tableView1;
@synthesize indicator;
@synthesize clipboard;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1111) {
		// 일정 등록 화면으로 이동한다.
        model.isNeedUpdateSelectedDate = YES; //새로 업데이트 하삼.
//        [super popViewController];        
        [super popOrPushViewController:@"CalendarMainViewController" animated:YES];
    }
}


- (void)responseScheduleRegistData {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_event_has_been_saved",@"일정이 등록되었습니다.")
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    
    alert.tag = 1111; // 임시로 팝 뷰 막음.
    [alert show];
    [alert release];        
    return;
    
}



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
	
    //NSLog(@"result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
    
//    code          응답코드
//    errDesc		에러메세지
//    totalPage		총페이지
//    totalCount	총갯수
    
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
		
        if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) { 
        } else {
        }
        
        [self responseScheduleRegistData]; //일정 등록이 완료 되었음을 알린다.
	} else if ( [rsltCode intValue] == 1 ) {
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
    
}

- (void)requestScheduleRegistData {
 
    
    // 일정 데이터를 생성하는 구간. ---- 여기서 부터 
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
    
    
    NSString *strRepeatEndDate = @"";
    NSString *strRepeatEndTime = @"";
    
    if (model.registerRepeatEndDate != nil) {
        strRepeatEndDate =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"yyyy-MM-dd"];
        strRepeatEndTime =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"HH:mm"];
    }
    
    //NSLog(@"strRepeatEnd [%@ %@] ", strRepeatEndDate, strRepeatEndTime);
    
    NSString *strInvateList = @"";
    NSString *strInvateEmailList = @"";
    if (model.registerInviteList != nil) {
        for (NSDictionary *dic in model.registerInviteList) {
            if ([strInvateList isEqualToString:@""]) {
                strInvateList = [dic objectForKey:@"name"];
                strInvateEmailList = [dic objectForKey:@"email"];
            } else {
                strInvateList = [NSString stringWithFormat:@"%@; %@", strInvateList, [dic objectForKey:@"name"]];
                strInvateEmailList = [NSString stringWithFormat:@"%@; %@", strInvateEmailList, [dic objectForKey:@"email"]];
            }                      
        }
    }
    //    subject		제목							
    //    contents		내용							
    //    location		장소							
    //    isalldayevent		하루종일 유무		true,false의 String으로 전달					
    //    minutesbeforestart		알림시간		분단위의 숫자로 입력			ex) 1시간전 60, 1일전 3600		
    //    starttime		시작시간		yyyy-MM-dd HH:mm 시분까지만 입력					
    //    endtime		종료시간		yyyy-MM-dd HH:mm 시분까지만 입력					
    //    attendees		초대자메일							
    //    recurrencetype		반복 타입		0:한번 , 1:매일, 2:주중 매일(월~금), 3:매주(현재요일), 4:매월(몇번째 현재요일), 5:매월(현재일), 6:매년(오늘날짜)    
    //    20110629 반복 타입 변경됨. 0:반복없음 , 1:매일, 2:매주, 3:매월, 4:매년(현재일자)    
    
    // 20110630 반복 타입변경.
    //recurrencetype		반복 타입	0:반복없음 , 1:매일, 2:매주, 3:매월, 4:매년(현재일자)						
    //recurrenceendtime;		반복종료일자	yyyy-MM-dd HH:mm 시분까지만 입력 (시작시간과 종료시간의 갭은 1년)						
    
    
    //NSString *registdate = [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyyMMdd"]; //전문에 사용 안함.
    NSString *subject = model.registerTitle; 
    NSString *contents = model.registerMemo;
    NSString *location = model.registerLocation;
    NSString *isalldayevent = (model.registerIsAllDayEvent)?@"true":@"false";//하루종일 값 체크 해야함.
    NSString *minutesbeforestart = [CalendarFunction getNoticeTime:[NSString stringWithFormat:@"%d", model.registerNotiType1]]; //분단위 숫자 입력.
    
    // 하루 종일 이라면 시간을 00:00 으로 강제 집행한다.
    NSString *starttime = @"";
    NSString *endtime = @"";
    if ( model.registerIsAllDayEvent ) {
        
        //주의 !
        // 하루종일 일정의 경우 종료일은 시작일 +1 일로 00:00 으로 셋팅한다.
        // 예를들어 2011-01-01 00:00 의 하루종일 일정이라면 시작일은 2011-01-01 00:00 ~ 종료일 2011-01-02 00:00 이 된다.
        
        starttime = [NSString stringWithFormat:@"%@ %@",
                     [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyy-MM-dd"],
                     [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"00:00"]];
        
        
        //하루종일 일정에서 종료일은 무조건 하루더 처리한다.
        NSDateComponents *dateComponentsEndDate = [[NSDateComponents alloc] init];
        dateComponentsEndDate.day = 1;
        endDate = [[[NSCalendar currentCalendar] dateByAddingComponents:dateComponentsEndDate 
                                                                toDate:endDate 
                                                               options:0] copy];
        [dateComponentsEndDate release];
        dateComponentsEndDate = nil;
        
        
        endtime = [NSString stringWithFormat:@"%@ %@",
                   [CalendarFunction getStringFromDate:endDate dateFormat:@"yyyy-MM-dd"],
                   [CalendarFunction getStringFromDate:endDate dateFormat:@"00:00"]];
        
        
        
        
    } else {
        starttime = [NSString stringWithFormat:@"%@ %@",
                     [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyy-MM-dd"],
                     [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"HH:mm"]];
        endtime = [NSString stringWithFormat:@"%@ %@",
                   [CalendarFunction getStringFromDate:endDate dateFormat:@"yyyy-MM-dd"],
                   [CalendarFunction getStringFromDate:endDate dateFormat:@"HH:mm"]];
    }
    
    
    NSString *attendees = strInvateEmailList;
    NSString *recurrencetype = [NSString stringWithFormat:@"%d", model.registerRepeatType];
    NSString *recurrenceendtime = [NSString stringWithFormat:@"%@ %@", strRepeatEndDate, strRepeatEndTime];
    if ( [recurrenceendtime isEqualToString:@" "] ) recurrenceendtime = @"";
    
//    NSString *NOTI_TYPE1 = [NSString stringWithFormat:@"%d", model.registerNotiType1];
//    NSString *NOTI_TYPE2 = [NSString stringWithFormat:@"%d", model.registerNotiType2];
    
        
    [endDate release];
    
    // 일정 데이터를 생성하는 구간. ---- 여기 까지    
            
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    callUrl = URL_createAppointmentInfo; // 일정생성
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    [requestDictionary setObject:subject forKey:@"subject"];
    [requestDictionary setObject:contents forKey:@"contents"];
    [requestDictionary setObject:location forKey:@"location"];
    [requestDictionary setObject:isalldayevent forKey:@"isalldayevent"];
    [requestDictionary setObject:minutesbeforestart forKey:@"minutesbeforestart"];
    [requestDictionary setObject:starttime forKey:@"starttime"];
    [requestDictionary setObject:endtime forKey:@"endtime"];
    [requestDictionary setObject:attendees forKey:@"attendees"];
    [requestDictionary setObject:recurrencetype forKey:@"recurrencetype"];
    [requestDictionary setObject:recurrenceendtime forKey:@"recurrenceendtime"];
    //NSLog(@"createAppointmentInfo requestDictionary [%@]",requestDictionary);    


//#define debug_no_send 1
#ifdef debug_no_send
    NSLog(@"createAppointmentInfo requestDictionary [%@]",requestDictionary); 
#else    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    //NSLog(@"end communication [%@] ",(result)?@"YES":@"NO");
	
    if (!result) {
        // error occurred
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_failed_to_save_your_event",@"일정 등록을 실패 하였습니다.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;	
    } 
#endif
    
}


#pragma mark -
#pragma mark CallBack Method
- (void)naviRigthbtnPress:(id)sender {

    
    
    if ( [model.registerTitle isEqualToString:@""] || model.registerTitle == nil ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_please_fill_the_title",@"제목을 등록하여 주십시요.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
        
        
    } else {
    
//        NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
//        
//        
//        NSString *strRepeatEndDate = @"";
//        NSString *strRepeatEndTime = @"";
//        
//        if (model.registerRepeatEndDate != nil) {
//            strRepeatEndDate =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"yyyyMMdd"];
//            strRepeatEndTime =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"HHmm"];
//        }
//        
//        NSString *strInvateList = @"";
//        
//        if (model.registerInviteList != nil) {
//            for (NSDictionary *dic in model.registerInviteList) {
//                if ([strInvateList isEqualToString:@""]) {
//                    strInvateList = [dic objectForKey:@"name"];
//                } else {
//                    strInvateList = [NSString stringWithFormat:@"%@|%@", strInvateList, [dic objectForKey:@"name"]];
//                }                      
//            }
//        }
//        
//        NSDictionary *dic = nil;
//        
//        dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//               [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyyMMdd"], @"DATE",
//               model.registerTitle, @"TITLE", 
//               model.registerLocation, @"LOCATION",
//               [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyy-MM-dd"], @"STR_DT",
//               [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"HH:mm"], @"STR_TM",
//               [CalendarFunction getStringFromDate:endDate dateFormat:@"yyyy-MM-dd"], @"END_DT",
//               [CalendarFunction getStringFromDate:endDate dateFormat:@"HH:mm"], @"END_TM",
//               [NSString stringWithFormat:@"%d", model.registerRepeatType], @"REPEAT_TYPE",
//               strRepeatEndDate, @"REPEAT_END_DT",
//               strRepeatEndTime, @"REPEAT_END_TM",
//               [NSString stringWithFormat:@"%d", model.registerNotiType1], @"NOTI_TYPE1",
//               [NSString stringWithFormat:@"%d", model.registerNotiType2], @"NOTI_TYPE2",
//               model.registerMemo, @"MEMO",
//               strInvateList, @"INVITE", nil];
//
//        //NSLog(@"regist data [%@]",dic);        
////        regist data [{
////            DATE = 20110628;
////            "END_DT" = 20110628;
////            "END_TM" = 2259;
////            INVITE = "\Uae40\Uacbd\Ucca0|\Uae40\Uba85\Ucca0";
////            LOCATION = 2;
////            MEMO = "1122\n3344";
////            "NOTI_TYPE1" = 3;
////            "NOTI_TYPE2" = 4;
////            "REPEAT_END_DT" = 20120628;
////            "REPEAT_END_TM" = 1059;
////            "REPEAT_TYPE" = 1;
////            "STR_DT" = 20110628;
////            "STR_TM" = 2159;
////            TITLE = 1;
////        }]
//        
//        
////        [model addSchedule:dic];
////        [dic release];
//        
//        
//        [endDate release];
        
        
        // 일정 등록 통신 탄다.
        [self requestScheduleRegistData];
        
        
    
	}
}


#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 || indexPath.section == 1) {	// CalendarScheduleRegisterListCell2.xib에 설정되어 있는 height
		return 120.0;
	} else if (indexPath.section == 4) {
		
		UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:17];		// xib에서 설정한 모임소개 라벨의 font
		CGFloat labelWidth = 622;											// xib에서 설정한 모임소개 라벨의 width
		UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
		
		NSString *strMemo = nil;
		if (model.registerMemo == nil || ![model.registerMemo isEqualToString:@""]) {
			strMemo = [model.registerMemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		} else {
			strMemo = NSLocalizedString(@"calendar_memo",@"메모");
		}

		CGSize labelSize = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
		
		if (labelSize.height > 406) {
			labelSize.height = 406;
		}
		
		return 9 + labelSize.height + 40;
		
	} else if (indexPath.section == 5) {
		
		// 사이즈를 잡아 준다.
		UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:17];		// xib에서 설정한 모임소개 라벨의 font
		CGFloat labelWidth = 400;											// xib에서 설정한 모임소개 라벨의 width
		UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
		
		NSString *strInvateList = @"";
		
        if (model.registerInviteList != nil) {
            for (NSDictionary *dic in model.registerInviteList ) {
                
                if ([strInvateList isEqualToString:@""]) {
                    strInvateList = [dic objectForKey:@"name"];
                } else {
                    strInvateList = [NSString stringWithFormat:@"%@, %@", strInvateList, [dic objectForKey:@"name"]];
                } 
            }
        } 
        
        if ( [strInvateList isEqualToString:@""] ) {
             strInvateList = NSLocalizedString(@"calendar_invitation",@"초대"); // 사이즈측정용
        } 
            
        CGSize labelSize = [strInvateList sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
        
        if (labelSize.height > 406) {
            labelSize.height = 406;
        }
        
        return 9 + labelSize.height + 50;
        
	}
	
	return 80.0;	// CalendarScheduleRegisterListCell1.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		case 0: {	// 제목 위치
			[super pushViewController:@"CalendarScheduleRegisterTitleViewController"];
		}	break;
		case 1: {	// 시작 종료
			[super pushViewController:@"CalendarScheduleRegisterTimeViewController"];
		}	break;
		case 2: {	// 반복
			if (indexPath.row == 0) {
				[super pushViewController:@"CalendarScheduleRegisterRepeatViewController"];
			} else {
				[super pushViewController:@"CalendarScheduleRegisterRepeatDetailViewController"];
			}
		}	break;
		case 3: {	// 미리알림
			// 제1알림인지 제2알림인지 다음 화면으로 전달
			model.registerEdittingNoti = indexPath.row;
			[super pushViewController:@"CalendarScheduleRegisterNoticeViewController"];
		}	break;
		case 4: {	// 메모
			[super pushViewController:@"CalendarScheduleRegisterMemoViewController"];
		}	break;
		case 5: {	// 초대

			
            
            
// 미리 넘겨줘야 할 연락처 정보가 있다면 아래 처럼 Array 에 Dictionary 를 담아주자.            
//            NSMutableArray *arrTemp = nil;
//            arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
//            
//            NSMutableArray *selectItem = [[self.dataTable indexPathsForSelectedRows] copy];
//            NSUInteger i, count = [selectItem count];
//            for (i = 0; i < count; i++) {
//                NSIndexPath * obj = [selectItem objectAtIndex:i];
//                
//                //NSLog(@"selected item [%@][%@]",obj,[[self.contactList objectAtIndex:obj.row] objectForKey:@"fullname"]);
//                
//                
//                NSString *name = [[self.contactList objectAtIndex:obj.row] objectForKey:@"fullname"];
//                NSString *email = [[self.contactList objectAtIndex:obj.row] objectForKey:@"fullname"];
//                
//                NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",email,@"email",nil];
//                
//                [arrTemp addObject:valueDic];
//                [valueDic release];
//            }
//            //결과가 완료되면 model.contactOptionDic 에 NSMutableArray 로 이름, 이메일 값을 Dictionary 로 값을 넣어주자
//            [model.contactOptionDic removeObjectForKey:@"selectedMember"];
//            [model.contactOptionDic setObject:arrTemp forKey:@"selectedMember"];            
            
            
            // 모델값을 설정한다.
            // 연락처 선택 옵션의 타이틀 및 타겟 등을 정의 한다.
            contactModel.contactOptionDic = nil; //초기화
            contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
            [contactModel.contactOptionDic setObject:NSLocalizedString(@"calendar_invitation",@"초대") forKey:@"title"];
            [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"calendar_invitation_list", @"초대목록")] forKey:@"items"];
            [contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
            [contactModel.contactOptionDic setObject:@"invite" forKey:@"callType"];
            
            if (model.registerInviteList != nil) {
                NSMutableArray *arrTemp = nil;
                arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in model.registerInviteList ) {
                    [arrTemp addObject:dic];
                }
                [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"]; 
            } 
            
			Class targetClass = NSClassFromString(@"ContactSelectViewController");
			
			id viewController = [[targetClass alloc] init];
			[self.navigationController pushViewController:viewController animated:YES];
			[viewController release];
			viewController = nil;
			
//            MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
//            [self presentModalViewController:mailWriteController animated:YES];
//            mailWriteController.titleNavigationBar.text = @"새로운 메시지";
//            [mailWriteController release];
            
            
            
		}	break;

		default:
			break;
	}
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    // 반복, 알림에 대하여.
    // 20110628 익스체인지 인터페이스에 반복의 종료 및 알림2번째 입력값은 없다.
    // 20110630 반복의 종료가 다시 부활 했다.
    BOOL exchange = YES;
    if ( exchange ) {
        switch (section) {
            case 2: {	// 반복
                if (model.registerRepeatType != 0) {
                    return 2;
                }
            }	break;
            case 3: {	// 알림
                if (model.registerNotiType1 != 0) {
// 두번째 알림 사용하려면 주석 해재.
//                    return 2;
                }
            }	break;
            default:
                break;
        }
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	static NSString *CustomCellIdentifier1 = @"CustomCellIdentifier1";
	static NSString *CustomCellIdentifier2 = @"CustomCellIdentifier2";
	
	UITableViewCell *cell = nil;

	if (indexPath.section == 0 || indexPath.section == 1) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier2];
		
		if (cell == nil) {
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterListCell2" owner:self options:nil];
			
			for (id oneObject in nib) {
				if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterListCell2")]) {
					cell = oneObject;
				}
			}
			
		}
	
		
		CalendarScheduleRegisterListCell2 *tmpCell = (CalendarScheduleRegisterListCell2 *)cell;

		
		switch (indexPath.section) {
			case 0: {
				// 오른쪽 라벨들은 감춘다.
				tmpCell.label3.hidden = YES;	
				tmpCell.label4.hidden = YES;

				if ([model.registerTitle isEqualToString:@""]) {
					tmpCell.label1.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
					tmpCell.label1.text = NSLocalizedString(@"btn_title",@"제목");
				} else {
					tmpCell.label1.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
					tmpCell.label1.text = model.registerTitle;
				}

				if ([model.registerLocation isEqualToString:@""]) {
					tmpCell.label2.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
					tmpCell.label2.text = NSLocalizedString(@"calendar_place",@"위치");
				} else {
					tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
					tmpCell.label2.text = model.registerLocation;
				}
				
			}	break;
			default: {
//				// 오른쪽 라벨들을 보여준다.
//				tmpCell.label3.hidden = NO;
//				tmpCell.label4.hidden = NO;
//				tmpCell.label3.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
//				tmpCell.label4.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
//				
//				tmpCell.label1.text = @"시작";
//				tmpCell.label2.text = @"종료";
//				
//				
//                // 날짜를 선택하지 않고 들어온경우 날짜를 선택 하여 준다. (오늘날짜.)
//                // model.selectedDate [2011-06-10 15:00:00 +0000]
//                if ( model.selectedDate == nil ) model.selectedDate = [NSDate date];
//                
//                // 일정 등록 화면이 처음 생성된 경우
//				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//				[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
//
//				if (model.registerStartDate == nil) {
//					// 일단 현재시간을 구한다.
//					NSTimeInterval hourMinuteInterval = (long)[[NSDate date] timeIntervalSince1970] % (60 * 60 * 24);
//					
//					// TODO: 아래 공식이 맞는지 확인 필요
//					// 분을 짤라 버린다. 
//					hourMinuteInterval -= ((long)hourMinuteInterval % (60 * 60)) - (60 * 60 * 10);
//					
//					model.registerStartDate = [[[NSDate alloc] initWithTimeInterval:hourMinuteInterval sinceDate:model.selectedDate] autorelease];
//				}
//				
//				NSLog(@"model.selectedDate [%@]", model.selectedDate);
//				NSLog(@"model.registerStartDate [%@]", model.registerStartDate);
//				// 시작
//				[dateFormatter setDateFormat:@"MMMM d일 (E) HH:mm"];
//				tmpCell.label3.text = [dateFormatter stringFromDate:model.registerStartDate];
//				
//				NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
//				
//				if ([CalendarFunction compare:endDate to:model.registerStartDate dateFormat:@"yyyyMMdd"] == NSOrderedSame) {
//					[dateFormatter setDateFormat:@"HH:mm"];
//				}
//				
//				tmpCell.label4.text = [dateFormatter stringFromDate:endDate];
//				
//				[endDate release];
//				endDate = nil;
//
//				[dateFormatter release];
                // 오른쪽 라벨들을 보여준다.
                tmpCell.label3.hidden = NO;
                tmpCell.label4.hidden = NO;
                tmpCell.label3.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
                tmpCell.label4.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
                
                tmpCell.label1.text = NSLocalizedString(@"calendar_start",@"시작");
                tmpCell.label2.text = NSLocalizedString(@"calendar_end",@"종료");
                
                // 일정 등록 화면이 처음 생성된 경우
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                if ( isKr ) {
                    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
                } else {
                    
                }
                if (model.registerStartDate == nil) {
                    // 일단 현재시간을 구한다.
                    NSTimeInterval hourMinuteInterval = (long)[[NSDate date] timeIntervalSince1970] % (60 * 60 * 24);
                    
                    // TODO: 아래 공식이 맞는지 확인 필요
                    // 분을 짤라 버린다. 
                    hourMinuteInterval -= ((long)hourMinuteInterval % (60 * 60)) - (60 * 60 * 10);
                    
                    model.registerStartDate = [[[NSDate alloc] initWithTimeInterval:hourMinuteInterval sinceDate:model.selectedDate] autorelease];
                }
                
                //NSLog(@"model.selectedDate[%@],model.registerStartDate[%@]", model.selectedDate,model.registerStartDate);
                
                // 하루종일 옵션 ON 상태
                if (model.registerIsAllDayEvent) {
                    // 시작
                    if ( isKr ) {
                        [dateFormatter setDateFormat:@"yyyy년 M월 d일 E"];
                    } else {
                        [dateFormatter setDateFormat:@"E d/M/yyyy"];
                    }
                    tmpCell.label3.text = [dateFormatter stringFromDate:model.registerStartDate];
                    
                    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
                    
                    tmpCell.label4.text = [dateFormatter stringFromDate:endDate];
                    
                    [endDate release];
                    endDate = nil;
                } else {	// 하루종일 옵션 OFF 상태
                    // 시작
                    if ( isKr ) {
                        [dateFormatter setDateFormat:@"MMMM d일 (E) HH:mm"];
                    } else {
                        [dateFormatter setDateFormat:@"(E) HH:mm d/MMMM"];
                    }
                    tmpCell.label3.text = [dateFormatter stringFromDate:model.registerStartDate];
                    
                    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
                    
                    if ([CalendarFunction compare:endDate to:model.registerStartDate dateFormat:@"yyyyMMdd"] == NSOrderedSame) {
                        [dateFormatter setDateFormat:@"HH:mm"];
                    }
                    
                    tmpCell.label4.text = [dateFormatter stringFromDate:endDate];
                    
                    [endDate release];
                    endDate = nil;
                }
                
                [dateFormatter release];

			}	break;
		}
		
	} else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier1];
		
		if (cell == nil) {
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterListCell1" owner:self options:nil];
			
			for (id oneObject in nib) {
				if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterListCell1")]) {
					cell = oneObject;
				}
			}
			
		}
		
		CalendarScheduleRegisterListCell1 *tmpCell = (CalendarScheduleRegisterListCell1 *)cell;

		switch (indexPath.section) {
			case 2:	{	// 반복
				if (indexPath.row == 0) {
					tmpCell.label1.text = NSLocalizedString(@"calendar_repeat",@"반복");
					tmpCell.label2.text = model.registerRepeatTypeString;
				} else {
					tmpCell.label1.text = NSLocalizedString(@"calendar_repeat_termination",@"반복종료");
					tmpCell.label2.text = model.registerRepeatEndDateString;
				}
			}	break;
			case 3: {	// 알림
				if (indexPath.row == 0) {
					tmpCell.label1.text = NSLocalizedString(@"calendar_alarm",@"알림");
					tmpCell.label2.text = model.registerNotiType1String;
				} else {
					tmpCell.label1.text = NSLocalizedString(@"calendar_second_alarm",@"두번째 알림");
					tmpCell.label2.text = model.registerNotiType2String;
				}
			}	break;
			case 4: {

				// 오른쪽 라벨은 감춘다.
				tmpCell.label2.hidden = YES;
				
				// 사이즈를 잡아 준다.
				UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:17];		// xib에서 설정한 모임소개 라벨의 font
				CGFloat labelWidth = 622;											// xib에서 설정한 모임소개 라벨의 width
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				NSString *strMemo = nil;
				if (model.registerMemo == nil || ![model.registerMemo isEqualToString:@""]) {
					strMemo = [model.registerMemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				} else {
					strMemo = NSLocalizedString(@"calendar_memo",@"메모");
				}
				
				CGSize labelSize = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
				
				if (labelSize.height > 406) {
					labelSize.height = 406;
				}
				
				tmpCell.label1.frame = CGRectMake(tmpCell.label1.frame.origin.x, 
												  tmpCell.label1.frame.origin.y, 
												  tmpCell.label1.frame.size.width, 
												  labelSize.height);

				if ([model.registerMemo isEqualToString:@""]) {
					tmpCell.label1.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
					tmpCell.label1.text = NSLocalizedString(@"calendar_memo",@"메모");
				} else {
					tmpCell.label1.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
					tmpCell.label1.text = model.registerMemo;
				}
				
			}	break;
			case 5: {
				
				tmpCell.label1.text = NSLocalizedString(@"calendar_invited_people",@"초대한 사람");
				
				// 사이즈를 잡아 준다.
				UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:17];		// xib에서 설정한 모임소개 라벨의 font
				CGFloat labelWidth = 400;											// xib에서 설정한 모임소개 라벨의 width
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				NSString *strInvateList = @"";
				
				if (model.registerInviteList != nil) {
                    for (NSDictionary *dic in model.registerInviteList ) {
                        
                        if ([strInvateList isEqualToString:@""]) {
                            strInvateList = [dic objectForKey:@"name"];
                        } else {
                            strInvateList = [NSString stringWithFormat:@"%@, %@", strInvateList, [dic objectForKey:@"name"]];
                        } 
                    }
                } else {
                    //strInvateList = @"사람"; // 사이즈측정용
                }

				
				
				CGSize labelSize = [strInvateList sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
				
				if (labelSize.height > 406) {
					labelSize.height = 406;
				}
				
				tmpCell.label2.textAlignment = UITextAlignmentLeft;
				tmpCell.label2.frame = CGRectMake(tmpCell.label2.frame.origin.x, 
												  tmpCell.label2.frame.origin.y+5, 
												  tmpCell.label2.frame.size.width, 
												  labelSize.height);
				
				tmpCell.label2.text = strInvateList;

			}	break;

			default:
				break;
		}
		
	}

	return cell;
	
}

#pragma mark -
#pragma mark View Translation Process

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    if ( [contactModel.contactOptionDic objectForKey:@"selectedMember"] != nil ) {
        model.registerInviteList = nil;
        model.registerInviteList = [contactModel.contactOptionDic objectForKey:@"selectedMember"];
    } else {
        // 취소 버튼 클릭등으로 모델 값이 들어오지 않으면 액션 처리 안함.
    }
    // 연락처 호출을 대비하여 클리어 해준다.
    [contactModel.contactOptionDic removeObjectForKey:@"select"];
    
	[self.tableView1 reloadData];
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
	
    self.title = NSLocalizedString(@"calendar_add_new_event",@"일정추가");
    
	model = [CalendarModel sharedInstance];
	
	// 왼쪽 취소
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonItemStylePlain];
	
	// 오른쪽 완료
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];
	
	/* 모델 초기화 */
	
	// 제목 위치
	model.registerTitle	   = @"";	// 제목
	model.registerLocation = @"";	// 위치
	
	// 시작 종료
	model.registerStartDate = nil;
	model.registerEndDateInterval = 60 * 60; // 시작일 + 1시간
	
    model.registerIsAllDayEvent = NO;
    
	// 반복, 반복종료
	model.registerRepeatType = 0;			// 없음
	model.registerRepeatTypeString = NSLocalizedString(@"calendar_none",@"없음");
	model.registerRepeatEndDate = nil;		// 안함
	model.registerRepeatEndDateString = @"";
	
	// 제1알림, 제2알림
	model.registerNotiType1 = 0;			// 안함
	model.registerNotiType1String = NSLocalizedString(@"calendar_no_alarm",@"안함");
	model.registerNotiType2 = 0;			// 안함
	model.registerNotiType2String = NSLocalizedString(@"calendar_no_alarm",@"안함");
	model.registerEdittingNoti = -1;
	
	// 메모
	model.registerMemo = @"";
	
	// 초대한 사람
	model.registerInviteList = nil;
	
    
    
    // 초대한 사람 목록을 받기 위한 연락처 모델.
    contactModel = [ContactModel sharedInstance];
    contactModel.contactOptionDic = nil;
    
    
    // 통신 초기화.
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;

    
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
	model.registerInviteList = nil; //초대 목록을 클리어 해준다.
	self.tableView1 = nil;
	
}


- (void)dealloc {
	
	[tableView1 release];

    [super dealloc];
}


@end

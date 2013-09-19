//
//  CalendarScheduleEditViewController.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleEditViewController.h"
#import "CalendarScheduleRegisterListCell1.h"
#import "CalendarScheduleRegisterListCell2.h"
#import "CalendarFunction.h"
#import "TITokenFieldView.h"
#import "URL_Define.h"
#import "NSDictionary+NotNilReturn.h"

#import "MailWriteController.h"

@implementation CalendarScheduleEditViewController

@synthesize tableView1;
@synthesize deleteButton;
@synthesize deleteButtonLabel;
@synthesize indicator;
@synthesize clipboard;

@synthesize communication_flag;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    
    if ( buttonIndex == 0 && alertView.tag == 11 ) { 
        // 모든 되풀이 일정 수정 취소시
    } else if ( buttonIndex == 1 && alertView.tag == 11 ) { 
        // 모든 되풀이 일정 수정 승낙시 
        [self requestScheduleEditData];
    } else if ( buttonIndex == 1 && alertView.tag == 21 ) { 
        // 모든 되풀이 일정 삭제 승낙시 
        [self requestScheduleDeleteData];
    } else {
        if( alertView.tag == 1111 ) { // 일정 수정
            // 일정 화면으로 이동한다.
            model.isNeedUpdateSelectedDate = YES; //새로 업데이트 하삼.
            //        [super popViewController];        
            [super popOrPushViewController:@"CalendarMainViewController" animated:YES];
        } else if ( alertView.tag == 2222 ) { // 일정 삭제
            // 일정 화면으로 이동한다.
            model.isNeedUpdateSelectedDate = YES; //새로 업데이트 하삼.
            [super popOrPushViewController:@"CalendarMainViewController" animated:YES];
        }
    }
}


- (void)responseScheduleEditData {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_schedule_has_been_modified",@"일정이 수정되었습니다.")
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    
    alert.tag = 1111; // 임시로 팝 뷰 막음.
    [alert show];
    [alert release];        
    return;
    
}

- (void)responseScheduleDeleteData {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_event_has_been_deleted",@"일정이 삭제되었습니다.")
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    
    alert.tag = 2222; // 임시로 팝 뷰 막음.
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
        
        self.clipboard = nil;
        if ( self.communication_flag == DELETE_DATA ) {
            
            [self responseScheduleDeleteData]; //일정 삭제가 완료 되었음을 알린다.
        } else if ( self.communication_flag == UPDATE_DATA ) {        
        
            [self responseScheduleEditData]; //일정 수정이 완료 되었음을 알린다.
        }
	} else if([rsltCode intValue] == 1) {
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

- (void)requestScheduleDeleteData {
    
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    callUrl = URL_deleteAppointmentInfo; // 일정삭제
    self.communication_flag = DELETE_DATA;
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    //일정 고유키.
    [requestDictionary setObject:[model.viewSchedule notNilObjectForKey:@"appointmentid"] forKey:@"appointmentid"];
     
//    NSLog(@"%@", model.viewSchedule);
    
    //NSLog(@"deleteAppointmentInfo requestDictionary [%@]",requestDictionary);    
    
    
//#define debug_no_send 1
#ifdef debug_no_send
#else    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    //NSLog(@"end communication [%@] ",(result)?@"YES":@"NO");
	
    if (!result) {
        // error occurred
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_failed_to_delete_event",@"일정을 삭제 실패 하였습니다.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;	
    } 
#endif

}

- (void)requestScheduleEditData {
 
    
    // 일정 데이터를 생성하는 구간. ---- 여기서 부터 
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
    
    
    NSString *strRepeatEndDate = @"";
    NSString *strRepeatEndTime = @"";
    
    if (model.registerRepeatEndDate != nil) {
        strRepeatEndDate =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"yyyy-MM-dd"];
        strRepeatEndTime =[CalendarFunction getStringFromDate:model.registerRepeatEndDate dateFormat:@"HH:mm"];
    }
    
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
        
//        strInvateList = [strInvateEmailList stringByReplacingOccurrencesOfString:@"," withString:@";"];
//        strInvateList = [strInvateList stringByReplacingOccurrencesOfString:@" " withString:@""];
//        strInvateEmailList = [strInvateEmailList stringByReplacingOccurrencesOfString:@"," withString:@";"];
//        strInvateEmailList = [strInvateEmailList stringByReplacingOccurrencesOfString:@" " withString:@""];



    }
    if ([strInvateEmailList isEqualToString:@""]) {
    }else{
        strInvateEmailList = [NSString stringWithFormat:@"%@; ", strInvateEmailList];

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
    
    [endDate release];
    
    // 일정 데이터를 생성하는 구간. ---- 여기 까지    
            
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    callUrl = URL_updateAppointmentInfo; // 일정생성
    self.communication_flag = UPDATE_DATA;
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
    //일정 고유키.
    [requestDictionary setObject:[model.viewSchedule notNilObjectForKey:@"appointmentid"] forKey:@"appointmentid"];
    
    //NSLog(@"createAppointmentInfo requestDictionary [%@]",requestDictionary);    


//#define debug_no_send 1
#ifdef debug_no_send
    NSLog(@"updateAppointmentInfo requestDictionary [%@]",requestDictionary);
#else    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    //NSLog(@"end communication [%@] ",(result)?@"YES":@"NO");
	
    if (!result) {
        // error occurred
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_failed_to_modify_your_schedule",@"일정을 수정 실패 하였습니다.")
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
    
        
        if ( [[model.viewSchedule notNilObjectForKey:@"recurrencetype"] intValue] > 0 ) {
            // 반복 일정을 수정할 경우에는 알림 메시지를 표현한다.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"반복일정을 수정할경우에는 모든 되풀이 항목이 수정됩니다."
                                                           delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"승인", nil];
            
            [alert setTag:11];
            [alert show];
            [alert release];
            return;
            
        } else {
            // 일정 수정 통신 탄다.
            [self requestScheduleEditData];    
        }
        
	}
}

-(IBAction) deleteButtonClicked {
    
    //show delete Action Sheet
    
                
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil]; 
    
    [menu addButtonWithTitle:NSLocalizedString(@"calendar_delete_event",@"일 정 삭 제")];
    
    [menu addButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소")];
    [menu setCancelButtonIndex:menu.numberOfButtons - 1];
    
    [menu showInView:self.view];
    [menu release];
        
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"click button index [%d]",buttonIndex);
    
    if ( buttonIndex ==  0 ) {
        // 일정 삭제 통신 탄다.
        
        // 되풀이 일정 확인.
        if ( [[model.viewSchedule notNilObjectForKey:@"recurrencetype"] intValue] > 0 ) {
            // 반복 일정을 수정할 경우에는 알림 메시지를 표현한다.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"반복일정을 삭제할경우에는 모든 되풀이 항목이 삭제됩니다."
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"btn_cancel",@"취소") otherButtonTitles:@"승인", nil];
            
            [alert setTag:21];
            [alert show];
            [alert release];
            return;
            
        } else {
            [self requestScheduleDeleteData];
        }
    } else {
        //취소버튼 클릭.
    }
}


#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 || indexPath.section == 1) {	// CalendarScheduleRegisterListCell2.xib에 설정되어 있는 height
		return 120.0;
	} else if (indexPath.section == 4) {
		
		UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:22];		// xib에서 설정한 모임소개 라벨의 font
		CGFloat labelWidth = 622;											// xib에서 설정한 모임소개 라벨의 width
		UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
		
		NSString *strMemo = nil;
		if (model.registerMemo == nil || ![model.registerMemo isEqualToString:@""]) {
			strMemo = [model.registerMemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		} else {
			strMemo = NSLocalizedString(@"calendar_memo",@"메모");
		}

		CGSize labelSize = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];

		
        
// 20110715 메모 모든 내용 보여줌.        
//		if (labelSize.height > 206) {
//			labelSize.height = 206;
//		}
		
		return 9 + labelSize.height + 40;
		
	} else if (indexPath.section == 5) {
		
		// 사이즈를 잡아 준다.
		UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:22];		// xib에서 설정한 모임소개 라벨의 font
		CGFloat labelWidth = 400;											// xib에서 설정한 모임소개 라벨의 width
		UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
		
		NSString *strInvateList = @"";
//NSLog(@"일정 편집의 초대 목록 사이즈 : [%@]", model.registerInviteList);				
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
        
        if (labelSize.height > 606) {
            labelSize.height = 606;
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

//            // 모델값을 설정한다.
//            // 연락처 선택 옵션의 타이틀 및 타겟 등을 정의 한다.
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
//            초대 수정 안되서 우선 맊는다.
            
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"초대한 사람 편집은 익스체인지 2007에서 지원하지 않습니다."
//                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//            
//            [alert show];
//            [alert release];        
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            
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
    // 익스체인지 인터페이스에 반복의 종료 및 알림2번째 입력값은 없다.
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
// 두번째 알림 사용하려면 주석 해재.
//                    return 2;
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

                
                // 오른쪽 라벨들을 보여준다.
                tmpCell.label3.hidden = NO;
                tmpCell.label4.hidden = NO;
                tmpCell.label3.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
                tmpCell.label4.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:136.0/255 alpha:1];
                
                tmpCell.label1.text = NSLocalizedString(@"calendar_start",@"시작");
                tmpCell.label2.text = NSLocalizedString(@"calendar_end",@"종료");
                
                // 일정 등록 화면이 처음 생성된 경우
                if ( model.selectedDate == nil ) model.selectedDate = [NSDate date];
                
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
                        [dateFormatter setDateFormat:@"E M d yyyy"];
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
                        [dateFormatter setDateFormat:@"MMMM d (E) HH:mm"];
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
				UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:22];		// xib에서 설정한 모임소개 라벨의 font
				CGFloat labelWidth = 620;											// xib에서 설정한 모임소개 라벨의 width
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				NSString *strMemo = nil;
				if (model.registerMemo == nil || ![model.registerMemo isEqualToString:@""]) {
					strMemo = [model.registerMemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				} else {
					strMemo = NSLocalizedString(@"calendar_memo",@"메모");
				}
				
				CGSize labelSize = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];

//20110715 메모 전체 텍스트 표현.				
//				if (labelSize.height > 206) {
//					labelSize.height = 206;
//				}
				
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
                tmpCell.label1.frame = CGRectMake(tmpCell.label1.frame.origin.x, 
												  tmpCell.label1.frame.origin.y, 
												  tmpCell.label1.frame.size.width, 
												  tmpCell.label1.frame.size.height);

				tmpCell.label1.text = NSLocalizedString(@"calendar_invited_people",@"초대한 사람");
				
				// 사이즈를 잡아 준다.
				UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:22];		// xib에서 설정한 모임소개 라벨의 font
				CGFloat labelWidth = 400;											// xib에서 설정한 모임소개 라벨의 width
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				NSString *strInvateList = @"";
//NSLog(@"일정 편집의 초대 목록 표현 : [%@]", model.registerInviteList);				
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
				
				if (labelSize.height > 606) {
					labelSize.height = 606;
				}
				
				tmpCell.label2.textAlignment = UITextAlignmentLeft;
				tmpCell.label2.frame = CGRectMake(tmpCell.label2.frame.origin.x, 
												  tmpCell.label2.frame.origin.y, 
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

        //저장 했으면 다시 클리어 시켜준다.
        [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
        
    } else {
        //취소 나 다시 돌아왔을경우 클리어 시키지 않는다.
        
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
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	model = [CalendarModel sharedInstance];
	
	// 왼쪽 취소
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonItemStylePlain];
	
	// 오른쪽 완료
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];
	
	/* 모델 초기화 */
	
	// 제목 위치
	model.registerTitle	   = [model.viewSchedule notNilObjectForKey:@"subject"];	// 제목
	model.registerLocation = [model.viewSchedule notNilObjectForKey:@"location"];	// 위치
	
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ( isKr ){
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        
    }
    NSDate *registerStartDate = [dateFormatter dateFromString:[model.viewSchedule notNilObjectForKey:@"starttime"]];
    NSDate *registerEndDateInterval = [dateFormatter dateFromString:[model.viewSchedule notNilObjectForKey:@"endtime"]];
    NSTimeInterval registerEndDateTimeInterval = [registerEndDateInterval timeIntervalSinceDate:registerStartDate];
    [dateFormatter release];
    
	// 시작(NSDate) 종료(NSTimeInterval)
	model.registerStartDate = registerStartDate;
	//model.registerEndDateInterval = 60 * 60; // 시작일 + 1시간
	model.registerEndDateInterval = registerEndDateTimeInterval;
    
    
    
    // 시간 인터벌은 다음과 같다. 
    // 하루종일 플래그가 없을경우 - 현행 유지
    // 하루종일 플래그가 있을경우 - 종료일이 00:00 이고 종료일 -1 일이 시작일과 동일할경우 시간 인터벌은 0 이다.
    
    if ( [[model.viewSchedule notNilObjectForKey:@"isalldayevent"] isEqualToString:@"true"] ) {
        //종료일이 00:00 으로 끝날때.
        if ( [[[model.viewSchedule objectForKey:@"endtime"] substringWithRange:NSMakeRange(11, 5)] isEqualToString:@"00:00"] ) {
            NSDateComponents *dateComponentsEndDate = [[NSDateComponents alloc] init];
            dateComponentsEndDate.day = -1;
            registerEndDateInterval = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponentsEndDate 
                                                                    toDate:registerEndDateInterval 
                                                                   options:0];
            [dateComponentsEndDate release];
            dateComponentsEndDate = nil;
            if ( [registerStartDate compare:registerEndDateInterval] == NSOrderedSame ) {
                model.registerEndDateInterval = 0;
            } else {
                //시작일과 종료일이 같지 않을경우는.. 종료일을 하루 빼준날을 대입한다.
                registerEndDateTimeInterval = [registerEndDateInterval timeIntervalSinceDate:registerStartDate];
                model.registerEndDateInterval = registerEndDateTimeInterval;
            }
        }
    }
    
    // 하루종일 체크
    // 일단 모델에 값을 박아 놓고.. 시작 종료 시간을 변경하면 모델이 갱신 되니깐. 그때 판단해도 됨.
    model.registerIsAllDayEvent = [[model.viewSchedule notNilObjectForKey:@"isalldayevent"] isEqualToString:@"true"]?YES:NO;
    
	
    // 반복, 반복종료 hasrecurrences 이건.. 반복 여부값 true false 임. 이걸 대입할수는 없음. 전문 변경해야함.
	model.registerRepeatType = 0;			// 없음
	model.registerRepeatTypeString = NSLocalizedString(@"calendar_no_alarm",@"없음");
	model.registerRepeatEndDate = nil;		// 안함
	model.registerRepeatEndDateString = @"";
	
    
    model.registerRepeatType = [[model.viewSchedule notNilObjectForKey:@"recurrencetype"] intValue];
    if ( model.registerRepeatType == 0 ) { 
        model.registerRepeatTypeString = NSLocalizedString(@"calendar_no_alarm",@"없음");
    } else if ( model.registerRepeatType == 1 ) { 
        model.registerRepeatTypeString = NSLocalizedString(@"calendar_everday",@"매일");
    } else if ( model.registerRepeatType == 2 ) {
        model.registerRepeatTypeString = NSLocalizedString(@"calendar_everyweek",@"매주");
    } else if ( model.registerRepeatType == 3 ) {
        model.registerRepeatTypeString = NSLocalizedString(@"calendar_every_month",@"매월");
    } else if ( model.registerRepeatType == 4 ) {
        model.registerRepeatTypeString = NSLocalizedString(@"calendar_every_year",@"매년");
    }
    
    if ( model.registerRepeatType > 0 ) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        model.registerRepeatEndDate = [dateFormatter dateFromString:[model.viewSchedule notNilObjectForKey:@"recurrenceendtime"]];
        
        if ( isKr ) {
            [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E"];
            [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
        } else {
            [dateFormatter setDateFormat:@"E d/MMMM/YYYY"];
        }
        model.registerRepeatEndDateString = [dateFormatter stringFromDate:model.registerRepeatEndDate];
        [dateFormatter release];
        dateFormatter = nil;
        
    }
    
    
    noticeTimeList  = [[NSDictionary alloc] initWithObjectsAndKeys:
                       NSLocalizedString(@"btn_no_alarm",@"안함"),    @"",    @"0", NSLocalizedString(@"btn_no_alarm",@"안함"),
                       [NSString stringWithFormat:@"5%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],  @"5",   @"1", [NSString stringWithFormat:@"5%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                       [NSString stringWithFormat:@"10%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")], @"10",  @"2", [NSString stringWithFormat:@"10%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                       [NSString stringWithFormat:@"15%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")], @"15",  @"3", [NSString stringWithFormat:@"15%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                       [NSString stringWithFormat:@"30%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")], @"30",  @"4", [NSString stringWithFormat:@"30%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                       [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],@"60",   @"5", [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                       [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],@"120",  @"6", [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                       [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],@"180",  @"7", [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                       [NSString stringWithFormat:@"4%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],@"240",  @"8", [NSString stringWithFormat:@"4%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                       [NSString stringWithFormat:@"8%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],@"480",  @"9", [NSString stringWithFormat:@"8%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                       [NSString stringWithFormat:@"0.5%@",NSLocalizedString(@"calendar_days_before", @"일 전")],@"720", @"10", [NSString stringWithFormat:@"0.5%@",NSLocalizedString(@"calendar_days_before", @"일 전")],
                       [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_days_before", @"일 전")],  @"1440", @"11", [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_days_before", @"일 전")],
                       [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_days_before", @"일 전")],  @"2880", @"12", [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_days_before", @"일 전")],
                       [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_days_before", @"일 전")],  @"4320", @"13", [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_days_before", @"일 전")],
                       [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")],  @"10080", @"14", [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")],
                       [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")],  @"20160", @"15", [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")],
                       NSLocalizedString(@"btn_exact_time",@"정각"),    @"0",     @"16", NSLocalizedString(@"btn_exact_time",@"정각"),
                       nil];
	
    // 제1알림, 제2알림
	model.registerNotiType1String = [noticeTimeList objectForKey:[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"]];
    model.registerNotiType1 = [[noticeTimeList objectForKey:model.registerNotiType1String] intValue];			
//	// 20110629 제2알림은 사용 안함.
//	model.registerNotiType2 = 0;			// 안함
//	model.registerNotiType2String = @"안함";
	model.registerEdittingNoti = -1;
	
    
    
	// 메모
	model.registerMemo = [model.viewSchedule notNilObjectForKey:@"contents"];
	
	// 초대한 사람
	model.registerInviteList = nil;
	if ( ![[model.viewSchedule notNilObjectForKey:@"displayto"] isEqualToString:@""] ) {
        // 이거.. name, email : dictionary 로 처리해야함.
//        NSLog(@"나와model.viewSchedule[%@]", model.viewSchedule);
//null check start -->
        NSMutableArray *arrTemp = nil;
        arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *arrDisplary = [[NSArray alloc] init];
        NSArray *arrAddress = [[NSArray alloc] init];
        arrDisplary = [[model.viewSchedule notNilObjectForKey:@"displayto"] componentsSeparatedByString:@"; "];
        arrAddress = [[model.viewSchedule notNilObjectForKey:@"mailaddressto"] componentsSeparatedByString:@"; "];
        NSMutableArray *arrMutableDisplay = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *arrMutableAddress = [[NSMutableArray alloc]initWithCapacity:0];
        [arrMutableDisplay removeAllObjects];
        [arrMutableAddress removeAllObjects];
        [arrMutableDisplay addObjectsFromArray:arrDisplary];
        [arrMutableAddress addObjectsFromArray:arrAddress];
        [arrMutableDisplay removeObject:@""];
        [arrMutableAddress removeObject:@""];
//        NSLog(@"제발수정좀%@", arrMutableDisplay);
//        NSLog(@"%@", arrMutableAddress);
 //null check end -->

//        int i = 0;
//        for (NSString *member in arrMutableDisplay) {
//            
//            NSArray *emailArr = arrMutableAddress;
//            
//            NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:member,@"name",[NSString stringWithFormat:@"%@",[emailArr objectAtIndex:i]],@"email",nil];
//            [arrTemp addObject:valueDic];
//            [valueDic release];
//            i++;
//        }
        
        
        NSString *name = @"";
        NSString *email = @"";


        for (int i=0; i < [arrMutableAddress count]; i++) {//dic으로 만듬
            if ([[arrMutableAddress objectAtIndex:i]isEqualToString:@""] || [arrMutableAddress objectAtIndex:i] == nil || [[arrMutableAddress objectAtIndex:i]isEqualToString:@""""] ) {
            }else {
                email = [arrMutableAddress objectAtIndex:i];
            }
            if ([[arrMutableDisplay objectAtIndex:i]isEqualToString:@""] || [arrMutableDisplay objectAtIndex:i] == nil || [[arrMutableDisplay objectAtIndex:i]isEqualToString:@""""]){
            }else {
                name = [arrMutableDisplay objectAtIndex:i];
            }
            NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",email,@"email",nil];
            
            [arrTemp addObject:valueDic];
            [valueDic release];
            
        }

        
//        int i = 0;
//        for (NSString *member in [[model.viewSchedule notNilObjectForKey:@"displayto"] componentsSeparatedByString:@"; "]) {
//            
//            NSArray *emailArr = [[model.viewSchedule notNilObjectForKey:@"mailaddressto"] componentsSeparatedByString:@"; "];
//            
//            NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:member,@"name",[NSString stringWithFormat:@"%@",[emailArr objectAtIndex:i]],@"email",nil];
//            [arrTemp addObject:valueDic];
//            [valueDic release];
//            i++;
//        }

        
        
        
        
        model.registerInviteList = arrTemp;
        
    }
    
    

//    NSLog(@"나와model.viewSchedule[%@]", model.viewSchedule);
    // 초대한 사람 목록을 받기 위한 연락처 모델.
    contactModel = [ContactModel sharedInstance];
    
    //didwillAppear 에서 모델값이 초기화 되는것을 방지하기 위해 값을 미리 할당한다.
    if ( model.registerInviteList != nil ) {
        [contactModel.contactOptionDic setObject:model.registerInviteList forKey:@"selectedMember"];
    }
    
    
    // 통신 초기화.
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;

    self.title = NSLocalizedString(@"calendar_edit_schedule",@"일정편집");
    
    self.deleteButtonLabel.text = NSLocalizedString(@"calendar_delete_event", @"일정삭제");
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
}


- (void)dealloc {
	
	[tableView1 release];
    [deleteButton release];
    [deleteButtonLabel release];
    [noticeTimeList release];
    [super dealloc];
}


@end

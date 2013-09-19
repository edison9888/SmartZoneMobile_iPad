//
//  CalendarScheduleReadViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleReadViewController.h"
#import "CalendarScheduleReadListCell1.h"
#import "CalendarScheduleReadListCell2.h"	// 알림
#import "CalendarScheduleReadListCell3.h"	// 메모
#import "CalendarScheduleReadListCell4.h"	// 초대한 사람
#import "NSDictionary+NotNilReturn.h"
#import "URL_Define.h"
#import "AttachmentCustomCell.h"
#import "FileAttachmentViewController.h"


@implementation CalendarScheduleReadViewController

@synthesize tableView1;
@synthesize indicator;
@synthesize clipboard;
@synthesize attachmentFileArray;
#pragma mark -
#pragma mark Local Method

- (NSString *)getKo_KRLocaleTimeStringWithTimeString:(NSString *)aStrTime {
	
	// 이거 로케일로 어떻게 하면 될꺼 같은데... 나중에 찾아서 고쳐야지...
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


//시작일을 표현한다.
- (NSString *)getStartTimeStr {
    
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
    //시작일은 무조건 다음과 같은 형식으로 표현된다.
    //xxxx년 x월 x일 x요일
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
	
    [dateFomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateOrg = [dateFomatter dateFromString:[model.viewSchedule notNilObjectForKey:@"starttime"]];
    
    if ( isKr ) {
        [dateFomatter setDateFormat:@"YYYY년 MMMM dd일 EEEE"];
        [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        [dateFomatter setDateFormat:@"EEEE dd/MMMM/YYYY"];
    }
    NSString *dateString = [dateFomatter stringFromDate:dateOrg];
    
	[dateFomatter release];
	dateFomatter = nil;
    
    return dateString;
}
//종료일을 표현한다.
- (NSString *)getEndTimeStr {
    
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
    //종료일은 무조건 다음과 같은 형식으로 표현된다.
    
    // if 하루종일 플래그가 있을경우 : 하루종일
    // else 
    // starttime ~ endtime (오전9시에서~오전10시까지)
    // 혹은 종료일이 시작일과 다를경우
    // starttime ~ endtime (오전9시에서~xxxx년 x월 x일 x요일 오후10시까지) 
    // 로 표현한다.
    // 문제점은 하루종일 플래그가 걸려 있는데 2011-02-02 00:00 ~ 2011-02-03 00:00 일경우이다.
    // 이경우는 (xxxx년 x월 x일 x요일까지 하루종일) 으로 표현하자.
    // 하루종일 플래그에서 endtime 값이 00:00 일경우는 하루 전으로 표현하자.
    
    NSString *returnStr = @"";
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
	
    [dateFomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *starttime = [model.viewSchedule notNilObjectForKey:@"starttime"];
    NSString *endtime = [model.viewSchedule notNilObjectForKey:@"endtime"];
    NSDate *dateStart = [dateFomatter dateFromString:starttime];
    NSDate *dateEnd = [dateFomatter dateFromString:endtime];
    
    if ( isKr ) {
        [dateFomatter setDateFormat:@"YYYY년 MMMM dd일 EEEE"];
        [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    } else {
        [dateFomatter setDateFormat:@"EEEE dd/MMMM/YYYY"];
    }
    
    if ( [[model.viewSchedule notNilObjectForKey:@"isalldayevent"] isEqualToString:@"true"] ) {
        if ( [starttime isEqualToString:endtime] ) {
            returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
        } else { 
            
            //종료일이 00:00 으로 끝날때.
            if ( [[[model.viewSchedule objectForKey:@"endtime"] substringWithRange:NSMakeRange(11, 5)] isEqualToString:@"00:00"] ) {
                
                NSDateComponents *dateComponentsEndDate = [[NSDateComponents alloc] init];
                dateComponentsEndDate.day = -1;
                dateEnd = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponentsEndDate 
                                                                        toDate:dateEnd 
                                                                       options:0];
                [dateComponentsEndDate release];
                dateComponentsEndDate = nil;
                if ( [dateStart compare:dateEnd] == NSOrderedSame ) {
                    returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
                } else {
                    returnStr = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:dateEnd],NSLocalizedString(@"calendar_allday_until_the ~",@"~까지 하루종일")];
                }
            } else {
                returnStr = [NSString stringWithFormat:@"%@ %@",[dateFomatter stringFromDate:dateEnd],NSLocalizedString(@"calendar_allday_until_the ~",@"~까지 하루종일")];
            }
        }
    } else {
        
        //시작일과 종료일이 같으며 시간만 다를때.
        NSString *strSTime = [starttime substringWithRange:NSMakeRange(0, 10)];
        NSString *strETime = [endtime substringWithRange:NSMakeRange(0, 10)];
        [dateFomatter setDateFormat:@"HHmm"];
        NSString *timeNameSTime = [self getKo_KRLocaleTimeStringWithTimeString:[dateFomatter stringFromDate:dateStart]];
        NSString *timeNameETime = [self getKo_KRLocaleTimeStringWithTimeString:[dateFomatter stringFromDate:dateEnd]];
        
        if ( [strSTime isEqualToString:strETime] ) {
            //(오전9시에서~오전10시까지)
            if ( isKr ) {
                returnStr = [NSString stringWithFormat:@"%@에서~%@까지",timeNameSTime,timeNameETime];
            } else {
                returnStr = [NSString stringWithFormat:@"%@ ~ %@",timeNameSTime,timeNameETime];
            }
        } else {
            
            //년도가 같을때
            //(오전9시에서~x월 x일 x요일 오후10시까지)
            if ( isKr ) {
                [dateFomatter setDateFormat:@"MMMM dd일 EEEE"];
                [dateFomatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
                returnStr = [NSString stringWithFormat:@"%@에서~%@ %@까지",
                             timeNameSTime,
                             [dateFomatter stringFromDate:dateEnd],
                             timeNameETime
                             ];
            } else {
                [dateFomatter setDateFormat:@"EEEE dd/MMMM"];
                returnStr = [NSString stringWithFormat:@"%@ ~%@ %@",
                             timeNameSTime,
                             [dateFomatter stringFromDate:dateEnd],
                             timeNameETime
                             ];
            }
            
            //년도가 다를때
            //(오전9시에서~xxxx년 x월 x일 x요일 오후10시까지)
            
        }
        
        
    }
        
    
    [dateFomatter release];
	dateFomatter = nil;
    
    
    return returnStr;
    
}


#pragma mark -
#pragma mark CallBack Method
// 오른쪽 내비게이션 버튼이 눌렸을 때
- (void)naviRigthbtnPress:(id)sender {
    
//    //내 일정인 경우에만 유효함. 일정 편집 화면으로 이동.
//    
//    [super pushViewController:@"CalendarScheduleEditViewController"];

    
    
    
    
    //    우선 편집이 지원 안되서 수정  
    if ([[model.viewSchedule notNilObjectForKey:@"hasrecurrences"]isEqualToString:@"true"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"반복 일정에 대한 수정 및 삭제는\n 익스체인지 2007에서 지원하지\n 않습니다."
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];

    }else if(![[model.viewSchedule notNilObjectForKey:@"responsestatus"]isEqualToString:@"ORGANIZED"] && ![[model.viewSchedule notNilObjectForKey:@"responsestatus"]isEqualToString:@"NONE"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"승인 또는 거절등의 응답을 하지 않은 초대 일정에 대해서는 SmartZone에서 편집 및 삭제가 불가능 합니다."
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];

    }else{
        [super pushViewController:@"CalendarScheduleEditViewController"];
    }
    

}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *type = [cellTypes objectAtIndex:indexPath.row];
        
        if ([type isEqualToString:@"title"]) {
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:20];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            NSString *strTitle = nil;
            
            
            if ( ![[model.viewSchedule notNilObjectForKey:@"subject"] isEqualToString:@""] ) {
                strTitle = [[model.viewSchedule notNilObjectForKey:@"subject"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            } else {
                strTitle = @"새로운 이벤트";
            }
            
            CGSize labelSize1 = [strTitle sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            // 위치
            CGSize labelSize2 = CGSizeMake(640, 0);
            labelFont = [UIFont fontWithName:@"Helvetica" size:16];
            
            if ( ![[model.viewSchedule notNilObjectForKey:@"location"] isEqualToString:@""] ) {
                labelSize2 = [[model.viewSchedule notNilObjectForKey:@"location"] sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            }
            
            // 시작, 종료
            CGSize labelSize3 = CGSizeMake(640, 18);
            CGSize labelSize4 = CGSizeMake(640, 18);
            
            return 9 + labelSize1.height + labelSize2.height + 4 + labelSize3.height + labelSize4.height + 10;
            
        } else if ([type isEqualToString:@"noti"]) {
            
            /*	2번째 알림 사용하지 않음	
             if (model.registerNotiType2 != 0) {
             return 85;
             } else {
             return 85 - 21;
             }
             */		
            return 85 - 21;
            
        } else if ([type isEqualToString:@"memo"]) {
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            NSString *strMemo = nil;
            strMemo = [[model.viewSchedule notNilObjectForKey:@"contents"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize labelSize1 = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            return 33 + labelSize1.height + 10;
            
        } else if ([type isEqualToString:@"invite"]) {
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            NSString *strInvateList = @"";
            if ( ![[model.viewSchedule notNilObjectForKey:@"displayto"] isEqualToString:@""]) {
                
                strInvateList = [[model.viewSchedule notNilObjectForKey:@"displayto"] stringByReplacingOccurrencesOfString:@"; " withString:@", "];
                
            }
            
            CGSize labelSize1 = [strInvateList sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            return 33 + labelSize1.height + 10;
        }
        
        
        return 0.0;	

    }else if(indexPath.section == 1){
        return 44.0;
    }
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    switch (section) {
        case 0:
            return [cellTypes count];
            break;
        case 1:
            return [attachmentFileArray count];
            break;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = nil;
	
	if (indexPath.section == 0) {
        NSString *type = [cellTypes objectAtIndex:indexPath.row];
        
        if ([type isEqualToString:@"title"]) {
            
            if (cell == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleReadListCell1" owner:self options:nil];
                
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleReadListCell1")]) {
                        cell = oneObject;
                    }
                }
                
            }
            
            CalendarScheduleReadListCell1 *tmpCell = (CalendarScheduleReadListCell1 *)cell;
            
            //label1;	// 제목
            //label2;	// 위치
            //label3;	// 시작
            //label4;	// 종료
            
            
            
            //        모델 구조 정보.        model.viewSchedule
            //        appointmentid;	일정아이디
            //        subject	제목
            //        contents	내용
            //        location;	장소
            //        displaycc;	참조자
            //        displayto;	초대자
            //        resources;	리소스
            //        appointmentstate;	일정상태
            //        endtime;	종료시간
            //        starttime;	시작시간
            //        hasattachments;	첨부
            //        importance;	중요도
            //        isalldayevent;	종일일정여부
            //        organizer;	회의주최자
            //        parentfolderid;	부모폴더아이디
            //        hasrecurrences;	반복여부
            //        sensitivity;	비공개여부
            
            
            
            
            tmpCell.label1.text = [model.viewSchedule objectForKey:@"subject"];
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:20];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            NSString *strTitle = nil;
            if ( ![[model.viewSchedule notNilObjectForKey:@"subject"] isEqualToString:@""] ) {
                strTitle = [[model.viewSchedule notNilObjectForKey:@"subject"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            } else {
                strTitle = @"새로운 이벤트";
            }
            
            CGSize labelSize1 = [strTitle sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            tmpCell.label1.frame = CGRectMake(tmpCell.label1.frame.origin.x, 
                                              tmpCell.label1.frame.origin.y, 
                                              640, 
                                              labelSize1.height);
            
            // 위치
            CGSize labelSize2 = CGSizeMake(640, 0);
            labelFont = [UIFont fontWithName:@"Helvetica" size:16];
            
            //if (model.registerLocation != nil && ![model.registerLocation isEqualToString:@""]) {
            
            if ( ![[model.viewSchedule notNilObjectForKey:@"location"] isEqualToString:@""] ) {
                
                labelSize2 = [[model.viewSchedule notNilObjectForKey:@"location"] sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
                tmpCell.label2.text = [model.viewSchedule notNilObjectForKey:@"location"];
                tmpCell.label2.frame = CGRectMake(tmpCell.label2.frame.origin.x,
                                                  tmpCell.label1.frame.origin.y + tmpCell.label1.frame.size.height, 
                                                  640, 
                                                  labelSize2.height);
                tmpCell.label3.frame = CGRectMake(tmpCell.label3.frame.origin.x, 
                                                  tmpCell.label2.frame.origin.y + tmpCell.label2.frame.size.height + 4, 
                                                  640, 
                                                  18);
                tmpCell.label4.frame = CGRectMake(tmpCell.label4.frame.origin.x, 
                                                  tmpCell.label3.frame.origin.y + tmpCell.label3.frame.size.height, 
                                                  640, 
                                                  18);
            } else {
                tmpCell.label2.text = @"";
                
                tmpCell.label3.frame = CGRectMake(tmpCell.label3.frame.origin.x, 
                                                  tmpCell.label1.frame.origin.y + tmpCell.label1.frame.size.height + 4, 
                                                  640, 
                                                  18);
                tmpCell.label4.frame = CGRectMake(tmpCell.label4.frame.origin.x, 
                                                  tmpCell.label3.frame.origin.y + tmpCell.label3.frame.size.height, 
                                                  640, 
                                                  18);
            }
            
            
            //        if ( [[model.viewSchedule notNilObjectForKey:@"isalldayevent"] isEqualToString:@"true"] ) {
            //            tmpCell.label3.text = [model.viewSchedule notNilObjectForKey:@"starttime"]; //시작
            //            tmpCell.label4.text = @"하루종일";    
            //        } else {
            //            tmpCell.label3.text = [model.viewSchedule notNilObjectForKey:@"starttime"]; //시작
            //            tmpCell.label4.text = [model.viewSchedule notNilObjectForKey:@"endtime"]; //종료
            //        }
            tmpCell.label3.text = [self getStartTimeStr]; //시작일 표현
            tmpCell.label4.text = [self getEndTimeStr]; //종료일 표현
            
            
            
            
        } else if ([type isEqualToString:@"noti"]) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleReadListCell2" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleReadListCell2")]) {
                    cell = oneObject;
                }
            }
            CalendarScheduleReadListCell2 *tmpCell = (CalendarScheduleReadListCell2 *)cell;
            
            tmpCell.title.text = NSLocalizedString(@"calendar_alarm", @"알림");
            
            NSDictionary *noticeTimeList = nil;
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
            tmpCell.label1.text = [noticeTimeList objectForKey:[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"]];
            //NSLog(@"read view label1[%@] reminderminutesbeforestart[%@]",tmpCell.label1.text,[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"]);
            
            if ( tmpCell.label1.text == nil && ![[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"] isEqualToString:@""] ) {
                //안함 혹은 연산 표현 처리를 해야 한다. 모델값이 없는경우는 안함임, 딕셔너리에서 빼내지 못한 값의 경우는 분, 시간. 표시
                tmpCell.label1.text = [NSString stringWithFormat:@"%@ %@", [model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"], NSLocalizedString(@"calendar_minutes_before", @"분 전")];
                
            }
            
            [noticeTimeList release];
            
            
            /*	2번째 알림은 사용하지 않음.	
             if (model.registerNotiType2 == 0) {
             tmpCell.label2.text = @"";
             } else {
             tmpCell.label2.text = [arr objectAtIndex:model.registerNotiType2];
             }
             */ 
            tmpCell.label2.hidden = YES;
            
        } else if ([type isEqualToString:@"memo"]) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleReadListCell3" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleReadListCell3")]) {
                    cell = oneObject;
                }
            }
            CalendarScheduleReadListCell3 *tmpCell = (CalendarScheduleReadListCell3 *)cell;
            
            tmpCell.title.text = NSLocalizedString(@"calendar_memo",@"메모");
            
            tmpCell.label1.text = [model.viewSchedule notNilObjectForKey:@"contents"];
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            NSString *strMemo = nil;
            strMemo = [[model.viewSchedule notNilObjectForKey:@"contents"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize labelSize1 = [strMemo sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            tmpCell.label1.frame = CGRectMake(tmpCell.label1.frame.origin.x, 
                                              tmpCell.label1.frame.origin.y, 
                                              640, 
                                              labelSize1.height);
            
        } else if ([type isEqualToString:@"invite"]) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleReadListCell4" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleReadListCell4")]) {
                    cell = oneObject;
                }
            }
            CalendarScheduleReadListCell4 *tmpCell = (CalendarScheduleReadListCell4 *)cell;
            
            tmpCell.title.text = NSLocalizedString(@"calendar_invited_people",@"초대한 사람");
            
            UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14];		// xib에서 설정한 모임소개 라벨의 font
            CGFloat labelWidth = 640;											// xib에서 설정한 모임소개 라벨의 width
            UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
            
            
            // 초대자는 Dictionary 의 "displayto" 이다. Null 일수 있음.
            
            
            NSString *strInvateList = @"";
            NSMutableString *tempMutableString = [[NSMutableString alloc]initWithCapacity:0];
            
            if ( ![[model.viewSchedule notNilObjectForKey:@"displayto"] isEqualToString:@""] ) {
                tempMutableString = [[model.viewSchedule notNilObjectForKey:@"displayto"] stringByReplacingOccurrencesOfString:@"; " withString:@", "];
                int tempInt = [tempMutableString length];
                [tempMutableString replaceCharactersInRange:NSMakeRange(tempInt-2, 2) withString:@""];
                
                strInvateList = tempMutableString;
                
                
            }
            
            strInvateList = [strInvateList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize labelSize1 = [strInvateList sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelWidth, FLT_MAX) lineBreakMode:labelBreakMode];
            
            
            tmpCell.label1.frame = CGRectMake(tmpCell.label1.frame.origin.x, 
                                              tmpCell.label1.frame.origin.y, 
                                              640, 
                                              labelSize1.height);
            
            tmpCell.label1.text = strInvateList;
            tempMutableString = nil;
            [tempMutableString release];
        }

    }else if(indexPath.section == 1){

        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachmentCustomCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"AttachmentCustomCell")]) {
                    cell = oneObject;
                }
            }
            
        }
        //		NSLog(@"asdfasdfasdfasdfadsf%d",indexPath.row);
		AttachmentCustomCell *tmpCell = (AttachmentCustomCell *)cell;
		NSDictionary *dic_current = [self.attachmentFileArray objectAtIndex:indexPath.row];
        NSLog(@"%@", dic_current);
        //        tmpCell.iconTitleLabel.text = nil;
        //        tmpCell.iconTitleLabel.text = [dic_current objectForKey:@"attachment_name"];
        if ([[dic_current objectForKey:@"attachment_isinline"]isEqualToString:@"0"]) {// mail 바디 안 이미지 표시는 첨부파일로 표시 안함
            
            UILabel *tempDate = (UILabel *)[tmpCell viewWithTag:111];//받은시간 4번셀
            tempDate.text = [dic_current objectForKey:@"attachment_name"];
            UILabel *tempSize = (UILabel *)[tmpCell viewWithTag:333];//받은시간 4번셀
            int sizeKB = [[dic_current objectForKey:@"attachment_size"]intValue]/1024;
            NSLog(@"asdfasdfasdf[%@]", dic_current);
            tempSize.text =  [NSString stringWithFormat:@"%dKB",sizeKB ];
//            if ([[dic_current objectForKey:@"attachment_isfile"]isEqualToString:@"1"]) {
                UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
                btn_tmp.tag = indexPath.row;
                [btn_tmp addTarget:self action:@selector(action_AttachFile:) forControlEvents:UIControlEventTouchUpInside];
                
//            }else{
//                UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
//                btn_tmp.tag = indexPath.row;
//                UIImage *backImage = [UIImage imageNamed:@"emailAttachementAdd.PNG"];
//                [btn_tmp setBackgroundImage:backImage forState:UIControlStateNormal];
//                
//                [btn_tmp addTarget:self action:@selector(action_AttachFile:) forControlEvents:UIControlEventTouchUpInside];
//            }
            
        }
        
        cell = tmpCell;
        

    }
	
	return cell;
    

    
}


#pragma mark -
#pragma mark View Translation Process

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	
	[cellTypes removeAllObjects];
	
	[cellTypes addObject:@"title"];	// 타이틀은 기본으로 나오니 미리 추가
	
    //알림 영역
	if ( ![[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"] isEqualToString:@""] ) {
		[cellTypes addObject:@"noti"];
	}
    
    //메모 영역
	if ( ![[model.viewSchedule notNilObjectForKey:@"contents"] isEqualToString:@""]) {
		[cellTypes addObject:@"memo"];
	}
    
    //초대한 사람 영역
	if ( ![[model.viewSchedule notNilObjectForKey:@"displayto"] isEqualToString:@""] ) {
		[cellTypes addObject:@"invite"];
	}
	
	[self.tableView1 reloadData];




    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"NO"] ) {
        //타인 이라면 편집 불가능
        self.title = [NSString stringWithFormat:@"%@%@", [model.scheduleOwnerInfo notNilObjectForKey:@"empnm"], NSLocalizedString(@"calendar_xxx_plan",@"님의 약속")];
    } else {
        self.title = NSLocalizedString(@"calendar_my_plan",@"나의 약속");
        [super makeNavigationRightBarButtonWithBarButtonSystemItem:UIBarButtonSystemItemEdit];
    }



}
#pragma mark -
#pragma mark View Detail Process
-(void) loadDetail:(NSString *)aptID{
    clipboard = nil;
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;

    NSString *callUrl = @"";
//    callUrl = URL_getAppointmentList; // 내일정
    //callUrl = URL_getSharedAppointmentList; // 타인일정
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    callUrl = URL_getAppointmentDetail;
    [requestDictionary setObject:aptID];
    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    if (!result) {
        // error occurred
    } 

}
- (void)MainScheduleRead:(NSNotification *)notification {
//    NSLog(@"%@", [notification object ]);
    clipboard = nil;
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    
    NSString *callUrl = @"";
//    callUrl = URL_getAppointmentList; // 내일정
    //callUrl = URL_getSharedAppointmentList; // 타인일정
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    callUrl = URL_getAppointmentDetail;
    NSLog(@"fsfsfsfsfsf%@", [notification object]);
	
//    [requestDictionary setObject:[NSString stringWithFormat:@"%@",[notification object]]];
    [requestDictionary setObject:[NSString stringWithFormat:@"%@",[notification object]] forKey:@"aptid"];
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    if (!result) {
        // error occurred
    } 
    
    
    
    
    
}

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    tableView1.hidden = YES;
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
    tableView1.hidden = NO;

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
		
	}
	
	if([rsltCode intValue] == 0) {
		
        if ( [[_resultDic objectForKey:@"aptinfo"] count] > 0 ) { 
            // 일정 데이터가 있다.
            //[self.contactList addObjectsFromArray:[_resultDic objectForKey:@"aptlistinfo"]];
//            scheduleList = [_resultDic objectForKey:@"aptlistinfo"];
//            
//            //데이터를 갱신 표현한다.
//            [self performSelector:@selector(receiveScheduleData)];
            
//            NSLog(@"model.view11111[%@", model.viewSchedule);

            
            model.viewSchedule = [_resultDic objectForKey:@"aptinfo"];
            if (self.attachmentFileArray == nil) {
                self.attachmentFileArray = [[NSMutableArray alloc]initWithCapacity:0];

            }else{
                if ([self.attachmentFileArray count]>0) {
                    [self.attachmentFileArray removeAllObjects];

                }

            }
            self.attachmentFileArray = [model.viewSchedule objectForKey:@"aptfileinfos"];
            
//            NSLog(@"model.view22222[%@", model.viewSchedule);

            
            [cellTypes removeAllObjects];
            
            [cellTypes addObject:@"title"];	// 타이틀은 기본으로 나오니 미리 추가
            
            //알림 영역
            if ( ![[model.viewSchedule notNilObjectForKey:@"reminderminutesbeforestart"] isEqualToString:@""] ) {
                [cellTypes addObject:@"noti"];
            }
            
            //메모 영역
            if ( ![[model.viewSchedule notNilObjectForKey:@"contents"] isEqualToString:@""]) {
                [cellTypes addObject:@"memo"];
            }
            
            //초대한 사람 영역
            if ( ![[model.viewSchedule notNilObjectForKey:@"displayto"] isEqualToString:@""] ) {
                [cellTypes addObject:@"invite"];
            }

            
            
            
            [tableView1 reloadData];
        } else {
            
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
        
    }
    else if ([rsltCode intValue] == 100){//공유 허용되지 않는 사용자 일때는 다시 캘린더 보기로 돌아가자
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		alert.tag = 5555;
		[alert show];	
		[alert release];
        
        
    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
	//테이블도 리로드 해준다.
    [self.tableView1 reloadData];
    
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    tableView1.hidden = NO;

    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
    //0건일수 있으므로 리드로 해준다.
//    [self redrawHasSchedule];
	//테이블도 리로드 해준다.
    [self.tableView1 reloadData];
}



#pragma mark -
#pragma mark XCode Genreated

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
    self.attachmentFileArray = [[NSMutableArray alloc]initWithCapacity:0];

	
//	dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//		   [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyyMMdd"], @"DATE",
//		   model.registerTitle, @"TITLE", 
//		   model.registerLocation, @"LOCATION",
//		   [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyyMMdd"], @"STR_DT",
//		   [CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"HHmm"], @"STR_TM",
//		   [CalendarFunction getStringFromDate:endDate dateFormat:@"yyyyMMdd"], @"END_DT",
//		   [CalendarFunction getStringFromDate:endDate dateFormat:@"HHmm"], @"END_TM",
//		   [NSString stringWithFormat:@"%d", model.registerRepeatType], @"REPEAT_TYPE",
//		   strRepeatEndDate, @"REPEAT_END_DT",
//		   strRepeatEndTime, @"REPEAT_END_TM",
//		   [NSString stringWithFormat:@"%d", model.registerNotiType1], @"NOTI_TYPE1",
//		   [NSString stringWithFormat:@"%d", model.registerNotiType2], @"NOTI_TYPE2",
//		   model.registerMemo, @"MEMO",
//		   strInvateList, @"INVITE", nil];
	
	model = [CalendarModel sharedInstance];
//	model.registerTitle = @"가나다라마바사아자차카타파핰ㅋㅋㅋ";
//	model.registerLocation = @"우리집";
//	
//	model.registerNotiType1 = 1;
//	model.registerNotiType2 = 3;
//	
//	model.registerMemo = @"ㅋㅋㅋㅋㅋ";
//
//	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
//	
//	TIToken *tiToken = nil;
//	
//	
//	tiToken = [[TIToken alloc] initWithTitle:@"강승철"];
//	[arr addObject:tiToken];
//	[tiToken release];
//	
//	tiToken = [[TIToken alloc] initWithTitle:@"장재영"];
//	[arr addObject:tiToken];
//	[tiToken release];
//	
//	model.registerInviteList = arr;
//	[arr release];
	
	cellTypes = [[NSMutableArray alloc] initWithCapacity:0];
	
//    NSLog(@"model.view[%@", model.viewSchedule);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainScheduleRead:) name:@"MainScheduleRead" object:nil];

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
- (void) viewWillDisappear:(BOOL)animated {
    if (clipboard != nil) {
		[clipboard cancelCommunication];
	}

    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MainScheduleRead" object:nil];
}
- (void)dealloc {
	[tableView1 release];
	[cellTypes release];
    [super dealloc];
}
#pragma mark -
#pragma mark AttachFile data source

-(void)action_AttachFile:(id)sender {
    
	UIButton *btn_tmp = (UIButton *)sender;
	int index = btn_tmp.tag;
	
    //	self.dic_docattachlistinfo = [[NSMutableDictionary alloc] init];
    //    
    //	NSDictionary *dic_tmp = [arr_docattachlistinfo objectAtIndex:index];
    //	
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"docid"] forKey:@"docid"];
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"attachdocurl"] forKey:@"href"];
    
    //	[self action_paymentOriginalPdfCell];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"뒤로";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];	
    
    NSString *indexString = [NSString stringWithFormat:@"%d", index];
    NSDictionary *dic_current = [self.attachmentFileArray objectAtIndex:index];
    
    
    if ([[dic_current objectForKey:@"attachment_name"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"app에서는 지원하지 않습니다. PC에서 이용해 주세요."
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];	
        [alert release];
        
    }else{
        FileAttachmentViewController *fileAttachmentViewController = [[FileAttachmentViewController alloc] initWithNibName:@"FileAttachmentViewController" bundle:nil];
        fileAttachmentViewController.title = self.title;
        //    self.navigationController.navigationBar.hidden = YES;
        //    
        //    // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:fileAttachmentViewController animated:YES];
        //    
        //    [mailAttachmentViewController loadAttachmentMailID:self.mailID attachmentIndex:[dic_current objectForKey:@"fileIndex"] attachmentName:[dic_current objectForKey:@"attachment_name"] attachmentIsFile:[dic_current objectForKey:@"attachment_isfile"]];
        
        //    
        
        [fileAttachmentViewController loadCalendarAttachemnet:[dic_current objectForKey:@"attachment_attachmentid"] attachmentName:[dic_current objectForKey:@"attachment_name"]];
        
        [fileAttachmentViewController release];
        //    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        
    }

    
    
    
    
    
    
}


@end

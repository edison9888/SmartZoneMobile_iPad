//
//  CalendarFunction.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 24..
//  Copyright 2011 두베. All rights reserved.
//

#import "CalendarFunction.h"


@implementation CalendarFunction

+ (NSString *)getStringFromDate:(NSDate *)aDate dateFormat:(NSString *)aStrDateFormat {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:aStrDateFormat];
	
	NSString *strRet = [dateFormat stringFromDate:aDate];
	
	[dateFormat release];
	dateFormat = nil;
	
	return strRet;
	
}

+ (NSDate *)getDateFromString:(NSString *)aString dateFormat:(NSString *)aStrDateFormat {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:aStrDateFormat];
	
	NSDate *dateRet = [dateFormat dateFromString:aString];
	
	[dateFormat release];
	dateFormat = nil;
    //NSLog(@"getDateFromString[%@][%@][%@]",aString,aStrDateFormat,dateRet);
	return dateRet;
}

+ (NSDate *)getDateFromString:(NSString *)aString {
	
	NSDate *dateRet = [self getDateFromString:aString dateFormat:@"yyyyMMdd"];
	
	return dateRet;
	
}




// date1을 기준으로 date2와 비교
// !주의 이상한 데이터를 넣으면 디폴트로 NSOrderedSame가 나올 수 있으니 사용시 유의할 것
+ (NSComparisonResult)compare:(id)date1 to:(id)date2 dateFormat:(NSString *)aStrDateFormat {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:aStrDateFormat];
	
	NSString *str1 = @"";
	NSString *str2 = @"";
	
	if ([date1 isKindOfClass:[NSString class]]) {
		str1 = date1;
	} else if ([date1 isKindOfClass:[NSDate class]]) {
		str1 = [dateFormat stringFromDate:date1];
	}
	
	if ([date2 isKindOfClass:[NSString class]]) {
		str2 = date2;
	} else if ([date2 isKindOfClass:[NSDate class]]) {
		str2 = [dateFormat stringFromDate:date2];
	}
	
	[dateFormat release];
	dateFormat = nil;
	
	return [str1 compare:str2];
}

+ (NSComparisonResult)compare:(id)date1 to:(id)date2 {
	return [self compare:date1 to:date2 dateFormat:@"yyyyMMdd"];
}


+ (NSString *)getFormatYyyyMMdd:(NSString *)orgStr {
    NSString *returnStr = @"";
    NSArray *strArr = [orgStr componentsSeparatedByString:@" "];
    if ( [strArr count] > 0 ) {
        returnStr = [strArr objectAtIndex:0];
        
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    } else {
        returnStr = orgStr;
    }
	
    return returnStr;
}

+ (NSString *)getFormatYyyyMMddDash:(NSString *)orgStr {
	return @"";
}

+ (NSString *)getFormatTime:(NSString *)orgStr {
    
    return @"";
}

+ (NSString *)getNoticeTime:(NSString *)index {
    
    NSString *returnStr = @"";
//    @"안함",    @"",    @"0", @"안함",
//    @"5분 전",  @"5",   @"1", @"5분 전",
//    @"10분 전", @"10",  @"2", @"10분 전",
//    @"15분 전", @"15",  @"3", @"15분 전",
//    @"30분 전", @"30",  @"4", @"30분 전",
//    @"1시간 전",@"60",   @"5", @"1시간 전",
//    @"2시간 전",@"120",  @"6", @"2시간 전",
//    @"3시간 전",@"180",  @"7", @"3시간 전",
//    @"4시간 전",@"240",  @"8", @"4시간 전",
//    @"8시간 전",@"480",  @"9", @"8시간 전",
//    @"0.5일 전",@"720", @"10", @"0.5일 전",
//    @"1일 전",  @"1440", @"11", @"1일 전",
//    @"2일 전",  @"2880", @"12", @"2일 전",
//    @"3일 전",  @"4320", @"13", @"3일 전",
//    @"1주 전",  @"10080", @"14", @"1주 전",
//    @"2주 전",  @"20160", @"15", @"2주 전",
//    @"정각",    @"0",     @"16", @"정각",
    switch ([index intValue]) {
		case 0: {	// @"안함"
        }	break;
        case 1: {   // @"5분 전"
            returnStr = @"5";
        }   break;
        case 2: {   // @"10분 전"
            returnStr = @"10";
        }   break;
        case 3: {   // @"15분 전"
            returnStr = @"15";
        }   break;
        case 4: {   // @"30분 전"
            returnStr = @"30";
        }   break;
        case 5: {   // @"1시간 전"
            returnStr = @"60";
        }   break;
        case 6: {   // @"2시간 전"
            returnStr = @"120";
        }   break;
        case 7: {   // @"3시간 전"
            returnStr = @"180";
        }   break;
        case 8: {   // @"4시간 전"
            returnStr = @"240";
        }   break;
        case 9: {   // @"8시간 전"
            returnStr = @"480";
        }   break;
        case 10: {   // @"0.5일 전"
            returnStr = @"720";
        }   break;
        case 11: {   // @"1일 전"
            returnStr = @"1440";
        }   break;
        case 12: {   // @"2일 전"
            returnStr = @"2880";
        }   break;
        case 13: {   // @"3일 전"
            returnStr = @"4320";
        }   break;
        case 14: {   // @"1주 전"
            returnStr = @"10080";
        }   break;
        case 15: {   // @"2주 전"
            returnStr = @"20160";
        }   break;
        case 16: {   // @"정각"
            returnStr = @"0";
        }   break;
    }
    
    return returnStr;
}

// 해당 달의 1일
+ (NSDate *)getMonthFirstDate:(NSDate *)aDate {
    
	// 현재 일의 년월만 가져온다.
	NSString *strYearMonth = [CalendarFunction getStringFromDate:aDate dateFormat:@"yyyyMM"];	
	NSString *strFirstDay = [NSString stringWithFormat:@"%@01", strYearMonth];
	
	NSDate *retDate = [CalendarFunction getDateFromString:strFirstDay];
	
	return retDate;

}

// 해달 달의 마지막 날
+ (NSDate *)getMonthLastDate:(NSDate *)aDate {
	
//	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//	
//	dateComponents.month = 1;
//	dateComponents.day	 = -1;
//	
//	NSDate *dateMonthLastDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
//                                                                               toDate:aDate 
//                                                                              options:0];
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

@end

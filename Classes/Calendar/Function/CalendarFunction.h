//
//  CalendarFunction.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 24..
//  Copyright 2011 두베. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarFunction : NSObject {
	
}

// NSDate를 원하는 dateFormat으로 변환하여 NSString으로 반환
+ (NSString *)getStringFromDate:(NSDate *)aDate dateFormat:(NSString *)aStrDateFormat;

// NSString을 yyyyMMdd 포맷으로 변환하여 NSDate로 반환
+ (NSDate *)getDateFromString:(NSString *)aString dateFormat:(NSString *)aStrDateFormat;
+ (NSDate *)getDateFromString:(NSString *)aString;

// date1을 기준으로 date2와 비교
// !주의 이상한 데이터를 넣으면 디폴트로 NSOrderedSame가 나올 수 있으니 사용시 유의할 것
+ (NSComparisonResult)compare:(id)date1 to:(id)date2 dateFormat:(NSString *)aStrDateFormat;
+ (NSComparisonResult)compare:(id)date1 to:(id)date2;

// 칼렌더 모델에 맞게 변환 : 2011-06-11 23:21 -> 20110611
+ (NSString *)getFormatYyyyMMdd:(NSString *)orgStr;

// 날짜 형식으로 변환. 20110611 -> 2011-06-11
+ (NSString *)getFormatYyyyMMddDash:(NSString *)orgStr;

// 시간 형식으로 변환 1400 -> 14:00
+ (NSString *)getFormatTime:(NSString *)orgStr;

// 알림 시간을 분단위로 리턴한다.
+ (NSString *)getNoticeTime:(NSString *)index; 

// 해당 달의 1일
+ (NSDate *)getMonthFirstDate:(NSDate *)aDate;

// 해달 달의 마지막 날
+ (NSDate *)getMonthLastDate:(NSDate *)aDate;

@end

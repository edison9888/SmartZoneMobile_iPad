//
//  StringUtil.m
//  SearcherTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 4. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "StringUtil.h"


@implementation StringUtil

/*!
    @function
    @abstract   문자열의 문자를 한글의 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray로 만든다.
    @discussion 문자열의 문자를 한글의 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray로 만든다. 
				문자가 한글이 아닐 경우 분해하지 않고 원본을 복사하여 아이템을 만든다.
    @param      aHangulString 일반 문자열
    @result     aHangulString의 문자를 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray
*/

+ (NSArray *)getApartedHangulCharArray:(NSString *)aHangulString {

	NSMutableArray *arrRet = [[[NSMutableArray alloc] initWithCapacity:[aHangulString length]] autorelease];
	
	for (int i = 0; i < [aHangulString length]; i++) {
		NSString *strApartedChar = [self getApartedHangulChar:[aHangulString substringWithRange:NSMakeRange(i, 1)]];
	
		[arrRet addObject:strApartedChar];
	}
	
	return [NSArray arrayWithArray:arrRet];
	
}

/*!
 @function
 @abstract   문자열의 문자를 한글의 초성, 중성, 종성으로 풀어쓴 NSString을 만든다.
 @discussion 문자열의 문자를 한글의 초성, 중성, 종성으로 풀어쓴 NSString을 만든다.(한글이 아닌 경우에는 원본을 카피하여 연결한다.)
 @param      aHangulString 일반 문자열
 @result     aHangulString의 문자들을 초성, 중성, 종성으로 풀어쓴 NSString
 */
+ (NSString *)getApartedHangulCharString:(NSString *)aHangulString {
	
	NSMutableString *strRet = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < [aHangulString length]; i++) {
		
		[strRet appendString:[self getApartedHangulChar:[aHangulString substringWithRange:NSMakeRange(i, 1)]]];
	}
	
	return strRet;
	
}


/*!
    @function
    @abstract   한글 한자를 초성, 중성, 종성으로 분해한다.
    @discussion 한글 한자를 초성, 중성, 종성으로 분해하며, 입력받은 aHangulChar이 유니코드의 한글 영역을 벗어난 경우 
				aHangulChar를 (autorelease객체로) 복사하여 리턴한다.
    @param      aHangulChar length가 1인 NSString
    @result     aHangulChar가 한글인 경우: 초성, 중성, 종성으로 분해된 NSString.  aHangulChar가 한글이 아닌 경우 aHangulChar의 복사본

*/

+ (NSString *)getApartedHangulChar:(NSString *)aHangulChar {
	
	// UNICODE Hangul Syllables에 대한 기본 지식
	// * 유니코드 Hangul Syllables의 경우  AC00(44032)-D7AF(55215)만큼 할당되어 있다.
	// (참고:http://www.unicode.org/charts/PDF/UAC00.pdf)
	//
	// 조합 원리
	// 1. 초성 하나당 가질 수 있는 캐릭터 수는 표현가능한 중성(21)갯수 * 종성(28)갯수이다.
	// 2. 초성이 결정되어 있는 상태에서 중성 하나당 가질 수 있는 캐릭터 수는 종성(28)갯수이다.
	// 
	// 위 원리를 수식으로 표현
	// unicode = 44032 + ((초성테이블 인덱스 값) * (중성 갯수 * 종성 갯수)) + (중성테이블 인덱스값) * (종성 갯수) + (종성테이블 인덱스 값)
	
	NSArray *arrSoundInit	= nil;	// 초성
	NSArray *arrSoundMiddle = nil;	// 중성
	NSArray *arrSoundFinal	= nil;	// 종성
	
	// 초성, 중성, 종성의 테이블을 만든다.
	// 초성 (19개)
	arrSoundInit = [[NSArray alloc] initWithObjects:
					@"ㄱ", @"ㄲ",
					@"ㄴ", 
					@"ㄷ", @"ㄸ",
					@"ㄹ", 
					@"ㅁ", 
					@"ㅂ", @"ㅃ",
					@"ㅅ", @"ㅆ",
					@"ㅇ", 
					@"ㅈ", 
					@"ㅉ", 
					@"ㅊ", 
					@"ㅋ", 
					@"ㅌ", 
					@"ㅍ", 
					@"ㅎ", nil];	
	
	// 중성(21개)
	arrSoundMiddle = [[NSArray alloc] initWithObjects:
					  @"ㅏ", @"ㅐ", 
					  @"ㅑ", @"ㅒ", 
					  @"ㅓ", @"ㅔ", 
					  @"ㅕ", @"ㅖ", 
					  @"ㅗ", @"ㅘ", @"ㅙ", @"ㅚ", @"ㅛ",
					  @"ㅜ", @"ㅝ", @"ㅞ", @"ㅟ", @"ㅠ",
					  @"ㅡ", @"ㅢ", @"ㅣ", nil];
	
	// 종성(28개)
	arrSoundFinal = [[NSArray alloc] initWithObjects:
					 @"",
					 @"ㄱ", @"ㄲ", @"ㄳ",
					 @"ㄴ", @"ㄵ", @"ㄶ",
					 @"ㄷ", 
					 @"ㄹ", @"ㄺ", @"ㄻ", @"ㄼ", @"ㄽ", @"ㄾ", @"ㄿ", @"ㅀ",
					 @"ㅁ", 
					 @"ㅂ", @"ㅄ",
					 @"ㅅ", @"ㅆ",
					 @"ㅇ", 
					 @"ㅈ", 
					 @"ㅊ", 
					 @"ㅋ", 
					 @"ㅌ", 
					 @"ㅍ", 
					 @"ㅎ", nil];
	
	NSString *apartedHangulChar = nil;

	NSInteger unicode = [aHangulChar characterAtIndex:0];	

	// 한글인 경우
	if (unicode >= 44032 && unicode <= 55203) {	// 44032: "가", 55203: "힣"	
		
		// 유니코드로 부터 초성, 중성, 종성 테이블 값을 가져오는 공식 실행
		NSInteger shiftedValue = unicode - 44032;
		
		NSInteger idxSoundInit	 = shiftedValue / (21 * 28);			
		NSInteger idxSoundMiddle = (shiftedValue % (21 * 28)) / 28;	
		NSInteger idxSoundFinal	 = shiftedValue % 28;			
		
		apartedHangulChar = [NSString stringWithFormat:@"%@%@%@", 
							 [arrSoundInit	 objectAtIndex:idxSoundInit], 
							 [arrSoundMiddle objectAtIndex:idxSoundMiddle], 
							 [arrSoundFinal  objectAtIndex:idxSoundFinal]];

	} else {	// 한글이 아닌 경우
		apartedHangulChar = [NSString stringWithString:aHangulChar];
	}

	[arrSoundInit release];
	[arrSoundMiddle release];
	[arrSoundFinal release];
	
	arrSoundInit	= nil;
	arrSoundMiddle  = nil;
	arrSoundFinal	= nil;
	
	return apartedHangulChar;
	
}

/*!
    @function
    @abstract   초성, 중성, 종성으로 조각나 있는 문자열과 입력받은(UITextField나 UISearchBar를 통하여) 문자열의 초성, 중성, 종성 조각과 비교판단한다.
    @discussion 초성, 중성, 종성으로 조각나 있는 문자열과 입력받은(UITextField나 UISearchBar를 통하여) 문자열의 초성, 중성, 종성 조각과 비교판단한다. 
    @param      aOriginArray 원본데이터
	@param      aTargetArray 입력받은 문자열을 초성, 중성, 종성으로 분해한 결과를 담고 있는 Array
	@result     입력받은 문자열의 그룹에 해당하면 YES값을 리턴
*/

+ (BOOL)getJudgementApartedHangulCharArray:(NSArray *)aOriginArray 
			  SameAsApartedHangulCharArray:(NSArray *)aTargetArray {
	
	int intTargetArrayLength = [aTargetArray count];
	
	// 원본 데이터가 비교 대상(텍스트필드로부터 입력받은) 보다 길이가 짧은 경우는 불일치로 판정
	if (intTargetArrayLength > [aOriginArray count]) {
		return NO;
	}
	
	for (int i = 0; i <= [aOriginArray count] - intTargetArrayLength; i++) {
		
		for (int j = 0; j < intTargetArrayLength; j++) {
			NSString *strTargetApartedChar = [aTargetArray objectAtIndex:j];
			
			if ([strTargetApartedChar isEqualToString:[[aOriginArray objectAtIndex:j + i] substringToIndex:[strTargetApartedChar length]]]) {
				return YES;
			}
		}
		
	}
	
	return NO;
	
}

/*!
 @function
 @abstract   문자열을 입력하면 RegularExpression 패턴으로 바꿔준다.
 @discussion 문자열을 입력하면 초성, 중성, 종성으로 분해하여 RegularExpression 패턴으로 바꿔준다.
 @param      aString 검색할 초성문자열
 @result     RegularExpression 패턴
 */

+ (NSString *)getRegularExpressionPatternWithString:(NSString *)aString {
	
	NSArray *arrApartedChars = [self getApartedHangulCharArray:aString];
	
	NSMutableString *strRegularExpression = [[NSMutableString alloc] init];
	
	for (int i = 0; i < [arrApartedChars count]; i++) {
		
		NSString *str = [arrApartedChars objectAtIndex:i];
		
//		if (i > 0) {
//			[strRegularExpression appendString:@"\\S*"];
//		}
		
		switch ([str length]) {
			case 3: {
				[strRegularExpression appendString:[NSString stringWithFormat:@"\\u%x\\u%x\\u%x", 
													[str characterAtIndex:0],
													[str characterAtIndex:1],
													[str characterAtIndex:2]]];
			}	break;
			case 2: {
				[strRegularExpression appendString:[NSString stringWithFormat:@"\\u%x\\u%x[\\u3131-\\u314E]?", 
													[str characterAtIndex:0],
													[str characterAtIndex:1]]];
				
			}	break;
			case 1: {
				if ([str characterAtIndex:0] > 0 && [str characterAtIndex:0] < 255) {
					[strRegularExpression appendString:[NSString stringWithFormat:@"\\x%x", [str characterAtIndex:0]]];
				} else {
					[strRegularExpression appendString:[NSString stringWithFormat:@"\\u%x[\\u314F-\\u3163]+[\\u3131-\\u314E]?", [str characterAtIndex:0]]];
				}

			}	break;
			default:
				break;
		}
		
	}
	
	[strRegularExpression appendString:@"\\S*"];
	
	return [strRegularExpression autorelease];
}

+ (NSString *)getKo_KRLocaleDateStringWithDateString:(NSString *)aStrDate timeString:(NSString *)aStrTime {

	// 이거 로케일로 어떻게 하면 될꺼 같은데... 나중에 찾아서 고쳐야지...
	
	NSString *strReturnFullDate = nil;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSString *strDate = [dateFormat stringFromDate:[NSDate date]];
	[dateFormat release];
	dateFormat = nil;
	
	NSString *strAmPm = @"";
	NSString *strTime = [aStrTime substringWithRange:NSMakeRange(0, 2)];
	NSString *strMinute = [aStrTime substringWithRange:NSMakeRange(2, 2)];

	strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	
//	if (12 - [strTime intValue] > 0) {	// 오전
//		strAmPm	= @"오전";
//		strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
//	} else {
//		strAmPm = @"오후";
//		strTime = [NSString stringWithFormat:@"%d", [strTime intValue] - 12];
//	}
	
	if ([strDate isEqualToString:aStrDate]) {	// 오늘인 경우
		
		strReturnFullDate = [NSString stringWithFormat:@"오늘 %@ %@:%@",
							 strAmPm,
							 strTime,
							 strMinute];
		
	} else {

		NSString *strYear  = [aStrDate substringWithRange:NSMakeRange(0, 4)];
		NSString *strMonth = [aStrDate substringWithRange:NSMakeRange(4, 2)];
		NSString *strDay   = [aStrDate substringWithRange:NSMakeRange(6, 2)];

		strReturnFullDate = [NSString stringWithFormat:@"%@년 %d월 %d일 %@ %@:%@",
							 strYear,
							 [strMonth intValue],
							 [strDay intValue],
							 strAmPm,
							 strTime,
							 strMinute];
							 
		}
	
	return strReturnFullDate;
	
}

@end

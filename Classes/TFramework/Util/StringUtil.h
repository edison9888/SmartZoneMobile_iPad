//
//  StringUtil.h
//  SearcherTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 4. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header StringUtil
 @abstract   String 조작에 필요한 Util성 Function 모음
 @discussion 
 */
@interface StringUtil : NSObject {

}

/*!
	@function
	@abstract   문자열의 문자를 한글의 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray로 만든다.
	@discussion 문자열의 문자를 한글의 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray로 만든다. 
	문자가 한글이 아닐 경우 분해하지 않고 원본을 복사하여 아이템을 만든다.
	@param      aHangulString 일반 문자열
	@result     aHangulString의 문자를 초성, 중성, 종성으로 분해한 NSString을 아이템으로 하는 NSArray
 */
+ (NSString *)getApartedHangulChar:(NSString *)aHangulChar;

/*!
	@function
	@abstract   한글 한자를 초성, 중성, 종성으로 분해한다.
	@discussion 한글 한자를 초성, 중성, 종성으로 분해하며, 입력받은 aHangulChar이 유니코드의 한글 영역을 벗어난 경우 
	aHangulChar를 (autorelease객체로) 복사하여 리턴한다.
	@param      aHangulChar length가 1인 NSString
	@result     aHangulChar가 한글인 경우: 초성, 중성, 종성으로 분해된 NSString.  aHangulChar가 한글이 아닌 경우 aHangulChar의 복사본
 */
+ (NSArray *)getApartedHangulCharArray:(NSString *)aHangulString;


/*!
 @function
 @abstract   문자열의 문자를 한글의 초성, 중성, 종성으로 풀어쓴 NSString을 만든다.
 @discussion 문자열의 문자를 한글의 초성, 중성, 종성으로 풀어쓴 NSString을 만든다.(한글이 아닌 경우에는 원본을 카피하여 연결한다.)
 @param      aHangulString 일반 문자열
 @result     aHangulString의 문자들을 초성, 중성, 종성으로 풀어쓴 NSString
 */
+ (NSString *)getApartedHangulCharString:(NSString *)aHangulString;

/*!
	 @function
	 @abstract   초성, 중성, 종성으로 조각나 있는 문자열과 입력받은(UITextField나 UISearchBar를 통하여) 문자열의 초성, 중성, 종성 조각과 비교판단한다.
	 @discussion 초성, 중성, 종성으로 조각나 있는 문자열과 입력받은(UITextField나 UISearchBar를 통하여) 문자열의 초성, 중성, 종성 조각과 비교판단한다. 
	 @param      aOriginArray 원본데이터
	 @param      aTargetArray 입력받은 문자열을 초성, 중성, 종성으로 분해한 결과를 담고 있는 Array
	 @result     입력받은 문자열의 그룹에 해당하면 YES값을 리턴
 */

+ (BOOL)getJudgementApartedHangulCharArray:(NSArray *)aOriginArray 
			  SameAsApartedHangulCharArray:(NSArray *)aTargetArray;


+ (NSString *)getRegularExpressionPatternWithString:(NSString *)aString;


+ (NSString *)getKo_KRLocaleDateStringWithDateString:(NSString *)aStrDate timeString:(NSString *)aStrTime;
@end

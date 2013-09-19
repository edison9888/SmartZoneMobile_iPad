//
//  TextFieldInfoModel.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	
	CharacterType = 1,	// 문자
	NumberType,			// 숫자
	NumberAndPunctuationType,	// 숫자 & 특수기호
	AmountType,			// 금액
	AlphabetOnlyType,	// 알파벳만
	
	TextViewType,		// 텍스트뷰
	
	// 이하 type은 UIView(또는 PickerView) Type
	
	PickerViewType,		// UIPickerView 호출
	DatePickerViewType	// UIDatePickerView 호출
	
} TEXTFIELD_INPUT_TYPE;	


@interface TextFieldInfoModel : NSObject {
	
	id object;						// 텍스트필드
	
	TEXTFIELD_INPUT_TYPE inputType;	// 키보드 타입
	int maxLength;					// 입력 가능한 문자수 (0인경우 체크하지 않음)
	UITextAlignment textAlignment;	// 문자열 배치
	bool enableSpecialChar;			// 특수문자 입력 가능 여부
	
}

@property (nonatomic, assign) id object;
@property TEXTFIELD_INPUT_TYPE inputType;
@property int maxLength;
@property UITextAlignment textAlignment;
@property bool enableSpecialChar;

- (id)initWithObject:(id)aObject 
		   inputType:(TEXTFIELD_INPUT_TYPE)anInputType  
		   maxLength:(int)aMaxLength 
   enableSpecialChar:(BOOL)anEnableSpecialChar 
	   textAlignment:(UITextAlignment)anAlignment;

- (id)initWithObject:(id)aObject 
		   inputType:(TEXTFIELD_INPUT_TYPE)anInputType  
		   maxLength:(int)aMaxLength 
   enableSpecialChar:(BOOL)anEnableSpecialChar 
	   textAlignment:(UITextAlignment)anAlignment 
	   returnKeyType:(UIReturnKeyType)aReturnKeyType;

@end

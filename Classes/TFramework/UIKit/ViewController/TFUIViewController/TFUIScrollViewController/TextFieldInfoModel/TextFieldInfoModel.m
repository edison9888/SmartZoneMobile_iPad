//
//  TextFieldInfoModel.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "TextFieldInfoModel.h"


@implementation TextFieldInfoModel

@synthesize object;
@synthesize inputType;
@synthesize maxLength;
@synthesize textAlignment;
@synthesize enableSpecialChar;


- (id)initWithObject:(id)aObject 
		   inputType:(TEXTFIELD_INPUT_TYPE)anInputType  
		   maxLength:(int)aMaxLength 
   enableSpecialChar:(BOOL)anEnableSpecialChar 
	   textAlignment:(UITextAlignment)anAlignment {
	
	return [self initWithObject:aObject
					  inputType:anInputType
					  maxLength:aMaxLength
			  enableSpecialChar:anEnableSpecialChar
				  textAlignment:anAlignment
				  returnKeyType:UIReturnKeyDone];	// 일단 기본은 "Done"으로 넣는다.
	
}

- (id)initWithObject:(id)aObject 
		   inputType:(TEXTFIELD_INPUT_TYPE)anInputType  
		   maxLength:(int)aMaxLength 
   enableSpecialChar:(BOOL)anEnableSpecialChar 
	   textAlignment:(UITextAlignment)anAlignment 
	   returnKeyType:(UIReturnKeyType)aReturnKeyType {
	
	if (self = [super init]) {
		
		object				= aObject;
		inputType			= anInputType;
		maxLength			= aMaxLength;
		enableSpecialChar	= anEnableSpecialChar;
		textAlignment		= anAlignment;
		
		if ([NSStringFromClass([object class]) isEqualToString:@"TFUITextView"]) {
			object = [[(UIView *)object subviews] objectAtIndex:0];
		}
		
		UITextField *textField = (UITextField *)object;
		
		switch (inputType) {
			
			// 문자
			case CharacterType: {
				textField.textAlignment = textAlignment;
				textField.keyboardType  = UIKeyboardTypeDefault;
				textField.returnKeyType	= aReturnKeyType;
			} break;
				
			// 숫자
			case NumberType: {
				textField.textAlignment = textAlignment;
				textField.keyboardType  = UIKeyboardTypeNumberPad;
			} break;
			
			// 숫자
			case NumberAndPunctuationType: {
				textField.textAlignment = textAlignment;
				textField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
			} break;
				
			// 금액
			case AmountType: {
				textField.textAlignment = textAlignment;
				textField.keyboardType  = UIKeyboardTypeNumberPad;
			} break;
			
			// 알파벳만
			case AlphabetOnlyType: {
				textField.textAlignment = textAlignment;
				textField.keyboardType  = UIKeyboardTypeDefault;
				textField.returnKeyType	= aReturnKeyType;		
			} break;

			default:
				break;
		}
	}
	
	return self;
	
}

@end

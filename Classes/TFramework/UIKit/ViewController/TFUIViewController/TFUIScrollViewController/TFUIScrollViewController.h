//
//  TFUIScrollViewController.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "TextFieldInfoModel.h"
#import "TFDatePickerModel.h"
#import "TFUITextView.h"

typedef enum {
	KeypadCancel,
	CancelAndComfirm
} KEYBOARD_TOOLBAR_TYPE;

typedef enum {
	TFDisplayTypeDefault,
	TFDisplayTypeNoneTabBar,
	TFDisplayTypeLandscapeDefault,
	TFDisplayTypeLandscapeNoneTabBar
} DISPLAY_TYPE;

@interface TFUIScrollViewController : TFUIViewController <UITextFieldDelegate, 
															UITextViewDelegate,
															UIPickerViewDataSource, 
															UIPickerViewDelegate> {

	DISPLAY_TYPE dispType;
	
	UIScrollView *tfUIScrollView;
	UIView *tfUIView;
	CGFloat yPoint;
	
	CGFloat scrollTopMargin;	// 상위 스크롤 마진 값
	CGPoint orgPoint;			// Tab된 입력필드의 위치
    
    SEL rollBackedContentSizeHeightSelector;    // 스크롤링을 위해 늘려놓은 View 사이즈를 원복하고 난 후 콜백
	
	UIView *selectedUITextField;				// 현재 선택되어있는 텍스트 필드
	UIToolbar *keyboardToolbar;						// 키보드 위에 놓여지는 툴바
	BOOL prevForwButtonLocked;						// 스크롤링 애니메이션 도중 이전, 다음 버튼의 동작을 막는다.
	
	NSMutableArray *textFieldsInfoArray;			// 화면에 있는 textField에 대한 정보를 담아 놓는 Array
	TextFieldInfoModel *selectedUITextfieldInfo;	// 현재 선택되어있는 텍스트 필드의 정보
	
	BOOL isSequenceInput;		// 이미 어떠한 텍스트필드가 입력대기(또는 입력 중) 상태
	BOOL isEmergencyClose;		// 키보드를 긴급으로 내려야 하는 상태
	
	BOOL hasPickerView;			// 피커뷰를 사용하는지 판단		(개별페이지에서 [super loadView] 이전에 설정함)
	BOOL hasDatePickerView;		// 데이트피커뷰를 사용하는지 판단 (개별페이지에서 [super loadView] 이전에 설정함)
	
	UIPickerView *tfPickerView;
	NSMutableDictionary *pickerComponetsData;
	NSMutableDictionary *pickerSelectedComponetsData;
	
	UIDatePicker *tfDatePickerView;
	NSMutableDictionary *datePickerData;
																
	NSString *strTemp;
	int replacementStringLength;
	
}

@property BOOL scrollEnabled;	// 스크롤 기능 설정 (YES-자유로운 스크롤링, NO-키패드에 의한 스크롤링만 가능)

#pragma mark -
#pragma mark Override Necessary Method
// UITextFieldDelegate 처리시 사용할 모델을 세팅한다.
- (void)setTextFieldInfo;

#pragma mark -
#pragma mark Optional Override Necessary Method

// UIPickerViewDataSource, UIPickerViewDelegate에서 사용할 모델을 세팅한다.
- (void)setPickerComponents;

// UIDatePicker에서 사용할 모델을 세팅한다.
- (void)setDatePickerComponents;

// UITextField의 입력한 값을 가공하여 UITextField에 설정을 해야 하는 경우
// 개별 page에서 override 하여 사용
- (void)textFieldDidEdit:(UITextField *)textField;

// 피커로부터 선택한 데이터를 가공하여 UITextField에 설정을 해야 하는 경우 
// 개별 page에서 override하여 사용
- (void)pickerDidSelect:(UITextField *)textField;

// 날짜 피커로부터 선택한 데이터를 가공하여 UITextField에 설정 해야 하는 경우 
// 개별 page에서 override 하여 사용
- (void)datePickerDidSelect:(UITextField *)textField 
				 DateString:(NSString *)dateString 
					  Model:(TFDatePickerModel *)dpModel;

// 현재 입력되고 있는 UITextField(또는 TFUITextView)와 텍스트와 텍스트의 길이를 가지고 무언가를 판단해야 하는 경우 (길이를 체크하여 Alert을 띄워야 하는 경우)
// 개별 page에서 override 하여 사용
// !주의 UIView를 베이스로만들어진 TFUITextView의 경우 sender가 UIView안에 addSubview로 들어가 있는 UITextView가 세팅된다.
- (void)inputtingStateWithText:(NSString *)text length:(NSUInteger)length sender:(id)sender;

// 키보드의 검색 버튼이 눌린경우 이쪽으로 들어온다.
- (void)searchRequestButtonDidPushFromKeyboard:(UITextField *)textField;

#pragma mark -
#pragma mark Util Method

// 내비게이션 바를 숨긴다.
- (void)setNavigationBarHide:(BOOL)hide;

// 화면 전이 전 키보드를 내릴때 사용
- (void)removeKeyboardOrPickerViewForPushViewController;

// 스크롤의 contentSize를 재설정한다.(tfUIView의 height로 설정)
- (void)resetScrollViewContentSize;

// textFieldDidEdit: 메소드에서 오류처리 등에 의해 이전, 다음버튼에 대한 처리를 강제막아야 하는 경우 사용
// (이 메소드는 반드시 textFieldDidEdit:에서 사용할 것)
- (void)blockPrevAndForwProcess;

#pragma mark   ..(For Picker Init)
// 입력받은 text(Java Map 기준 - value), value(Java Map 기준 - key)를 재조합하여 textArray와 valueArray로 만든 후
// textArray와 valueArray를 페어로 묵어주는 Array(ComponentDataArray)를 생성하여 리턴한다.
- (NSArray *)getComponentDataArrayWithDisplayTextsAndValueTexts:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;

// 이미 생성되어 있는 textArray와 valueArray를 페어로 묵어주는 Array(ComponentDataArray)를 생성하여 리턴한다.
- (NSArray *)getComponentDataArrayWithDisplayArray:(NSArray *)textArray ValueArray:(NSArray *)valueArray;

// ComponentDataArray를 재조합하여 각 UITextField의 tag값을 키값으로 하는 Dictionaly 객체에 세팅 
- (void)setPickerComponentsDataWithUITextField:(UITextField *)textField ComponentDataArrays:(NSArray *)firstArray, ... NS_REQUIRES_NIL_TERMINATION;

// PickerViewType의  UITextField에 value값에 해당하는 text값을 세팅해주고,
// 나중에 value 또는 text값을 꺼내올때 사용하는 pickerSelectedComponetsData도 세팅해줌.
- (void)setPickerDefaultValueWithUITextField:(UITextField *)uiTextField Value:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark   ..(For Picker's Value And Text)
// 피커로 선택된 텍스트를 가져올 때 사용하는 함수
// component가 1개 였던 경우는 NSString이 반환
// component가 2개 이상이었던 경우는 NSArray가 반환
- (id)getPickerViewSelectedTextWithUITextfield:(UITextField *)textField;

// 피커로 선택된 값을 가져올 때 사용하는 함수
// component가 1개 였던 경우는 NSString이 반환
// component가 2개 이상이었던 경우는 NSArray가 반환
- (id)getPickerViewSelectedValueWithUITextfield:(UITextField *)textField;

#pragma mark ..(For DatePicker's Init)
- (TFDatePickerModel *)getTFDatePickerModel;

#pragma mark   ..(For DatePicker's Value)
// 설정된 날짜를 yyyyMMdd형태의 NSString으로 반환
- (NSString *)getDatePickerViewSelectedDayWithUITextField:(UITextField *)textField;

#pragma mark -
#pragma mark 내부호출용
- (void)textFieldDone;	// "키패드닫기"에 대한 액션
- (void)removeKeyboardOrPickerView:(BOOL)removeAll;

@end

//
//  TFUIScrollViewController.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "TFUIScrollViewController.h"

#define MAX_DISPLAY_HEIGHT_LANDSCAPE	570	// 320 - 20 - 32 - 49
//#define MAX_DISPLAY_HEIGHT				367.0
#define MAX_DISPLAY_HEIGHT				2700.0

//#define SCROLLVIEW_TOP_MARGIN			5.0		// 자동스크롤은 5px 미만의 y 값을 가질 수 없다.
#define SCROLLVIEW_TOP_MARGIN			41.0		// 스마트존 네비게이션 바 땜에.

@implementation TFUIScrollViewController

#pragma mark -
#pragma mark Properties

// 스크롤 기능 설정 (YES-자유로운 스크롤링, NO-키패드에 의한 스크롤링만 가능)
- (void)setScrollEnabled:(BOOL)isEnabled {
	tfUIScrollView.scrollEnabled = isEnabled;
    //    tfUIScrollView.scrollEnabled = NO;
    
}

- (BOOL)scrollEnabled {
	return tfUIScrollView.scrollEnabled;
}

#pragma mark -
#pragma mark Override Necessary Method
- (void)setTextFieldInfo {
	
#ifdef TEST_APPLICATION 
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"주의" 
														message:[NSString stringWithFormat:@"자식클래스에서의 setTextFieldInfo 메소드 오버라이드가 누락되었습니다. 확인해주세요.\n%@", self] 
													   delegate:nil 
											  cancelButtonTitle:@"확인" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
#endif
	
}

#pragma mark -
#pragma mark Optional Override Necessary Method

// UIPickerViewDataSource, UIPickerViewDelegate에서 사용할 모델을 세팅한다.
- (void)setPickerComponents {
	
#ifdef TEST_APPLICATION
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"주의" 
														message:[NSString stringWithFormat:@"자식클래스에서의 setPickerComponents 메소드 오버라이드가 누락되었습니다. 확인해주세요.\n%@", self] 
													   delegate:nil 
											  cancelButtonTitle:@"확인" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
#endif
	
}

// UIDatePicker에서 사용할 모델을 세팅한다.
- (void)setDatePickerComponents {
	
}

// UITextField의 입력한 값을 가공하여 UITextField에 설정을 해야 하는 경우
// 개별 page에서 override 하여 사용
- (void)textFieldDidEdit:(UITextField *)textField {
    
}

// 피커로부터 선택한 데이터를 가공하여 UITextField에 설정을 해야 하는 경우 
// 개별 page에서 override하여 사용
- (void)pickerDidSelect:(UITextField *)textField {
	
}

// 날짜 피커로부터 선택한 데이터를 가공하여 UITextField에 설정 해야 하는 경우 
// 개별 page에서 override 하여 사용
- (void)datePickerDidSelect:(UITextField *)textField 
				 DateString:(NSString *)dateString 
					  Model:(TFDatePickerModel *)dpModel {
	textField.text = dateString;
}

// 현재 입력되고 있는 UITextField(또는 TFUITextView)와 텍스트와 텍스트의 길이를 가지고 무언가를 판단해야 하는 경우 (길이를 체크하여 Alert을 띄워야 하는 경우)
// 개별 page에서 override 하여 사용
// !주의 UIView를 베이스로만들어진 TFUITextView의 경우 sender가 UIView안에 addSubview로 들어가 있는 UITextView가 세팅된다.
- (void)inputtingStateWithText:(NSString *)text length:(NSUInteger)length sender:(id)sender {
	
}

// 키보드의 검색 버튼이 눌린경우 이쪽으로 들어온다.
- (void)searchRequestButtonDidPushFromKeyboard:(UITextField *)textField {
	
}

#pragma mark -
#pragma mark Util Method

// 내비게이션 바를 숨긴다.
- (void)setNavigationBarHide:(BOOL)hide {
	
	self.navigationController.navigationBar.hidden = hide;
	
	if (hide) {
		scrollTopMargin = 120 + NAVIGATIONBAR_HEIGHT;	// 내비게이션바 크기만큼 더해준다.
	} else {
		scrollTopMargin = 120;		// 기존과 동일
	}
	
}

// 화면 전이 전 키보드를 내릴때 사용 (화면 전환 애니메이션이 없으면 화면 전환 이후에 호출해줘도 된다.)
- (void)removeKeyboardOrPickerViewForPushViewController {
	
	// TODO: 여거서도 거시기 해야 한다.
	if (tfUIView.frame.size.height <= tfUIScrollView.contentSize.height - (216 + 44)) {
		[tfUIScrollView setContentOffset:CGPointMake(0, 0)];
	}
	
	[self textFieldDone];
	[self removeKeyboardOrPickerView:YES];
	
}

// 스크롤의 contentSize를 재설정한다.(tfUIView의 height로 설정)
- (void)resetScrollViewContentSize {
	[tfUIScrollView setContentSize:CGSizeMake(0, tfUIView.frame.size.height)];
}

// 이전, 다음버튼에 대한 처리를 강제로 막는다.
// (이 메소드는 textFieldDidEdit:에서 사용할 것)
- (void)blockPrevAndForwProcess {
	isEmergencyClose = YES;
	[self textFieldDone];
}

#pragma mark   ..(For Picker Init)
// 입력받은 text, value를 재조합하여 textArray와 valueArray로 만든 후
// textArray와 valueArray를 페어로 묵어주는 Array(ComponentDataArray)를 생성하여 리턴한다.
- (NSArray *)getComponentDataArrayWithDisplayTextsAndValueTexts:(NSString *)first, ... {
	
	NSMutableArray *textArray;	// 디스플레이 텍스트 저장
	NSMutableArray *valueArray;	// 벨류 텍스트 저장
	
	textArray  = [[NSMutableArray alloc] init];
	valueArray = [[NSMutableArray alloc] init];
	
	[textArray addObject:first];
	
	va_list args;
	
	va_start(args, first);
	
	NSString *listItem = va_arg(args, NSString *);          // 다음 파라미터값
	int i = 0;
	while(listItem)
	{
		if (i % 2 == 1) {
			[textArray  addObject:listItem];
		} else {
			[valueArray addObject:listItem];
		}
		
		listItem = va_arg(args, NSString *);                 // nil일때까지 반복
		i++;
	}
	va_end(args);
	
	NSArray *retArray = [[[NSArray alloc] initWithObjects:textArray, valueArray, nil] autorelease];
	[textArray release];
	[valueArray release];
	
	return retArray;
	
}

// 이미 생성되어 있는 textArray와 valueArray를 페어로 묵어주는 Array(ComponentDataArray)를 생성하여 리턴한다.
- (NSArray *)getComponentDataArrayWithDisplayArray:(NSArray *)textArray ValueArray:(NSArray *)valueArray {
	return [[[NSArray alloc] initWithObjects:textArray, valueArray, nil] autorelease];
}

// ComponentDataArray를 재조합하여 각 UITextField의 tag값을 키값으로 하는 Dictionaly 객체에 세팅 
- (void)setPickerComponentsDataWithUITextField:(UITextField *)textField ComponentDataArrays:(NSArray *)firstArray, ... {
	
	NSMutableArray *groupedComponentsDataArray = [[NSMutableArray alloc] init];
	
	[groupedComponentsDataArray addObject:firstArray];
	
	va_list args;
	
	va_start(args, firstArray);
	NSArray *listItem = va_arg(args, NSArray *);
	
	while (listItem) {
		[groupedComponentsDataArray addObject:listItem];
		listItem = va_arg(args, NSArray *);
	}
	
	va_end(args);
	
	[pickerComponetsData setObject:groupedComponentsDataArray 
							forKey:[NSString stringWithFormat:@"%d", textField.tag]];
	[groupedComponentsDataArray release];
}

// PickerViewType의  UITextField에 value값에 해당하는 text값을 세팅해주고,
// 나중에 value 또는 text값을 꺼내올때 사용하는 pickerSelectedComponetsData도 세팅해줌.
- (void)setPickerDefaultValueWithUITextField:(UITextField *)uiTextField Value:(NSString *)firstValue, ... {
	
	NSArray *groupedComponentsDataArray;
	NSArray *componentDataArray;
	NSArray *textArray;
	NSArray *valueArray;
	
	groupedComponentsDataArray = [pickerComponetsData objectForKey:[NSString stringWithFormat:@"%d", uiTextField.tag]];
	
	NSMutableArray *groupedComponentsSelectedDataArray = [[NSMutableArray alloc] init];
	[pickerSelectedComponetsData setObject:groupedComponentsSelectedDataArray 
									forKey:[NSString stringWithFormat:@"%d", uiTextField.tag]];
	NSMutableArray *componentSelectedTextArray	 = [[NSMutableArray alloc] init];
	NSMutableArray *componentSelectedValuetArray = [[NSMutableArray alloc] init];
	NSMutableArray *componentSelectedRowArray	 = [[NSMutableArray alloc] init];
	
	va_list args;
	
	va_start(args, firstValue);
	NSString *listItem = firstValue;
	
	int component = 0;
	
	while (listItem) {
		
		componentDataArray = [groupedComponentsDataArray objectAtIndex:component];
		textArray  = [componentDataArray objectAtIndex:0];
		valueArray = [componentDataArray objectAtIndex:1];
		
		int i = 0;
		
		BOOL isSearched = NO;
		for (NSString* strValue in valueArray) {
			if ([strValue isEqualToString:listItem]) {
				isSearched = YES;
				break;
			}
			i++;
		}
		
		if (!isSearched) {
			i = 0;
		}
		
		[componentSelectedTextArray   addObject:[textArray objectAtIndex:i]];
		[componentSelectedValuetArray addObject:[valueArray objectAtIndex:i]];
		[componentSelectedRowArray    addObject:[NSString stringWithFormat:@"%d", i]];
		
		listItem = va_arg(args, NSString *);
		component++;
	}
	
	va_end(args);
	
	if (component == 1) {
		uiTextField.text = [componentSelectedTextArray objectAtIndex:component-1];
	} else {
		[self pickerDidSelect:uiTextField];
	}
	
	[groupedComponentsSelectedDataArray addObject:componentSelectedTextArray];
	[groupedComponentsSelectedDataArray addObject:componentSelectedValuetArray];
	[groupedComponentsSelectedDataArray addObject:componentSelectedRowArray];
	
	[componentSelectedValuetArray release];
	componentSelectedValuetArray = nil;
	[componentSelectedTextArray release];
	componentSelectedTextArray = nil;
	[componentSelectedRowArray release];
	componentSelectedRowArray = nil;
	
	[groupedComponentsSelectedDataArray release];
}

#pragma mark   ..(For Picker's Value And Text)
// 피커로 선택된 텍스트를 가져올 때 사용하는 함수
// component가 1개 였던 경우는 NSString이 반환
// component가 2개 이상이었던 경우는 NSArray가 반환
- (id)getPickerViewSelectedTextWithUITextfield:(UITextField *)textField {
	
	NSMutableArray *groupedComponentsDataArray = [pickerSelectedComponetsData objectForKey:[NSString stringWithFormat:@"%d", textField.tag]];
	
	NSMutableArray *componentSelectedTextArray = [groupedComponentsDataArray objectAtIndex:0];
	
	if ([componentSelectedTextArray count] == 1) {
		
		return [componentSelectedTextArray objectAtIndex:0];
		
	} else {
		
		return componentSelectedTextArray;
	}
	
}

// 피커로 선택된 값을 가져올 때 사용하는 함수
// component가 1개 였던 경우는 NSString이 반환
// component가 2개 이상이었던 경우는 NSArray가 반환
- (id)getPickerViewSelectedValueWithUITextfield:(UITextField *)textField {
	
	NSMutableArray *groupedComponentsDataArray = [pickerSelectedComponetsData objectForKey:[NSString stringWithFormat:@"%d", textField.tag]];
	
	NSMutableArray *componentSelectedValueArray = [groupedComponentsDataArray objectAtIndex:1];
	
	if ([componentSelectedValueArray count] == 1) {
		
		return [componentSelectedValueArray objectAtIndex:0];
		
	} else {
		
		return componentSelectedValueArray;
	}
}

#pragma mark ..(For DatePicker's Init)

- (TFDatePickerModel *)getTFDatePickerModel {
	
	TFDatePickerModel *tfDatePickerModel = [[[TFDatePickerModel alloc] init] autorelease];
	
	for (TextFieldInfoModel *textFieldModel in textFieldsInfoArray) {
		if (textFieldModel.inputType == DatePickerViewType) {
			NSString *key = [NSString stringWithFormat:@"%d", [textFieldModel.object tag]];
			
			if ([datePickerData objectForKey:key] == nil) {
				[datePickerData setObject:tfDatePickerModel forKey:key];
				
				return tfDatePickerModel;
			}
		}
	}
	
	return nil;
	
}

#pragma mark   ..(For DatePicker's Value)
// 설정된 날짜를 yyyyMMdd형태의 NSString으로 반환
- (NSString *)getDatePickerViewSelectedDayWithUITextField:(UITextField *)textField {
	
	TFDatePickerModel *tfDatePickerModel = nil;
	tfDatePickerModel = [datePickerData objectForKey:[NSString stringWithFormat:@"%d", textField.tag]];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyyMMdd"];
	
	NSString *strDate = [df stringFromDate:tfDatePickerModel.selectedDate];
	[df release];
	df = nil;
	
	return strDate;
}

#pragma mark -
#pragma mark Local Method

// AmountType일때 3자리마다 컴마를 붙여준다.
- (NSString *)convertToAmountTypeNumber:(NSString *)aNumberString {
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSString *strRet = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:[aNumberString longLongValue]]];
	[numberFormatter release];
	
	return strRet;
}

// 키보드나 피커 등에 의해 바뀐 스크롤뷰의 상태(offset, frame, contentSize)를 원상태로 돌린다. 
- (void)setOriginalCondition {
	
	CGRect textFieldFrame = [selectedUITextField convertRect:selectedUITextField.bounds toView:tfUIScrollView];
	
	if (selectedUITextField == nil) {
		return;
	}
	
	[selectedUITextField resignFirstResponder];
	selectedUITextField = nil;
	selectedUITextfieldInfo = nil;
	
//	if (tfUIScrollView != nil) {
//		
//		UIView *correntView = [tfUIScrollView.subviews objectAtIndex:0];
//		
//		// !방어코드
//		// 애니메이션 처리속도보다 빠르게 "다음" 버튼을 눌러 마지막 입력필드에 도착 했을 때
//		// orgPoint의 y가 정상처리의  orgPoint의 y보다 작게 되어 입력필드가 화면에서 사라질 경우 강제로 끌어 올림
//		switch (dispType) {
//			case TFDisplayTypeDefault: {
//				
//				if (orgPoint.y + (MAX_DISPLAY_HEIGHT - tfUIScrollView.frame.origin.y) < textFieldFrame.origin.y) {
//					orgPoint.y = textFieldFrame.origin.y;
//				}
//				
//				// 키보드가 올라왔을시 스크롤의 contentOffset이 스크롤을 가장 아래로 내렸을 때의
//				// contentOffset보다 클 경우 강제로 스크롤을 가장 아래로 내렸을때의 contentOffset으로 바꿔준다.
//				if (orgPoint.y > correntView.frame.size.height - (MAX_DISPLAY_HEIGHT - tfUIScrollView.frame.origin.y)) {
//					orgPoint.y = correntView.frame.size.height - (MAX_DISPLAY_HEIGHT - tfUIScrollView.frame.origin.y);
//				}
//				
//			}	break;
//			case TFDisplayTypeNoneTabBar: {
//				
//				if (orgPoint.y + (MAX_DISPLAY_HEIGHT + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y) < textFieldFrame.origin.y) {
//					orgPoint.y = textFieldFrame.origin.y;
//				}
//				
//				// 키보드가 올라왔을시 스크롤의 contentOffset이 스크롤을 가장 아래로 내렸을 때의
//				// contentOffset보다 클 경우 강제로 스크롤을 가장 아래로 내렸을때의 contentOffset으로 바꿔준다.
//				if (orgPoint.y > correntView.frame.size.height - (MAX_DISPLAY_HEIGHT + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y)) {
//					orgPoint.y = correntView.frame.size.height - (MAX_DISPLAY_HEIGHT + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y);
//				}
//				
//			}	break; 
//			case TFDisplayTypeLandscapeDefault: {
//				if (orgPoint.y + (MAX_DISPLAY_HEIGHT_LANDSCAPE - tfUIScrollView.frame.origin.y) < textFieldFrame.origin.y) {
//					orgPoint.y = textFieldFrame.origin.y;
//				}
//				
//				// 키보드가 올라왔을시 스크롤의 contentOffset이 스크롤을 가장 아래로 내렸을 때의
//				// contentOffset보다 클 경우 강제로 스크롤을 가장 아래로 내렸을때의 contentOffset으로 바꿔준다.
//				if (orgPoint.y > correntView.frame.size.height - (MAX_DISPLAY_HEIGHT_LANDSCAPE - tfUIScrollView.frame.origin.y)) {
//					orgPoint.y = correntView.frame.size.height - (MAX_DISPLAY_HEIGHT_LANDSCAPE - tfUIScrollView.frame.origin.y);
//				}	
//			}	break;
//			case TFDisplayTypeLandscapeNoneTabBar: {
//				if (orgPoint.y + (MAX_DISPLAY_HEIGHT_LANDSCAPE + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y) < textFieldFrame.origin.y) {
//					orgPoint.y = textFieldFrame.origin.y;
//				}
//				
//				// 키보드가 올라왔을시 스크롤의 contentOffset이 스크롤을 가장 아래로 내렸을 때의
//				// contentOffset보다 클 경우 강제로 스크롤을 가장 아래로 내렸을때의 contentOffset으로 바꿔준다.
//				if (orgPoint.y > correntView.frame.size.height - (MAX_DISPLAY_HEIGHT_LANDSCAPE + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y)) {
//					orgPoint.y = correntView.frame.size.height - (MAX_DISPLAY_HEIGHT_LANDSCAPE + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y);
//				}
//			}	break;
//			default:
//				break;
//		}
//		
//		// !방어코드
//		// 이전버튼을 눌러서 contentOffset을 원복 시켰을 경우 입력 필드가 화면에서 사라질 경우
//		// 입력필드 위치로 contentOffset을 맞춰 준다.
//		if (orgPoint.y > textFieldFrame.origin.y) {
//			orgPoint.y = textFieldFrame.origin.y;
//		}
//		
//		if (orgPoint.y < 0) {
//			orgPoint.y = 0;
//		}
//		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//		if (yPoint > 0) {
//			tfUIScrollView.frame = CGRectMake(tfUIScrollView.frame.origin.x, 
//											  yPoint, 
//											  tfUIScrollView.frame.size.width, 
//											  tfUIScrollView.frame.size.height - yPoint + SCROLLVIEW_TOP_MARGIN);
//		}
//		
//		[tfUIScrollView setContentOffset:orgPoint animated:YES];
//		[UIView commitAnimations];
//		
//		// 강제적으로 늘려놨던 스크로뷰의 contentSize를 원복시킨다.
//		[self performSelector:@selector(rollBackContentSizeHeight) 
//				   withObject:nil 
//				   afterDelay:0.3f];	// 스크롤의 setContentOffset 애니메이션 처리를 0.3초간 기다린다.
//		
//	}
	
}

// 늘려놨던 스크롤 원복
- (void)rollBackContentSizeHeight {
	
	//[tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height - 200)];
	
	if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
		self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
		// 162(키보드) + 33(툴바)
		[tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height - 195)];
	} else {
		[tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height - (216 + 44))];
	}
	
    if (rollBackedContentSizeHeightSelector) {
		[self performSelector:rollBackedContentSizeHeightSelector];
		rollBackedContentSizeHeightSelector = nil;
	}
	
	isEmergencyClose = NO;
}

// 키보드나 피커를 화면상에서 삭제
// removeAll : YES - iOS기본 키보드 타입까지 내림, NO - 피커만 내림
- (void)removeKeyboardOrPickerView:(BOOL)removeAll {
	
	if (keyboardToolbar) {
		
		if (removeAll) {
            //            [self setOriginalCondition];
            
			// 키보드 내리기
			[selectedUITextField resignFirstResponder];
			
			// 키보드 툴바 삭제
			[keyboardToolbar removeFromSuperview];
			[keyboardToolbar release];
			keyboardToolbar = nil;
		}
		
		// 피커 내리기
		[tfPickerView removeFromSuperview];
		tfPickerView.frame   = CGRectMake(0, 524, 320, 216);
		
		[tfDatePickerView removeFromSuperview];
		tfDatePickerView.frame = CGRectMake(0, 524, 320, 216);
		
	}
	selectedUITextfieldInfo = nil;
    //    selectedUITextField = nil;
}

- (void)prevForwButtonLockRelease {
	
	prevForwButtonLocked = NO;
	
}

// 키보드 또는 피커위의 툴바를 생성함
- (void)setKeyboardToolbar:(KEYBOARD_TOOLBAR_TYPE)toolBartype {
	
	// 다음, 이전 세그먼트 작성
	NSArray *segments = [NSArray arrayWithObjects:@"이전", @"다음", nil];
	
	UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:segments];
	segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedController.tintColor = [UIColor blackColor];
	segmentedController.frame = CGRectMake(0, 0, 100, 30);
	[segmentedController addTarget:self 
							action:@selector(segmentDidChange:) 
				  forControlEvents:UIControlEventValueChanged];
	
	switch (toolBartype) {
			
		case KeypadCancel: {
			
			keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,self.view.bounds.size.width, 44)];
			keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
			keyboardToolbar.tintColor = [UIColor blackColor];
			keyboardToolbar.alpha = 0.8;
			
			UIBarButtonItem *segmentBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedController];
			UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            //			UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(textFieldDone)];
            
            UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"초기화" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonDidPush:)];
			[barButtonItem2 setTag:602];
            
            //			NSArray *items = [[NSArray alloc] initWithObjects:segmentBarButtonItem, flexibleSpace, barButtonItem2, barButtonItem, nil];
            NSArray *items = [[NSArray alloc] initWithObjects:segmentBarButtonItem, flexibleSpace, barButtonItem2, nil];
            
			[keyboardToolbar setItems:items];
			
			[segmentBarButtonItem	release];
            //			[barButtonItem			release];
            [barButtonItem2         release];
			[flexibleSpace			release];
			
			[items release];	
			
		} break;
			
		case CancelAndComfirm: {
			
            //			keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 44)];
            keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 765, 500, 44)];
            
			keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
			keyboardToolbar.tintColor = [UIColor blackColor];
			keyboardToolbar.alpha = 0.8;
			
			UIBarButtonItem *segmentBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedController];
			
			UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"확인" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonDidPush:)];
			[barButtonItem setTag:600];
			
			UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonDidPush:)];
			[barButtonItem1 setTag:601];
			
            UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"초기화" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonDidPush:)];
			[barButtonItem2 setTag:602];
            
            
			UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
//			NSArray *items = [[NSArray alloc] initWithObjects:segmentBarButtonItem, flexibleSpace, barButtonItem2, barButtonItem1,barButtonItem, nil];
            NSArray *items = [[NSArray alloc] initWithObjects:flexibleSpace, barButtonItem2, barButtonItem1,barButtonItem, nil];

			[keyboardToolbar setItems:items];
			
			[segmentBarButtonItem	release];
			[barButtonItem release];
			[barButtonItem1 release];
            [barButtonItem2 release];
			[flexibleSpace release];
			
			[items release];
		} break;
			
		default:
			break;
	}
	
	[segmentedController release];
	
}

- (void)setPrevAndForwButtonState {
	
	// 이전, 다음 버튼의 상태를 다시 잡아준다.
	UIBarButtonItem *barButtonItem
	= [keyboardToolbar.items objectAtIndex:0];	// 0번 아이템이 이전,다음 segmentControl
	
	if (barButtonItem) {
		
		UISegmentedControl *segmentedController = (UISegmentedControl *)barButtonItem.customView;
		
		// setKeyboardToolbar에서 해주는 이전, 다음 버튼의 상태변경을 여기서도 해준다.
		
		// 세그먼트를 생성하기 전 현재 선택된 텍스트필드가 몇번째 아이템인지 알아낸다.
		NSUInteger index = [textFieldsInfoArray indexOfObject:selectedUITextfieldInfo];
		
		// 이전, 다음버튼을 활성화 시커놓고 조건에 의해 
		[segmentedController setEnabled:YES forSegmentAtIndex:0];	// 이전
		[segmentedController setEnabled:YES forSegmentAtIndex:1];	// 다음
		
		//  이전 버튼 disable 조건
		if (index == 0) {	
			[segmentedController setEnabled:NO forSegmentAtIndex:0];
		}
		
		// 다음버튼 disable 조건
		if (index + 1 == [textFieldsInfoArray count]) {
			[segmentedController setEnabled:NO forSegmentAtIndex:1];
		}
		//		if (index + 1 == [textFieldsInfoArray count]) {
		//			[segmentedController setTitle:@"확인" forSegmentAtIndex:1];
		//		} else {
		//			[segmentedController setTitle:@"다음" forSegmentAtIndex:1];
		//		}
		
		
	}
}

// 현재 열려있는 피커에서 텍스트 또는 값을 얻음
// component : 현재 올라와 있는 피커의 component 
// type : 0 - 텍스트, 1 - value
- (NSArray *)getSelectedTextOrValueWithComponent:(NSInteger)component type:(int)type {
	
	NSArray *groupedComponentsDataArray;
	NSArray *componentDataArray;
	NSArray *textArray;
	NSArray *valueArray;
	
	groupedComponentsDataArray = [pickerComponetsData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
	componentDataArray = [groupedComponentsDataArray objectAtIndex:component];
	textArray  = [componentDataArray objectAtIndex:0];
	valueArray = [componentDataArray objectAtIndex:1];
	
	if (type == 0) {
		return [textArray  objectAtIndex:[tfPickerView selectedRowInComponent:component]];
	} else {
		return [valueArray objectAtIndex:[tfPickerView selectedRowInComponent:component]];
	}
	
}

#pragma mark -
#pragma mark CallBack Method

- (void)toolbarButtonDidPush:(id)sender {
	
	switch ([sender tag]) {
			
		case 600: {	// picker 확인
			
			UITextField *uiTextField = (UITextField *)selectedUITextField;
			
			if (selectedUITextfieldInfo.inputType == PickerViewType) {
				
				NSMutableArray *groupedComponentsDataArray = [[NSMutableArray alloc] init];
				
				[pickerSelectedComponetsData setObject:groupedComponentsDataArray 
												forKey:[NSString stringWithFormat:@"%d", uiTextField.tag]];
				
				NSMutableArray *componentSelectedTextArray = [[NSMutableArray alloc] init];
				NSMutableArray *componentSelectedValuetArray = [[NSMutableArray alloc] init];
				NSMutableArray *componentSelectedRowArray = [[NSMutableArray alloc] init];
				
				for (int i = 0; i < [self numberOfComponentsInPickerView:nil]; i++) {
					[componentSelectedTextArray   addObject:[self getSelectedTextOrValueWithComponent:i type:0]];
					[componentSelectedValuetArray addObject:[self getSelectedTextOrValueWithComponent:i type:1]];
					[componentSelectedRowArray addObject:[NSString stringWithFormat:@"%d", [tfPickerView selectedRowInComponent:i]]];
				}
				[groupedComponentsDataArray addObject:componentSelectedTextArray];
				[groupedComponentsDataArray addObject:componentSelectedValuetArray];
				[groupedComponentsDataArray addObject:componentSelectedRowArray];
				
				[componentSelectedValuetArray release];
				componentSelectedValuetArray = nil;
				[componentSelectedTextArray release];
				componentSelectedTextArray = nil;
				[componentSelectedRowArray release];
				componentSelectedRowArray = nil;
				
				[groupedComponentsDataArray release];
				
				if ([self numberOfComponentsInPickerView:nil] == 1) {
					uiTextField.text = [self getPickerViewSelectedTextWithUITextfield:uiTextField];
				}
				
				// 확인 버튼(UIBarButtonItem)을 클릭시에는 툴바와 피커를 내려준다.
				// (이전, 다음 버튼에 의한 함수 콜로 이곳에 들어왔을 시에는 sender가 UIView)
				if ([sender isKindOfClass:[UIBarButtonItem class]]) {
					[self textFieldDone];
					[self removeKeyboardOrPickerView:YES];
					return;
				}
				
				[self pickerDidSelect:uiTextField];		// 이 함수를 override하여 포맷 등을 처리한다.
				
			} else if (selectedUITextfieldInfo.inputType == DatePickerViewType) {
				
				// 확인 버튼(UIBarButtonItem)을 클릭시에는 툴바와 피커를 내려준다.
				// (이전, 다음 버튼에 의한 함수 콜로 이곳에 들어왔을 시에는 sender가 UIView)
				if ([sender isKindOfClass:[UIBarButtonItem class]]) {
					[self textFieldDone];
					[self removeKeyboardOrPickerView:YES];
					return;
				}
				
				TFDatePickerModel *tfDatePickerModel = nil;
				tfDatePickerModel = [datePickerData objectForKey:[NSString stringWithFormat:@"%d", uiTextField.tag]];
				tfDatePickerModel.date = tfDatePickerView.date;
				
				NSDateFormatter *df = [[NSDateFormatter alloc] init];
				[df setDateFormat:tfDatePickerModel.dateFormat];
				[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:tfDatePickerModel.localeIdentifier] autorelease]];
				
				NSString *strDate = [df stringFromDate:tfDatePickerView.date];
				
				[df release];
				
				tfDatePickerModel.selectedDate = tfDatePickerView.date;
				
				[self datePickerDidSelect:uiTextField DateString:strDate Model:tfDatePickerModel];
			} else {
				
				if ([selectedUITextField isKindOfClass:[UITextView class]]) {
					//UITextView *tmpTextView = (UITextView *)selectedUITextField;
					
					//[tmpTextView setContentOffset:CGPointMake(-tmpTextView.contentInset.left, -tmpTextView.contentInset.top) animated:YES];
					
				}
				[self textFieldDidEdit:(UITextField *)selectedUITextField];
			}
			
			
		} break;
			
		case 601: {	// picker, datePicker 취소
			[self setOriginalCondition];
			[self removeKeyboardOrPickerView:YES];
		} break;
			
        case 602: { // 피커, 키패드 초기화
            
            UITextField *uiTextField = (UITextField *)selectedUITextField;
            uiTextField.text = @"";
            [self setOriginalCondition];
			[self removeKeyboardOrPickerView:YES];
        }
            
		default:
			
			break;
			
	}
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//	NSLog(@"%@", @"dalkj");
//	return YES;
//}

- (void)segmentDidChange:(id)sender {
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	
	// !방어코드 
	// 이전, 다음버튼이 락상태이거나, 
	// segmentedControl.selectedSegmentIndex = -1; 구문에 의해서 이 메소드로 들어온 경우
	// 아무 처리도 하지 않도록 막는다.
	if (prevForwButtonLocked || segmentedControl.selectedSegmentIndex == -1) {
		if (segmentedControl.selectedSegmentIndex != -1) {
			segmentedControl.selectedSegmentIndex = -1;
		}
		return;
	}
	
	NSUInteger index = [textFieldsInfoArray indexOfObject:selectedUITextfieldInfo];
	TextFieldInfoModel *nextTextFieldInfo;
	
	switch (segmentedControl.selectedSegmentIndex) {
			
		case 0: {	// 이전
			
			prevForwButtonLocked = YES;
			nextTextFieldInfo = (TextFieldInfoModel *)[textFieldsInfoArray objectAtIndex:(index-1)];
			
			UIView *trickSender = [[[UIView alloc] init] autorelease];
			trickSender.tag = 600;
			[self toolbarButtonDidPush:trickSender];
			
			// 강제로 키보드(또는 피커)를 내려야 하는 상황이라면 다음 UITextField의 becomeFirstResponder를 호출하지 않는다.
			if (!isEmergencyClose) {
				[nextTextFieldInfo.object becomeFirstResponder];
			}
			isEmergencyClose = NO;
			
			segmentedControl.selectedSegmentIndex = -1;
			
		}	break;
			
		case 1: {	// 다음
			
			// 다음이 아닌 확인인 경우, 확인 버튼을 누른 것과 같은 동작을 하도록 만들어 준다.
			if ([[segmentedControl titleForSegmentAtIndex:1] isEqualToString:@"확인"]) {
				
				// 기본 키보드
				if (selectedUITextfieldInfo.inputType < PickerViewType) {
					[self textFieldDone];
				} else {
					UIBarButtonItem *trickSender = [[[UIBarButtonItem alloc] init] autorelease];
					trickSender.tag = 600;
					[self toolbarButtonDidPush:trickSender];
				}
				
				return;
			}
			
			prevForwButtonLocked = YES;
			nextTextFieldInfo = (TextFieldInfoModel *)[textFieldsInfoArray objectAtIndex:(index+1)];
			[segmentedControl setSelectedSegmentIndex:-1];
			UIView *trickSender = [[[UIView alloc] init] autorelease];
			trickSender.tag = 600;
			[self toolbarButtonDidPush:trickSender];
			
			
			// 강제로 키보드(또는 피커)를 내려야 하는 상황이라면 다음 UITextField의 becomeFirstResponder를 호출하지 않는다.
			if (!isEmergencyClose) {
				[nextTextFieldInfo.object becomeFirstResponder];
			}
			isEmergencyClose = NO;
			
			segmentedControl.selectedSegmentIndex = -1;
			
		}	break;
			
		default:
			break;
	}
	
	
}



- (void)textFieldTextDidChange:(NSNotification *)notification {
	
	int maxLength = INT32_MAX;
	int inputType = 0;
	BOOL enableSpecialChar = YES;
	
	UITextField *textField = [notification object];
	
	if ((selectedUITextfieldInfo.inputType == CharacterType || 
		 selectedUITextfieldInfo.inputType == TextViewType  || 
		 selectedUITextfieldInfo.inputType == AlphabetOnlyType) &&
		selectedUITextfieldInfo.object == textField) {
		
		maxLength = selectedUITextfieldInfo.maxLength == 0 ? INT32_MAX : selectedUITextfieldInfo.maxLength; 
        
	} 
	
	//	// 길이 체크(바이트)
	//	if (strlen([textField.text cStringUsingEncoding:0x80000422]) > maxLength) {
	//		textField.text = strTemp;			// 오버되면 미리 복사해놨던 텍스트 필드의 text값으로 원복시킨다.
	//		[strTemp release];					// 원복 시켰으므로 temp는 필요없게 된다. 릴리즈를 하고,
	//		strTemp = nil;						// 이상한 호출 또는 메세지 호출을 해도 뻑 안나게 nil로 바꾼다.
	//	} else {
	//		[strTemp release];
	//		strTemp	= nil;
	//		strTemp = [textField.text copy];	// 오버되지 않으면 텍스트필드의 text값을 복사해논다.
	//	}
	
	// 길이체크(일반 length)
	if ([textField.text length] > maxLength) {
        
		if ([strTemp length] > maxLength) {
			textField.text = [strTemp substringWithRange:NSMakeRange(0, maxLength)];
		} else {
			if (replacementStringLength > 1) {	// 복사하여 붙여넣기로 판전
				textField.text = [textField.text substringWithRange:NSMakeRange(0, maxLength)];
			} else {
				textField.text = strTemp;
			}
		}
        
		[strTemp release];					// 원복 시켰으므로 temp는 필요없게 된다. 릴리즈를 하고,
		strTemp = nil;						// 이상한 호출 또는 메세지 호출을 해도 뻑 안나게 nil로 바꾼다.
	} else {
		[strTemp release];
		strTemp	= nil;
	}
	
	[self inputtingStateWithText:textField.text 
						  length:[textField.text length] 
						  sender:([textField isKindOfClass:[UITextField class]] ? textField : textField.superview)];
	
	
}

// 통지센터에 의해 키보드가 등장 할 때 이쪽 콜백함수로 들어온다.
- (void)keyboardWillShow:(NSNotification *)notification {
	
//	if (keyboardToolbar == nil) {
//		
//		// 키보드툴바를 세팅
//		[self setKeyboardToolbar:KeypadCancel];
//		
//		// (0, 480) 포지션에서 (0, 161) 포지션으로 이동 애니메이션을 보여줌
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//		
//		if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
//			self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
//            //			if (self.navigationController == nil || 
//            //				self.navigationController.navigationBar.hidden) {		
//            //				keyboardToolbar.frame = CGRectMake(0, 73 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 33);
//            //			} else {
//            //				keyboardToolbar.frame = CGRectMake(0, 73, 480, 33);
//            //			}
//            if (self.navigationController == nil ||
//				self.navigationController.navigationBar.hidden) {		
//				keyboardToolbar.frame = CGRectMake(0, 500 - 20 - 216 - 44, 540, 44);
//			} else {
////				keyboardToolbar.frame = CGRectMake(0, 500 - 20 - 216 - 44, 540, 44);
//                keyboardToolbar.frame = CGRectMake(0, 200, 540, 44);
//
//			}
//            
//		} else {
//            //			if (self.navigationController == nil ||
//            //				self.navigationController.navigationBar.hidden) {		
//            //				keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 320, 44);
//            //			} else {
//            //				keyboardToolbar.frame = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 - 44, 320, 44);
//            //			}
//            if (self.navigationController == nil ||
//				self.navigationController.navigationBar.hidden) {		
//				keyboardToolbar.frame = CGRectMake(0, 740 - 20 - 216 - 44, 540, 44);
//			} else {
//				keyboardToolbar.frame = CGRectMake(0, 740 - 20 - 216 - 44, 540, 44);
//			}
//            
//		}
//		
//		[self.view addSubview:keyboardToolbar];		
//		[UIView commitAnimations];
//		
//	}
//	
//	// 이전, 다음 버튼 상태를 맞춰 준다.
//	[self setPrevAndForwButtonState];
	
}

// 통지센터에 의해 키보드가 사라질 때 이쪽 콜백함수로 들어온다.
- (void)keyboardWillHide:(NSNotification *)notification {
    if (selectedUITextField == nil) {
		return;
	}
	
	if (selectedUITextfieldInfo.inputType < PickerViewType &&
		!isEmergencyClose) {
		[self textFieldDidEdit:(UITextField *)selectedUITextField];
	}
	
	if (selectedUITextfieldInfo.inputType >= PickerViewType &&
		!isEmergencyClose) {
        [self removeKeyboardOrPickerView:YES];
	}
//    [keyboardToolbar removeFromSuperview];
//	[keyboardToolbar release];
//	keyboardToolbar = nil;
    
	[self setOriginalCondition];
    
}

// "키패드닫기"에 대한 액션
- (void)textFieldDone {
	
	if (selectedUITextField == nil) {
		return;
	}
	
	if (selectedUITextfieldInfo.inputType < PickerViewType &&
		!isEmergencyClose) {
		[self textFieldDidEdit:(UITextField *)selectedUITextField];
	}
	
	if (selectedUITextfieldInfo.inputType >= PickerViewType &&
		!isEmergencyClose) {
		isEmergencyClose = YES;
		UIBarButtonItem *trickSender = [[[UIView alloc] init] autorelease];
		trickSender.tag = 600;
		[self toolbarButtonDidPush:trickSender];
	}
	
	[self setOriginalCondition];
	
}

#pragma mark -
#pragma mark UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //	NSLog(@"%@", keyboardToolbar);
	for (id info in textFieldsInfoArray) {
		
		if (((TextFieldInfoModel *)info).object == textField) {
			
			if (selectedUITextfieldInfo != nil) {
				
				// 전 입력필드가 iOS기본 키보드를 사용할 경우 현재 입력필드와 다르면 키보드 내려주자.
				if (selectedUITextfieldInfo.inputType != ((TextFieldInfoModel *)info).inputType) {
					
					switch (selectedUITextfieldInfo.inputType) {
							
						case CharacterType:
						case NumberType:
						case NumberAndPunctuationType:
						case AmountType:
						case AlphabetOnlyType: 
						case TextViewType : {
							if (((TextFieldInfoModel *)info).inputType >= PickerViewType) {
                                
								[self removeKeyboardOrPickerView:YES];
                                //                                [self textFieldDone];
                                
							} else {
								[self removeKeyboardOrPickerView:NO];	
                                //                                [self removeKeyboardOrPickerView:NO];	
                                
                                //								[self textFieldDone];
							}
							
						} break;
							
						default:
							break;
					}
				}
				
				switch (selectedUITextfieldInfo.inputType) {
					case PickerViewType: 
					case DatePickerViewType : {
                        //                        [self textFieldDone];
                        
						[self removeKeyboardOrPickerView:YES];
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
					} break;
				}
				
			}
			selectedUITextfieldInfo = info;
            
			if (selectedUITextfieldInfo.inputType == PickerViewType) {
//				[textField resignFirstResponder]; 
                
                @try//modal에서 키보드 숨기기
                {
                    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
                    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
                    [activeInstance performSelector:@selector(dismissKeyboard)];
                }
                @catch (NSException *exception)
                {
                    NSLog(@"%@", exception);
                }
                
                
                
                
				// 스크롤 사이즈를 잡아주기 위해 강제로 textFieldDidBeginEditing 펑션을 부른다.
				[self textFieldDidBeginEditing:textField];
				selectedUITextField = textField;
				
				// 피커를 보이게 한다.
				tfPickerView.hidden = NO;
				// 키보드툴바를 세팅
				[self setKeyboardToolbar:CancelAndComfirm];
				
				[tfPickerView reloadAllComponents];
//				[textField resignFirstResponder]; 
//				[tfPickerView becomeFirstResponder];

				NSArray *groupedComponentsDataArray 
				= [pickerSelectedComponetsData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
				
				if (groupedComponentsDataArray == nil) {
					// 피커의 전 component의 선택된 위치를 0번째 indexRow로 한다.
					for (int i = 0; i < [tfPickerView numberOfComponents]; i++) {
						[tfPickerView selectRow:0 inComponent:i animated:NO];
					} 
				} else {
					NSMutableArray *componentSelectedRowArray = [groupedComponentsDataArray objectAtIndex:2];
					for (int i = 0; i < [tfPickerView numberOfComponents]; i++) {
						[tfPickerView selectRow:[[componentSelectedRowArray objectAtIndex:i] intValue] inComponent:i animated:NO];
					} 
				}
				
				// (0, 480) 포지션에서 (0, 161) 포지션으로 이동 애니메이션을 보여줌
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.3f];
				
				if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
					self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
					
                    //					if (self.navigationController == nil ||
                    //						self.navigationController.navigationBar.hidden) {
                    //						keyboardToolbar.frame = CGRectMake(0, 73 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 33);	// !주의 좌표 강제로 세팅
                    //						tfPickerView.frame    = CGRectMake(0, 106 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 162);						// !주의 좌표 강제로 세팅
                    //					} else {
                    //						keyboardToolbar.frame = CGRectMake(0, 73, 480, 33);
                    //						tfPickerView.frame    = CGRectMake(0, 106, 480, 162);						// !주의 좌표 강제로 세팅
                    //					}
                    if (self.navigationController == nil ||
						self.navigationController.navigationBar.hidden) {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 540, 44);	// !주의 좌표 강제로 세팅
						tfPickerView.frame    = CGRectMake(0, 480 - 20 - 216, 540, 216);		// !주의 좌표 강제로 세팅
					} else {
//						keyboardToolbar.frame = CGRectMake(0, 510 - 20 - NAVIGATIONBAR_HEIGHT - 216 - 44, 540, 44);
//						
//						if (self.tabBarController != nil) 
//							tfPickerView.frame    = CGRectMake(0, 510 - 20 - NAVIGATIONBAR_HEIGHT - 216 + 64, 540, 216);
//						else 
//							tfPickerView.frame    = CGRectMake(0, 510 - 20 - NAVIGATIONBAR_HEIGHT - 216, 540, 216);
                        keyboardToolbar.frame = CGRectMake(0, 350 - 44, 540, 44);
						
						if (self.tabBarController != nil) 
							tfPickerView.frame    = CGRectMake(0, 510 + 64, 540, 216);
						else 
							tfPickerView.frame    = CGRectMake(0, 350, 540, 216);

					}
                    
				} else {
					
					if (self.navigationController == nil ||
						self.navigationController.navigationBar.hidden) {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 540, 44);	// !주의 좌표 강제로 세팅
						tfPickerView.frame    = CGRectMake(0, 480 - 20 - 216, 540, 216);		// !주의 좌표 강제로 세팅
					} else {
						keyboardToolbar.frame = CGRectMake(0, 350 - 44, 540, 44);
						
						if (self.tabBarController != nil) 
							tfPickerView.frame    = CGRectMake(0, 570 - 20 - NAVIGATIONBAR_HEIGHT - 216 + 64, 540, 216);
						else 
							tfPickerView.frame    = CGRectMake(0, 350, 540, 216);
						
					}
					
				}
				
				[self.view addSubview:keyboardToolbar];
				if (self.tabBarController != nil) {
					[self.tabBarController.view addSubview:tfPickerView];
				} else {
					[self.view addSubview:tfPickerView];
				}
				
				[UIView commitAnimations];
				
				// 이전, 다음 버튼 상태를 맞춰 준다.
				[self setPrevAndForwButtonState];
				
				return NO;
				
			} else if (selectedUITextfieldInfo.inputType == DatePickerViewType) {
				
				// 스크롤 사이즈를 잡아주기 위해 강제로 textFieldDidBeginEditing 펑션을 부른다.
				[self textFieldDidBeginEditing:textField];
				selectedUITextField = textField;
				
				// 피커를 보이게 한다.
				tfDatePickerView.hidden = NO;
				
				// 키보드툴바를 세팅
				[self setKeyboardToolbar:CancelAndComfirm];
				
				// (0, 480) 포지션에서 (0, 161) 포지션으로 이동 애니메이션을 보여줌
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.3f];
				
				if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
					self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
					
                    //					if (self.navigationController == nil ||
                    //						self.navigationController.navigationBar.hidden) {
                    //						keyboardToolbar.frame = CGRectMake(0, 73 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 33);	// !주의 좌표 강제로 세팅
                    //						tfDatePickerView.frame    = CGRectMake(0, 106 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 162);						// !주의 좌표 강제로 세팅
                    //					} else {
                    //						keyboardToolbar.frame = CGRectMake(0, 73, 480, 33);
                    //						tfDatePickerView.frame    = CGRectMake(0, 106, 480, 162);						// !주의 좌표 강제로 세팅
                    //					}
                    if (self.navigationController == nil ||
						self.navigationController.navigationBar.hidden) {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 320, 44);	// !주의 좌표 강제로 세팅
						tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - 216, 320, 216);		// !주의 좌표 강제로 세팅
					} else {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 - 44, 320, 44);
                        
						if (self.tabBarController != nil)
							tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 + 64, 320, 216);
						else
							tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216, 320, 216);
                        
					}
                    
					
				} else {
					
					if (self.navigationController == nil ||
						self.navigationController.navigationBar.hidden) {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 320, 44);	// !주의 좌표 강제로 세팅
						tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - 216, 320, 216);		// !주의 좌표 강제로 세팅
					} else {
						keyboardToolbar.frame = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 - 44, 320, 44);
                        
						if (self.tabBarController != nil)
							tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 + 64, 320, 216);
						else
							tfDatePickerView.frame    = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216, 320, 216);
                        
					}
					
				}
				
				[self.view addSubview:keyboardToolbar];
				
				if (self.tabBarController != nil) {
					[self.tabBarController.view addSubview:tfDatePickerView];
				} else {
					[self.view addSubview:tfDatePickerView];
				}
				
				[UIView commitAnimations];
				
				TFDatePickerModel *tfDatePickerModel = [datePickerData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
				
				tfDatePickerView.date			= tfDatePickerModel.date;
				tfDatePickerView.maximumDate	= tfDatePickerModel.maximumDate;
				tfDatePickerView.minimumDate	= tfDatePickerModel.minimumDate;
				tfDatePickerView.minuteInterval = tfDatePickerModel.minuteInterval;
				tfDatePickerView.datePickerMode	= tfDatePickerModel.datePickerMode;
				
				// 이전, 다음 버튼 상태를 맞춰 준다.
				[self setPrevAndForwButtonState];
				
				return NO;
				
			}else{
//                if (selectedUITextfieldInfo.inputType != nil) {
//                    //                    NSLog(@"%i", selectedUITextfieldInfo.inputType);
//                    //아이패드에서 툴바 안올라와서 수정
//                    if (selectedUITextfieldInfo.inputType != PickerViewType ||selectedUITextfieldInfo.inputType != DatePickerViewType) {
//                        if (keyboardToolbar == nil) {
//                            //                            NSLog(@"1111111%@", self.view.subviews);
//                            ////                            BOOL isIndicator = YES;
//                            //                            for (UIToolbar *uiView in tfUIView.subviews) {
//                            //                                 NSLog(@"123123123%@", uiView);
//                            //                                if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
//                            ////                                    isIndicator = NO;
//                            //                                    NSLog(@"%123123123@, uiView");
//                            //                                }
//                            //                            }        
//                            //                            if ( isIndicator ) {
//                            //                                indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//                            //                                indicator.hidesWhenStopped = YES;
//                            //                                indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//                            //                                [self.view addSubview:indicator];
//                            //                                indicator.center = self.view.center;
//                            //                                [indicator startAnimating];
//                            //                            }
//                            //
//                            
//                            // 키보드툴바를 세팅
//                            [self setKeyboardToolbar:KeypadCancel];
//                            
//                            // (0, 480) 포지션에서 (0, 161) 포지션으로 이동 애니메이션을 보여줌
//                            [UIView beginAnimations:nil context:NULL];
//                            [UIView setAnimationDuration:0.3f];
//                            
//                            if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
//                                self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
//                                //			if (self.navigationController == nil || 
//                                //				self.navigationController.navigationBar.hidden) {		
//                                //				keyboardToolbar.frame = CGRectMake(0, 73 + NAVIGATIONBAR_HEIGHT_LANDSCAPE, 480, 33);
//                                //			} else {
//                                //				keyboardToolbar.frame = CGRectMake(0, 73, 480, 33);
//                                //			}
//                                if (self.navigationController == nil ||
//                                    self.navigationController.navigationBar.hidden) {		
//                                    keyboardToolbar.frame = CGRectMake(0, 650 - 20 - 216 - 44, 540, 44);
//                                } else {
//                                    keyboardToolbar.frame = CGRectMake(0, 650 - 20 - 216 - 44, 540, 44);
//                                }
//                                
//                            } else {
//                                //			if (self.navigationController == nil ||
//                                //				self.navigationController.navigationBar.hidden) {		
//                                //				keyboardToolbar.frame = CGRectMake(0, 480 - 20 - 216 - 44, 320, 44);
//                                //			} else {
//                                //				keyboardToolbar.frame = CGRectMake(0, 480 - 20 - NAVIGATIONBAR_HEIGHT - 216 - 44, 320, 44);
//                                //			}
//                                if (self.navigationController == nil ||
//                                    self.navigationController.navigationBar.hidden) {		
//                                    keyboardToolbar.frame = CGRectMake(0, 740 - 20 - 216 - 44, 540, 44);
//                                } else {
//                                    keyboardToolbar.frame = CGRectMake(0, 740 - 20 - 216 - 44, 540, 44);
//                                }
//                                
//                            }
//                            
//                            [self.view addSubview:keyboardToolbar];		
//                            [UIView commitAnimations];
//                            
//                            // 이전, 다음 버튼 상태를 맞춰 준다.
//                            [self setPrevAndForwButtonState];
//                            
//                        }
//                        
//                    }
//                    
//                    
//                    
//                    
//                    
//                }
                
            }
			
		} 
	}
	
	// 이전, 다음 버튼 상태를 맞춰 준다.
	[self setPrevAndForwButtonState];
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {	
	
	// 이미 어떠한 텍스트필드가 입력대기(또는 입력 중) 상태였는지 체크
	if (selectedUITextField) {
		isSequenceInput = YES;
        //        isSequenceInput = NO;
	}
	
	// 현재 선택되어 있는 UITextField의 주소값을 저장해논다.(툴바에서 취소바튼등을 눌를때 사용)
	selectedUITextField = textField;
	
	for (id info in textFieldsInfoArray) {
		if (((TextFieldInfoModel *)info).object == selectedUITextField) {
			selectedUITextfieldInfo = info;
		} 
	}
	
//	if (!isSequenceInput) {
//		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//		if (yPoint > 0) {
//			tfUIScrollView.frame = CGRectMake(tfUIScrollView.frame.origin.x, 
//											  SCROLLVIEW_TOP_MARGIN, 
//											  tfUIScrollView.frame.size.width, 
//											  tfUIScrollView.frame.size.height + yPoint - SCROLLVIEW_TOP_MARGIN);
//		}		
//		[UIView commitAnimations];
//		
//		if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
//			self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
//			// 162(키보드) + 33(툴바)
//            //			[tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height + 195)];
//            [tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height + 216 + 44)];
//            
//		} else {
//			// 일반키보드 높이 216이지만 207으로 설정해야 딱 맞음
//			[tfUIScrollView setContentSize:CGSizeMake(0, tfUIScrollView.contentSize.height + 216 + 44)];
//		}
//		
//		
//	}
	isSequenceInput = NO;
	
	// 현재 선택되어 있는  UITextField의 위치를 tfUIScrollView로 기준하여 상대좌표를 구한다.
	CGRect textFieldFrame = [textField convertRect:textField.bounds toView:tfUIScrollView];
	
	// 스크롤 해야 하는 offset
//	CGPoint newContentOffset = CGPointMake(0, 0);;
//	
//	if ([textField isKindOfClass:[UITextField class]]) {
//		
//		// 선택되어져 있는 UITextField의 y 좌표가 키보드에 의해 가려지는 경우
//		if (textFieldFrame.origin.y > scrollTopMargin) {
//			
//			newContentOffset = textFieldFrame.origin;
//			newContentOffset.x = 0;
//			newContentOffset.y = (newContentOffset.y - scrollTopMargin) < 0 ? 0 : (newContentOffset.y - scrollTopMargin);
//			
//		} else {
//			
//			newContentOffset = CGPointMake(0, 0);
//			
//		}
//		
//	} else if ([textField isKindOfClass:[UITextView class]]) {	// !주의 UITextView의 경우도 처리 해준다.
//		
//		// UITextView와 같은 경우는 UITextView의 높이가 내비게이션바와 툴바 사이에 들어갈 수 있는지 판단부터 한다.
//		if (textField.frame.size.height < 160 - 5) {
//			
//			newContentOffset = textFieldFrame.origin;
//			newContentOffset.x = 0;
//			
//			if ([[textField superview] isKindOfClass:[TFUITextView class]]) {
//				newContentOffset.y = newContentOffset.y - ((160 - textField.superview.frame.size.height) / 2);
//			} else {
//				newContentOffset.y = newContentOffset.y - ((160 - textField.frame.size.height) / 2);
//			}
//			
//		} else {
//			
//			newContentOffset = textFieldFrame.origin;
//			newContentOffset.x = 0;
//			newContentOffset.y = newContentOffset.y - 5;
//			
//		}
//		
//		if (newContentOffset.y < 0) {
//			newContentOffset.y = 0;
//		}
//	}
	
	
//	orgPoint = [tfUIScrollView contentOffset];
//	
//	
//	[tfUIScrollView setContentOffset:newContentOffset animated:YES];
	
	
	[self performSelector:@selector(prevForwButtonLockRelease) withObject:nil afterDelay:0.5f];
	
	
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	int maxLength = INT32_MAX;
	int inputType = 0;
	BOOL enableSpecialChar = YES;
	
	//	for (int i = 0; i < [textFieldsInfoArray count]; i++) {
	//		
	//		textFieldInfo = (TextFieldUtil *)[textFieldsInfoArray objectAtIndex:i];		// 이 변수를 노티피 콜백에서도 쓴다.
	//		
	//		UITextField *compareTextField = (UITextField *)textFieldInfo.object;
	//		
	//		if (textField == compareTextField) {
	//			maxLength = textFieldInfo.maxLength; 
	//			inputType = textFieldInfo.inputType;
	//			enableSpecialChar = textFieldInfo.enableSpecialChar;
	//			
	//			break;
	//		}
	//	} 
	
	if (selectedUITextfieldInfo) {
		maxLength			= selectedUITextfieldInfo.maxLength == 0 ? INT32_MAX : selectedUITextfieldInfo.maxLength; 
		inputType			= selectedUITextfieldInfo.inputType;
		enableSpecialChar	= selectedUITextfieldInfo.enableSpecialChar;
	}
	
	replacementStringLength = [string length];
	
	if (inputType == CharacterType ||	
		inputType == AlphabetOnlyType ||
		inputType == TextViewType) {		// 캐릭터 타입은 노티피케이션에서 잡는다.
		
		strTemp = [textField.text copy];	// 노티피케이션에서 원복할때 쓴다.
		
		if (inputType == AlphabetOnlyType) {
			NSString *strAlphabetAndnumber = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
			
			NSCharacterSet *cs;
			cs = [[NSCharacterSet characterSetWithCharactersInString:strAlphabetAndnumber] invertedSet];
			NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
			BOOL basicTest = [string isEqualToString:filtered];
			
			if (!basicTest && [string length] > 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" 
																message:@"알파벳과 숫자를 제외한 문자는 입력할 수 없습니다." 
															   delegate:nil 
													  cancelButtonTitle:@"확인" 
													  otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
				
				return NO;
			}
			
		} else {
			// 특수문자 입력가능한지 체크 (AmountType과 NumberType은 Number Pad이므로 특수문자를 입력할 수 없다.)
			if (!enableSpecialChar) {
				//				NSString *SPECIAL_CHAR = @"-/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>€£¥•";
				NSString *SPECIAL_CHAR = @"₩\\¥£•";
				
				NSCharacterSet *cs;
				cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
				NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
				BOOL basicTest = [string isEqualToString:filtered];
				
				if (basicTest && [string length] > 0 ) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" 
																	message:@"₩\\¥£• 특수문자는 입력할 수 없습니다." 
																   delegate:nil 
														  cancelButtonTitle:@"확인" 
														  otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
					
					return NO;
				}
			}
		}
		
		return YES;						// 노티피케이션 콜백으로 이동한다.
	}
	
	
	// 이하 처리는 AmountType과 NumberType에 한하여 작동한다.
	
	NSString *strForward  = [textField.text substringToIndex:range.location];
	
	NSRange tmpRange = NSMakeRange(range.location + range.length, [textField.text length] - [strForward length] - range.length);
	
	NSString *strBackward = [textField.text substringWithRange:tmpRange];
	
	NSString *text = [NSString stringWithFormat:@"%@%@%@", strForward, string, strBackward];
	
	// 입력타입이 금액일 경우 ,를 삭제처리 
	if (inputType == AmountType) {
		text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
	} 
	
	// Validation MaxLength  
	if(string && [string length] && !([text length] <= maxLength))
		return NO;
	
	// 입력타입이 금액일 경우 자동으로 ,를 추가
	if (inputType == AmountType){
		
		// 숫자 입력
		if ([string isEqualToString:[NSString stringWithFormat:@"%d",[string intValue]]]) {
			textField.text = [self convertToAmountTypeNumber:text];
			return NO;
			
		} else {	// 백스페이스 입력
			
			if (range.length == 1) {
				NSRange tmpRange = NSMakeRange(range.location - range.length + 1, range.length);
				NSString *strDeleteTarget = [textField.text substringWithRange:tmpRange];
				
				if ([strDeleteTarget isEqualToString:@","]) {
					strForward = [textField.text substringToIndex:(range.location - 1)];
				}
			}
			
			text = [NSString stringWithFormat:@"%@%@", strForward, strBackward];
			text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
			
			textField.text = [self convertToAmountTypeNumber:text];
			
			
			return NO;
		}
	}
	
	return YES;
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self textFieldDone];
	
	switch (textField.returnKeyType) {
		case UIReturnKeySearch:			// 검색버튼이 눌린 경우
			[self searchRequestButtonDidPushFromKeyboard:textField];
			break;
		default:
			break;
	}
	
	return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	[self textFieldShouldBeginEditing:(UITextField *)textView];
	return YES;
}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
//
- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self textFieldDidBeginEditing:(UITextField *)textView];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return [self textField:(UITextField *)textView shouldChangeCharactersInRange:range replacementString:text];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self textFieldDidEndEditing:(UITextField *)textView];
}

#pragma mark -
#pragma mark UIPickerViewDataSource Method
// Components 갯수를 반환
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	
	NSArray *groupedComponentsDataArray;
	
	groupedComponentsDataArray = [pickerComponetsData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
	
	return [groupedComponentsDataArray count];
}

// 각 Components의 Row수를 반환
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	NSArray *groupedComponentsDataArray;
	NSArray *componentsDataArray;
	NSArray *textArray;
	
	groupedComponentsDataArray = [pickerComponetsData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
	componentsDataArray = [groupedComponentsDataArray objectAtIndex:component];
	textArray = [componentsDataArray objectAtIndex:0];
	
	return [textArray count];
	
}

#pragma mark -
#pragma mark UIPickerViewDelegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	NSArray *groupedComponentsDataArray;
	NSArray *componentsDataArray;
	NSArray *textArray;
	
	groupedComponentsDataArray = [pickerComponetsData objectForKey:[NSString stringWithFormat:@"%d", selectedUITextField.tag]];
	componentsDataArray = [groupedComponentsDataArray objectAtIndex:component];
	textArray = [componentsDataArray objectAtIndex:0];
	
	return [textArray objectAtIndex:row];
}

#pragma mark -
#pragma mark View Translation Process
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// TextField의 값 변화를 관찰하는 옵져버 등록
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldTextDidChange:) 
												 name:UITextFieldTextDidChangeNotification 
											   object:nil];
	
	// TextView의 값 변화를 관찰하는 옵져버 등록
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldTextDidChange:) 
												 name:UITextViewTextDidChangeNotification
											   object:nil];
	
	// 키보드 등장 시 불리워지는 통지센터에 옵져버로 등록
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
    // 키보드가 사라질 시 불리워지는 통지센터에 옵져버로 등록
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// 통지센터에서 등록된 옵져버를 삭제한다.
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UITextFieldTextDidChangeNotification 
												  object:nil]; 
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UITextViewTextDidChangeNotification 
												  object:nil]; 
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
	
	[keyboardToolbar removeFromSuperview];
	[keyboardToolbar release];
	keyboardToolbar = nil;
	
	[tfPickerView   removeFromSuperview];
	
}

#pragma mark -
#pragma mark XCode GENERATED
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setNavigationBarHide:NO];
	
	//	scrollTopMargin = 40;	// 가로모드에 내비게이션바가 있는 경우
    //	scrollTopMargin = 120;	// 세로모드에 내비게이션바가 있는 경우
	scrollTopMargin = 210;
	for (UIView *uiView in self.view.subviews) {
		
		if ([uiView isKindOfClass:[UIScrollView class]]) {
			
			tfUIScrollView = (UIScrollView*)uiView;
			
			UIView *dispView = nil;
			if ([[tfUIScrollView.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]) {
				// background ImageView로 인식 다음 object를 view로 인식시킴
				dispView = (UIView *)[tfUIScrollView.subviews objectAtIndex:1];
			} else {
				dispView = (UIView *)[tfUIScrollView.subviews objectAtIndex:0];
			}
			
			self.view.autoresizesSubviews		= NO;
			tfUIScrollView.autoresizesSubviews  = NO;
			dispView.autoresizesSubviews		= NO;
			
			tfUIScrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
			
			if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
				self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
				
				if (tfUIScrollView.frame.size.height >= MAX_DISPLAY_HEIGHT_LANDSCAPE + TABBAR_HEIGHT) {
					tfUIScrollView.frame = CGRectMake(0, 
													  tfUIScrollView.frame.origin.y, 
													  540, 
													  MAX_DISPLAY_HEIGHT_LANDSCAPE + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y);
					dispType = TFDisplayTypeLandscapeNoneTabBar;	// 탭바가 없는 화면으로 간주
				} else {
					// 위쪽 네비게이션바와 아랫쪽 툴바를 제외한 실제 페이지 영역이 367이다.
					tfUIScrollView.frame = CGRectMake(0, 
													  tfUIScrollView.frame.origin.y, 
													  540, 
													  MAX_DISPLAY_HEIGHT_LANDSCAPE - tfUIScrollView.frame.origin.y);
					dispType = TFDisplayTypeLandscapeDefault;	// 탭바가 있는 화면으로 간주
				}
				
			} else {
				if (tfUIScrollView.frame.size.height >= MAX_DISPLAY_HEIGHT + TABBAR_HEIGHT) {
					tfUIScrollView.frame = CGRectMake(0, 
													  tfUIScrollView.frame.origin.y, 
													  540, 
													  MAX_DISPLAY_HEIGHT + TABBAR_HEIGHT - tfUIScrollView.frame.origin.y);
					dispType = TFDisplayTypeNoneTabBar;	// 탭바가 없는 화면으로 간주
				} else {
					// 위쪽 네비게이션바와 아랫쪽 툴바를 제외한 실제 페이지 영역이 367이다.
					tfUIScrollView.frame = CGRectMake(0, 
													  tfUIScrollView.frame.origin.y, 
													  540, 
													  MAX_DISPLAY_HEIGHT - tfUIScrollView.frame.origin.y);
					dispType = TFDisplayTypeDefault;	// 탭바가 있는 화면으로 간주
				}
			}
			
			[tfUIScrollView setContentSize:CGSizeMake(0, dispView.frame.size.height)];
			
			yPoint = tfUIScrollView.frame.origin.y;
			tfUIView = dispView;
			
		}
		
	}
	
	textFieldsInfoArray = [[NSMutableArray alloc] init];
	
	[self setTextFieldInfo];
	
	if (hasPickerView) {
		
        //		tfPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 566, 320, 100)];
        tfPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 566, 766, 100)];
        
		tfPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tfPickerView.hidden = YES;
		tfPickerView.tag = 1;
		tfPickerView.delegate = self;
		tfPickerView.dataSource = self;
		tfPickerView.showsSelectionIndicator = YES;
		
		pickerComponetsData = [[NSMutableDictionary alloc] init];
		pickerSelectedComponetsData = [[NSMutableDictionary alloc] init];
		[self setPickerComponents];
		
	}
	
	if (hasDatePickerView) {
        tfDatePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 566, 540, 100)];
        
        //		tfDatePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 566, 320, 100)];
		tfDatePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tfDatePickerView.datePickerMode = UIDatePickerModeDate;
		tfDatePickerView.hidden = YES;
		tfDatePickerView.tag = 2;
		
		tfDatePickerView.date = [NSDate date];
		datePickerData = [[NSMutableDictionary alloc] init];
		
		[self setDatePickerComponents];
	}
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
 interfaceOrientation == UIInterfaceOrientationLandscapeRight)
 return YES;
 else
 return NO;
 }
 */
- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration { 
    //	MainMenuController *mainController = [[MainMenuController alloc] init];
    
    //	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
    //	CATransition *myTransition = [CATransition animation];
	switch (self.interfaceOrientation) {
            
		case UIDeviceOrientationPortrait:
            scrollTopMargin = 210;
            
			break;
		case UIDeviceOrientationPortraitUpsideDown:
            
            scrollTopMargin = 210;
            
			break;
		case UIDeviceOrientationLandscapeLeft:
            scrollTopMargin = 40;
            
			break;
		case UIDeviceOrientationLandscapeRight:
            scrollTopMargin = 40;
            
			break;
			
	}
}
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


- (void)dealloc {
	
	[textFieldsInfoArray release];
	
	// PickerView 관련
	[tfPickerView				 release];
	[pickerComponetsData		 release];
	[pickerSelectedComponetsData release];
	
	// DatePickerView 관련
	[tfDatePickerView release];
	
    [super dealloc];
}


@end

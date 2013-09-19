//
//  TFUIViewController.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFDefine.h"
#import "StringUtil.h"
#import "TFUINavigationBar.h"

#define TFUIViewAnimationDuration 0.3

enum {
	TFUIViewAnimationTransitionNone,
	TFUIViewAnimationTransitionRightToLeft,	// 오른쪽에서 왼쪽으로 애니메이션
	TFUIViewAnimationTransitionLeftToRight,	// 왼쪽에서 오른쪽으로 애니메이션
	TFUIViewAnimationTransitionBottomToTop,	// 아랫쪽에서 윗쪽으로 애니메이션
	TFUIViewAnimationTransitionTopToBottom,	// 윗쪽에서 아랫쪽으로 애니메이션
    TFUIViewAnimationTransitionFlipFromLeft,	// 왼쪽으로 회전 애니메이션
	TFUIViewAnimationTransitionFlipFromRight,	// 오른쪽으로 회전 애니메이션
};
typedef NSUInteger TFUIViewAnimationTransition;

@interface TFUIViewController : UIViewController {
	
	TFTestAppDelegate *application;		// appDelegate
	
	NSString *subViewName;
	UIView *coveredView;
	TFUIViewAnimationTransition animationTrasition;		// viewWillAppear와 viewWillDisappear에서 사용되는 에니메이션
	
	UIButton *navigationLeftButton;		// 왼쪽 버튼
	UIButton *navigationRightButton;	// 오른쪽 버튼
	
	BOOL isRippleAnimating;
	UIView *ripplePopupView;
	
	// 레티나용 이미지가 @2x를 달지 않고 들어온 경우 강제로 이미지를 1/2사이즈로 줄여줘야 함...
	// isRetinaDrawing이 YES이면 1/2사이즈로 드로잉 시켜줌
	BOOL isRetinaDrawing;	

}

@property (nonatomic, assign) TFTestAppDelegate *application;		// appDelegate

@property (nonatomic, assign) UIView *coveredView;

@property (nonatomic, retain) UIButton *navigationLeftButton;
@property (nonatomic, retain) UIButton *navigationRightButton;

#pragma mark -
#pragma mark CallBack Method
- (void)naviRigthbtnPress:(id)sender;
- (void)backButtonDidPush:(id)sender;

#pragma mark -
#pragma mark Util Method

// 내비게이션 바를 숨긴다.
- (void)setNavigationBarHide:(BOOL)hide;

// 내비게이션에 디폴트 타이틀을 넣는다.
- (void)setTitle:(NSString *)aTitle;
// 내비게이션에 커스텀 타이틀을 넣는다.
- (void)setCustomTitle:(NSString *)aTitle;


#pragma mark -
#pragma mark   (Popup Animation관련)
// 리플팝업 프로토타입입니다. (원래는 CIVector랑 필터 써서 만들어야 하는데..)
- (void)ripplePopUpWithView:(UIView *)aView in:(UIView *)aSuperView;
- (void)ripplePopUpWithView:(UIView *)aView rect:(CGRect)aRect in:(UIView *)aSuperView;

#pragma mark -
#pragma mark   (내비게이션 양쪽버튼 생성 관련)

// 네비게이션의 왼쪽 버튼을 만든다.
// 이 함수로 버튼을 만들었을 경우, 콜백은 (void)backButtonDidPush:(id)sender이 되므로 
// 개별 페이지에서 오버라이드 하여 사용할 것
- (void)makeNavigationLeftBarButton;
- (void)makeNavigationLeftBarButtonWithTitle:(NSString *)btnTitle;
- (void)makeNavigationLeftBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString;
- (void)makeNavigationLeftBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString 
												  title:(NSString *)aTitle;
- (void)makeNavigationLeftBarButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;
- (void)makeNavigationLeftBarButtonWithTitle:(NSString *)btnTitle 
									   style:(UIBarButtonItemStyle)style;

// 네비게이션의 오른쪽 버튼을 만든다.
// 이 함수로 버튼을 만들었을 경우, 콜백은 (void)naviRigthbtnPress:(id)sender이 되므로 
// 개별 페이지에서 오버라이드 하여 사용할 것
- (void)makeNavigationRightBarButtonWithTitle:(NSString *)btnTitle;
- (void)makeNavigationRightBarButtonWithTitle:(NSString *)btnTitle style:(UIBarButtonItemStyle)style;
- (void)makeNavigationRightBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString;
- (void)makeNavigationRightBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString 
												  title:(NSString *)aTitle;
- (void)makeNavigationRightBarButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;
- (void)makeNavigationRightBarButtonWithTitle:(NSString *)btnTitle style:(UIBarButtonItemStyle)style;


#pragma mark   (PushViewController 관련)
// 해당 문자열과 같은 클래스(ViewController)로 push한다.
- (void)pushViewController:(NSString *)aViewContollerName;
- (void)pushViewController:(NSString *)aViewContollerName delegate:(id)aDelegate;
- (void)pushViewController:(NSString *)aViewContollerName animated:(BOOL)animated;
- (void)pushViewController:(NSString *)aViewContollerName delegate:(id)aDelegate animated:(BOOL)animated;
- (void)pushViewController:(NSString *)aViewContollerName animationTransition:(TFUIViewAnimationTransition)transition;	// 뷰 전환시 사용자 정의 에니메이션을 실행한다.
- (void)pushViewController:(NSString *)aViewContollerName delegate:(id)aDelegate animationTransition:(TFUIViewAnimationTransition)transition;	// 뷰 전환시 사용자 정의 에니메이션을 실행한다.

#pragma mark   (PopViewController 관련)
- (void)popViewController;
- (void)popViewControllerWithAnimated:(BOOL)animated;
// 해당 문자열과 같은 클래스(ViewController)로 pop한다.
- (void)popToViewControllerInFlow:(NSString *)targetViewControllerName;
- (void)popToViewControllerInFlow:(NSString *)targetViewControllerName animated:(BOOL)animated;

#pragma mark   (ViewController Switching 관련)
// 해당 문자열과 같은 클래스가 있는 경우 POP 하고, 없는 경우 PUSH 한다.
- (void)popOrPushViewController:(NSString *)targetViewControllerName;
- (void)popOrPushViewController:(NSString *)targetViewControllerName delegate:(id)aDelegate;
- (void)popOrPushViewController:(NSString *)targetViewControllerName animated:(BOOL)animated;
- (void)popOrPushViewController:(NSString *)targetViewControllerName delegate:(id)aDelegate animated:(BOOL)animated;

#pragma mark   (ViewController 스택에서 Search 관련)
// 해당 문자열과 같은 클래스를 Navigation Stack으로부터 검색한다.
- (UIViewController*)searchInNavigationStack:(NSString *)aViewControllerName;
// 입력한 뷰 컨트롤러의 바로전 viewController의 이름을 찾아준다.
- (NSString *)prevViewControllerNameInNavigationStack:(UIViewController *)viewContoller;

#pragma mark   (ViewController 스택에서 Remove 관련)
// 해당 문자열과 같은 클래스를 Navigation Stack으로부터 삭제한다.
- (void)removeInNavigationStack:(NSString *)aViewControllerName;

#pragma mark -
- (void)viewTranslationAnimationDidStop;
@end

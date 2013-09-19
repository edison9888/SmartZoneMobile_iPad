//
//  TFUIViewController.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>

#import "TFUIViewController.h"
#import "TFDefine.h"


@implementation TFUIViewController

@synthesize coveredView;
@synthesize application;
@synthesize navigationLeftButton;
@synthesize navigationRightButton;

#pragma mark -
#pragma mark Property Method

// 내비게이션에 디폴트 타이틀을 넣는다.
- (void)setTitle:(NSString *)aTitle {
	
	if ([self.navigationController.navigationBar isKindOfClass:[TFUINavigationBar class]]) {
	
		UILabel *naviTitleLabel = ((TFUINavigationBar *)self.navigationController.navigationBar).titleLabel;
		naviTitleLabel.hidden = YES;
		
		NSUInteger selectedIndex = self.tabBarController.selectedIndex;
		NSString *strTabBarTitle = [[[self.tabBarController.tabBar.items objectAtIndex:selectedIndex] title] copy];
		
		[super setTitle:aTitle];
		
		[[self.tabBarController.tabBar.items objectAtIndex:selectedIndex] setTitle:strTabBarTitle];
		
		[strTabBarTitle release];
		strTabBarTitle = nil;
		
	} else	{
		[super setTitle:aTitle];
	}
	
}

// 내비게이션에 커스텀 타이틀을 넣는다.
- (void)setCustomTitle:(NSString *)aTitle {
	
	// 일단 내비게이션의 타이틀을 날려버린다.
	[super setTitle:@""];
	
	UILabel *naviTitleLabel = ((TFUINavigationBar *)self.navigationController.navigationBar).titleLabel;
	
	naviTitleLabel.hidden = NO;
	naviTitleLabel.text = aTitle;
	
	naviTitleLabel.textAlignment   = UITextAlignmentCenter;
	naviTitleLabel.textColor	   = [UIColor whiteColor];
	naviTitleLabel.shadowOffset    = CGSizeMake(0, -5);
	naviTitleLabel.backgroundColor = [UIColor clearColor];
	
	// 일단 타이틀이 한줄인지 두줄인지 판단한다.
	if (strlen([naviTitleLabel.text cStringUsingEncoding:0x80000422]) <= 20 ) {	// 한줄
		
		naviTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
		naviTitleLabel.numberOfLines = 1;
		naviTitleLabel.frame = CGRectMake(75, 11, 170, 21);
		
	} else {																// 두줄
		
		naviTitleLabel.textAlignment   = UITextAlignmentLeft;
		naviTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
		naviTitleLabel.numberOfLines = 2;
		naviTitleLabel.frame = CGRectMake(80, 4, 160, 36);
		
	}
	
}

#pragma mark -
#pragma mark Setter Method
- (void)setAnimationTrasition:(NSString *)transition {
	animationTrasition = [transition intValue];
}

#pragma mark -
#pragma mark Util Method

// 내비게이션 바를 숨긴다.
- (void)setNavigationBarHide:(BOOL)hide {
	self.navigationController.navigationBar.hidden = hide;
}

#pragma mark -
#pragma mark   (Popup Animation관련)
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

	if (isRippleAnimating) {
		isRippleAnimating = NO;

		CAKeyframeAnimation *sanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
		sanimation.duration = TFUIViewAnimationDuration * 0.25;
		sanimation.values = [NSArray arrayWithObjects:
							[NSNumber numberWithFloat:1.1],
							[NSNumber numberWithFloat:0.95],
							 [NSNumber numberWithFloat:1.05],
							 [NSNumber numberWithFloat:1.0],
							nil];
		sanimation.keyTimes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0.0],
							   [NSNumber numberWithFloat:0.33],
							   [NSNumber numberWithFloat:0.67],
							  [NSNumber numberWithFloat:1.0],
							  nil];
		
//		CATransition *animation = [CATransition animation];
//		[animation setDelegate:self];
//		[animation setDuration:(TFUIViewAnimationDuration * 0.6)];
//		[animation setType:@"rippleEffect"];
		
		[ripplePopupView.layer addAnimation:sanimation
									 forKey:@"scaleAnimation3QuartersTo4Quarters"];
//		[ripplePopupView.layer addAnimation:animation
//									 forKey:@"rippleEffect"];
		
		
	} else {
		NSLog(@"!!!");
	}
	
}

- (CAAnimation *)scaleAnimationTo0From3Quarters {
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
	animation.delegate = self;
	animation.duration = TFUIViewAnimationDuration * 0.3;
	animation.values = [NSArray arrayWithObjects:
						[NSNumber numberWithFloat:0.1],
						[NSNumber numberWithFloat:1.1],
						nil];
	animation.keyTimes = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:0.0],
						  [NSNumber numberWithFloat:1.0],
						  nil];

	return animation;

}

- (void)ripplePopUpWithView:(UIView *)aView in:(UIView *)aSuperView {
	
	ripplePopupView = aView;
	aView.frame = CGRectMake(0,0,aSuperView.frame.size.width, aSuperView.frame.size.height);
	[aSuperView addSubview:aView];
	
	isRippleAnimating = YES;
	[ripplePopupView.layer addAnimation:[self scaleAnimationTo0From3Quarters]
								 forKey:@"scaleAnimationTo0From3Quarters"];
	
}

- (void)ripplePopUpWithView:(UIView *)aView rect:(CGRect)aRect in:(UIView *)aSuperView {
	
	ripplePopupView = aView;
	aView.frame = aRect;
	[aSuperView addSubview:aView];
	
	isRippleAnimating = YES;
	[ripplePopupView.layer addAnimation:[self scaleAnimationTo0From3Quarters]
					   forKey:@"scaleAnimationTo0From3Quarters"];
	
}

#pragma mark -
#pragma mark   (내비게이션 양쪽버튼 생성 관련)


- (void)makeNavigationLeftBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString {
	[self makeNavigationLeftBarButtonWithImageNamePrefix:pString
										   selectedString:sString 
										 unselectedString:uString
										  extensionString:eString 
													title:@""];
}

- (void)makeNavigationLeftBarButtonWithImageNamePrefix:(NSString *)pString 
										selectedString:(NSString *)sString
									  unselectedString:(NSString *)uString
									   extensionString:(NSString *)eString 
												 title:(NSString *)aTitle{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *strImageNormal   = [NSString stringWithFormat:@"%@%@.%@", pString, uString, eString];
	NSString *strImageSelected = [NSString stringWithFormat:@"%@%@.%@", pString, sString, eString];
	
	NSString *imagePath = nil;
	
	imagePath = [[NSBundle mainBundle] pathForResource:strImageNormal ofType:nil];
	UIImage *imageNormal =[UIImage imageWithContentsOfFile:imagePath];
	
	imagePath = [[NSBundle mainBundle] pathForResource:strImageSelected ofType:nil];
	UIImage *imageSelected =[UIImage imageWithContentsOfFile:imagePath];
	
	if (isRetinaDrawing) {
		button.frame = CGRectMake(0, 0, imageNormal.size.width / 2, imageNormal.size.height / 2);
	} else {
		button.frame = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
	}

	[button setTitle:aTitle forState:UIControlStateNormal];
	[button setBackgroundImage:imageNormal   forState:UIControlStateNormal];
	[button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
	[button setBackgroundImage:imageSelected forState:UIControlStateSelected];
	
	[button addTarget:self action:@selector(backButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationLeftButton = button;
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release];
	
}


// 네비게이션바에서 왼쪽 버튼을 만든다. 
// (테마 적용시 디폴트 backBarButtonItem이 아닌 leftBarButtonItem을 사용해야 한다.)
- (void)makeNavigationLeftBarButton {
	
	// 기본 버튼을 다시 만들어 준다.
	[self makeNavigationLeftBarButtonWithImageNamePrefix:@"btn_top_back" 
										  selectedString:@"press" 
										unselectedString:@"" 
										 extensionString:@"png"];
	
}

// 네비게이션바에서 왼쪽 버튼을 만든다. 
// (테마 적용시 디폴트 backBarButtonItem이 아닌 leftBarButtonItem을 사용해야 한다.)
- (void)makeNavigationLeftBarButtonWithTitle:(NSString *)btnTitle {

	UIImage *imageNormal	= [UIImage imageNamed:@"btn_back.png"];
	UIImage *imageHilighted = [UIImage imageNamed:@"btn_back_press.png"];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
	button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	[button setTitle:btnTitle forState:UIControlStateNormal];
	[button setBackgroundImage:imageNormal	  forState:UIControlStateNormal];
	[button setBackgroundImage:imageHilighted forState:UIControlStateHighlighted];
	[button setBackgroundImage:imageHilighted forState:UIControlStateSelected];
	
	[button addTarget:self action:@selector(backButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	backButton = nil;
	
}

- (void)makeNavigationLeftBarButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem {
	
	UIBarButtonItem	*barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem 
																			   target:self 
																			   action:@selector(backButtonDidPush:)];
	self.navigationLeftButton = (UIButton *)barButton;
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release];
	
}
- (void)makeNavigationLeftBarButtonWithTitle:(NSString *)btnTitle style:(UIBarButtonItemStyle)style {
	
	UIBarButtonItem	*barButton = [[UIBarButtonItem alloc] initWithTitle:btnTitle 
																  style:style 
																 target:self 
																 action:@selector(backButtonDidPush:)];
	
	self.navigationLeftButton = (UIButton *)barButton;
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release];
	
}

- (void)makeNavigationRightBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString 
												  title:(NSString *)aTitle {
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *strImageNormal   = [NSString stringWithFormat:@"%@%@.%@", pString, uString, eString];
	NSString *strImageSelected = [NSString stringWithFormat:@"%@%@.%@", pString, sString, eString];
	
	NSString *imagePath = nil;
	
	imagePath = [[NSBundle mainBundle] pathForResource:strImageNormal ofType:nil];
	UIImage *imageNormal =[UIImage imageWithContentsOfFile:imagePath];
	
	imagePath = [[NSBundle mainBundle] pathForResource:strImageSelected ofType:nil];
	UIImage *imageSelected =[UIImage imageWithContentsOfFile:imagePath];
	
	if (isRetinaDrawing) {
		button.frame = CGRectMake(0, 0, imageNormal.size.width / 2, imageNormal.size.height / 2);
	} else {
		button.frame = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
	}

	[button setTitle:aTitle forState:UIControlStateNormal];
	[button setBackgroundImage:imageNormal   forState:UIControlStateNormal];
	[button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
	[button setBackgroundImage:imageSelected forState:UIControlStateSelected];
	
	[button addTarget:self action:@selector(naviRigthbtnPress:) forControlEvents:UIControlEventTouchUpInside];
	
		self.navigationRightButton = button;
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
	
}

- (void)makeNavigationRightBarButtonWithImageNamePrefix:(NSString *)pString 
										 selectedString:(NSString *)sString
									   unselectedString:(NSString *)uString
										extensionString:(NSString *)eString {
	[self makeNavigationRightBarButtonWithImageNamePrefix:pString
										   selectedString:sString 
										 unselectedString:uString
										  extensionString:eString 
													title:@""];
}

- (void)makeNavigationRightBarButtonWithImageName:(NSString *)anImageName {
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *image = [UIImage imageNamed:@"btn_catagory_thum_on.png"];
	
	NSLog(@"image.size) := %@", NSStringFromCGSize(image.size));
	
//	[button setTitle:btnTitle forState:UIControlStateNormal];
	button.frame = CGRectMake(0, 0, 48, 30);
	
	[button setImage:[UIImage imageNamed:anImageName] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"btn_catagory_thum_on.png"] forState:UIControlStateHighlighted];
	
	
	[button addTarget:self action:@selector(naviRigthbtnPress:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	
//	UIBarButtonItem	*barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:anImageName] 
//																  style:UIBarButtonItemStylePlain 
//																 target:self 
//																 action:@selector(naviRigthbtnPress:)];
	
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
	
}
- (void)makeNavigationRightBarButtonWithTitle:(NSString *)btnTitle {
	[self makeNavigationRightBarButtonWithTitle:btnTitle style:UIBarButtonItemStylePlain];
}

- (void)makeNavigationRightBarButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem {
	
	UIBarButtonItem	*barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem 
																			   target:self 
																			   action:@selector(naviRigthbtnPress:)];
	
	self.navigationRightButton = (UIButton *)barButton;
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
}

- (void)makeNavigationRightBarButtonWithTitle:(NSString *)btnTitle style:(UIBarButtonItemStyle)style {
	
	UIBarButtonItem	*barButton = [[UIBarButtonItem alloc] initWithTitle:btnTitle 
																  style:style 
																 target:self 
																 action:@selector(naviRigthbtnPress:)];
	
	self.navigationRightButton = (UIButton *)barButton;
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
	
}


#pragma mark   (PushViewController 관련)
- (void)pushViewController:(NSString *)aViewContollerName {
	[self pushViewController:aViewContollerName delegate:nil];
}

- (void)pushViewController:(NSString *)aViewContollerName delegate:(id)aDelegate {
	[self pushViewController:aViewContollerName delegate:aDelegate animated:YES];
}

- (void)pushViewController:(NSString *)aViewContollerName animated:(BOOL)animated {
	
	[self pushViewController:aViewContollerName delegate:nil animated:animated];
	
}


- (void)pushViewController:(NSString *)aViewContollerName 
				  delegate:(id)aDelegate 
				  animated:(BOOL)animated {
	
	Class targetClass = NSClassFromString(aViewContollerName);
	
#ifdef TEST_APPLICATION
	if (!targetClass) {
		NSLog(@"설정하신 targetViewControllerName은 없는 클래스이름입니다.");
		return;
	}
#endif
	
	id viewController = [[targetClass alloc] initWithNibName:aViewContollerName bundle:nil]; 
	
	if ([viewController respondsToSelector:@selector(setDelegate:)]) {
		[viewController performSelector:@selector(setDelegate:) withObject:aDelegate];
	}
	
	[self.navigationController pushViewController:(UIViewController *)viewController animated:animated];
	[viewController release];
	viewController = nil;
}

- (void)pushViewController:(NSString *)aViewContollerName 
	   animationTransition:(TFUIViewAnimationTransition)transition {
	
	[self pushViewController:aViewContollerName delegate:nil animationTransition:transition];
	
}

- (void)pushViewController:(NSString *)aViewContollerName 
				  delegate:(id)aDelegate 
	   animationTransition:(TFUIViewAnimationTransition)transition {	// 뷰 전환시 사용자 정의 에니메이션을 실행한다.
	
	Class targetClass = NSClassFromString(aViewContollerName);
	
#ifdef TEST_APPLICATION
	if (!targetClass) {
		NSLog(@"설정하신 targetViewControllerName은 없는 클래스이름입니다.");
		return;
	}
#endif
	
	id viewController = [[targetClass alloc] initWithNibName:aViewContollerName bundle:nil]; 
	
	// delegate 설정
	if ([viewController respondsToSelector:@selector(setDelegate:)]) {
		[viewController performSelector:@selector(setDelegate:) withObject:aDelegate];
	}
	
	// 덮이게 되는 대상 컨트롤러
	UIViewController *coveredViewController = self.navigationController.topViewController;
	
	[self.navigationController pushViewController:(UIViewController *)viewController animated:NO];
	
	if ([viewController isKindOfClass:[TFUIViewController class]]) {
		[viewController performSelector:@selector(setAnimationTrasition:) 
							 withObject:[NSString stringWithFormat:@"%d", transition]];
		[viewController performSelector:@selector(setCoveredView:) 
							 withObject:coveredViewController.view];
	}
	
	[viewController release];
	viewController = nil;
	
}

#pragma mark   (PopViewController 관련)

- (void)popViewController {
	[self popViewControllerWithAnimated:YES];
}

- (void)popViewControllerWithAnimated:(BOOL)animated {
	[self.navigationController popViewControllerAnimated:animated];
}

// 해당 문자열과 같은 클래스(ViewController)로 pop한다.
- (void)popToViewControllerInFlow:(NSString *)targetViewControllerName {
	[self popToViewControllerInFlow:targetViewControllerName animated:YES];
}

- (void)popToViewControllerInFlow:(NSString *)targetViewControllerName 
						 animated:(BOOL)animated {
	
	Class targetClass = NSClassFromString(targetViewControllerName);
	
#ifdef TEST_APPLICATION
	if (!targetClass) {
		NSLog(@"설정하신 targetViewControllerName은 없는 클래스이름입니다.");
		return;
	}
#endif
	
	id targetViewController = nil;
	
	NSArray *viewControllers = [self.navigationController viewControllers];
	
	NSUInteger i, count = [viewControllers count];
	for (i = 0; i < count; i++) {
		NSObject * obj = [viewControllers objectAtIndex:i];
		
		if ([obj isKindOfClass:targetClass]) {
			targetViewController = obj;
			break;
		}
	}
	
	[self.navigationController popToViewController:(UIViewController *)targetViewController animated:animated];
}

#pragma mark   (ViewController Switching 관련)
// 해당 문자열과 같은 클래스가 있는 경우 POP 하고, 없는 경우 PUSH 한다.
- (void)popOrPushViewController:(NSString *)targetViewControllerName {
	[self popOrPushViewController:targetViewControllerName delegate:nil animated:YES];
}

- (void)popOrPushViewController:(NSString *)targetViewControllerName 
					   delegate:(id)aDelegate {
	[self popOrPushViewController:targetViewControllerName delegate:aDelegate animated:YES];
}

// 해당 문자열과 같은 클래스가 있는 경우 POP 하고, 없는 경우 PUSH 한다.
- (void)popOrPushViewController:(NSString *)targetViewControllerName 
					   animated:(BOOL)animated {
	[self popOrPushViewController:targetViewControllerName delegate:nil animated:animated];
}

// 해당 문자열과 같은 클래스가 있는 경우 POP 하고, 없는 경우 PUSH 한다.
- (void)popOrPushViewController:(NSString *)targetViewControllerName 
					   delegate:(id)aDelegate 
					   animated:(BOOL)animated {

	Class targetClass = NSClassFromString(targetViewControllerName);
	
	id targetViewController = nil;
	
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]] ;
	
	NSUInteger i, count = [viewControllers count];
	for (i = 0; i < count; i++) {
		NSObject * obj = [viewControllers objectAtIndex:i];
		
		if ([obj isKindOfClass:targetClass]) {
			targetViewController = obj;
			break;
		}
	}
	
	// 네비게이션 스택에 해당 클래스가 없는 경우
	if (targetViewController == nil) {
		
		id viewController = [[targetClass alloc] initWithNibName:targetViewControllerName bundle:nil]; 
		
		// delegate 설정
		if ([viewController respondsToSelector:@selector(setDelegate:)]) {
			[viewController performSelector:@selector(setDelegate:) withObject:aDelegate];
		}
		
		[self.navigationController pushViewController:(UIViewController *)viewController animated:animated];
		[viewController release];
		viewController = nil;
		
	} else {	// 네비게이션 스택에 해당 클래스가 있는 경우
		
		// delegate 설정
		if ([targetViewController respondsToSelector:@selector(setDelegate:)]) {
			[targetViewController performSelector:@selector(setDelegate:) withObject:aDelegate];
		}
		
		// 네이게이션 스택의 최상위로 옮긴다.
		[targetViewController retain];
		[viewControllers removeObject:targetViewController];
		[viewControllers addObject:targetViewController];
		[targetViewController release];
		
		[self.navigationController  setViewControllers:viewControllers];
		
		[self.navigationController  popToViewController:(UIViewController *)targetViewController animated:animated];
		
	}
	
	[viewControllers release];
	viewControllers = nil;
}

#pragma mark   (ViewController 스택에서 Search 관련)
// 해당 문자열과 같은 클래스를 Navigation Stack으로부터 검색한다.
- (UIViewController *)searchInNavigationStack:(NSString *)aViewControllerName {
	
	UIViewController* returnController = nil;
	
	for (UIViewController *controller in self.navigationController.viewControllers) {
		
		if ([NSStringFromClass([controller class]) isEqualToString:aViewControllerName]) {
			returnController = controller;
			break;
		}
		
	}
	
	return returnController;
}
// 입력한 뷰 컨트롤러의 바로전 viewController의 이름을 찾아준다.
- (NSString *)prevViewControllerNameInNavigationStack:(UIViewController *)viewContoller {
	
	UIViewController *prevViewController = nil;
	
	for (UIViewController *controller in viewContoller.navigationController.viewControllers) {
		
		if ([controller isEqual:viewContoller]) {
			break;
		}
		prevViewController = controller;
	}
	
	if (prevViewController == nil) {
		return @"";
	} else {
		return NSStringFromClass([prevViewController class]);
	}
	
}

#pragma mark   (ViewController 스택에서 Remove 관련)
// 해당 문자열과 같은 클래스를 Navigation Stack으로부터 삭제한다.
- (void)removeInNavigationStack:(NSString *)aViewControllerName {
	
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//	NSLog(@"%@", viewControllers);
	for (UIViewController *controller in viewControllers) {
		
		if ([NSStringFromClass([controller class]) isEqualToString:aViewControllerName]) {
			[viewControllers removeObject:controller];
			break;
		}
		
	}
	
	self.navigationController.viewControllers = viewControllers;
	[viewControllers release];
	viewControllers = nil;
}

#pragma mark -
#pragma mark CallBack Method
- (void)naviRigthbtnPress:(id)sender {
	NSLog(@"개별 페이지에서 오버라이드 하여 사용해 주세요.");
}

- (void)backButtonDidPush:(id)sender {
	NSLog(@"backButtonDidPush : 개별 페이지에서 오버라이드 하여 사용해 주세요.");
	[self popViewController];
}

#pragma mark -
#pragma mark View Translation Process

- (void)viewTranslationAnimationDidStop {
	[self.coveredView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = NO;
	
	if ([self.navigationController.navigationBar isKindOfClass:[TFUINavigationBar class]]) {
		((TFUINavigationBar *)self.navigationController.navigationBar).isHomeLogo = NO;
	}
	

//	if (self.navigationItem.backBarButtonItem == nil &&
//		self.navigationItem.leftBarButtonItem == nil) {
//		
//		[self makeNavigationLeftBarButtonWithImageNamePrefix:@"btn_top_back" 
//											  selectedString:@"press" 
//											unselectedString:@"" 
//											 extensionString:@"png"];
//		
//		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"이전" style:UIBarButtonItemStyleBordered target:nil action:nil];
//		
//		self.navigationItem.backBarButtonItem = backButton;
//		[backButton release];
//		backButton = nil;
//		
//	}
	
	// !주의 appDelegate와 커플링이 강한 구간 프로젝트와 맞지 않는 경우 삭제 할 것 - 시작
	
	// window.rootViewController가 바뀌는 경우 (TabBarContorller가 바뀌는 경우)
//	if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
	
//		// 플립 에니메이션을 실행한다.
//		switch ([GET_APP_DELEGATE() flipAnimationDestination]) {
//			case -1: {
//				animationTrasition = TFUIViewAnimationTransitionFlipFromLeft;
//			}	break;
//			case 1: {
//				animationTrasition = TFUIViewAnimationTransitionFlipFromRight;
//			}	break;
//			default:
//				break;
//		}
//		
//		[GET_APP_DELEGATE() setFlipAnimationDestination:0];

//	}
	
	// !주의 appDelegate와 커플링이 강한 구간 프로젝트와 맞지 않는 경우 삭제 할 것 - 끝
	
	
	// ViewController간 전환시 에니메이션
	switch (animationTrasition) {
		case TFUIViewAnimationTransitionNone: {
			
		}	break;
		case TFUIViewAnimationTransitionRightToLeft: {
			
			for (UIView *subView in self.view.subviews) {
				subView.frame = CGRectMake(subView.frame.origin.x + self.view.frame.size.width, 
										   subView.frame.origin.y, 
										   subView.frame.size.width, 
										   subView.frame.size.height);
			}
			
			[self.view addSubview:self.coveredView];
			
			// 애니메이션 시작
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(viewTranslationAnimationDidStop)];
			[UIView setAnimationDuration:TFUIViewAnimationDuration];
			
			for (UIView *subView in self.view.subviews) {
				subView.frame = CGRectMake(subView.frame.origin.x - self.view.frame.size.width, 
										   subView.frame.origin.y, 
										   subView.frame.size.width, 
										   subView.frame.size.height);
			}
			
			[UIView commitAnimations];
			// 애니메이션 끝
			
		}	break;
			
		case TFUIViewAnimationTransitionLeftToRight: {
			
			for (UIView *subView in self.view.subviews) {
				subView.frame = CGRectMake(subView.frame.origin.x - self.view.frame.size.width, 
										   subView.frame.origin.y, 
										   subView.frame.size.width, 
										   subView.frame.size.height);
			}
			
			[self.view addSubview:self.coveredView];
			
			// 애니메이션 시작
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(viewTranslationAnimationDidStop)];
			[UIView setAnimationDuration:TFUIViewAnimationDuration];
			
			for (UIView *subView in self.view.subviews) {
				subView.frame = CGRectMake(subView.frame.origin.x + self.view.frame.size.width, 
										   subView.frame.origin.y, 
										   subView.frame.size.width, 
										   subView.frame.size.height);
			}
			
			[UIView commitAnimations];
			// 애니메이션 끝
			
		}	break;
			
		case TFUIViewAnimationTransitionFlipFromLeft: {
			
			CATransform3D originTransform1;
			originTransform1.m11 = 1;	originTransform1.m12 = 0;	originTransform1.m13 = 0;	originTransform1.m14 = 0.001;
			originTransform1.m21 = 0;	originTransform1.m22 = 1;	originTransform1.m23 = 0;	originTransform1.m24 = 0;
			originTransform1.m31 = 0;	originTransform1.m32 = 0;	originTransform1.m33 = 1;	originTransform1.m34 = 0;
			originTransform1.m41 = 0;	originTransform1.m42 = 0;	originTransform1.m43 = 0;	originTransform1.m44 = 1;
			
			CATransform3D originTransform2;
			originTransform2.m11 = 1;	originTransform2.m12 = 0;	originTransform2.m13 = 0;	originTransform2.m14 = -0.001;
			originTransform2.m21 = 0;	originTransform2.m22 = 1;	originTransform2.m23 = 0;	originTransform2.m24 = 0;
			originTransform2.m31 = 0;	originTransform2.m32 = 0;	originTransform2.m33 = 1;	originTransform2.m34 = 0;
			originTransform2.m41 = 0;	originTransform2.m42 = 0;	originTransform2.m43 = 0;	originTransform2.m44 = 1;
			
			CATransform3D cat = CATransform3DConcat(originTransform1, CATransform3DMakeRotation(DegreesToRadians(90.0), 0, 0.5, 0));
			cat = CATransform3DConcat(cat, CATransform3DMakeScale(1, 0.9, 1));
			CATransform3D cat2 = CATransform3DConcat(originTransform2, CATransform3DMakeRotation(DegreesToRadians(90.0), 0, 0.5, 0));
			cat2 = CATransform3DConcat(cat2, CATransform3DMakeScale(1, 0.9, 1));
			
			CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
			
			animation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:CATransform3DIdentity],
								[NSValue valueWithCATransform3D:cat2],
								[NSValue valueWithCATransform3D:cat],
								[NSValue valueWithCATransform3D:CATransform3DIdentity],
								nil];
			animation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0.0],
								  [NSNumber numberWithFloat:0.45],
								  [NSNumber numberWithFloat:0.55],
								  [NSNumber numberWithFloat:1.0],
								  nil];
			
			CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
			animationGroup.animations = [NSArray arrayWithObjects: animation, nil];
			animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			animationGroup.duration = TFUIViewAnimationDuration;
			animationGroup.fillMode = kCAFillModeForwards;
			animationGroup.removedOnCompletion = NO;
			
			[self.navigationController.view.layer addAnimation:animationGroup forKey:@"animateLayer"];
			
		}	break;
			
		case TFUIViewAnimationTransitionFlipFromRight: {
			
			CATransform3D originTransform1;
			originTransform1.m11 = 1;	originTransform1.m12 = 0;	originTransform1.m13 = 0;	originTransform1.m14 = 0.001;
			originTransform1.m21 = 0;	originTransform1.m22 = 1;	originTransform1.m23 = 0;	originTransform1.m24 = 0;
			originTransform1.m31 = 0;	originTransform1.m32 = 0;	originTransform1.m33 = 1;	originTransform1.m34 = 0;
			originTransform1.m41 = 0;	originTransform1.m42 = 0;	originTransform1.m43 = 0;	originTransform1.m44 = 1;
			
			CATransform3D originTransform2;
			originTransform2.m11 = 1;	originTransform2.m12 = 0;	originTransform2.m13 = 0;	originTransform2.m14 = -0.001;
			originTransform2.m21 = 0;	originTransform2.m22 = 1;	originTransform2.m23 = 0;	originTransform2.m24 = 0;
			originTransform2.m31 = 0;	originTransform2.m32 = 0;	originTransform2.m33 = 1;	originTransform2.m34 = 0;
			originTransform2.m41 = 0;	originTransform2.m42 = 0;	originTransform2.m43 = 0;	originTransform2.m44 = 1;
			
			CATransform3D cat = CATransform3DConcat(originTransform1, CATransform3DMakeRotation(DegreesToRadians(90.0), 0, 0.5, 0));
			cat = CATransform3DConcat(cat, CATransform3DMakeScale(1, 0.9, 1));
			CATransform3D cat2 = CATransform3DConcat(originTransform2, CATransform3DMakeRotation(DegreesToRadians(90.0), 0, 0.5, 0));
			cat2 = CATransform3DConcat(cat2, CATransform3DMakeScale(1, 0.9, 1));
			
			CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
			
			animation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:CATransform3DIdentity],
								[NSValue valueWithCATransform3D:cat],
								[NSValue valueWithCATransform3D:cat2],
								[NSValue valueWithCATransform3D:CATransform3DIdentity],
								nil];
			animation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0.0],
								  [NSNumber numberWithFloat:0.45],
								  [NSNumber numberWithFloat:0.55],
								  [NSNumber numberWithFloat:1.0],
								  nil];
		
			CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
			animationGroup.animations = [NSArray arrayWithObjects: animation, nil];
			animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			animationGroup.duration = TFUIViewAnimationDuration;
			animationGroup.fillMode = kCAFillModeForwards;
			animationGroup.removedOnCompletion = NO;
			
			[self.navigationController.view.layer addAnimation:animationGroup forKey:@"animateLayer"];
			
		}	break;

		default:
			break;
	}

	animationTrasition = TFUIViewAnimationTransitionNone;
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];

}


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
	
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    
//	// 왼쪽 버튼을 넣어 준다.
//	[self makeNavigationLeftBarButton];
	
	// 기본적으로 내비게이션 바는 나오게 한다.
	[self setNavigationBarHide:NO];
	
	application = GET_APP_DELEGATE();

	NSLog(@"[%@] DidLoaded", self);
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


- (void)dealloc {
	[navigationRightButton release];
	[navigationLeftButton release];
    [super dealloc];
}


@end

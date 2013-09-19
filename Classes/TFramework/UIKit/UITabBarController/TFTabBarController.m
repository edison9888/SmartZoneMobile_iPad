    //
//  TFTabBarController.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 두베. All rights reserved.
//

#import "TFTabBarController.h"
//#import "TFTestAppDelegate.h"


@implementation TFTabBarController

@synthesize selectingIndex;

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case 9999: {
			if (alertView.cancelButtonIndex == buttonIndex) {
				exit(0);
			} else {
				[(TFUITabBar *)self.tabBar rollBakcSelectedIndex];
			}
		}	break;
		default:
			break;
	} 
}

- (void)tabBarItemSelected:(NSUInteger)index {
	
	selectingIndex = index;
/*	
	// !주의 커플링이 강한 구간 (종료버튼)
	if ([((TFTestAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController1 isEqual:self] &&
		selectingIndex == 4) {
		
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"김총무 종료" 
															message:@"김총무를 종료하시겠습니까?" 
														   delegate:self 
												  cancelButtonTitle:@"확인" 
												   otherButtonTitles:@"취소", nil] autorelease];
		alertView.tag = 9999;
		[alertView show];
		return;
	}
	// !주의 커플링 강한 구간
*/	
	if ([self.delegate tabBarController:self 
			 shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
		
		self.selectedIndex = index;
		self.selectedViewController = [self.viewControllers objectAtIndex:index];
	} else {
		[(TFUITabBar *)self.tabBar rollBakcSelectedIndex];
	}


}

- (void)makeTabBarHidden:(BOOL)hide {
	if ([self.view.subviews count] < 2)
		return;
	
	UIView *contentView = nil;
	
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
		contentView = [self.view.subviews objectAtIndex:1];
	else
		contentView = [self.view.subviews objectAtIndex:0];
	
	if (hide) {
		contentView.frame = self.view.bounds;		
	} else {
		contentView.frame = CGRectMake(self.view.bounds.origin.x,
									   self.view.bounds.origin.y,
									   self.view.bounds.size.width,
									   self.view.bounds.size.height - self.tabBar.frame.size.height);
	}
	
	self.tabBar.hidden = hide;
}

- (void)dealloc {
    [super dealloc];
}


@end

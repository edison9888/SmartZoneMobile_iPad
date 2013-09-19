//
//  TFTabBarController.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUITabBar.h"

@interface TFTabBarController : UITabBarController <TFUITabBarItemsDelegate> {
	int selectingIndex;
}

@property int selectingIndex;

- (void)makeTabBarHidden:(BOOL)hide;

@end

//
//  TFUITabBar.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFDefine.h"
#import "TFUITabBarItemsView.h"


@interface TFUITabBar : UITabBar <TFUITabBarItemsDelegate> {
	id <TFUITabBarItemsDelegate>tfTabBarItemsdelegate;
	TFUITabBarItemsView *buttonsView;
}

@property (nonatomic, assign) id <TFUITabBarItemsDelegate>tfTabBarItemsdelegate;
@property (nonatomic, retain) TFUITabBarItemsView *buttonsView;

- (void)setTabbarItemsImageSpecialType1;
- (void)setTabbarItemsImageSpecialType2;
- (void)setTabbarItemsImageSpecialType:(int)type;
- (void)setTabbarItemsImageWithPrefix:(NSString *)prefix 
					   selectedString:(NSString *)sString 
					 unselectedString:(NSString *)uString
					  extensionString:(NSString *)eString
					  numberOfButtons:(int)numberOfButtons;
- (void)setTabbarItemsImage:(NSArray *)imageInfos;
- (void)rollBakcSelectedIndex;
- (void)setBadgeValue:(NSString *)badgeValue index:(NSUInteger)index;


@end

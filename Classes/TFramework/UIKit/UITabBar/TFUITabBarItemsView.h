//
//  TFUITabBarItemsView.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFUITabBarItemsDelegate

@required
- (void)tabBarItemSelected:(NSUInteger)index;

@end


@interface TFUITabBarItemsView : UIView {
	
	// UI
	UIButton *button1;
	UIButton *button2;
	UIButton *button3;
	UIButton *button4;
	UIButton *button5;
	
	UIView *badge01;
	UIView *badge02;
	UIView *badge03;
	UIView *badge04;
	
	UILabel *badgeLabel01;
	UILabel *badgeLabel02;
	UILabel *badgeLabel03;
	UILabel *badgeLabel04;
	
	// UI Handling
	
	UIButton *selectedButton;
	
	NSUInteger prvSelectedIndex;
	NSUInteger selectedIndex;
	
	id <TFUITabBarItemsDelegate>delegate;
	
	NSArray *imageInfos;
	
}

@property (nonatomic, assign) id <TFUITabBarItemsDelegate>delegate;

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;

@property (nonatomic, retain) IBOutlet UIView *badge01;
@property (nonatomic, retain) IBOutlet UIView *badge02;
@property (nonatomic, retain) IBOutlet UIView *badge03;
@property (nonatomic, retain) IBOutlet UIView *badge04;

@property (nonatomic, retain) IBOutlet UILabel *badgeLabel01;
@property (nonatomic, retain) IBOutlet UILabel *badgeLabel02;
@property (nonatomic, retain) IBOutlet UILabel *badgeLabel03;
@property (nonatomic, retain) IBOutlet UILabel *badgeLabel04;

@property (nonatomic, copy) NSArray *imageInfos;

@property NSUInteger selectedIndex;

- (IBAction)buttonDidPush:(id)sender;

- (void)rollBakcSelectedIndex;
- (void)setBadgeValue:(NSString *)badgeValue index:(NSUInteger)index;
- (void)forceButtonDidPush:(int)index;

@end

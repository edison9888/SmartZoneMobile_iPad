//
//  TFUITabBarItemsView.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 두베. All rights reserved.
//

#import "TFUITabBarItemsView.h"
#import "NSDictionary+NotNilReturn.h"

@implementation TFUITabBarItemsView

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

@synthesize badge01;
@synthesize badge02;
@synthesize badge03;
@synthesize badge04;

@synthesize badgeLabel01;
@synthesize badgeLabel02;
@synthesize badgeLabel03;
@synthesize badgeLabel04;

@synthesize delegate;

@synthesize imageInfos;

#pragma mark -
#pragma mark Public Method

- (UIButton *)getButtonWithIndex:(int)index {
	UIButton *retButton = nil;
	
	switch (index) {
		case 0: {
			retButton = self.button1;
		}	break;
		case 1:	{
			retButton = self.button2;
		}	break;
		case 2:	{
			retButton = self.button3;
		}	break;
		case 3:	{
			retButton = self.button4;
		}	break;
		case 4:	{
			retButton = self.button5;
		}	break;
		default:
			break;
	}
	
	return retButton;
}

- (void)rollBakcSelectedIndex {

	[selectedButton setImage:[UIImage imageNamed:[[self.imageInfos objectAtIndex:selectedIndex] objectForKey:@"normal"]] 
					forState:UIControlStateNormal];
	
	selectedIndex = prvSelectedIndex;
	selectedButton.selected = NO;
	
	selectedButton = [self getButtonWithIndex:selectedIndex];
	
	selectedButton.selected = YES;
	[selectedButton setImage:[UIImage imageNamed:[[self.imageInfos objectAtIndex:selectedIndex] 
												  objectForKey:@"selected"]] forState:UIControlStateNormal];

}

- (void)setBadgeValue:(NSString *)badgeValue index:(NSUInteger)index {

	UIView *badge = nil;
	CGRect badgeFrame = CGRectMake(35, 10, 33, 34);
	
	switch (index) {
		case 0:
			badge = self.badge01; 
			badgeFrame = badgeFrame;
			badgeLabel01.text = badgeValue;
			break;
		case 1:
			badge = self.badge02;
			badgeFrame.origin.x += 64 * 1;
			badgeLabel02.text = badgeValue;
			break;
		case 2:
			badge = self.badge03;
			badgeFrame.origin.x += 64 * 2;
			badgeLabel03.text = badgeValue;
			break;
		case 3:
			badge = self.badge04;
			badgeFrame.origin.x += 64 * 3;
			badgeLabel04.text = badgeValue;
			break;
//		case 4:
//			badge = self.badge05;
//			badgeFrame.origin.x += 64 * 4;
//			badgeLabel04.text = badgeValue;
//			break;
		default:
			break;
	}
	
	if (badgeValue == nil || [badgeValue isEqualToString:@""]) {
		[badge removeFromSuperview];
		return;
	}
	
	if (![[badge superview] isEqual:self]) {
		badge.frame = badgeFrame;
		[self addSubview:badge];
	}
	
}


- (void)forceButtonDidPush:(int)index {
	
	UIButton *targetButton = [self getButtonWithIndex:index];
	[self buttonDidPush:targetButton];
	
}

#pragma mark -
#pragma mark Property Method

- (void)setImageInfos:(NSArray *)arrImageInfo {
	
	[imageInfos release];
	imageInfos = nil;

	UIButton *currentButton = nil;
	CGFloat currentButtonXposiotn = 0.0;
	
	for (int i = 0; i < [arrImageInfo count]; i++) {
		
		currentButton = [self getButtonWithIndex:i];
		
		[currentButton setImage:[UIImage imageNamed:[[arrImageInfo objectAtIndex:i] objectForKey:@"normal"]] 
					   forState:UIControlStateNormal];
		[currentButton setImage:[UIImage imageNamed:[[arrImageInfo objectAtIndex:i] objectForKey:@"highlighted"]]
					   forState:UIControlStateHighlighted];
		[currentButton setImage:[UIImage imageNamed:[[arrImageInfo objectAtIndex:i] objectForKey:@"disabled"]] 
					   forState:UIControlStateDisabled];
		[currentButton setImage:[UIImage imageNamed:[[arrImageInfo objectAtIndex:i] objectForKey:@"selected"]]
					   forState:UIControlStateSelected];

		if (![[[arrImageInfo objectAtIndex:i] notNilObjectForKey:@"width"] isEqualToString:@""]) {
			currentButton.frame = CGRectMake(currentButtonXposiotn, 
											 currentButton.frame.origin.y, 
											 [[[arrImageInfo objectAtIndex:i] notNilObjectForKey:@"width"] floatValue],
											 currentButton.frame.size.height);
			currentButtonXposiotn += [[[arrImageInfo objectAtIndex:i] notNilObjectForKey:@"width"] floatValue];
		}
		
	}
	
	imageInfos = [arrImageInfo retain];
	
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	
	selectedButton.selected = NO;
	
	selectedButton = [self getButtonWithIndex:aSelectedIndex];
	
	prvSelectedIndex = selectedIndex;
	
	selectedButton.selected = YES;
	selectedIndex = aSelectedIndex;
	
}

- (NSUInteger)selectedIndex {
	return selectedIndex;
}

#pragma mark -
#pragma mark Action Method

- (IBAction)buttonDidPush:(id)sender {
	
	[selectedButton setImage:[UIImage imageNamed:[[self.imageInfos objectAtIndex:selectedIndex] objectForKey:@"normal"]] 
					forState:UIControlStateNormal];
	
	selectedButton.selected = NO;
	selectedButton = (UIButton *)sender;
	
	if (selectedButton.frame.size.width == 80) {
		
	} else {
		selectedButton = [self getButtonWithIndex:[sender tag]];
	}
	
	prvSelectedIndex = selectedIndex;
	
	selectedButton.selected = YES;
	
	selectedIndex = [sender tag];
	
	[selectedButton setImage:[UIImage imageNamed:[[self.imageInfos objectAtIndex:selectedIndex] 
												  objectForKey:@"selected"]] forState:UIControlStateNormal];
	
	[delegate tabBarItemSelected:selectedIndex];
	
}

#pragma mark -
#pragma mark Xcode Generated

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[button1 release];
	[button2 release];
	[button3 release];
	[button4 release];
	[button5 release];
	
	[badge01 release];
	[badge02 release];
	[badge03 release];
	[badge04 release];
	
	[badgeLabel01 release];
	[badgeLabel02 release];
	[badgeLabel03 release];
	[badgeLabel04 release];	
	
	[imageInfos release];
	
    [super dealloc];
}


@end

//
//  TFUITabBar.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 17..
//  Copyright 2011 두베. All rights reserved.
//

#import "TFUITabBar.h"

@implementation TFUITabBar

@synthesize tfTabBarItemsdelegate;
@synthesize buttonsView;

#pragma mark -
#pragma mark Public Method

- (void)setTabbarItemsImageSpecialType:(int)type {

	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:4];

	NSString *strFormat = @"%@0%d_%@.%@";
	NSString *prefix = @"00_footermenu_";
	NSString *uString = @"off";
	NSString *sString = @"on";
	NSString *eString = @"png";
	NSString *width = nil;
	
	for (int i = 0; i < 4; i++) {
		
		switch (i) {
			case 0:
				width = @"81";
				break;
			case 1:
				width = @"79";
				break;
			case 2:
				width = @"76";
				break;
			case 3:
				width = @"84";
				
				prefix = (type == 1 ? prefix : @"00_footermenu02_");
				break;
			default:
				break;
		}
		
		NSString *strImageNomal		= [NSString stringWithFormat:strFormat, prefix, i+1, uString, eString];
		NSString *strImageSelecgted = [NSString stringWithFormat:strFormat, prefix, i+1, sString, eString];
		
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
							 strImageNomal,		@"normal", 
							 strImageNomal,		@"highlighted", 
							 strImageNomal,		@"disabled", 
							 strImageSelecgted, @"selected", 
							 width,				@"width", nil];
		
		[arr addObject:dic];
		[dic release];
		dic = nil;
		
	}
	
	buttonsView.imageInfos = arr;
	[arr release];
	arr = nil;
	
}

- (void)setTabbarItemsImageSpecialType1 {
	[self setTabbarItemsImageSpecialType:1];
}

- (void)setTabbarItemsImageSpecialType2 {
	[self setTabbarItemsImageSpecialType:2];
}

- (void)setTabbarItemsImageWithPrefix:(NSString *)prefix 
					   selectedString:(NSString *)sString 
					 unselectedString:(NSString *)uString
					  extensionString:(NSString *)eString 
					  numberOfButtons:(int)numberOfButtons {
	
	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:numberOfButtons];
	
	NSString *strFormat = @"%@0%d_%@.%@";

	for (int i = 0; i < numberOfButtons; i++) {
		
		NSString *strImageNomal		= [NSString stringWithFormat:strFormat, prefix, i+1, uString, eString];
		NSString *strImageSelecgted = [NSString stringWithFormat:strFormat, prefix, i+1, sString, eString];
		
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
							 strImageNomal,		@"normal", 
							 strImageNomal,		@"highlighted", 
							 strImageNomal,		@"disabled", 
							 strImageSelecgted, @"selected", nil];
		
		[arr addObject:dic];
		[dic release];
		dic = nil;
		
	}
	buttonsView.imageInfos = arr;
	[arr release];
	arr = nil;
}

- (void)setTabbarItemsImage:(NSArray *)imageInfos {
	buttonsView.imageInfos = imageInfos;
}
- (void)rollBakcSelectedIndex {
	[buttonsView rollBakcSelectedIndex];
}
- (void)setBadgeValue:(NSString *)badgeValue index:(NSUInteger)index {
	[buttonsView setBadgeValue:badgeValue index:index];
}

#pragma mark -
#pragma mark TFUITabBarItemsDelegate Implement
- (void)tabBarItemSelected:(NSUInteger)index {
	
	[self.tfTabBarItemsdelegate tabBarItemSelected:index];
	
}

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
    if (self) {
        // Initialization code.
    }
    return self;
}

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

		
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TFUITabBarItemsView" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"TFUITabBarItemsView")]) {
				
				self.buttonsView = oneObject;

				[self addSubview:self.buttonsView];
				self.buttonsView.delegate = self;
				self.buttonsView.selectedIndex = 0;

				[self setTabbarItemsImageWithPrefix:@"bott_menu_" 
									 selectedString:@"on" 
								   unselectedString:@"off" 
									extensionString:@"png" 
									numberOfButtons:5];

			}
		}
		
		
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
	[buttonsView release];
    [super dealloc];
}


@end

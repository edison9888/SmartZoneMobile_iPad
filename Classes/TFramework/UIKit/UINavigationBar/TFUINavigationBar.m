//
//  TFUINavigationBar.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "TFUINavigationBar.h"


@implementation TFUINavigationBar

@synthesize isHomeLogo;
@synthesize titleLabel;	// 타이틀 라벨

- (void)setIsHomeLogo:(BOOL)drawHomeLogo {
	isHomeLogo = drawHomeLogo;
	
	[self setNeedsDisplay];
}

- (id)init {
	if (self = [super init]) {
		isHomeLogo = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
		isHomeLogo = NO;
		titleLabel = [[UILabel alloc] init];
		[self addSubview:titleLabel];
    }
    return self;	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		isHomeLogo = NO;
		titleLabel = [[UILabel alloc] init];
		[self addSubview:titleLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.

	if (isHomeLogo) {
		UIImage *image = [UIImage imageNamed:@"home_title.png"];
		[image drawInRect:rect];
	} else {
		UIImage *image = [UIImage imageNamed:@"top_tit_bg.png"];
		if (image == nil) {
			[super drawRect:rect];
		} else {
			[image drawInRect:rect];
		}
	}

	
}


- (void)dealloc {
	[titleLabel release];	// 타이틀 라벨
	titleLabel = nil;
    [super dealloc];
}


@end

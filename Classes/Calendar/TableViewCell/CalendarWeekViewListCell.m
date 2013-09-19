//
//  CalendarWeekViewListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 18..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarWeekViewListCell.h"


@implementation CalendarWeekViewListCell

@synthesize label1;	// 요일
@synthesize label2;	// 날짜
@synthesize label3;	// 일정1 시간
@synthesize label4;	// 일정1 타이틀
@synthesize label5;	// 일정2 시간
@synthesize label6;	// 일정2	타이틀
@synthesize label7;	// 표시되지 않은 일정 수

@synthesize image1, image2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	
	[label1 release];	// 요일
	[label2 release];	// 날짜
	[label3 release];	// 일정1 시간
	[label4 release];	// 일정1 타이틀
	[label5 release];	// 일정2 시간
	[label6 release];	// 일정2	타이틀	
	[label7 release];	// 표시되지 않은 일정 수
	
    [image1 release];
    [image2 release];
    [super dealloc];
}


@end

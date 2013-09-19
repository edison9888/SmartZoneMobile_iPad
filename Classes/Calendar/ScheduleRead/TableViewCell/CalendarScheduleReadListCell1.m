//
//  CalendarScheduleReadListCell1.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleReadListCell1.h"


@implementation CalendarScheduleReadListCell1

@synthesize label1;	// 제목
@synthesize label2;	// 위치
@synthesize label3;	// 시작
@synthesize label4;	// 종료


#pragma mark -
#pragma mark XCode Generated

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
	
	[label1 release];	// 제목
	[label2 release];	// 위치
	[label3 release];	// 시작
	[label4 release];	// 종료	
	
    [super dealloc];
}


@end

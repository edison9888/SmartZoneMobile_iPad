//
//  CalendarDayScheduleListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 19..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarDayScheduleListCell.h"


@implementation CalendarDayScheduleListCell

@synthesize label1;	// 타이틀
@synthesize label2;	// 시간

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
	[label1 release];	// 타이틀
	[label2 release];	// 시간	
    [super dealloc];
}


@end

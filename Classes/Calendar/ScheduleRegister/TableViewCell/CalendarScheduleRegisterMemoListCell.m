//
//  CalendarScheduleRegisterMemoListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterMemoListCell.h"


@implementation CalendarScheduleRegisterMemoListCell

@synthesize textView1;

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
	
	[textView1 release];
	
    [super dealloc];
}


@end

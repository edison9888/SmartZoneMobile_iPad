//
//  CalendarScheduleRegisterListCell1.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterListCell1.h"


@implementation CalendarScheduleRegisterListCell1

@synthesize label1;
@synthesize label2;

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
	[label1 release];
	[label2 release];	
    [super dealloc];
}


@end

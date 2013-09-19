//
//  CalendarScheduleReadListCell3.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleReadListCell3.h"


@implementation CalendarScheduleReadListCell3

@synthesize title;
@synthesize label1;

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
    [title  release];
	[label1 release];
    [super dealloc];
}


@end

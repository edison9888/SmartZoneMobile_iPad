//
//  CalendarScheduleReadListCell2.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleReadListCell2.h"


@implementation CalendarScheduleReadListCell2

@synthesize title;
@synthesize label1;	// 알림 1
@synthesize label2;	// 알림 2

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
	[label1 release];	// 알림 1
	[label2 release];	// 알림 2	
	
    [super dealloc];
}


@end

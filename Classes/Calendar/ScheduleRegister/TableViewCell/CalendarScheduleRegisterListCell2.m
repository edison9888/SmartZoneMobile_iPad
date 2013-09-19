//
//  CalendarScheduleRegisterListCell2.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterListCell2.h"


@implementation CalendarScheduleRegisterListCell2

@synthesize label1;	// 왼쪽 위
@synthesize label2;	// 왼쪽 아래
@synthesize label3;	// 오른쪽 위
@synthesize label4;	// 오른쪽 아래

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
	
	[label1 release];	// 왼쪽 위
	[label2 release];	// 왼쪽 아래
	[label3 release];	// 오른쪽 위
	[label4 release];	// 오른쪽 아래
	
    [super dealloc];
}


@end

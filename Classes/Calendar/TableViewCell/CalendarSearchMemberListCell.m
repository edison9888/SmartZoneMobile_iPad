//
//  CalendarSearchMemberListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarSearchMemberListCell.h"


@implementation CalendarSearchMemberListCell

@synthesize label1;
@synthesize imageView1;
@synthesize button1;

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
	[imageView1 release];
	[button1 release];	
    [super dealloc];
}


@end

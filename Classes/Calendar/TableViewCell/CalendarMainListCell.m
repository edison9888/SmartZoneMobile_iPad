//
//  CalendarMainListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 24..
//  Copyright 2011 두베. All rights reserved.
//

#import "CalendarMainListCell.h"


@implementation CalendarMainListCell

@synthesize label1;

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
	
    [super dealloc];
}


@end

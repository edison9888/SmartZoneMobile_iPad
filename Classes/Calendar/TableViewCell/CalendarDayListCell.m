//
//  CalendarDayListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarDayListCell.h"


@implementation CalendarDayListCell

@synthesize label1;	// 첫번째
@synthesize label2;	// 두번째
@synthesize image1;	// 첫번째
@synthesize image2;	// 두번째

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
    
    [label1 release];	// 첫번째
	[label2 release];	// 두번째
    [image1 release];
    [image2 release];
    [super dealloc];
}


@end

//
//  CalendarListListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 28..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarListListCell.h"


@implementation CalendarListListCell

@synthesize label1;	// 시간
@synthesize label2;	// 타이틀
@synthesize image1;

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
	
	[label1 release];	// 시간
	[label2 release];	// 타이틀
	[image1 release];
    [super dealloc];
}


@end

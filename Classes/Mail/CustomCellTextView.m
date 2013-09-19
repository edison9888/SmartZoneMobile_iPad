//
//  CustomCellTextView.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 7. 7..
//  Copyright 2011 ktds. All rights reserved.
//

#import "CustomCellTextView.h"


@implementation CustomCellTextView

@synthesize customTextView;
@synthesize customScrollView;
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
    [super dealloc];
}




@end

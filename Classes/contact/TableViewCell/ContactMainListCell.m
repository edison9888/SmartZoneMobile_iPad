//
//  ContactMainListCell.m
//  TFTest
//
//  Created by 재영 장 on 11. 6. 16..
//  Copyright 2011 . All rights reserved.
//

#import "ContactMainListCell.h"


@implementation ContactMainListCell

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;

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
    [label3 release];
    [label4 release];
	
    [super dealloc];
}


@end

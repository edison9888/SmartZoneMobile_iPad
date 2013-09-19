//
//  MainListCustomCell.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 7. 4..
//  Copyright 2011 ktds. All rights reserved.
//

#import "OrgNaviInfoCustomCell.h"


@implementation OrgNaviInfoCustomCell
@synthesize iconImageView;
@synthesize iconTitleLabel;
@synthesize subLabel;
@synthesize orgLabel;
@synthesize backgroundCustomView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//		iconTitleLabel.text = @"";
//		subLabel.text = @"";
//		backgroundCustomView.backgroundColor = [UIColor whiteColor];
//		orgLabel.text = @"";
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
		// Configure the view for the selected state.
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[iconImageView release];
	[iconTitleLabel release];
	[subLabel release];
	[backgroundCustomView release];
	[orgLabel release];
	
    [super dealloc];
}


@end

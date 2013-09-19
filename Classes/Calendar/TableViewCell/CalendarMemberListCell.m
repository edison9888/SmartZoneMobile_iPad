//
//  CalendarMemberListCell.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarMemberListCell.h"


@implementation CalendarMemberListCell

@synthesize label1;
@synthesize imageView1;
@synthesize button1;
@synthesize button2;
@synthesize image1;

@synthesize delegate;

#pragma mark -
#pragma mark a

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint touchPoint = [ [[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
	originX = touchPoint.x;
	
	hasToggle = NO;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint touchPoint = [ [[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
	
	if (originX - touchPoint.x > 1 || originX - touchPoint.x < -1) {
		hasToggle = YES;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    [self.button2 setTitle:NSLocalizedString(@"btn_delete", @"삭제") forState:UIControlStateNormal]; 

	if (hasToggle) {
		self.button2.hidden = !self.button2.hidden;
	}
	
	if (!self.button2.hidden) {
		[self.delegate deleteButtonDidShow:self.button2];
	}
	
	hasToggle = NO;
}

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
	[label1 release];
	[imageView1 release];
	[button1 release];	
	[button2 release];
	[image1 release];
    [super dealloc];
}


@end

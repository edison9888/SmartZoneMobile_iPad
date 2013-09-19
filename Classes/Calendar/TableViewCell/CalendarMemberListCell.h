//
//  CalendarMemberListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMemberListCellDelegate

- (void)deleteButtonDidShow:(id)sender;

@end


@interface CalendarMemberListCell : UITableViewCell {
	
	// UI
	UILabel *label1;
	UIImageView *imageView1;
	UIButton *button1;
	UIButton *button2;
    
    UIImageView *image1;
	
    // flag
	BOOL hasToggle;
	
	// handling
	CGFloat originX;
	
	id <CalendarMemberListCellDelegate>delegate;
	
}

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIImageView *image1;

@property (nonatomic, assign) id <CalendarMemberListCellDelegate>delegate;

@end

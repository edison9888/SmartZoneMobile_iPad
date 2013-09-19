//
//  CalendarSearchMemberListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarSearchMemberListCell : UITableViewCell {
	// UI
	UILabel *label1;
	UIImageView *imageView1;
	UIButton *button1;
}

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutlet UIButton *button1;

@end

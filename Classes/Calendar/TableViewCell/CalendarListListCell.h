//
//  CalendarListListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 28..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarListListCell : UITableViewCell {
	// UI
	UILabel *label1;	// 시간
	UILabel *label2;	// 타이틀
    
    UIImageView *image1;
}

// UI
@property (nonatomic, retain) IBOutlet UILabel *label1;	// 시간
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 타이틀
@property (nonatomic, retain) IBOutlet UIImageView *image1;	

@end

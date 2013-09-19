//
//  CalendarDayListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarDayListCell : UITableViewCell {

    // UI
	UILabel *label1;	// 첫번째
	UILabel *label2;	// 두번째
    
    UIImageView *image1;
    UIImageView *image2;
}

// UI
@property (nonatomic, retain) IBOutlet UILabel *label1;	// 첫번째
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 두번째
@property (nonatomic, retain) IBOutlet UIImageView *image1;	// 첫번째
@property (nonatomic, retain) IBOutlet UIImageView *image2;	// 두번째

@end

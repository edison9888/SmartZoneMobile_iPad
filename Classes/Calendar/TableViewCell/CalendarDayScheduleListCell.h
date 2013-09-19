//
//  CalendarDayScheduleListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 19..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarDayScheduleListCell : UITableViewCell {
	
	// UI
	UILabel *label1;	// 타이틀
	UILabel *label2;	// 시간
	
}

// UI
@property (nonatomic, retain) IBOutlet UILabel *label1;	// 타이틀
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 시간

@end

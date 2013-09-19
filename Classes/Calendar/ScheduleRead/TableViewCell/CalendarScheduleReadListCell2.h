//
//  CalendarScheduleReadListCell2.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarScheduleReadListCell2 : UITableViewCell {
    
    UILabel *title;
	UILabel *label1;	// 알림 1
	UILabel *label2;	// 알림 2
}

@property (nonatomic, retain) IBOutlet UILabel *title;	// 알림
@property (nonatomic, retain) IBOutlet UILabel *label1;	// 알림 1
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 알림 2

@end

//
//  CalendarScheduleReadListCell3.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarScheduleReadListCell3 : UITableViewCell {
    UILabel *title;
	UILabel *label1;	// 메모 내용
}
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *label1;	// 메모 내용


@end

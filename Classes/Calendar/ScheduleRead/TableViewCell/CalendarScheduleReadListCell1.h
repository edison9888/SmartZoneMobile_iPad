//
//  CalendarScheduleReadListCell1.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarScheduleReadListCell1 : UITableViewCell {
	UILabel *label1;	// 제목
	UILabel *label2;	// 위치
	UILabel *label3;	// 시작
	UILabel *label4;	// 종료
}

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 제목
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 위치
@property (nonatomic, retain) IBOutlet UILabel *label3;	// 시작
@property (nonatomic, retain) IBOutlet UILabel *label4;	// 종료

@end

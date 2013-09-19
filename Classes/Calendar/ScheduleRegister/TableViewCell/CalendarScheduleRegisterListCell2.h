//
//  CalendarScheduleRegisterListCell2.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarScheduleRegisterListCell2 : UITableViewCell {

	UILabel *label1;	// 왼쪽 위
	UILabel *label2;	// 왼쪽 아래
	UILabel *label3;	// 오른쪽 위
	UILabel *label4;	// 오른쪽 아래
	
}

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 왼쪽 위
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 왼쪽 아래
@property (nonatomic, retain) IBOutlet UILabel *label3;	// 오른쪽 위
@property (nonatomic, retain) IBOutlet UILabel *label4;	// 오른쪽 아래


@end

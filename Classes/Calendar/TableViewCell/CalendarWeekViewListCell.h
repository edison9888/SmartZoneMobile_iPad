//
//  CalendarWeekViewListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 18..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarWeekViewListCell : UITableViewCell {
	
	UILabel *label1;	// 요일
	UILabel *label2;	// 날짜
	UILabel *label3;	// 일정1 시간
	UILabel *label4;	// 일정1 타이틀
	UILabel *label5;	// 일정2 시간
	UILabel *label6;	// 일정2	타이틀
	UILabel *label7;	// 표시되지 않은 일정 수
    
    UIImageView *image1;    // 일정1이미지
    UIImageView *image2;    // 일정2이미지
	
}

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 요일
@property (nonatomic, retain) IBOutlet UILabel *label2;	// 날짜
@property (nonatomic, retain) IBOutlet UILabel *label3;	// 일정1 시간
@property (nonatomic, retain) IBOutlet UILabel *label4;	// 일정1 타이틀
@property (nonatomic, retain) IBOutlet UILabel *label5;	// 일정2 시간
@property (nonatomic, retain) IBOutlet UILabel *label6;	// 일정2	타이틀
@property (nonatomic, retain) IBOutlet UILabel *label7;	// 표시되지 않은 일정 수
@property (nonatomic, retain) IBOutlet UIImageView *image1;	// 일정1 이미지
@property (nonatomic, retain) IBOutlet UIImageView *image2;	// 일정2 이미지

@end

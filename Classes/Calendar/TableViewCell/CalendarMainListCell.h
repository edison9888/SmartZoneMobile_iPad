//
//  CalendarMainListCell.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 24..
//  Copyright 2011 두베. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarMainListCell : UITableViewCell {
	UILabel *label1;	// 일정
}

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 일정

@end

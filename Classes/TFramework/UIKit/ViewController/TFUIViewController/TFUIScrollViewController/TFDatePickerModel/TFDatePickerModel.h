//
//  TFDatePickerModel.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFDatePickerModel : NSObject {
	
	UIDatePickerMode datePickerMode;
	NSDate *date;
	NSDate *minimumDate;
	NSDate *maximumDate;
	NSTimeInterval minuteInterval;
	
	NSString *dateFormat;
	NSString *localeIdentifier;
	
	NSDate *selectedDate;

}

@property UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *maximumDate;
@property NSTimeInterval minuteInterval;

@property (nonatomic, copy) NSString *dateFormat; 
@property (nonatomic, copy) NSString *localeIdentifier;

@property (nonatomic, copy) NSDate *selectedDate;

@end

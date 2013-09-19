//
//  TFDatePickerModel.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "TFDatePickerModel.h"


@implementation TFDatePickerModel

@synthesize datePickerMode;
@synthesize date;
@synthesize minimumDate;
@synthesize maximumDate;
@synthesize minuteInterval;

@synthesize dateFormat;
@synthesize localeIdentifier;

@synthesize selectedDate;

- (void)setDate:(NSDate *)aDate {

	if (date != nil) {
		[date release];
		date = nil;
	}
	
	date = [aDate retain];
	self.selectedDate = date;
	
}

- (id)init {

	self = [super init];
	
	if (self) {
		
		datePickerMode = UIDatePickerModeDate;
		date = [[NSDate alloc] init];
		minimumDate = nil;
		maximumDate = nil;
		
		dateFormat = @"yyyyMMdd";
		localeIdentifier = @"en_US";
	}
	
	return self;
}

- (void)dealloc {
	
	[date release];
	[minimumDate release];
	[maximumDate release];
	
	[dateFormat release];
	[localeIdentifier release];
	
	[selectedDate release];

	[super dealloc];
}

@end

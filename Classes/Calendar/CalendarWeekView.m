//
//  CalendarWeekView.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 12..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarWeekView.h"
#import "CalendarFunction.h"

@implementation CalendarWeekView

@synthesize imageView1;	// 일요일
@synthesize imageView2;	// 월요일
@synthesize imageView3;	// 화요일
@synthesize imageView4;	// 수요일
@synthesize imageView5;	// 목요일
@synthesize imageView6;	// 금요일
@synthesize imageView7;	// 토요일
@synthesize imageView101;	// 일요일
@synthesize imageView102;	// 월요일
@synthesize imageView103;	// 화요일
@synthesize imageView104;	// 수요일
@synthesize imageView105;	// 목요일
@synthesize imageView106;	// 금요일
@synthesize imageView107;	// 토요일
@synthesize label1;	// 일요일
@synthesize label2;	// 월요일
@synthesize label3;	// 화요일
@synthesize label4;	// 수요일
@synthesize label5;	// 목요일
@synthesize label6;	// 금요일
@synthesize label7;	// 토요일

@synthesize calendarDelegate;
@synthesize isSetCompleted;

#pragma mark -
#pragma mark Local Method

- (UIImageView *)getImageViewWithIndex:(NSUInteger)index {
	
	UIImageView *imageView = nil;
	
	switch (index) {
		case 0:	{	// 일요일
			imageView = self.imageView1;
		}	break;
		case 1:	{	// 월요일
			imageView = self.imageView2;
		}	break;
		case 2:	{	// 화요일
			imageView = self.imageView3;
		}	break;
		case 3:	{	// 수요일
			imageView = self.imageView4;
		}	break;
		case 4:	{	// 목요일
			imageView = self.imageView5;
		}	break;
		case 5:	{	// 금요일
			imageView = self.imageView6;
		}	break;
		case 6:	{	// 토요일
			imageView = self.imageView7;
		}	break;
		default:
			break;
	}	

	return imageView;
}

- (UIImageView *)getHasScheduleImageViewWithIndex:(NSUInteger)index {
	
	UIImageView *imageView = nil;
	
	switch (index) {
		case 0:	{	// 일요일
			imageView = self.imageView101;
		}	break;
		case 1:	{	// 월요일
			imageView = self.imageView102;
		}	break;
		case 2:	{	// 화요일
			imageView = self.imageView103;
		}	break;
		case 3:	{	// 수요일
			imageView = self.imageView104;
		}	break;
		case 4:	{	// 목요일
			imageView = self.imageView105;
		}	break;
		case 5:	{	// 금요일
			imageView = self.imageView106;
		}	break;
		case 6:	{	// 토요일
			imageView = self.imageView107;
		}	break;
		default:
			break;
	}	
	
	return imageView;
}

- (UILabel *)getLabelWithIndex:(NSUInteger)index {
	
	UILabel *label = nil;
	
	switch (index) {
		case 0:	{	// 일요일
			label	  = self.label1;
		}	break;
		case 1:	{	// 월요일
			label	  = self.label2;
		}	break;
		case 2:	{	// 화요일
			label	  = self.label3;
		}	break;
		case 3:	{	// 수요일
			label	  = self.label4;
		}	break;
		case 4:	{	// 목요일
			label	  = self.label5;
		}	break;
		case 5:	{	// 금요일
			label	  = self.label6;
		}	break;
		case 6:	{	// 토요일
			label	  = self.label7;
		}	break;
		default:
			break;
	}	
	
	return label;
}

#pragma mark -
#pragma mark Public Method

- (NSMutableDictionary *)setDays:(NSArray *)aDates {
	
	if ([CalendarFunction compare:[aDates objectAtIndex:0] 
							   to:[arrDates objectAtIndex:0] 
					   dateFormat:@"yyyyMMdd"] == NSOrderedSame) {
		return buttonsInfo;
	}
	
	[buttonsInfo release];
	buttonsInfo = [[NSMutableDictionary alloc] init];
	
	[arrDates release];
	arrDates = nil;
	
	arrDates = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < 7; i++) {
		
		UIImageView *imageView			  = [self getImageViewWithIndex:i];
		UIImageView *hasScheduleImageView = [self getHasScheduleImageViewWithIndex:i];
		UILabel *label					  = [self getLabelWithIndex:i];
		
		NSTimeInterval interVal = 60 * 60 * 24 * i; // (하루 = 60초 * 60분 * 24시간)
		
		NSDate *tmpDate = [[NSDate alloc] initWithTimeInterval:interVal sinceDate:[aDates objectAtIndex:0]];
		[arrDates addObject:tmpDate];
		[tmpDate release];
		tmpDate = nil;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyyMMdd"];
		
		NSString *strDay = [dateFormat stringFromDate:[arrDates objectAtIndex:i]];
		
		NSArray *imageViewAndLabel = [[NSArray alloc] initWithObjects:imageView, label, hasScheduleImageView, nil];
		[buttonsInfo setObject:imageViewAndLabel forKey:strDay];
		[imageViewAndLabel release];
		imageViewAndLabel = nil;
		
		[dateFormat setDateFormat:@"d"];
		label.text = [dateFormat stringFromDate:[arrDates objectAtIndex:i]];
		
		[dateFormat release];
		dateFormat = nil;
	}
	
	return buttonsInfo;
}

#pragma mark -
#pragma mark Action Method

- (IBAction)buttonDidPush:(id)sender {
	
	NSLog(@"sender tag := %d", [sender tag]);

	[calendarDelegate dayButtonDidPush:sender
									  :[arrDates objectAtIndex:[sender tag]]];
	
}

#pragma mark -
#pragma mark XCode Generated

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[imageView1 release];	// 일요일
	[imageView2 release];	// 월요일
	[imageView3 release];	// 화요일
	[imageView4 release];	// 수요일
	[imageView5 release];	// 목요일
	[imageView6 release];	// 금요일
	[imageView7 release];	// 토요일
	
	[imageView101 release];	// 일요일
	[imageView102 release];	// 월요일
	[imageView103 release];	// 화요일
	[imageView104 release];	// 수요일
	[imageView105 release];	// 목요일
	[imageView106 release];	// 금요일
	[imageView107 release];	// 토요일	
	
	[label1 release];	// 일요일
	[label2 release];	// 월요일
	[label3 release];	// 화요일
	[label4 release];	// 수요일
	[label5 release];	// 목요일
	[label6 release];	// 금요일
	[label7 release];	// 토요일
	
	[arrDates release];
	
	[buttonsInfo release];
    [super dealloc];
}


@end

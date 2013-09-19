//
//  CalendarScheduleRegisterRepeatViewController.m
//  TFTest
//
//  Created by 닷넷나무에 사과열리다. on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterRepeatViewController.h"
#import "CalendarScheduleRegisterRepeatListCell.h"

@implementation CalendarScheduleRegisterRepeatViewController

@synthesize tableView1;

#pragma mark -
#pragma mark naviRigthbtnPress

- (void)naviRigthbtnPress:(id)sender {
    // 변한 데이터를 모델에 저장한다.
    // 여기서는 변할 데이터가 없음. 
    [self popViewController];   
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 80.0;	// CalendarScheduleRegisterRepeatListCell.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	// 모델에 어떤 타입이 선택되었는지 저장한다.
	model.registerRepeatType = indexPath.row;
	model.registerRepeatTypeString = [datasource objectAtIndex:indexPath.row];
	
	
	// 기본적으로 설정되어 있는 값을 누른 경우 이쪽으로 온다.
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
//	switch (model.registerRepeatType) {
//		case 0:			// 없음
//			model.registerRepeatEndDate = nil;
//			model.registerRepeatEndDateString = @"";
//			// 일정등록 화면으로 이동한다.
//			[super popViewController];
//			break;
//		case 1:			// 매일
//			dateComponents.year = 1;	// 1년간
//			model.registerRepeatEndDateString = @"1년간";
//			break;
//		case 2:			// 매주
//			dateComponents.year = 5;	// 5년간
//			model.registerRepeatEndDateString = @"5년간";
//			break;
//		case 3:			// 매월 
//			dateComponents.year = 10;	// 10년간
//			model.registerRepeatEndDateString = @"10년간";
//			break;
//		case 4:			// 매년
//			dateComponents.year = 20;	// 20년간
//			model.registerRepeatEndDateString = @"20년간";
//			break;
//		default:
//			break;
//	}
    
    switch (model.registerRepeatType) {
		case 0:			// 없음
			model.registerRepeatEndDate = nil;
			model.registerRepeatEndDateString = @"";
			// 일정등록 화면으로 이동한다.
			[super popViewController];
			break;
		case 1:			// 매일
			dateComponents.month = 1;	// 1개월
			if ( isKr ) {
                model.registerRepeatEndDateString = @"1개월간";
            } else {
                model.registerRepeatEndDateString = @"1months";
            }
			break;
		case 2:			// 매주
			dateComponents.month = 1;	// 1개월
			if ( isKr ) {
                model.registerRepeatEndDateString = @"1개월간";
            } else {
                model.registerRepeatEndDateString = @"1months";
            }
			break;
		case 3:			// 매월 
			dateComponents.year = 1;	// 1년간
			model.registerRepeatEndDateString = [NSString stringWithFormat:@"1%@", NSLocalizedString(@"calendar_years", @"년간")];
			break;
		case 4:			// 매년
			dateComponents.year = 3;	// 3년간
			model.registerRepeatEndDateString = [NSString stringWithFormat:@"3%@", NSLocalizedString(@"calendar_years", @"년간")];
			break;
		default:
			break;
	}
	
	NSDate *repeatEndDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
																		   toDate:[NSDate date] 
																		  options:0];
	[dateComponents release];
	dateComponents = nil;
	
	model.registerRepeatEndDate = repeatEndDate;
	
	// 일정등록 화면으로 이동한다.
	[super popViewController];
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;

	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterRepeatListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterRepeatListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarScheduleRegisterRepeatListCell *tmpCell = (CalendarScheduleRegisterRepeatListCell *)cell;
	
	tmpCell.label1.text = [datasource objectAtIndex:indexPath.row];
	
	return cell;
	
}


#pragma mark -
#pragma mark XCode Generated

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	self.title = NSLocalizedString(@"calendar_repeat",@"반복");
	
	// 내비게이션 왼쪽버튼
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonSystemItemDone];
	
	// 내비게인션 오른쪽 버튼
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonSystemItemDone];
	
	
	model = [CalendarModel sharedInstance];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
    // 일단 현재시간을 구한다.
    NSTimeInterval hourMinuteInterval = (long)[[NSDate date] timeIntervalSince1970] % (60 * 60 * 24);
    hourMinuteInterval -= ((long)hourMinuteInterval % (60 * 60)) - (60 * 60 * 10);
    NSDate *selectDateFormat = [[[NSDate alloc] initWithTimeInterval:hourMinuteInterval sinceDate:model.selectedDate] autorelease];

	NSString *strWeekly = @"";
    if ( isKr ) {
        [dateFormatter setDateFormat:@"매주(매주 EEEE)"];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
        strWeekly = [dateFormatter stringFromDate:selectDateFormat];
    } else {
        [dateFormatter setDateFormat:@" EEEE"];
        strWeekly = [NSString stringWithFormat:@"every week(every week %@)", [dateFormatter stringFromDate:selectDateFormat]];
    }
    
    NSString *strMonthly = @"";
	if ( isKr ) {
        [dateFormatter setDateFormat:@"매월(매월 d일)"];
        strMonthly = [dateFormatter stringFromDate:selectDateFormat];
	} else {
        [dateFormatter setDateFormat:@"d"];
        strMonthly = [NSString stringWithFormat:@"every month(every month %@)", [dateFormatter stringFromDate:selectDateFormat]];
	}
    
    NSString *strYearly  = @"";
    if ( isKr ) {
        [dateFormatter setDateFormat:@"매년(매년 M월 d일)"];
        strYearly  = [dateFormatter stringFromDate:selectDateFormat];
    } else {
        [dateFormatter setDateFormat:@"MMMM d"];
        strYearly  = [NSString stringWithFormat:@"every year(every year %@)", [dateFormatter stringFromDate:selectDateFormat]];
    }
    
	
	// 테이블에 보여줄 데이터소스를 만든다.
//20110629 UI 및 데이터 변경 0:반복없음 , 1:매일, 2:매주, 3:매월, 4:매년(현재일자)						
//	datasource = [[NSArray alloc] initWithObjects:
//				  @"없음",
//				  @"매일",
//				  @"주중(월~금)",
//				  strWeekly,
//				  strMonthly,
//				  strYearly, nil];
    datasource = [[NSArray alloc] initWithObjects:
				  NSLocalizedString(@"calendar_no_alarm",@"없음"),
				  NSLocalizedString(@"calendar_everday",@"매일"),
				  strWeekly,
				  strMonthly,
				  strYearly, nil];

	[dateFormatter release];
	dateFormatter = nil;

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tableView1 = nil;
}


- (void)dealloc {
	[tableView1 release];
	[datasource release];
    [super dealloc];
}


@end

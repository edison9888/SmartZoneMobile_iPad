//
//  CalendarScheduleRegisterRepeatDetailViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterRepeatDetailViewController.h"
#import "CalendarScheduleRegisterRepeatDetailListCell.h"
#import "CalendarFunction.h"

@implementation CalendarScheduleRegisterRepeatDetailViewController

@synthesize tableView1;
@synthesize datePicker1;

#pragma mark -
#pragma mark Callback Method

- (void)naviRigthbtnPress:(id)sender {
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	// 모델에 데이트피커로 설정한 date를 저장한다.
	model.registerRepeatEndDate = self.datePicker1.date;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
    if ( isKr ) {
        [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E"];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
	} else {
        [dateFormatter setDateFormat:@"E d/MMMM/YYYY"];
    }
    
    model.registerRepeatEndDateString = [dateFormatter stringFromDate:model.registerRepeatEndDate];
	[dateFormatter release];
	dateFormatter = nil;
	
	// 일정 등록, 수정 화면으로 이동
	//[super popToViewControllerInFlow:@"CalendarScheduleRegisterViewController"];
    [super popViewController];
}

#pragma mark -
#pragma mark Action Method

- (IBAction)datePicker1ValueChanged:(id)sender {

	[tableView1 reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 80.0;	// CalendarScheduleRegisterRepeatListCell.xib에 설정되어있는 height
	
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return nil;
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
    
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
    
//	NSDate *repeatEndDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
//																				toDate:[NSDate date] 
//																			   options:0];
    
    
    NSDate *repeatEndDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents 
                                                                           toDate:[CalendarFunction getDateFromString:[CalendarFunction getStringFromDate:model.registerStartDate dateFormat:@"yyyy-MM-dd HH:mm"] dateFormat:@"yyyy-MM-dd HH:mm"] 
                                                                          options:0];
    [dateComponents release];
	dateComponents = nil;
	
	model.registerRepeatEndDate = repeatEndDate;
//	NSLog(@"%@", model.registerRepeatEndDate);
	
	// 일정 등록, 수정 화면으로 이동
	//[super popToViewControllerInFlow:@"CalendarScheduleRegisterViewController"];
    [super popViewController];
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
    
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterRepeatDetailListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterRepeatDetailListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarScheduleRegisterRepeatDetailListCell *tmpCell = (CalendarScheduleRegisterRepeatDetailListCell *)cell;
	
	if (indexPath.row == 0) {
		tmpCell.label1.text = NSLocalizedString(@"calendar_repeat_termination",@"반복 종료");
		tmpCell.label2.hidden = NO;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		if ( isKr ) {
            [dateFormatter setDateFormat:@"YYYY년 MMMM d일 (E)"];
            [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
        } else {
            [dateFormatter setDateFormat:@"(E) d/MMMM/YYYY"];
        }
		
		tmpCell.label2.text = [dateFormatter stringFromDate:self.datePicker1.date];
		
		[dateFormatter release];
		dateFormatter = nil;
	} else {
		tmpCell.label2.hidden = YES;
		
//		switch (model.registerRepeatType) {
//			case 0:			// 없음
//				
//				break;
//			case 1:			// 매일
//				tmpCell.label1.text = @"1년간";
//				break;
//			case 2:			// 매주
//				tmpCell.label1.text = @"5년간";
//				break;
//			case 3:			// 매월 
//				tmpCell.label1.text = @"10년간";
//				break;
//			case 4:			// 매년
//				tmpCell.label1.text = @"20년간";
//				break;
//			default:
//				break;
//		}
        
        switch (model.registerRepeatType) {
			case 0:			// 없음
				
				break;
			case 1:			// 매일
				if ( isKr ) {
                    tmpCell.label1.text = @"1개월간";
                } else {
                    tmpCell.label1.text = @"1months";
                }
				break;
			case 2:			// 매주
				if ( isKr ) {
                    tmpCell.label1.text = @"1개월간";
                } else {
                    tmpCell.label1.text = @"1months";
                }
				break;
			case 3:			// 매월 
				tmpCell.label1.text = [NSString stringWithFormat:@"1%@", NSLocalizedString(@"calendar_years", @"년간")];
				break;
			case 4:			// 매년
				tmpCell.label1.text = [NSString stringWithFormat:@"3%@", NSLocalizedString(@"calendar_years", @"년간")];
				break;
			default:
				break;
		}
		
	}

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
    
    self.title = NSLocalizedString(@"calendar_repeat_termination",@"반복종료");
	
	// 왼쪽 취소
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonSystemItemDone];
	
	// 오른쪽 완료
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonSystemItemDone];
	
	model = [CalendarModel sharedInstance];
	
	//self.datePicker1.date		 = [NSDate date];
	//self.datePicker1.minimumDate = [NSDate date];
	// 날짜 피커가 선택 되어야할 날짜.. (일단은.. 반복이니깐.. enddate보다는 커야지..
    // minimumDate 는 상황에 따라 다른데.. 
    // 매일일 경우 종료일 보다 크면 되고
    // 매주일 경우 종료일 보다 일주일 커야 하고..
    // 매월의 경우 종료일 보다 한달 커야하고
    // 매년의 경우 종료일 보다 일년 커야한다.
    // 일단은 종료일로 설정하자.
    //NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    self.datePicker1.date = model.registerRepeatEndDate;
    self.datePicker1.minimumDate = [[NSDate alloc] initWithTimeInterval:model.registerEndDateInterval sinceDate:model.registerStartDate];
    
    
	[tableView1 reloadData];
	
	selectedIndex = 0;
	
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
	self.tableView1  = nil;
	self.datePicker1 = nil;
}


- (void)dealloc {
	
	[tableView1 release];
	[datePicker1 release];
	
	[datasource release];
	
    [super dealloc];
}


@end

//
//  CalendarScheduleRegisterTimeViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//
//	참고1  종료 날짜의 표현은 시작date에서 타임인터벌로 계산하도록 한다.
//		  종료의 타임인터벌이 마이너스가 되면 시작일보다 과거로 세팅되었다 판단 경고와 그 이전에 라벨의 색을 빨간색으로 바꿔준다.
//	참고2  하루종일값을 참으로 하면 datePicker 타입은 date타입으로 바뀌어 시간을 설정할 수 없기 때문에 
//		  전문전송시 하루종일 값이 설정되었음을 판단할 수 있는 flag필드가 필요할 듯 함



#import "CalendarScheduleRegisterTimeViewController.h"
#import "CalendarScheduleRegisterTimeListCell.h"
#import "CalendarFunction.h"

@implementation CalendarScheduleRegisterTimeViewController

@synthesize tableView1;
@synthesize datePicker1;
@synthesize switch1;

#pragma mark -
#pragma mark CallBack Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1234) {
		        
    }
}

- (void)naviRigthbtnPress:(id)sender {
	
    if (endDateTimeInterval < 0) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"이벤트를 저장할 수 없음" 
															message:@"시작 날짜가 종료 날짜 이전이어야 합니다." 
														   delegate:nil 
												  cancelButtonTitle:@"승인" 
												   otherButtonTitles:nil] autorelease];
		alertView.tag = 1234;
        [alertView show];
	} else {
        // 변한 데이터를 모델에 저장한다.
        model.registerStartDate = startDate;
        model.registerEndDateInterval = endDateTimeInterval;
        model.registerIsAllDayEvent = switch1.on;				// 하루종일
        
        // 일정 등록 화면으로 이동한다.
        [super popViewController];
    }
}

#pragma mark -
#pragma mark Action Method

- (IBAction)switch1ValueChaned:(id)sender {

	// 피커 타입을 바꾼다.
	if (self.switch1.on) {
		self.datePicker1.datePickerMode = UIDatePickerModeDate;
	} else {
		self.datePicker1.datePickerMode = UIDatePickerModeDateAndTime;
	}

	// 라벨들의 포맷을 바꾸기 위해 갱신
	[self.tableView1 reloadData];
	[self.tableView1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
								 animated:NO 
						   scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)datePicker1ValueChanged:(id)sender {

	switch (selectedIndex) {
		case 0: {
			[startDate release];
			startDate = [self.datePicker1.date copy];
		}	break;
		case 1: {
			endDateTimeInterval = [self.datePicker1.date timeIntervalSinceDate:startDate];
		}	break;
		default:
			break;
	}
	

	[self.tableView1 reloadData];
	[self.tableView1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
								 animated:NO 
						   scrollPosition:UITableViewScrollPositionNone];

}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 80.0;	// CalendarScheduleRegisterRepeatListCell.xib에 설정되어있는 height
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		return nil;
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	selectedIndex = indexPath.row;

	switch (selectedIndex) {
		case 0: {
			self.datePicker1.date = startDate;
		}	break;
		case 1: {
			self.datePicker1.date = [[NSDate alloc] initWithTimeInterval:endDateTimeInterval sinceDate:startDate];
		}	break;
		default:
			break;
	}
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
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
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterTimeListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterTimeListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarScheduleRegisterTimeListCell *tmpCell = (CalendarScheduleRegisterTimeListCell *)cell;
	
	
	switch (indexPath.row) {
		case 0: {	// 시작

			tmpCell.label1.text = NSLocalizedString(@"calendar_start",@"시작");
			tmpCell.label2.hidden = NO;
			
			
			if (endDateTimeInterval < 0) {
				tmpCell.label2.textColor = [UIColor redColor];
			} else {
				tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
			}

			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			if ( isKr ) {
                [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
                if (self.switch1.on) {
                    [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E"];
                } else {
                    [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E HH:mm"];
                }
            } else {
                if (self.switch1.on) {
                    [dateFormatter setDateFormat:@"E d/MMMM/YYYY"];
                } else {
                    [dateFormatter setDateFormat:@"E HH:mm d/MMMM/YYYY"];
                }
            }
			
            
			tmpCell.label2.text = [dateFormatter stringFromDate:startDate];
			
			[dateFormatter release];
			dateFormatter = nil;
			
		}	break;
		case 1: {	// 종료
			
			tmpCell.label1.text = NSLocalizedString(@"calendar_end",@"종료");
			tmpCell.label2.hidden = NO;
			if (endDateTimeInterval < 0) {
				tmpCell.label2.textColor = [UIColor redColor];
			} else {
				tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
			}
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			if ( isKr ) {
                [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
            } else {
                
            }
			
			
			NSDate *endDate = [[NSDate alloc] initWithTimeInterval:endDateTimeInterval sinceDate:startDate];
			
			if ( isKr ) {
                if (self.switch1.on) {
                    [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E"];
                } else {
                    
                    if ([CalendarFunction compare:endDate to:startDate dateFormat:@"yyyyMMdd"] == NSOrderedSame) {
                        [dateFormatter setDateFormat:@"HH:mm"];
                    } else {
                        [dateFormatter setDateFormat:@"YYYY년 MMMM d일 E HH:mm"];
                    }
                    
                }
            } else {
                if (self.switch1.on) {
                    [dateFormatter setDateFormat:@"E d/MMMM/YYYY"];
                } else {
                    
                    if ([CalendarFunction compare:endDate to:startDate dateFormat:@"yyyyMMdd"] == NSOrderedSame) {
                        [dateFormatter setDateFormat:@"HH:mm"];
                    } else {
                        [dateFormatter setDateFormat:@"E HH:mm d/MMMM/YYYY"];
                    }
                    
                }
            }
			
			
			tmpCell.label2.text = [dateFormatter stringFromDate:endDate];
			
			[endDate release];
			[dateFormatter release];
			dateFormatter = nil;
			
		}	break;
		case 2: {

			tmpCell.label1.text = NSLocalizedString(@"calendar_all_day",@"하루종일");
			tmpCell.label2.hidden = YES;
			
		}	break;
		default:
			break;
	}
	
	return cell;
	
}

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
    
    self.title = NSLocalizedString(@"calendar_start_and_end",@"시작 및 종료");
	
	// 내비게이션 왼쪽버튼
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonSystemItemDone];
	
	// 내비게인션 오른쪽 버튼
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonSystemItemDone];
	
	model = [CalendarModel sharedInstance];

	// 핸들링을 위해 필요한 모델값들을 복사해논다.
	self.datePicker1.date = model.registerStartDate;
	startDate = [model.registerStartDate copy];
	endDateTimeInterval = model.registerEndDateInterval;
	switch1.on = model.registerIsAllDayEvent;

	// 하루종일 옵션이 ON상태면 데이트피커를 날짜만 나오게 하고
	if (switch1.on) {
		datePicker1.datePickerMode = UIDatePickerModeDate;
	} else {	// OFF상태면 데이트피커를 날짜와 시간이 나오게 한다. 
		datePicker1.datePickerMode = UIDatePickerModeDateAndTime;
	}
	
	// 라벨 갱신시키고 강제로 0번 인덱스(시작)을 선택한다.
	selectedIndex = 0;
	[self.tableView1 reloadData];
	[self.tableView1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
								 animated:NO 
						   scrollPosition:UITableViewScrollPositionNone];
	
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
	self.switch1	 = nil;
	
}


- (void)dealloc {
	
	[tableView1  release];
	[datePicker1 release];
	[switch1	release];
	
	[startDate release];

    [super dealloc];
}


@end

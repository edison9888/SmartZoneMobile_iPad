//
//  CalendarScheduleRegisterNoticelViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterNoticeViewController.h"
#import "CalendarScheduleRegisterNoticeListCell.h"

@implementation CalendarScheduleRegisterNoticeViewController

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
	
	return 40.0;	// CalendarScheduleRegisterNoticeListCell.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// 모델에 어떤 타입이 선택되었는지 저장한다.
	if (model.registerEdittingNoti == 0) {
		model.registerNotiType1 = indexPath.row;
		model.registerNotiType1String = [datasource objectAtIndex:indexPath.row];
	} else {
		model.registerNotiType2 = indexPath.row;
		model.registerNotiType2String = [datasource objectAtIndex:indexPath.row];
	}

	// 일정등록 화면으로 이동한다.
	[super popViewController];
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"s";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterNoticeListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterNoticeListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarScheduleRegisterNoticeListCell *tmpCell = (CalendarScheduleRegisterNoticeListCell *)cell;
	
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
	
	self.title = NSLocalizedString(@"calendar_alarm",@"알림");
	
	// 내비게이션 왼쪽버튼
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonSystemItemDone];
	
	// 내비게인션 오른쪽 버튼
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonSystemItemDone];
	
	model = [CalendarModel sharedInstance];
	
	// 테이블에 보여줄 데이터소스를 만든다.
	datasource = [[NSArray alloc] initWithObjects:
				  NSLocalizedString(@"btn_no_alarm",@"안함"),   
                  [NSString stringWithFormat:@"5%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")], 
                  [NSString stringWithFormat:@"10%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                  [NSString stringWithFormat:@"15%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                  [NSString stringWithFormat:@"30%@",NSLocalizedString(@"calendar_minutes_before", @"분 전")],
                  [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                  [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                  [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                  [NSString stringWithFormat:@"4%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                  [NSString stringWithFormat:@"8%@",NSLocalizedString(@"calendar_hours_before", @"시간 전")],
                  [NSString stringWithFormat:@"0.5%@",NSLocalizedString(@"calendar_days_before", @"일 전")],
                  [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_days_before", @"일 전")], 
                  [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_days_before", @"일 전")], 
                  [NSString stringWithFormat:@"3%@",NSLocalizedString(@"calendar_days_before", @"일 전")], 
                  [NSString stringWithFormat:@"1%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")], 
                  [NSString stringWithFormat:@"2%@",NSLocalizedString(@"calendar_weeks_before", @"주 전")], 
                  NSLocalizedString(@"btn_exact_time",@"정각")
                  , nil];
    
  	
	// 라벨 갱신시키고 강제로 0번 인덱스(시작)을 선택한다.
	int selectedIndex = model.registerEdittingNoti == 0 ? model.registerNotiType1 : model.registerNotiType2;
	
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
	
	self.tableView1 = nil;
}


- (void)dealloc {
	
	[tableView1 release];
	[datasource release];
    [super dealloc];
}


@end

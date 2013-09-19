//
//  CalendarDayScheduleListViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 19..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarDayScheduleListViewController.h"
#import "CalendarDayScheduleListCell.h"
#import "CalendarFunction.h"
#import "NSDictionary+NotNilReturn.h"


@implementation CalendarDayScheduleListViewController

@synthesize tableView1;

#pragma mark -
#pragma mark Local Method

- (NSString *)getKo_KRLocaleTimeStringWithTimeString:(NSString *)aStrTime {
	
	// 이거 로케일로 어떻게 하면 될꺼 같은데... 나중에 찾아서 고쳐야지...
    
    // 이렇게 고쳐야지.
    BOOL isKr = NO;
    if ( [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ko"] ) {
        isKr = YES;
    }
	
	NSString *strReturnFullDate = nil;
	
	NSString *strAmPm = @"";
	NSString *strTime   = [aStrTime substringWithRange:NSMakeRange(0, 2)];
	NSString *strMinute = [aStrTime substringWithRange:NSMakeRange(2, 2)];
	
	strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	
	if (12 - [strTime intValue] > 0) {	// 오전
		strAmPm	= (isKr)?@"오전":@"AM";
		strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	} else {
		strAmPm = (isKr)?@"오후":@"PM";
		strTime = [NSString stringWithFormat:@"%d", [strTime intValue]];
	}
	
	strReturnFullDate = [NSString stringWithFormat:@"%@ %@:%@", strAmPm, strTime, strMinute];
	
	return strReturnFullDate;
	
}

- (NSString *)getScheduleTimeStr:(NSDictionary *)dic {
    
    NSString *returnStr = @"";
    
    if ([[dic objectForKey:@"isalldayevent"] isEqualToString:@"true"]) {	// 하루종일 옵션 ON
		returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
	} else {
		
		if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXTED"]) {	// 시작일과 종료일의 중간에 낀 날짜
			returnStr = NSLocalizedString(@"calendar_all_day",@"하루종일");
		} else {
			// 이쪽으로 온 경우에는 시작일이거나... 종료일이거나... 하루종일 옵션 OFF로 하고 시작일과 종료일이 같은날(시간만 다른)인 경우
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
			NSDate *startDate = [dateFormatter dateFromString:[dic objectForKey:@"starttime"]];
			NSDate *endDate	  = [dateFormatter dateFromString:[dic objectForKey:@"endtime"]];
			
			[dateFormatter setDateFormat:@"HHmm"];
			
			if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXT_START"]) {		// EXTEND 타입의 시작일
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:startDate]];
				returnStr = [NSString stringWithFormat:@"%@ ~", korLocaleTimeString1];
			} else if ([[dic objectForKey:@"EXT_TYPE"] isEqualToString:@"EXT_END"]) {	// EXTEND 타입의 종료일
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:endDate]];
				returnStr = [NSString stringWithFormat:@"~ %@", korLocaleTimeString1];
			} else {																	// 시작일과 종료일이 같은 경우
				NSString *korLocaleTimeString1 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:startDate]];
				NSString *korLocaleTimeString2 = [self getKo_KRLocaleTimeStringWithTimeString:[dateFormatter stringFromDate:endDate]];
				returnStr = [NSString stringWithFormat:@"%@ ~ %@", korLocaleTimeString1, korLocaleTimeString2];
			}
            
			[dateFormatter release];
			dateFormatter = nil;
			
		}
        
	}
    
    return returnStr;
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 47.0;	// CalendarDayScheduleListCell.xib에 설정되어있는 height
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    model.viewSchedule = [datasource objectAtIndex:indexPath.section]; //섹션 처리.
//    [super pushViewController:@"CalendarScheduleReadViewController"];
    
    ;
    
    [super pushViewController:@"CalendarScheduleReadViewController"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MainScheduleRead" object:[[datasource objectAtIndex:indexPath.section]objectForKey:@"appointmentid"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark -
#pragma mark UITableViewDataSource Implement
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [datasource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarDayScheduleListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarDayScheduleListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	NSDictionary *dic = [datasource objectAtIndex:indexPath.section];

	CalendarDayScheduleListCell *tmpCell = (CalendarDayScheduleListCell *)cell;
	
	tmpCell.label1.text = [dic objectForKey:@"subject"];
	
    tmpCell.label2.text = [self getScheduleTimeStr:dic];
    
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
	
	datasource = [[NSMutableArray alloc] initWithCapacity:0];
	
    model = [CalendarModel sharedInstance];
    
    //NSLog(@"recive data list [%@]", model.viewScheduleList);    
    
    
	
//    for ( NSDictionary *dic in model.viewScheduleList ) {
//        [datasource addObject:dic];
//    }
    
    datasource = [model.viewScheduleList copy];
    
    
	[self.tableView1 reloadData];
	
    
    self.title = NSLocalizedString(@"calendar_appointment_list",@"약속목록");
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

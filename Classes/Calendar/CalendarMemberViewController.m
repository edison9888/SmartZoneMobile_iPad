//
//  CalendarMemberViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarMemberViewController.h"
#import "NSDictionary+NotNilReturn.h"
#import "URL_Define.h"

@implementation CalendarMemberViewController

@synthesize imageView1;	// 나의 일정 체크버튼
@synthesize imageView2;	// 공개된 다른사람 일정 백그라운드
@synthesize tableView1;	// 맴버리스트

@synthesize myLabel;
@synthesize memberLabel;

@synthesize indicator;
@synthesize clipboard;
@synthesize communication_flag;

#pragma mark -
#pragma mark Callback Method

- (void)backButtonDidPush:(id)sender {
    
    //완료버튼 클릭.
    if ( isMyScheduleChecked ) {
        //내 일정을 조회 하다 다시 내 일정을 조회 할경우
        if ( [[model.scheduleOwnerInfo notNilObjectForKey:@"isMy"] isEqualToString:@"YES"] ) {
            
        } else {
            model.isNeedUpdateSelectedDate = YES; // 다시 데이터 읽어 들이삼.
        }
        
        //내 일정 선택의 경우.
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        model.scheduleOwnerInfo = nil;
        model.scheduleOwnerInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"YES", @"isMy",
                                   [userDefault objectForKey:@"login_id"],@"loginid",
                                   NSLocalizedString(@"calendar_My_calendar",@"나의 일정"),@"empnm",
                                   @"",@"sharedemail",
                                   nil];
        
        
        
        [self dismissModalViewControllerAnimated:YES];
        
    } else {
        
        // 내 일정이 아니면서 타인 일정도 선택 하지 않은경우
        
        if ( [[selectMember notNilObjectForKey:@"email"] isEqualToString:@""] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"calendar_please_select_your_target",@"조회 대상을 선택하여 주십시요.")
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            
            [alert show];
            [alert release];
            return;
        } else {
        
            //타인 일정 선택의 경우.
            model.scheduleOwnerInfo = nil;
            model.scheduleOwnerInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"NO", @"isMy",
                                       [selectMember notNilObjectForKey:@"userid"],@"loginid",
                                       [selectMember notNilObjectForKey:@"usernm"] ,@"empnm",
                                       [selectMember notNilObjectForKey:@"email"],@"sharedemail",
                                       nil];
            
            [model.scheduleListDic removeAllObjects];
            
            model.isNeedUpdateSelectedDate = YES; // 다시 데이터 읽어 들이삼.
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
	
}

- (void)naviRigthbtnPress:(id)sender {

	//검색 버튼 클릭.
    
    [super pushViewController:@"CalendarSearchMemberViewController"];
}

// 체크박스 위 버튼
- (void)checkButtonDidPush:(id)sender {
	
	NSMutableDictionary *dic = [datasource objectAtIndex:[sender tag]];
	
	if ([[dic notNilObjectForKey:@"SELECTED"] isEqualToString:@"N"]) {
        
        // 타인 일정을 선택하는 경우 이므로 
        self.imageView1.image = nil;
        isMyScheduleChecked = NO;
        
        //테이블 안의 모든 데이터를 N으로 해준다.
        for (NSMutableDictionary *dic2 in datasource) {
            [dic2 setObject:@"N" forKey:@"SELECTED"];
        }
        
        //선택된 데이터만 Y로 해준다.
		[dic setObject:@"Y" forKey:@"SELECTED"];
        selectMember = [dic copy]; //현재 선택된 타인 값을 담아 놓는다.
	} else {
		[dic setObject:@"N" forKey:@"SELECTED"];
        [self myScheduleDidPush:self];
	}
	[self.tableView1 reloadData];

//	NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//	[self.tableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] 
//						   withRowAnimation:UITableViewRowAnimationNone];
	
}

// 체크박스 위 버튼
- (void)deleteButtonDidPush:(id)sender {
	
	NSMutableDictionary *dic = [datasource objectAtIndex:[sender tag]];
	
//	// 이미 선택한 데이터를 삭제한다면 선택된 데이터를 담아둔 배열에서도 삭제해준다.
//	[model.sharedMemberList removeObjectForKey:[dic objectForKey:@"ID"]];
//	
//	// 데이터소스에서 삭제한다.
//	[datasource removeObjectAtIndex:[sender tag]];
//	
//	showingDeleteButton.hidden = YES;
//	showingDeleteButton = nil;
//	
//	// 화면 갱신
//	[self.tableView1 reloadData];

	//[dic notNilObjectForKey:@"loginid"]; // 해당 값을 삭제 한다.
    
    self.communication_flag = DELETE_DATA;
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    callUrl = URL_deleteSharedUserInfo;
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [requestDictionary setObject:[dic notNilObjectForKey:@"otheruserid"] forKey:@"otheruserid"];
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
    if (!result) {
        // error occurred
    }
}

#pragma mark -
#pragma mark Action Method

- (IBAction)myScheduleDidPush:(id)sender {	// 나의 일정 버튼 액선(check / unckeck)

    //나의 일정을 선택하면 일단.. 모델에 나의 일정을 마킹하고 데이터를 리프래시 한다.
	if (!isMyScheduleChecked) {
		self.imageView1.image = [UIImage imageNamed:@"list_check.png"];	// TODO: 체크이미지
        
        
        // 테이블 안의 모든 데이터의 마크를 해재하고 데이터를 리프래시 한다.
        for (NSMutableDictionary *dic in datasource) {
            [dic setObject:@"N" forKey:@"SELECTED"];
        }
        [self.tableView1 reloadData];
        
	} else {
		self.imageView1.image = nil;
	}
	isMyScheduleChecked = !isMyScheduleChecked;
    
}

- (void)deleteButtonDidShow:(id)sender {
	
	showingDeleteButton.hidden = YES;
	showingDeleteButton = sender;
    
    [UIButton buttonWithType:UIButtonTypeCustom];
    
}

#pragma mark -
#pragma mark Data Request & Receive
- (void)requestCommunication {
	
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
	NSString *callUrl = @"";
    
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    if ( self.communication_flag == LOAD_DATA ) { //목록 호출
        callUrl = URL_getSharedUserInfoList; // 공유 타인 목록
        //[requestDictionary setObject:@"1001" forKey:@"compcd"]; //기본 파라메터이다.
    } else if ( self.communication_flag == CREATE_DATA ) { // 저장
        // 저장 후에는 다시 호출 해야한다 목록을
        callUrl = URL_createSharedUserInfo;
        
        
    } else if ( self.communication_flag == DELETE_DATA ) { // 삭제
        // 삭제 후에는 다시 호출 해야한다 목록을
        callUrl = URL_deleteSharedUserInfo;
        
        
    } 
    
    
    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
	
    if (!result) {
        // error occurred
    } 
	
}


- (void)receiveCommunication {
    
    // 타입에 따라 전문 처리를 변경 하여 준다.
    
//NSLog(@"all shared Member Data [%@]",model.sharedMemberList);
    
    if ( self.communication_flag == LOAD_DATA ) {
        // 목록 호출의 경우
        
        // 2가지 케이스가 있다. 1. 내 일정을 조회중 삭제 메소드가 호출되었을때. 2. 타인 일정 조회중 해당 타인을 삭제 하였을때.
        if ( isMyScheduleChecked ) {
            // 1. 테이블 리로드.
            [self.tableView1 reloadData];
            
        } else {
            // 타인 일정 조회중 삭제 된 케이스 이므로 일정 조회 목록 모델을 초기화 한다.
            // 1. 스케줄 목록 모델 초기화
            // 2. viewWillAppear 를 위해서 일정 재 호출 command
            // 3. 내 일정임을 알리기 위해서 Owner 를 내 정보로 대체.
            // 4. 내 일정 조회 마크후 테이블 갱신
            
            [model.scheduleListDic removeAllObjects];
            model.isNeedUpdateSelectedDate = YES;
            
            // 삭제된 사람에 마크가 있었다면.. 즉.. 테이블 데이터에 체크된.. SELECTED = Y 가 하나도 없다면.
            BOOL isMyFlag = YES;
            for ( NSMutableDictionary *checkdic in datasource ) {
                if ( [[checkdic notNilObjectForKey:@"SELECTED"] isEqualToString:@"Y"] ) {
                    isMyFlag = NO;
                }
            }
            if ( isMyFlag ) {
                model.scheduleOwnerInfo = nil;
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                model.scheduleOwnerInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"YES", @"isMy",
                                           [userDefault objectForKey:@"login_id"],@"loginid",
                                           NSLocalizedString(@"calendar_My_calendar",@"나의 일정"),@"empnm",
                                           @"",@"sharedemail",
                                           nil];
                
                [self myScheduleDidPush:self];
            }
            [self.tableView1 reloadData];
            
//            [self myScheduleDidPush:self];
//            // 테이블 안의 모든 데이터의 마크를 해재하고 데이터를 리프래시 한다.
//            for (NSMutableDictionary *dic in datasource) {
//                [dic setObject:@"N" forKey:@"SELECTED"];
//            }
//            [self.tableView1 reloadData];
            
                        
        }
        
    } else if ( self.communication_flag == CREATE_DATA ) {
        // 등록의 경우 -> calendarSearchMemnberView 에서 처리해야함. 
        
    } else if ( self.communication_flag == DELETE_DATA ) {
        // 삭제의 경우 - 데이터를 Reload 해야한다.
        
        self.communication_flag = LOAD_DATA;
        [self requestCommunication];
    }
    
    //self.communication_flag = 0;
    
    [self.tableView1 reloadData];
}

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    //--- indicator setting ---//
    BOOL isIndicator = YES;
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            isIndicator = NO;
        }
    }        
    if ( isIndicator ) {
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:indicator];
        indicator.center = self.view.center;
        [indicator startAnimating];
    }
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
    
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
    //NSLog(@"result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
    
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
		
        if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) { 
            // 정상 수신 완료.
            // 데이터 셋팅.
            [datasource removeAllObjects];
            [model.sharedMemberList removeAllObjects];
            
            if ( self.communication_flag == LOAD_DATA ) {
                for (NSMutableDictionary *dic in [_resultDic objectForKey:@"shareduserinfo"] ) { //수신된 데이터.
                    
                    // 일단 모델에 해당 값에 선택 겂이 있는지 체크한다. 
                    // 선택값이 있으면 선택값을 유지하고 없으면 N 셋팅한다.
                    if ( [[model.scheduleOwnerInfo notNilObjectForKey:@"isMy"] isEqualToString:@"NO"] ) {
                        
                        if ( [[model.scheduleOwnerInfo notNilObjectForKey:@"sharedemail"] isEqualToString:[dic notNilObjectForKey:@"email"]] ) {
                            // 타인 일정을 조회 중이다.
                            [dic setObject:@"Y" forKey:@"SELECTED"];
                            
                            selectMember = [dic copy]; //현재 선택된 타인 값을 담아 놓는다.
                            
                        }
                    } else {
                        [dic setObject:@"N" forKey:@"SELECTED"];
                    }
                    [model.sharedMemberList setObject:dic forKey:[dic notNilObjectForKey:@"otheruserid"]]; //딕셔너리..
                    [datasource addObject:dic];

                }
            }
        } else {
            // 데이터 없음.
        }
        [self receiveCommunication];
	}
    else if([rsltCode intValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic notNilObjectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
        }
    } 
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;

}



#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50;	// CalendarSearchMemberListCell.xib 에 설정된 height
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //NSLog(@"editingStyleForRowAtIndexPath [%@]", indexPath);
//    return UITableViewCellEditingStyleDelete;
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    //NSLog(@"canEditRowAtIndexPath [%@]", indexPath);
//    return YES;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	NSMutableDictionary *dictionary = [datasource objectAtIndex:indexPath.row];
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarMemberListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarMemberListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarMemberListCell *tmpCell = (CalendarMemberListCell *)cell;
	tmpCell.delegate = self;
	
	tmpCell.label1.text = [NSString stringWithFormat:@"%@%@",
						   [dictionary notNilObjectForKey:@"usernm"], NSLocalizedString(@"calendar_xxxs_calendar", @"님의 일정"), nil];
	
	tmpCell.button1.tag = indexPath.row;
	[tmpCell.button1 removeTarget:self action:@selector(checkButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
	[tmpCell.button1 addTarget:self action:@selector(checkButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
		//tmpCell.button1.hidden = YES;
    
	tmpCell.button2.tag = indexPath.row;
	[tmpCell.button2 removeTarget:self action:@selector(deleteButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
	[tmpCell.button2 addTarget:self action:@selector(deleteButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.button2.hidden = YES;
    
	if ([[dictionary notNilObjectForKey:@"SELECTED"] isEqualToString:@"Y"]) {
        //NSLog(@"%@ image selected YES ",[dictionary notNilObjectForKey:@"usernm"]);
		tmpCell.imageView1.image = [UIImage imageNamed:@"list_check.png"];
	} else if ([[dictionary notNilObjectForKey:@"SELECTED"] isEqualToString:@"N"]) {
        //NSLog(@"%@ image selected NO ",[dictionary notNilObjectForKey:@"usernm"]);
		tmpCell.imageView1.image = [UIImage imageNamed:@""];
	} else {
		tmpCell.imageView1.image = nil;
	}
    
// 이미지 목록.
//    	
// 1   dot_cyan_10
// 2   dot_gold_10
// 3   dot_green_10
// 4   dot_orange_10
// 5   dot_pink_10
// 6   dot_purple_10
// 7   dot_red_10
// 8   dot_white_10
// 9   dot_yellow_10
// 10  dot_deepblue_10
    
    //NSLog(@"row값[%d]나머지[%d]이미지명[%@]",indexPath.row, (indexPath.row %10), [dotImage objectAtIndex:(indexPath.row %10)]);
    
    tmpCell.image1.image = [UIImage imageNamed:[dotImage objectAtIndex:(indexPath.row %10)]];	
        
	return cell;
	
}

#pragma mark -
#pragma mark View Translation Process

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
//	[datasource removeAllObjects];
//	
//	// TODO: 전문에서 받아온 리스트를 먼저 datasource에 붙인다.
//	
//	// 다른사람 검색에서 받아온 리스트를 붙여준다. (소트하고 싶으면 allKeys로 받아온 NSArray를 소트하면 됨)
//	for (NSString *strID in [model.sharedMemberList allKeys]) {
//		
//        //NSLog(@"allKeys strID [%@]", strID);
//        
//        NSMutableDictionary *dic = [model.sharedMemberList objectForKey:strID];
//		[dic setObject:@"N" forKey:@"SELECTED"];
//		[datasource addObject:dic];
//	}
//	
//	[self.tableView1 reloadData];
    
    //NSLog(@"scheduleOwnerInfo [%@]", model.scheduleOwnerInfo);
    
    if ( [[model.scheduleOwnerInfo objectForKey:@"isMy"] isEqualToString:@"YES"] ) {
        //나의 일정이다.
        [self myScheduleDidPush:self];
    } else {
        isMyScheduleChecked = NO;
        self.imageView1.image = nil;
    }
    
    // 위 구문을 타지 말고 (search에서 안담길수 있으므로)
    // 여기서 통신을 다시 태워야 한다.
    // 그리고.. 임직원 키 값과.. 익스체인지 키 값이 서로 상이하다..
    self.communication_flag = LOAD_DATA;
    [self requestCommunication];
}

#pragma mark -
#pragma mark XCode Genreated
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

- (void)viewWillDisappear:(BOOL)animated {
    if (clipboard != nil) {
		[clipboard cancelCommunication];
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = NSLocalizedString(@"calendar_calendar_view",@"캘린더 보기");
    
    self.myLabel.text = NSLocalizedString(@"calendar_My_calendar", @"나의일정");
    self.memberLabel.text = NSLocalizedString(@"calendar_open_others_calendar", @"공개된 다른사람 일정");
    
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	// 내비게인션 왼쪽 버튼
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];
	
	// 왼쪽 홈 버튼
	[super makeNavigationRightBarButtonWithBarButtonSystemItem:UIBarButtonSystemItemSearch];
	
	datasource = [[NSMutableArray alloc] initWithCapacity:0];
	selectMember= [[NSMutableDictionary alloc] init];

	
	model = [CalendarModel sharedInstance];
	
    //NSLog(@"view did load finish");
    
    
    
    self.clipboard = nil;
    
    CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    
    
    // 1   dot_cyan_10
    // 2   dot_gold_10
    // 3   dot_green_10
    // 4   dot_orange_10
    // 5   dot_pink_10
    // 6   dot_purple_10
    // 7   dot_red_10
    // 8   dot_white_10
    // 9   dot_yellow_10
    // 10  dot_deepblue_10
    
    dotImage = [[NSArray alloc] initWithObjects:
                @"dot_cyan_10",
                @"dot_gold_10",
                @"dot_green_10",
                @"dot_orange_10",
                @"dot_pink_10",
                @"dot_purple_10",
                @"dot_red_10",
                @"dot_white_10",
                @"dot_yellow_10",
                @"dot_deepblue_10",
                                nil];
    
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
	self.imageView1 = nil;	// 나의 일정 체크버튼
	self.imageView2 = nil;	// 공개된 다른사람 일정 백그라운드
	self.tableView1 = nil;	// 맴버리스트
}


- (void)dealloc {
	
	// UI
	[imageView1 release];	// 나의 일정 체크버튼
	[imageView2 release];	// 공개된 다른사람 일정 백그라운드
	[tableView1 release];	// 맴버리스트
	
    [myLabel release];
    [memberLabel release];
    
	[datasource release];
	[selectMember release];
    
    [super dealloc];
}


@end

//
//  CalendarSearchMemberViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 20..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarSearchMemberViewController.h"
#import "ContactMainListCell.h"
#import "NSDictionary+NotNilReturn.h"
#import "URL_Define.h"
@implementation CalendarSearchMemberViewController

@synthesize tableView1;

@synthesize searchBar;
@synthesize indicator;
@synthesize clipboard;
@synthesize communication_flag;

@synthesize now_page, result_totalCount, result_totalPage, mode_nextCell;

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
	
        
	NSString *rsltCode = [resultDic objectForKey:@"code"];
  
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
        
		if ( self.communication_flag == LOAD_DATA ) {
            //목록 조회의 경우
            if (datasource == nil) {
                datasource = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            if ( [[_resultDic objectForKey:@"count"] intValue] > 0 ) { 
                
                //공유 사용자 목록을 담는다.
                [datasource addObjectsFromArray:[_resultDic objectForKey:@"userinfo"]];
                self.tableView1.editing = YES;
                
            } else {
                
                // 여기다 코드를 넣자.. 한건도 없으면.. 등록 검색된 내용이 없다고.
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"-",@"-",nil];
                [datasource addObject:dic];
                self.tableView1.editing = NO;
                
            }
            //목록 조회시 페이징 체크를 한다.
            //사용값. totalcount, totalpage
            self.result_totalCount = [[resultDic notNilObjectForKey:@"totalcount"] intValue];
            self.result_totalPage = [[resultDic notNilObjectForKey:@"totalpage"] intValue];
            
            if ( self.now_page < self.result_totalPage ) {
                self.now_page++;
                self.mode_nextCell = YES;
            } else {
                self.mode_nextCell = NO;
            }
            //NSLog(@"%d-%d-%d nextcell[%@]",self.result_totalCount , self.result_totalPage, [[_resultDic objectForKey:@"count"] intValue], self.mode_nextCell?@"YES":@"NO");
            
            [self.tableView1 reloadData];
            
        } else if ( self.communication_flag == CREATE_DATA ) {
            //데이터 생성의 경우
            [self responseCommunication];
        }
        
	} else if([rsltCode intValue] == 1) {
        
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
}

#pragma mark -
#pragma mark CallBack Method
- (void)closepop {
    [self popViewController];
    
}


- (void)responseCommunication {
    //통신 처리가 완료되면 팝업을 종료한다.
    [self closepop];
}

- (void)requestCommunication {
    
    self.communication_flag = CREATE_DATA;
    
    //저장 통신을 타자.
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    NSString *callUrl = @"";
    callUrl = URL_createSharedUserInfo;
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];

    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *login_id_arr = @"";
    NSString *empno_arr = @"";
    NSString *empnm_arr = @"";
    NSString *email_arr = @"";
    
    
    for (NSString *strID in [selectData allKeys]) {
		
        
        NSMutableDictionary *dic = [selectData objectForKey:strID];

//        userid		사용자아이디
//        otheruserid	공유사용자아이디
//        usernm		사용자이름
//        email         이메일주소
//        [requestDictionary setObject:[userDefault objectForKey:@"login_id"] forKey:@"userid"];
//        [requestDictionary setObject:[dic notNilObjectForKey:@"empno"] forKey:@"otheruserid"];
//        [requestDictionary setObject:[dic notNilObjectForKey:@"empnm"] forKey:@"usernm"];
//        [requestDictionary setObject:[dic notNilObjectForKey:@"email"] forKey:@"email"];
        
        if ([login_id_arr isEqualToString:@""]) {
            login_id_arr = [userDefault objectForKey:@"login_id"];
            empno_arr = [dic notNilObjectForKey:@"empno"];
            empnm_arr = [dic notNilObjectForKey:@"empnm"];
            email_arr = [dic notNilObjectForKey:@"email"];
        } else {
            login_id_arr = [NSString stringWithFormat:@"%@; %@", login_id_arr, [userDefault objectForKey:@"login_id"]];
            empno_arr = [NSString stringWithFormat:@"%@; %@", empno_arr, [dic notNilObjectForKey:@"empno"]];
            empnm_arr = [NSString stringWithFormat:@"%@; %@", empnm_arr, [dic notNilObjectForKey:@"empnm"]];
            email_arr = [NSString stringWithFormat:@"%@; %@", email_arr, [dic notNilObjectForKey:@"email"]];
        }
	}
    
    [requestDictionary setObject:login_id_arr forKey:@"userid"];
    [requestDictionary setObject:empno_arr forKey:@"otheruserid"];
    [requestDictionary setObject:empnm_arr forKey:@"usernm"];
    [requestDictionary setObject:email_arr forKey:@"email"];

    if ( [[selectData allKeys] count] > 0 ) {
    
        BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
        
        if (!result) {
            // error occurred
        } 
    
    } else {
        [self closepop];
    }
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 9876) {
		//[self popViewController]; // 선택완료시 메시지가 있을경우.
        //선택한 값을 저장하는 통신을 호출 한다.
        [self requestCommunication];
	}
}
- (void)naviRigthbtnPress:(id)sender {
	NSLog(@"model.sharedMemberList [%@]", model.sharedMemberList);
    //초기화.
    [selectData removeAllObjects];
    
    // 모델값과 선택된 값을 확인하여 담을지 얼랏을 띄울지 확인한다. 키값은 loginid 이다.
    NSString *selectMemberCheckStr = @""; 
    
    NSMutableArray *arrTemp = nil;
    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *selectItem = [[self.tableView1 indexPathsForSelectedRows] copy];
    NSUInteger i, count = [selectItem count];
    for (i = 0; i < count; i++) {
        NSIndexPath * obj = [selectItem objectAtIndex:i];
        
        //NSLog(@"selected item [%@][%@]",obj,[[self.contactList objectAtIndex:obj.row] objectForKey:@"fullname"]);
        NSMutableDictionary *dic = [datasource objectAtIndex:obj.row];
        
        // 여기서 기존 모델과 값을 비교한다.
        // 기존 모델에 있으면 체크섬 넣어주고 없으면 SELECTED 에 N값을 추가해서 재 배열 한다.
        if ( [model.sharedMemberList objectForKey:[dic notNilObjectForKey:@"loginid"]] == nil ) {
            
            [selectData setObject:dic forKey:[dic notNilObjectForKey:@"loginid"]];
            
            
        } else {
            if ( [selectMemberCheckStr isEqualToString:@""] ) {
                selectMemberCheckStr = [dic notNilObjectForKey:@"empnm"];
            } else {
                selectMemberCheckStr = [NSString stringWithFormat:@"%@, %@",selectMemberCheckStr, [dic notNilObjectForKey:@"empnm"]];
            }
        }
    }
    
    //결과가 완료되면 model.sharedMemberList 에 Dictionary 로 값을 넣어주자    
    // 여기서 팝뷰를 호출 하지 말고 .. 통신이 완료된 이후에 팝뷰를 호출 하자.
    if ( ![selectMemberCheckStr isEqualToString:@""] ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@.",selectMemberCheckStr, NSLocalizedString(@"calendar_xx_percent_has_already_been_registered",@"은 이미 등록되어있습니다")]
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        
        alert.tag = 9876; // 임시로 팝 뷰 막음.
        [alert show];
        [alert release];        
        return;	
        
    } else {
        //선택한 값을 저장하는 통신을 호출 한다.
        [self requestCommunication];
    }
    
}

- (void)backButtonDidPush:(id)sender {
    // 취소
	[self popViewController];
}


#pragma mark -
#pragma mark UISearchBarDelegate Implement
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *tempString = [self.searchBar.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];

//    NSString *searchText = self.searchBar.text;
    
//    //NSLog(@"search button clicked = [%@]", searchText);
    
    // 검색어로 임직원 데이터를 호출 한다.
    if ([tempString length] < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다.") 
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        self.communication_flag = LOAD_DATA;
        
        [datasource removeAllObjects];
        self.result_totalPage = 0;
        self.result_totalCount = 0;
        self.mode_nextCell = NO;
        self.now_page = 1;
        
        
        // 검색어로 임직원 데이터를 호출 한다.
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        [requestDictionary setObject:tempString forKey:@"overall"]; //통합검색 키워드.
        [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
        [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
        BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
        if (!result) {
            // error occurred
        }
        
    }
    [self.searchBar resignFirstResponder];
}

-(void)action_nextCell:(id)sender {
    //[self searchBarSearchButtonClicked:self.searchBar];
    
    NSString *searchText = self.searchBar.text;

    self.communication_flag = LOAD_DATA;
    
    // 검색어로 임직원 데이터를 호출 한다.
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [requestDictionary setObject:searchText forKey:@"overall"]; //통합검색 키워드.
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
    if (!result) {
        // error occurred
    }
}



#pragma mark -
#pragma mark UITableViewDelegate Implement
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {  
    if( self.mode_nextCell && (indexPath.row == [datasource count]) ) {
        return 0;
    } else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if( self.mode_nextCell && (indexPath.row == [datasource count]) ) {
        return 66.0; // 더보기 셀이 있음.
    } else {
        return 44.0;	// CalendarSearchMemberListCell.xib 에 설정된 height
	}
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( self.mode_nextCell ) {
        return [datasource count]+1;
    } else {
        return [datasource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	
	UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
    
    if( self.mode_nextCell && (indexPath.row == [datasource count]) ) {
        //더보기.
		cell = nextCell;
        
	} else {
        
        if (cell == nil) {
            NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ContactMainListCell" owner:self options:nil];
            cell = [topObject objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // Configure the cell...
        NSMutableDictionary *dic = [datasource objectAtIndex:indexPath.row];
        
        
        NSString *label1Text = @"";
        NSString *label2Text = @"";
        NSString *label3Text = @"";
        
        ContactMainListCell *tmpCell = (ContactMainListCell *)cell;
        if ( [[dic notNilObjectForKey:@"-"] isEqualToString:@"-"] ) {
            tmpCell.label1.text = NSLocalizedString(@"contact_no_results",@"결과없음");
            tmpCell.label2.hidden = YES;
            tmpCell.label3.hidden = YES;
            tmpCell.label4.hidden = YES;
            tmpCell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            label1Text = [NSString stringWithFormat:@"%@ %@", [dic notNilObjectForKey:@"empnm"], [dic notNilObjectForKey:@"title"]];
            tmpCell.label1.text = label1Text;
            label2Text = [dic notNilObjectForKey:@"orgnm"];
            tmpCell.label2.text = label2Text;
            label3Text = [dic notNilObjectForKey:@"companynm"];
            tmpCell.label3.text = label3Text;
            tmpCell.label4.hidden = YES;
        } 
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
        
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

- (void)viewWillDisappear:(BOOL)animated {
    if (clipboard != nil) {
		[clipboard cancelCommunication];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 내비게인션 왼쪽 버튼
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonItemStylePlain];
	
	// 내비게인션 오른쪽 버튼
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];

	
	model = [CalendarModel sharedInstance];
    contactModel = [ContactModel sharedInstance];
    
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    
    self.title = NSLocalizedString(@"calendar_view_others_calendar",@"다른사람 일정보기");
    
//  타인 일정 조회 대상 맴버 목록을 호출한다.    
//    [self loadData]; //검색후 조회 되어야 한다. 페이징 들어갈것.
  
    
    
	//selectedMember = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // 데이터 저장용...
	selectData = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    self.searchBar.placeholder = NSLocalizedString(@"calendar_integrative_search",@"통합검색");
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
	[selectData release];
    
    [super dealloc];
}


@end

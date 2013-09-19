//
//  ContactSearchResultViewController.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 15..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactSearchResultViewController.h"
#import "URL_Define.h"
#import "ContactMainListCell.h"
#import "ContactDetailViewController.h"
#import "NSMutableArray+QueueAdditions.h"
#import "NSDictionary+NotNilReturn.h"
#import "ContactFunction.h"

@implementation ContactSearchResultViewController


@synthesize param; //검색어 파라메터 

@synthesize contactList; //테이블 뷰 에 가공될 연락처 목록
@synthesize indicator; //인디케이터
@synthesize clipboard; //통신모듈

@synthesize dataTable;

@synthesize searchOptionStr;

@synthesize now_page, result_totalCount, result_totalPage, mode_nextCell;




#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( self.mode_nextCell && (indexPath.row == [self.contactList count]) ) {
        return 66.0; // 더보기 셀이 있음.
    } else {
        return 44.0;	// CalendarSearchMemberListCell.xib 에 설정된 height
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.mode_nextCell ) {
        return [self.contactList count]+1;
    } else {
        return [self.contactList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if( self.mode_nextCell && (indexPath.row == [self.contactList count]) ) {
        //더보기.
		cell = nextCell;
        
	} else {
        
        if (cell == nil) {
            
            NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ContactMainListCell" owner:self options:nil];
            cell = [topObject objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        // Configure the cell...
        NSDictionary *dic = [self.contactList objectAtIndex:indexPath.row];
        
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
            
            label1Text = [NSString stringWithFormat:@"%@ %@",[dic notNilObjectForKey:@"empnm"], [dic notNilObjectForKey:@"title"]];
            tmpCell.label1.text = label1Text;
            label2Text = [dic notNilObjectForKey:@"orgnm"];
            tmpCell.label2.text = label2Text;
            label3Text = [dic notNilObjectForKey:@"companynm"];
            tmpCell.label3.text = label3Text;
            
            tmpCell.label4.hidden = YES;
        }  
        
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSMutableDictionary *dic = [self.contactList objectAtIndex:indexPath.row];
    
        //내 연락처 상세 정보 호출.
        self.navigationController.navigationBar.hidden = NO;
        
        ContactDetailViewController *detail = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
        [self.navigationController pushViewController:detail animated:YES];
        //[(ContactDetailViewController *)tmpController loadData];	//파라메터 처리하자.
        [detail loadDetail:dic forCallType:@"member"];
        [detail release];
        [dataTable deselectRowAtIndexPath:indexPath animated:YES];
        
    
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
	
    //NSLog(@"PaymentListController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
    
	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
		
        //self.result_totalPage = [[resultDic objectForKey:@"totalpage"] intValue];
		//self.result_totalCount = [[resultDic objectForKey:@"totalcount"] intValue];
        
        if ( [[_resultDic objectForKey:@"count"] intValue] > 0 ) { 
            
            
            //버튼 인덱스에 따라 값을 달리준다.
            
            //이건 내 연락처 부분
            [self.contactList addObjectsFromArray:[_resultDic objectForKey:@"userinfo"]];
            
            
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
            
            [self.dataTable reloadData];
            
            
        } else {
            
            // 여기다 코드를 넣자.. 한건도 없으면.. 등록 검색된 내용이 없다고.
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"-",@"-",nil];
            [self.contactList addObject:dic];
            [self.dataTable reloadData];
        }
        
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

-(void) loadData {
    
    // call comunicate method
    NSString *callUrl = @"";
    
    // 임직원 연락처
    callUrl = URL_getUserInfo;
        
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    //sleep(2);
    // make request object
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];

    //최초로드이다.
    self.now_page = 1;
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
    
    
    //검색 조건 리스트
//    [name           release];
//	[department     release];
//	[jobtitle       release];
//	[chargedwork    release];
//	[homephone      release];
//	[mobilephone    release];
//	[companyname    release];
    
    
    NSString *strSearchOptionList = @"";
    
    if ( ![[param notNilObjectForKey:@"name"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"name"] forKey:@"empnm"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_name",@"이름");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_name",@"이름")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"department"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"department"] forKey:@"orgnm"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_department",@"부서");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_department",@"부서")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"jobtitle"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"jobtitle"] forKey:@"title"];    
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_position",@"직위");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_position",@"직위")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"chargedwork"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"chargedwork"] forKey:@"job"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_charge_at_work",@"담당업무");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_charge_at_work",@"담당업무")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"homephone"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"homephone"] forKey:@"telno"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_phone_number",@"전화번호");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_phone_number",@"전화번호")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"mobilephone"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"mobilephone"] forKey:@"mobileno"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_cell_phone_number",@"휴대폰");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_cell_phone_number",@"휴대폰")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"companynm"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"companynm"] forKey:@"companynm"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_company",@"회사");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_company",@"회사")];
        } 
    }
    if ( ![[param notNilObjectForKey:@"companycd"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"companycd"] forKey:@"companycd"];
        if ([strSearchOptionList isEqualToString:@""]) {
            strSearchOptionList = NSLocalizedString(@"contact_company",@"회사");
        } else {
            strSearchOptionList = [NSString stringWithFormat:@"%@ and %@", strSearchOptionList, NSLocalizedString(@"contact_company",@"회사")];
        } 
    }
    self.searchOptionStr.text = strSearchOptionList;
        
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
        
    if (!result) {
        // error occurred
    }
	
}

-(void)action_nextCell:(id)sender {
    //[self searchBarSearchButtonClicked:self.searchBar];
    
    // 검색어로 임직원 데이터를 호출 한다.
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    //검색어.
    if ( ![[param notNilObjectForKey:@"name"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"name"] forKey:@"empnm"];
    }
    if ( ![[param notNilObjectForKey:@"department"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"department"] forKey:@"orgnm"];
    }
    if ( ![[param notNilObjectForKey:@"jobtitle"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"jobtitle"] forKey:@"title"];    
    }
    if ( ![[param notNilObjectForKey:@"chargedwork"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"chargedwork"] forKey:@"job"];
    }
    if ( ![[param notNilObjectForKey:@"homephone"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"homephone"] forKey:@"telno"];
    }
    if ( ![[param notNilObjectForKey:@"mobilephone"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"mobilephone"] forKey:@"mobileno"];
    }
    if ( ![[param notNilObjectForKey:@"companynm"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"companynm"] forKey:@"companynm"];
    }
    if ( ![[param notNilObjectForKey:@"companycd"] isEqualToString:@""] ) {
        [requestDictionary setObject:[param notNilObjectForKey:@"companycd"] forKey:@"companycd"];
    }
    
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
    if (!result) {
        // error occurred
    }
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)dealloc
{
    
    [param release]; //검색어 파라메터 
    [contactList release]; //테이블 뷰 에 가공될 연락처 목록
    [indicator release]; //인디케이터
    [clipboard release]; //통신모듈
    [dataTable release];
    [searchOptionStr release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillDisappear:(BOOL)animated {
    //	refreshButton.enabled = YES;
    
	[indicator stopAnimating];
	
	if (clipboard != nil) {
		[clipboard cancelCommunication];
	}	
	
	[super viewWillDisappear:animated];
	
}
- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"contact_search_result",@"검색결과");
    
    
    self.contactList = [[NSMutableArray alloc] init];
    
    self.dataTable.delegate = self;
	self.dataTable.dataSource = self;
    
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    
    
    //view 가 로드될때 검색 결과 목록을 Load 한다.
    self.clipboard = nil;
    self.contactList = [[NSMutableArray alloc] init];
    [self loadData];
    
    
    
    //검색어 옵션을 표현한다.
    // -> loadData 에서 표현 같이 처리한다.
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end

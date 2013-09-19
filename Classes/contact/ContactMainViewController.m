//
//  ContactMainViewController.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 13..
//  Copyright 2011 infoTM. All rights reserved.
//


////임직원 목록 정보 (페이징 있음)
//loginid : 사번
//empno : 사번
//empnm : 사원명
//companycd : 회사코드
//companynm : 회사명
//orgcd : 부서코드
//orgnm : 부서명
//title : 직위
//email : 이메일
//telno : 사무실전화
//mobileno : 이동전화
//job : 담당업무
//manageryn : 관리자 여부

//// 내 연락처 목록 정보 
//contactid : 연락처아이디
//fullname : 이름
//jobtitle : 직위
//department : 부서
//companyname : 회사명
//emailaddress : 이메일주소

//// 폰북 목록 정보
//fullname : 이름
//mobile : 모바일폰
//iphone : 아이폰
//home : 집전화
//email : 이메일


#import "ContactMainViewController.h"
#import "ContactData.h"
#import "ContactSearchViewController.h"
#import "URL_Define.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ContactMainListCell.h"
#import "CalendarSearchMemberListCell.h"
#import "ContactDetailViewController.h"
#import "NSMutableArray+QueueAdditions.h"
#import "NSDictionary+NotNilReturn.h"
#import "ContactFunction.h"
#import "MobileKate2_0_iPadAppDelegate.h"
@implementation ContactMainViewController


@synthesize dataTable;
@synthesize indicator;
@synthesize clipboard;

@synthesize searchButton;               //임직원의 경우만 상세검색 가능.
@synthesize searchBar;                  //모든 데이터에 대한 통합검색.
@synthesize button1, button2, button3;  //1:임직원, 2:내연락처, 3:폰북
@synthesize label1, label2, label3;
@synthesize data1, data2, data3;        //1:임직원, 2:내연락처, 3:폰북

@synthesize contactList; //테이블뷰 사용용 연락처 목록.

@synthesize delegate_flag, memberSearch_flag;

@synthesize now_page, result_totalCount, result_totalPage, mode_nextCell;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
    
}


#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    self.button1.enabled = NO;
    self.button2.enabled = NO;
    self.button3.enabled = NO;

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
    self.button1.enabled = YES;
    self.button2.enabled = YES;
    self.button3.enabled = YES;

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
        
        BOOL dataOk = NO;
        if ( self.button1.selected ) {
            if ( [[_resultDic objectForKey:@"count"] intValue] > 0 ) {
                dataOk = YES;
            }
        } else if ( self.button2.selected ) { 
            if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) {
                dataOk = YES;
            }
        }
        
        
        if ( dataOk ) { 
            
            //버튼 인덱스에 따라 값을 달리준다.
            if ( self.button1.selected ) {
                //여기는 임직원 연락처 부분
                
                if ( self.memberSearch_flag ) {
                    //임직원 내부 검색 데이터 이다.
                    [self.contactList removeAllObjects];
                    [self.contactList addObjectsFromArray:[_resultDic objectForKey:@"userinfo"]];                    
                } else {
                    [self.contactList addObjectsFromArray:[_resultDic objectForKey:@"userinfo"]];
                    // 모델에 값 저장할때 add 해주어야 한다.
                    //이건 수신값 Add 하는거 [[model.contactListDic objectForKey:@"member"] addObjectsFromArray:[_resultDic objectForKey:@"userinfo"]];
                    //이건 최종값 Add하는거 [model.contactListDic setObject:[_resultDic objectForKey:@"userinfo"] forKey:@"member"];
                    //이건 현재 테이블값 Add 하는거
                    
                    //[model.contactListDic setObject:[self.contactList copy] forKey:@"member"];
                    //모델에 값을 저장하지 말고 포커스 올때마다 처리하자.
                    self.data1 = [self.contactList copy];
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
                
                [self.dataTable reloadData];
                
            } else if ( self.button2.selected ) {
                //이건 내 연락처 부분
                self.contactList = nil;
                self.contactList = [[NSMutableArray alloc] init];
                [model.contactListDic setObject:[_resultDic objectForKey:@"contactitemlist"] forKey:@"my"];
                [self.contactList addObjectsFromArray:[model.contactListDic objectForKey:@"my"]];   
                //NSLog(@"contactList[%@]",self.contactList);
                [self.dataTable reloadData];
            }
            
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
    self.button1.enabled = YES;
    self.button2.enabled = YES;
    self.button3.enabled = YES;

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



#pragma mark - Table view commend
// 체크박스 위 버튼 - 사용하지 않으려함.
- (void)checkButtonDidPush:(id)sender {
	
    NSMutableDictionary *dic = [self.contactList objectAtIndex:[sender tag]];
	
    if ( [[dic notNilObjectForKey:@"SELECTED"] isEqualToString:@""] ) [dic setObject:@"N" forKey:@"SELECTED"];
    
	if ([[dic notNilObjectForKey:@"SELECTED"] isEqualToString:@"N"]) {
		[dic setObject:@"Y" forKey:@"SELECTED"];
        
        NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [dic notNilObjectForKey:@"fullname"], @"title", 
                                   [dic notNilObjectForKey:@"fullname"], @"email", nil];
        
        [selectedMember setObject:resultDic forKey:[dic notNilObjectForKey:@"contactid"]];
        
        
        //NSLog(@"checkButtonDidPush [%@][%@]",[dic notNilObjectForKey:@"contactid"],[selectedMember objectForKey:[dic notNilObjectForKey:@"contactid"]]);
        
	} else {
		[dic setObject:@"N" forKey:@"SELECTED"];
		[selectedMember removeObjectForKey:[dic notNilObjectForKey:@"contactid"]];
	}
	NSLog(@"row reload");
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	[self.dataTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] 
						   withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.button1.selected ) {
        
        if( self.mode_nextCell ) {
            return [self.contactList count]+1;
        }        
        
    } else {
         
    }
    
    return [self.contactList count];  
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {  
//  if(dataTable.editing) {
//		return 3;
//	} else {
// 	return UITableViewCellEditingStyleDelete;
//	}
    if( self.mode_nextCell && (indexPath.row == [self.contactList count]) ) {
        return UITableViewCellEditingStyleNone;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //임시처리.. 로직 더 넣어주셈.
    if ( !self.button1.selected ) self.mode_nextCell = NO;
    
    
    
    if( self.mode_nextCell && (indexPath.row == [self.contactList count]) ) {
		
        cell = nextCell;
        
	} else {
        
        if (cell == nil) {
            NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"ContactMainListCell" owner:self options:nil];
            cell = [topObject objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // Configure the cell...
        NSMutableDictionary *dic = [self.contactList objectAtIndex:indexPath.row];
        
        NSString *label1Text = @"";
        NSString *label2Text = @"";
        NSString *label3Text = @"";
        NSString *label4Text = @"";
        
        ContactMainListCell *tmpCell = (ContactMainListCell *)cell;
        if ( self.button1.selected ) { // 임직원
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
        } else if ( self.button2.selected ) { //내 연락처.
            if ( [[dic notNilObjectForKey:@"-"] isEqualToString:@"-"] ) {
                tmpCell.label1.text = NSLocalizedString(@"contact_no_results",@"결과없음");
                tmpCell.label2.hidden = YES;
                tmpCell.label3.hidden = YES;
                tmpCell.label4.hidden = YES;
                tmpCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                label1Text = [NSString stringWithFormat:@"%@ %@",[dic notNilObjectForKey:@"fullname"], [dic notNilObjectForKey:@"jobtitle"]];
                tmpCell.label1.text = label1Text;
                label2Text = [dic notNilObjectForKey:@"department"];
                tmpCell.label2.text = label2Text;
                label3Text = [dic notNilObjectForKey:@"companyname"];
                tmpCell.label3.text = label3Text;
                tmpCell.label4.hidden = YES;
            }
        } else if ( self.button3.selected ) { //폰북
            if ( [[dic notNilObjectForKey:@"-"] isEqualToString:@"-"] ) {
                tmpCell.label1.text = NSLocalizedString(@"contact_no_results",@"결과없음");
                tmpCell.label2.hidden = YES;
                tmpCell.label3.hidden = YES;
                tmpCell.label4.hidden = YES;
                tmpCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                label1Text = [dic notNilObjectForKey:@"fullname"];
                tmpCell.label1.text = label1Text;
                label4Text = [dic notNilObjectForKey:@"mobile"];
                tmpCell.label4.text = label4Text;
                tmpCell.label2.hidden = YES;
                tmpCell.label3.hidden = YES;
            }
        } else {
            //NSLog(@"no detect button index");
        }
        
        if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
            
            tmpCell.accessoryType = UITableViewCellAccessoryNone;
            
        } 
        
    }
        
    return cell;
    
}

//더보기
-(void)action_nextCell:(id)sender {
    
    // 검색어로 임직원 데이터를 호출 한다.
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    clipboard.ignoreTimer = YES;
    
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    //로그인시 받아온 조직 코드를 입력한다.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *organizationid = [userDefault objectForKey:@"login_organizationid"];
    
    // 테스트를 위해 임시로 조직 코드 막음.
    //[requestDictionary setObject:organizationid forKey:@"orgcd"];//organizationid
    
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
    [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
    if (!result) {
        // error occurred
    }
    
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( self.mode_nextCell && (indexPath.row == [self.contactList count]) ) {
        return 66.0; // 더보기 셀이 있음.
    } else {
        return 44.0;	// CalendarSearchMemberListCell.xib 에 설정된 height
	}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSMutableDictionary *dic = [self.contactList objectAtIndex:indexPath.row];
    
    if ( [[dic objectForKey:@"-"] isEqualToString:@"-"] ) {
        // 결과 없음...
        
    } else {
        if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
            //NSLog(@"메일, 초대 검색. clicked[%@]",indexPath);
            //메일, 초대 등에서 연락처 검색시
        } else {
            
            if ( self.button1.selected ) {
                //임직원 상세 정보 호출.
                self.navigationController.navigationBar.hidden = NO;
                
                ContactDetailViewController *detail = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
                [self.navigationController pushViewController:detail animated:YES];
                //[(ContactDetailViewController *)tmpController loadData];	//파라메터 처리하자.
                [detail loadDetail:dic forCallType:@"member"];
                [detail release];
                [dataTable deselectRowAtIndexPath:indexPath animated:YES];
                
            } else if ( self.button2.selected ) {
                //내 연락처 상세 정보 호출.
                self.navigationController.navigationBar.hidden = NO;
                
                ContactDetailViewController *detail = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
                [self.navigationController pushViewController:detail animated:YES];
                //[(ContactDetailViewController *)tmpController loadData];	//파라메터 처리하자.
                [detail loadDetail:dic forCallType:@"my"];
                [detail release];
                [dataTable deselectRowAtIndexPath:indexPath animated:YES];
                
            } else if ( self.button3.selected ) {
                [self personView:[dic notNilObjectForKey:@"recordId"]];
            }
            
        }
        
    }
    
    
}


#pragma mark - load datas

-(void)loadAddressBook {
    
    //[self.contactList removeAllObjects];
    self.contactList = nil;
    self.contactList = [[NSMutableArray alloc] init];
    [self.dataTable reloadData];
    
    self.data3 = nil;
    self.data3 = [model getAddressData:@"phonebook"];
    
    NSString *recordId = @"";
    NSMutableArray *array = data3;
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fName,@"firstName",lName,@"lastName",mobile,@"mobile",iphone,@"iphone",home,@"home",nil];
//NSLog(@"contact mainView recordId[%@]fullname[%@]mobile[%@]iphone[%@]home[%@]email[%@]", 
//              [dic objectForKey:@"recordId"],
//              [dic objectForKey:@"fullname"], 
//              [dic objectForKey:@"mobile"],
//              [dic objectForKey:@"iphone"],
//              [dic objectForKey:@"home"],
//              [dic objectForKey:@"email"]);
        
        recordId = [dic objectForKey:@"recordId"];
    }
    
    self.contactList = self.data3;
    [self.dataTable reloadData];
    //[self personView:recordId];
}

-(void) personView:(NSString *)recordId {
    ABAddressBookRef addressBook = ABAddressBookCreate();
	
	ABPersonViewController *personView = [[ABPersonViewController alloc] init];
	personView.personViewDelegate = self;
	
	ABRecordID recID = (ABRecordID)[recordId intValue];
	personView.displayedPerson = ABAddressBookGetPersonWithRecordID(addressBook, recID);
	personView.allowsEditing = YES;
	personView.title = NSLocalizedString(@"contact_phonebook_information",@"폰북 정보");
	if (personView.displayedPerson != NULL) {
		[self.navigationController pushViewController:personView animated:YES];
		[personView release];
	}
}

-(void) loadData {
	// call comunicate method
    NSString *callUrl = @"";
    BOOL loadFlag = YES;
    
    //[self.contactList removeAllObjects];
    self.contactList = nil;
    self.contactList = [[NSMutableArray alloc] init];
    [self.dataTable reloadData];
    
    if ( self.button1.selected ) {
        //NSLog(@"loadData button1");
          // 임직원
        callUrl = URL_getUserInfo;
        
        // 데이터 유무를 판별하고 통신 유무를 체크한다.
        self.data1 = nil;
        self.data1 = [model getAddressData:@"member"];
        
        if ( [self.data1 count] > 0 ) {
            loadFlag = NO;
            self.contactList = self.data1;
        }         
    } else if ( self.button2.selected ) {
        //NSLog(@"loadData button2");
        // 내 연락처
        callUrl = URL_getContactInfoList;
        
        // 데이터 유무를 판별하고 통신 유무를 체크한다.
        self.data2 = nil;
        self.data2 = [model getAddressData:@"my"];
        
        if ( [self.data2 count] > 0 ) {
            loadFlag = NO;
            self.contactList = self.data2;
        } 
    }
    //callUrl = URL_getContactInfoList;
    
    if ( loadFlag ) { 
        //--- cancel previous communication caused by 30sec timeout thread
        if(clipboard != nil)
            [clipboard cancelCommunication];
        
        //무조건 두건 이상의 통신을 하나의 객체에 할당하기 위해서는 이전 통신을 끊어주고 돌려야 한다.
        //안그럼 이전 쓰레드가 참조할 객체를 잃고 앱이 죽는다.
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        clipboard.ignoreTimer = YES;
        
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        if ( self.button1.selected ) {
           
            self.now_page = 1; // 여기는 무조건 최초 조회 이다.
            
            //로그인시 받아온 조직 코드를 입력한다.
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *organizationid = [userDefault objectForKey:@"login_organizationid"];
            
            // 테스트를 위해 임시로 조직 코드 막음.
            [requestDictionary setObject:organizationid forKey:@"orgcd"];//organizationid
            
            
            //페이징을 위해서 쿼리 카운트 값을 던진다.
            [requestDictionary setObject:[NSString stringWithFormat:@"%d", PAGE_COUNT] forKey:@"rows"];
            [requestDictionary setObject:[NSString stringWithFormat:@"%d", self.now_page] forKey:@"page"];
            
        }
        
        
        BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
	
        if (!result) {
            // error occurred
		}
	} else {
        [self.dataTable reloadData];
    }
}



#pragma mark - tabbar command
-(void)resetData {
    
    searchBar.text = @"";
    
    if ( self.button1.selected ) {
        //임직원은 모델에 저장하지 않는다.
    } else if ( self.button2.selected ) {
        self.contactList = [model.contactListDic objectForKey:@"my"];
    } else if ( self.button3.selected ) {
        self.contactList = [model.contactListDic objectForKey:@"phonebook"];
    }
    
    [self.dataTable reloadData];
    
    
}
-(void)defaultSettingViewMode:(int)tab {
    
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;
    
    if (tab == 1 ) {
        if ( self.delegate_flag ) { 
            
        } else {
            self.delegate_flag = YES;
            self.title = NSLocalizedString(@"btn_all_members",@"임직원");
            self.searchBar.placeholder = [NSString stringWithFormat:@"%@ %@", 
                                          NSLocalizedString(@"btn_all_members",@"임직원"), 
                                          NSLocalizedString(@"btn_search",@"검색")];
            self.button1.selected = YES;
            [self resetData];
            [self loadData];
            self.delegate_flag = NO;
        }
    } else if (tab == 2 ) {
        if ( self.delegate_flag ) { 
            
        } else {
            self.delegate_flag = YES;
            self.title = NSLocalizedString(@"btn_my_contacts",@"내연락처");
            self.searchBar.placeholder = [NSString stringWithFormat:@"%@ %@", 
                                          NSLocalizedString(@"btn_my_contacts",@"내연락처"), 
                                          NSLocalizedString(@"btn_search",@"검색")];
            self.button2.selected = YES;
            [self resetData];
            [self loadData];
            self.delegate_flag = NO;
        }
    } else if (tab == 3 ) {
        if ( self.delegate_flag ) { 
            
        } else {
            self.delegate_flag = YES;
            self.title = NSLocalizedString(@"btn_phonebook",@"폰북");
            self.searchBar.placeholder = [NSString stringWithFormat:@"%@ %@", 
                                          NSLocalizedString(@"btn_phonebook",@"폰북"), 
                                          NSLocalizedString(@"btn_search",@"검색")];
            self.button3.selected = YES;
            [self resetData];
            [self loadAddressBook];
            self.delegate_flag = NO;
        }
    }
    
    
    if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
        
    } else {
        if (tab == 1 ) {
            self.navigationItem.rightBarButtonItem = searchButton; //임직원의 경우만 상세검색 허용
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    
}
-(IBAction) tabButtonClicked:(id)sender {
    NSLog(@"sender[%@]", sender);
    
    //프로세스 (통신) 진행중에는 버튼이 클릭 되지 않도록 해야한다.
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;

    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
		case 1:{
			//임직원
            [self defaultSettingViewMode:btn.tag];
		}break;
		case 2:{
			//내연락처
            [self defaultSettingViewMode:btn.tag];
		}break;
        case 3:{
			//폰북
            [self defaultSettingViewMode:btn.tag];
		}break;    
    }
    
}
-(void) contactDefault{ //main 화면에서 넘어왔을때 이벤트 실행. 설정에서 사용자가 정의한 값으로 우선 보여줌
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
	switch ([[userDefault objectForKey:@"ContactDefault"] intValue]) {
        case 1:
            button1.selected = YES;
            button2.selected = NO;
            button3.selected = NO;
            [self defaultSettingViewMode:1];
            break;
        case 2:
            button2.selected = YES;
            button1.selected = NO;
            button3.selected = NO;
            [self defaultSettingViewMode:2];
            
            break;
        case 3:
            button3.selected = YES;
            button1.selected = NO;
            button2.selected = NO;
            [self defaultSettingViewMode:3];
            
            break;
            
            
        default:
            break;
    }
    

}



#pragma mark - uiSearchBar command
//연락처 검색.
-(void)searchBarSearchButtonClicked:(UISearchBar *)sender {
    NSString *tempString = [searchBar.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];

//    NSString *searchText = searchBar.text;
    
	if ([tempString length] < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다.") 
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        //이름 검색.
        
        if ( self.button1.selected ) {

            //임직원의 경우 이름 검색이다.
            //이 케이스의 경우 초대, 메일에서는 이름 검색을 하고 
            //연락처 메인에서 진입한경우 메모리 검색을 한다.
//            if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
//                self.memberSearch_flag = YES;
//                clipboard = [[Communication alloc] init];
//                clipboard.delegate = self;
//                NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//                [requestDictionary setObject:searchText forKey:@"empnm"];
//                BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
//                if (!result) {
//                    // error occurred
//                }
//            } else {
//                
//                // 더보기 버튼을 삭제 한다.
//                self.mode_nextCell = NO;
//                //NSLog(@"member 에 저장된 값.[%@]",[model.contactListDic objectForKey:@"member"]);
//                self.contactList = [ContactFunction searchAddressBook:self.data1 addressType:@"member" keyWord:searchText];
//                
//                if ( [self.contactList count] == 0 ) {
//                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"-",@"-",nil];
//                    [self.contactList addObject:dic];
//                }
//                
//                [self.dataTable reloadData];
//            }
            // 무조건 서버에서 검색으로 바뀜
            self.memberSearch_flag = YES;
            clipboard = [[Communication alloc] init];
            clipboard.delegate = self;
            clipboard.ignoreTimer = YES;
            NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
            [requestDictionary setObject:tempString forKey:@"empnm"];
            BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getUserInfo];
            if (!result) {
                // error occurred
            }
            

            [searchBar resignFirstResponder];
            [self keyboardhide];
            
        } else if ( self.button2.selected ) {
            
            self.contactList = [ContactFunction searchAddressBook:[model.contactListDic objectForKey:@"my"] addressType:@"my" keyWord:tempString];
            
            if ( [self.contactList count] == 0 ) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"-",@"-",nil];
                [self.contactList addObject:dic];
            }
            
            [self.dataTable reloadData];
            [searchBar resignFirstResponder];
            [self keyboardhide];
            
        } else if ( self.button3.selected ) {
            
            self.contactList = [ContactFunction searchAddressBook:[model.contactListDic objectForKey:@"phonebook"] addressType:@"phonebook" keyWord:tempString];
            
            if ( [self.contactList count] == 0 ) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"-",@"-",nil];
                [self.contactList addObject:dic];
            }
            
            [self.dataTable reloadData];
            [searchBar resignFirstResponder];
            [self keyboardhide];
        }
        
    }
    
}


// Cancel 클릭.
-(void)searchBarCancelButtonClicked:(UISearchBar *)sender {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    
    if ( self.button1.selected ) {
        //[self.contactList removeAllObjects]; //임직원은 항상 초기화 해주자.
        self.contactList = nil;
        self.contactList = [[NSMutableArray alloc] init];
        [self.contactList addObjectsFromArray:self.data1];
        //self.mode_nextCell = YES;
        
    } else if ( self.button2.selected ) {
        self.contactList = [model.contactListDic objectForKey:@"my"];
    } else if ( self.button3.selected ) {
        self.contactList = [model.contactListDic objectForKey:@"phonebook"];
    }
        
    [self.dataTable reloadData];
    [searchBar resignFirstResponder];
    [self keyboardhide];
}
-(void)keyboardhide{
    @try//modal에서 키보드 숨기기
    
    {
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
    }
    
    @catch (NSException *exception)
    
    {
        
        NSLog(@"%@", exception);
        
    }
}
//입력값 변경시.
-(void)searchBar:(UISearchBar*)sender textDidChange:(NSString*)searchText {
    //[searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)sender {
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:NSLocalizedString(@"btn_cancel",@"취소") forState:UIControlStateNormal];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 9876) {
		[self dismissModalViewControllerAnimated:YES];
	}
}

//이 버튼의 액션은 임직원 검색으로 이동 혹은 초대,메일 작성시 결과값 전달 2가지를 가지고 있다.
-(IBAction) searchButtonClicked {
    
    if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
          
        NSString *nameEmailCheckStr = @""; 
        
        NSMutableArray *arrTemp = nil;
        arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSMutableArray *selectItem = [[self.dataTable indexPathsForSelectedRows] copy];
        NSUInteger i, count = [selectItem count];
        for (i = 0; i < count; i++) {
            NSIndexPath * obj = [selectItem objectAtIndex:i];
                        
            //NSLog(@"selected item [%@][%@]",obj,[[self.contactList objectAtIndex:obj.row] objectForKey:@"fullname"]);
            
            
            NSString *nameKey = @"";
            NSString *emailKey = @"";
            
            if ( self.button1.selected ) {
                nameKey = @"empnm";
                emailKey = @"email";
            } else if ( self.button2.selected ) {
                nameKey = @"fullname";
                emailKey = @"emailaddress";
            } else if ( self.button3.selected ) {
                nameKey = @"fullname";
                emailKey = @"email";
            }
            
            NSString *name = [[self.contactList objectAtIndex:obj.row] notNilObjectForKey:nameKey];
            NSString *email = [[self.contactList objectAtIndex:obj.row] notNilObjectForKey:emailKey];
            
            if ( [name isEqualToString:@""] ) {
                name = [email copy];
            }
            
            if ( [email isEqualToString:@""] ) {
                if ( [nameEmailCheckStr isEqualToString:@""] ) {
                    nameEmailCheckStr = name;
                } else {
                    nameEmailCheckStr = [NSString stringWithFormat:@"%@, %@",nameEmailCheckStr, name];
                }
            } else {
                NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",email,@"email",nil];
                
                [arrTemp addObject:valueDic];
                [valueDic release];
            }
        }
        //결과가 완료되면 model.contactOptionDic 에 NSMutableArray 로 이름, 이메일 값을 Dictionary 로 값을 넣어주자
        [model.contactOptionDic removeObjectForKey:@"selectedMember"];
        [model.contactOptionDic setObject:arrTemp forKey:@"selectedMember"];
        // 주의 !!!! 셀렉트 플래그를 삭제 하면 다시 호출될때.. 문제 발생.
        //[model.contactOptionDic removeObjectForKey:@"select"]; //연락처 선택 모드가 끝났음을 알린다.
        
        if ( ![nameEmailCheckStr isEqualToString:@""] ) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@",nameEmailCheckStr, NSLocalizedString(@"contact_xx_is_not_exist", @"은 이메일주소가 없습니다")] 
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            
            alert.tag = 9876;
            [alert show];
            [alert release];        
            return;	
            
        } else {
        
            [self dismissModalViewControllerAnimated:YES];
        }
        
    } else {
        //임직원 상세 검색시.
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = NSLocalizedString(@"btn_cancel",@"취소");
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
    
        ContactSearchViewController *contactSearchViewController;
    
        contactSearchViewController = [[ContactSearchViewController alloc] initWithNibName:@"ContactSearchViewController" bundle:nil];
        [self.navigationController pushViewController:contactSearchViewController animated:YES];
        [contactSearchViewController release];
    }
}


#pragma mark - view command
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)action_home {
    
	
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
    /*
     [self.view removeFromSuperview];
     [self.navigationController.view removeFromSuperview];
     [self.navigationController release];
     
     
     NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
     [noti postNotificationName:@"returnHomeView" object:self];
	 */
	
	[self dismissModalViewControllerAnimated:YES];
	
	if ([appdelegate.window.rootViewController isKindOfClass:[MainMenuController class]]) {
		
		//NSLog(@"Class : %@", appdelegate.window.rootViewController);
		//if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft || [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
        //NSLog(@"reload");
        [(MainMenuController *)appdelegate.window.rootViewController firstComm];
		/*
         } else {
         
         }*/
        
	}
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    model = [ContactModel sharedInstance];
    
    //NSLog(@"recive select mode = [%@]",[model.contactOptionDic objectForKey:@"select"]);
    
    if ( [[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
        // 내비게인션 오른쪽 버튼
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        searchButton.title = NSLocalizedString(@"btn_done",@"완료");
        self.navigationItem.rightBarButtonItem = searchButton; // 검색 모드로 진입하였을 경우
        
        //멀티 체크를 위하여 에디팅 모드로 처리하자.
        dataTable.editing = YES;
    } else {
        
        searchButton.title = NSLocalizedString(@"btn_search_detail",@"상세검색");
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(action_home)];
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];

    }
    
    
    self.label1.text = NSLocalizedString(@"btn_all_members",@"임직원");
    self.label2.text = NSLocalizedString(@"btn_my_contacts",@"내연락처");
    self.label3.text = NSLocalizedString(@"btn_phonebook",@"폰북");
    
    
    self.contactList = [[NSMutableArray alloc] init];
    selectedMember = [[NSMutableDictionary alloc] init];
    
    self.memberSearch_flag = NO;
    
    
    self.dataTable.delegate = self;
	self.dataTable.dataSource = self;
    
    self.clipboard = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;

    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ContactDefault = [userDefault objectForKey:@"ContactDefault"];
    
    //NSLog(@"ContactDefault[%@]",ContactDefault);
    
    if ( ContactDefault == nil || [ContactDefault isEqualToString:@""] ) {
        [self defaultSettingViewMode:1]; //로드 타이밍에 임직원을 먼저 체크 한다.
    } else {
        [self defaultSettingViewMode:[ContactDefault intValue]]; //로드 타이밍에 임직원을 먼저 체크 한다.
    }
    
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [contactList   release];
    
    [searchButton   release];
    [searchBar      release];
    
    [button1    release];
    [button2 release];
    [button3 release];
    [label1  release];
    [label2  release];
    [label3  release];
    
    self.navigationItem.rightBarButtonItem = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    
//    //임직원의 경우는 표현될때마다 초기 화 해준다. 원래 팀 데이터로.
//    if ( self.button1.selected &&
//        ![[model.contactOptionDic objectForKey:@"select"] isEqualToString:@"Y"] ) {
//        //[self.contactList removeAllObjects];
//        self.contactList = nil;
//        self.contactList = [[NSMutableArray alloc] init];
//        self.contactList = [model getAddressData:@"member"];
//    }    
    [self.dataTable reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.indicator stopAnimating];
	
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



#pragma mark -
#pragma mark ABPersonViewControllerDelegate
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

@end

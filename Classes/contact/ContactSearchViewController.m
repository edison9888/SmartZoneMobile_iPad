//
//  ContactSearchViewController.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 14..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactSearchViewController.h"
#import "ContactSearchResultViewController.h"
#import "ContactDetailViewController.h"
#import "URL_Define.h"


@implementation ContactSearchViewController

@synthesize searchButton;

@synthesize name;
@synthesize department;
@synthesize jobtitle;
@synthesize chargedwork;
@synthesize homephone;
@synthesize mobilephone;
@synthesize companyname;

@synthesize button;

@synthesize companyList;
@synthesize indicator;
@synthesize clipboard;

@synthesize nameStr;
@synthesize departmentStr;
@synthesize jobtitleStr;
@synthesize chargedworkStr;
@synthesize homephoneStr;
@synthesize mobilephoneStr;
@synthesize companynameStr;

#pragma mark -
#pragma mark Optional Override Necessary Method
- (void)setPickerComponents {
	
    //	NSArray *componentsArray1 = [self getComponentDataArrayWithDisplayTextsAndValueTexts:
    //								 @"KT", @"KT", 
    //								 @"KTDS", @"KTDS", 
    //                                 nil];
    
    //NSLog(@"picker array [%@]", self.companyList);
    
    NSMutableArray *textArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *valueArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.companyList count] ; i++) { 
        NSDictionary *dic = [self.companyList objectAtIndex:i];
        NSString *text = [dic objectForKey:@"companynm"];
        NSString *value = [dic objectForKey:@"companynm"];
        [textArray addObject:text];
        [valueArray addObject:value];
    }
    
    NSArray *componentsArray1 = [[[NSArray alloc] initWithObjects:textArray, valueArray, nil] autorelease];
    
    
    [self setPickerComponentsDataWithUITextField:companyname ComponentDataArrays:componentsArray1, nil];
	
	// 디폴트값 설정 하지 않으면 자동으로 0번 아이템들로 세팅 됨 (위 예제의 경우는 남자, 35세가 디폴트)
	//[self setPickerDefaultValueWithUITextField:companyname Value:@"F", nil];
	
}
// UIDatePicker에서 사용할 모델을 세팅한다.
- (void)setDatePickerComponents {
	
	TFDatePickerModel *tfDatePickerModel = nil;
	
	tfDatePickerModel = [self getTFDatePickerModel];
	tfDatePickerModel.localeIdentifier = @"ko_KR";
	tfDatePickerModel.dateFormat	   = @"MMMM d일 (E)";
	tfDatePickerModel.date			   = [NSDate date];		// 기본 세팅은 오늘로 한다.
	
	tfDatePickerModel = [self getTFDatePickerModel];
	tfDatePickerModel.localeIdentifier = @"ko_KR";
	tfDatePickerModel.dateFormat	 = @"MMMM d일 (E)";
	tfDatePickerModel.date			   = [NSDate date];		// 기본 세팅은 오늘로 한다.
	tfDatePickerModel.datePickerMode = UIDatePickerModeDateAndTime;
    
}
#pragma mark -
#pragma mark Override Necessary Method

// !주의  TFUIScrollViewController은 반드시 setTextFieldInfo를 구현해주어야 한다.
- (void)setTextFieldInfo {
	//	CharacterType = 1,	// 문자
	//	NumberType,			// 숫자
	//	NumberAndPunctuationType,	// 숫자 & 특수기호
	//	AmountType,			// 금액
	//	AlphabetOnlyType,	// 알파벳만
	//	
	//	TextViewType,		// 텍스트뷰
	//	
	//	// 이하 type은 UIView(또는 PickerView) Type
	//	
	//	PickerViewType,		// UIPickerView 호출
	//	DatePickerViewType	// UIDatePickerView 호출
	
	// !주의 TextViewType의 경우에는 개발자에게 문의하세요. 그냥 막 쓰는거 안됩니당..
    TextFieldInfoModel *textFieldInfo;
    
    
    //  UITextField *name;
    //	UITextField *department;
    //	UITextField *jobtitle;
    //	UITextField *chargedwork;
    //	UITextField *homephone;
    //	UITextField *mobilephone;
    //	UITextField *companyname;
    
    // 일반 문자형
	textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:name
													 inputType:CharacterType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:department
													 inputType:CharacterType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:jobtitle
													 inputType:CharacterType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:chargedwork
													 inputType:CharacterType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:homephone
													 inputType:NumberType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:mobilephone
													 inputType:NumberType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentLeft];
	[textFieldsInfoArray addObject:textFieldInfo];
	[textFieldInfo release];
    
    // 피커타입 (components 세팅은 setPickerComponents 메소드에서 한다)
	textFieldInfo = [[TextFieldInfoModel alloc] initWithObject:companyname
													 inputType:PickerViewType 
													 maxLength:0				// maxLength를 0으로 하면 무제한으로 입력을 받는다.
											 enableSpecialChar:NO 
												 textAlignment:UITextAlignmentRight];
	[textFieldsInfoArray addObject:textFieldInfo];
    [textFieldInfo release];
    
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
        
        
        self.companyList = [_resultDic objectForKey:@"companyinfo"];
        //NSLog(@"recive Data [%@]", [_resultDic objectForKey:@"companyinfo"]);
        [self setPickerComponents]; //데이터를 수신하면 피커 데이터를 갱신해준다.
        
        
        
        //로그인시 받아온 회사명 노출.
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        for ( NSDictionary *dicComp in self.companyList ) {
            if ( [[dicComp objectForKey:@"companycd"] isEqualToString:[userDefault objectForKey:@"login_compcd"]] ) {
                companyname.text = [dicComp objectForKey:@"companynm"];
            }
        }
        
        
        if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) { 
            
            
        } else {
            
            
        }
        
	}
    else if([rsltCode intValue] == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
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

-(void) loadCompany {
    
    
    //Communication *
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    //sleep(2);
    // make request object
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    /*
     [requestDictionary setObject:@"1001" forKey:@"compcd"];
     [requestDictionary setObject:@"1" forKey:@"cpage"];
     [requestDictionary setObject:@"10" forKey:@"maxrow"];
     */
    
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getCompanyInfo];
	
    if (!result) {
        // error occurred
		
    }
    
    
}

//
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
    [name           release];
	[department     release];
	[jobtitle       release];
	[chargedwork    release];
	[homephone      release];
	[mobilephone    release];
	[companyname    release];
    [button         release];
    [companyList    release];
    
    [searchButton    release];
    
    [nameStr            release];
    [departmentStr   release];
    [jobtitleStr        release];
    [chargedworkStr  release];
    [homephoneStr    release];
    [mobilephoneStr  release];
    [companynameStr  release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.indicator stopAnimating];
	
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
}

- (void)viewDidLoad
{
    
    // !주의  picker와 datePicker를 사용하기 위해서는 [super viewDidLoad] 구문 이전에
	//       hasPickerView = YES; 와 hasDatePickerView = YES; 해줘야함
	//
	// !주의2 picker와 datePicker에 대한 정보를 NSDictionary로 관리하며 NSDictionary의 키를 UITextField의 tag값으로 관리하므로
	//       UITextField의 tag 값을 유니크게 세팅해야함. (간단하게 xib에서 tag를 0, 1, 2 ... n-1 로 주면 됨)
	
	hasPickerView = YES;		// 이 화면은 UIPickerView를 사용함
	hasDatePickerView = YES;	// 이 화면은 UIDatePickerView를 사용함
    
    self.title = NSLocalizedString(@"contact_find_more_employees",@"임직원 상세검색");
    
    searchButton.title = NSLocalizedString(@"btn_search", @"검색");
    self.button.titleLabel.text = NSLocalizedString(@"btn_search", @"검색");
    
    
	self.navigationItem.rightBarButtonItem = searchButton;
    
    //view 가 로드될때 회사 계열사 목록을 Load 한다.
    self.clipboard = nil;
    self.companyList = [[NSMutableArray alloc] init];
    [self loadCompany];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    nameStr.text = NSLocalizedString(@"contact_name", @"이름");       
    departmentStr.text = NSLocalizedString(@"contact_department", @"부서");
    jobtitleStr.text = NSLocalizedString(@"contact_position", @"직위");
    chargedworkStr.text = NSLocalizedString(@"contact_charge_at_work", @"담당업무");
    homephoneStr.text = NSLocalizedString(@"contact_phone_number", @"전화번호");
    mobilephoneStr.text = NSLocalizedString(@"contact_cell_phonenumber", @"휴대폰");
    companynameStr.text = NSLocalizedString(@"contact_affiliated_company", @"회사(계열사)");
    
    
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



#pragma mark - button command
-(BOOL) checkParameter {
    checkParamAlert = NO;
    int checki = 0;
    if ( ![self.name.text isEqualToString:@""] ) {
        if ([self.name.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_name", @"이름"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")] 
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }
    }
    if ( ![self.department.text isEqualToString:@""] ) {
        if ([self.department.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_department", @"부서"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")] 
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }
    }
    if ( ![self.jobtitle.text isEqualToString:@""] ) {
        if ([self.jobtitle.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_position", @"직위"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")]
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }   
    }
    if ( ![self.chargedwork.text isEqualToString:@""] ) {
        if ([self.chargedwork.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_charge_at_work", @"담당업무"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")]
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }   
    }
    if ( ![self.homephone.text isEqualToString:@""] ) {
        if ([self.homephone.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_phone_number", @"전화번호"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")]
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }   
    }
    if ( ![self.mobilephone.text isEqualToString:@""] ) {
        if ([self.mobilephone.text length] < 2) {
            checkParamAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"contact_cell_phone_number", @"휴대폰"), NSLocalizedString(@"contact_please_search_more_than_2_characters",@"검색어를 2자이상 입력하시기 바랍니다")] 
                                                           delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
            
        } else {
            checki++;
        }  
    }
    if ( ![self.companyname.text isEqualToString:@""] ) {
        // 회사명은 두자이상일 필요가 없음
        checki++;
    }
    
    if ( checki < 2 ) {
        return NO;
    } else {
        return YES;
    }
    
}
-(IBAction) searchButtonClicked {
    
    
    BOOL check = [self checkParameter];
    
    if ( check ) {
        
        
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        
        temporaryBarButtonItem.title = NSLocalizedString(@"btn_back", @"뒤로");
        
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        
        
        //검색 버튼이 클릭되면 검색 조건을 NSMutableDictionary 에 담아서 SearchResultViewController 로 보낸다.
        //검색 조건 리스트
        //    [name           release];
        //	[department     release];
        //	[jobtitle       release];
        //	[chargedwork    release];
        //	[homephone      release];
        //	[mobilephone    release];
        //	[companyname    release];
        // 회사명은 이름이 아니라 코드를 넘겨준다. 전문상 companycd
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        if ( ![self.name.text isEqualToString:@""] ) [param setObject:self.name.text forKey:@"name"];
        if ( ![self.department.text isEqualToString:@""] ) [param setObject:self.department.text forKey:@"department"];
        if ( ![self.jobtitle.text isEqualToString:@""] ) [param setObject:self.jobtitle.text forKey:@"jobtitle"];
        if ( ![self.chargedwork.text isEqualToString:@""] ) [param setObject:self.chargedwork.text forKey:@"chargedwork"];
        if ( ![self.homephone.text isEqualToString:@""] ) [param setObject:self.homephone.text forKey:@"homephone"];
        if ( ![self.mobilephone.text isEqualToString:@""] ) [param setObject:self.mobilephone.text forKey:@"mobilephone"];
        if ( ![self.companyname.text isEqualToString:@""] ) {
            //[param setObject:self.companyname.text forKey:@"companyname"];   
            NSString *companycd = @"";
            for (NSDictionary *dic in self.companyList ) {
                if ( [self.companyname.text isEqualToString:[dic objectForKey:@"companynm"]] ) {
                    companycd = [dic objectForKey:@"companycd"];
                }
            }            
            [param setObject:companycd forKey:@"companycd"];
        }
        
        //NSLog(@"param [%@]", param);
        
        ContactSearchResultViewController *contactSearchResultViewController;
        contactSearchResultViewController = [[ContactSearchResultViewController alloc] initWithNibName:@"ContactSearchResultViewController" bundle:nil];
        [contactSearchResultViewController setParam:param];
        [self.navigationController pushViewController:contactSearchResultViewController animated:YES];
        [contactSearchResultViewController release];
        [param release];
        
    } else {
        
        if ( checkParamAlert ) {
            //얼랏이 떠 있는 상태.
        } else {
            checkParamAlert = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"2개 이상 검색조건을 입력하세요"
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            
            [alert show];
            [alert release];
            return;
            
        }
    }
}

@end

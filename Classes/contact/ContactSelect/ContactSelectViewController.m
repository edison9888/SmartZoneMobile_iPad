//
//  TokenFieldExampleViewController.m
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import "ContactSelectViewController.h"
#import "Names.h"
#import "URL_Define.h"
#import "ContactMainViewController.h"

@interface ContactSelectViewController (Private)
- (void)resizeViews;
@end

@implementation ContactSelectViewController

@synthesize indicator;
@synthesize clipboard;
@synthesize delegate_flag;
@synthesize tempTokensArray;

#pragma mark -
#pragma mark CallBack Method
//완료 버튼 클릭.
- (void)naviRigthbtnPress:(id)sender {
	
    
    // 텍스트 필드에 입력값이 토큰 형태로 존재하지 않는 값이 있다면 토큰으로 만들어 주자.
    //NSLog(@"tokenTypeText : [%@]",tokenFieldView.tokenField.text);
    if ( [tokenFieldView.tokenField.text length] > 1 ) {
        [tokenFieldView textFieldShouldReturn:tokenFieldView.tokenField];  
    }
    
	// 변한 데이터를 모델에 저장한다.
    //NSLog(@"토큰 저장된 값. [%@], 모델에 적용된값 [%@]",tokenFieldView.tokenField.tokensArray, [contactModel.contactOptionDic objectForKey:@"selectedMember"] );

    NSMutableArray *arrTemp = nil;
    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TIToken *tiToken in tokenFieldView.tokenField.tokensArray) {
        
        NSString *str_email = tiToken.email;
        NSRange range1 = [str_email rangeOfString:@"@"];
        NSRange range2 = [str_email rangeOfString:@"."];
//        if (range1.length == 0 || range2.length == 0) {
//            //--- e-mail validation error
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 이메일 형식에 \n오류가 있습니다. \n올바른 형식으로 수정하시고 \n다시 완료를 눌러주세요."
//                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//            
//            [alert show];
//            [alert release];
//            return;
//            break;
//        }
        
        NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:tiToken.title,@"name",tiToken.email,@"email",nil];
        
        [arrTemp addObject:valueDic];
        [valueDic release];
    }
    if (tokenFieldView.tokenValidation) {
        //결과가 완료되면 model.contactOptionDic 에 NSMutableArray 로 이름, 이메일 값을 Dictionary 로 값을 넣어주자
        [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
        [contactModel.contactOptionDic removeObjectForKey:@"select"];
        [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"];
        

        // 일정 등록 화면으로 이동한다.
        [super popViewController];
    }
    

    
// 일정 모델에 값을 저장한다.    
//	model.registerInviteList = tokenFieldView.tokenField.tokensArray;
//    
//    for (TIToken *tiToken in model.registerInviteList) {
//NSLog(@"토큰 저장된 값. 파싱 [%@][%@]", tiToken.title, tiToken.email);
//    }
    
    //연락처 모델에 값을 저장한다.

}
- (void)viewWillDisappear:(BOOL)animated
{
    
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
}

- (void)viewDidLoad {
    
	model = [CalendarModel sharedInstance]; //일정 객체
    if ( model.registerInviteList == nil ) model.registerInviteList = [[NSArray alloc] init];
    
    contactModel = [ContactModel sharedInstance]; //주소록 객체
    
    
    //contactModel 의 select Text 값을 보고 타이틀을 완성 하자.
    NSString *title = [contactModel.contactOptionDic objectForKey:@"title"];
    NSString *items = [contactModel.contactOptionDic objectForKey:@"items"];
    
    
    //view가 로드될때.. 주소록 객체를 보고 데이터 로드를 판단한다.
//    임시로 주석처리.. 통신 이 끝나기전 Unload 될때 자꾸 에러 발생함.
//    [self loadContactData];
    
    	
	// 왼쪽 취소
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonItemStylePlain];
	
	// 오른쪽 완료
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];
	
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:title];
	
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);    
//    CGRect tmpRect = self.view.frame;
//    tmpRect.size.height = 100;
//    self.view.frame = tmpRect;
    NSMutableArray *wefwe = [Names listOfNames];
	tokenFieldView = [[TITokenFieldView alloc] init];
	[tokenFieldView setDelegate:self];
//	[tokenFieldView setSourceArray:[Names listOfNames]]; //연락처 목록을 가지고 있어야 한다...
    [tokenFieldView.tokenField setPromptText:items];
	[tokenFieldView.tokenField setAddButtonAction:@selector(showContactsPicker) target:self];
	
    
// 일정 모델에서 받은값.    
//    for (TIToken *tiToken in model.registerInviteList) {
//        [tokenFieldView.tokenField addToken:tiToken.title value:tiToken.email];
//    }
    
    
    // 토큰을 초기화 하고 값을 넣는것은 willAppear 에서 처리됨.
    
//    
//    // 토큰 어레이를 초기화 한다.1
//    [tokenFieldView.tokenField.tokensArray removeAllObjects];   
//    //연락처 모델에서 받은값.
//NSLog(@"didload [%@]",[contactModel.contactOptionDic objectForKey:@"selectedMember"]);
//    for (NSDictionary *dic in [contactModel.contactOptionDic objectForKey:@"selectedMember"]) {
//        [tokenFieldView.tokenField addToken:[dic objectForKey:@"name"] value:[dic objectForKey:@"email"]];
//    }
//    
    
    
    
    
	[self.view addSubview:tokenFieldView];
	[tokenFieldView release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// You can call this on either the view on the field.
	// They both do the same thing.
	[tokenFieldView becomeFirstResponder];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    //NSLog(@"tokenFieldView.tokenField.tokensArray [%@]",self.tempTokensArray);
    
    //contactModel 의 selectedMember 를 표현한다. 표현후 날리자.
    if ( [[contactModel.contactOptionDic objectForKey:@"selectedMember"] count] > 0 ) {
        
        for (TIToken *tiToken in self.tempTokensArray) {
            //NSLog(@"tocken [%@]",tiToken);
            [tokenFieldView.tokenField addToken:tiToken.title value:tiToken.email];
        }
        
        for (NSDictionary *dic in [contactModel.contactOptionDic objectForKey:@"selectedMember"]) {
            
            [tokenFieldView.tokenField addToken:[dic objectForKey:@"name"] value:[dic objectForKey:@"email"]];
        }
        
        [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
    }
    
    [tokenFieldView becomeFirstResponder];
    
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pretty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void)showContactsPicker {

	//주소록 호출.
	self.tempTokensArray = [tokenFieldView.tokenField.tokensArray copy];
    //NSLog(@"현재 저장된 토큰 목록. %@", tokenFieldView.tokenField.tokensArray);
    
    
//    contactModel.contactOptionDic = nil; //초기화
//    contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
//    [contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];

    //NSLog(@"call. select mode = [%@]",[contactModel.contactOptionDic objectForKey:@"select"]);
    
    Class targetClass = NSClassFromString(@"ContactMainViewController");
	id viewController = [[targetClass alloc] initWithNibName:@"ContactMainViewController" bundle:nil]; 
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewController];
    [self.navigationController presentModalViewController:navBar animated:YES];
	[navBar release];
	navBar = nil;
	[viewController release];
	viewController = nil;
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	// Wouldn't it be fantastic if, when in landscape mode, width was actually width and not height?
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
	
	CGRect newFrame = tokenFieldView.frame;
	newFrame.size.width = self.view.bounds.size.width;
	newFrame.size.height = self.view.bounds.size.height - keyboardHeight;
	[tokenFieldView setFrame:newFrame];
	[messageView setFrame:tokenFieldView.contentView.bounds];
}

- (void)tokenField:(TITokenField *)tokenField didChangeToFrame:(CGRect)frame {
	[self textViewDidChange:messageView];
}

- (void)textViewDidChange:(UITextView *)textView {
	
	CGFloat fontHeight = (textView.font.ascender - textView.font.descender) + 1;
	CGFloat originHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + fontHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < originHeight){
		newTextFrame.size.height = originHeight;
		newFrame.size.height = originHeight;
	}
		
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
}

-(void)loadContactData {
    
    //1. 폰북 로드.
    //2. 내 연락처 로드.
    //3. 임직원 로드.
    
    NSString *callUrl = @"";
    if ( [contactModel getAddressData:@"phonebook"] == nil ) {
        
        [contactModel getAddressData:@"phonebook"];
    
    }
    
    if ( ![contactModel isAddressData:@"my"] ) {
        //NSLog(@"start my address");
        self.delegate_flag = @"my";//내 연락처 로드
        callUrl = URL_getContactInfoList;
        
            
            //Communication *
            clipboard = [[Communication alloc] init];
            clipboard.delegate = self;
            //sleep(2);
            // make request object
            NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
            BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
            
            if (!result) {
                // error occurred
            }
        //NSLog(@"end my address");
        
    }
    
    if ( ![contactModel isAddressData:@"member"] ) {
        self.delegate_flag = @"member";//임직원 연락처 로드
        //NSLog(@"start member address");
        callUrl = URL_getContactInfoList;
            
            //Communication *
            clipboard = [[Communication alloc] init];
            clipboard.delegate = self;
            //sleep(2);
            // make request object
            NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
            BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
            
            if (!result) {
                // error occurred
            }
        //NSLog(@"end member address");
    }

    
}

#pragma mark -
#pragma mark communication delegate
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
    //--- indicator setting ---//
//	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    indicator.hidesWhenStopped = YES;
//	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [self.view addSubview:indicator];
//	indicator.center = self.view.center;
//	
//	[indicator startAnimating];
    
    //NSLog(@"start communication");
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
//	[indicator stopAnimating];
    //NSLog(@"end communication");
    
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
        
        if ( [[resultDic objectForKey:@"totalcount"] intValue] > 0 ) { 
            
            
            //버튼 인덱스에 따라 값을 달리준다.
            if ( [self.delegate_flag isEqualToString:@"member"] ) {
                //여기는 임직원 연락처 부분
                [contactModel.contactListDic setObject:[_resultDic objectForKey:@"contactitemlist"] forKey:@"member"];
            } else if ( [self.delegate_flag isEqualToString:@"my"] ) {
                //이건 내 연락처 부분
                [contactModel.contactListDic setObject:[_resultDic objectForKey:@"contactitemlist"] forKey:@"my"];
                //내 연락처 로드가 완료 되면 임직원을 호출하자.
                [self loadContactData];
            }
            
        } else {
            // 여기다 코드를 넣자.. 한건도 없으면.. 등록 검색된 내용이 없다고.
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;

}



@end

//
//  ContactDetailViewController.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 15..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactDetailListCell.h"
#import "NSMutableArray+QueueAdditions.h"
#import "NSDictionary+NotNilReturn.h"
#import "URL_Define.h"

#import "MailWriteController.h"

//#define debug 1

@implementation ContactDetailViewController

@synthesize dataTable;
@synthesize button1, button2, button3; //1.내연락처저장, 2.문자메시지 보내기, 3.문자메시지보내기
@synthesize label1, label2, label3;
@synthesize param, callTypeStr, responseData, phoneArr;
@synthesize indicator;
@synthesize clipboard;


@synthesize communication_flag;

#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 40.0;	//기본높이값
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == 2) {
//		return nil;
//	}
	NSLog(@"willSelectRowAtIndexPath.row=[%d]", indexPath.row);
    
    NSString *fullnameKey = @"fullname";
    NSString *companynameKey = @"companyname";
    NSString *departmentKey = @"department";
    NSString *jobtitleKey = @"jobtitle";
    NSString *emailaddress1Key = @"emailaddress1";
    NSString *businessphoneKey = @"businessphone";
    NSString *mobilephoneKey = @"mobilephone";
    
    if ( [self.callTypeStr isEqualToString:@"member"] ) {
        fullnameKey = @"empnm";
        companynameKey = @"companynm";
        departmentKey = @"orgnm";
        jobtitleKey = @"title";
        emailaddress1Key = @"email";
        businessphoneKey = @"telno";
        mobilephoneKey = @"mobileno";
	}
    
    
    
    
    // 선택 이벤트 이메일, 회사전화번호, 핸드폰 발생
    switch (indexPath.row) {
		case 0: {	// 성명
        }	break;
		case 1: {	// 회사명
		}	break;
		case 2: {   // 부서명
			
		}	break;
		case 3: {   // 직책
		}	break;
            
            
		case 4: {   
            
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
                
//                // 이메일
//                // 받는사람 초기화 
                NSMutableArray *mailFromDics = [[NSMutableArray alloc] initWithCapacity:0];
                NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:[responseData notNilObjectForKey:fullnameKey],@"name",[responseData notNilObjectForKey:emailaddress1Key],@"email",nil];
                [mailFromDics addObject:valueDic];
                [valueDic release];
                
                //NSLog(@"내연락처 이메일 전송 mailFromDics[%@]", mailFromDics);
                
                model.contactOptionDic = nil; //초기화
                model.contactOptionDic = [[NSMutableDictionary alloc] init];
                [model.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
                [model.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
                
                [model.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
                [model.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")] forKey:@"items"];
                [model.contactOptionDic setObject:@"Y" forKey:@"select"];
                
                
                MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
                mailWriteController.titleNavigationBar.text = @"새로운 메시지";
                mailWriteController.contentIndex = @"";
                mailWriteController.subjectField.text = @"";
                [self.navigationController pushViewController:mailWriteController transition:8];
                mailWriteController.contactMode = YES;
                //[self.navigationController pushViewController:mailWriteController animated:YES];
                [mailWriteController release];
            
            } else {
                
                //임직원의 경우 담당업무다.
                
                
            }
		}	break;
		case 5: {   
            
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
                
                // 회사전화번호
                NSString *businessphoneStr = [responseData notNilObjectForKey:businessphoneKey];
                if ( [self.callTypeStr isEqualToString:@"my"] ) {
                    if ( [[responseData notNilObjectForKey:businessphoneKey] isEqualToString:@""] ) {
                        if ( [[responseData notNilObjectForKey:@"businessphone2"] isEqualToString:@""] ) {
                            businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:@"homephone"]]; 
                        } else {
                            businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:@"businessphone2"]];
                        }
                    } else {
                        businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:businessphoneKey]];
                    }
                }
                //[responseData objectForKey:@"businessphone"]; //전화걸기 이벤트
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",businessphoneStr]]];
                
            } else {
                
                // 임직원의 경우 이메일이다.
                NSMutableArray *mailFromDics = [[NSMutableArray alloc] initWithCapacity:0];
                NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:[responseData notNilObjectForKey:fullnameKey],@"name",[responseData notNilObjectForKey:emailaddress1Key],@"email",nil];
                [mailFromDics addObject:valueDic];
                [valueDic release];
                
                //NSLog(@"임직원 이메일 전송 mailFromDics[%@]", mailFromDics);
                
                model.contactOptionDic = nil; //초기화
                model.contactOptionDic = [[NSMutableDictionary alloc] init];
                [model.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
                [model.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
                
                [model.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
                [model.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")] forKey:@"items"];
                //[model.contactOptionDic setObject:@"Y" forKey:@"select"];
                
                
                MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
                mailWriteController.titleNavigationBar.text = @"새로운 메시지";
                mailWriteController.contentIndex = @"";
                mailWriteController.subjectField.text = @"";
                [self.navigationController pushViewController:mailWriteController transition:8];
                mailWriteController.contactMode = YES;

                //[self.navigationController pushViewController:mailWriteController animated:YES];
                [mailWriteController release];
            }
		}	break;
		case 6: {   
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
                // 핸드폰
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[responseData notNilObjectForKey:mobilephoneKey]]]];
                
            } else {
                //임직원의 경우 회사전화번호다.
                NSString *businessphoneStr = [responseData notNilObjectForKey:businessphoneKey];
                if ( [self.callTypeStr isEqualToString:@"my"] ) {
                    if ( [[responseData notNilObjectForKey:businessphoneKey] isEqualToString:@""] ) {
                        if ( [[responseData notNilObjectForKey:@"businessphone2"] isEqualToString:@""] ) {
                            businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:@"homephone"]]; 
                        } else {
                            businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:@"businessphone2"]];
                        }
                    } else {
                        businessphoneStr = [NSString stringWithFormat:@"%@%@",businessphoneStr,[responseData notNilObjectForKey:businessphoneKey]];
                    }
                }
                //[responseData objectForKey:@"businessphone"]; //전화걸기 이벤트
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",businessphoneStr]]];
            }
            
		}	break;
        case 7: {
            //임직원의 경우 핸드폰이다.
            
            // 핸드폰
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[responseData notNilObjectForKey:mobilephoneKey]]]];
        }
            
		default:
			break;
	}
    
    
	return indexPath;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( [self.callTypeStr isEqualToString:@"my"] ) {
        return 7;
    } else {
        //임직원의 경우 담당업무 컬럼이 추가된다.
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath data [%@] ", self.responseData);
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactDetailListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"ContactDetailListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	ContactDetailListCell *tmpCell = (ContactDetailListCell *)cell;
	
    
    NSString *fullnameKey = @"fullname";
    NSString *companynameKey = @"companyname";
    NSString *departmentKey = @"department";
    NSString *jobtitleKey = @"jobtitle";
    NSString *emailaddress1Key = @"emailaddress1";
    NSString *businessphoneKey = @"businessphone";
    NSString *mobilephoneKey = @"mobilephone";
    
    if ( [self.callTypeStr isEqualToString:@"member"] ) {
        fullnameKey = @"empnm";
        companynameKey = @"companynm";
        departmentKey = @"orgnm";
        jobtitleKey = @"title";
        emailaddress1Key = @"email";
        businessphoneKey = @"telno";
        mobilephoneKey = @"mobileno";
	}
    
    if (indexPath.row == 0 || indexPath.row%2 == 0) {
//        tmpCell.label3.backgroundColor = [UIColor grayColor];		
        tmpCell.label3.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];

    } else {
        tmpCell.label3.backgroundColor = [UIColor whiteColor];

    }

	switch (indexPath.row) {
		case 0: {	// 성명
            
			tmpCell.label1.text = NSLocalizedString(@"contact_name",@"성명");
			tmpCell.label2.hidden = NO;
//			tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
			tmpCell.label2.text = [self.responseData notNilObjectForKey:fullnameKey];
			
		}	break;
		case 1: {	// 회사명
			tmpCell.label1.text = NSLocalizedString(@"contact_company",@"회사명");
			tmpCell.label2.hidden = NO;
//			tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
			tmpCell.label2.text = [responseData notNilObjectForKey:companynameKey];
            
		}	break;
		case 2: {   // 부서명
			tmpCell.label1.text = NSLocalizedString(@"contact_department_name",@"부서명");
			tmpCell.label2.hidden = NO;
//			tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
            tmpCell.label2.text = [responseData notNilObjectForKey:departmentKey];
			
		}	break;
		case 3: {   // 직책
			tmpCell.label1.text = NSLocalizedString(@"contact_position",@"직책");
			tmpCell.label2.hidden = NO;
//			tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
            tmpCell.label2.text = [responseData notNilObjectForKey:jobtitleKey];
			
		}	break;
		case 4: {   
            
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
                // 이메일
                tmpCell.label1.text = NSLocalizedString(@"contact_e-mail",@"이메일");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = [responseData notNilObjectForKey:emailaddress1Key];
            } else {
                //임직원의 경우 담당업무이다.
                tmpCell.label1.text = NSLocalizedString(@"contact_charge_at_work",@"담당업무");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = [responseData notNilObjectForKey:@"job"];
            }
		}	break;
		case 5: {   
            
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
                
                // 회사전화번호
                tmpCell.label1.text = NSLocalizedString(@"contact_company_phone_number",@"회사전화번호");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = @"";
                tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:businessphoneKey]];
                NSLog(@"%@]1",tmpCell.label2.text );
                if ( [self.callTypeStr isEqualToString:@"my"] ) {
                    if ( [[responseData notNilObjectForKey:businessphoneKey] isEqualToString:@""] ) {
                        if ( [[responseData notNilObjectForKey:@"businessphone2"] isEqualToString:@""] ) {
                            tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:@"homephone"]]; 
                            NSLog(@"%@]2",tmpCell.label2.text );

                        } else {
                            tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:@"businessphone2"]];
                            NSLog(@"%@]3",tmpCell.label2.text );

                        }
                    } 
//                    else {
//                        tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:businessphoneKey]];
//                        NSLog(@"%@]4",tmpCell.label2.text );
//
//                    }
                } 
                            
            } else {
                // 임직원의 경우 이메일이다.
                tmpCell.label1.text = NSLocalizedString(@"contact_e-mail",@"이메일");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = [responseData notNilObjectForKey:emailaddress1Key];
            }
            
		}	break;
		case 6: {   
            
            if ( [self.callTypeStr isEqualToString:@"my"] ) {
            
                // 핸드폰
                tmpCell.label1.text = NSLocalizedString(@"contact_cellphone number",@"핸드폰");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = [responseData notNilObjectForKey:mobilephoneKey];
			
            } else {
                
                //임직원의 경우 회사 전화번호다.
                tmpCell.label1.text = NSLocalizedString(@"contact_company_phone_number",@"회사전화번호");
                tmpCell.label2.hidden = NO;
//                tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
                tmpCell.label2.text = @"";
                
                tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:businessphoneKey]];
                
                if ( [self.callTypeStr isEqualToString:@"my"] ) {
                    if ( [[responseData notNilObjectForKey:businessphoneKey] isEqualToString:@""] ) {
                        if ( [[responseData notNilObjectForKey:@"businessphone2"] isEqualToString:@""] ) {
                            tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:@"homephone"]]; 
                        } else {
                            tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:@"businessphone2"]];
                        }
                    } else {
                        tmpCell.label2.text = [NSString stringWithFormat:@"%@%@",tmpCell.label2.text,[responseData notNilObjectForKey:businessphoneKey]];
                    }
                } 
            }
                
                
		}	break;
            
        case 7 : {
            // 임직원의 경우 핸드폰.
            // 핸드폰
            tmpCell.label1.text = NSLocalizedString(@"contact_cellphone number",@"핸드폰");
            tmpCell.label2.hidden = NO;
//            tmpCell.label2.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1];
            tmpCell.label2.text = [responseData notNilObjectForKey:mobilephoneKey];
            
        }   break;
		default:
			break;
	}
    
    return cell;
}

-(void)loadDetail:(NSMutableDictionary *)dic forCallType:(NSString *)callType {
    
    
    self.callTypeStr = callType;
    
    // 전문 변경.. 
    // 임직원의 경우 연락 처 정보가 목록에 모두 포함 되어있으므로 데이터를 별도 호출 하지 않는다.
    self.communication_flag = LOAD_DATA;
    
    // call comunicate method
    NSString *callUrl = @"";
    
    if ( [callType isEqualToString:@"member"] ) {
        // 임직원
        self.button1.hidden = NO;
        self.label1.hidden = NO;
        self.button2.hidden = NO;
        self.label2.hidden = NO;
        self.button3.hidden = YES;
        self.label3.hidden = YES;
        
        callUrl = URL_getAddressDetail;
        //callUrl = URL_getCompanyInfo;
        
        // 데이터 유무를 판별하고 통신 유무를 체크한다.
        self.responseData = dic;
        [self.dataTable reloadData];
        
    } else if ( [callType isEqualToString:@"my"] ) {
        //내 연락처
        self.button1.hidden = YES;
        self.label1.hidden = YES;
        self.button2.hidden = YES;
        self.label2.hidden = YES;
        self.button3.hidden = NO;
        self.label3.hidden = NO;
        
        callUrl = URL_getContactInfoDetail;
        
        //NSLog(@"call Url [%@] ", callUrl);
        
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        [requestDictionary setObject:[dic notNilObjectForKey:@"contactid"] forKey:@"contactid"];    
        BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:callUrl];
        if (!result) {
            // error occurred
        }
        
    }
    

}


#pragma mark -
#pragma mark communication delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 9876) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if (alertView.tag == 1234) {
        
        // 성공 내 연락처를 갱신한다.
        clipboard = [[Communication alloc] init];
        clipboard.delegate = self;
        self.communication_flag = CALL_CONTACT;
        NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getContactInfoList];
        if (!result) {
            // 내 연락처 수신 실패 에러 메시지.
        } 

    }

	
}
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
        
        if ( self.communication_flag == LOAD_DATA ) {
            //연락처 상세정보 조회
            
            self.responseData = [_resultDic objectForKey:@"contactItem"];
            [self.dataTable reloadData];
            
        } else if ( self.communication_flag == SAVE_DATA) {
            //연락처 등록
            	
            [self saveMyContactResult:YES];
            
            
        } else if ( self.communication_flag == CALL_CONTACT) {
            //모델에 내 연락처 재등록.
            
            [model.contactListDic setObject:[_resultDic objectForKey:@"contactitemlist"] forKey:@"my"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }

	
    
    }
    else if([rsltCode intValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		//alert.tag = 9876; // 임시로 팝 뷰 막음.
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




-(void)buttonClicked:(UIButton *)sender {
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
		case 1:{
			//내연락처저장
            [self saveMyContact];
		}break;
		case 2:{
			//문자메시지보내기
            [self showActionSheet];
		}break;
        case 3:{
			//문자메시지보내기
            [self showActionSheet];
		}break;    
    }

}

-(void)showActionSheet {
	
    //NSLog(@"showActionSheetData [%@]",self.responseData);
    
    //임직원 연락처의 문자 메시지 보내기 기능 연락처는 다음과 같다.
//telno
//mobileno
    
    
    //내 연락처의 문자 메시지 보내기 가능 연락처는 다음과 같다. 
//    assistantphone;		비서전화번호
//    businessphone;		사무실전화번호
//    businessphone2;		사무실전화번호2
//    homephone;          전화번호
//    mobilephone;		핸드폰번호
    
    
    self.phoneArr = [[NSMutableArray alloc] init];
    
    if ( self.responseData != nil ) {
        
        if ( [self.callTypeStr isEqualToString:@"member"] ) {
            
            if ( ![[self.responseData notNilObjectForKey:@"telno"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"telno"]];
            
            if ( ![[self.responseData notNilObjectForKey:@"mobileno"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"mobileno"]];
            
        } else {
        
            if ( ![[self.responseData notNilObjectForKey:@"assistantphone"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"assistantphone"]];
            if ( ![[self.responseData notNilObjectForKey:@"businessphone"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"businessphone"]];
            if ( ![[self.responseData notNilObjectForKey:@"businessphone2"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"businessphone2"]];
            if ( ![[self.responseData notNilObjectForKey:@"homephone"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"homephone"]];
            if ( ![[self.responseData notNilObjectForKey:@"mobilephone"] isEqualToString:@""] ) [phoneArr addObject:[self.responseData notNilObjectForKey:@"mobilephone"]];
            
        }
        
    } else {
//        [phoneArr addObject:@"123456789"];
//        [phoneArr addObject:@"02-1258-1255"];
//        [phoneArr addObject:@"011-1258-5425"];
//        [phoneArr addObject:@"01025851257"];
    }
    //NSLog(@"actionsheet data[%@], count[%d]",phoneArr, [phoneArr count]);
    if ( [phoneArr count] == 0 ) {
    
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_no contact number",@"연락가능한 전화 번호가 없습니다.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
        
    } else {
//        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:
//                                     @"02-1234-5678", @"011-1478-9582", @"010-1234-5896"
//                                    , nil];
//        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [popupQuery showInView:self.view];
//        [popupQuery release];
        
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil]; 
        for (int i = 0; i < phoneArr.count; i++) 
            [menu addButtonWithTitle:[phoneArr objectAtIndex:i]];
        
        [menu addButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소")];
        [menu setCancelButtonIndex:menu.numberOfButtons - 1];
        
        [menu showInView:self.view];
        [menu release];
	}
    
    
}
-(NSString *)callPhoneUi:(NSString *)orgStr {

    //phone 타입인지 sms 타입인지 이도 저도 아닌지 확인한다.
    NSString *type = @"";
    if ( [orgStr rangeOfString:@"0"].location == 0 ) {
        type = @"phone";
    } 
    if ( [orgStr rangeOfString:@"070"].location == 0 ) {
        type = @"phone";
    } else if ( [orgStr rangeOfString:@"010"].location == 0 ) {
        type = @"sms";
    } else if ( [orgStr rangeOfString:@"011"].location == 0 ) {
        type = @"sms";
    } else if ( [orgStr rangeOfString:@"016"].location == 0 ) {
        type = @"sms";
    } else if ( [orgStr rangeOfString:@"017"].location == 0 ) {
        type = @"sms";
    } else if ( [orgStr rangeOfString:@"018"].location == 0 ) {
        type = @"sms";
    } else if ( [orgStr rangeOfString:@"019"].location == 0 ) {
        type = @"sms";
    } 
    
    return type;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"call start index[%d]", buttonIndex);
    
    //문자메시지 보내기.ios 3x
//    NSString *phoneNumber = @"011-1478-9582";
//    NSString *pn=[[NSString alloc]init];
//    pn=[@"sms://" stringByAppendingString:phoneNumber];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pn]];
    //NSLog(@"click button index [%d]",buttonIndex);
    
    
    if ( [phoneArr count] == buttonIndex ) { 
        //취소버튼 클릭.
    } else {
    
        //넘겨받은 파라메터의 값중 010,011,016,017,018,019 의 경우에는 문자메시지
        //그이외의 경우는 전화 연결을 한다.
        NSString *phoneArrStr = [phoneArr objectAtIndex:buttonIndex];
        NSString *phoneArrStrType = [self callPhoneUi:phoneArrStr];
                                 
        //NSLog(@"call [%@] [%@]",phoneArrStrType, phoneArrStr);
    
        if ( [phoneArrStrType isEqualToString:@"phone"] ) {
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneArrStr]]];
        
        
        } else if ( [phoneArrStrType isEqualToString:@"sms"] ) {
    
            //ios4x
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText]) {
                controller.body = @""; //메시지 바디
                controller.recipients = [NSArray arrayWithObjects:phoneArrStr, nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
        
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_phone number is not_valid",@"연락가능한 전화 번호형태가 아닙니다.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
            [alert show];
            [alert release];
            return;
        }
        
        
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            //NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //NSLog(@"Result: sent");
            break;
        case MessageComposeResultFailed:
            //NSLog(@"Result: failed");
            break;
        default:
            //NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) saveMyContact {
    
    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    ABRecordRef person = ABPersonCreate();
//    
//    ABRecordSetValue(person, kABPersonFirstNameProperty, dept , nil);
//    ABRecordSetValue(person, kABPersonLastNameProperty, name.text , nil);
//    ABRecordSetValue(person, kABPersonJobTitleProperty, reserv2.text , nil);
//    ABRecordSetValue(person, kABPersonDepartmentProperty, reserv1.text , nil);
//    ABRecordSetValue(person, kABPersonOrganizationProperty, corp.text , nil);
//    
//    
//    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
//    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, mobile.text, kABPersonPhoneMobileLabel, nil);
//    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, phone1.text, kABWorkLabel, nil);
//    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
//    
//    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
//    ABMultiValueAddValueAndLabel(emailMultiValue, email.text, kABWorkLabel, nil);
//    ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
//    
//    NSData * dataRef = UIImagePNGRepresentation(base64image.image);
//    ABPersonSetImageData(person, (CFDataRef)dataRef, nil);
//    
//    ABAddressBookAddRecord(addressBook, person, nil);
//    ABAddressBookSave(addressBook, nil);
//    
//    
//    
//    CFRelease(person);
//    CFRelease(phoneNumberMultiValue);
//    CFRelease(emailMultiValue);
//    // 처리 내용
//    UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"알림" message:@"연락처를 저장 하였습니다."
//                                                    delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//    [alerts show];	
//    [alerts release];
    
    // address book 이 아니고 
    
    
    
    
    
    
// 임직원 연락처 구조체.    
//    loginid		사번
//    empno         사번
//    empnm         사원명
//    companycd		회사코드
//    companynm		회사명
//    orgcd         부서코드
//    orgnm         부서명
//    title         직위
//    email         이메일
//    telno         사무실전화
//    mobileno		이동전화
//    job           담당업무
//    manageryn		관리자 여부
// createContactInfo inParam  
//    fullname		이름		"기본적으로는 fullname을 사용한다. Givenname, middlename, surname은 추후 확인후 사용함.Fullname에 성이름을 합쳐서 전달하면 OK/"
//    givenname		첫째 이름							
//    surname		성							
//    middlename	중간 이름							
//    department	부서명							
//    businessphone	사무실전화번호							
//    mobilephone	핸드폰전화번호							
//    jobtitle		직위							
//    emailaddress	이메일주소							
//    companyname	회사명							
    
    
    
    
    // 내연락처에 저장하는것.. 통신 탈껏.
    // 먼저 내 연락처에 기 존재하는 연락처인지 확인 하는 로직 있어야 하지 않음?????????
    NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //"기본적으로는 fullname을 사용한다. Givenname, middlename, surname은 추후 확인후 사용함.Fullname에 성이름을 합쳐서 전달하면 OK/"					
    
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"empnm"] forKey:@"fullname"];
    [requestDictionary setObject:@"" forKey:@"givenname"]; //임직원에서는 값을 넘겨줄수 없다.
    [requestDictionary setObject:@"" forKey:@"surname"]; //임직원에서는 값을 넘겨줄수 없다.
    [requestDictionary setObject:@"" forKey:@"middlename"]; //임직원에서는 값을 넘겨줄수 없다.
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"orgnm"] forKey:@"department"];
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"telno"] forKey:@"businessphone"];
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"mobileno"] forKey:@"mobilephone"];
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"title"] forKey:@"jobtitle"];
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"email"] forKey:@"emailaddress"];
    [requestDictionary setObject:[self.responseData notNilObjectForKey:@"companynm"] forKey:@"companyname"];
    
    self.communication_flag = SAVE_DATA;
    clipboard = [[Communication alloc] init];
    clipboard.delegate = self;
    BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_createContactInfo];
    if (!result) {
        // error occurred
        [self saveMyContactResult:result];
    }     
}

-(void) saveMyContactResult:(BOOL)result {

    //등록 결과에 따라 액션을 취한다.
    
    if ( result ) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_saved in your contact list",@"내 연락처에 저장되었습니다.")
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        
        alert.tag = 1234;
        [alert show];	
        [alert release];
        return;
    } else {
        // 실패 에러 메시지.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:NSLocalizedString(@"contact_failed to save address",@"주소록 저장에 실패 하였습니다.")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;	
    }
}
#pragma mark - view

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //연락처 모델.
    model = [ContactModel sharedInstance];
    
    
    //다국어 적용.NSLocalizedString
    self.title = NSLocalizedString(@"contact_personal profile",@"개인프로필");
    self.label1.text = NSLocalizedString(@"btn_save_in_my_contacts",@"내연락처에 저장");
    self.label2.text = NSLocalizedString(@"btn_send_message",@"문자메시지 보내기");
    self.label3.text = NSLocalizedString(@"btn_send_message",@"문자메시지 보내기");
    
    
    //테이블 표현용
    self.responseData = [[NSMutableDictionary alloc] init];
    
    self.dataTable.delegate = self;
	self.dataTable.dataSource = self;
    
    self.clipboard = nil;

    CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [dataTable   release];
    [button1     release];
    [button2     release];
    [button3     release]; //1.내연락처저장, 2.문자메시지 보내기, 3.문자메시지보내기
    [label1      release];
    [label2      release];
    [label3      release];
    
    [param       release];
    [responseData    release];
    [phoneArr       release];
    [indicator   release];
    [clipboard   release];
    [callTypeStr release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (clipboard != nil) {
		[clipboard cancelCommunication];
	}
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}
@end

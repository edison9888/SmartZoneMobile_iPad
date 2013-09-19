    //
//  MailListController.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 19..
//  Copyright 2011 ktds. All rights reserved.
//

#import "MailListController.h"
#import "URL_Define.h"
#import "MailDetailController.h"
#import "MailWriteController.h"
#import "OverlayViewController.h"
#import "MailController.h"
#import "MailMoveController.h"
#import "SplitOverlayViewController.h"
@implementation MailListController

@synthesize userDefault, num_pageNum, mailList, currentTableView;
@synthesize result_totalCount, result_totalPage, mode_nextCell;
@synthesize folderID;
@synthesize temporaryBarRightButtonItem;
@synthesize editModeToolbar;
@synthesize selectedRows;
@synthesize mode_edit,mode_oneRowDelete, oneRowDeleteIndex;
@synthesize ovController;
@synthesize mailSearchBar;
@synthesize mode_search, mode_unRead;
@synthesize searchStype;
@synthesize refreshBarButton;
@synthesize mode_reset;
@synthesize detailViewController;
@synthesize appDelegate;
@synthesize splitOverlayViewController;
@synthesize detailMailID;
#pragma mark-
#pragma mark system method

-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	refreshBarButton.enabled = YES;
	
}
-(void)viewWillAppear:(BOOL)animated {
	[self.currentTableView reloadData];
}

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

-(void)viewDidLoad {
//    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

	mode_edit = NO;
	mode_reset = NO;
    indicator = nil;
    self.appDelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];

//    self.detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];

	UIBarButtonItem *aBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btn_back",@"btn_back") style:UIBarButtonItemStyleBordered target:self action:@selector(editCancelMode)]autorelease];
	self.navigationItem.backBarButtonItem = aBarButtonItem;
	
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	editModeToolbar.hidden = YES;
	
	self.mailList = [[NSMutableArray alloc] init];
    
	CGRect rect_tableView = self.view.frame;
	rect_tableView.size.height -= 20;
    //self.currentTableView = [[UITableView alloc] initWithFrame:rect_tableView style:UITableViewStylePlain];
	self.currentTableView.delegate = self;
	self.currentTableView.dataSource = self;
	self.currentTableView.editing = NO;
    //[self.view addSubview:self.currentTableView];
	mode_search = NO;
    
	self.currentTableView.contentOffset = CGPointMake(0, 44);
	mailSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    mailSearchBar.delegate = self;
    self.currentTableView.tableHeaderView =mailSearchBar;
    [mailSearchBar release];
    
	
	
	selectedRows = [[NSMutableArray alloc]init];
    
	
	
	self.userDefault = [NSUserDefaults standardUserDefaults];
	self.num_pageNum = 0;	//최초 페이지 1
    noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(returnListMailMove) name:@"returnListMailMove" object:nil];
	[noti addObserver:self selector:@selector(overlayView) name:@"overlayView" object:nil];
    [noti addObserver:self selector:@selector(overlayViewCancel) name:@"overlayViewCancel" object:nil];
    [noti addObserver:self selector:@selector(tableUpdate) name:@"tableUpdate" object:nil];

}

- (void)dealloc {
    
    [userDefault release];
	[mailList release];
	[currentTableView release];
	[indicator release];
    [nextCell release];
    [nextCellButton release];
	[oneRowDeleteIndex release];
	[cm release];
//	[temporaryBarRightButtonItem release];
//	[editModeToolbar release];
	[folderID release];
	[selectedRows release];
	[ovController release];
//	[mailSearchBar release];
	[searchStype release];
	[refreshBarButton release];

    
    
    
    [super dealloc];
}

#pragma mark -
#pragma mark communication delegate


-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	currentTableView.userInteractionEnabled = NO;
	
//	BOOL isIndicator = YES;
//	for (UIView *uiView in self.view.subviews) {
//        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
//            isIndicator = NO;
//        }
//    }        
//    if ( isIndicator ) {
    if(indicator == nil){ 
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 170, 30, 30)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:indicator];
//        indicator.center = self.view.center;
        [indicator startAnimating];
    }
	refreshBarButton.enabled = NO;
    
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	refreshBarButton.enabled = YES;
    currentTableView.userInteractionEnabled = YES;

	[indicator stopAnimating];
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
            indicator = nil;
        }
    } 
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
		//NSLog(@"PaymentListController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];

	
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		return;
		
	}
	
	if([rsltCode intValue] == 0) {
		

		if (mode_edit == YES) {//편집모드에서 삭제했을때

//			int i;
//			for (i = 0; i < [self.selectedRows count]; i++) {
//				NSIndexPath * obj = [selectedRows objectAtIndex:i];
//				NSLog(@"%d",obj.row);
//				[self.mailList removeObjectAtIndex:obj.row-i];
//			}

//            NSLog(@"%@", selectedRows);
//            for (int i=[selectedRows count]-1; i >= 0; i--) {
//                NSIndexPath * obj = [selectedRows objectAtIndex:i];
//                NSLog(@"%d", obj.row);
//                [self.mailList removeObjectAtIndex:obj.row];
//            }
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            NSLog(@"%@", selectedRows);
            for (int i=[selectedRows count]-1; i >= 0; i--) {
                NSIndexPath * obj = [selectedRows objectAtIndex:i];
                NSLog(@"%d", obj.row);
                [tempArray addObject:[NSString stringWithFormat:@"%d", obj.row ]];
            }
            [tempArray sortUsingSelector: @selector( caseInsensitiveCompare: )];

            for (int j=[tempArray count]-1;  j >= 0; j--) {
                NSString * tempString = [tempArray objectAtIndex:j];
                [self.mailList removeObjectAtIndex:[tempString intValue]];
            }
            [tempArray release];
            tempArray = nil;
            [noti postNotificationName:@"delReloadContentTableView" object:nil];

            
            
		}else if (mode_oneRowDelete) {//swipe delete
			
			[self.mailList removeObjectAtIndex:oneRowDeleteIndex.row]; 
            [noti postNotificationName:@"delReloadContentTableView" object:nil];
            
            
            
            

            
            
            
            
            
            

		}else if (mode_unRead == YES) {
			NSMutableDictionary *mail_IsReadDictionary= [[[NSMutableDictionary alloc]init]autorelease];

			NSUInteger i, count = [self.selectedRows count];
			for (i = 0; i < count; i++) {
				NSIndexPath * obj = [selectedRows objectAtIndex:i];
				
				mail_IsReadDictionary = [self.mailList objectAtIndex:obj.row];
				[mail_IsReadDictionary setObject:[NSString stringWithFormat:@"0"] forKey:@"mail_isread"];
			
			}
			mode_unRead = NO;
//			[self.currentTableView reloadData];

		}

		
		else {
			self.result_totalPage = [[resultDic objectForKey:@"totalpage"] intValue];
			self.result_totalCount = [[resultDic objectForKey:@"totalcount"] intValue];
			if (mode_reset == YES) {
				[self.mailList removeAllObjects];
				[self.mailList addObjectsFromArray:[_resultDic objectForKey:@"emailinfolist"]];
				mode_reset = NO;

			}else {
				[self.mailList addObjectsFromArray:[_resultDic objectForKey:@"emailinfolist"]];
                self.detailViewController=(MailDetailController *)[[self.splitViewController.viewControllers objectAtIndex:1] visibleViewController];
                //            self.detailViewController=(MailDetailController *)[self.splitViewController.viewControllers objectAtIndex:1];

                [self.detailViewController loadDetailTableList:self.mailList];
			}


			
		}
		[self.currentTableView reloadData];

	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
	mode_edit = NO;
	mode_oneRowDelete = NO;
	mode_unRead == NO;
		//[self editCancelMode];
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	refreshBarButton.enabled = YES;
    currentTableView.userInteractionEnabled = YES;

	[indicator stopAnimating];
	for (UIView *uiView in self.view.subviews) {
        if ([uiView isKindOfClass:[UIActivityIndicatorView class]]) {
            [uiView removeFromSuperview];
            indicator = nil;

        }
    } 
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//    return;

	
}


#pragma mark -
#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	self.navigationItem.rightBarButtonItem.enabled = YES;

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
		//  [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.currentTableView.editing == YES) {

		NSLog(@"editing mode");
		if((self.num_pageNum < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.mailList count])) {
				//--- nextCell의 빈공간을 누르면 아무 처리도 하지 않는다.
			currentTableView.editing = NO;
		}
		else {
			NSLog(@"clicked   %@",indexPath);
			
			
		}


	}else {
		if((self.num_pageNum+1 < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.mailList count])) {
				//--- nextCell의 빈공간을 누르면 아무 처리도 하지 않는다.
		}else {
				NSMutableDictionary *mail_IsReadDictionary= [[[NSMutableDictionary alloc]init]autorelease];
					//[mail_IsReadDictionary setObject:@"1" forKey:@"mail_isread"];
				mail_IsReadDictionary = [self.mailList objectAtIndex:indexPath.row];

				[mail_IsReadDictionary setObject:[NSString stringWithFormat:@"1"] forKey:@"mail_isread"];
            [self.currentTableView reloadData];

//				MailDetailController *mailDetailController = [[MailDetailController alloc] initWithNibName:@"MailDetailController" bundle:nil];
//				mailDetailController.title = self.title;
//
//				// Pass the selected object to the new view controller.
//				[self.navigationController pushViewController:mailDetailController animated:YES];
//
//			
//				[mailDetailController loadDetailContentTableList:mailList forIndexPath:indexPath.row folderID:self.folderID];
//				
//				[mailDetailController release];
//				[tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.detailViewController=(MailDetailController *)[[self.splitViewController.viewControllers objectAtIndex:1] visibleViewController];
//            self.detailViewController=(MailDetailController *)[self.splitViewController.viewControllers objectAtIndex:1];
            [self.detailViewController loadDetailContentTableList:self.mailList forIndexPath:indexPath.row folderID:self.folderID];
//            [detailViewController loadDetailContentTableList:self.mailList forIndexPath:indexPath.row folderID:self.folderID];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [detailViewController popoverDismiss];
            self.detailMailID = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:indexPath.row] objectForKey:@"mail_id"]];

				
//			}

			
			
			
		}
		
		
	}

	
}

#pragma mark -
#pragma mark tableview datasource
	// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		//--- 현재 페이지가 토탈 페이지 보다 작으면 nextCell 보여줌
	if(self.num_pageNum+1 < self.result_totalPage) {
		self.mode_nextCell = YES;
		return [self.mailList count] + 1;
	}
	else {
		return [self.mailList count];
	}
	
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
		//--- nextCell 모드이고, 현재 페이지가 토탈 페이지보다 작고, 마지막 라인이면 nextCell
	if((self.num_pageNum+1 < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.mailList count])) {
		cell = nextCell;

	}
	else {
		if (cell == nil) {
			NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"MailListCustomCell" owner:self options:nil];
			cell = [topObject objectAtIndex:0];
		}
		
			

		cell.selectionStyle = UITableViewCellSelectionStyleBlue;

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//cell.imageView.image = [UIImage imageNamed:@"downarrow.png"];
		
		NSDictionary *dic_current = [self.mailList objectAtIndex:indexPath.row];

		NSString *mail_IsRead = [dic_current objectForKey:@"mail_isread"];
		if ([mail_IsRead isEqualToString:@"0"]) {
			UIImageView *tempImgView = (UIImageView *)[cell viewWithTag:16];
			tempImgView.image = [UIImage imageNamed:@"dot_orange.png"];
		}

		CGFloat r = 256;

		NSString *mail_hasattachment = [dic_current objectForKey:@"mail_hasattachment"];
		if ([mail_hasattachment isEqualToString:@"1"]) {
			CGRect loadImageRect = CGRectMake(17,4,15,15);
				//		CGRect mailFromeIdRect = mailFromID.frame 
                //		mailFromID.frame.size.width
			UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
			cellImage.image = [UIImage imageNamed:@"img_clip.png"];
			
			
			[cell.contentView addSubview:cellImage];
			
			[cellImage release];
			
			
			
			CGRect loadValueRect = CGRectMake(35,0,130,21);
			UILabel *mailFromID = [[UILabel alloc] initWithFrame:loadValueRect];
			mailFromID.font = [UIFont boldSystemFontOfSize:14];
			mailFromID.text = [dic_current objectForKey:@"mail_fromname"];
			mailFromID.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:mailFromID];
			[mailFromID release];
		}else {

			CGRect loadValueRect = CGRectMake(20,0,130,21);
			UILabel *mailFromID = [[UILabel alloc] initWithFrame:loadValueRect];
			mailFromID.font = [UIFont boldSystemFontOfSize:14];
            if([self.folderID isEqualToString:@"2"])
                mailFromID.text = [dic_current objectForKey:@"mail_displayto"];
            else
                mailFromID.text = [dic_current objectForKey:@"mail_fromname"];
			[cell.contentView addSubview:mailFromID];
			[mailFromID release];

		}

		UILabel *mailSubject = (UILabel *)[cell viewWithTag:12];//메일제목
		mailSubject.text = [dic_current objectForKey:@"mail_subject"];
		UILabel *mailBody = (UILabel *)[cell viewWithTag:15];//메일제목
		mailBody.text = [dic_current objectForKey:@"mail_body"];

		NSString *dateString = [dic_current objectForKey:@"mail_receivedtime"];
		UILabel *tempDateLabel = (UILabel *)[cell viewWithTag:13];
		tempDateLabel.text = dateString;
		
	}
	
	
	
    return cell;
}



 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
	if((self.num_pageNum+1 < self.result_totalPage) && (self.mode_nextCell == YES) && (indexPath.row == [self.mailList count])) {
			//--- nextCell의 빈공간을 누르면 아무 처리도 하지 않는다.
		return NO;
	}
	else {
//		self.navigationItem.rightBarButtonItem.enabled = YES;
		return YES;
	}

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {  
		//return 3; 
	if(currentTableView.editing){
		return 3;
	}else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
		return UITableViewCellEditingStyleDelete;

	}

}  

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
	NSLog(@"HIT THIS BABY"); 
	if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
		cm = [[Communication alloc] init];
		[cm setDelegate:self];
		
		
		mode_oneRowDelete = YES;
		
		self.oneRowDeleteIndex = indexPath;
        if ([self.detailMailID isEqualToString:[NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:indexPath.row] objectForKey:@"mail_id"]]]) {
            [noti postNotificationName:@"imagehiddenNo" object:self];//삭제할경우 디테일도 삭제
        }

		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		[requestDictionary setObject:[NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:indexPath.row] objectForKey:@"mail_id"]] forKey:@"mail_id"];
		
		int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_deleteEmailInfo];
		if (rslt != YES) {
				//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
														   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
		
		
		
	}
}


#pragma mark searchBar Deligate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	mailSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"btn_sender", @"보낸사람"),NSLocalizedString(@"btn_recevier", @"받는사람"),NSLocalizedString(@"btn_title", @"제목"),NSLocalizedString(@"btn_all", @"모두"),nil];
    mailSearchBar.showsScopeBar = YES;
    [mailSearchBar setShowsCancelButton:YES animated:YES]; 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.currentTableView.contentOffset = CGPointMake(0, 0);
		// View의 폭에 맞게 툴바를 설정한다.
    [mailSearchBar sizeToFit];
	self.currentTableView.scrollEnabled = NO;
    
		//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height+44;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
		//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.currentTableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		//Add the done button.

	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	mode_search = YES;
	self.num_pageNum = 0;
	[self.mailList removeAllObjects];

	[self doneSearching_Clicked:@""];

	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:folderID forKey:@"folderid"];
	[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.num_pageNum] forKey:@"pcount"];
		//NSString *sssss = [[self.mailSearchBar scopeButtonTitles] objectAtIndex:[self.mailSearchBar selectedScopeButtonIndex]];
	int intSearchType =[self.mailSearchBar selectedScopeButtonIndex];
	
	if (intSearchType == 0 ) {
		searchStype = @"from";
	}else if (intSearchType == 1 ) {
		searchStype = @"to";		
	}else if (intSearchType == 2 ) {
		searchStype = @"subject";		
	}else {
		searchStype = @"all";		
	}
	
	[requestDictionary setObject:searchStype forKey:@"stype"];
	[requestDictionary setObject:[NSString stringWithFormat:@"%@", mailSearchBar.text] forKey:@"sword"];
	NSLog(@"ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄹ%@",mailSearchBar.text);
	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_getEmailInfoList];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[self doneSearching_Clicked:@""];
	

}
- (void) doneSearching_Clicked:(id)sender {
	
	[mailSearchBar resignFirstResponder];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.currentTableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	mailSearchBar.showsScopeBar = NO;
    [mailSearchBar setShowsCancelButton:NO animated:YES]; 
    
	self.currentTableView.contentOffset = CGPointMake(0, 0);
	CGFloat width = self.view.frame.size.width;
    
	self.currentTableView.tableHeaderView.frame = CGRectMake(0, 0, width, 44);
    
	
    
}
#pragma overay event
- (void)overlayView{

    // View의 폭에 맞게 툴바를 설정한다.
    
    //Add the overlay view.
	if(splitOverlayViewController == nil)
		splitOverlayViewController = [[SplitOverlayViewController alloc] initWithNibName:@"SplitOverlayViewController" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
    
	CGFloat width = self.view.frame.size.width;
//	CGFloat height = self.view.frame.size.height;
    CGFloat height = 800;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 0, width, height);
	splitOverlayViewController.view.frame = frame;	
	splitOverlayViewController.view.backgroundColor = [UIColor grayColor];
	splitOverlayViewController.view.alpha = 0.5;
	
	
	[self.view addSubview:splitOverlayViewController.view ];
    

}
- (void)overlayViewCancel{
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];

	[splitOverlayViewController.view removeFromSuperview];
	[splitOverlayViewController release];
	splitOverlayViewController = nil;
    
	self.currentTableView.contentOffset = CGPointMake(0, 0);
	CGFloat width = self.view.frame.size.width;
    
	self.currentTableView.tableHeaderView.frame = CGRectMake(0, 0, width, 44);
}

#pragma mark event
-(void)tableUpdate{
//    BOOL animationsEnabled = [UIView areAnimationsEnabled];
//    [UIView setAnimationsEnabled:NO];
//    [self.currentTableView beginUpdates];
//    [self.currentTableView endUpdates];
//    [UIView setAnimationsEnabled:animationsEnabled];
    [self.currentTableView reloadData];
}
-(void)resetList {
	self.num_pageNum = 0;	//최초 페이지 1
	mode_search = NO;
	mode_reset = YES;
    //	[self.mailList removeAllObjects];
	[self loadMoreListComm];
}


-(void) loadMoreListComm {
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:folderID forKey:@"folderid"];
	[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.num_pageNum] forKey:@"pcount"];
	if (self.mode_search == YES) {
//		NSLog(@"^^^^^^^^^^^^^^^^^^^^%@",mailSearchBar.text);
		[requestDictionary setObject:self.searchStype forKey:@"stype"];
		[requestDictionary setObject:[NSString stringWithFormat:@"%@", mailSearchBar.text] forKey:@"sword"];
	}
	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_getEmailInfoList];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
	
	
}
-(void) loadDetailContentAtIndex:(NSString *)index {
	
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    if ([index isEqualToString:@"1"]) {
        self.title = @"받은 편지함";
    }
	self.folderID = index;
    
	[requestDictionary setObject:index forKey:@"folderid"];
		//[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.num_pageNum] forKey:@"pcount"];
	[requestDictionary setObject:@"0" forKey:@"pcount"];

	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_getEmailInfoList];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
}

-(void) refresh{
	
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:folderID forKey:@"folderid"];
	[requestDictionary setObject:[NSString stringWithFormat:@"%d", self.num_pageNum] forKey:@"pcount"];
		//[requestDictionary setObject:num_pageNum forKey:@"pcount"];
	
	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_getEmailInfoList];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}
-(void) editMode{
	currentTableView.editing = YES;
	self.temporaryBarRightButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btn_cancel", @"취소 버튼") style:UIBarButtonItemStyleBordered target:self action:@selector(editCancelMode)]autorelease];
	self.navigationItem.rightBarButtonItem = self.temporaryBarRightButtonItem;
	editModeToolbar.hidden = NO;

}
-(void) editCancelMode{
	currentTableView.editing = NO;
	self.temporaryBarRightButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btn_edit", @"편집 버튼") style:UIBarButtonItemStyleBordered target:self action:@selector(editMode)]autorelease];
	self.navigationItem.rightBarButtonItem = self.temporaryBarRightButtonItem;
	editModeToolbar.hidden = YES;

}
-(IBAction) trashButtonClicked{
    
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	NSMutableString *multiSelectedRowString = [[NSMutableString alloc]init];

	self.selectedRows= [[self.currentTableView indexPathsForSelectedRows] copy];
	NSUInteger i, count = [self.selectedRows count];
	for (i = 0; i < count; i++) {
		NSIndexPath * obj = [selectedRows objectAtIndex:i];
		NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_id"]];
		[multiSelectedRowString appendFormat:@"%@; ", addMailIdString];
        if ([self.detailMailID isEqualToString:addMailIdString]) {
            [noti postNotificationName:@"imagehiddenNo" object:self];//삭제할경우 디테일도 삭제
        }
	}
	mode_edit = YES;
	

	
	
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:multiSelectedRowString forKey:@"mail_id"];
    if ([self.folderID isEqualToString:@"4"]) {
        [requestDictionary setObject:@"h" forKey:@"delete_type"];
    }
	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_deleteEmailInfo];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	[multiSelectedRowString release];

}
-(IBAction) unReadButtonClicked{
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	NSMutableString *multiSelectedRowString = [[NSMutableString alloc]init];
	
	self.selectedRows=[[self.currentTableView indexPathsForSelectedRows] copy];
	NSUInteger i, count = [self.selectedRows count];
	for (i = 0; i < count; i++) {
		NSIndexPath * obj = [selectedRows objectAtIndex:i];
		NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_id"]];
		[multiSelectedRowString appendFormat:@"%@; ", addMailIdString];
	}
	

	
	mode_unRead = YES;
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:multiSelectedRowString forKey:@"mail_id"];
	[requestDictionary setObject:@"0" forKey:@"mail_isread"];

	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_updateUnreadEmailInfo];
	if (rslt != YES) {
			//--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	[multiSelectedRowString release];
	
}

-(void)action_nextCell:(id)sender {
	self.num_pageNum++;
	
	[self loadMoreListComm];
	/*
     if (mode_search == YES) {
     self.num_pageSearch++;
     
     }
	 */
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
	[super setEditing:editing animated:animated]; // must be called first according to Apple docs
	
    [self.currentTableView setEditing:editing animated:animated];
	self.temporaryBarRightButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btn_cancel", @"취소 버튼") style:UIBarButtonItemStyleBordered target:self action:@selector(editCancelMode)]autorelease];
	self.navigationItem.rightBarButtonItem = self.temporaryBarRightButtonItem;
	editModeToolbar.hidden = NO;
	
}
-(IBAction) writeButtonClicked {
	
	MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
	mailWriteController.titleNavigationBar.text = NSLocalizedString(@"mail_new_message",@"새로운 메시지");

	[self.navigationController pushViewController:mailWriteController transition:8];
	
	[mailWriteController release];
}
-(IBAction)mailBoxClicked{
		// ...
		// Pass the selected object to the new view controller.

	
//	Remove the current ViewController from the stack and push the next
    self.detailViewController=(MailDetailController *)[[self.splitViewController.viewControllers objectAtIndex:1] visibleViewController];
    //            self.detailViewController=(MailDetailController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    self.detailViewController.currentRowShowMode = NO;

	UINavigationController *navController = self.navigationController;
	MailController *mailController = [[MailController alloc] initWithNibName:@"MailController" bundle:nil];
	mailController.title = NSLocalizedString(@"mail_box",@"메일함");

	NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
	[controllers removeLastObject];
	
	
	
	navController.viewControllers = controllers;
	[navController pushViewController:mailController animated: NO];
	[mailController release];

}
-(IBAction)mailMove{
//	UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"mail_move_alert",@"mail_move_alert")
//													delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"ok"), nil];
//	[alerts show];	
//	[alerts release];
//	
    self.selectedRows=[[self.currentTableView indexPathsForSelectedRows] copy];

    NSIndexPath * obj = [selectedRows objectAtIndex:0];
    NSString *mailFromName = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_fromname"]];
    NSString *mailFromTitle = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_subject"]];

	NSMutableString *multiSelectedRowString = [[NSMutableString alloc]init];
	NSUInteger i, count = [self.selectedRows count];
	for (i = 0; i < count; i++) {
		NSIndexPath * obj = [selectedRows objectAtIndex:i];
		NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_id"]];
		[multiSelectedRowString appendFormat:@"%@; ", addMailIdString];
	}

    
    
    MailMoveController *mailMoveController = [[MailMoveController alloc]initWithNibName:@"MailMoveController" bundle:nil];
    [self.navigationController pushViewController:mailMoveController transition:8];

    

    [mailMoveController selectedMailID:multiSelectedRowString mailCount:[NSString stringWithFormat:@"%d",[selectedRows count]] folderID:self.folderID mailName:mailFromName mailTitle:mailFromTitle];
    [mailMoveController release];
    
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = NSLocalizedString(@"btn_cancel", @"취소 버튼");
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];

    
    

    
    
    
    
    
    
//    NSMutableString *multiSelectedRowString = [[NSMutableString alloc]init];
//	
//	self.selectedRows=[[self.currentTableView indexPathsForSelectedRows] copy];
//	NSUInteger i, count = [self.selectedRows count];
//	for (i = 0; i < count; i++) {
//		NSIndexPath * obj = [selectedRows objectAtIndex:i];
//		NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.mailList objectAtIndex:obj.row] objectForKey:@"mail_id"]];
//		[multiSelectedRowString appendFormat:@"%@; ", addMailIdString];
//	}
//	
//    
//	
//	mode_unRead = YES;
//	
//	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//	[requestDictionary setObject:multiSelectedRowString forKey:@"mail_id"];
//	[requestDictionary setObject:@"0" forKey:@"mail_isread"];
//    
//	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_updateUnreadEmailInfo];
//	if (rslt != YES) {
//        //--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//		[alert show];
//		[alert release];
//	}
//	[multiSelectedRowString release];
//
}
-(void)returnListMailMove{
//    int i;
//    for (i = 0; i < [self.selectedRows count]; i++) {
//        NSIndexPath * obj = [selectedRows objectAtIndex:i];
//        NSLog(@"%d",obj.row);
//        [self.mailList removeObjectAtIndex:obj.row-i];
//    }
    
    
    
    
//    for (int i=[selectedRows count]-1; i >= 0; i--) {
//        NSIndexPath * obj = [selectedRows objectAtIndex:i];
//        [self.mailList removeObjectAtIndex:obj.row];
//    }

    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i=[selectedRows count]-1; i >= 0; i--) {
        NSIndexPath * obj = [selectedRows objectAtIndex:i];
        [tempArray addObject:[NSString stringWithFormat:@"%d", obj.row ]];
    }
    [tempArray sortUsingSelector: @selector( caseInsensitiveCompare: )];
    
    for (int j=[tempArray count]-1;  j >= 0; j--) {
        NSString * tempString = [tempArray objectAtIndex:j];
        [self.mailList removeObjectAtIndex:[tempString intValue]];
    }
    
    [tempArray release];
    tempArray = nil;

    
    
    
    
    
    [self.currentTableView reloadData];

    

}
-(IBAction)returnMainMenu{
	
	[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)resetListClicked{
	[self resetList];
}
@end

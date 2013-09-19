//
//  SettingBoardController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "SettingBoardController.h"
#import "URL_Define.h"

@implementation SettingBoardController
@synthesize beforeProcessBoardList;
@synthesize afterProcessBoardList;
@synthesize menulist;
#define kNumSections 1

#pragma mark tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	MailListController *mailListController = [[MailListController alloc] initWithNibName:@"MailListController" bundle:nil];
//	mailListController.title = [NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_name"]];
//    // Pass the selected object to the new view controller.
//	
//	UINavigationController *navController = self.navigationController;
//	NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
//	[controllers removeLastObject];
//	navController.viewControllers = controllers;
//	
//	[navController pushViewController:mailListController animated:YES];
//	[mailListController loadDetailContentAtIndex:[NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]]];
//    //	NSLog(@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]);
//	[mailListController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.afterProcessBoardList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//	static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//		NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"MailControllerCustomCell" owner:self options:nil];
//		cell = [topObject objectAtIndex:0];
//    	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//	}
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *dic = [self.afterProcessBoardList objectAtIndex:indexPath.row];
	cell.textLabel.text = [dic objectForKey:@"title"];
    
//    UIView		*viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
//	UISwitch	*switchAutoSave = [[UISwitch alloc] initWithFrame:CGRectMake(0, 6, 94, 27)];
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"ID"] ) [switchAutoSave setOn:YES animated:NO];			
//    else [switchAutoSave setOn:NO animated:NO];
//    
//    [viewCell addSubview:switchAutoSave];
//    [switchAutoSave addTarget:self action:@selector(autoSaveChange:) forControlEvents:UIControlEventValueChanged];
//    cell.accessoryView = viewCell;
//    [switchAutoSave release];
//    [viewCell		release];
    UISwitch* stateSwitch = [[UISwitch alloc] init];
    if ([[dic objectForKey:@"isdefault"]isEqualToString:@"1" ]) {
        stateSwitch.on  = YES;
        stateSwitch.tag = [self rowTagForIndexPath: indexPath];
        stateSwitch.enabled = NO;

    }else{
        stateSwitch.on  = [self rowStateForIndexPath: indexPath];
        stateSwitch.tag = [self rowTagForIndexPath: indexPath];

    }
    // This causes tapping the switch to send an action message to
    // 'target'. Since the switch tag is set above, the target can
    // extract the sender's section and row values from its tag.
    
    cell.accessoryView = stateSwitch;
//    cell.accessoryAction = @selector(actionFlipRowState:);
    [(UISwitch *)cell.accessoryView addTarget:self action:@selector(actionFlipRowState:) forControlEvents:UIControlEventValueChanged];
//    cell.target = self;
    
    [stateSwitch release];
    
    return cell;

    
    
    // Configure the cell.
	
//	NSMutableString *str_cell = [[NSMutableString alloc] init];
//	NSDictionary *tmpDic = [self.afterProcessBoardList objectAtIndex:indexPath.row];
//    
//	if ([[tmpDic objectForKey:@"folder_unreadcount"] intValue] > 0 ) {
//        
//        // add badge view 
//		CustomBadge *replysBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%@", [tmpDic objectForKey:@"folder_unreadcount"]]withStringColor:[UIColor whiteColor] withInsetColor:[UIColor lightGrayColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor]];
//        //		CustomBadge *replysBadge = [CustomBadge customBadgeWithString:@"999"];
//        //		+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor;
//        
//		[replysBadge setFrame:CGRectMake(260, 9, /*replyBadge.frame.size.width*/32, replysBadge.frame.size.height)];
//		[cell addSubview:replysBadge];
//        //		[NSString stringWithFormat:@"%@", [[badge objectAtIndex:0] objectForKey:@"badgecount"]]
//		
//        //(NSString *)[rslt objectForKey:@"code"]
//		
//        
//	}
//	[str_cell appendFormat:@" %@", [tmpDic objectForKey:@"folder_name"]];	
//    
//	if (0==[[tmpDic objectForKey:@"folder_depth"]intValue]) {//폴더 뎁스 0
//		
//		CGRect loadValueRect = CGRectMake(38,3,320,38);
//		UILabel *cellText = [[UILabel alloc] initWithFrame:loadValueRect];
//		cellText.font = [UIFont systemFontOfSize:20];
//		cellText.text = str_cell;
//		[cell.contentView addSubview:cellText];
//		[cellText release];
//		
//		CGRect loadImageRect = CGRectMake(9,9,25,25);
//        
//		UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
//        
//        //cell.textLabel.text = str_cell;
//		if ([[tmpDic objectForKey:@"folder_id"] isEqualToString:inboxID]) {
//			cellImage.image = [UIImage imageNamed:@"icon_inbox.png"];
//			
//		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:sentID]){
//			cellImage.image = [UIImage imageNamed:@"icon_save.png"];
//            
//		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:trashID]){
//			cellImage.image = [UIImage imageNamed:@"icon_delete.png"];
//            
//		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:draftsID]){
//			cellImage.image = [UIImage imageNamed:@"icon_outbox.png"];
//            
//		}else {
//            
//			cellImage.image = [UIImage imageNamed:@"icon_mybox.png"];
//            
//		}
//		[cell.contentView addSubview:cellImage];
//		[cellImage release];
//        //NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]]];
//        
//	}else {
//        
//		int depthLength = 30*[[tmpDic objectForKey:@"folder_depth"]intValue];
//		CGRect loadValueRect = CGRectMake(depthLength+30,3,320,38);
//		UILabel *cellText = [[UILabel alloc] initWithFrame:loadValueRect];
//		cellText.font = [UIFont systemFontOfSize:20];
//		cellText.text = str_cell;
//		[cell.contentView addSubview:cellText];
//        
//		CGRect loadImageRect = CGRectMake(depthLength-3,9,28,25);
//		UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
//        cellImage.image = [UIImage imageNamed:@"icon_mybox.png"];
//        
//        
//		[cell.contentView addSubview:cellImage];
//        //cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
//		[cellText release];
//		[cellImage release];
//        
//	}
    
	
    return cell;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

}

//서버 와 저장된 것 비교 
-(void) saveProcess: (NSMutableArray *)commArray{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if ([userDefault objectForKey:@"settingBoard"] != nil) {
    
    }else{
        
        [userDefault setObject:commArray forKey:@"settingBoard"];
        [userDefault synchronize];

    }

    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithCapacity:0];

    for (int i=0; i < [commArray count]; i++) {
        dic1 = nil;
        dic1 = [commArray objectAtIndex:i];
        NSString *dic1String = [dic1 objectForKey:@"isdefault"];

        if([dic1String isEqualToString:@"1"]){
            [tempArray addObject:dic1];
        }else{
            BOOL findMatchingObject = NO;
            for (int j=0; j < [[userDefault objectForKey:@"settingBoard"] count]; j++) {
                dic2 = nil;
                dic2 = [[userDefault objectForKey:@"settingBoard"] objectAtIndex:j];
                NSString *dic1String = [dic1 objectForKey:@"boardid"];
                NSString *dic2String = [dic2 objectForKey:@"boardid"];

                if ([dic1String isEqualToString:dic2String]) {
                    
                    if([dic2 objectForKey:@"isvisible"] !=nil){//서버에서 온 data에 사용자 저장값만 추가 
                        [dic1 setObject:[dic2 objectForKey:@"isvisible"] forKey:@"isvisible"];
                        [tempArray addObject:dic1];
                    }else{
                        [dic1 setObject:@"0" forKey:@"isvisible"];//사용자 저장값이 없으면 view를 추가해 준다.
                        [tempArray addObject:dic1];
                    }
                    
                    findMatchingObject = YES;
                    break;
                }
                //서버에서 새로 추가된 것일 경우
                if (findMatchingObject == YES) {
                    [tempArray addObject:dic1];
                }
            }
        }
    }
    NSLog(@"%@",tempArray);
    [afterProcessBoardList removeAllObjects];
    [afterProcessBoardList setArray:tempArray];
    [userDefault setObject:afterProcessBoardList forKey:@"settingBoard"];
    [userDefault synchronize];
    NSLog(@"beforeProcessBoardList[%@]", beforeProcessBoardList);
    NSLog(@"afterProcessBoardList[%@]", afterProcessBoardList);

//    tempArray = nil;
//    dic1 = nil;
//    dic2 = nil;
//
//    [tempArray release];
//    [dic1 release];
//    [dic2 release];
    [menulist reloadData];
}



- (NSUInteger) rowTagForIndexPath: (NSIndexPath*) indexPath{
    NSUInteger section = [indexPath section];
    NSUInteger row    = [indexPath row];
    
    return kNumSections * row + section;
}

- (NSUInteger) rowStateForIndexPath: (NSIndexPath*) indexPath
{
    NSMutableDictionary *tempDic = [afterProcessBoardList objectAtIndex:indexPath.row];
    if ([tempDic objectForKey:@"isvisible"] != nil) {
        if ([[tempDic objectForKey:@"isvisible"]isEqualToString:@"1"]) {
            return YES;

        }else{
            return NO;

        }
            
    }else{
        return YES;

    }
}
- (void) actionFlipRowState: (id) sender
{
    NSLog(@"Settings: -actionFlipRowState:");
    
    UISwitch* view = (UISwitch*) sender;
    
    NSUInteger tag = [view tag];
    
    NSUInteger row = tag / kNumSections;
//    NSUInteger section = tag % kNumSections;
    NSLog(@"%@",sender);


    if(view.on){
        NSLog(@"on");
        NSMutableDictionary *tempdic = [afterProcessBoardList objectAtIndex:row];
        [tempdic setObject:@"1" forKey:@"isvisible"];
        tempdic = nil;

        [tempdic release];
        
    }else{
        NSLog(@"off");
        NSLog(@"%@", afterProcessBoardList);
        NSMutableDictionary *tempdic = [afterProcessBoardList objectAtIndex:row];
        [tempdic setObject:@"0" forKey:@"isvisible"];
        NSLog(@"%@", afterProcessBoardList);
        tempdic = nil;

        [tempdic release];
    }

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.afterProcessBoardList forKey:@"settingBoard"];
    [userDefault synchronize];
    userDefault = nil;
    [userDefault release];

    // Flip the boolean state associated with
    // the given row and section values.
}
- (IBAction)comm:(id)sender{
    [self saveProcess:beforeProcessBoardList];
}

#pragma mark communication


-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
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
	
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
    
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc]initWithCapacity:0];
    
	tempMutableArray = (NSMutableArray *)[_resultDic objectForKey:@"boplist"];
	
    
//	[tempMutableArray release];
//    tempMutableArray = nil;
	
    // -- set label if success -- //
	if (rslt != nil && resultNum == 0) {
        [self saveProcess:tempMutableArray];

		[self.menulist reloadData];
//		self.menulist.hidden = NO;
		self.menulist.userInteractionEnabled = YES;
        //self.cm = nil;
	} else {
        // -- error handling -- //
        // Show alert view to user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];	
		[alert release];
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


-(void)tr_data {
    
    
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //	[requestDictionary setObject:@"1001" forKey:@"compcd"];
    //	[requestDictionary setObject:@"1" forKey:@"cpage"];
    //	[requestDictionary setObject:@"10" forKey:@"maxrow"];
	int rslt = [cm callWithArray:requestDictionary serviceUrl:getBoardListCollection];
	if (rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}		
	
}

#pragma mark system method


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"게시판 설정";
//	beforeProcessBoardList = [[NSMutableArray alloc] init];
	afterProcessBoardList = [[NSMutableArray alloc] initWithCapacity:0];
    
    
//    for (int i=1; i<5; i++) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        if (i%2==0) {
//            [dic setObject:[NSString stringWithFormat:@"dic%d", i ] forKey:@"board"];
//            [dic setObject:@"Y" forKey:@"default"];
//            
//            
//        }else{
//            [dic setObject:[NSString stringWithFormat:@"dic%d", i ] forKey:@"board"];
//            [dic setObject:@"N" forKey:@"default"];
//            
//        }
//
//        [beforeProcessBoardList addObject:dic];
//        [dic release];
//        
//    }
//    
//    for (int i=2; i<6; i++) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        
//        [dic setObject:[NSString stringWithFormat:@"dic%d", i ] forKey:@"board"];
//        [dic setObject:@"Y" forKey:@"view"];
//        [dic setObject:@"Y" forKey:@"default"];
//
//        [afterProcessBoardList addObject:dic];
//        [dic release];
//        
//    }
//    NSLog(@"beforeProcessBoardList[%@]", beforeProcessBoardList);
//    NSLog(@"afterProcessBoardList[%@]", afterProcessBoardList);
    [self.menulist reloadData];
    
    
    //	self.currentTableView.delegate = self;
    //	self.currentTableView.dataSource = self;	self.title = @"메일함";
    //	
    //	
    //	self.navigationItem.hidesBackButton = YES;
    
    
    
    
    
    //    for (NSDictionary *dic in beforeProcessBoardList) {
    //        NSLog(@"[%@]", dic);
    //    }
    //
    //    for (NSDictionary *dic in afterProcessBoardList) {
    //        NSLog(@"[%@]", dic);
    //    }
    
    //
    //    for (int i = 0; <#condition#>; <#increment#>) {
    //        <#statements#>
    //    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated {
    
//	[self.currentTableView reloadData];	
    
	[self tr_data]; 
	
	
}

-(void)viewWillDisappear:(BOOL)animated {
//	refreshButton.enabled = YES;
//    
//	[indicator stopAnimating];
//	
//	if (cm != nil) {
//		[cm cancelCommunication];
//		cm.delegate = nil;
//		cm=nil;
//	}	
//	
	[super viewWillDisappear:animated];
	
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


- (void)dealloc {
    //	[mailList release];
    [super dealloc];
}



#pragma mark button Event

@end

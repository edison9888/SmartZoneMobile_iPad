//
//  MailMoveController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 9. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MailMoveController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MailMoveController
@synthesize currentTableView;
@synthesize menuList;
@synthesize selectedMailID;
@synthesize folderID;
@synthesize titleLabel;
@synthesize nameLabel;
@synthesize moveInfo;
#define inboxID @"1"
#define sentID @"3"
#define trashID @"4"
#define draftsID @"2"


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
#pragma mark tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	MailListController *mailListController = [[MailListController alloc] initWithNibName:@"MailListController" bundle:nil];
//	mailListController.title = [NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_name"]];
    // Pass the selected object to the new view controller.
	
//	UINavigationController *navController = self.navigationController;
//	NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
//	[controllers removeLastObject];
//	navController.viewControllers = controllers;
//	
//	[navController pushViewController:mailListController animated:YES];
//	[mailListController loadDetailContentAtIndex:[NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]]];
//    //	NSLog(@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]);
//	[mailListController release];
	
    cm = [[Communication alloc] init];
	[cm setDelegate:self];
    NSDictionary *tmpDic = [self.menuList objectAtIndex:indexPath.row];

	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [requestDictionary setObject:self.selectedMailID forKey:@"mail_id"];
    [requestDictionary setObject:[tmpDic objectForKey:@"folder_id"] forKey:@"folderid"];
    //	[requestDictionary setObject:@"10" forKey:@"maxrow"];
    moveAction = YES;

	int rslt = [cm callWithArray:requestDictionary serviceUrl:moveEmailInfo];
	if (rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
    [requestDictionary release];
    [tmpDic release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//	static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        
//        
//	}
    
    //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    NSArray *topObject = [[NSBundle mainBundle] loadNibNamed:@"MailControllerCustomCell" owner:self options:nil];
    UITableViewCell *cell = [topObject objectAtIndex:0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.userInteractionEnabled = YES;

    
    // Configure the cell.
	
	NSMutableString *str_cell = [[NSMutableString alloc] init];
	NSDictionary *tmpDic = [self.menuList objectAtIndex:indexPath.row];
    
	[str_cell appendFormat:@" %@", [tmpDic objectForKey:@"folder_name"]];	
    
	if (0==[[tmpDic objectForKey:@"folder_depth"]intValue]) {//폴더 뎁스 0
		
		CGRect loadValueRect = CGRectMake(38,3,320,38);
		UILabel *cellText = [[UILabel alloc] initWithFrame:loadValueRect];
		cellText.font = [UIFont systemFontOfSize:20];
		cellText.text = str_cell;
        if ([folderID isEqualToString:[tmpDic objectForKey:@"folder_id"]]) {
            cell.userInteractionEnabled = NO;
            cellText.textColor = [UIColor lightGrayColor];
            
        }

		[cell.contentView addSubview:cellText];
		[cellText release];
		
		CGRect loadImageRect = CGRectMake(9,9,25,25);
        
		UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
        
        //cell.textLabel.text = str_cell;
		if ([[tmpDic objectForKey:@"folder_id"] isEqualToString:inboxID]) {
			cellImage.image = [UIImage imageNamed:@"icon_inbox.png"];
			
		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:sentID]){
			cellImage.image = [UIImage imageNamed:@"icon_save.png"];
            
		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:trashID]){
			cellImage.image = [UIImage imageNamed:@"icon_delete.png"];
            
		}else if([[tmpDic objectForKey:@"folder_id"] isEqualToString:draftsID]){
			cellImage.image = [UIImage imageNamed:@"icon_outbox.png"];
            
		}else {
            
			cellImage.image = [UIImage imageNamed:@"icon_mybox.png"];
            
		}
		[cell.contentView addSubview:cellImage];
		[cellImage release];
        //NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]]];
	}else {
        
		int depthLength = 30*[[tmpDic objectForKey:@"folder_depth"]intValue];
		CGRect loadValueRect = CGRectMake(depthLength+30,3,320,38);
		UILabel *cellText = [[UILabel alloc] initWithFrame:loadValueRect];
		cellText.font = [UIFont systemFontOfSize:20];
		cellText.text = str_cell;
        if ([folderID isEqualToString:[tmpDic objectForKey:@"folder_id"]]) {
            cell.userInteractionEnabled = NO;
            cellText.textColor = [UIColor lightGrayColor];
            cell.userInteractionEnabled = NO;

        }

		[cell.contentView addSubview:cellText];
        
		CGRect loadImageRect = CGRectMake(depthLength-3,9,28,25);
		UIImageView *cellImage = [[UIImageView alloc] initWithFrame:loadImageRect];
        cellImage.image = [UIImage imageNamed:@"icon_mybox.png"];
        
        
		[cell.contentView addSubview:cellImage];
        //cell.imageView.image = [UIImage imageNamed:@"notice_tableicon.png"];
		[cellText release];
		[cellImage release];
        
	}
    
	
    return cell;
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
    if ([_resultDic objectForKey:@"folderitemlist"]!= nil) {
        self.menuList = nil;
        
        self.menuList = (NSMutableArray *)[_resultDic objectForKey:@"folderitemlist"];

    }
	
	
	
	
	
    // -- set label if success -- //
	if (rslt != nil && resultNum == 0) {
        if (moveAction == YES) {
            [self.navigationController popViewControllerAnimated:YES];
            moveAction = NO;

        
        
        	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
            
            [noti postNotificationName:@"returnListMailMove" object:nil];

        
        
        }else{
            [self.currentTableView reloadData];
            self.currentTableView.hidden = NO;
            self.currentTableView.userInteractionEnabled = YES;
            moveAction = NO;

        }
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
    moveAction = NO;

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
	int rslt = [cm callWithArray:requestDictionary serviceUrl:URL_getEmailFolerInfo];
	if (rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"<통신 장애 발생>"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		[alert show];	
		[alert release];
	}		
	
}
-(void) selectedMailID:(NSString *)mailID mailCount:(NSString *)index folderID:(NSString *)folder_id mailName:(NSString *)mail_name mailTitle:(NSString *)mail_title{
    //index 0:리스트에서, 1:디테일에서
    self.nameLabel.text = mail_name;
    
    self.folderID = folder_id ;
    if ([index intValue] >1) {
        moveInfo.text = NSLocalizedString(@"move_info_more",@"이동안내 하나이상메시지 ");
        self.titleLabel.text = [NSString stringWithFormat:@"%@개의 메시지", index];
    }else{
        self.titleLabel.text = mail_title;
        moveInfo.text = NSLocalizedString(@"move_info",@"이동안내 메시지");
    }
    self.selectedMailID = mailID;
//    if ([selectedRows count]>1) {
//        moveInfo.text = NSLocalizedString(@"move_info_more",@"이동안내 하나이상메시지 ");
//    }else if([selectedRows count]==1){
//        moveInfo.text = NSLocalizedString(@"move_info",@"이동안내 메시지");

//    }
//    NSLog(@"%@",[self.selectedRows objectAtIndex:0]);
    
//    [mailMoveController moveMailID:selectedRows moveType:@"0" folderID:self.folderID];

    
    
    
}
#pragma mark system method

-(void)viewDidLoad {
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

	self.currentTableView.delegate = self;
	self.currentTableView.dataSource = self;	self.title = @"메일함";
	
//	self.navigationItem.hidesBackButton = NO;
    //	int count = [self.navigationController.viewControllers count];
    //	NSLog(@"%d", count);
	
	moveAction = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
	[self.currentTableView reloadData];	
    
	[self tr_data]; 
	
	
}

-(void)viewWillDisappear:(BOOL)animated {
    //	[self.view removeFromSuperview];
    
	[indicator stopAnimating];
	
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
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
    [currentTableView release];
	[indicator release];
	[cm release];
//	[menuList release];
    [titleLabel release];
    [nameLabel release];
	[selectedMailID release];
    [moveInfo release];
    [folderID release];

    [super dealloc];
}



#pragma mark button Event

-(IBAction)refresh{
	[self tr_data];
}

@end

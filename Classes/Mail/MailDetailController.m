//
//  MailDetailController.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 24..
//  Copyright 2011 ktds. All rights reserved.
//

#import "MailDetailController.h"
#import "URL_Define.h"
#import "MailWriteController.h"
#import "MailListController.h"
#import "NSDictionary+NotNilReturn.h"
#import "AttachmentCustomCell.h"
#import "IsInlineCustomCell.h"
#import "MailAttachmentViewController.h"
//for ipad
#import "CustomSubTabViewController.h"

@interface MailDetailController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
//- (void)configureView;
@end


@implementation MailDetailController
@synthesize folderID;
@synthesize contentWebView;
@synthesize contentTableView;
@synthesize contentDictionary;
@synthesize mainContentCell;
@synthesize titleCell;
@synthesize nameCell, toNameCell,ccCell, isInlineCell;
@synthesize clipboard;
@synthesize indicator;
@synthesize webViewHeight;
@synthesize webviewLoadFlag;
@synthesize webopen;
@synthesize contentString;
@synthesize clientHeight, clientWidth;
@synthesize currentTableList, currentRow;
@synthesize segmentedControl;
@synthesize mode_trash, mode_unRead;
@synthesize trashButton;
@synthesize markUnRead;
@synthesize markUnReadImage;
@synthesize attachmentArray;
@synthesize isInLineIndex;
@synthesize isInLineMode;

@synthesize handle;
@synthesize receivedLength;
@synthesize receivedData;
@synthesize filesize;
@synthesize progressView;
@synthesize realMailBody;
@synthesize isInLineMailBody;
@synthesize isInLineCountIndex;
@synthesize isInLineEnable;
@synthesize attachmentFileArray;
@synthesize toolbarLabel;
//for ipad
@synthesize mainButton, listButton;
@synthesize imageView;
@synthesize menuTabbarView;
@synthesize subMenu;
@synthesize mailToolbar, popoverController;
@synthesize imageViewHiddenMode;
@synthesize currentRowShowMode;





@synthesize detailRowType;
@synthesize detailRowBool;
@synthesize detailRowButton, hideRowButton;

//@synthesize mailListController;

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
#pragma mark -
#pragma mark system method


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    currentRowShowMode = NO;//처음 디테일 왔을때 한번만 실행
    self.toolbarLabel.text = @"";
//    self.mailListController = [[self.splitViewController viewControllers]objectAtIndex:0];
    imageViewHiddenMode = NO;
    self.subMenu = [[CustomSubTabViewController alloc] initWithNibName:@"CustomSubTabViewController" bundle:nil];
	[self.subMenu.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
	[self.menuTabbarView addSubview:self.subMenu.view];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    noti = [NSNotificationCenter defaultCenter];
	[noti addObserver:self selector:@selector(popForFirstAppear) name:@"popForFirstAppear" object:nil];
    [noti addObserver:self selector:@selector(imagehidden) name:@"imagehidden" object:nil];
    [noti addObserver:self selector:@selector(imagehiddenNo) name:@"imagehiddenNo" object:nil]; 
    [noti addObserver:self selector:@selector(delReloadContentTableView) name:@"delReloadContentTableView" object:nil];


    
    self.detailRowBool = NO;
    self.detailRowButton.hidden = NO;
    self.hideRowButton.hidden = YES;
    
    [self detailHideRowSettringProcess];

    
    
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
	self.contentTableView.allowsSelection = NO;
	self.contentWebView.delegate = self;
	self.contentDictionary = nil;
	self.clipboard = nil;
	self.webviewLoadFlag = 0;
//	self.webViewHeight = 335.0f;
	self.webViewHeight = 600.0f;

	self.webopen = nil;
    self.contentString = [[NSMutableString alloc]init];
    
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
	
	mode_trash = NO;
	mode_unRead = NO;
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
						[NSArray arrayWithObjects:
						 [UIImage imageNamed:@"up.png"],
						 [UIImage imageNamed:@"down.png"],
						 nil]];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 90, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
	
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
//    self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
	contactModel = [ContactModel sharedInstance];
    self.attachmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.attachmentFileArray= [[NSMutableArray alloc]initWithCapacity:0];
	isInLineMode = NO;
    isInLineIndex = 0;
    isInLineEnable = 0;
    self.folderID = @"";
    
//    NSLog(@"window:%@", self.view.window);

}
- (void)viewWillAppear:(BOOL)animated {
    

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
//    NSLog(@"window:%@", self.view.window);


}

- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
    self.imageView.hidden = YES;

	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];

}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 //return (interfaceOrientation == UIInterfaceOrientationPortrait);
 if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
 return NO;
 }
 return YES;
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
    
    //for ipad
    self.popoverController = nil;

}


- (void)dealloc {
    [contentWebView release];	
	[contentTableView release];
	[contentDictionary release];
	[mainContentCell release];
	[titleCell release];
	[nameCell release];
	[toNameCell release];
	[ccCell release];
	[clipboard release];
	[indicator release];
	[webopen release];
	[contentString release];
    //	[currentTableList release];
	[trashButton release];
	[markUnRead release];
	[markUnReadImage release];
    [attachmentArray release];
    [folderID release];
    [attachmentFileArray release];
    
    
    //for ipad
    [popoverController release];
	[mailToolbar release];
	[mainButton release];
	[imageView release];
	[menuTabbarView release];
	[subMenu release];

    [imageView release];

    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int j;// 참조 가 없을경우 표시 안하기 위해 
    if (self.detailRowBool == YES) {//상세버튼 클릭 시
        if ([self.contentDictionary objectForKey:@"mail_displaycc"] != nil) {
            j = 5;
        }else{
            j = 4;
        }
    }else{
        j = 3;
    }
    
    if ([self.attachmentArray count]>0) {
        int i = 0;
        for (NSDictionary *dic in attachmentArray) {
            if ([[dic objectForKey:@"attachment_isinline"]isEqualToString:@"0"]) {
                i++;
            }
        }
        switch (section) {
            case 0:
                return j;
                break;
            case 1:
                return i;
                break;
            case 2:
                
                return isInLineEnable; 
                
                break;
                
            default:
                break;
        }
        //        return section == 0 ? 5 : i ;
        
    }else{
        //        return section == 0 ? 5 : 0 ;
        switch (section) {
            case 0:
                return j;
                break;
            case 1:
                return 0;
                break;
            case 2:
                return 0;
                break;
                
            default:
                break;
        }
        
    }
    
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    static NSString *CellIdentifier = @"Cell";
    if (self.detailRowBool == YES) {
        self.detailRowButton.hidden = YES;
        self.hideRowButton.hidden = NO;
    }else{
        self.detailRowButton.hidden = NO;
        self.hideRowButton.hidden = YES;
        
    }

    
	UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (self.detailRowBool == YES) {//상세버튼 클릭 시
            if([self.contentDictionary objectForKey:@"mail_displaycc"] !=nil){// 참조 가 없을경우 표시 안하기 위해 
                if (indexPath.row == 0) {
                    UILabel *mailFromID = (UILabel *)[titleCell viewWithTag:111];//보낸사람 1번셀
                    if([self.folderID isEqualToString:@"2"])
                        mailFromID.text = NSLocalizedString(@"mail_tmp_save_no_sender", @"[발신자 없음]");
                    else
                        mailFromID.text = [self.contentDictionary objectForKey:@"mail_fromname"];
                    cell = titleCell;
                } else if (indexPath.row == 1) {
                    UILabel *mail_addressto = (UILabel *)[toNameCell viewWithTag:112];//받는사람 2번셀
                    //		mail_addressto.text = [self.contentDictionary objectForKey:@"mail_addressto"];
                    mail_addressto.text = [self.contentDictionary objectForKey:@"mail_displayto"];
                    cell = toNameCell;
                }else if (indexPath.row == 2) {
                    UILabel *mail_displaycc = (UILabel *)[ccCell viewWithTag:133];//cc 3번셀
                    mail_displaycc.text = [self.contentDictionary objectForKey:@"mail_displaycc"];
                    
                    cell = ccCell;
                }else if (indexPath.row == 3) {
                    UILabel *mailSubject = (UILabel *)[nameCell viewWithTag:222];//메일제목 4번셀
                    mailSubject.text = [self.contentDictionary objectForKey:@"mail_subject"];
                    
                    UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];//받은시간 4번셀
                    tempDate.text = [self.contentDictionary objectForKey:@"mail_receivedtime"];
                    cell = nameCell;
                }  else if (indexPath.row == 4) {
                    cell = mainContentCell;
                }
                
            }else{
                if (indexPath.row == 0) {
                    UILabel *mailFromID = (UILabel *)[titleCell viewWithTag:111];//보낸사람 1번셀
                    if([self.folderID isEqualToString:@"2"])
                        mailFromID.text = NSLocalizedString(@"mail_tmp_save_no_sender", @"[발신자 없음]");
                    else
                        mailFromID.text = [self.contentDictionary objectForKey:@"mail_fromname"];
                    cell = titleCell;
                } else if (indexPath.row == 1) {
                    UILabel *mail_addressto = (UILabel *)[toNameCell viewWithTag:112];//받는사람 2번셀
                    //		mail_addressto.text = [self.contentDictionary objectForKey:@"mail_addressto"];
                    mail_addressto.text = [self.contentDictionary objectForKey:@"mail_displayto"];
                    cell = toNameCell;
                }else if (indexPath.row == 2) {
                    UILabel *mailSubject = (UILabel *)[nameCell viewWithTag:222];//메일제목 4번셀
                    mailSubject.text = [self.contentDictionary objectForKey:@"mail_subject"];
                    
                    UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];//받은시간 4번셀
                    tempDate.text = [self.contentDictionary objectForKey:@"mail_receivedtime"];
                    cell = nameCell;
                }  else if (indexPath.row == 3) {
                    cell = mainContentCell;
                }
                
            }
            
        }else{
            if (indexPath.row == 0) {
                UILabel *mailFromID = (UILabel *)[titleCell viewWithTag:111];//보낸사람 1번셀
                if([self.folderID isEqualToString:@"2"])
                    mailFromID.text = NSLocalizedString(@"mail_tmp_save_no_sender", @"[발신자 없음]");
                else
                    mailFromID.text = [self.contentDictionary objectForKey:@"mail_fromname"];
                cell = titleCell;
            }else if (indexPath.row == 1) {
                UILabel *mailSubject = (UILabel *)[nameCell viewWithTag:222];//메일제목 4번셀
                mailSubject.text = [self.contentDictionary objectForKey:@"mail_subject"];
                
                UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];//받은시간 4번셀
                tempDate.text = [self.contentDictionary objectForKey:@"mail_receivedtime"];
                cell = nameCell;
            }  else if (indexPath.row == 2) {
                cell = mainContentCell;
            }
            
        }
        
        
    }
    else if (indexPath.section == 1 ) {//첨부
        //		NSLog(@"%@",indexPath);
		cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachmentCustomCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"AttachmentCustomCell")]) {
                    cell = oneObject;
                }
            }
            
        }
        //		NSLog(@"asdfasdfasdfasdfadsf%d",indexPath.row);
		AttachmentCustomCell *tmpCell = (AttachmentCustomCell *)cell;
		NSDictionary *dic_current = [self.attachmentFileArray objectAtIndex:indexPath.row];
        NSLog(@"%@", dic_current);
        //        tmpCell.iconTitleLabel.text = nil;
        //        tmpCell.iconTitleLabel.text = [dic_current objectForKey:@"attachment_name"];
        if ([[dic_current objectForKey:@"attachment_isinline"]isEqualToString:@"0"]) {// mail 바디 안 이미지 표시는 첨부파일로 표시 안함
            
            UILabel *tempDate = (UILabel *)[tmpCell viewWithTag:111];//받은시간 4번셀
            tempDate.text = [dic_current objectForKey:@"attachment_name"];
            UILabel *tempSize = (UILabel *)[tmpCell viewWithTag:333];//받은시간 4번셀
            int sizeKB = [[dic_current objectForKey:@"attachment_size"]intValue]/1024;
            NSLog(@"asdfasdfasdf[%@]", dic_current);
            tempSize.text =  [NSString stringWithFormat:@"%dKB",sizeKB ];
            if ([[dic_current objectForKey:@"attachment_isfile"]isEqualToString:@"1"]) {
                UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
                btn_tmp.tag = indexPath.row;
                [btn_tmp addTarget:self action:@selector(action_paymentAttachFile:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
                btn_tmp.tag = indexPath.row;
                UIImage *backImage = [UIImage imageNamed:@"emailAttachementAdd.PNG"];
                [btn_tmp setBackgroundImage:backImage forState:UIControlStateNormal];
                
                [btn_tmp addTarget:self action:@selector(action_paymentAttachFile:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        cell = tmpCell;
        
        
	}
    
	else if(indexPath.section == 2){// inline 첨부 표시 여부 
        cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IsInlineCustomCell" owner:self options:nil];
            
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:NSClassFromString(@"IsInlineCustomCell")]) {
                    cell = oneObject;
                }
            }
            
        }
		IsInlineCustomCell *tmpCell = (IsInlineCustomCell *)cell;
        
        //        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //
        //        CGRect loadValueRect = CGRectMake(7,0,260,21);
        //        UILabel *mailFromID = [[UILabel alloc] initWithFrame:loadValueRect];
        //        mailFromID.font = [UIFont boldSystemFontOfSize:14];
        //        mailFromID.text = @"asdfasdf";
        //        [cell.contentView addSubview:mailFromID];
        //        [mailFromID release];
        
        
        UILabel *tempText = (UILabel *)[tmpCell viewWithTag:155];//받은시간 4번셀
        tempText.text = NSLocalizedString(@"inline_Attach", @"현재 텍스트 모드 입니다. 본문에 이미지를 표시하시려면 여기를 클릭하세요.");
        UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
        btn_tmp.tag = indexPath.row;
        [btn_tmp addTarget:self action:@selector(action_isInlineImageView:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = tmpCell;
        
    }
    return cell;
	
	
	
	
}
-(void)action_paymentAttachFile:(id)sender {
	UIButton *btn_tmp = (UIButton *)sender;
	int index = btn_tmp.tag;
	
    //	self.dic_docattachlistinfo = [[NSMutableDictionary alloc] init];
    //    
    //	NSDictionary *dic_tmp = [arr_docattachlistinfo objectAtIndex:index];
    //	
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"docid"] forKey:@"docid"];
    //	[self.dic_docattachlistinfo setObject:[dic_tmp objectForKey:@"attachdocurl"] forKey:@"href"];
    
    //	[self action_paymentOriginalPdfCell];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"뒤로";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];	
    
    NSString *mailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
    NSString *indexString = [NSString stringWithFormat:@"%d", index];
    NSDictionary *dic_current = [self.attachmentFileArray objectAtIndex:index];
    
    MailAttachmentViewController *mailAttachmentViewController = [[MailAttachmentViewController alloc] initWithNibName:@"MailAttachmentViewController" bundle:nil];
    mailAttachmentViewController.title = self.title;
    //    
    //    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:mailAttachmentViewController animated:YES];

    [self presentModalViewController:mailAttachmentViewController animated:YES];
    [mailAttachmentViewController loadAttachmentMailID:mailIdString attachmentIndex:[dic_current objectForKey:@"fileIndex"] attachmentName:[dic_current objectForKey:@"attachment_name"] attachmentIsFile:[dic_current objectForKey:@"attachment_isfile"]];

    //    
    [mailAttachmentViewController release];
    
    
    
    
}

//-(IBAction)action_paymentOriginalPdfCell {
//	
//	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//	temporaryBarButtonItem.title = @"뒤로";
//	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];	
//    
//	ConfirmFileViewController *fileViewController = [[ConfirmFileViewController alloc] initWithNibName:@"ConfirmFileViewController" bundle:nil];
//	fileViewController.selectedCategory = self.selectedCategory;
//	fileViewController.dic_selectedItem = self.dic_selectedItem;
//	fileViewController.dic_approvaldocinfo = self.approvaldocinfo;
//	fileViewController.dic_docattachlistinfo = self.dic_docattachlistinfo;
//    
//	[self.navigationController pushViewController:fileViewController animated:YES];
//	[fileViewController release];
//	
//}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        NSString *mailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
        NSString *index = [NSString stringWithFormat:@"%d", indexPath.row];
        NSDictionary *dic_current = [self.attachmentArray objectAtIndex:indexPath.row];
        
        MailAttachmentViewController *mailAttachmentViewController = [[MailAttachmentViewController alloc] initWithNibName:@"MailAttachmentViewController" bundle:nil];
        //    mailAttachmentViewController.title = self.title;
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:mailAttachmentViewController animated:YES];
        
        [mailAttachmentViewController loadAttachmentMailID:mailIdString attachmentIndex:index attachmentName:[dic_current objectForKey:@"attachment_name"] attachmentIsFile:[dic_current objectForKey:@"attachment_isfile"]];
        
        [mailAttachmentViewController release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }else if(indexPath.section == 2){
        [self imageView:@""];
    }
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITextView *tempView;
	CGSize newSize;
	
	/*= newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
	 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
	 constrainedToSize:CGSizeMake(320,99999)
	 lineBreakMode:UILineBreakModeWordWrap];*/
    
    
    
    
	if (indexPath.section==0) {
        if (self.detailRowBool == YES) {//상세버튼 클릭 시
            
            if([self.contentDictionary objectForKey:@"mail_displaycc"] !=nil){// 참조 가 없을경우 표시 안하기 위해
                
                switch (indexPath.row) {
                    case 0:
                        //return 40.0;
                        ////NSLog(@"%@", [self.contentDictionary objectForKey:@"bulltitle"]);
                        newSize = [[self.contentDictionary objectForKey:@"mail_fromname"]
                                   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                                   constrainedToSize:CGSizeMake(674,99999)
                                   lineBreakMode:UILineBreakModeWordWrap];
                        ////NSLog(@"%d", newSize);
                        if (newSize.height <= 40.0f) {
                            return 40.0;
                        } else {
                            return newSize.height + 10.0;// 5px margin
                        }
                        
                        ////NSLog(@"%f", newSize.height);
                        return newSize.height + 5.0;// 5px margin
                        break;
                        
                    case 1:
                        newSize = [[self.contentDictionary objectForKey:@"mail_displayto"]
                                   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                                   constrainedToSize:CGSizeMake(674,99999)
                                   lineBreakMode:UILineBreakModeWordWrap];
                        //				NSLog(@"%d", newSize.height);
                        if (newSize.height <= 40.0f) {
                            return 40.0;
                            
                        } else {
                            return newSize.height + 10.0;// 5px margin
                        }
                        
                        ////NSLog(@"%f", newSize.height);
                        return newSize.height + 5.0;// 5px margin
                        
                        break;
                        
                        
                    case 2:
                        newSize = [[self.contentDictionary objectForKey:@"mail_displaycc"]
                                   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                                   constrainedToSize:CGSizeMake(674,99999)
                                   lineBreakMode:UILineBreakModeWordWrap];
                        ////NSLog(@"%d", newSize);
                        if (newSize.height <= 40.0f) {
                            return 40.0;
                        } else {
                            return newSize.height + 10.0;// 5px margin
                        }
                        
                        ////NSLog(@"%f", newSize.height);
                        return newSize.height + 5.0;// 5px margin
                        
                        break;
                    case 3:
                        return 40.0;
                        break;
                        
                    case 4:
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
                            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                            // Landscape mode
                            return 505.0f;
                            
                        } else {
                            // Portrait mode
                            return 765.0f;
                        }
                        break;
                    default:
                        return 44.0;
                        break;
                }
                
                
            }else{
                switch (indexPath.row) {
                    case 0:
                        //return 40.0;
                        ////NSLog(@"%@", [self.contentDictionary objectForKey:@"bulltitle"]);
                        newSize = [[self.contentDictionary objectForKey:@"mail_fromname"]
                                   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                                   constrainedToSize:CGSizeMake(674,99999)
                                   lineBreakMode:UILineBreakModeWordWrap];
                        ////NSLog(@"%d", newSize);
                        if (newSize.height <= 40.0f) {
                            return 40.0;
                        } else {
                            return newSize.height + 10.0;// 5px margin
                        }
                        
                        ////NSLog(@"%f", newSize.height);
                        return newSize.height + 5.0;// 5px margin
                        break;
                        
                    case 1:
                        newSize = [[self.contentDictionary objectForKey:@"mail_displayto"]
                                   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                                   constrainedToSize:CGSizeMake(674,99999)
                                   lineBreakMode:UILineBreakModeWordWrap];
                        //				NSLog(@"%d", newSize.height);
                        if (newSize.height <= 40.0f) {
                            return 40.0;
                            
                        } else {
                            return newSize.height + 10.0;// 5px margin
                        }
                        
                        ////NSLog(@"%f", newSize.height);
                        return newSize.height + 5.0;// 5px margin
                        
                        break;
                        
                        
                    case 2:
                        return 40.0;
                        
                        break;
                    case 3:
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
                            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                            // Landscape mode
                            return 505.0f;
                            
                        } else {
                            // Portrait mode
                            return 765.0f;
                        }
                        break;
                        
                    default:
                        return 44.0;
                        break;
                }
                
            }
            
        }else{//상세버튼 클릭 아닐 시
            switch (indexPath.row) {
                case 0:
                    //return 40.0;
                    ////NSLog(@"%@", [self.contentDictionary objectForKey:@"bulltitle"]);
                    newSize = [[self.contentDictionary objectForKey:@"mail_fromname"]
                               sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                               constrainedToSize:CGSizeMake(674,99999)
                               lineBreakMode:UILineBreakModeWordWrap];
                    ////NSLog(@"%d", newSize);
                    if (newSize.height <= 40.0f) {
                        return 40.0;
                    } else {
                        return newSize.height + 10.0;// 5px margin
                    }
                    
                    ////NSLog(@"%f", newSize.height);
                    return newSize.height + 5.0;// 5px margin
                    break;
                case 1:
                    return 40.0;
                    break;
                case 2:
                    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
                        || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                        // Landscape mode
                        return 505.0f;
                        
                    } else {
                        // Portrait mode
                        return 765.0f;
                    }
                    break;
                default:
                    return 44.0;
                    break;
            }
            
        }
        
        
    }else{
        return 44.0;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.imageView.hidden = YES;
	[self.contentTableView reloadData];
	self.contentTableView.hidden = NO;

    //	NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML;"];
    [self.contentString setString:@""];
	[contentString appendFormat:@"\n\n\n\n%@", [self.contentDictionary objectForKey:@"mail_receivedtime"]];
	[contentString appendFormat:@" '%@' ", [self.contentDictionary objectForKey:@"mail_fromname"]];
	[contentString appendFormat:@"''%@'' 작성:<br><br>", [self.contentDictionary objectForKey:@"mail_fromaddress"]];
	[contentString appendFormat:@"\n %@", self.realMailBody];
    
    //  	NSLog ( @"Client height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth"] );
    //	
    //	NSLog ( @"Client height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] );
    //	
    //	NSLog ( @"Client height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.pixelWidth"] );
    //	
	
//    if (webView.subviews.count > 0) {
//        UIScrollView *scrollerView = [webView.subviews objectAtIndex:0];
//        if (scrollerView.subviews.count > 0) {
//			if (self.webviewLoadFlag == 0) {
//				self.webviewLoadFlag = 1;
//				UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
//				CGRect currentFrame = tempView.frame;
//                //                tempView.scalesPageToFit = YES;				
//                //                [tempView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 10;"];
//                
//                if (tempView.subviews.count > 0) {
//					UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
////                    scrollerView.contentSize = CGSizeMake(768, 354);
//                    scrollerView.contentSize = CGSizeMake(768, 866);
//					[scrollerView setAutoresizingMask :( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight )];
//                    //CGSize scrollFrame = scrollerView.contentSize;
//				}
//                
//				CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, scrollerView.contentSize.width, self.webViewHeight);
//				tempView.frame = newFrame;
//                
//				[self.contentTableView reloadData];
//                //                BOOL animationsEnabled = [UIView areAnimationsEnabled];
//                //                [UIView setAnimationsEnabled:NO];
//                //                [self.contentTableView beginUpdates];
//                //                [self.contentTableView endUpdates];
//                //                [UIView setAnimationsEnabled:animationsEnabled];
//                
//				self.contentTableView.hidden = NO;
//				self.contentTableView.userInteractionEnabled = YES;
//                
//			}
//        }
//    }
	[self.indicator stopAnimating];
//    NSLog(@"window:%@", self.view.window);
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];

}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // check link click and prevent navatationing
    //	if ([[request.URL scheme] isEqualToString:@"toAPP"] ) {
    //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"attachment_file", @"첨부파일 보기")
    //													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
    //		[alert show];	
    //		[alert release];
    //		NSLog(@"첨부파일 보기는 현재 허용되지 않습니다");
    //	}
	if (navigationType==UIWebViewNavigationTypeLinkClicked) {
		if ([[request.URL scheme] isEqualToString:@"mailto"]) {
            NSLog(@"%@", request.URL);
            NSString * tempURL = [NSString stringWithFormat:@"%@", request.URL];
            tempURL = [tempURL stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
            NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:tempURL,@"name",tempURL,@"email",nil];
            
            NSMutableArray *mailFromDics = nil;//보낸사람 to로 보내려고 dic으로 묶음
            mailFromDics = [[NSMutableArray alloc] initWithCapacity:0];
            [mailFromDics addObject:valueDic];
            
            [valueDic release];
            
            contactModel.contactOptionDic = nil; //초기화
            contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
            [contactModel.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
            [contactModel.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
            
            [contactModel.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
            [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")]forKey:@"items"];
            
            MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
            mailWriteController.titleNavigationBar.text = NSLocalizedString(@"mail_new_message",@"새로운 메시지");
            
            
            //		mailWriteController.torecipientsFiled.text = [NSString stringWithFormat:@"%@", [self.contentDictionary objectForKey:@"mail_fromaddress"]];
            [self.navigationController pushViewController:mailWriteController transition:8];
            
            [mailWriteController release];
            
            
            
            //			[[UIApplication sharedApplication] openURL:request.URL];
            
			return NO;
		} else if ([[request.URL scheme] isEqualToString:@"tel"]) {
			[[UIApplication sharedApplication] openURL:request.URL];
			return NO;
		} else if ([[request.URL scheme] isEqualToString:@"http"] || [[request.URL scheme] isEqualToString:@"https"]) {
			[[UIApplication sharedApplication] openURL:request.URL];
			return NO;
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"app에서는 지원하지 않습니다. PC에서 이용해 주세요."
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			return NO;
		}
	}
	return YES;
}
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
	
    //	NSLog(@"javascript alert : %@",message);
	
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles:nil];
	
    [customAlert show];
	
    [customAlert autorelease];
	
}

#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	if(mode_unRead == NO){
		self.contentTableView.hidden = YES;
		self.contentTableView.userInteractionEnabled = NO;
	}
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
    [self.indicator stopAnimating];
	
    // get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
    ////NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
    // get value dictionary form result dictionary
    // -- set label if success -- //
    //	if (resultNum == 0 && rslt != nil) {
	if (resultNum == 0 ) {
        if (isInLineMode == YES) {//로컬에 저장 후 웹페이지에 표시
            
            
            NSDictionary *streams2 = (NSDictionary *)[_resultDic valueForKey:@"attachmentinfo"];
            if (streams2) {
                //--- file write
                NSString *str_fileName = [streams2 objectForKey:@"attachment_name"];
                
                NSString *base64EncodedString = [streams2 objectForKey:@"attachment_content"];
                NSData	*b64DecData = [Base64 decode:base64EncodedString];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);			
                NSString *documentsDirectory = [paths objectAtIndex:0];			
                NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:str_fileName];
                BOOL rslt = [b64DecData writeToFile:pdfPath atomically:YES];
                
                
                
                //--- file read & display
                NSArray *searchPaths = 
                NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                    NSUserDomainMask, YES); 
                NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
                
                NSString *savedPdfPath = [documentsDirectoryPath stringByAppendingPathComponent:str_fileName];
                //                savedPdfPath = [savedPdfPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
                savedPdfPath = [savedPdfPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                //                NSString *savedPath = [savedPdfPath
                //                                       stringByReplacingOccurrencesOfString:@"localhost/" withString:@""];
                
                //                NSURL *url = [[NSURL alloc] initFileURLWithPath:savedPath];
                ////			NSURL *url = [[NSBundle mainBundle] URLForResource:str_fileName withExtension:nil];
                ////			NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.pdf" withExtension:nil];
                //                NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                //                mWebView.scalesPageToFit = YES;
                //                [mWebView loadRequest:requestObj];
                
                //                self.isInLineMailBody = [self.isInLineMailBody stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"cid:%@",[streams2 objectForKey:@"attachment_contentid"] ] withString:[NSString stringWithFormat:@"file:/%@",savedPdfPath]];
                
                
                //                NSLog(@"111111111[%@]", isInLineMailBody);
                NSRange baseIndex = [self.isInLineMailBody rangeOfString:@"<base href="];
                if (baseIndex.length < 8) {
                }else{
                    self.isInLineMailBody = [self.isInLineMailBody stringByReplacingCharactersInRange:NSMakeRange(baseIndex.location, 25) withString:@""];                
                }
                
                
                //                NSLog(@"222222222[%@]", isInLineMailBody);
                
                self.isInLineMailBody = [self.isInLineMailBody stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"cid:%@",[streams2 objectForKey:@"attachment_contentid"] ] withString:str_fileName];
                
                //                NSLog(@"[%@]", isInLineMailBody);
                isInLineCountIndex++;
                
                if (isInLineIndex == isInLineCountIndex && isInLineIndex > 0) {
                    UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
//                    tempView.scalesPageToFit = YES;				
//                    
//                    
//                    // reset webview's height
//                    CGRect currentFrame = tempView.frame;
//                    //CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width+500, 354);
//                    CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, 600);
//                    //				[tempView setAutoresizingMask :( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight )];
//                    
//                    tempView.frame = newFrame;
//                    
//                    if (tempView.subviews.count > 0) {
//                        UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
//                        //scrollerView.contentSize = CGSizeMake(320, 354);
//                        [scrollerView setAutoresizingMask :( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight )];
//                        //CGSize scrollFrame = scrollerView.contentSize;
//                    }
//                    
//                    //                    documentsDirectoryPath = [documentsDirectoryPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//                    //                    documentsDirectoryPath = [documentsDirectoryPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectoryPath];
                    //                    NSLog(@"%@", documentsDirectoryPath);
                    [tempView loadHTMLString:isInLineMailBody baseURL:baseURL];//웹뷰에 뿌려줌
                    //                    [tempView loadHTMLString:isInLineMailBody baseURL:[NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//",documentsDirectoryPath]]];//웹뷰에 뿌려줌
                    
                    tempView.delegate = self;
                    self.clipboard = nil;
                    isInLineCountIndex = 0;
                    isInLineIndex = 0;
                    isInLineEnable = 0;
                    [self.contentTableView reloadData];
                    
                    isInLineMode = NO;
                }
                
            }
            
            
            
            
            
            
            
            
            
            
        }else{
            if (mode_unRead == YES) {//읽지않음으로 표시
                
                NSMutableDictionary *mail_IsReadDictionary= [[[NSMutableDictionary alloc]init]autorelease];
                mail_IsReadDictionary = [self.currentTableList objectAtIndex:currentRow];
                [mail_IsReadDictionary setObject:[NSString stringWithFormat:@"0"] forKey:@"mail_isread"];
				//			[self loadDetailContentTableList:currentTableList forIndexPath:currentRow];
                mode_unRead = NO;
//                [self.indicator stopAnimating];
                
            }else {
                
                self.contentDictionary = nil;
                self.contentDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_resultDic objectForKey:@"emailinfo"]];
                
                
                
                
                if(mode_trash == YES){//삭제했을 경우
                    
                    [currentTableList removeObjectAtIndex:currentRow];
                    
                    if (currentRow == [currentTableList count]) {
                        currentRow--;
                    }
                    [self loadDetailContentTableList:currentTableList forIndexPath:currentRow folderID:self.folderID];
//                    [self.mailListController.currentTableView reloadData ];
//                    [self.mailListController tableUpdate];
                    [noti postNotificationName:@"tableUpdate" object:self];

                    mode_trash = NO;
                    if ([currentTableList count]==0) {
                        [self.contentTableView reloadData];
//                        [self.indicator stopAnimating];
                    }
                }else {
					//				UILabel *mailFromID = (UILabel *)[titleCell viewWithTag:111];//보낸사람 1번셀
					//				mailFromID.text = [self.contentDictionary objectForKey:@"mail_fromname"];
					//				
					//				UILabel *mail_addressto = (UILabel *)[toNameCell viewWithTag:112];//받는사람 2번셀
					//				mail_addressto.text = [self.contentDictionary objectForKey:@"mail_addressto"];
					//				UILabel *mailSubject = (UILabel *)[nameCell viewWithTag:222];//메일제목 3번셀
					//				mailSubject.text = [self.contentDictionary objectForKey:@"mail_subject"];
					//				
					//				UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];//받은시간 3번셀
					//				tempDate.text = [self.contentDictionary objectForKey:@"mail_receivedtime"];
                    
                    UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
//                    tempView.scalesPageToFit = YES;				
//                    
//                    
//					// reset webview's height
//                    CGRect currentFrame = tempView.frame;
//					//CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width+500, 354);
//                    CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, 600);
//                    //				[tempView setAutoresizingMask :( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight )];
//                    
//                    tempView.frame = newFrame;
//                    
//                    if (tempView.subviews.count > 0) {
//                        UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
//						//scrollerView.contentSize = CGSizeMake(320, 354);
//                        [scrollerView setAutoresizingMask :( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight )];
//						//CGSize scrollFrame = scrollerView.contentSize;
//                    }
                    if ([self.contentDictionary objectForKey:@"attachmentItems"] != nil) {
                        [self.attachmentArray removeAllObjects];
                        [self.attachmentFileArray removeAllObjects];
                        self.attachmentArray = [self.contentDictionary objectForKey:@"attachmentItems"];
                        int i = 0;
                        NSMutableDictionary *mail_IsReadDictionary= [[[NSMutableDictionary alloc]init]autorelease];
                        mail_IsReadDictionary = [self.currentTableList objectAtIndex:currentRow];
                        [mail_IsReadDictionary setObject:[NSString stringWithFormat:@"1"] forKey:@"mail_isread"];
                        
                        for (NSMutableDictionary *tempDic in attachmentArray) {
                            
                            if ([[tempDic objectForKey:@"attachment_isinline"]isEqualToString:@"0"]) {
                                [tempDic setObject:[NSString stringWithFormat:@"%d", i] forKey:@"fileIndex"];
                                [attachmentFileArray addObject:tempDic];
                            }
                            i++;
                            
                        }
                        NSLog(@"asdfasdfasdf[%@]", attachmentFileArray);
                        
                    }
                    //                    if ([[self.contentDictionary objectForKey:@"mail_hasattachment"]isEqualToString:@"1"]) {
                    //						//첨부파일 명 표시 하기 위해
                    //                        
                    //                        [self.attachmentArray removeAllObjects];
                    //                        self.attachmentArray = [self.contentDictionary objectForKey:@"attachmentItems"];
                    //                        //                    NSLog(@"%@",self.contentDictionary);
                    //                        //                    NSLog(@"%@",self.attachmentArray);
                    //                        
                    //                    }
                    //                [tempView loadHTMLString:[self.contentDictionary objectForKey:@"mail_body"] baseURL:nil];//웹뷰에 뿌려줌
                    //                    NSLog(@"[%@]", [self.contentDictionary objectForKey:@"mail_body"]);
                    
                    NSMutableString *attachmentString = [[NSMutableString alloc]init];
                    //              [attachmentString appendFormat:@"document.body.style.zoom = 3.5"];
                    
                    [attachmentString appendFormat:@"\n%@", [self.contentDictionary objectForKey:@"mail_body"]];
                    //                NSLog(@"%@", [self.contentDictionary objectForKey:@"mail_body"]);
                    [attachmentString appendFormat:@"<br>"];
                    [attachmentString appendFormat:@"<meta name='viewport' content='user-scalable=yes, initial-scale=0.8'/>"];
                    self.realMailBody = @"";
                    self.isInLineMailBody = @"";
                    self.isInLineMailBody = attachmentString;
                    self.realMailBody = [self.contentDictionary objectForKey:@"mail_body"];
                    [self.contentString setString:[self.contentDictionary objectForKey:@"mail_body"]];

                    [tempView loadHTMLString:attachmentString baseURL:nil];//웹뷰에 뿌려줌
                    //                    NSLog(@"%@",attachmentString);
                    attachmentString = nil;
                    [attachmentString release];
                    
                    tempView.delegate = self;
                    self.clipboard = nil;
                    
                    
                    
                    //테이블 뷰에 inline 버튼 만들어 주기 위해서 
                    int i = 0;
                    for (NSDictionary *dic in attachmentArray) {
                        if ([[dic objectForKey:@"attachment_isinline"]isEqualToString:@"1"]) {
                            i++;
                        }
                    }
                    isInLineEnable = 0;
                    if (i > 0) {
                        isInLineEnable = 1;
                    }
                    
                    
                    
                    
                    
                    [self.contentTableView reloadData];
                    //                BOOL animationsEnabled = [UIView areAnimationsEnabled];
                    //                [UIView setAnimationsEnabled:NO];
                    //                [self.contentTableView beginUpdates];
                    //                [self.contentTableView endUpdates];
                    //                [UIView setAnimationsEnabled:animationsEnabled];
                    
                    //                for (UIScrollView *scroll in [tempView subviews]) { //we get the scrollview 
                    //                    // Make sure it really is a scroll view and reset the zoom scale.
                    //                    scroll.minimumZoomScale = 5;
                    //                }
                    
                }
                
            }
            
        }
        
        
		
		
		
	} else {
        // -- error handling -- //
        // Show alert view to user
		[self.indicator stopAnimating];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	self.contentTableView.hidden = NO;
	self.contentTableView.userInteractionEnabled = YES;
    
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator stopAnimating];
	self.contentTableView.userInteractionEnabled = YES;
    // Alert network error message
    //NSLog(@"%@", error);
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
    //												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
    //	[alert show];	
    //	[alert release];
    //    return;
}


#pragma mark -
#pragma mark event
-(void)didMoveToWindow{
    NSLog(@"$#");
}
-(void)segmentProcess{
    if ([currentTableList count] == 1) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
    } else if (currentRow == 0 || currentRow == -1) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
    } else if (currentRow+1 == [currentTableList count]) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
    } else {
        [segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
        
    }
    if ([currentTableList count] == 2 && currentRow == 0 ) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
        
    }if ([currentTableList count] == 2 && currentRow == 1 ) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
        [segmentedControl setEnabled:YES forSegmentAtIndex:0];
        
    }
    if ([self.currentTableList count]<1) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
        
    }

}
-(void) loadDetailContentTableList:(NSMutableArray *)tableList forIndexPath:(int)indexPathRow folderID:(NSString *)forderIdString{
	currentRowShowMode = YES;
    [self.attachmentArray removeAllObjects];
    [self.attachmentFileArray removeAllObjects];
    markUnRead.alpha = 1;
	markUnRead.enabled = YES;
	markUnReadImage.alpha = 1;
	self.folderID = forderIdString;
    // get clipboard module
    //Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	self.webviewLoadFlag = 0;
    //add tableList and indexpath
	currentTableList = tableList;
	currentRow = indexPathRow;

    if (self.popoverController != nil ) {
//        if ([currentTableList count] == 1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else if (currentRow == 0 || currentRow == -1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//        } else if (currentRow+1 == [currentTableList count]) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else {
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }
//        if ([currentTableList count] == 2 && currentRow == 0 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }if ([currentTableList count] == 2 && currentRow == 1 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            
//        }
        [self segmentProcess];
    }
	
	if ([currentTableList count] != 0) {
        // make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        //[requestDictionary setObject:@"KT" forKey:@"userid"];
		[requestDictionary setObject:[NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]] forKey:@"mail_id"];
		
        // call communicate method
		BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getEmailInfo];
        //	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getEmailSpecificInfo];
		
		
		if (!result) {
            // error occurred
			
		}
		
	}

//	self.title = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        toolbarLabel.hidden = NO;
    }else{
        toolbarLabel.hidden = YES;
    }
    toolbarLabel.text = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];

}
-(void)loadDetailTableList:(NSMutableArray *)tableList{
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        toolbarLabel.hidden = NO;
    }else{
        toolbarLabel.hidden = YES;
    }
    
    if (currentRowShowMode == NO) {
        currentRow = -1;

    }
    currentTableList = tableList;
    toolbarLabel.text = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];
    if (self.popoverController != nil ) {
//        if ([currentTableList count] == 1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else if (currentRow == 0 || currentRow == -1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//        } else if (currentRow+1 == [currentTableList count]) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else {
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }
//        if ([currentTableList count] == 2 && currentRow == 0 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }if ([currentTableList count] == 2 && currentRow == 1 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            
//        }
        [self segmentProcess];
    }

}
-(IBAction) writeButtonClicked {
    if (self.popoverController != nil && [self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}

    [noti postNotificationName:@"overlayView" object:self];
//	[noti addObserver:self selector:@selector(returnListMailMove) name:@"returnListMailMove" object:nil];
//	[noti addObserver:self selector:@selector(overlayView) name:@"overlayView" object:nil];
//    [noti addObserver:self selector:@selector(doneSearching_Clicked:) name:@"doneSearching_Clicked" object:nil];

//    MailListController *mailListController = [self.splitViewController.viewControllers objectAtIndex:0];
//    [mailListController overlayView ];
//    [[[[[self.splitViewController.viewControllers objectAtIndex:0] navigationController ]viewControllers ]objectAtIndex:0]overlayView];
	MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];
	mailWriteController.titleNavigationBar.text = NSLocalizedString(@"mail_new_message",@"새로운 메시지");
    //[detailContentController loadDetailContentAtIndex:[indexPath row]];
    // Pass the selected object to the new view controller.
    //	[self.navigationController pushViewController:testwrite animated:YES];
	[self.navigationController pushViewController:mailWriteController transition:8];
	
	[mailWriteController release];
	
}
-(IBAction)showActionSheet:(id)sender{
    if (self.popoverController != nil && [self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}

    if ([self.currentTableList count] > 0) {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"btn_cancel", @"취소") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"mail_reply", @"답장"), NSLocalizedString(@"mail_replyAll", @"모두답장"), NSLocalizedString(@"mail_forward", @"전달"), nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        popupQuery.tag = 10;
        [popupQuery showInView:self.view];
        [popupQuery release];

    }
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	MailWriteController *mailWriteController = [[MailWriteController alloc] initWithNibName:@"MailWriteController" bundle:nil];

    NSLog(@"%d", buttonIndex);
	if (actionSheet.tag == 10 || actionSheet.tag == 20) {
        [noti postNotificationName:@"overlayView" object:self];
        if (actionSheet.tag == 10) {
            if (buttonIndex == 3) {
                [noti postNotificationName:@"overlayViewCancel" object:self];
            }
        }
        if (actionSheet.tag == 20) {
            if (buttonIndex == 2) {
                [noti postNotificationName:@"overlayViewCancel" object:self];

            }

        }
    }
    switch (actionSheet.tag) {
        case 10:
            if (buttonIndex == 0 || buttonIndex == 1) {//답장, 모두답장
                // ...
                // Pass the selected object to the new view controller.
                
                
                
                if ([[self.contentDictionary objectForKey:@"mail_fromaddress"]isEqualToString:@"" ]||[self.contentDictionary objectForKey:@"mail_fromaddress"] == nil ) {
                }else {
                    //                    NSLog(@"mail_fromaddress[%@]",[self.contentDictionary objectForKey:@"mail_fromaddress"]);
                    
                }
                
                if ([[self.contentDictionary objectForKey:@"mail_fromname"]isEqualToString:@""]||[self.contentDictionary objectForKey:@"mail_fromname"] == nil) {
                }else {
                    //                    NSLog(@"mail_fromname[%@]",[self.contentDictionary objectForKey:@"mail_fromname"]);
                    
                }
                
                if ([[self.contentDictionary objectForKey:@"mail_addresscc"]isEqualToString:@""] ||[self.contentDictionary objectForKey:@"mail_addresscc"] == nil) {
                }else {
                    //                    NSLog(@"mail_addresscc[%@]",[self.contentDictionary objectForKey:@"mail_addresscc"]);
                    
                }
                
                if ([[self.contentDictionary objectForKey:@"mail_displaycc"]isEqualToString:@""] ||[self.contentDictionary objectForKey:@"mail_displaycc"] == nil) {
                }else{
                    //                    NSLog(@"mail_displaycc[%@]",[self.contentDictionary objectForKey:@"mail_displaycc"]);
                    
                }
                if ([[self.contentDictionary objectForKey:@"mail_addressto"]isEqualToString:@""]||[self.contentDictionary objectForKey:@"mail_addressto"] == nil) {
                }else {
                    //                    NSLog(@"mail_addressto[%@]",[self.contentDictionary objectForKey:@"mail_addressto"]);
                    
                }
                
                if ([[self.contentDictionary objectForKey:@"mail_displayto"]isEqualToString:@""]||[self.contentDictionary objectForKey:@"mail_addressto"] == nil) {
                }else {
                    //                    NSLog(@"mail_displayto[%@]",[self.contentDictionary objectForKey:@"mail_displayto"]);
                    
                }
                
                
                
                NSArray *mailFromAddressArray = [[self.contentDictionary notNilObjectForKey:@"mail_fromaddress"] componentsSeparatedByString: @"; "];
                int indexFromAddress = [mailFromAddressArray indexOfObject:@""];
                if (indexFromAddress >= 0 && indexFromAddress < 5000) {//object가 없으면 지워줌 ,nil일때는 int값이 20만 숫자떠서 (주소값)조건 막아줌
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:mailFromAddressArray];
                    [newArray removeObjectAtIndex:indexFromAddress];
                    mailFromAddressArray = [newArray copy];
                    //	[newArray release];
                }
                //                for (NSString* item in mailFromAddressArray) {
                //                    NSLog(@"mailFromAddressArray[%@]",item);
                //                }			
                //	NSString *maildisplaytoString = [self.contentDictionary notNilObjectForKey:@"mail_displayto"];
                NSArray *mailFromNameArray = [[self.contentDictionary notNilObjectForKey:@"mail_fromname"] componentsSeparatedByString: @"; "];
                int indexFromDisplay = [mailFromNameArray indexOfObject:nil];
                if (indexFromDisplay >= 0 && indexFromDisplay < 5000) {
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:mailFromNameArray];
                    [newArray removeObjectAtIndex:indexFromDisplay];
                    mailFromNameArray = [newArray copy];
                    //		[newArray release];
                    
                }
                
                //                for (NSString* item in mailFromNameArray) {
                //                    NSLog(@"mailFromNameArray[%@]",item);
                //                }			
                
                
                
                NSArray *mailCCAddressArray = [[self.contentDictionary notNilObjectForKey:@"mail_addresscc"] componentsSeparatedByString: @"; "];
                int indexCCAddress = [mailCCAddressArray indexOfObject:@""];
                if (indexCCAddress >= 0 && indexCCAddress < 5000) {//object가 없으면 지워줌 ,nil일때는 int값이 20만 숫자떠서 (주소값)조건 막아줌
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:mailCCAddressArray];
                    [newArray removeObjectAtIndex:indexCCAddress];
                    mailCCAddressArray = [newArray copy];
                    //	[newArray release];
                }
                //                for (NSString* item in mailCCAddressArray) {
                //                    NSLog(@"mailCCAddressArray[%@]",item);
                //                }			
                //	NSString *maildisplaytoString = [self.contentDictionary notNilObjectForKey:@"mail_displayto"];
                NSArray *mailCCNameArray = [[self.contentDictionary notNilObjectForKey:@"mail_displaycc"] componentsSeparatedByString: @"; "];
                int indexCCDisplay = [mailCCNameArray indexOfObject:nil];
                if (indexCCDisplay >= 0 && indexCCDisplay < 5000) {
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:mailCCNameArray];
                    [newArray removeObjectAtIndex:indexCCDisplay];
                    mailCCNameArray = [newArray copy];
                    //		[newArray release];
                    
                }
                
                //                for (NSString* item in mailCCNameArray) {
                //                    NSLog(@"mailCCNameArray[%@]",item);
                //                }			
                
                
                
                
                
                
                
                // token에 넣어주기 위해서 array와 dictionary로 쌈
                //	NSString *mailaddresstoString = [self.contentDictionary notNilObjectForKey:@"mail_addressto"];
                NSArray *mailaddresstoArray = [[self.contentDictionary notNilObjectForKey:@"mail_addressto"] componentsSeparatedByString: @"; "];
                int indexAddress = [mailaddresstoArray indexOfObject:@""];
                if (indexAddress >= 0 && indexAddress < 5000) {//object가 없으면 20만 숫자떠서 막아줌
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:mailaddresstoArray];
                    [newArray removeObjectAtIndex:indexAddress];
                    mailaddresstoArray = [newArray copy];
                    //	[newArray release];
                }
                //                for (NSString* item in mailaddresstoArray) {
                //                    NSLog(@"mailaddresstoArray[%@]",item);
                //                }			
                //	NSString *maildisplaytoString = [self.contentDictionary notNilObjectForKey:@"mail_displayto"];
                NSArray *maildisplaytoArray = [[self.contentDictionary notNilObjectForKey:@"mail_displayto"] componentsSeparatedByString: @"; "];
                int indexDisplay = [maildisplaytoArray indexOfObject:nil];
                if (indexDisplay >= 0 && indexDisplay < 5000) {
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:maildisplaytoArray];
                    [newArray removeObjectAtIndex:indexDisplay];
                    maildisplaytoArray = [newArray copy];
                    //		[newArray release];
                    
                }
                
                //                for (NSString* item in maildisplaytoArray) {
                //                    NSLog(@"maildisplaytoArray[%@]",item);
                //                }			
                
                NSString *name = @"";
                NSString *email = @"";
                
                
                
                
                
                
                
                
                NSMutableArray *mailFromDics = nil;//보낸사람 to로 보내려고 dic으로 묶음
                mailFromDics = [[NSMutableArray alloc] initWithCapacity:0];
                int i;
                //                NSLog(@"mailAddressToArray[%@][%@]",mailFromAddressArray, mailFromNameArray );
                
                for (i=0; i < [mailFromAddressArray count]; i++) {//dic으로 만듬
                    if ([[mailFromAddressArray objectAtIndex:i]isEqualToString:@""] || [mailFromAddressArray objectAtIndex:i] == nil || [[mailFromAddressArray objectAtIndex:i]isEqualToString:@""""] ) {
                    }else {
                        email = [mailFromAddressArray objectAtIndex:i];
                    }
                    if ([[mailFromNameArray objectAtIndex:i]isEqualToString:@""] || [mailFromNameArray objectAtIndex:i] == nil || [[mailFromNameArray objectAtIndex:i]isEqualToString:@""""]){
                    }else {
                        name = [mailFromNameArray objectAtIndex:i];
                    }
                    NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",email,@"email",nil];
                    
                    [mailFromDics addObject:valueDic];
                    [valueDic release];
                    
                }
                
                
                
                
                
                if (buttonIndex == 0 ) {//답장
                    
                    
                    
                    //		
                    //		
                    //			// 변한 데이터를 모델에 저장한다.
                    //		NSLog(@"토큰 저장된 값. [%@], 모델에 적용된값 [%@]",tokenFieldView.tokenField.tokensArray, [contactModel.contactOptionDic objectForKey:@"selectedMember"] );
                    //		
                    //		NSMutableArray *arrTemp = nil;
                    //		arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    //		
                    //		for (TIToken *tiToken in tokenFieldView.tokenField.tokensArray) {
                    //			
                    //			NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:tiToken.title,@"name",tiToken.email,@"email",nil];
                    //			
                    //			[arrTemp addObject:valueDic];
                    //			[valueDic release];
                    //		}
                    //			//결과가 완료되면 model.contactOptionDic 에 NSMutableArray 로 이름, 이메일 값을 Dictionary 로 값을 넣어주자
                    //		[contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    //		[contactModel.contactOptionDic removeObjectForKey:@"select"];
                    //		[contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"];
                    //		NSLog(@"mailAddressToDic[%@]",arrTemp);
                    //		[contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    //		[contactModel.contactOptionDic removeObjectForKey:@"select"];
                    contactModel.contactOptionDic = nil; //초기화
                    contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                    [contactModel.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
                    [contactModel.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
                    
                    [contactModel.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
                    [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")]forKey:@"items"];
                    //			[contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                    
                    //                    NSLog(@"maildetail action sheet [%@][%@]",[contactModel.contactOptionDic objectForKey:@"recipient"],[contactModel.contactOptionDic objectForKey:@"selectedMember"]);
                    
                    
                    //		
                    //		contactModel.contactOptionDic = nil; //초기화
                    //		contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                    //		[contactModel.contactOptionDic setObject:@"받는사람" forKey:@"title"];
                    //		[contactModel.contactOptionDic setObject:@"받는사람:" forKey:@"items"];
                    //		[contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                    //		[contactModel.contactOptionDic setObject:@"to" forKey:@"recipient"];
                    //		if (toRecipientList != nil) {
                    //			NSMutableArray *arrTemp = nil;
                    //			arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    //			for (NSDictionary *dic in toRecipientList ) {
                    //				[arrTemp addObject:dic];
                    //			}
                    //			[contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    //			[contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"]; 
                    //		} 
                    //		
                    
                    
                    
                    
                    
                    
                    NSString *tempTitle = [NSString stringWithFormat:@"Re: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                    mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", self.contentString];
                    if ([self.contentDictionary objectForKey:@"mail_subject"] == nil) {
                        tempTitle == @"Re:";
                    }
                    //		mailWriteController.torecipientsFiled.text = [NSString stringWithFormat:@"%@", [self.contentDictionary objectForKey:@"mail_fromaddress"]];
                    [self.navigationController pushViewController:mailWriteController transition:8];
                    mailWriteController.titleNavigationBar.text = tempTitle;
                    
                    
                    mailWriteController.subjectField.text = tempTitle;
                    
                    [mailWriteController release];
                    
                    
                    
                    
                    
                    
                    
                    
                } else if (buttonIndex == 1) {//모두답장
                    
                    
                    
                    
                    
                    NSMutableArray *allToAddressArray = [NSMutableArray arrayWithArray:mailaddresstoArray];
                    [allToAddressArray addObjectsFromArray:mailCCAddressArray];
                    NSMutableArray *allToNameArray = [NSMutableArray arrayWithArray:maildisplaytoArray];
                    [allToNameArray addObjectsFromArray:mailCCNameArray];
                    
                    //                    NSLog(@"allToAddressArray[%@][%@]",allToAddressArray, allToNameArray );
                    
                    
                    
                    
                    NSMutableArray *arrTemp = nil;
                    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    int i;
                    //                    NSLog(@"mailAddressToArray[%@][%@]",allToAddressArray, allToNameArray );
                    
                    for (i=0; i < [allToAddressArray count]; i++) {//dic으로 만듬
                        if ([[allToAddressArray objectAtIndex:i]isEqualToString:@""] || [allToAddressArray objectAtIndex:i] == nil || [[allToAddressArray objectAtIndex:i]isEqualToString:@""""] ) {
                        }else {
                            email = [allToAddressArray objectAtIndex:i];
                        }
                        if ([[allToNameArray objectAtIndex:i]isEqualToString:@""] || [allToNameArray objectAtIndex:i] == nil || [[allToNameArray objectAtIndex:i]isEqualToString:@""""]){
                        }else {
                            name = [allToNameArray objectAtIndex:i];
                        }
                        NSDictionary *valueDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",email,@"email",nil];
                        
                        [arrTemp addObject:valueDic];
                        [valueDic release];
                        
                    }
                    //                    NSLog(@"mailAddressToDic[%@]",arrTemp);
                    
                    //		[contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    //		[contactModel.contactOptionDic removeObjectForKey:@"select"];
                    contactModel.contactOptionDic = nil; //초기화
                    contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                    
                    [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"];
                    [contactModel.contactOptionDic setObject:@"cc" forKey:@"recipient"];
                    
                    [contactModel.contactOptionDic setObject:NSLocalizedString(@"mail_cc",@"참조") forKey:@"title"];
                    [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"mail_cc",@"참조")] forKey:@"items"];
                    //		[contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                    
                    
                    [contactModel.contactOptionDic setObject:mailFromDics forKey:@"toSelectedMember"];
                    [contactModel.contactOptionDic setObject:@"to" forKey:@"toRecipient"];
                    
                    [contactModel.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
                    [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")] forKey:@"items"];
                    //		[contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                    
                    
                    //                    NSLog(@"maildetail action sheet [%@][%@]",[contactModel.contactOptionDic objectForKey:@"recipient"],[contactModel.contactOptionDic objectForKey:@"selectedMember"]);
                    
                    //		mailWriteController.torecipientsFiled.text = [self.contentDictionary objectForKey:@"mail_fromaddress"];
                    
                    //		NSMutableString *allReplyString = [[NSMutableString alloc]init];
                    //		[allReplyString appendFormat:@"%@", [self.contentDictionary objectForKey:@"mail_addressto"]];
                    //		[allReplyString appendFormat:@"%@", [self.contentDictionary objectForKey:@"mail_addresscc"]];
                    //		mailWriteController.ccrecipientsFiled.text = allReplyString;
                    
                    
                    [self.navigationController pushViewController:mailWriteController transition:8];
                    
                    NSString *tempTitle = [NSString stringWithFormat:@"Re: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                    if ([self.contentDictionary objectForKey:@"mail_subject"] == nil) {
                        tempTitle == @"Re:";
                    }
                    
                    mailWriteController.titleNavigationBar.text = tempTitle;
                    mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", self.contentString];
                    mailWriteController.subjectField.text = tempTitle;
                    
                    
                    //		mailWriteController.titleNavigationBar.text = @"새로운 메시지";
                    //		mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", self.contentString];
                    //		mailWriteController.subjectField.text = [NSString stringWithFormat:@"Re: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                    //		mailWriteController.torecipientsFiled.text = [self.contentDictionary objectForKey:@"mail_fromaddress"];
                    //		
                    //		NSMutableString *allReplyString = [[NSMutableString alloc]init];
                    //		[allReplyString appendFormat:@"%@", [self.contentDictionary objectForKey:@"mail_addressto"]];
                    //		[allReplyString appendFormat:@"%@", [self.contentDictionary objectForKey:@"mail_addresscc"]];
                    //		mailWriteController.ccrecipientsFiled.text = allReplyString;
                    //		
                    //		
                    //		[self.navigationController pushViewController:mailWriteController transition:8];
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            } else if (buttonIndex == 2) {//전달
                if ([[self.contentDictionary objectForKey:@"mail_hasattachment"]isEqualToString:@"1"]) {//첨부 있을경우 첨부파일 첨부 여부 확인
                    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"fwd_mail_message", @"첨부파일 첨부 여부확인") delegate:self cancelButtonTitle:NSLocalizedString(@"btn_cancel", @"취소") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"fwd_mail_include", @"포함"), NSLocalizedString(@"fwd_mail_dont_include", @"포함 안 함"), nil];
                    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    popupQuery.tag = 20;
                    [popupQuery showInView:self.view];
                    [popupQuery release];
                    
                }else{
                    [self.navigationController pushViewController:mailWriteController transition:8];
                    NSString *tempTitle = [NSString stringWithFormat:@"FW: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                    if ([self.contentDictionary objectForKey:@"mail_subject"] == nil) {
                        tempTitle == @"FW:";
                    }
                    
                    mailWriteController.titleNavigationBar.text = tempTitle;
                    mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", self.contentString];
                    mailWriteController.subjectField.text = tempTitle;
                    mailWriteController.attachment = NO;
                    mailWriteController.mailID = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
                    
                    [mailWriteController release];
                    
                }
                
                
                
                
                
                
                
            } 
            
            break;
        case 20:
            
            if (buttonIndex == 1) {//첨부 포함하지 않음
                NSMutableString *attachmentString = [[[NSMutableString alloc]init]autorelease];
                NSDictionary *attachmentDictionary = [[[NSMutableDictionary alloc]init]autorelease];
                
                [attachmentString appendFormat:@"\n%@", self.contentString];
                
                [attachmentString appendFormat:@"<br>"];
                //                    [attachmentString appendFormat:@"<meta name='viewport' content='user-scalable=yes, initial-scale=1.0, minimum-scale=1.0, width = device-width'/>"];
                
                [attachmentString appendFormat:@"<table width=300 border=1><tr><td width=100 align=center>첨부파일</td></tr></table>"];
                [attachmentString appendFormat:@"<table width=300 border=1><tr><td width=100> "];
                int i;
                for (i = 0; i < self.attachmentArray.count; i++) {
                    attachmentDictionary = [self.attachmentArray objectAtIndex:i];
                    [attachmentString appendFormat:@"<form><input type=button onclick='javascript:location.href=\"toAPP://\";' value=%@ ></form>", [attachmentDictionary objectForKey:@"attachment_name"]];
                    
                }
                [attachmentString appendFormat:@"</td></tr></table>"];
                
                [self.navigationController pushViewController:mailWriteController transition:8];
                NSString *tempTitle = [NSString stringWithFormat:@"FW: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                if ([self.contentDictionary objectForKey:@"mail_subject"] == nil) {
                    tempTitle == @"FW:";
                }
                
                mailWriteController.titleNavigationBar.text = tempTitle;
                mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", attachmentString];
                mailWriteController.subjectField.text = tempTitle;
                [mailWriteController release];
                
                
                
            }else if(buttonIndex == 0){//첨부 포함
                [self.navigationController pushViewController:mailWriteController transition:8];
                NSString *tempTitle = [NSString stringWithFormat:@"FW: %@", [self.contentDictionary objectForKey:@"mail_subject"]];
                if ([self.contentDictionary objectForKey:@"mail_subject"] == nil) {
                    tempTitle == @"FW:";
                }
                
                mailWriteController.titleNavigationBar.text = tempTitle;
                mailWriteController.contentIndex = [NSString stringWithFormat:@"<br><br><br>%@", self.contentString];
                mailWriteController.subjectField.text = tempTitle;
                mailWriteController.attachment = NO;
                mailWriteController.mailID = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
                [mailWriteController mailForwardfileArray:self.attachmentFileArray];

                [mailWriteController release];
                
            }
            
            break;
        default:
            break;
    }
    
//	[noti postNotificationName:@"contentTextView" object:self];

}
//- (void) segmentAction:(id)sender{
//	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//	self.title = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
//
//	NSLog([NSString stringWithFormat:@"<br><br><br>%d",[segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]]);
//}
- (void)segmentAction:(UISegmentedControl*)sender
{
    currentRowShowMode = YES;
    //	if ([activeTextField canResignFirstResponder])
    //		[activeTextField resignFirstResponder];
    [self.attachmentArray removeAllObjects];
	markUnRead.alpha = 1;
	markUnRead.enabled = YES;
	markUnReadImage.alpha = 1;
	
    //	NSLog(@"segmentAction: sender = %d, segment = %d",  [sender tag], [sender selectedSegmentIndex]);
	if ([sender selectedSegmentIndex]==0) {
        //up 
		currentRow--;
	}else {
        //down
		currentRow++;
	}
//	self.title = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];
//    mailToolbar. = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];
    toolbarLabel.text = [NSString stringWithFormat:@"%d/%d", currentRow+1, [currentTableList count]];
	if (currentRow <1) {
		[sender setEnabled:NO forSegmentAtIndex:0];
		
	}
	
//	if ([currentTableList count] == 1) {
//        [sender setEnabled:NO forSegmentAtIndex:0];
//        [sender setEnabled:NO forSegmentAtIndex:1];
//	} else if (currentRow == 0 || currentRow == -1) {
//        [sender setEnabled:NO forSegmentAtIndex:0];
//	} else if (currentRow+1 == [currentTableList count]) {
//        [sender setEnabled:NO forSegmentAtIndex:1];
//	}
//	
//	else {
//		[sender setEnabled:YES forSegmentAtIndex:0];
//        [sender setEnabled:YES forSegmentAtIndex:1];
//		
//	}
//	if ([currentTableList count] == 2 && currentRow == 0 ) {
//		[segmentedControl setEnabled:NO forSegmentAtIndex:0];
//		[segmentedControl setEnabled:YES forSegmentAtIndex:1];
//		
//	}if ([currentTableList count] == 2 && currentRow == 1 ) {
//		[segmentedControl setEnabled:NO forSegmentAtIndex:1];
//		[segmentedControl setEnabled:YES forSegmentAtIndex:0];
//		
//	}
	[self segmentProcess];
    
    
    // get clipboard module
    //Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	self.webviewLoadFlag = 0;
    //add tableList and indexpath
	
    // make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    //[requestDictionary setObject:@"KT" forKey:@"userid"];
	[requestDictionary setObject:[NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]] forKey:@"mail_id"];
	
    // call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getEmailInfo];
    //	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:URL_getEmailSpecificInfo];
	
    //리스트에서 메일 읽음으로 표시
	NSMutableDictionary *mail_IsReadDictionary= [[[NSMutableDictionary alloc]init]autorelease];
	mail_IsReadDictionary = [self.currentTableList objectAtIndex:currentRow];
	[mail_IsReadDictionary setObject:[NSString stringWithFormat:@"1"] forKey:@"mail_isread"];
	
	if (!result) {
        // error occurred
		
	}
	
	
}
-(IBAction) trashButtonClicked{
    if (self.popoverController != nil && [self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	if (self.currentTableList != nil) {
        if ( currentRow >= 0) {
            clipboard = [[Communication alloc] init];
            [clipboard setDelegate:self];
            
            NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
            mode_trash = YES;
            NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
            [requestDictionary setObject:addMailIdString forKey:@"mail_id"];
            if([self.folderID isEqualToString:@"4"]){
                [requestDictionary setObject:@"h" forKey:@"delete_type"];
                
            }
            [addMailIdString release];
            
            int rslt = [clipboard callWithArray:requestDictionary serviceUrl:URL_deleteEmailInfo];
            if (rslt != YES) {
                //--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"ok"), nil];
                [alert show];
                [alert release];
            }else {
            }
            
        }
        
    }

    //NSArray* selectedRows = [currentTableView.mu indexPathsForSelectedRows];
    //[self.loadDetailContentAtIndex:[NSString stringWithFormat:@"%@", self.folderID]];
    //[mailListController loadDetailContentAtIndex:[NSString stringWithFormat:@"%@", [[self.menuList objectAtIndex:indexPath.row] objectForKey:@"folder_id"]]];
	
}
-(IBAction) markUnReadClcked{
	mode_unRead = YES;
	clipboard = [[Communication alloc] init];
	[clipboard setDelegate:self];
	NSString *addMailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
	
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[requestDictionary setObject:addMailIdString forKey:@"mail_id"];
	[requestDictionary setObject:@"0" forKey:@"mail_isread"];
	
	[addMailIdString release];
	
	int rslt = [clipboard callWithArray:requestDictionary serviceUrl:URL_updateUnreadEmailInfo];
	if (rslt != YES) {
        //--- 에러 처리. 공통 모듈 구현에 따름으로 지금은 보류 ---//
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"ok"), nil];
		[alert show];
		[alert release];
	}else {
	}
	
	
	markUnRead.alpha = 0.4;
	markUnRead.enabled = NO;
	markUnReadImage.alpha = 0.4;
	
}
#pragma mark -
#pragma mark inLine Process
-(void)action_isInlineImageView:(id)sender {
    isInLineMode = YES;
    //    NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.co.kr/logos/2011/Googles_13th_Birthday-2011-hp.jpg"];
    //
    //    [self downloadRequest:url];
    NSString *mailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
    
    NSLog(@"%@", attachmentArray);
    int i = 0;
    int j = 0;
    for (NSDictionary *dic in attachmentArray) {
        
        if ([[dic objectForKey:@"attachment_isinline"]isEqualToString:@"1"]) {
            
            clipboard = [[Communication alloc] init];
            [clipboard setDelegate:self];
            
            NSMutableDictionary *commRequest = [[NSMutableDictionary alloc] init];
            
            [commRequest setObject:mailIdString forKey:@"mail_id"];
            [commRequest setObject:[NSString stringWithFormat:@"%d", i] forKey:@"attachment_index"];
            int rslt = [clipboard callWithArray:commRequest serviceUrl:getEmailAttachmentInfo];
            if(rslt != YES) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            j++;
        }
        i++;
    }
    isInLineIndex = j;
    isInLineCountIndex = 0;
    
    
}




-(void) loadAttachmentMailID:(NSString *)mailID attachmentIndex:(NSString *)index{
    
    if (isInLineMode > 0) {
        clipboard = [[Communication alloc] init];
        [clipboard setDelegate:self];
        
        
        NSMutableDictionary *commRequest = [[NSMutableDictionary alloc] init];
        
        [commRequest setObject:mailID forKey:@"mail_id"];
        [commRequest setObject:index forKey:@"attachment_index"];
        
        //	if(self.dic_docattachlistinfo == nil || [self.dic_docattachlistinfo count] <= 0) {
        //		//--- 첨부파일 정보가 없으면 원문보기
        //		//--- 박병주 대리 테스트 pdf
        //		//	NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\PdfFile\\metest0315.xlsx";
        //		//	[loginRequest  setObject:tmpPath forKey:@"filepath"];
        //		[commRequest  setObject:[self.dic_approvaldocinfo objectForKey:@"href"] forKey:@"filepath"];		
        //		[commRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
        //		
        //	}
        //	else {
        //        //		NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\AttachFile\\test343453534545★.docx";
        //        //		[loginRequest  setObject:tmpPath forKey:@"filepath"];
        //		[commRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"href"] forKey:@"filepath"];		
        //		[commRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"docid"] forKey:@"docid"]; 
        //		
        //	}
        
        int rslt = [commRequest callWithArray:commRequest serviceUrl:getEmailAttachmentInfo];
        if(rslt != YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            
            [alert show];
            [alert release];
            return;
        }
        
        
    }
    
}



#pragma mark -
#pragma mark detailHideRowSettringProcess

-(void) detailHideRowSettringProcess{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
	NSString *tempDetailRowString = [userDefault objectForKey:@"DetailRowType"];//1이면 세부사항 0이면 가리기
	
    
    if (tempDetailRowString == nil) {
        //nil이면 기본으로 setting
        self.detailRowBool = NO;
        [userDefault setObject:@"0" forKey:@"DetailRowType"];
        
    }else {
        
        if ([tempDetailRowString isEqualToString:@"1"] ) {
            self.detailRowBool = YES;
            [userDefault setObject:@"1" forKey:@"DetailRowType"];
            //            self.detailRowButton.hidden = YES;
            
            
        }else{
            self.detailRowBool = NO; 
            [userDefault setObject:@"0" forKey:@"DetailRowType"];
            
        }
        
    }
    [userDefault synchronize];
    
    
}
-(IBAction)detailHideButtonClicked:(id)sender{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
		case 777:{//세부보기에서 클릭
            [userDefault setObject:@"1" forKey:@"DetailRowType"];
		}break;
		case 888:{//가리기 클릭
            [userDefault setObject:@"0" forKey:@"DetailRowType"];
            
            
        }break;
            
    }
    [userDefault synchronize];
    
    [self detailHideRowSettringProcess];
    [self.contentTableView reloadData];
}






-(void) downloadRequest:(NSURL *)requestURL

{
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *path = [paths objectAtIndex:0];
        
        
        //Some code to get the correct path and name of file
        
        
        if( [manager fileExistsAtPath:path] )
            
        {
            
            NSError *error = [[NSError alloc] init];
            
            [manager removeItemAtPath:path error:&error];
            
            [error release];
            
        }
        
        [manager createFileAtPath:path contents:nil attributes:nil];
        
        handle = [[NSFileHandle fileHandleForWritingAtPath:path] retain];
        
        receivedData =[[NSMutableData alloc] initWithLength:0];
        
        [theConnection start];
        
    }
    [theConnection release];
    
}



#pragma mark NSURLConnection functions____

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    [receivedData setLength:0]; 
    
    filesize = [[NSNumber numberWithLong: [response expectedContentLength] ] retain];
    
    receivedLength = 0;
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    [receivedData appendData:data];
    
    receivedLength = receivedLength + [data length];
    
    
    float progress = 0;
    
    progress = ((float)receivedLength / [filesize floatValue]) ;
    
    
    progressView.progress = progress;
    
    
    //    if( receivedData.length > TWO_AND_A_HALF_MB && handle!=nil )
    if( receivedData.length > 0 && handle!=nil )
        
    {          
        [handle writeData:receivedData];
        
        [receivedData release];
        
        receivedData =[[NSMutableData alloc] initWithLength:0];
    }
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{     
    NSLog(@"%@", connection);
    
    [handle writeData:receivedData];
    
    
    //some code to update UI
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge

{     
    
    //some code to correctly authenticate
}
#pragma mark ipad function

-(IBAction) mainButtonClicked {
	//added by kwbaek
	
	//[[self.splitViewController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
	
	if (self.popoverController != nil && [self.popoverController isPopoverVisible]) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
	//[[self.view superview] removeFromSuperview];
	/*
	 MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	 
	 // 버튼 입력시 화면 전환
	 CATransition *transition = [CATransition animation];
	 // Animate over 3/4 of a second
	 transition.duration = 0.5;
	 // using the ease in/out timing function
	 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	 
	 
	 Selectable types :
	 types = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade}
	 subtypes = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom}
	 
	 
	 transition.type = kCATransitionPush;
	 transition.subtype = kCATransitionFromLeft;
	 transition.delegate = self;
	 
	 [appdelegate.window.layer addAnimation:transition forKey:nil];
	 
	 // -- Push NoticeSplitViewController -- //
	 //NoticeSplitViewController *temp = [[[NoticeSplitViewController alloc] init] autorelease];
	 [self.splitViewController.view removeFromSuperview];
	 appdelegate.window.rootViewController = (UIViewController *)appdelegate.mainController;
	 */
	
	
	
	
}

-(void) popForFirstAppear {
    NSLog(@"%@", [self.mailToolbar items]);
    NSLog(@"%@", [self.view subviews]);
    if(self.popoverController != nil){
		if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
			|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			if (self.view.window != nil) {
                [self.popoverController	 presentPopoverFromBarButtonItem:[[self.mailToolbar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

            }else{
                [self performSelector:@selector(popForFirstAppear) withObject:nil afterDelay:0.1f];
                
                
            }
//if (self.view.window != nil)
//    [popoverController presentPopoverFromRect:CGRectMake(10.0f, 44.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}

	
}

-(void) popoverDismiss {
	if(self.popoverController != nil && [self.popoverController isPopoverVisible]){
		[self.popoverController dismissPopoverAnimated:YES];
	}
}
#pragma mark -
#pragma mark Split view support
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    self.mailToolbar = (UIToolbar *)[self.view viewWithTag:767];

    barButtonItem.title = @" 메 일 ";
    NSMutableArray *items = [[self.mailToolbar items] mutableCopy];
	if([items objectAtIndex:0] == barButtonItem){
		// do nothing
		//NSLog(@"%@, %@", [items objectAtIndex:0], barButtonItem);
	} else {		
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:
                            [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"up.png"],
                             [UIImage imageNamed:@"down.png"],
                             nil]];
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(0, 0, 90, 30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.momentary = YES;
        
        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        [segmentedControl release];
        //    self.navigationItem.rightBarButtonItem = segmentBarItem;

        [items insertObject:segmentBarItem atIndex:1];
        [segmentBarItem release];

        
        
        
		[items insertObject:barButtonItem atIndex:0];
		[self.mailToolbar setItems:items animated:YES];
//        if ([self.currentTableList count]<1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//
//        }
//        if ([currentTableList count] == 1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else if (currentRow == 0 || currentRow == -1) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//        } else if (currentRow+1 == [currentTableList count]) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//        } else {
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }
//        if ([currentTableList count] == 2 && currentRow == 0 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
//            
//        }if ([currentTableList count] == 2 && currentRow == 1 ) {
//            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
//            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
//            
//        }
        [self segmentProcess];
	}
//    NSLog(@"%@", [self.mailToolbar items]);
    //[items insertObject:barButtonItem atIndex:0];
    //[mailToolbar setItems:items animated:YES];
    [items release];
    self.toolbarLabel.hidden = NO;
    self.popoverController = pc;
//    NSLog(@"window:%@", self.view.window);

}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[mailToolbar items] mutableCopy];
    [items removeObjectAtIndex:2];
    [items removeObjectAtIndex:0];
    [mailToolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
    self.toolbarLabel.hidden = YES;

}


#pragma mark -
#pragma mark Rotation support


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
//        NSLog(@"dismissing chart");
//        [self.parentViewController dismissModalViewControllerAnimated:NO];
//    }
    
//    NSLog(@"%f",self.view.frame.size.width );
//    NSLog(@"%f",self.view.frame.size.height );
//    CGRect tempFrame = self.view.frame;
//    tempFrame.size.width = 703.0;
//    tempFrame.size.width = 748.0;

    
}

-(void)imagehidden{
    self.imageViewHiddenMode = YES;
}

-(void)imagehiddenNo{
    self.imageView.hidden = NO;
    
}
-(void)delReloadContentTableView{
//    [currentTableList removeAllObjects];
    
    
    
    
    if (currentRow == [currentTableList count]) {
        currentRow--;
    }
    [self loadDetailContentTableList:currentTableList forIndexPath:currentRow folderID:self.folderID];
    //                    [self.mailListController.currentTableView reloadData ];
    //                    [self.mailListController tableUpdate];
    
    mode_trash = NO;
    if ([currentTableList count]==0) {
        [self.contentTableView reloadData];
    }
    [self segmentProcess];

}
- (void)didAddSubview:(UIView*)subview {
    NSLog( @"didAddSubview" );
}

- (void)didMoveToSuperview {
    NSLog( @"didMoveToSuperview" );
}


- (void)willMoveToSuperview:(UIView*)newSuperview {
    NSLog( @"willMoveToSuperview" );
}

- (void)willMoveToWindow:(UIWindow*)newWindow {
    NSLog( @"willMoveToWindow" );
}

- (void)willRemoveSubview:(UIView*)subview {
    NSLog( @"willRemoveSubview" );
}
- (void)awakeFromNib {
    NSLog(@"window:%@", self.view.window);

}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@", self.currentTableList);
    if (self.imageViewHiddenMode == NO) {
        self.imageView.hidden = NO;
    }else{
        if ([self.currentTableList count] > 0) {
            self.imageView.hidden = YES;
        }else{
            self.imageView.hidden = NO;

        }
    }
    imageViewHiddenMode = NO;

}
- (void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"window:%@", self.view.window);

}
// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewWillLayoutSubviews{
//    NSLog(@"window:%@", self.view.window);

}
// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewDidLayoutSubviews{
//    NSLog(@"window:%@", self.view.window);

}

/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndexa
 {
 
 // if URL open alert
 if(alertView.tag == 777) {
 // open if confirm clicked
 if(buttonIndex != [alertView cancelButtonIndex]) {
 ////NSLog(@"open :  %@", self.webopen);
 [[UIApplication sharedApplication] openURL:self.webopen];
 }
 }
 }
 
 */

@end

//
//  MailWriteController.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 5. 20..
//  Copyright 2011 ktds. All rights reserved.
//

#import "MailWriteController.h"
#import "URL_Define.h"
#import "MailListController.h"
#import "TITokenFieldView.h"
#import "CustomCellTextView.h"
#import "AttachmentCustomCell.h"
#import "FileAttachmentViewController.h"
//#import "ContentCell.h"
@implementation MailWriteController

@synthesize contentTableView;
@synthesize mainContentCell, toCell, ccCell, bccCell, titleCell;
@synthesize clipboard;
@synthesize indicator;
@synthesize contentTextView;
@synthesize toRecipientList, ccRecipientList, bccRecipientList;
@synthesize torecipientsLabel;
@synthesize ccrecipientsLabel;
@synthesize bccrecipientsLabel;
@synthesize subjectField;
@synthesize toRecipientString;
@synthesize contentIndex;
@synthesize indicatorAlert;
@synthesize titleNavigationBar;
@synthesize contentScrolView;
@synthesize contentScrollView;
@synthesize CustomTextViewHeight;
@synthesize contentCell;
@synthesize textviewFocus;
@synthesize attachment;
@synthesize mailID;
@synthesize attachmentFileArray;
@synthesize contactMode;
-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBar.hidden = YES;
	[super viewWillAppear:animated];
	NSLog(@"subjectField_tableview_=[%@]",subjectField.text);
    NSLog(@"bccRecipientList=[%@]",bccRecipientList);
    
    NSLog(@"ccRecipientList=[%@]",ccRecipientList);
	NSLog(@"toRecipientList=[%@]",toRecipientList);
    
	[contactModel.contactOptionDic removeObjectForKey:@"select"];
    
    //	NSLog(@"MAILWRITE [%@][%@]",[contactModel.contactOptionDic objectForKey:@"recipient"],[contactModel.contactOptionDic objectForKey:@"selectedMember"]);
	
	if ([contactModel.contactOptionDic objectForKey:@"toSelectedMember"] != nil || [contactModel.contactOptionDic objectForKey:@"selectedMember"] != nil) {
		if ([[contactModel.contactOptionDic objectForKey:@"toRecipient"]isEqualToString:@"to"] ) {
			[toRecipientList removeAllObjects];
			toRecipientList = [contactModel.contactOptionDic objectForKey:@"toSelectedMember"];
		}else if ([[contactModel.contactOptionDic objectForKey:@"recipient"]isEqualToString:@"to"]) {
			[toRecipientList removeAllObjects];
			
			toRecipientList = [contactModel.contactOptionDic objectForKey:@"selectedMember"];
			
		}
		
		
		if ([[contactModel.contactOptionDic objectForKey:@"recipient"]isEqualToString:@"cc"]) {
			[ccRecipientList removeAllObjects];
			
			ccRecipientList = [contactModel.contactOptionDic objectForKey:@"selectedMember"];
			
		}
		if ([[contactModel.contactOptionDic objectForKey:@"recipient"]isEqualToString:@"bcc"]) {
			[bccRecipientList removeAllObjects];
			
			bccRecipientList = [contactModel.contactOptionDic objectForKey:@"selectedMember"];
			
		}
		
	}else {
        // 취소 버튼 클릭등으로 모델 값이 들어오지 않으면 액션 처리 안함.
        
	}
    NSLog(@"bccRecipientList=[%@]",bccRecipientList);
    
    NSLog(@"ccRecipientList=[%@]",ccRecipientList);
	NSLog(@"toRecipientList=[%@]",toRecipientList);
    
	[self.contentTableView reloadData];
    [activeView becomeFirstResponder];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    contactMode = NO; //contact에서 키보드 사이즈 맞춰줌
	contentScrolView.frame = CGRectMake(0, 0, 1000, 1000);
    //contentScrolView.contentSize = 
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
    //	self.contentTableView.allowsSelection = NO;
	self.contentTextView.delegate = self;
	self.clipboard = nil;
    //	[contentTextView sizeToFit];
    //	CGRect oldFrame = self.indicator.frame;
    //	oldFrame.size.width = 30;
    //	oldFrame.size.height = 30;
	self.indicator.frame = CGRectMake(140, 170, 30, 30);
    //	self.indicator.center = self.view.center;
    //	contentTextView.contentInset = UIEdgeInsetsZero;
    //	NSLog(@"viewchange[%f]",contentTextView.bounds.size.width);
	CGRect frame = contentTextView.frame;
	
	frame.size = contentTextView.contentSize;
    
	contentTextView.frame = frame;
    //	contentTextView.directionalLockEnabled = YES;
    
	self.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
	self.contentTextView.alwaysBounceHorizontal = YES;
    //		self.contentTextView.scalesPageToFit = YES;				
	
	
	
	
	[contentTableView sizeToFit];
    
	contentTableView.scrollEnabled = YES;
	contentTextView.scrollEnabled = YES;
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	self.clipboard = nil;
	
    
    
    // 초대한 사람 목록을 받기 위한 연락처 모델.
    contactModel = [ContactModel sharedInstance];
//	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
//	
//	[noti addObserver:self selector:@selector(setContentText) name:@"contentTextView" object:nil];
	
//	self.CustomTextViewHeight = 260;
    //	NSLog(@"content_retainCunt[%d]",[contentIndex retainCount]) ;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
        || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        // Landscape mode
        //            return 505.0f;
            self.CustomTextViewHeight = 505.0f;
               
    } else {
        self.CustomTextViewHeight = 765.0f;
        
    }

	[contentIndex retain];
	textviewFocus.location = 0; 
	textviewFocus.length = 0;
    attachment = YES;
    self.attachmentFileArray = [[NSMutableArray alloc ]initWithCapacity:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [activeView resignFirstResponder];

	[self.indicator stopAnimating];
	self.navigationController.navigationBar.hidden = NO;
	
    //MailListController *mailListController = [[MailListController alloc] initWithNibName:@"MailListController" bundle:nil];
    //detailBackRefresh = 
    //[mailListController release];
	
	if (self.clipboard != nil) {
		[self.clipboard cancelCommunication];
	}
    [super viewWillDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 //return (interfaceOrientation == UIInterfaceOrientationPortrait);
 return YES;
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
    
    
    [contentTableView release];
	[contentTextView release];
	[contentScrollView release];
	[mainContentCell release];
	[toCell release];
	[ccCell release];
	[bccCell release];
	[titleCell release];
	[toRecipientList release];
	[ccRecipientList release];
	[bccRecipientList release];
	
	[clipboard release];
	[indicator release];
	
	[contactModel release];	
	[model release];
	
	
	[contentIndex release];
	
	[subjectField release];
	[torecipientsLabel release];
	[ccrecipientsLabel release];
	[bccrecipientsLabel release];
	[toRecipientString release];
	[indicatorAlert release];
	[titleNavigationBar release];
	[contentScrolView release];
	[activeView release];
	[contentCell release];
    [mailID release];
    
    
    
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
	switch (section) {
		case 0:
			return 4;
			break;
		case 1:
			return 1;
			break;
        case 2:
            return [attachmentFileArray count];
		default:
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ContentCellIdentifier = @"ContentCellIdentifier";
	static NSString *CustomCellIdentifier2 = @"CustomCellIdentifier2";
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
	UITableViewCell *cell = nil;
    
	if (indexPath.section == 0) {
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		if (indexPath.row == 0) {
			
			NSString *toRecipient = @"";
			if (toRecipientList != nil) {
				for (NSDictionary *dic in toRecipientList ) {
                    //				NSLog(@"%@", [dic objectForKey:@"name"]);
					
					if ([toRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        toRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
					} 
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [toRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(torecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}
				
				torecipientsLabel.textAlignment = UITextAlignmentLeft;
                //		torecipientsLabel.frame = CGRectMake(torecipientsLabel.frame.origin.x, torecipientsLabel.frame.origin.y, torecipientsLabel.frame.size.width, labelSize.height);
				torecipientsLabel.frame = CGRectMake(torecipientsLabel.frame.origin.x, torecipientsLabel.frame.origin.y, torecipientsLabel.frame.size.width, labelSize.height);
				torecipientsLabel.text = toRecipient;
				
			}
			
			cell = toCell;
		} else if (indexPath.row == 1) {
			NSString *ccRecipient = @"";
			if (ccRecipientList != nil) {
				for (NSDictionary *dic in ccRecipientList ) {
                    //NSLog(@"%@", [dic objectForKey:@"name"]);
					
                    //					if ([ccRecipient isEqualToString:@""]) {
                    //						ccRecipient = [dic objectForKey:@"name"];
                    //					} else {
                    //						ccRecipient = [NSString stringWithFormat:@"%@, %@", ccRecipient, [dic objectForKey:@"name"]];
                    //					} 
                    
                    
                    if ([ccRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        ccRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        ccRecipient = [NSString stringWithFormat:@"%@, %@", ccRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
					} 
                    
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [ccRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(ccrecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}
				
				ccrecipientsLabel.textAlignment = UITextAlignmentLeft;
                //		torecipientsLabel.frame = CGRectMake(torecipientsLabel.frame.origin.x, torecipientsLabel.frame.origin.y, torecipientsLabel.frame.size.width, labelSize.height);
				ccrecipientsLabel.frame = CGRectMake(ccrecipientsLabel.frame.origin.x, ccrecipientsLabel.frame.origin.y, ccrecipientsLabel.frame.size.width, labelSize.height);
				ccrecipientsLabel.text = ccRecipient;
				
			}
			cell = ccCell;
		} else if (indexPath.row == 2) {
			NSString *bccRecipient = @"";
			if (bccRecipientList != nil) {
				for (NSDictionary *dic in bccRecipientList ) {
                    //NSLog(@"%@", [dic objectForKey:@"name"]);
					
                    //					if ([bccRecipient isEqualToString:@""]) {
                    //						bccRecipient = [dic objectForKey:@"name"];
                    //					} else {
                    //						bccRecipient = [NSString stringWithFormat:@"%@, %@", bccRecipient, [dic objectForKey:@"name"]];
                    //					} 
                    
                    
                    if ([bccRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        bccRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        bccRecipient = [NSString stringWithFormat:@"%@, %@", bccRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
					} 
                    
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [bccRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(bccrecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}
				
				bccrecipientsLabel.textAlignment = UITextAlignmentLeft;
                //		torecipientsLabel.frame = CGRectMake(torecipientsLabel.frame.origin.x, torecipientsLabel.frame.origin.y, torecipientsLabel.frame.size.width, labelSize.height);
				bccrecipientsLabel.frame = CGRectMake(bccrecipientsLabel.frame.origin.x, bccrecipientsLabel.frame.origin.y, bccrecipientsLabel.frame.size.width, labelSize.height);
				bccrecipientsLabel.text = bccRecipient;
				
			}
			cell = bccCell;
		} else if (indexPath.row == 3) {
            //		contentTextView.text = @"!!!";
            //		titleCell.userInteractionEnabled = NO;
			subjectField = (UITextField *)[titleCell viewWithTag:444];
			NSLog(@"subjectField_tableview_=[%@]",subjectField.text);
			cell = titleCell;
		} 
	}else if (indexPath.section == 1) {
        //		ContentCell *contentCell = (ContentCell *)[tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier];
		contentCell = (ContentCell *)[tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier];
        
		if (contentCell == nil) {
			contentCell = [[[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier] autorelease];
		}
		contentCell.textView.editable = YES;
		contentCell.delegate = self;
        //		NSLog(@"contentIndex[%@]",self.contentIndex);
		
        [contentCell.textView setContentToHTMLString:contentIndex];
		[contentCell.textView setSelectedRange:textviewFocus];
		return contentCell;
        
    } else if(indexPath.section == 2){
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
    
	
    return cell;
	
	
	
	
}
#pragma mark -
#pragma mark AttachFile data source

-(void)action_paymentAttachFile:(id)sender {
    contactModel.contactOptionDic = nil; //초기화
    
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
    
    NSString *indexString = [NSString stringWithFormat:@"%d", index];
    NSDictionary *dic_current = [self.attachmentFileArray objectAtIndex:index];
    
    FileAttachmentViewController *fileAttachmentViewController = [[FileAttachmentViewController alloc] initWithNibName:@"FileAttachmentViewController" bundle:nil];
    fileAttachmentViewController.title = self.title;
    //    
    //    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:fileAttachmentViewController animated:YES];
    //    
    [fileAttachmentViewController loadAttachmentMailID:self.mailID attachmentIndex:[dic_current objectForKey:@"fileIndex"] attachmentName:[dic_current objectForKey:@"attachment_name"] attachmentIsFile:[dic_current objectForKey:@"attachment_isfile"]];
    
    //    
    [fileAttachmentViewController release];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //    NSDictionary *dic_current = [self.attachmentArray objectAtIndex:index];
    //    NSString *encodedUrl = [[dic_current objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    self.webopen = [NSURL URLWithString:encodedUrl];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"safari에서 열기."
    //                                                   delegate:self cancelButtonTitle:@"취소" otherButtonTitles: @"확인", nil];
    //    alert.tag = 5555;
    //    [alert show];	
    //    [alert release];
    
    
    
    
}

- (void)endEditing:(UIBarButtonItem *)sender {
    [activeView resignFirstResponder];
    //    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    //    self.navigationItem.hidesBackButton = NO;
	
	
	
    
}
-(void)mailForwardfileArray:(NSMutableArray *)fileArrayList{
    [self.attachmentFileArray removeAllObjects];
    self.attachmentFileArray = fileArrayList;
    [self.contentTableView reloadData];
    //    [self tableViewNeedsToUpdateHeight];
}
#pragma mark -
#pragma mark ContentCellDelegate & SubjectCellDelegate
-(void)contentCellDidChange:(ContentCell *)cell{
	self.CustomTextViewHeight = cell.textView.contentSize.height;
	self.contentIndex = [cell.textView contentAsHTMLString];
    //	[cell.textView.selectedRange:textviewFocus];
	textviewFocus = cell.textView.selectedRange;//focus 저장해서 나중에 표현 해준다(editing 할 때마다 저장)
    //	NSLog(@"contentIndex[%@]",contentIndex);
    
	[self tableViewNeedsToUpdateHeight];
    
	
}
- (void)contentCellDidChangeChangeSelection:(ContentCell *)cell{
	textviewFocus = cell.textView.selectedRange;//focus 저장해서 나중에 표현 해준다(텍스트뷰에서 editing 안하고 포커스만 줬을때)
    
}
- (void)contentCellDidBeginEditing:(ContentCell *)cell {
    activeView = cell.textView;
    
	
	
    //    if (self.navigationItem.hidesBackButton) {
    //        return;
    //    }
    //    self.navigationItem.hidesBackButton = YES;
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)] 
    //                                     animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
    if (contactMode == YES) {
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect.size.height = 10;
        keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    }else{
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // Wouldn't it be fantastic if, when in landscape mode, width was actually width and not height?
        keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;

    }
    
    
	
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	[self resizeViews];
}
- (void)resizeViews {
	int tableRowHeight = 44;
	CGRect newFrame = self.contentTableView.frame;
	newFrame.size.width = self.view.bounds.size.width;
	newFrame.size.height = self.view.bounds.size.height- keyboardHeight -tableRowHeight;//키보드 높이와 숨겨진 네비게이션 바를 빼줌
	[contentTableView setFrame:newFrame];
	
	NSInteger tableHeight = 0;
    for (NSInteger i = 0; i < [self.contentTableView numberOfSections]; i++) 
        tableHeight += [self.contentTableView numberOfRowsInSection:i] * self.contentTableView.rowHeight;
	int torecipientsHeight;
	int ccrecipientsHeight;
	int bccrecipientsHeight;
	if (torecipientsLabel.frame.size.height < 27) {
		torecipientsHeight = 44;
	}else {
		torecipientsHeight = torecipientsLabel.frame.size.height + 19;
	}
	if (ccrecipientsLabel.frame.size.height < 27) {
		ccrecipientsHeight = 44;
	}else {
		ccrecipientsHeight = ccrecipientsLabel.frame.size.height + 19;
	}
	if (bccrecipientsLabel.frame.size.height < 27) {
		bccrecipientsHeight = 44;
	}else {
		bccrecipientsHeight = bccrecipientsLabel.frame.size.height + 19;
	}
	
	int askasdjsdfsdf= self.view.bounds.size.height - keyboardHeight - tableHeight + torecipientsHeight + ccrecipientsHeight + bccrecipientsHeight + tableRowHeight;
    //	NSLog(@"textview frame[%d]",askasdjsdfsdf);
    //		[contentTextView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - keyboardHeight - tableHeight + torecipientsHeight + ccrecipientsHeight + bccrecipientsHeight + tableRowHeight)];
    //	CGSize labelSize = [contentTextView.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(contentTextView.frame.size.width, FLT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
    //	[contentTextView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, labelSize.height)];
	
	[contentTextView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - keyboardHeight + tableHeight)];
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [contentCell.textView becomeFirstResponder];
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

	if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {	// 받는사람
                
				// 모델값을 설정한다.
				// 연락처 선택 옵션의 타이틀 및 타겟 등을 정의 한다.
                
                contactModel.contactOptionDic = nil; //초기화
                contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                [contactModel.contactOptionDic setObject:NSLocalizedString(@"btn_recevier",@"받는사람") forKey:@"title"];
                [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"btn_recevier",@"받는사람")] forKey:@"items"];
                [contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                [contactModel.contactOptionDic setObject:@"to" forKey:@"recipient"];
                if (toRecipientList != nil) {
                    NSMutableArray *arrTemp = nil;
                    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dic in toRecipientList ) {
                        [arrTemp addObject:dic];
                    }
                    //				NSLog(@"%@.......................",arrTemp);
                    
                    [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"]; 
                } 
                //			[self.toRecipientList removeAllObjects];
                
                Class targetClass = NSClassFromString(@"ContactSelectViewController");
                
                id viewController = [[targetClass alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                viewController = nil;
                
            }	break;
            case 1: {	// 시작 종료
                contactModel.contactOptionDic = nil; //초기화
                contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                [contactModel.contactOptionDic setObject:NSLocalizedString(@"mail_cc",@"참조") forKey:@"title"];
                [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"mail_cc",@"참조")] forKey:@"items"];
                [contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                [contactModel.contactOptionDic setObject:@"cc" forKey:@"recipient"];
                if (ccRecipientList != nil) {
                    NSMutableArray *arrTemp = nil;
                    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dic in ccRecipientList ) {
                        [arrTemp addObject:dic];
                    }
                    [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"]; 
                } 
                
                Class targetClass = NSClassFromString(@"ContactSelectViewController");
                
                id viewController = [[targetClass alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                
                [viewController release];
                viewController = nil;
                //			[ccRecipientList removeAllObjects];
                
            }	break;
            case 2: {	// 반복
                contactModel.contactOptionDic = nil; //초기화
                contactModel.contactOptionDic = [[NSMutableDictionary alloc] init];
                [contactModel.contactOptionDic setObject:NSLocalizedString(@"mail_bcc",@"숨은참조") forKey:@"title"];
                [contactModel.contactOptionDic setObject:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"mail_bcc",@"숨은참조")] forKey:@"items"];
                [contactModel.contactOptionDic setObject:@"Y" forKey:@"select"];
                [contactModel.contactOptionDic setObject:@"bcc" forKey:@"recipient"];
                if (bccRecipientList != nil) {
                    NSMutableArray *arrTemp = nil;
                    arrTemp = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dic in bccRecipientList ) {
                        [arrTemp addObject:dic];
                    }
                    [contactModel.contactOptionDic removeObjectForKey:@"selectedMember"];
                    [contactModel.contactOptionDic setObject:arrTemp forKey:@"selectedMember"]; 
                } 
                
                Class targetClass = NSClassFromString(@"ContactSelectViewController");
                
                id viewController = [[targetClass alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                
                [viewController release];
                viewController = nil;
                //			[bccRecipientList removeAllObjects];
                
            }	break;
            case 3: {	
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                //			[self.subjectField becomeFirstResponder];
                
            }	break;
            case 4: {	
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                //			[self.contentTextView becomeFirstResponder];
                [contentCell.textView becomeFirstResponder];
                
            }	break;
                
            default:
                break;
        }
        
    }
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.contentTextView becomeFirstResponder];
        
	}
    //	[self.contentTableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITextView *tempView;
	
	
	/*= newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
	 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
	 constrainedToSize:CGSizeMake(320,99999)
	 lineBreakMode:UILineBreakModeWordWrap];*/
	
	if (indexPath.section == 0) {
		
		if (indexPath.row == 0) {
			
			NSString *toRecipient = @"";
			if (toRecipientList != nil) {
				for (NSDictionary *dic in toRecipientList ) {
                    //NSLog(@"%@", [dic objectForKey:@"name"]);
					
                    //					if ([toRecipient isEqualToString:@""]) {
                    //						toRecipient = [dic objectForKey:@"name"];
                    //					} else {
                    //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                    //					} 
					if ([toRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        toRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
					} 
                    
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [toRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(torecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}else if (labelSize.height == 0) {
					labelSize.height = 25;
				}
				
				return 9 + labelSize.height + 10;
				
			}else {
				return 44.0;
			}
			
			
			
		} else if (indexPath.row == 1) {
			NSString *ccRecipient = @"";
			if (ccRecipientList != nil) {
				for (NSDictionary *dic in ccRecipientList ) {
                    //NSLog(@"%@", [dic objectForKey:@"name"]);
					
                    //					if ([ccRecipient isEqualToString:@""]) {
                    //						ccRecipient = [dic objectForKey:@"name"];
                    //					} else {
                    //						ccRecipient = [NSString stringWithFormat:@"%@, %@", ccRecipient, [dic objectForKey:@"name"]];
                    //					} 
                    
                    if ([ccRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        ccRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        ccRecipient = [NSString stringWithFormat:@"%@, %@", ccRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
					} 
                    
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [ccRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(ccrecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}else if (labelSize.height == 0) {
					labelSize.height = 25;
				}
				
				return 9 + labelSize.height + 10;
				
			}else {
				return 44.0;
			}
			
		}else if (indexPath.row == 2) {
			NSString *bccRecipient = @"";
			if (bccRecipientList != nil) {
				for (NSDictionary *dic in bccRecipientList ) {
                    //NSLog(@"%@", [dic objectForKey:@"name"]);
					
                    //					if ([bccRecipient isEqualToString:@""]) {
                    //						bccRecipient = [dic objectForKey:@"name"];
                    //					} else {
                    //						bccRecipient = [NSString stringWithFormat:@"%@, %@", bccRecipient, [dic objectForKey:@"name"]];
                    //					} 
                    
                    if ([bccRecipient isEqualToString:@""]) {
                        //						toRecipient = [dic objectForKey:@"name"];
                        bccRecipient = [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]];//email 표시 해주기 위해 변경
                        //                        [NSString stringWithFormat:@"%@",email ]
					} else {
                        //						toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"name"]];
                        bccRecipient = [NSString stringWithFormat:@"%@, %@", bccRecipient, [NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"name"],  [dic objectForKey:@"email"]]];//email 표시 해주기 위해 변경
                        
                    }
				}
				UILineBreakMode labelBreakMode = UILineBreakModeTailTruncation;		// xib에서 설정한 모임소개 라벨의 width
				
				CGSize labelSize = [bccRecipient sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(bccrecipientsLabel.frame.size.width, FLT_MAX) lineBreakMode:labelBreakMode];
				if (labelSize.height > 95) {
					labelSize.height = 95;
				}else if (labelSize.height == 0) {
					labelSize.height = 25;
				}
				
				return 9 + labelSize.height + 10;
				
			}else {
				return 44.0;
			}
			
		}else if (indexPath.row == 3) {
			return 44.0;
			
		}
		
	}
	
	
	else if (indexPath.section == 1) {
        //			NSLog(@"bounds[%f]",contentTextView.bounds.size.height);
        //			NSLog(@"frame[%f]",contentTextView.bounds.size.height);
        //			NSLog(@"viewchange[%f]",contentTextView.bounds.size.width);
//		if (self.CustomTextViewHeight <260) {
//			return 260;
//		}else {
//			return self.CustomTextViewHeight;
//            
//		}
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
            || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            // Landscape mode
//            return 505.0f;
            if (self.CustomTextViewHeight <505.0f) {
                return 505.0f;
            }else {
                return self.CustomTextViewHeight;
                
            }
            
        } else {
            // Portrait mode
//            return 765.0f;
            if (self.CustomTextViewHeight <765.0f) {
                return 765.0f;
            }else {
                return self.CustomTextViewHeight;
                
            }

        }

		
	}else if(indexPath.section == 2){
        return 44.0;
    }
	
}


#pragma mark -
#pragma mark UITextViewDelegate
- (void)tableViewNeedsToUpdateHeight
{
    [UIView setAnimationsEnabled:NO];
    [self.contentTableView beginUpdates];
    [self.contentTableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}


#pragma mark -
#pragma mark ClipboardDelegate


-(IBAction) backButtonClicked {
	if([self.torecipientsLabel.text length] > 0 || [self.ccrecipientsLabel.text length] > 0|| [self.bccrecipientsLabel.text length] > 0 || [self.subjectField.text length] > 0) {
		[self showActionSheet];
	}else {
		contactModel.contactOptionDic = nil;
		[toRecipientList removeAllObjects];
		[ccRecipientList removeAllObjects];
		[bccRecipientList removeAllObjects];
        NSLog(@"%@", [[self.navigationController viewControllers]objectAtIndex:0 ]);
         NSLog(@"%@", [[[self.navigationController viewControllers]objectAtIndex:0 ]splitViewController]);
        NSLog(@"%@",[[self.splitViewController viewControllers]objectAtIndex:0]);
        [self overlaycancelProcess];
		[self.navigationController popViewControllerAnimated:YES];
        
		
	}
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


-(IBAction) writeButtonClicked {
    [self overlaycancelProcess];

	if(self.toRecipientList != nil) {
        // get clipboard module		
        //Communication *
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
        //NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
        ////NSLog(@"%@", [tempDefaults stringForKey:@"login_id"]);
		
        // make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		BOOL result;
		
		NSString *content = [contentCell.textView contentAsHTMLString];
		
        
		
		
		
		NSString *toRecipient = @"";
		if (toRecipientList != nil) {
			for (NSDictionary *dic in toRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([toRecipient isEqualToString:@""]) {
					toRecipient = [dic objectForKey:@"email"];
				} else {
					toRecipient = [NSString stringWithFormat:@"%@; %@", toRecipient, [dic objectForKey:@"email"]];
				} 
			}
            //			NSLog(@"toRecipient1=[%@]", toRecipient);
			toRecipient = [toRecipient stringByReplacingOccurrencesOfString:@" " withString:@""];
            //			NSLog(@"toRecipient2=[%@]", toRecipient);
            
			toRecipient = [toRecipient stringByReplacingOccurrencesOfString:@"," withString:@";"];
            //			NSLog(@"toRecipient3=[%@]", toRecipient);
            
		}
		NSString *ccRecipient = @"";
		if (ccRecipientList != nil) {
			for (NSDictionary *dic in ccRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([ccRecipient isEqualToString:@""]) {
					ccRecipient = [dic objectForKey:@"email"];
				} else {
					ccRecipient = [NSString stringWithFormat:@"%@; %@", ccRecipient, [dic objectForKey:@"email"]];
				} 
			}
			
		}
		
		NSString *bccRecipient = @"";
		if (bccRecipientList != nil) {
			for (NSDictionary *dic in bccRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([bccRecipient isEqualToString:@""]) {
					bccRecipient = [dic objectForKey:@"email"];
				} else {
					bccRecipient = [NSString stringWithFormat:@"%@; %@", bccRecipient, [dic objectForKey:@"email"]];
				} 
			}
			
		}
		
		//NSLog(@"asdfasdfasdfasdfasdfasdfasdf%@", content);
		if([toRecipient isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"mail_to_alert",@"mail_to_alert")
														   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"ok"), nil];
			[alert show];	
			[alert release];
			
		}else {
			[requestDictionary setObject:self.subjectField.text forKey:@"subject"];
			[requestDictionary setObject:content forKey:@"contents"];
			[requestDictionary setObject:toRecipient forKey:@"torecipients"];
			[requestDictionary setObject:ccRecipient forKey:@"ccrecipients"];
			[requestDictionary setObject:bccRecipient forKey:@"bccrecipients"];
            //			NSLog(@"toRecipient=%@", toRecipient);
            //			NSLog(@"ccrecipients=%@", ccRecipient);
            //			NSLog(@"bccrecipients=%@", bccRecipient);
			if (attachment == NO) {//포워딩 메일 첨부파일 포함 시 
                NSLog(@"%@", mailID);
                [requestDictionary setObject:self.mailID forKey:@"mail_id"];
                
                result = [clipboard callWithArray:requestDictionary serviceUrl:forwardEmailInfo];
                attachment = YES;
                if (!result) {
					// error occurred
                    
                }
                
            }else{
                result = [clipboard callWithArray:requestDictionary serviceUrl:URL_sendEmailInfo];
                
                if (!result) {
					// error occurred
                    
                }
                
            }
			
		}
        
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"mail_to_alert",@"mail_to_alert")
													   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"ok"), nil];
		[alert show];	
		[alert release];
	}
}

-(void)setContentText{
    //	if(self.contentIndex)
    //		[self.contentTextView setContentToHTMLString:self.contentIndex];
    //	UIScrollView *scrollerView = contentTextView;
    //		
    //			UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
    //				// reset webview's height
    //			CGRect currentFrame = tempView.frame;
    //			
    //			CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, scrollerView.contentSize.width, self.contentTextView.frame.size.height);
    //			
    //			
    //			tempView.frame = newFrame;
    //			[self.contentTableView reloadData];
    //			self.contentTableView.hidden = NO;
    //			self.contentTableView.userInteractionEnabled = YES;
	
    //	[self.contentTableView reloadData];
	
} 
#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.indicatorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"sending",@"보내는 중..")] message:nil//@"작성을 완료하였습니다"
													delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	[self.indicatorAlert show];	
	[self.indicatorAlert release];
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	[self.indicator stopAnimating];
	
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
    ////NSLog(@"%@", rslt);
    // get result data from result dictionary
	if (rslt!=nil) {
		int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
		[self.indicatorAlert dismissWithClickedButtonIndex:[self.indicatorAlert cancelButtonIndex] animated:NO];
        // get value dictionary form result dictionary
		if (resultNum == 0) {
			self.clipboard = nil;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"mail_completed",@"전송을 완료하였습니다") 
														   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
			alert.tag = 12345;
			[alert show];	
			[alert release];		
		} else {
            // -- error handling -- //
            // Show alert view to user
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
														   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
	} else {
		[self.indicatorAlert dismissWithClickedButtonIndex:[self.indicatorAlert cancelButtonIndex] animated:NO];
		
        //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
        //													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
        //		[alert show];	
        //		[alert release];
	}
	
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
    // Alert network error message
	[self.indicator stopAnimating];
    //NSLog(@"%@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
	[alert show];	
	[alert release];
}


#pragma mark -
#pragma mark Login Alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
    // if delete qusetion alert
	if(alertView.tag == 12345) {
        // delete confirm
		if(buttonIndex == [alertView cancelButtonIndex]) {
			[toRecipientList removeAllObjects];
			[ccRecipientList removeAllObjects];
			[bccRecipientList removeAllObjects];
			
			[self.navigationController popViewControllerAnimated:YES];
			
			/*
			 NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
			 if (self.writeMode==0) {
			 [noti postNotificationName:@"QnAListReload" object:self];
			 } else {
			 [noti postNotificationName:@"QnADetailReload" object:self];
			 [noti postNotificationName:@"QnAReloadSet" object:self];
			 }
			 */
		}
	}
}

-(void)showActionSheet{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"btn_cancel",@"취소") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete_draft",@"임시 저장 삭제"), NSLocalizedString(@"save_draft",@"임시 저장"), nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 || buttonIndex == 1) {
        [self overlaycancelProcess];
        
    }

    if (buttonIndex == 0) {//임시저장 삭제
        // ...
        // Pass the selected object to the new view controller.
		[toRecipientList removeAllObjects];
		[ccRecipientList removeAllObjects];
		[bccRecipientList removeAllObjects];
		
		[self.navigationController popViewControllerAnimated:YES];
		
		
    } else if (buttonIndex == 1) {//임시저장
		
        // get clipboard module		
        //Communication *
		clipboard = [[Communication alloc] init];
		clipboard.delegate = self;
		
        //NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
        ////NSLog(@"%@", [tempDefaults stringForKey:@"login_id"]);
		
        // make request dictionary
		NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		BOOL result;
		NSString *content = [contentCell.textView contentAsHTMLString];
		
		
        //		
        //		contentString = [[NSMutableString alloc]init];
        //		NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML;"];
        //		[contentString appendFormat:@"\n\n\n\n%@", [self.contentDictionary objectForKey:@"mail_receivedtime"]];
        //		[contentString appendFormat:@" '%@' ", [self.contentDictionary objectForKey:@"mail_fromname"]];
		
		
        
		
		
		NSString *toRecipient = @"";
		if (toRecipientList != nil) {
			for (NSDictionary *dic in toRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([toRecipient isEqualToString:@""]) {
					toRecipient = [dic objectForKey:@"email"];
				} else {
					toRecipient = [NSString stringWithFormat:@"%@, %@", toRecipient, [dic objectForKey:@"email"]];
				} 
			}
			
		}
		NSString *ccRecipient = @"";
		if (ccRecipientList != nil) {
			for (NSDictionary *dic in ccRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([ccRecipient isEqualToString:@""]) {
					ccRecipient = [dic objectForKey:@"email"];
				} else {
					ccRecipient = [NSString stringWithFormat:@"%@, %@", ccRecipient, [dic objectForKey:@"email"]];
				} 
			}
			
		}
		
		NSString *bccRecipient = @"";
		if (bccRecipientList != nil) {
			for (NSDictionary *dic in bccRecipientList ) {
				//NSLog(@"%@", [dic objectForKey:@"email"]);
				
				if ([bccRecipient isEqualToString:@""]) {
					bccRecipient = [dic objectForKey:@"email"];
				} else {
					bccRecipient = [NSString stringWithFormat:@"%@, %@", bccRecipient, [dic objectForKey:@"email"]];
				} 
			}
			
		}
		
		//NSLog(@"asdfasdfasdfasdfasdfasdfasdf%@", content);
        NSString *str_subjectField = subjectField.text;
		[requestDictionary setObject:self.subjectField.text forKey:@"subject"];
		[requestDictionary setObject:content forKey:@"contents"];
		[requestDictionary setObject:toRecipient forKey:@"torecipients"];
		[requestDictionary setObject:ccRecipient forKey:@"ccrecipients"];
		[requestDictionary setObject:bccRecipient forKey:@"bccrecipients"];
		
		result = [clipboard callWithArray:requestDictionary serviceUrl:URL_createDraftEmailInfo];
		
		if (!result) {
            // error occurred 
			
		}
		
		
    } 

}
-(void)overlaycancelProcess{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    
    if ([[[self.navigationController viewControllers]objectAtIndex:0] isKindOfClass:NSClassFromString(@"MailDetailController")]) {
        NSLog(@"asdf");
        [noti postNotificationName:@"imagehidden" object:self];
        [noti postNotificationName:@"overlayViewCancel" object:self];
        
    }else if([[[self.navigationController viewControllers]objectAtIndex:0] isKindOfClass:NSClassFromString(@"OrgNaviDetailView")]){
        [noti postNotificationName:@"orgOverlayViewCancel" object:self];
        
    }else if([[[self.navigationController viewControllers]objectAtIndex:0] isKindOfClass:NSClassFromString(@"SearchEmployeeDetail")]){
        [noti postNotificationName:@"employeeOverlayViewCancel" object:self];

    }

}
@end

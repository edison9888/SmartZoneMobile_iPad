//
//  BoardDetailContentController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "BoardDetailContentController.h"
#import "URL_Define.h"
#import "AttachmentCustomCell.h"
#import "BoardAttachmentViewController.h"
#import "MailWriteController.h"

@implementation BoardDetailContentController

@synthesize contentWebView;
@synthesize contentTableView;
@synthesize contentDictionary;
@synthesize mainContentCell;
@synthesize titleCell;
@synthesize nameCell;
@synthesize clipboard;
@synthesize indicator;
@synthesize webViewHeight;
@synthesize webviewLoadFlag;
@synthesize webopen;
@synthesize attachmentArray;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.contentTableView.delegate = self;
	self.contentTableView.dataSource = self;
	self.contentTableView.allowsSelection = NO;
	self.contentWebView.delegate = self;
	self.contentDictionary = nil;
	self.clipboard = nil;
	self.webviewLoadFlag = 0;
	self.webViewHeight = 335.0f;
    
	self.webopen = nil;
	
	CGRect oldFrame = self.indicator.frame;
	oldFrame.size.width = 30;
	oldFrame.size.height = 30;
	self.indicator.frame = oldFrame;
	self.indicator.center = self.view.center;
    self.attachmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    contactModel = [ContactModel sharedInstance];

}

- (void)viewWillDisappear:(BOOL)animated {
	[self.indicator stopAnimating];
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
}


- (void)dealloc {
	[contentWebView release];
	[contentTableView release];
	[contentDictionary release];
	[mainContentCell release];
	[titleCell release];
	[nameCell release];
	[clipboard release];
	[indicator release];
	[webopen release];
	[attachmentArray release];

    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.attachmentArray count]>0) {
        return section == 0 ? 3 : [self.attachmentArray count];
    }else{
        return section == 0 ? 3 : 0 ;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";

	UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = titleCell;
        } else if (indexPath.row == 1) {
            cell = nameCell;
        } else if (indexPath.row == 2) {
            cell = mainContentCell;
        }

    }
    else if (indexPath.section == 1 ) {//첨부
    
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
		NSDictionary *dic_current = [self.attachmentArray objectAtIndex:indexPath.row];
        //        tmpCell.iconTitleLabel.text = nil;
        //        tmpCell.iconTitleLabel.text = [dic_current objectForKey:@"attachment_name"];
        UILabel *tempDate = (UILabel *)[tmpCell viewWithTag:111];//받은시간 4번셀
        tempDate.text = [dic_current objectForKey:@"title"];
        UILabel *tempSize = (UILabel *)[tmpCell viewWithTag:333];//받은시간 4번셀
        
        tempSize.text =  @"";
        UIButton *btn_tmp = (UIButton *)[tmpCell viewWithTag:222];
        btn_tmp.tag = indexPath.row;
        [btn_tmp addTarget:self action:@selector(action_paymentAttachFile:) forControlEvents:UIControlEventTouchUpInside];

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
    temporaryBarButtonItem.title = NSLocalizedString(@"btn_back", @"뒤로");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];	
    
////    NSString *mailIdString = [NSString stringWithFormat:@"%@", [[self.currentTableList objectAtIndex:currentRow] objectForKey:@"mail_id"]];
////    NSString *indexString = [NSString stringWithFormat:@"%d", index];
//    NSDictionary *dic_current = [self.attachmentArray objectAtIndex:index];
//    
//    BoardAttachmentViewController *boardAttachmentViewController = [[BoardAttachmentViewController alloc] initWithNibName:@"BoardAttachmentViewController" bundle:nil];
//    //    mailAttachmentViewController.title = self.title;
//    
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:boardAttachmentViewController animated:YES];
//    
//    [boardAttachmentViewController loadAttachmentMailID:@"" attachmentIndex:@"" attachmentName:[dic_current objectForKey:@"url"] attachmentIsFile:[dic_current objectForKey:@"url"]];
//    
//    [boardAttachmentViewController release];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dic_current = [self.attachmentArray objectAtIndex:index];
    NSString *tempUrl = [dic_current objectForKey:@"url"];
    NSString *tempTitle = [dic_current objectForKey:@"title"];

    BoardAttachmentViewController *boardAttachmentViewController = [[BoardAttachmentViewController alloc] initWithNibName:@"BoardAttachmentViewController" bundle:nil];
    boardAttachmentViewController.title = self.title;
    //    
    //    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:boardAttachmentViewController animated:YES];
    //    
    [boardAttachmentViewController boardAttachemntlink:tempUrl attachmentTitle:tempTitle];
    
    //    
    [boardAttachmentViewController release];
//    // get clipboard module
//	//Communication *
//	clipboard = [[Communication alloc] init];
//	clipboard.delegate = self;
//	self.webviewLoadFlag = 0;
//    openAttachment = YES;
//	// make request dictionary
//	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//	//[requestDictionary setObject:@"KT" forKey:@"userid"];
//    [requestDictionary setObject:tempTitle forKey:@"title"];
//	[requestDictionary setObject:tempUrl forKey:@"url"];
//	AttachmentTitle = @"";
//    AttachmentTitle = tempTitle;
//	// call communicate method
//	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:getBoardDetailAttachedFileURL];
//	
//	if (!result) {
//		// error occurred
//		
//	}

    

    
    

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     NoticeDetailContentController *detailContentController = [[NoticeDetailContentController alloc] initWithNibName:@"NoticeDetailContentController" bundle:nil];
     detailContentController.title = self.title;
     //[detailContentController loadDetailContentAtIndex:[indexPath row]];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailContentController animated:YES];
     [detailContentController loadDetailContentAtIndex:[indexPath row]];
     [detailContentController release];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//UITextView *tempView;
	CGSize newSize;
	
	/*= newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
     sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
     constrainedToSize:CGSizeMake(320,99999)
     lineBreakMode:UILineBreakModeWordWrap];*/
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                //return 40.0;
                ////NSLog(@"%@", [self.contentDictionary objectForKey:@"bulltitle"]);
                newSize = [[self.contentDictionary objectForKey:@"bulltitle"]
                           sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
                           constrainedToSize:CGSizeMake(320,99999)
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
                return 44.0;
                break;
            case 2:
                /*
                 //tempView = (UITextView *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:777];
                 tempView = (UIWebView *)[mainContentCell viewWithTag:777];
                 newSize = [tempView.text
                 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
                 constrainedToSize:CGSizeMake(320,99999)
                 lineBreakMode:UILineBreakModeWordWrap];
                 ////NSLog(@"%f", newSize.height);
                 return newSize.height + 20.0;// 20px margin
                 */
                
                
                
                if (self.webViewHeight < 325.0f) {
                    return 335.0;
                    //return self.webViewHeight+10.0f;
                } else {
                    return self.webViewHeight+20.0f;
                }
                break;
            default:
                return 0.0;
                break;
                
        }

    }else{
        return 44.0;
    }
}

-(void) loadDetailContentAtIndex:(NSString *)index forCategory:(NSString *)category {
    
	// get clipboard module
	//Communication *
	clipboard = [[Communication alloc] init];
	clipboard.delegate = self;
	self.webviewLoadFlag = 0;
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	//[requestDictionary setObject:@"KT" forKey:@"userid"];
	[requestDictionary setObject:category forKey:@"boardid"];
	[requestDictionary setObject:index forKey:@"attachid"];
	
	// call communicate method
	BOOL result = [clipboard callWithArray:requestDictionary serviceUrl:getBoardDetail];
	
	if (!result) {
		// error occurred
		
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.contentTableView.userInteractionEnabled = YES;
    self.contentTableView.hidden = NO;

	[self.indicator stopAnimating];
	//CGFloat 
	//self.webViewHeight = 335.0f;
	//int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
    if (webView.subviews.count > 0) {
        UIScrollView *scrollerView = [webView.subviews objectAtIndex:0];
        if (scrollerView.subviews.count > 0) {
            //UIView *webDocView = scrollerView.subviews.lastObject;
            //if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
            ////NSLog(@"webDocView : %@", webDocView.frame);
            ////NSLog(@"webView : %@", webView.frame);
            //self.webViewHeight = webDocView.frame.size.height;
//			self.webViewHeight = scrollerView.contentSize.height;
			
			if (self.webviewLoadFlag == 0) {
				self.webviewLoadFlag = 1;
				//self.webViewHeight = scrollHeight;
				UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
				// reset webview's height
				CGRect currentFrame = tempView.frame;
				CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, self.webViewHeight);
				tempView.frame = newFrame;
				[self.contentTableView reloadData];
//				self.contentTableView.hidden = NO;
//				self.contentTableView.userInteractionEnabled = YES;
			}
        }
    }
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	// check link click and prevent navatationing

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
#pragma mark -
#pragma mark ClipboardDelegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	[self.indicator startAnimating];
	self.contentTableView.hidden = YES;
	self.contentTableView.userInteractionEnabled = NO;
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
    self.contentTableView.userInteractionEnabled = YES;
    self.contentTableView.hidden = NO;
    
	[self.indicator stopAnimating];

	//[self.indicator stopAnimating];
	
	// get result data from result dictionary
	NSDictionary *rslt = (NSDictionary *)[_resultDic objectForKey:@"result"];
	////NSLog(@"%@", rslt);
	int resultNum = [(NSString *)[rslt objectForKey:@"code"] intValue];//STATE_SUCCESS;
	
	// get value dictionary form result dictionary
    
	// -- set label if success -- //
	if (resultNum == 0 && rslt != nil) {
		
        self.contentDictionary = nil;
        self.contentDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_resultDic objectForKey:@"BoardDetail"]];
        
        //[self.contentTableView reloadData];
        
        
        UILabel *tempTitle = (UILabel *)[titleCell viewWithTag:111];
        tempTitle.text = [self.contentDictionary objectForKey:@"title"];
        
        UILabel *tempName = (UILabel *)[nameCell viewWithTag:222];
        tempName.text = [self.contentDictionary objectForKey:@"author"];

        UILabel *tempDate = (UILabel *)[nameCell viewWithTag:333];
        tempDate.text = [self.contentDictionary objectForKey:@"createdtime"];
        
        UIWebView *tempView = (UIWebView *)[mainContentCell viewWithTag:777];
        // reset webview's height
        CGRect currentFrame = tempView.frame;
        CGRect newFrame = CGRectMake(currentFrame.origin.x , currentFrame.origin.y, currentFrame.size.width, 354);
        tempView.frame = newFrame;
        
        if (tempView.subviews.count > 0) {
            UIScrollView *scrollerView = [tempView.subviews objectAtIndex:0];
            scrollerView.contentSize = CGSizeMake(320, 354);
            //CGSize scrollFrame = scrollerView.contentSize;
            
        }
        [self.attachmentArray removeAllObjects];
        self.attachmentArray = (NSMutableArray *)[_resultDic objectForKey:@"urlList"];
        //        NSLog(@"%@",self.contentDictionary);
        //        NSLog(@"%@",self.attachmentArray);
        //
        //        NSString *asdf = [self.contentDictionary objectForKey:@"body"];
        //        [asdf ]
        
        
        
        NSMutableString *attachmentString = [[NSMutableString alloc]init];
        //              [attachmentString appendFormat:@"document.body.style.zoom = 3.5"];
        
        [attachmentString appendFormat:@"\n%@", [self.contentDictionary objectForKey:@"body"]];
                NSLog(@"%@", [self.contentDictionary objectForKey:@"body"]);
        [attachmentString appendFormat:@"<br>"];
        [attachmentString appendFormat:@"<meta name='viewport' content='user-scalable=yes, initial-scale=0.8'/>"];
        
        
        [tempView loadHTMLString:attachmentString baseURL:nil];//웹뷰에 뿌려줌
        attachmentString = nil;
        [attachmentString release];
        
        
        tempView.delegate = self;
        self.clipboard = nil;
        
	} else {
		// -- error handling -- //
		// Show alert view to user
		[self.indicator stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"alert") message:[rslt objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
		[alert show];	
		[alert release];

	}
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
     // if URL open alert
     if(alertView.tag == 5555) {
         // open if confirm clicked
         if(buttonIndex != [alertView cancelButtonIndex]) {
             ////NSLog(@"open :  %@", self.webopen);
             
             [[UIApplication sharedApplication] openURL:self.webopen];
         }
     }

 }
 
@end

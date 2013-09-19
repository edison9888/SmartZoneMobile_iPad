//
//  FileAttachmentViewController.m
//  MobileKate2.0_iPad
//
//  Created by Baek Kyung Wook on 11. 12. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "FileAttachmentViewController.h"

@implementation FileAttachmentViewController

@synthesize dic_selectedItem, dic_approvaldocinfo, selectedCategory, dic_docattachlistinfo, pdfPath;


#pragma mark -
#pragma mark Communication delegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
    
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
    //	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	//NSLog(@"ConfirmFileViewController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;		
	}
    
	if([rsltCode intValue] == 0){
		//--- success
		NSDictionary *streams2 = (NSDictionary *)[_resultDic valueForKey:@"attachmentinfo"];
		if (streams2) {
            NSString *str_fileName = [streams2 objectForKey:@"attachment_name"];
            //            if ([[streams2 objectForKey:@"attachment_isfile"]isEqualToString:@"1"]) {
                //--- file write
            NSString *base64EncodedString = [streams2 objectForKey:@"attachment_content"];
            NSData	*b64DecData = [Base64 decode:base64EncodedString];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);			
            NSString *documentsDirectory = [paths objectAtIndex:0];			
            self.pdfPath = [documentsDirectory stringByAppendingPathComponent:str_fileName];
            BOOL rslt = [b64DecData writeToFile:self.pdfPath atomically:YES];
            
            //--- file read & display
            NSArray *searchPaths = 
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                NSUserDomainMask, YES); 
            NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
            
            NSString *savedPdfPath = [documentsDirectoryPath stringByAppendingPathComponent:str_fileName];
            
            NSString *savedPath = [savedPdfPath
                                   stringByReplacingOccurrencesOfString:@"localhost/" withString:@""];
            
            NSURL *url = [[NSURL alloc] initFileURLWithPath:savedPath];
            ////			NSURL *url = [[NSBundle mainBundle] URLForResource:str_fileName withExtension:nil];
            ////			NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.pdf" withExtension:nil];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            mWebView.scalesPageToFit = YES;
            [mWebView loadRequest:requestObj];
  
                
//            }else{
//                NSString *attachmentString = [streams2 objectForKey:@"attachment_content"];
//                mWebView.scalesPageToFit = YES;
//                [mWebView loadHTMLString:attachmentString baseURL:nil];//웹뷰에 뿌려줌
//                
//            }
			
			
            
			
		}
		
		//---
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
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


-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
	//--- tmp file delete
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:self.pdfPath error:NULL];
    NSLog(@"%@",[self.navigationController viewControllers]);
    NSLog(@"%@",[self.view subviews]);
    //    self.parentViewController.imageViewHiddenMode;
    NSLog(@"clase : %@",NSStringFromClass([[self parentViewController] class]) );
    //    MailDetailController *detailController = self.parentViewController;
    //    MailSplitViewController *mailSplitViewController
    //    NSLog(@"%@", [self.parentViewController.viewControllers objectAtIndex:1];
    //
    //    NSLog(@"%@", [[self.parentViewController.navigationController viewControllers]objectAtIndex:0]);
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti postNotificationName:@"imagehidden" object:self];
    
    //    MailDetailController *detailController = [[self.navigationController viewControllers]objectAtIndex:0];
    //    MailDetailController *detailController = [[self.parentViewController.navigationController viewControllers]objectAtIndex:1];
    //
    //    //	[detailController imagehidden] ;
    //    detailController.imageViewHiddenMode = YES;
    //    [detailController release];
}


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
	
    //	switch ([self.selectedCategory intValue]) {
    //		case 1: //category 1 결재할 문서
    //			self.title = @"결재할 문서";
    //			break;
    //		case 2: //category 2 결재한 문서
    //			self.title = @"결재한 문서";
    //			break;
    //		case 9:	//category 9 수신문서
    //			self.title = @"수신문서";
    //			break;
    //		case 10: // category 10 부서수신문서
    //			self.title = @"부서수신문서";
    //			break;
    //		case 5:	// category 5 기안한 문서
    //			self.title = @"기안한 문서";
    //			break;
    //		default:
    //			break;
    //	}
    //	
    fileType = YES;
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
    mWebView.delegate = self;
	
    //	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
    //	
    //	
    //	if(self.dic_docattachlistinfo == nil || [self.dic_docattachlistinfo count] <= 0) {
    //		//--- 첨부파일 정보가 없으면 원문보기
    //		//--- 박병주 대리 테스트 pdf
    //		//	NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\PdfFile\\metest0315.xlsx";
    //		//	[loginRequest  setObject:tmpPath forKey:@"filepath"];
    //		[loginRequest  setObject:[self.dic_approvaldocinfo objectForKey:@"href"] forKey:@"filepath"];		
    //		[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
    //		
    //	}
    //	else {
    //        //		NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\AttachFile\\test343453534545★.docx";
    //        //		[loginRequest  setObject:tmpPath forKey:@"filepath"];
    //		[loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"href"] forKey:@"filepath"];		
    //		[loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"docid"] forKey:@"docid"]; 
    //		
    //	}
    //	
    //	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getAprFileDownload];
    //	if(rslt != YES) {
    //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
    //													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    //		
    //		[alert show];
    //		[alert release];
    //		return;
    //	}
    //	
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //	NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.doc" withExtension:nil];
    //	
    //	//			NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test"ofType:@"pdf"];
    //	//			NSURL *url = [NSURL fileURLWithPath:filePath];
    //	
    //	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //	mWebView.scalesPageToFit = YES;
    //	[mWebView loadRequest:requestObj];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
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
    [mWebView release];
	[dic_selectedItem release];
	[dic_approvaldocinfo release];
	[selectedCategory release];
	[dic_docattachlistinfo release];
	[indicator release];
	[cm release];
	[pdfPath release];
    
    [super dealloc];
}

-(void) loadAttachmentMailID:(NSString *)mailID attachmentIndex:(NSString *)index attachmentName:(NSString *)name attachmentIsFile:(NSString *)file{
    
    self.title = name;
    
    cm = [[Communication alloc] init];
	[cm setDelegate:self];
    
	
	NSMutableDictionary *commRequest = [[NSMutableDictionary alloc] init];
	
	if ([file isEqualToString:@"1"]) {
        fileType = YES;
    }else{
        fileType = NO;
    }
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
	
	int rslt = [cm callWithArray:commRequest serviceUrl:getEmailAttachmentInfo];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
	}
    
}
-(void) loadCalendarAttachemnet:(NSString *)attachmentID attachmentName:(NSString *)name{
    self.title = name;
    
    cm = [[Communication alloc] init];
	[cm setDelegate:self];
    
	
	NSMutableDictionary *commRequest = [[NSMutableDictionary alloc] init];
	fileType = YES;
    
    [commRequest setObject:attachmentID forKey:@"attachment_id"];
    
	
	int rslt = [cm callWithArray:commRequest serviceUrl:getAppointmentAttachmentInfo];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
	}
    
}
#pragma mark -
#pragma mark webview delegate



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
	
	indicator.hidden = YES;
	
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [indicator startAnimating];
//    //	[self.view bringSubviewToFront:self.indicator];
//	
//	indicator.hidden = NO;
//	
//}
//
//
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"error : %@", error);
	[indicator stopAnimating];
	
    if (error.code == 204) {//mp4는 에러나도 열림
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"app에서는 지원하지 않습니다. PC에서 이용해 주세요."
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];	
        [alert release];
        
    }
    
}
- (IBAction)btn_cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    //    [self.parentViewController dismissModalViewControllerAnimated:YES];
    
}


@end

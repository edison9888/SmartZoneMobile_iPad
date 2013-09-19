//
//  BoardAttachmentViewController.m
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 9. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "BoardAttachmentViewController.h"

@implementation BoardAttachmentViewController


@synthesize dic_selectedItem, dic_approvaldocinfo, selectedCategory, dic_docattachlistinfo, pdfPath;
@synthesize mWebView;
@synthesize indicator;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Communication delegate

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	//--- indicator setting ---//
	[indicator startAnimating];
}
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
	
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
        
        
        //NSString *escapedUrl = [[_resultDic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSURL *url = [[NSURL alloc] initWithString:escapedUrl];
        NSURL *url = [[NSURL alloc] initWithString:[_resultDic objectForKey:@"url"]];
        
        NSURLRequest *requestObj = [ [NSURLRequest alloc] initWithURL: url ];
        mWebView.scalesPageToFit = YES;
        [mWebView loadRequest:requestObj];
        [url release];
        [requestObj release];
        
        
        
        
//		//--- success
//		NSDictionary *streams2 = (NSDictionary *)[_resultDic valueForKey:@"attachmentinfo"];
//		if (streams2) {
//            NSString *str_fileName = [streams2 objectForKey:@"attachment_name"];
//            
//            if ([[streams2 objectForKey:@"attachment_isfile"]isEqualToString:@"1"]) {
//                //--- file write
//                
//                NSString *base64EncodedString = [streams2 objectForKey:@"attachment_content"];
//                NSData	*b64DecData = [Base64 decode:base64EncodedString];
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);			
//                NSString *documentsDirectory = [paths objectAtIndex:0];			
//                self.pdfPath = [documentsDirectory stringByAppendingPathComponent:str_fileName];
//                BOOL rslt = [b64DecData writeToFile:self.pdfPath atomically:YES];
//                
//                //--- file read & display
//                NSArray *searchPaths = 
//                NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
//                                                    NSUserDomainMask, YES); 
//                NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
//                
//                NSString *savedPdfPath = [documentsDirectoryPath stringByAppendingPathComponent:str_fileName];
//                
//                NSString *savedPath = [savedPdfPath
//                                       stringByReplacingOccurrencesOfString:@"localhost/" withString:@""];
//                
//                NSURL *url = [[NSURL alloc] initFileURLWithPath:savedPath];
//                ////			NSURL *url = [[NSBundle mainBundle] URLForResource:str_fileName withExtension:nil];
//                ////			NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.pdf" withExtension:nil];
//                NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                mWebView.scalesPageToFit = YES;
//                [mWebView loadRequest:requestObj];
//                
//                
//            }else{
//                NSString *attachmentString = [streams2 objectForKey:@"attachment_content"];
//                mWebView.scalesPageToFit = YES;
//                [mWebView loadHTMLString:attachmentString baseURL:nil];//웹뷰에 뿌려줌
//                
//            }
//			
//			
//            
//			
//		}
//		
//		//---
		
	}
	else {
        [indicator stopAnimating];
        indicator.hidden = YES;

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[resultDic objectForKey:@"errdesc"]
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
    indicator.hidden = YES;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert",@"알림") message:NSLocalizedString(@"Failed_network_connection",@"네트워크 접속에 실패하였습니다")
//												   delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"ok") otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
//
//    return;
}


-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
//	//--- tmp file delete
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	[fileManager removeItemAtPath:self.pdfPath error:NULL];
	
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
	cm = [[Communication alloc] init];
	[cm setDelegate:self];
    
	
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
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(void) boardAttachemntlink:(NSString *)url attachmentTitle:(NSString *)attachTitle{
    
    self.title = attachTitle;

//    NSString *tempUrl = url;
//    NSURLRequest *requestObj = [ [NSURLRequest alloc] initWithURL: [NSURL URLWithString:tempUrl] ];
//   mWebView.scalesPageToFit = YES;
//    [mWebView loadRequest:requestObj];

    
    
    
    
    //Communication *
	cm = [[Communication alloc] init];
	cm.delegate = self;
	// make request dictionary
	NSMutableDictionary *requestDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	//[requestDictionary setObject:@"KT" forKey:@"userid"];
    [requestDictionary setObject:attachTitle forKey:@"title"];
	[requestDictionary setObject:url forKey:@"url"];
	// call communicate method
	BOOL result = [cm callWithArray:requestDictionary serviceUrl:getBoardDetailAttachedFileURL];
	
	if (!result) {
		// error occurred
		
	}

    


}
#pragma mark -
#pragma mark WebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//{
////	NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authed);
//	
////    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
//	return NO;
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
//{
//	NSLog(@"got auth challange");
//	
//	if ([challenge previousFailureCount] == 0) {
////		_authed = YES;
//		/* SET YOUR credentials, i'm just hard coding them in, tweak as necessary */
//		[[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"201091075" password:@"ruddnr5402!" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
//	} else {
//		[[challenge sender] cancelAuthenticationChallenge:challenge]; 
//	}
//}
//
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
	
	indicator.hidden = YES;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [indicator startAnimating];
    //	[self.view bringSubviewToFront:self.indicator];
	
	indicator.hidden = NO;
	
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"error : %@", error);
	[indicator stopAnimating];
	indicator.hidden = YES;
    
    if (error.code == 204) {//mp4는 에러나도 열림
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"app에서는 지원하지 않습니다. PC에서 이용해 주세요."
                                                       delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];	
        [alert release];
  
    }
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];

}

- (IBAction)btn_cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end


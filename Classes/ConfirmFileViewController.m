//
//  ConfirmFileViewController.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmFileViewController.h"


@implementation ConfirmFileViewController
@synthesize dic_selectedItem, dic_approvaldocinfo, selectedCategory, dic_docattachlistinfo, pdfPath;
@synthesize toolbar;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)action_backButton {
	[self dismissModalViewControllerAnimated:YES];
}
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
	
//	//NSLog(@"ConfirmFileViewController result : %@", resultDic);
	
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
//		NSDictionary *streams2 = (NSDictionary *)[_resultDic valueForKey:@"approvalfiledownloadinfo"];
        NSString *streams2 = (NSString *)[_resultDic valueForKey:@"url"];

		if (streams2) {
//			//--- file write
//			NSString *str_fileName = [streams2 objectForKey:@"filename"];
//			
//			NSString *base64EncodedString = [streams2 objectForKey:@"filedata"];
//			NSData	*b64DecData = [Base64 decode:base64EncodedString];
//			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);			
//			NSString *documentsDirectory = [paths objectAtIndex:0];			
//			self.pdfPath = [documentsDirectory stringByAppendingPathComponent:str_fileName];
//			BOOL rslt = [b64DecData writeToFile:self.pdfPath atomically:YES];
//			rslt = nil;
//
//			//--- file read & display
//			NSArray *searchPaths = 
//			NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
//												NSUserDomainMask, YES); 
//			NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
//			
//			NSString *savedPdfPath = [documentsDirectoryPath stringByAppendingPathComponent:str_fileName];
//			
//			NSString *savedPath = [savedPdfPath
//							  stringByReplacingOccurrencesOfString:@"localhost/" withString:@""];
//			
//			NSURL *url = [[NSURL alloc] initFileURLWithPath:savedPath];
////			NSURL *url = [[NSBundle mainBundle] URLForResource:str_fileName withExtension:nil];
////			NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.pdf" withExtension:nil];
            NSURL *url = [[NSURL alloc] initWithString:streams2];

			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			mWebView.scalesPageToFit = YES;
			[mWebView loadRequest:requestObj];
			
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
}


-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
	//--- tmp file delete
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:self.pdfPath error:NULL];
	
	
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

	
	switch ([self.selectedCategory intValue]) {
		case 1: //category 1 결재할 문서
			self.title = @"결재할 문서";
			break;
		case 2: //category 2 결재한 문서
			self.title = @"결재한 문서";
			break;
		case 9:	//category 9 수신문서
			self.title = @"수신문서";
			break;
		case 10: // category 10 부서수신문서
			self.title = @"부서수신문서";
			break;
		case 5:	// category 5 기안한 문서
			self.title = @"기안한 문서";
			break;
		default:
			break;
	}
	

	cm = [[Communication alloc] init];
	[cm setDelegate:self];

	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	
	
	if(self.dic_docattachlistinfo == nil || [self.dic_docattachlistinfo count] <= 0) {
		//--- 첨부파일 정보가 없으면 원문보기
		//--- 박병주 대리 테스트 pdf
		//	NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\PdfFile\\metest0315.xlsx";
		//	[loginRequest  setObject:tmpPath forKey:@"filepath"];
//		[loginRequest  setObject:[self.dic_approvaldocinfo objectForKey:@"href"] forKey:@"filepath"];		
//		[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
        [loginRequest setObject:self.selectedCategory forKey:@"category"];  
        
		[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
        [loginRequest  setObject:[self.dic_approvaldocinfo objectForKey:@"filepath"] forKey:@"filepath"];	
        [loginRequest  setObject:[self.dic_approvaldocinfo objectForKey:@"filename"] forKey:@"filename"];	
        //        [loginRequest  setObject:[self.dic_selectedItem objectForKey:@"functiontype"] forKey:@"aprstate"];
        
        if ([self.dic_selectedItem objectForKey:@"functiontype"]) {
            [loginRequest  setObject:[self.dic_selectedItem objectForKey:@"functiontype"] forKey:@"aprstate"];
        }else{
            [loginRequest  setObject:@"002" forKey:@"aprstate"];
        }

		
	}
	else {
//		NSString *tmpPath = @"\\\\testoasysdb\\Mobile\\AttachFile\\test343453534545★.docx";
//		[loginRequest  setObject:tmpPath forKey:@"filepath"];
//		[loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"href"] forKey:@"filepath"];		
//		[loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"docid"] forKey:@"docid"]; 
        [loginRequest setObject:self.selectedCategory forKey:@"category"];
        
        [loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"docid"] forKey:@"docid"]; 
        [loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"filepath"] forKey:@"filepath"];	
        [loginRequest  setObject:[self.dic_docattachlistinfo objectForKey:@"filename"] forKey:@"filename"];	
        if ([self.dic_selectedItem objectForKey:@"functiontype"]) {
            [loginRequest  setObject:[self.dic_selectedItem objectForKey:@"functiontype"] forKey:@"aprstate"];
        }else{
            [loginRequest  setObject:@"002" forKey:@"aprstate"];
        }
        
		
	}
	
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getAprFileDownload];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
	}
	
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
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
//    [mWebView release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [mWebView release];
}


@end

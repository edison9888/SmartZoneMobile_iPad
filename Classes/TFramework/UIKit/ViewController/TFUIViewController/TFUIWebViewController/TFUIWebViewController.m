//
//  TFUIWebViewController.m
//  SearcherTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "TFUIWebViewController.h"


@implementation TFUIWebViewController

#pragma mark -
#pragma mark UIWebViewDelegate Method 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	
	switch (navigationType) {
		case UIWebViewNavigationTypeLinkClicked: {
			NSLog(@"UIWebViewNavigationTypeLinkClicked!!!!");
		}	break;
		case UIWebViewNavigationTypeFormSubmitted: {
			NSLog(@"UIWebViewNavigationTypeFormSubmitted!!!!");
		}	break;
		case UIWebViewNavigationTypeOther: {
			NSLog(@"UIWebViewNavigationTypeOther!!!!");
		}	break;
		default: {
			NSLog(@"UIWebViewNavigationTypeUnknown!!!!");
		}	break;
	}
	
	// javascript bridge로부터 call (또는 callback)
	if (navigationType == UIWebViewNavigationTypeOther && [request.URL.scheme isEqualToString:@"jsFrame"]) {
		
		NSString *strParam = [request.URL.resourceSpecifier stringByReplacingOccurrencesOfString:@"//" withString:@""];
		strParam = [strParam stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSDictionary *dicJSFrameReturn = [strParam JSONValue];
		
		NSString *strCallbackSelector = [dicJSFrameReturn objectForKey:@"callback"];
		
		// callback인 경우(native(call) -> js(처리, 리턴) -> native)
		if (strCallbackSelector != nil && ![strCallbackSelector isEqualToString:@"NO"]) {
			[self performSelector:NSSelectorFromString(strCallbackSelector) withObject:[dicJSFrameReturn objectForKey:@"returnValue"]];
		}
		
	}
	
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
}

- (void)callJSFunctionWithJSFunctionName:(NSString *)jsFunctionName CallBackSelector:(SEL)aCallBackSelector Arguments:(NSString *)first, ... {
	
	NSMutableArray *arrArgs = [[NSMutableArray alloc] init];
	
	va_list args;
	va_start(args, first);
	if (first != nil) {
		[arrArgs addObject:first];
	
		NSString *listItem = va_arg(args, NSString *);          // 다음 파라미터값
		while(listItem)	{
			
			[arrArgs addObject:listItem];
			listItem = va_arg(args, NSString *);                 // nil일때까지 반복
		}
		
	}
	
	va_end(args);
	
	NSMutableDictionary *jsonData = nil;
	if (aCallBackSelector) {
		jsonData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					NSStringFromSelector(aCallBackSelector), @"callback", 
					nil];

	} else {
		jsonData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					@"NO", @"callback", 
					nil];
	}
	
	if ([arrArgs count]) {
		[jsonData setObject:arrArgs forKey:@"args"];
	}
	
	[arrArgs release];
	arrArgs = nil;
	
	SBJSON *json = nil;
	json = [[SBJSON alloc] init];
	
	NSString *retJSONString = [json stringWithObject:jsonData allowScalar:YES error:nil];
	
	[json release];
	json = nil;
	
	[jsonData release];
	jsonData = nil;
	
	NSString *str = [NSString stringWithFormat:@"NativeBridge.callJSFunctionFromNative(%@, %@)", 
					 jsFunctionName, retJSONString];
	
	[uiWebView1 performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:str];
	
}

#pragma mark -
#pragma mark View Translation

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSString *strPath = [[NSBundle mainBundle] bundlePath];
	//	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	strPath = [NSString stringWithFormat:@"%@%@", strPath, wwwPath];
	
	//	NSArray *arr = [fileManager contentsOfDirectoryAtPath:strPath error:NULL];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:strPath]];
	[uiWebView1 loadRequest:request];
	
}

#pragma mark -
#pragma mark XCode Generated

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
	
	for (UIView *uiView in self.view.subviews) {
		if ([uiView isKindOfClass:[UIWebView class]]) {
			uiWebView1 = (UIWebView *)uiView;
			uiWebView1.delegate = self;
			break;
		}
	}
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
    [super dealloc];
}


@end

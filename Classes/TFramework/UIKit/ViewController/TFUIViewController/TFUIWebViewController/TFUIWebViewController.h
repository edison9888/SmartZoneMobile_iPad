//
//  TFUIWebViewController.h
//  SearcherTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 1. 27..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "JSON.h"

@interface TFUIWebViewController : TFUIViewController <UIWebViewDelegate> {
	UIWebView *uiWebView1;
	
	NSString *wwwPath;
}

- (void)callJSFunctionWithJSFunctionName:(NSString *)jsFunctionName 
						CallBackSelector:(SEL)aCallBackSelector 
							   Arguments:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;

@end

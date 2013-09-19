//
//  ConfirmFileViewController.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"
#import "Base64.h"


@interface ConfirmFileViewController : UIViewController<UIAlertViewDelegate> {
	IBOutlet UIWebView *mWebView;
	NSDictionary *dic_selectedItem;
	NSDictionary *dic_approvaldocinfo;
	NSString *selectedCategory;
	
	NSMutableDictionary *dic_docattachlistinfo;
	
	UIActivityIndicatorView *indicator;
	
	Communication *cm;
	
	NSString *pdfPath;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) NSDictionary *dic_selectedItem;
@property (nonatomic, retain) NSDictionary *dic_approvaldocinfo;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) NSMutableDictionary *dic_docattachlistinfo;
@property (nonatomic, retain) NSString *pdfPath;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

-(IBAction)action_backButton;

@end

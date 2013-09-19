//
//  FileAttachmentViewController.h
//  MobileKate2.0_iPad
//
//  Created by Baek Kyung Wook on 11. 12. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"
#import "Base64.h"

@interface FileAttachmentViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *mWebView;
	NSDictionary *dic_selectedItem;
	NSDictionary *dic_approvaldocinfo;
	NSString *selectedCategory;
	NSMutableDictionary *dic_docattachlistinfo;
	UIActivityIndicatorView *indicator;
	Communication *cm;
	NSString *pdfPath;
    BOOL fileType;
}

@property (nonatomic, retain) NSDictionary *dic_selectedItem;
@property (nonatomic, retain) NSDictionary *dic_approvaldocinfo;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) NSMutableDictionary *dic_docattachlistinfo;
@property (nonatomic, retain) NSString *pdfPath;
-(void) loadAttachmentMailID:(NSString *)mailID attachmentIndex:(NSString *)index attachmentName:(NSString *)name attachmentIsFile:(NSString *)file;
-(void) loadCalendarAttachemnet:(NSString *)attachmentID attachmentName:(NSString *)name;
@end


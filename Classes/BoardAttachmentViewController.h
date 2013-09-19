//
//  BoardAttachmentViewController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 9. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"
#import "Base64.h"

@interface BoardAttachmentViewController : UIViewController<UIWebViewDelegate, CommunicationDelegate, UIAlertViewDelegate>{
    UIWebView *mWebView;
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
@property (nonatomic, retain) IBOutlet UIWebView *mWebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
-(void) boardAttachemntlink:(NSString *)url attachmentTitle:(NSString *)attachTitle;
- (IBAction)btn_cancel:(id)sender;

@end


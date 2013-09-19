//
//  BoardDetailContentController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Communication.h"
#import "ContactModel.h"
@interface BoardDetailContentController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, CommunicationDelegate> {
	
	UIWebView *contentWebView;	
	UITableView *contentTableView;
	
	NSDictionary *contentDictionary;
	
	UITableViewCell *mainContentCell;
	UITableViewCell *titleCell;
	UITableViewCell *nameCell;
    ContactModel *contactModel;	

	Communication *clipboard;
	UIActivityIndicatorView *indicator;
	
	CGFloat webViewHeight;
	int webviewLoadFlag; // 0 = make table load, 1 = start load
	NSURL *webopen;
    NSMutableArray *attachmentArray;

}

@property(nonatomic,retain) IBOutlet UIWebView *contentWebView;
@property(nonatomic,retain) IBOutlet UITableView *contentTableView;

@property(nonatomic,retain) NSDictionary *contentDictionary;

@property(nonatomic,retain) IBOutlet UITableViewCell *mainContentCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *titleCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *nameCell;

@property(nonatomic,retain) Communication *clipboard;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

@property(nonatomic,assign) CGFloat webViewHeight;
@property(nonatomic,assign) int webviewLoadFlag;
@property(nonatomic,retain) NSURL *webopen;
@property(nonatomic,retain) NSMutableArray *attachmentArray;


-(void) loadDetailContentAtIndex:(NSString *)index forCategory:(NSString *)category;

@end

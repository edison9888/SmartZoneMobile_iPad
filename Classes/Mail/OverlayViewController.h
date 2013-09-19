//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import <UIKit/UIKit.h>

@class MailListController;

@interface OverlayViewController : UIViewController {

	MailListController *rvController;
}

@property (nonatomic, retain) MailListController *rvController;

@end

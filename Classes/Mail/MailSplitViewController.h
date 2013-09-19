//
//  MailSplitViewController.h
//  MobileKate2.0_iPad
//
//  Created by Baek Kyung Wook on 11. 10. 20..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MailListController;
@class MailDetailController;
@class MailDetailRoot;
@interface MailSplitViewController : UISplitViewController {
    MailListController *rootView;
	MailDetailController *detailView;

}

@property (nonatomic, retain) MailListController *rootView;
@property (nonatomic, retain) MailDetailController *detailView;
@end


//
//  FAQSplitViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAQRootViewController;
@class FAQDetailViewController;

@interface FAQSplitViewController : UISplitViewController {

	FAQRootViewController *rootView;
	FAQDetailViewController *detailView;
	
}
@property (nonatomic, retain) FAQRootViewController *rootView;
@property (nonatomic, retain) FAQDetailViewController *detailView;

@end

//
//  QnASplitViewController.h
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QnARootViewController;
@class QnADetailViewController;

@interface QnASplitViewController : UISplitViewController {
	QnARootViewController *rootView;
	QnADetailViewController *detailView;
	
}

@property (nonatomic, retain) QnADetailViewController *detailView;

@end

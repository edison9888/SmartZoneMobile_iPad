//
//  PaymentSplitViewController.h
//  MobileKate2.0_iPad
//
//  Created by 김일호 on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentController.h"
#import "ConfirmController.h"


@interface PaymentSplitViewController : UISplitViewController {
    PaymentController *rootView;
	ConfirmController *detailView;
}

@property (nonatomic, retain) PaymentController *rootView;
@property (nonatomic, retain) ConfirmController *detailView;

@end


//
//  PaymentController.h
//  MobileKate2.0_iPad
//
//  Created by 김일호 on 11. 2. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentListController.h"
#import "Communication.h"
#import "URL_Define.h"


@interface PaymentController : UIViewController {
	PaymentListController *payList;
	NSUserDefaults *userDefault;
	
	UITableView *currentTableView;
	
	NSMutableDictionary *listCountDic;
	NSMutableDictionary *listUnreadCountDic;
	

	
	UILabel *label1;
	UILabel *label2;
	UILabel *label3;
	UILabel *label4;
	UILabel *label5;
	UILabel *testLabel;
	
	BOOL flag_reload;
	
	IBOutlet UIActivityIndicatorView *indicator;
	
	Communication *cm;
}

-(void)tr_data;

@property (nonatomic, retain) PaymentListController *payList;
@property (nonatomic, retain) IBOutlet UITableView *currentTableView;
@property (nonatomic, retain) NSUserDefaults *userDefault;
@property (nonatomic, retain) NSMutableDictionary *listCountDic;
@property (nonatomic, retain) NSMutableDictionary *listUnreadCountDic;
@property (nonatomic) BOOL flag_reload;


@end

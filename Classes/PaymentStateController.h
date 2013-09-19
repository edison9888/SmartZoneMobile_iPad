//
//  PaymentStateController.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import	"URL_Define.h"


@interface PaymentStateController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *currentTableView;
	
	NSDictionary *dic_selectedItem;
	NSDictionary *dic_approvalLineHeaderInfo;
	NSArray *arr_approvalLineListInfo;
	
	NSString *selectedCategory;
	
	UIActivityIndicatorView *indicator;
	
	Communication *cm;
	

}

-(IBAction)backButtonPressed;

@property (nonatomic, retain) NSDictionary *dic_selectedItem;
@property (nonatomic, retain) NSDictionary *dic_approvalLineHeaderInfo;
@property (nonatomic, retain) NSArray *arr_approvalLineListInfo;
@property (nonatomic, retain) NSString *selectedCategory;


@end

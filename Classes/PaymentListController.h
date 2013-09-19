//
//  PaymentListController.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmController.h"
#import "Communication.h"
#import "URL_Define.h"


#define num_pageSize 20



@interface PaymentListController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	ConfirmController *confirmController;
	
	NSUserDefaults *userDefault;
	NSString *selectedCategory;	
	NSMutableArray *arr_docListInfo;
	
	UITableView *currentTableView;
	UIActivityIndicatorView *indicator;
	
	IBOutlet UITableViewCell *nextCell;
	IBOutlet UIButton *nextCellButton;
	int num_pageNum;
	
	int result_totalCount;
	int result_totalPage;
	
	BOOL mode_nextCell;
	
	Communication *cm;
	
	NSMutableDictionary *dic_flag_readded;
	
}

-(void)listComm;
-(IBAction)action_nextCell:(id)sender;

@property (nonatomic, retain) ConfirmController *confirmController;
@property (nonatomic, retain) NSUserDefaults *userDefault;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) NSMutableArray *arr_docListInfo;
@property (nonatomic, retain) IBOutlet UITableView *currentTableView;
@property (nonatomic) int	num_pageNum;
@property (nonatomic) int	result_totalCount;
@property (nonatomic) int	result_totalPage;
@property (nonatomic) BOOL mode_nextCell;


@end

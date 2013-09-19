//
//  OpinionViewController.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"

@interface OpinionViewController : UIViewController<UITableViewDelegate, UIAlertViewDelegate> {
	
	NSDictionary *dic_selectedItem;
	
	NSArray *arr_approvalopinioninfo;
	
	IBOutlet UITableViewCell *noDataCell;
	
	NSString *selectedCategory;
	
	UIActivityIndicatorView *indicator;
	
	Communication *cm;
	
	IBOutlet UITableView *currentTableView; 
	
	NSMutableArray *arr_size;
	CGSize newSize;

	


}

-(IBAction)cancelButton;

@property (nonatomic, retain) NSDictionary *dic_selectedItem;
@property (nonatomic, retain) NSArray *arr_approvalopinioninfo;
@property (nonatomic, retain) NSString *selectedCategory;

@end

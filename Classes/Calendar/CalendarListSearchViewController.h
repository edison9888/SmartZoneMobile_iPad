//
//  CalendarListSearchViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"


@interface CalendarListSearchViewController : TFUIViewController {
	//UI
	UITableView *tableView1;
	UISearchBar *searchBar1;
	
	// data
	NSMutableDictionary *datasource;
	NSArray *datasourceAllKeys;
	
    int todayInSection;
    
    
    CalendarModel *model;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar1;

@property (nonatomic, assign) int todayInSection;


- (void)searchSchedule:(NSString *)keyWord;

@end

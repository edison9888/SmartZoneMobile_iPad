//
//  CalendarScheduleReadViewController.h
//  TFTest
//
//  Created by 승철 강 on 11. 6. 26..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "CalendarModel.h"
#import "TITokenFieldView.h"
#import "Communication.h"

@interface CalendarScheduleReadViewController : TFUIViewController<CommunicationDelegate> {
	
	// UI
	UITableView *tableView1;
	
	// data
    Communication *clipboard; 

	CalendarModel *model;
	
	NSMutableArray *cellTypes;
    UIActivityIndicatorView *indicator; //인디케이터
    NSMutableArray *attachmentFileArray;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;
@property(nonatomic,retain) NSMutableArray *attachmentFileArray;

-(void) loadDetail:(NSString *)aptID;
@end

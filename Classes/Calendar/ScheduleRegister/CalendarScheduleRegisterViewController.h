//
//  CalendarScheduleRegisterViewController.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 6. 14..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIViewController.h"
#import "Communication.h"
#import "CalendarModel.h"
#import "ContactModel.h"

@interface CalendarScheduleRegisterViewController : TFUIViewController <CommunicationDelegate> {

	// UI
	UITableView *tableView1;

	// data
	CalendarModel *model;
	ContactModel *contactModel;	
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@end

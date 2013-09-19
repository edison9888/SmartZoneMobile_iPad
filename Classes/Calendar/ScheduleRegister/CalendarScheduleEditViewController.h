//
//  CalendarScheduleEditViewController.h
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

#define UPDATE_DATA 1
#define DELETE_DATA 2

@interface CalendarScheduleEditViewController : TFUIViewController <CommunicationDelegate, UIActionSheetDelegate> {

	// UI
	UITableView *tableView1;

    UIButton *deleteButton;
    UILabel *deleteButtonLabel;
    
	// data
	CalendarModel *model;
	ContactModel *contactModel;	
    
    NSDictionary *noticeTimeList;
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    int communication_flag;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UILabel *deleteButtonLabel;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, assign) int communication_flag;

-(IBAction) deleteButtonClicked;

@end

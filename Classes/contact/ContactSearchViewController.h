//
//  ContactSearchViewController.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 14..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFUIScrollViewController.h"
#import "Communication.h"

@interface ContactSearchViewController : TFUIScrollViewController<CommunicationDelegate> {
    
    IBOutlet UIBarButtonItem *searchButton;
    
    UITextField *name;
	UITextField *department;
	UITextField *jobtitle;
	UITextField *chargedwork;
	UITextField *homephone;
	UITextField *mobilephone;
	UITextField *companyname;
    
    
    UILabel *nameStr;
	UILabel *departmentStr;
	UILabel *jobtitleStr;
	UILabel *chargedworkStr;
	UILabel *homephoneStr;
	UILabel *mobilephoneStr;
	UILabel *companynameStr;
    
    
    UIButton *button;
    
    BOOL checkParamAlert;
    
    
    NSMutableArray *companyList;
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
}
@property(nonatomic,retain) IBOutlet UIBarButtonItem *searchButton;

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *department;
@property (nonatomic, retain) IBOutlet UITextField *jobtitle;
@property (nonatomic, retain) IBOutlet UITextField *chargedwork;
@property (nonatomic, retain) IBOutlet UITextField *homephone;
@property (nonatomic, retain) IBOutlet UITextField *mobilephone;
@property (nonatomic, retain) IBOutlet UITextField *companyname;

@property (nonatomic, retain) IBOutlet UIButton *button;

@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, retain) IBOutlet UILabel *nameStr;
@property (nonatomic, retain) IBOutlet UILabel *departmentStr;
@property (nonatomic, retain) IBOutlet UILabel *jobtitleStr;
@property (nonatomic, retain) IBOutlet UILabel *chargedworkStr;
@property (nonatomic, retain) IBOutlet UILabel *homephoneStr;
@property (nonatomic, retain) IBOutlet UILabel *mobilephoneStr;
@property (nonatomic, retain) IBOutlet UILabel *companynameStr;

-(IBAction) searchButtonClicked;

@end

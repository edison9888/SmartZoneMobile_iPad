//
//  ContactDetailViewController.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 15..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "ContactModel.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "TFUIViewController.h"

#define LOAD_DATA 1
#define SAVE_DATA 2
#define CALL_CONTACT 3

@interface ContactDetailViewController : TFUIViewController <CommunicationDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    
    // UI
    UITableView *dataTable;
    
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    
    
    // handling
    NSMutableDictionary *param;
    NSString *callTypeStr;
    NSMutableDictionary *responseData; //주소록 상세정보.
    NSMutableArray      *phoneArr; //actionsheet 용.
    
    // data
	ContactModel *model; //연락처 메인 인스턴스 모델
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    int communication_flag;
    
}
@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;

@property (nonatomic, retain) NSMutableDictionary *param;
@property (nonatomic, retain) NSString *callTypeStr;
@property (nonatomic, retain) NSMutableDictionary *responseData;
@property (nonatomic, retain) NSMutableArray *phoneArr;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

@property (nonatomic, assign) int communication_flag;

-(IBAction) buttonClicked:(id)sender;
-(void)loadDetail:(NSMutableDictionary *)dic forCallType:(NSString *)callType;
-(void)showActionSheet;
-(void)saveMyContact;
-(void)saveMyContactResult:(BOOL)result;

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

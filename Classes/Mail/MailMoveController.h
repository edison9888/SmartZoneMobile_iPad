//
//  MailMoveController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 9. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"

@interface MailMoveController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *currentTableView;
	UIActivityIndicatorView *indicator;
	Communication *cm;
	NSMutableArray *menuList;
    UILabel * titleLabel;
    UILabel * nameLabel;
	NSString *selectedMailID;
    UILabel * moveInfo;
    NSString *folderID;
    BOOL moveAction;

}
-(void)tr_data;
-(IBAction)refresh;
-(IBAction) writeButtonClicked;

@property (nonatomic, retain) IBOutlet UITableView *currentTableView;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) NSString *selectedMailID;
@property (nonatomic, retain) IBOutlet UILabel * titleLabel;
@property (nonatomic, retain) IBOutlet UILabel * nameLabel;
@property (nonatomic, retain) IBOutlet UILabel * moveInfo;
@property (nonatomic, retain)	NSString *folderID;

-(void) selectedMailID:(NSString *)mailID mailCount:(NSString *)index folderID:(NSString *)folder_id mailName:(NSString *)mail_name mailTitle:(NSString *)mail_title;
@end



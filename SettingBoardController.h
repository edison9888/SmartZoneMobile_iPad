//
//  SettingBoardController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface SettingBoardController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *beforeProcessBoardList ;
    NSMutableArray *afterProcessBoardList ;
    UITableView *menulist;
    UIActivityIndicatorView *indicator;
	Communication *cm;

}

@property (nonatomic, retain)NSMutableArray *beforeProcessBoardList;
@property (nonatomic, retain)NSMutableArray *afterProcessBoardList;
@property (nonatomic, retain)IBOutlet   UITableView *menulist;
- (NSUInteger) rowTagForIndexPath: (NSIndexPath*) indexPath;
- (NSUInteger) rowStateForIndexPath: (NSIndexPath*) indexPath;
- (void) actionFlipRowState: (id) sender;
- (IBAction)comm:(id)sender;
@end

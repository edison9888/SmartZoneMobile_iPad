//
//  BoardController.h
//  MobileOffice2.0
//
//  Created by Baek Kyung Wook on 11. 8. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

@interface BoardController : UIViewController<CommunicationDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITableView *menulist;
	NSMutableArray *afterProcessBoardList;
	UIActivityIndicatorView *indicator;
	Communication *clipboard;

}
@property (nonatomic, retain) IBOutlet UITableView *menulist;
@property (nonatomic, retain) NSMutableArray *afterProcessBoardList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;

-(void) tr_data;
-(void) saveProcess: (NSMutableArray *)commArray;
@end





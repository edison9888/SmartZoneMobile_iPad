//
//  NoticeSplitViewController.h
//  MKate_iPad
//
//  Created by park on 11. 2. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardController.h"

@class BoardRootViewController;
@class BoardDetailViewController;

@interface BoardSplitViewController : UISplitViewController {
	BoardController *rootView;
	BoardDetailViewController *detailView;
}

@property (nonatomic, retain) BoardDetailViewController *detailView;
@property (nonatomic, retain) BoardController *rootView;

@end

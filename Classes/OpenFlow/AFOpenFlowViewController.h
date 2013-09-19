//
//  AFOpenFlowViewController.h
//  Smc
//
//  Created by SangMin Wang on 10. 4. 20..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import "MainMenuController.h"


@interface AFOpenFlowViewController : UIViewController <AFOpenFlowViewDelegate> {
	NSArray *coverImageData;
	NSDictionary *interestingPhotosDictionary;
	NSOperationQueue *loadImagesOperationQueue;
	UILabel *label ;
    UILabel *monthLabel;
    UILabel *dateLabel;
	UIButton *button;
	NSNotificationCenter *noti;

}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UILabel *monthLabel;
@property (nonatomic, retain) UILabel *dateLabel;

- (void)imageDidLoad:(NSArray *)arguments;

- (void)setSelectedCover:(int)newSelectedCover ;
- (void) coverViewMoveRight;
- (void) coverViewMoveLeft ;
//- (int ) getSelectCoverViewIndex ;
- (void) setDelegate:(id)sender ;


@end

//
//  StypePickerController.h
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 3. 9..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StypePickerDelegate
- (void)stypePickerSelected:(NSString *)stype;
@end


@interface StypePickerController : UITableViewController {
    NSMutableArray *_stypelist;
    id<StypePickerDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *stypelist;
@property (nonatomic, assign) id<StypePickerDelegate> delegate;

@end

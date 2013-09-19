//
//  FAQCategoryViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 7. 6..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FAQCategoryViewControllerDelegate
- (void)categorySelected:(NSString *)category categoryID:(NSString *)categoryCome;
@end

@interface FAQCategoryViewController : UITableViewController {
    NSMutableArray *categoryList;
    id<FAQCategoryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *categoryList;
@property (nonatomic, assign) id<FAQCategoryViewControllerDelegate> delegate;

@end

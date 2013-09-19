//
//  CustomCellTextView.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 7. 7..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellTextView : UITableViewCell {
	UITextView *customTextView;
	UIScrollView *customScrollView;
	
}
@property (nonatomic, retain) IBOutlet UITextView *customTextView;
@property (nonatomic, retain) IBOutlet UIScrollView *customScrollView;



@end

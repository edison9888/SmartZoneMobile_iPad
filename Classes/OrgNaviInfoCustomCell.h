//
//  MainListCustomCell.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 7. 4..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrgNaviInfoCustomCell : UITableViewCell {
	UIImageView *iconImageView;
	UILabel *iconTitleLabel;
	UILabel *subLabel;
	UILabel *orgLabel;
	UIView *backgroundCustomView;
}

@property (nonatomic, retain)IBOutlet 	UIImageView *iconImageView;
@property (nonatomic, retain)IBOutlet	UILabel *iconTitleLabel;
@property (nonatomic, retain)IBOutlet UILabel *subLabel;
@property (nonatomic, retain)IBOutlet UILabel *orgLabel;
@property (nonatomic, retain)IBOutlet UIView *backgroundCustomView;

@end

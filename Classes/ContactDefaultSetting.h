//
//  ContactDefaultSetting.h
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 6. 29..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactDefaultSetting : UITableViewController {
	NSArray *sectionArray;
	NSArray *sectionTitleArray;
	
	NSMutableArray *menuList;

}
@property(nonatomic,retain) NSArray *sectionArray;
@property(nonatomic,retain) NSArray *sectionTitleArray;

@property (nonatomic, retain) NSMutableArray *menuList;

@end

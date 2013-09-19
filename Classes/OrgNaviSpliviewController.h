//
//  OrgNavieSpliviewController.h
//  MobileKate2.0_iPad
//
//  Created by Kyung Wook Baek on 11. 7. 5..
//  Copyright 2011 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrgNaviInfo;
@class OrgNaviDetailView;

@interface OrgNaviSpliviewController : UISplitViewController {
	OrgNaviInfo *rootViewNavi;
	OrgNaviDetailView *detailViewNavi;

}
@property (nonatomic, retain) OrgNaviInfo *rootViewNavi;
@property (nonatomic, retain) OrgNaviDetailView *detailViewNavi;

@end

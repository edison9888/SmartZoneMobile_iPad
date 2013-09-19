//
//  TFUINavigationBar.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 15..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TFUINavigationBar : UINavigationBar {
	BOOL isHomeLogo;		// 홈인 경우 홈 특유의 이미지를 뿌리게 한다.
	UILabel *titleLabel;	// 타이틀 라벨
}

@property BOOL isHomeLogo;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;	// 타이틀 라벨

@end

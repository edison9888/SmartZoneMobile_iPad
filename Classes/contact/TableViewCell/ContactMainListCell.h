//
//  ContactMainListCell.m
//  TFTest
//
//  Created by 재영 장 on 11. 6. 16..
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactMainListCell : UITableViewCell {
	
    UILabel *label1;	// 이름, 부서
    UILabel *label2;    // 팀
    UILabel *label3;    // 전화번호 (회사명)
    UILabel *label4;    // 전화번호 (폰북전용)
    
}

@property (nonatomic, retain) IBOutlet UILabel *label1;	// 이름, 부서
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;

@end

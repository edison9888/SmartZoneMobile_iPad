//
//  SettingPushController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"

@interface SettingPushController : UIViewController<CommunicationDelegate> {
	
	UISwitch *paymentSwitch;
	UISwitch *candySwitch;
	
	Communication *cm;
	UIActivityIndicatorView *indicator;
}

@property(nonatomic,retain) IBOutlet UISwitch *paymentSwitch;
@property(nonatomic,retain) IBOutlet UISwitch *candySwitch;


-(IBAction)paymentSwitchChanged:(id)sender;
-(IBAction)candySwitchChanged:(id)sender;

-(void)sendPushSettingCommunication:(NSString *)type Flag:(BOOL)yesno;

@end
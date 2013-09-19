//
//  NekoWindow.h
//  TFTest
//
//  Created by 이재호 on 10. 4. 26..
//	Modified by 닷넷나무에 사과열리다 on 11. 5. 26..
//  Copyright 2011 이재호. All rights reserved.
//	

#import "NekoWindow.h"


@implementation NekoWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {	
	
	#ifdef TEST_APPLICATION
//	UITabBarController *tabBarController = [(UITabBarController *)[[UIApplication sharedApplication] delegate] tabBarController];
	
	UITabBarController *tabBarController = (UITabBarController *)self.rootViewController;
	
	NSMutableString *tree=[[NSMutableString alloc] initWithString:@""];

	if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
		// Make stack
		for (UIView* uiView in [(UINavigationController*)tabBarController.selectedViewController viewControllers]) {
			[tree setString:[NSString stringWithFormat:@"%@%@\n", tree, [uiView description]]];
		}
		NSLog(@">>CurrentViewController Stack>>\n%@", tree);
	}
	
	UIAlertView* hierachyAlert = [[UIAlertView alloc] initWithTitle:@"ObjectTree" message:tree delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[hierachyAlert show];
	[hierachyAlert release];
	NSLog(@"--------------------------");
	[tree release];
	tree = nil;
	#endif
    
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:TFNOTIFICATION_MOTION_SHAKE_ENDED object:self];
    }
	
}


#pragma mark -
#pragma mark XCode Generated
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end

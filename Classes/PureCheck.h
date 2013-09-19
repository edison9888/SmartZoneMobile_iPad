//
//  PureCheck.h
//  MobileOffice2.0
//
//  Created by Tsubaki on 11. 3. 12..
//  Copyright 2011 Insang. All rights reserved.
//
//  Jailbreaked Device Check Class
//    - check jailbreak files and some ports
//  Return False if Device is pure, True if Device jailbreaked.
//

#import <Foundation/Foundation.h>


@interface PureCheck : NSObject {
	BOOL pureflag;
}

- (BOOL)isPure;

@end

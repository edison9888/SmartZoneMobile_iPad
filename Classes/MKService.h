//
//  MKService.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	
//	Header정보 기타 로그인 정보 등을 포함하는 Services

#import <Foundation/Foundation.h>


@interface MKService : NSObject {
	NSString *headerInfo;
}

@property (nonatomic, retain) NSString *headerInfo;

@end

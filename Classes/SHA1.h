//
//  SHA1.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 3..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>


@interface SHA1 : NSObject {

}

+(NSString *)stringToSha1:(NSString *)hashkey;
	
@end

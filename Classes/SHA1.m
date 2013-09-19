//
//  SHA1.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 3..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SHA1.h"


@implementation SHA1

+(NSString *)stringToSha1:(NSString *)hashkey{
	
    // Using UTF8Encoding
    const char *s = [hashkey cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
	
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
	
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest
								 length:CC_SHA1_DIGEST_LENGTH];
    // description converts to hex but puts <> around it and spaces every 4	bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    // hash is now a string with just the 40char hash value in it
	
    return hash;
	
}

@end

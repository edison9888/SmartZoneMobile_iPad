//
//  NSDictionary+NotNilReturn.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 3. 2..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "NSDictionary+NotNilReturn.h"


@implementation NSDictionary (NotNilReturn) 

- (id)notNilObjectForKey:(id)aKey {
	
	id ret = [self objectForKey:aKey];
	
	if (ret == nil) {
		ret = @"";
	}
	
	return ret;
	
}

@end

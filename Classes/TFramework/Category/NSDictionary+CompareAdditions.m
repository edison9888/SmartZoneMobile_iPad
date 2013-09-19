//
//  NSDictionary+CompareAdditions.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 31..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "NSDictionary+CompareAdditions.h"


@implementation NSDictionary (CompareAdditions)

- (NSComparisonResult)compareWithItemTITLE:(NSDictionary *)otherDic {
	
	return [[self objectForKey:@"TITLE"] compare:[otherDic objectForKey:@"TITLE"]];
	
}

- (NSComparisonResult)compareWithItemName:(NSDictionary *)otherDic {
	return [[self objectForKey:@"Name"] compare:[otherDic objectForKey:@"Name"]];
	
}

@end

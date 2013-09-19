//
//  NSMutableDictionary+CompareAdditions.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 31..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "NSMutableDictionary+CompareAdditions.h"


@implementation NSMutableDictionary (CompareAdditions)

// TITokenField 전용 
- (NSComparisonResult)localizedCaseInsensitiveCompareForTITokenFieldView:(NSMutableDictionary *)otherDic {
	
	NSString * selfObject = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             [self objectForKey:@"NAME"],
                             [self objectForKey:@"POSITION"],
                             [self objectForKey:@"DEPARTMENT"], 
                             [self objectForKey:@"ETC"]];
	
	NSString * otherObject = [NSString stringWithFormat:@"%@ %@ %@ %@",
                              [otherDic objectForKey:@"NAME"],
                              [otherDic objectForKey:@"POSITION"],
                              [otherDic objectForKey:@"DEPARTMENT"], 
                              [otherDic objectForKey:@"ETC"]];
	
	return [selfObject localizedCaseInsensitiveCompare:otherObject];
	
}

- (NSComparisonResult)compareWithItemTITLE:(NSMutableDictionary *)otherDic {
	
	return [[self objectForKey:@"TITLE"] compare:[otherDic objectForKey:@"TITLE"]];
	
}

- (NSComparisonResult)compareWithItemName:(NSMutableDictionary *)otherDic {
	return [[self objectForKey:@"Name"] compare:[otherDic objectForKey:@"Name"]];
	
}

@end

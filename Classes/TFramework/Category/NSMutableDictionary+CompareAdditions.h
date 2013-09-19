//
//  NSMutableDictionary+CompareAdditions.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 31..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (CompareAdditions) 

- (NSComparisonResult)compareWithItemTITLE:(NSMutableDictionary *)otherDic;
- (NSComparisonResult)compareWithItemName:(NSMutableDictionary *)otherDic;

@end

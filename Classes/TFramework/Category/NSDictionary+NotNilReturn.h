//
//  NSDictionary+NotNilReturn.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 3. 2..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NotNilReturn) 

// objectForKey로 부터 얻어진 값이 nil인경우 @""로 반환
// (value값이 NSString 타입인게 기대되어지는 경우 사용가능)
- (id)notNilObjectForKey:(id)aKey;

@end

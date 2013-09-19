//
//  NSMutableArray+QueueAdditions.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 3. 2..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAdditions)
- (id)dequeueFromHeader:(BOOL)header;
- (void)enqueue:(id)anObject toHeader:(BOOL)header;

@end

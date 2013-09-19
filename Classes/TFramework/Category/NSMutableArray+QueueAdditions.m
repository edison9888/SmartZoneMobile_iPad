//
//  NSMutableArray+QueueAdditions.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 3. 2..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"


@implementation NSMutableArray (QueueAdditions)


- (id)dequeueFromHeader:(BOOL)header {
   
    id object = nil;
	
	if (header) {	// header
		object = [self objectAtIndex:0];
		if (object != nil) {
			[[object retain] autorelease];
			[self removeObjectAtIndex:0];
		}
	} else {		// tail
		object = [self lastObject];
		if (object != nil) {
			[[object retain] autorelease];
			[self removeLastObject];
		}
	}

    return object;
}


- (void)enqueue:(id)anObject toHeader:(BOOL)header {
	
	if (header) {	// header
		[self insertObject:anObject atIndex:0];
	} else {	// tail
		[self addObject:anObject];
	}

}

@end

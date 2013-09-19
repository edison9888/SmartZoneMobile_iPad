//
//  Clipboard.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Clipboard.h"



@implementation Clipboard
@synthesize dic;	

+ (Clipboard *)sharedClipboard {
	static Clipboard *clipboard;
	
	@synchronized(self) {
		if(!clipboard) {
			
			clipboard = [[Clipboard alloc] init];
		}
	}
	return clipboard;
}

- (void)clipValue:(id)_value clipKey:(NSString *)_key {
	[self.dic setObject:_value forKey:_key];	
}

- (id)clipKey:(NSString *)_key {
	return [self.dic objectForKey:_key];
}

- (id)init {
	[super init];
	self.dic = [[NSMutableDictionary alloc] init];
	return self;
}	

@end

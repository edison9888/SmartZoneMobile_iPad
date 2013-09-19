//
//  Clipboard.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//--- (return) keyName by owner     :     정의해 놓으면 나중에 편하다!
// (NSArray *) MainNoticeArray by kakadais


#import <Foundation/Foundation.h>


@interface Clipboard : NSObject {
	NSMutableDictionary *dic;
	
}

+ (Clipboard *)sharedClipboard;
- (void)clipValue:(id)_value clipKey:(NSString *)_key;
- (id)clipKey:(NSString *)_key;

@property (nonatomic, retain) NSMutableDictionary *dic;



@end

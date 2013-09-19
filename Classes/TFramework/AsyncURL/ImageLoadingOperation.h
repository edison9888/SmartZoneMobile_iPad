//
//  ImageLoadingOperation.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 4. 29..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoadingInfo : NSObject {
	NSString *url;
	id target;
	SEL action;
}

@property (retain) NSString *url;
@property (retain) id target;
@property (assign) SEL action;

@end


@interface ImageLoadingOperation : NSOperation {
	NSString *url;
	id target;
	SEL action;
}

@property (retain) NSString *url;
@property (retain) id target;
@property (assign) SEL action;

+ (NSString *)imageResultKey;
+ (NSString *)urlResultKey;
- (id)initWithImageURL:(NSString *)theUrl target:(id)theTarget action:(SEL)theAction;

@end

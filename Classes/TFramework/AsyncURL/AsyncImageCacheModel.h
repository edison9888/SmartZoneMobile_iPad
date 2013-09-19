//
//  AsyncImageCacheModel.h
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 18..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AsyncImageCacheModel : NSObject {
	
	// Thread Queue
	NSOperationQueue	*operationQueue;
	NSMutableDictionary *cachedImages;
	NSMutableArray		*imageLoadingInfoArray;
	NSMutableArray		*imageIndex;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) NSMutableDictionary *cachedImages;
@property (nonatomic, retain) NSMutableArray *imageLoadingInfoArray;
@property (nonatomic, retain) NSMutableArray *imageIndex;

// Singleton creation method
+ (AsyncImageCacheModel *)sharedInstance;

- (UIImage *)cachedImageForURL:(NSString *)url;
- (UIImage *)savedImageForURL:(NSString *)url;

@end

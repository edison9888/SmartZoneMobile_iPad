//
//  AsyncImageCacheModel.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 18..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "AsyncImageCacheModel.h"
#import "ImageLoadingOperation.h"
#import "TFDefine.h"

#define MAX_NUMBER_OF_CACHED_IMAGE 90	// 최대 90개의 이미지를 메모리에 캐쉬 해논다.

@implementation AsyncImageCacheModel

@synthesize operationQueue;
@synthesize cachedImages;
@synthesize imageLoadingInfoArray;
@synthesize imageIndex;

- (id)init {
	
	if (self = [super init]) {
		self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
		[self.operationQueue setMaxConcurrentOperationCount:2];
		self.cachedImages = [NSMutableDictionary dictionaryWithCapacity:0];
		self.imageLoadingInfoArray = [NSMutableArray arrayWithCapacity:0];
		self.imageIndex =[NSMutableArray arrayWithCapacity:0];	
	}
	
	return self;
	
}

// Singleton creation method
+ (AsyncImageCacheModel *)sharedInstance {
	
	static AsyncImageCacheModel *instance = nil;
	
	@synchronized (self) {
		
		if (instance == nil) {
			instance = [[AsyncImageCacheModel alloc] init];
		}
	}
	
	return instance;
}

- (void)didFinishLoadingImageWithResult:(NSDictionary *)result {
	
	if (result == nil) {
		return;
	}
	
//	if ([result count] == 0) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:TFNOTIFICATION_IMAGE_LOAD_COMPLETE 
//															object:nil];
//		return;		
//	}
	
	NSString *url  = [result objectForKey:[ImageLoadingOperation urlResultKey]];
	UIImage *image = [result objectForKey:[ImageLoadingOperation imageResultKey]];
	
	if(url == nil) {
	}else{
		if (image != nil) {
			[self.cachedImages setObject:UIImagePNGRepresentation(image) forKey:url];
			[self.imageIndex addObject:url];
		} else {
			[self.cachedImages setObject:[[[UIImage alloc] init] autorelease]  forKey:url];
			[self.imageIndex addObject:url];
		}
	}
	
	NSEnumerator *enumerator = [self.imageLoadingInfoArray objectEnumerator];
	ImageLoadingInfo *info = nil;
	
	while (info = [enumerator nextObject]) {
		
		if ([info.url isEqual:url]) {
						
			[self.imageLoadingInfoArray removeObject:info];
			
			if ([self.imageLoadingInfoArray count] == 0) {
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:TFNOTIFICATION_IMAGE_LOAD_COMPLETE 
																object:nil];
	
			break;

		}
	}
}

- (void)didFinishSaveImageWithResult:(NSDictionary *)result {
	
	if (result == nil) {
		return;
	} 
	
//	if ([result count] == 0) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:TFNOTIFICATION_IMAGE_SAVE_COMPLETE 
//															object:nil];
//		return;
//	}
	
	NSString *url  = [result objectForKey:[ImageLoadingOperation urlResultKey]];
	UIImage *image = [result objectForKey:[ImageLoadingOperation imageResultKey]];
	
	BOOL isNotiCancel = NO;	// 이미지를 저장하여 노티피케이션을 날릴지 판단.
	
	if(url == nil) {
	}else{
		if (image != nil) {
			//이미지 저장작업을 한다.
			NSString *imgFile = [NSString stringWithFormat:@"%@",[url lastPathComponent]];
			NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			NSString *fileName = [path stringByAppendingPathComponent:imgFile];
			
			NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(image)];
			[imgData writeToFile:fileName atomically:YES];
		} else {
			isNotiCancel = YES;	// URL에 이미지가 없다. 노티피케이션은 안날린다.
		}

	}
	
	NSEnumerator *enumerator = [self.imageLoadingInfoArray objectEnumerator];
	ImageLoadingInfo *info = nil;
	
	while (info = [enumerator nextObject]) {
		
		if ([info.url isEqual:url]) {
			
			[self.imageLoadingInfoArray removeObject:info];
			
			if ([self.imageLoadingInfoArray count] == 0) {
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			}
			
			// URL에 이미지가 있고 저장소에 저장을 했다면 노티를 날린다.
			if (!isNotiCancel) {
				[[NSNotificationCenter defaultCenter] postNotificationName:TFNOTIFICATION_IMAGE_SAVE_COMPLETE 
																	object:nil];
			}
			
			break;
			
		}
	}
}

- (UIImage *)cachedImageForURL:(NSString *)url {
	
	if (url == nil || [url isEqualToString:@""]) {
		return nil;
	}
	
	id cachedObject = nil;
	
	cachedObject = [self.cachedImages objectForKey:url];
	
	if ([cachedObject isKindOfClass:[NSData class]]) {
		cachedObject = [UIImage imageWithData:cachedObject];
	}
	
	if (cachedObject == nil) {
		for(ImageLoadingInfo *imgInfo in self.imageLoadingInfoArray){
			if([imgInfo.url isEqualToString:url]) return nil;
		}
		
		ImageLoadingInfo *info = [[ImageLoadingInfo alloc] init];
		
		if ([self.cachedImages count] >= MAX_NUMBER_OF_CACHED_IMAGE) {	
			[self.cachedImages removeObjectForKey:[imageIndex objectsAtIndexes:0]];						// 캐쉬를 비운다.				[imageIndex removeObjectAtIndex:0];
		}
		
		info.url = url;
		
		[self.imageLoadingInfoArray addObject:info];
		[info release];
		info = nil;
		[self.cachedImages setObject:@"Loading..." forKey:url];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		ImageLoadingOperation *operation = [[ImageLoadingOperation alloc] initWithImageURL:url
																					target:self
																					action:@selector(didFinishLoadingImageWithResult:)];
		[self.operationQueue addOperation:operation];
		[operation release];
		operation = nil;
		
	} else if (![cachedObject isKindOfClass:[UIImage class]]) {
		cachedObject = nil;
	} else {
		
	}
	
	return cachedObject;
}


- (UIImage *)savedImageForURL:(NSString *)url {
	
	if (url == nil || [url isEqualToString:@""]) {
		return nil;
	}
	
	for(ImageLoadingInfo *imgInfo in self.imageLoadingInfoArray){
		if([imgInfo.url isEqualToString:url]) return nil;
	}
	
	id cachedObject = nil;
	ImageLoadingInfo *info = [[ImageLoadingInfo alloc] init];
	
	info.url = url;
	
	[self.imageLoadingInfoArray addObject:info];
	[info release];
	info = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	ImageLoadingOperation *operation = [[ImageLoadingOperation alloc] initWithImageURL:url
																				target:self
																				action:@selector(didFinishSaveImageWithResult:)];
	[self.operationQueue addOperation:operation];
	[operation release];
	operation = nil;
	
	if (![cachedObject isKindOfClass:[UIImage class]]) {
		cachedObject = nil;
	} else {
		
	}
	
	return cachedObject;
}


- (void)dealloc {
	
	[imageLoadingInfoArray release];
	[cachedImages release];
	[operationQueue release];
	[imageIndex release];
	
	[super dealloc];
	
}

@end

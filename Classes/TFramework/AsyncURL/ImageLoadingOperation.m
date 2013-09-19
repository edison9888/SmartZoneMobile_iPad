//
//  ImageLoadingOperation.m
//  TestFramework
//
//  Created by 닷넷나무에 사과열리다 on 11. 4. 29..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "ImageLoadingOperation.h"

@implementation ImageLoadingInfo

@synthesize url;
@synthesize target;
@synthesize action;

- (void)dealloc {
	[target release];
	[url release];
	[super dealloc];
}

@end


@implementation ImageLoadingOperation

@synthesize url;
@synthesize target;
@synthesize action;

+ (NSString *)imageResultKey {
	return @"image";
}

+ (NSString *)urlResultKey {
	return @"url";
}

- (id)initWithImageURL:(NSString *)theUrl target:(id)theTarget action:(SEL)theAction {

	self = [super init];
	
	if (self) {
		self.url	= theUrl;
		self.target = theTarget;
		self.action = theAction;
	}
	
	return self;
	
}

- (void)main {
	NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.url]];
	UIImage *image = [[UIImage alloc] initWithData:data];
	
	NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
							self.url, [ImageLoadingOperation urlResultKey],
							image,	  [ImageLoadingOperation imageResultKey], nil];
	
	[self.target performSelectorOnMainThread:self.action withObject:result waitUntilDone:NO];
	
	[image release];
	image = nil;
	[data release];
	data = nil;
	
}

- (void)dealloc {
	[target release];
	[url release];
	[super dealloc];
}

@end

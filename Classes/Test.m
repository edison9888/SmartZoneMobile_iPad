//
//  Test.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test.h"
#import "Clipboard.h"
#import "URL_Define.h"

@implementation Test

-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic{
	
}

-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic{
	
	NSDictionary *singles = (NSDictionary *)[_resultDic valueForKey:@"result"];
	NSLog(@"### 1 This is the title of a stream: %@", [singles valueForKey:@"totalCount"]);
	
	NSArray *streams = (NSArray *)[_resultDic valueForKey:@"personinfo"];
	
	// loop over all the stream objects and print their titles
	int ndx;
	
	for (ndx = 0; ndx < streams.count; ndx++) {
		NSDictionary *stream = (NSDictionary *)[streams objectAtIndex:ndx];
		NSLog(@"### 2 This is the title of a stream: %@", [stream valueForKey:@"name"]); 
	}
	
}

- (void) test {
	
	
//	Communication *cm = [[Communication alloc] init];
//	cm.delegate = self;
//	
//	//	NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
//	//	
//	//	[tmpArr addObject:@"stype=name"];
//	//	[tmpArr	addObject:@"sword=이현우"];
//	
//	NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
//	[tmpDic setValue:@"name" forKey:@"stype"];
//	[tmpDic setValue:@"이현우" forKey:@"sword"];
//	
//	
//	BOOL rslt = [cm callWithArray:tmpDic serviceUrl:URL_getAddressList];	
//	if(rslt) {
//		
//	}
}
@end

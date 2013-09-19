//
//  ContactModel.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 17..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactModel.h"


@implementation ContactModel

@synthesize contactListDic;
@synthesize contactOptionDic;

static ContactModel *instance;

// Singleton creation method
+ (ContactModel *)sharedInstance {
	
	@synchronized (self) {
		
		if (instance == nil) {
			instance = [[ContactModel alloc] init];
        }
        if ( instance.contactListDic == nil ) {
            instance.contactListDic = [[NSMutableDictionary alloc] init]; 
        }
        if ( instance.contactOptionDic == nil ) {
            instance.contactOptionDic = [[NSMutableDictionary alloc] init];
        }
	}
	
	return instance;
}

+ (void)releaseSharedInstance {
	
	@synchronized (self) {
		[instance release];
		instance = nil;
	}
	
}

// 모델을 초기화 시킨다.
- (void)resetModel {
	
	[contactListDic removeAllObjects];
	
}

- (BOOL)isAddressData:(NSString *)key {
    //NSLog(@"isAddressData key [%@] data [%@]",key, [contactListDic objectForKey:key]);
    if ( [contactListDic objectForKey:key] == nil ) {
        //NSLog(@"address book key[%@] is nil", key);
        return NO;
    } else {
        //NSLog(@"address book key[%@] is not nil", key);
        return YES;
    }
}

- (NSMutableArray *)getAddressData:(NSString *)key {
    
    NSMutableArray *data = [[[NSMutableArray alloc] init] autorelease];
    
    if ( [self isAddressData:key] ) {
        data = [contactListDic objectForKey:key];
    } else {
        
        if ( [key isEqualToString:@"phonebook"] ) {
            data = [ContactFunction loadAddressBook];
        
            if ( [data count] > 0 ) {
                //새로 값을 호출 했으므로 모델에 저장한다.
                //[contactListDic setObject:[data copy] forKey:key];
                [contactListDic setObject:data forKey:key];
            }
        } else {
            
        }
    }
    return data;
}

- (void)dealloc {
    
    [contactListDic release];
    
    [super dealloc];
}
    
@end

//
//  ContactFunction.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 17..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContactFunction : NSObject {

    
}

+ (NSMutableArray *)loadAddressBook;

+ (NSMutableArray *)searchAddressBook:(NSMutableArray *)orgData addressType:(NSString *)addressType keyWord:(NSString *)keyWord;


@end

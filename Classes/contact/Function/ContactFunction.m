//
//  ContactFunction.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 17..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactFunction.h"
#import <AddressBook/AddressBook.h>

@implementation ContactFunction






//phone book load.
+ (NSMutableArray *)loadAddressBook {
    
    
    //NSLog(@"start load addressbook");
    
    //===================================================//
    // 주소록의 모든 정보를 구조체에 저장을 합니다.
    //===================================================//
    ABAddressBookRef addressBook = ABAddressBookCreate();
//NSLog(@"start load addressbook [%@]",addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//NSLog(@"start load allPeople [%@]",allPeople);
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    NSInteger nPeople = (NSInteger)ABAddressBookGetPersonCount(addressBook);
//    //    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:nPeople];
    
    //===================================================//
    // 저장된 구조체를 돌면서 해당 데이터를 추출해 옵니다.
    //===================================================//
    for (int i = 0; i < nPeople ; i++) { 
        
        //NSString *recID = @"";
        NSString *fName = @"";
        NSString *lName = @"";
        NSString *mobile = @"";
        NSString *iphone = @"";
        NSString *home = @"";
        NSString *email = @"";
        
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSNumber *recordId = [NSNumber numberWithInteger: ABRecordGetRecordID(ref)];
        
        
        if (firstName != nil) {
            fName = (NSString *)firstName;
            CFRelease(firstName);
        }
        if (lastName != nil) {
            lName = (NSString *)lastName;
            CFRelease(lastName);
        }
        
        // 사진이미지는 여기에 넘어옵니다.
        if (ABPersonHasImageData(ref)) {
            // UIImage* image = [UIImage imageWithData:
            //        (NSData *)ABPersonCopyImageData(ref)];
            // image를 저장하는 펑션은 여기에 작성하시면 됩니다.
        }
        
        //========================================================//
        // 전화번호 구조체 및 카테고리 저장/추출
        // 전화번호 구조체에는 전화번호와 집전화, 핸드폰 이런 카테고리 구분이 있으며
        // 이것은 Label로 구별합니다.
        // Label : kABHomeLabel, kABPersonPhoneIPhoneLabel 등등...
        //=======================================================//
        ABMultiValueRef phoneNums = (ABMultiValueRef)ABRecordCopyValue(ref, kABPersonPhoneProperty);
//NSLog(@"ABMultiValueGetCount[%d]",(NSInteger)ABMultiValueGetCount(phoneNums));
        for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNums); j++) {
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNums, j);
            CFStringRef tempRef = (CFStringRef)ABMultiValueCopyValueAtIndex(phoneNums, j);
//NSLog(@"label[%@]tempRef[%@]",label, tempRef);
            
            if ( label == NULL ) {
                
                
                
            } else {
            
            // 전화번호의 형태라벨별로 추출. 다른 형식도 이렇게 추출이 됩니다.
            if (CFStringCompare(label, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                if (tempRef != nil) {
                    //NSLog(@"Mobile: %@-%d", (NSString *)tempRef,i);
                    mobile = (NSString *)tempRef;
                }
            } else if (CFStringCompare(label, kABPersonPhoneIPhoneLabel, 0) == kCFCompareEqualTo) {
                if (tempRef != nil) {
                    //NSLog(@"iPhone: %@-%d", (NSString *)tempRef,i);
                    iphone = (NSString *)tempRef;
                }
            } else if (CFStringCompare(label, kABHomeLabel, 0) == kCFCompareEqualTo) {
                if (tempRef != nil) {
                    //NSLog(@"Home:  %@-%d", (NSString *)tempRef,i);
                    home = (NSString *)tempRef;
                }
            }
                
                CFRelease(label);
            }
            
            
            CFRelease(tempRef);
        }
        if ( [lName isEqualToString:@""] && [fName isEqualToString:@""] ) {
            
        } else {
            
            ABMutableMultiValueRef eMail = ABRecordCopyValue(ref, kABPersonEmailProperty);
            if ( ABMultiValueGetCount(eMail) > 0 ) {
                email = (NSString *)ABMultiValueCopyValueAtIndex(eMail, 0);
            }
            
            
            
            //기초정보를 딕셔너리에 담고..
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:recordId,@"recordId",[NSString stringWithFormat:@"%@ %@",lName,fName],@"fullname",mobile,@"mobile",iphone,@"iphone",home,@"home",email,@"email",nil];
            
            //어레이에.. 담는다.
            [array addObject:dic];
        }
    }
    
    CFRelease(allPeople);
    
	return array;
}


//초성 검색 메소드 이다.
+ (NSMutableArray *)searchAddressBook:(NSMutableArray *)orgData addressType:(NSString *)addressType keyWord:(NSString *)keyWord {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *forKey = @"";
    if ( [addressType isEqualToString:@"member"] ) {
        forKey = @"empnm";
    } else if ( [addressType isEqualToString:@"my"] ) {
        forKey = @"fullname";
    } else if ( [addressType isEqualToString:@"phonebook"] ) {
        forKey = @"fullname";
    }
    
    
    //키워드로 검색하여 결과만 추려내자.
    
    for (int i=0; i<[orgData count]; i++) {
        NSDictionary *dic = [orgData objectAtIndex:i];
        
        //NSLog(@"orgStr[%@] schstr[%@] check[%d]", [dic objectForKey:forKey], keyWord, [[dic objectForKey:forKey] rangeOfString:keyWord].length);
        
        NSString *keyStr = [[dic objectForKey:forKey] stringByReplacingOccurrencesOfString:@" " withString:@""];
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ( [keyStr rangeOfString:keyWord].length > 0 ) {
            [array addObject:dic];
        }
    }
    
    //결과 값을 정렬한다.
    NSSortDescriptor *publishedSorter =     [[[NSSortDescriptor alloc] initWithKey:forKey
                                                                         ascending:YES                                             
                                                                          selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    [array sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];

    //정렬된 결과값을 리턴한다.
    
    if ( [array count] == 0 ) {
        //결과 없음.
        //NSLog(@"no search result");
    }
    //NSLog(@"search Result [%@]", array);
    
    return array;
}



@end

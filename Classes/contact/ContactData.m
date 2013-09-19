//
//  ContactData.m
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 14..
//  Copyright 2011 infoTM. All rights reserved.
//

#import "ContactData.h"
#import <AddressBook/AddressBook.h>

//// 전화걸기
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://전화번호"]];
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8004664411"]];
//
//// 메일 쓰기
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://이메일주소"]];
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://devprograms@apple.com"]];
//
////SMS 쓰기
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://전화번호"]];
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://466453"]];








//정렬
//NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"22", @"published",@"33",@"key",nil];
//NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"23", @"published",@"34",@"key",nil];
//NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"22", @"published",@"35",@"key",nil];
//NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"24", @"published",@"36",@"key",nil];
//NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"21", @"published",@"37",@"key",nil];
//
//NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
//[array addObject:dic];
//[array addObject:dic2];
//[array addObject:dic3];
//[array addObject:dic4];
//[array addObject:dic5];
//
//NSSortDescriptor *publishedSorter =     [[[NSSortDescriptor alloc] initWithKey:@"published"
//                                                                     ascending:YES                                             
//                                                                      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
//NSLog(@"%@", [array description]);
//[array sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
//
//NSLog(@"%@", [array description]);




@implementation ContactData

+ (NSMutableDictionary *)loadAddressBook {
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	
    
    //NSLog(@"start load addressbook");
    
    //===================================================//
    // 주소록의 모든 정보를 구조체에 저장을 합니다.
    //===================================================//
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //NSLog(@"start load addressbook [%@]",addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //NSLog(@"start load allPeople [%@]",allPeople);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    //NSLog(@"nPeople Count[%@]", nPeople);
    
    
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
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSNumber *recordId = [NSNumber numberWithInteger: ABRecordGetRecordID(ref)];
        
        //NSLog(@"Name : %@-%@ %@", recordId, (firstName != nil) ? (NSString *)firstName : @"", (lastName != nil) ? (NSString *)lastName : @"");
        
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
        for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNums); j++) {
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNums, j);
            CFStringRef tempRef = (CFStringRef)ABMultiValueCopyValueAtIndex(phoneNums, j);
            
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
            CFRelease(tempRef);
        }
        
        //기초정보를 딕셔너리에 담고..
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:recordId,@"recordId",fName,@"firstName",lName,@"lastName",mobile,@"mobile",iphone,@"iphone",home,@"home",nil];
        
        //어레이에.. 담는다.
        [array addObject:dic];
        
    }
    CFRelease(allPeople);
    
    [data setObject:array forKey:@"list"];
    
	return data;
}

@end

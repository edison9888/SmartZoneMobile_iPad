//
//  ContactModel.h
//  MobileOffice2.0
//
//  Created by 장재영 on 11. 6. 17..
//  Copyright 2011 infoTM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactFunction.h"

@interface ContactModel : NSObject {
    
    // 임직원, 내연락처, 폰북의 데이터를 담고 있는 Dictionary.
    // objectForKey : {member}{my}{phonebook}  NSMutableArray 로 값을 저장한다.
    NSMutableDictionary *contactListDic;

    ContactFunction *f;
    
    // 연락처 임직원, 내연락처 구조 정보.
    //contactid : 연락처 아이디
    //fullname : 이름
    //jobtitle : 직위
    //department : 부서
    //companyname : 회사명
    // 연락처 폰북 구조 정보
    
    // 연락처 검색시 호출된 정보및 리턴 정보 딕셔너리.
    // forKey : BOOL "search" value("YES") : 초대, 연락처 검색 등에서 사용된다.
    // forKey : NSString "title" : 타이틀 정의
    // forKey : NSString "items" : 항목명 정의
    // forKey : NSMutableDictionary selected : 선택된 결과값을 담는다.
    NSMutableDictionary * contactOptionDic;
}


@property (nonatomic, retain) NSMutableDictionary *contactListDic;
@property (nonatomic, retain) NSMutableDictionary *contactOptionDic;

+ (ContactModel *)sharedInstance;	// Singleton creation method
+ (void)releaseSharedInstance;
- (void)resetModel;

- (BOOL)isAddressData:(NSString *)key;
- (NSMutableArray *)getAddressData:(NSString *)key;


@end

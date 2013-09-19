//
//  Communication.h
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Clipboard.h"

enum TransactionState {
	STATE_TIMEOUT,
	STATE_NODATA,
	STATE_FAIL_CONNECTION,
	STATE_FAIL_OTHER,
	STATE_SUCCESS
};

@protocol CommunicationDelegate <NSObject>
-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic;
-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic;
-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic;

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end


@interface Communication : NSObject {
	/* 
	 str_header
	 헤더 Name : MobileKate
	 헤더 Value : 사번|폰모델|운영체제및버전|WIFI-MAC-Address|3G-MAC-Address or 사번|폰모델|운영체제및버전|WIFI-MAC-Address
	 Example : 201091218|AIP4|IOS4.2|11:aa:bb:cc:dd|11:aa:bb:cc:dd <- 일반 스마트폰
     201091218|AIP4|IOS4.2|11:aa:bb:cc:dd     <- WIFI 전용 IPAD 또는 해지한 스마트폰
	 */	
	NSString *str_header;
	
	NSString *str_url;
	NSMutableDictionary *arr_input;
	
	NSMutableData *finalData;
	
	NSURLConnection *urlConnection;
	
	BOOL login_process;
    
    NSTimer *timer;
    BOOL ignoreTimer;
	
}

- (void)cancelCommunication;
- (BOOL)callWithArray:(NSMutableDictionary *)_dic serviceUrl:(NSString *)_url; // return : YES/NO / Param1(_dic) : input dictionary / Param2(_url) : service call url
- (BOOL)stringWithUrl:(NSURL *)url;
- (void)setDelegate:(id)aDelegate;
- (NSString *)getHeaderString;
- (void)timeout:(NSTimer *)aTimer;

@property (nonatomic) BOOL login_process;
@property (nonatomic, assign) id<CommunicationDelegate>delegate;
@property (nonatomic, retain) NSString *str_url;
@property (nonatomic, retain) NSMutableDictionary *arr_input;
@property (nonatomic, retain) NSString *str_header;
@property (nonatomic, retain) NSMutableData *finalData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) BOOL ignoreTimer;;

@end

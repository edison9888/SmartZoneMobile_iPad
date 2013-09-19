//
//  Communication.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 2. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Communication.h"
#import "Base64.h"
#import "URL_Define.h"
//#define debugmode 1

@implementation Communication
@synthesize delegate, str_url, arr_input, str_header, finalData, urlConnection, login_process, timer, ignoreTimer;;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 666) {
		//앱종료
		//[[UIApplication sharedApplication] terminateWithSuccess];
		
		//PIN로그인으로 이동
		NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
		[noti postNotificationName:@"SessionTimeout" object:nil];
		
	}
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten 
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	//NSLog(@"bytesWritten: %d bytes.", bytesWritten);
	//NSLog(@"totalBytesWritten: %d bytes.", totalBytesWritten);
	//NSLog(@"totalBytesExpectedToWrite: %d bytes.", totalBytesExpectedToWrite);
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        //NSLog(@"Can Auth Secure Requestes!");
        return YES;
    }
    else if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        //NSLog(@"Can Auth Basic Requestes!");
        return YES;
    }
    
    //NSLog(@"Cannot Auth!");
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        //NSLog(@"Trust Challenge Requested!");
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
		
    }
    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        //NSLog(@"HTTP Auth Challenge Requested!");
        NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:@"user" password:@"pass" persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        [credential release];
    }
}


#pragma mark -
#pragma mark NSURLConnection delegate method

- (void)setDelegate:(id)aDelegate {
	delegate = aDelegate;
}

//--- tmp remove for sync transaction ---//

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.finalData appendData:data];
	//NSLog(@"Received data : %d bytes.", [data length]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	[self.timer invalidate];
    
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	NSDictionary *fields = [httpResponse allHeaderFields];
	NSString *cookie = nil;
	cookie = [fields valueForKey:@"Set-Cookie"];
	
	if(cookie != nil) {
		Clipboard *clip = [Clipboard sharedClipboard];
		[clip clipValue:cookie clipKey:@"kakadais_cookie"];			
	}
	
	//--- 매번 cookie가 들어오진 않으므로 최초에만 넣어주고 통신을 진행한다.
	//		else {
	//			//--- cookie가 안들어왔다면 정상 통신으로 보지 않는다. ---//
	//			error = [NSError errorWithDomain:@"Receive No Cookie Error" code:32767 userInfo:nil];
	//			[delegate performSelector:@selector(didErrorCommunication:requestDictionary:) withObject:error withObject:self.arr_input];
	//		}
	
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Do whatever you want here
	
	SBJSON *jsonParser = [SBJSON new];
	
	//NSLog(@"Total received data : %d bytes.", [self.finalData length]);
	
	NSString *tmpStrData = [[NSString alloc] initWithData:self.finalData encoding:NSUTF8StringEncoding];
	
	
	id tmpID = [jsonParser objectWithString:tmpStrData error:NULL];
	NSDictionary *tmpDic = (NSDictionary *)tmpID;
	[tmpStrData release];
	[jsonParser release];
	
#ifdef debugmode
	NSLog(@"### Communication Receive data : %@", tmpDic);
#endif
    
	//--- 인증/세션 에러 앱종료
	NSDictionary *resultDic = (NSDictionary *)[tmpDic objectForKey:@"result"];
	NSNumber *rsltCode = [resultDic objectForKey:@"code"];
	
	if ([rsltCode intValue] == 2 && login_process != YES) {
		//--- login fail ---//
		NSString *strErrDesc = [resultDic objectForKey:@"errdesc"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"message:strErrDesc
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		alert.tag = 666;
		[alert show];
		[alert release];
	}
	else {
		[delegate performSelector:@selector(didEndCommunication:requestDictionary:) withObject:tmpDic withObject:self.arr_input];
	}
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	
	[delegate performSelector:@selector(willStartCommunication:requestDictionary:) withObject:nil withObject:self.arr_input];
	
	return request;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[delegate performSelector:@selector(didErrorCommunication:requestDictionary:) withObject:error withObject:self.arr_input];
}

// for URI encode
- (NSString *)component:(NSString *)component {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(
																NULL,
																(CFStringRef)component,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8 ) autorelease];
}

- (BOOL)stringWithUrl:(NSURL *)url
{
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
															  cachePolicy:NSURLRequestReturnCacheDataElseLoad
														  timeoutInterval:30];
	
	[urlRequest setHTTPMethod:@"POST"];
	
	
	//	[urlRequest setValue:self.str_header forHTTPHeaderField:@"MobileKate"];
	
	//	NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:@"eye",@"name",@"http://theeye.pe.kr", @"home", nil];
	
	
	//--- make string ---//
	NSMutableString *_bodyString = [[NSMutableString alloc] init];
	
	NSMutableDictionary *tmpDic = self.arr_input;
	
	NSArray *keyArr = [self.arr_input allKeys];
	
	int arr_count = [keyArr count];
	
	for(int i = 0; i < arr_count; i++) {
		
		//--- file path mode 일 때는 URI 인코딩 하지 않는다.
		[_bodyString appendFormat:@"%@=%@", [self component:[keyArr objectAtIndex:i]], [self component:[tmpDic objectForKey:[keyArr objectAtIndex:i]]]];
		//		[_bodyString appendString:[self.arr_input objectAtIndex:[tmpDic objectForKey:<#(id)aKey#>]]];
		//--- except last & char
		if((i + 1) < arr_count)
			[_bodyString appendString:@"&"];			
		
	}
    // url 통계를 위한 파라미터  추가
	[_bodyString appendString:@"&appmngid=APP-00020"];//공통 
	if ([[url absoluteString] isEqualToString:URL_getAppointmentList] ||//일정
        [[url absoluteString] isEqualToString:URL_getAppointmentDetail] ||
		[[url absoluteString] isEqualToString:URL_getSharedAppointmentList] ||
		[[url absoluteString] isEqualToString:URL_createAppointmentInfo]|| 
		[[url absoluteString] isEqualToString:URL_updateAppointmentInfo]|| 
		[[url absoluteString] isEqualToString:URL_acceptAppointmentInfo]|| 
		[[url absoluteString] isEqualToString:URL_deleteAppointmentInfo]|| 
		[[url absoluteString] isEqualToString:URL_cancelAppointmentInfo]|| 
		[[url absoluteString] isEqualToString:URL_getSharedUserInfoList] ||
		[[url absoluteString] isEqualToString:URL_createSharedUserInfo] ||
		[[url absoluteString] isEqualToString:URL_deleteSharedUserInfo] 
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00002"];
	}
	if ([[url absoluteString] isEqualToString:URL_getEmailFolerInfo] ||//메일
		[[url absoluteString] isEqualToString:URL_getEmailInfoList] ||
		[[url absoluteString] isEqualToString:URL_getEmailInfo]|| 
		[[url absoluteString] isEqualToString:URL_sendEmailInfo]|| 
		[[url absoluteString] isEqualToString:URL_deleteEmailInfo]|| 
        //		[[url absoluteString] isEqualToString:URL_getEmailSpecificInfo]|| 
		[[url absoluteString] isEqualToString:URL_updateUnreadEmailInfo]|| 
		[[url absoluteString] isEqualToString:URL_createDraftEmailInfo] || 
		[[url absoluteString] isEqualToString:URL_getBadgeCountInfo] || 
		[[url absoluteString] isEqualToString:getEmailAttachmentInfo] || 
		[[url absoluteString] isEqualToString:URL_createDraftEmailInfo] || 
		[[url absoluteString] isEqualToString:forwardEmailInfo] || 
		[[url absoluteString] isEqualToString:moveEmailInfo] 
        
        
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00001"];
	}
    if ([[url absoluteString] isEqualToString:URL_getAddressList]||
        [[url absoluteString] isEqualToString:URL_getAddressDetail]
        ) {//임직원조회
        [_bodyString appendString:@"&appsvcid=SVC-00003"];
    }
    
    
	if ([[url absoluteString] isEqualToString:URL_getApprovalInfo]||//결재
		[[url absoluteString] isEqualToString:URL_getApprovalListInfo] ||
		[[url absoluteString] isEqualToString:URL_getApprovalDocInfo]|| 
		[[url absoluteString] isEqualToString:URL_getApprovalLineListInfo]|| 
		[[url absoluteString] isEqualToString:URL_getOpinionListInfo]|| 
		[[url absoluteString] isEqualToString:URL_getApprovalDecisionInfo]|| 
		[[url absoluteString] isEqualToString:URL_PaymentBadgeInfo]|| 
		[[url absoluteString] isEqualToString:URL_getAprFileDownload] 
		
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00004"];
	}
	
	if ([[url absoluteString] isEqualToString:getBoardListCollection]||//게시판
		[[url absoluteString] isEqualToString:getBoardList] ||
		[[url absoluteString] isEqualToString:getBoardDetail] ||
        [[url absoluteString] isEqualToString:getBoardDetailAttachedFileURL]
		
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00005"];
	}
	if ([[url absoluteString] isEqualToString:URL_getOrgInfo]||///조직탐색
		[[url absoluteString] isEqualToString:URL_getCompanyInfo] ||
		[[url absoluteString] isEqualToString:URL_getUserInfo]
		
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00006"];
	}
	if ([[url absoluteString] isEqualToString:URL_getStockInfo]///주가정보
		
		) {
		[_bodyString appendString:@"&appsvcid=SVC-00008"];
	}

#ifdef debugmode
	NSLog(@"######### Send String Data : %@", _bodyString);
#endif	
	
	//--- set cookie ---//
	Clipboard *clip = [Clipboard sharedClipboard];
	NSString *cookieFromClip = [clip clipKey:@"kakadais_cookie"];
	if(cookieFromClip != nil) {
		[urlRequest addValue:cookieFromClip forHTTPHeaderField:@"Cookie"];
		[urlRequest addValue:self.str_header forHTTPHeaderField:@"MobileKate"];
	}
	
	[urlRequest setHTTPBody:[_bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	[_bodyString release];
#ifdef debugmode	
	NSLog(@"######### Send NSRequest Data : %@", urlRequest);
#endif	
	
	self.finalData = nil;
	self.finalData = [[[NSMutableData alloc] init] autorelease];
	self.urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	if(self.urlConnection == nil) {
		return NO;
	}
    
    
    if(ignoreTimer != YES)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
    
	return YES;
	//[finalData release];
}

- (void)timeout:(NSTimer *)aTimer {
    if(self.urlConnection != nil)
        [self.urlConnection cancel];
    [self connection:nil didFailWithError:nil];
    [self.timer invalidate];
}

- (void)cancelCommunication {
    [self.timer invalidate];    //stop connection time out check
	if(self.urlConnection != nil)   //init url connection for cancel communication
		[self.urlConnection cancel];
}

- (void)goCommunication:(NSMutableURLRequest *)_request {
	
	NSURLResponse *urlResponse = nil;
	NSError *error = nil;
	NSData *responseData = nil;
	
	responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&urlResponse error:&error];
	if(responseData) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
		NSDictionary *fields = [httpResponse allHeaderFields];
		NSString *cookie = nil;
		cookie = [fields valueForKey:@"Set-Cookie"];
		
		if(cookie != nil) {
			Clipboard *clip = [Clipboard sharedClipboard];
			[clip clipValue:cookie clipKey:@"kakadais_cookie"];			
		}		
	}
	else {
		if (error) {
			//			[self didErrorMainTread:error];
		}		
	}	
}

- (NSString *)getHeaderString {
	//--- make header string  ---//
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSMutableString *mStr_header = [[NSMutableString alloc] init];
	NSString *tmpString;
	
	NSString *encryptString = [userDefault objectForKey:@"login_id"];
	NSData *tmpID = [Base64 decode:encryptString];
	NSString *str_ID = [[NSString alloc] initWithData:tmpID encoding:NSUTF8StringEncoding];
	
	
	tmpString = str_ID;
	if([tmpString length] > 0)
		[mStr_header appendFormat:@"%@|", tmpString];
	
	tmpString = [userDefault objectForKey:@"device_os"];
	if([tmpString length] > 0)
		[mStr_header appendFormat:@"%@|", tmpString];
	
	tmpString = [userDefault objectForKey:@"device_os_version"];
	if([tmpString length] > 0)
		[mStr_header appendFormat:@"%@|", tmpString];
	
	tmpString = [userDefault objectForKey:@"device_mac_address"];
	if([tmpString length] > 0)
		[mStr_header appendFormat:@"%@", tmpString];
	
	return (NSString *)mStr_header;
	[mStr_header release];
	[str_ID release];
}

- (BOOL) callWithArray:(NSMutableDictionary *)_arr serviceUrl:(NSString *)_url {
	
	self.str_header = [self getHeaderString];
#ifdef debugmode
	NSLog(@"########## Head String : %@", self.str_header);
#endif
	self.arr_input = _arr;
	
	BOOL rslt = [self stringWithUrl:[NSURL URLWithString:_url]];
	
	return rslt;
}
-(void)dealloc{
    
	[str_url release];
	[arr_input release];
	[str_header release];
	[finalData release]; 
	[urlConnection release];
	//[login_process release];
	
	[super dealloc];
}


@end

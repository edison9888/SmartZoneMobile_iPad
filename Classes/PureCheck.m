//
//  PureCheck.m
//  MobileOffice2.0
//
//  Created by Tsubaki on 11. 3. 12..
//  Copyright 2011 Insang. All rights reserved.
//

#import "PureCheck.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CFNetwork/CFSocketStream.h>

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>

@implementation PureCheck

/*
void MyCallBack (
				 CFSocketRef s,
				 CFSocketCallBackType callbackType,
				 CFDataRef address,
				 const void *data,
				 void *info
				 ) {
	//NSLog(@"callback!");
	//self.pureflag = 1;
}

*/

- (BOOL)isPure {
	/*
	// Get self instance
	static PureCheck *pureCheck;
	
	@synchronized(self) {
		if(!pureCheck) {
			
			pureCheck = [[PureCheck alloc] init];
		}
	}
	*/
	
	//int pureflag = 0;
	pureflag = FALSE;
	
	// First, check jailbreak apps
	
	// File path array for check
	NSArray *checkApps = [NSArray arrayWithObjects:@"/Applications/Cydia.app", @"/Applications/RockApp.app",
						  @"/Applications/Icy.app", @"/usr/bin/sshd", @"usr/libexec/sftp-server", @"/usr/sbin/sshd",
						  @"/Applications/WinterBoard.app", @"/Applications/SBSettings.app", @"/Applications/MxTube.app",
						  @"/Applications/InteliScreen.app", @"/Applications/FakeCarrier.app", @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
						  @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist", @"/private/var/lib/apt", @"/Applications/blackra1n.app",
						  @"/private/var/stash", @"/private/var/mobile/Library/SBSettings/Themes", @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
						  @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist", @"/private/var/tmp/cydia.log", @"/private/var/lib/cydia", nil];
						  
	//NSLog(@"%@", checkApps);
	NSString *filename = nil;
	NSFileHandle *fHandle = nil;
	for(filename in checkApps) {
		
		// try to open file
		//NSLog(@"check file.... : %@", filename);
		fHandle = [NSFileHandle fileHandleForReadingAtPath:filename];
		
		// if file exists, the device is jailbreaked.
		if (fHandle != nil) {
			//NSLog(@"file exists! : %@", filename);
			NSLog(@"This device is jailbreaked !!");
			pureflag = TRUE;
			[fHandle closeFile];
			return pureflag;
		}
	}
	/*
	// Second, Check some ports (21, 22, 23) are opened
	CFSocketContext context = {0, self, NULL, NULL, NULL};
	CFSocketRef cfSocket = CFSocketCreate(NULL, PF_INET, SOCK_DGRAM, 0, kCFSocketConnectCallBack, MyCallBack, &context);
	
	struct sockaddr_in theName;
	socklen_t nameLen = 0;
	nameLen = sizeof(theName);
	
	int yes = 1;
	setsockopt(CFSocketGetNative(cfSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
	// set up the IPv4 endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
	memset(&theName, 0, sizeof(theName));
	theName.sin_len = nameLen;
	theName.sin_family = AF_INET;
	theName.sin_port = 80;
	theName.sin_addr.s_addr = htonl(INADDR_ANY);
	NSData * address4 = [NSData dataWithBytes:&theName length:nameLen];
	
	if (kCFSocketSuccess != CFSocketSetAddress(cfSocket, (CFDataRef)address4)) {
		//if (error) *error = [[NSError alloc] initWithDomain:CryptoServerErrorDomain code:kCryptoServerCouldNotBindToIPv4Address userInfo:nil];
		if (cfSocket) CFRelease(cfSocket);
		cfSocket = NULL;
		//return;
	}
	
	// now that the binding was successful, we get the port number 
	// -- we will need it for the NSNetService
	NSData * addr = [(NSData *)CFSocketCopyAddress(cfSocket) autorelease];
	memcpy(&theName, [addr bytes], [addr length]);
	uint16_t chosenPort = ntohs(theName.sin_port);
	
	
	/*
	struct hostent *hp;
	
	theName.sin_port = htons(80);
	theName.sin_family = AF_INET;
	
	hp = genhostbyname("naver.com");
	if (hp == NULL) {
		// fail!
	}
	
	
	memcpy(&theName.sin_addr.s_addr, hp->h_addr_list[0], hp->h_length);
	CFDataRef addressData = CFDataCreate(NULL, &theName, sizeof(struct sockaddr_in));
	CFSocketConnectToAddress(cfSocket, addressData, 10);
	
	CFRunLoopSourceRef FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, cfSocket, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes);
	
	if (CFSocketIsValid(cfSocket)) {
		pureflag = 1;
	}
	*/
	return pureflag;
}

@end

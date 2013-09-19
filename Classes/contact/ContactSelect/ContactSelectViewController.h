//
//  TokenFieldExampleViewController.h
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "TFUIViewController.h"
#import "TITokenFieldView.h"
#import "CalendarModel.h"
#import "ContactModel.h"

@interface ContactSelectViewController : TFUIViewController <TITokenFieldViewDelegate, CommunicationDelegate, UITextViewDelegate> {

	TITokenFieldView * tokenFieldView;
	UITextView * messageView;
	
	CGFloat keyboardHeight;
	
	CalendarModel *model;
    
    // data
	ContactModel *contactModel; //연락처 메인 인스턴스 모델
    
    IBOutlet UIActivityIndicatorView *indicator; //인디케이터
	Communication *clipboard; //통신모듈
    
    NSString *delegate_flag;
    
    NSMutableArray *tempTokensArray;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Communication *clipboard;
@property (nonatomic, retain) NSString *delegate_flag;
@property (nonatomic, retain) NSMutableArray *tempTokensArray;

-(void)loadContactData;

@end


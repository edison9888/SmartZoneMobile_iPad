//
//  RejectController.h
//  MobileOffice2.0
//
//  Created by 진정원 on 11. 3. 14..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"
#import "URL_Define.h"



@interface RejectController : UIViewController<UITextViewDelegate> {
	IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UIBarButtonItem *rejectButton;
	
	IBOutlet UITextView *tf_rejectComment;
	
	NSDictionary *dic_selectedItem;
	NSString *selectedCategory;
	
	UIActivityIndicatorView *indicator;
	
	Communication *cm;
	
	IBOutlet UIBarButtonItem *rightBarButton;
	IBOutlet UILabel *textLabel1;
	IBOutlet UILabel *textLabel2;
	
	BOOL flag_approval;
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rejectButton;
@property(nonatomic,retain) NSDictionary *dic_selectedItem;
@property(nonatomic,retain) NSString *selectedCategory;
@property(nonatomic) BOOL flag_approval;

- (IBAction)btn_reject;
- (void)go_reject;
-(IBAction) cancelButtonClicked;
//-(IBAction) rejectButtonClicked;


@end

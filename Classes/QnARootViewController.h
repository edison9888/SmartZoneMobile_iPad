//
//  QnARootViewController.h
//  MobileKate_iPad
//
//  Created by park on 11. 2. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

#define PCOUNT @"20"

@class QnADetailViewController;

@interface QnARootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CommunicationDelegate> {

	UIBarButtonItem *askButton;
	
	NSMutableArray *menuList;
	UITableView *tableList;
	
	NSArray *pickerList;
	int currentPage;
	BOOL searchingMode;
	BOOL morePageFlag;
	
	UIView *pickerBody;
	UIPickerView *pickerView;
	
	UIButton *pickerButton;
	UILabel *pickerLabel;
	UITextField *searchField;
	UIButton *searchButton;
	UIButton *nextButton;
	
	UITableViewCell *nextCell;
	
	UIActivityIndicatorView *indicatorView;
	Communication *clipboard;
	
	QnADetailViewController *detailViewController;
	BOOL reloadflag;
	
	IBOutlet UIToolbar *pickerToolbar;
	IBOutlet UIBarButtonItem *pickerSelectButton;
}

@property(nonatomic,retain) IBOutlet UIBarButtonItem *askButton;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) IBOutlet UITableView *tableList;
@property (nonatomic, retain) QnADetailViewController *detailViewController;

@property (nonatomic, retain) NSArray *pickerList;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL searchingMode;
@property (nonatomic, assign) BOOL morePageFlag;

@property (nonatomic, retain) IBOutlet UIView *pickerBody;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *pickerButton;
@property (nonatomic, retain) IBOutlet UILabel *pickerLabel;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *nextCell;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) Communication *clipboard;
@property(nonatomic,assign) BOOL reloadflag;

@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pickerSelectButton;

-(IBAction) askButtonClicked;

-(IBAction) pickerButtonClicked;
-(IBAction) searchButtonClicked;
-(IBAction) resignKeyboardnPicker;
-(IBAction) nextCellClicked;
-(void) loadData;
- (void)registerForKeyboardNotifications;
//-(void) setReloadYes;

@end

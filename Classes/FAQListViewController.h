//
//  FAQListViewController.h
//  MobileKate2.0_iPad
//
//  Created by Insang Park on 11. 6. 21..
//  Copyright 2011 Insang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Communication.h"

#define MAXROW @"20"

@class FAQDetailViewController;

@interface FAQListViewController : UIViewController<CommunicationDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>  {

	UITableView *dataTable;
	UIActivityIndicatorView *indicator;
	NSMutableArray *faqList;
	NSString *boardId;
	NSString *orderBy;
	NSString *sortBy;
	UITableViewCell *nextCell;
	
	int currentPage;
	Communication *clipboard;
	BOOL morePageFlag;
	
	FAQDetailViewController *detailViewController;
	
	UIBarButtonItem *askButton;
	NSArray *pickerList;
	BOOL searchingMode;
	
	NSArray *categoryList;
	
	UIView *pickerBody;
	UIPickerView *pickerView;
	
	UIButton *pickerButton;
	UILabel *pickerLabel;
	UITextField *searchField;
	UIButton *searchButton;
	UIButton *nextButton;
	
	//UIActivityIndicatorView *indicatorView;
	BOOL reloadflag;
	
	int deleteIndex;
	BOOL deleteFlag;
	
	IBOutlet UIToolbar *pickerToolbar;
	IBOutlet UIBarButtonItem *pickerSelectButton;
	
	NSNotificationCenter *noti;
	
}

@property (nonatomic, retain) IBOutlet UITableView *dataTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableArray *faqList;
@property (nonatomic, retain) NSString *boardId;
@property (nonatomic, retain) NSString *orderBy;
@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) IBOutlet UITableViewCell *nextCell;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) Communication *clipboard;
@property (nonatomic, assign) BOOL morePageFlag;

@property (nonatomic,retain) FAQDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

@property (nonatomic,retain) IBOutlet UIBarButtonItem *askButton;
@property (nonatomic, retain) NSArray *pickerList;
@property (nonatomic, assign) BOOL searchingMode;

@property (nonatomic, retain) IBOutlet UIView *pickerBody;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *pickerButton;
@property (nonatomic, retain) IBOutlet UILabel *pickerLabel;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

@property (nonatomic,assign) BOOL reloadflag;
@property (nonatomic,assign) BOOL deleteFlag;

@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pickerSelectButton;

@property (nonatomic, retain) NSArray *categoryList;

-(IBAction) askButtonClicked;

-(IBAction) pickerButtonClicked;
-(IBAction) searchButtonClicked;
-(IBAction) resignKeyboardnPicker;

-(void) loadData;

-(void)registerForKeyboardNotifications;


-(IBAction) nextCellClicked;



@end

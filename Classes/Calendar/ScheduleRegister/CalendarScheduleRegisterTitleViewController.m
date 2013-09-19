//
//  CalendarScheduleRegisterTitleViewController.m
//  TFTest
//
//  Created by 승철 강 on 11. 6. 16..
//  Copyright 2011 .NetTree. All rights reserved.
//

#import "CalendarScheduleRegisterTitleViewController.h"
#import "CalendarScheduleRegisterTitleListCell.h"

@implementation CalendarScheduleRegisterTitleViewController

@synthesize tableView1;
@synthesize textField1;	// 제목
@synthesize textField2;	// 위치


#pragma mark -
#pragma mark CallBack Method
- (void)naviRigthbtnPress:(id)sender {
	
	// 변한 데이터를 모델에 저장한다.
	model.registerTitle	   = self.textField1.text;
	model.registerLocation = self.textField2.text;
	
	// 일정 등록 화면으로 이동한다.
	[super popViewController];
}

#pragma mark -
#pragma mark UITextFieldDelegate Implement

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if ([textField isEqual:self.textField1]) {
		[self.textField2 becomeFirstResponder];
	} else if ([textField isEqual:self.textField2]) {
		[self naviRigthbtnPress:nil];
	}
	
	return YES;
	
}

#pragma mark -
#pragma mark UITableViewDelegate Implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 80.0;	// CalendarScheduleRegisterTitleListCell.xib에 설정되어있는 height
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -
#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarScheduleRegisterTitleListCell" owner:self options:nil];
		
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:NSClassFromString(@"CalendarScheduleRegisterTitleListCell")]) {
				cell = oneObject;
			}
		}
		
	}
	
	CalendarScheduleRegisterTitleListCell *tmpCell = (CalendarScheduleRegisterTitleListCell *)cell;
	
	if (indexPath.row == 0) {
		self.textField1 = tmpCell.textField1;
		
		self.textField1.delegate = self;
		self.textField1.placeholder = NSLocalizedString(@"btn_title",@"제목");
		self.textField1.text = model.registerTitle;
		[self.textField1 becomeFirstResponder];
	} else {
		self.textField2 = tmpCell.textField1;
		
		self.textField2.delegate = self;
		self.textField2.placeholder = NSLocalizedString(@"calendar_place",@"위치");
		self.textField2.text = model.registerLocation;
	}

	
	return cell;
	
}

#pragma mark -
#pragma mark XCode Generated
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = NSLocalizedString(@"calendar_subject_and_location",@"제목 및 위치");
    
	// 왼쪽 취소
	[super makeNavigationLeftBarButtonWithTitle:NSLocalizedString(@"btn_cancel",@"취소") style:UIBarButtonItemStylePlain];
	
	// 오른쪽 완료
	[super makeNavigationRightBarButtonWithTitle:NSLocalizedString(@"btn_done",@"완료") style:UIBarButtonItemStylePlain];
	
	model = [CalendarModel sharedInstance];
	
	[self.tableView1 reloadData];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tableView1 = nil;
	self.textField1 = nil;	// 제목
	self.textField2 = nil;	// 위치
}


- (void)dealloc {
	
	[tableView1 release];
	[textField1 release];	// 제목
	[textField2 release];	// 위치

	
    [super dealloc];
}


@end

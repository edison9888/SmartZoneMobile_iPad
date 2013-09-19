//
//  OpinionViewController.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpinionViewController.h"


@implementation OpinionViewController
@synthesize dic_selectedItem, arr_approvalopinioninfo, selectedCategory;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 100) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)cancelButton {
	
	[self dismissModalViewControllerAnimated:YES];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(self.arr_approvalopinioninfo == nil || [self.arr_approvalopinioninfo count] == 0) {
		return 1;
	}
	else {
		return [self.arr_approvalopinioninfo count];
	}
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([arr_size count] <= 0) {
		return 44;
	}
	else {
		return [(NSNumber *)[arr_size objectAtIndex:indexPath.row] intValue] + 50;
	}
	
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
	if (self.arr_approvalopinioninfo == nil || [self.arr_approvalopinioninfo count] == 0) {
		cell = noDataCell;
		
	} else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell...
		NSDictionary *dic_tmp = [self.arr_approvalopinioninfo objectAtIndex:indexPath.row];
		
		UITextView *titleView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
		titleView.font = [UIFont fontWithName:@"Helvetica" size:15];
		titleView.text = [dic_tmp objectForKey:@"username"];
		titleView.editable = NO;
		
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 25, 320, [(NSNumber *)[arr_size objectAtIndex:indexPath.row] intValue] + 25)];
		textView.font = [UIFont fontWithName:@"Helvetica" size:12];
		textView.text = [dic_tmp objectForKey:@"content"];
		textView.editable = NO;
		
		[cell addSubview:titleView];
		[cell addSubview:textView];
		
		
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}


-(void)willStartCommunication:(id *)param1 requestDictionary:(NSMutableDictionary *)_dic {
	indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.hidesWhenStopped = YES;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
	indicator.center = self.view.center;
	
	[indicator startAnimating];
	
}


-(void)didEndCommunication:(NSDictionary *)_resultDic requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
	
	NSDictionary *resultDic = (NSDictionary *)[_resultDic objectForKey:@"result"];
	
	//NSLog(@"OpinionViewController result : %@", resultDic);
	
	NSString *rsltCode = [resultDic objectForKey:@"code"];
	if(rsltCode == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;		
	}	
	
	if([rsltCode intValue] == 0){
		//--- save document list
		self.arr_approvalopinioninfo = [_resultDic objectForKey:@"approvalopinioninfo"];
//		[self.arr_approvalopinioninfo addObject:[self.arr_approvalopinioninfo objectAtIndex:0]];
		
		NSDictionary *dic_tmp;
		NSString *str_content;
		
		UITextView *tmpView;
		NSNumber *tmpNumber;
        
        //--- 의견 없을 시 팝업
        if(self.arr_approvalopinioninfo == nil || [self.arr_approvalopinioninfo count] <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"해당 문건에 의견이 없습니다."
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            
            [alert show];
            alert.tag = 100;
            [alert release];
            return;
        }
		
		//--- cell 별 height 계산
		for(int i = 0; i < [self.arr_approvalopinioninfo count]; i++) {
			dic_tmp = [self.arr_approvalopinioninfo objectAtIndex:i];
			
			str_content = [dic_tmp objectForKey:@"content"];
			
			tmpView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			tmpView.font = [UIFont fontWithName:@"Helvetica" size:12];
			tmpView.editable = NO;
			tmpView.text = str_content;
			
			
			newSize = [tmpView.text
					   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]
					   constrainedToSize:CGSizeMake(320,99999)
					   lineBreakMode:UILineBreakModeWordWrap];
			
			tmpNumber = [[NSNumber alloc] initWithFloat:newSize.height];
			
			[arr_size addObject:tmpNumber];
			[tmpView release];
			
		}
		
		[currentTableView reloadData];
		
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];	
		[alert release];
		return;		
	}
	
}

-(void)didErrorCommunication:(NSError *)error requestDictionary:(NSMutableDictionary *)_dic {
	[indicator stopAnimating];
}

-(void)viewWillDisappear:(BOOL)animated {
	[indicator stopAnimating];
	if (cm != nil) {
		[cm cancelCommunication];
	}	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	currentTableView.allowsSelection = NO;
	
	switch ([self.selectedCategory intValue]) {
		case 1: //category 1 결재할 문서
			self.title = @"결재할 문서";
			break;
		case 2: //category 2 결재한 문서
			self.title = @"결재한 문서";
			break;
		case 9:	//category 9 수신문서
			self.title = @"수신문서";
			break;
		case 10: // category 10 부서수신문서
			self.title = @"부서수신문서";
			break;
		case 5:	// category 5 기안한 문서
			self.title = @"기안한 문서";
			break;
		default:
			break;
	}
	

	cm = [[Communication alloc] init];
	[cm setDelegate:self];
	
	NSMutableDictionary *loginRequest = [[NSMutableDictionary alloc] init];
	[loginRequest  setObject:[self.dic_selectedItem objectForKey:@"docid"] forKey:@"docid"]; 
	[loginRequest  setObject:@"1" forKey:@"opiniontype"]; // 1:전체 2:발신 3:수신
	int rslt = [cm callWithArray:loginRequest serviceUrl:URL_getOpinionListInfo];
	if(rslt != YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크를 확인해 주십시오"
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
		
		[alert show];
		[alert release];
		return;
	}
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

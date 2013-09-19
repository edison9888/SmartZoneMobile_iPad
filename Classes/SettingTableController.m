//
//  SettingController.m
//  MobileOffice2.0
//
//  Created by park on 11. 2. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingTableController.h"

#import "SettingPinController.h"
#import "SettingAccountController.h"
#import "SettingHelpController.h"
#import "SettingPushController.h"
#import "MainMenuController.h"

#import "ContactDefaultSetting.h"
#import "SettingBoardController.h"
#import "LogInController.h"


@implementation SettingTableController

@synthesize menuList;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(void)action_home {

	
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
/*
	[self.view removeFromSuperview];
	[self.navigationController.view removeFromSuperview];
	[self.navigationController release];
	
	
	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"returnHomeView" object:self];
	 */
	
	[self dismissModalViewControllerAnimated:YES];
	
	if ([appdelegate.window.rootViewController isKindOfClass:[MainMenuController class]]) {
		
		//NSLog(@"Class : %@", appdelegate.window.rootViewController);
		//if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft || [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
			//NSLog(@"reload");
			[(MainMenuController *)appdelegate.window.rootViewController firstComm];
		/*
		} else {
			
		}*/

	}

}

-(void)viewDidLoad {
	self.title = @"환경설정";
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(action_home)];
	self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	self.menuList = [NSMutableArray array];
	[self.menuList addObject:@"1. PIN 인증 설정"];
	[self.menuList addObject:@"2. 사용자 계정 설정"];
    [self.menuList addObject:@"3. 주소록 설정"];	
    [self.menuList addObject:@"4. 게시판 설정"];
//	[self.menuList addObject:@"3. 알림 설정"];
	[self.menuList addObject:@"5. 이용 안내"];
    [self.menuList addObject:@"6. 로그 아웃"];

	[super viewDidLoad];
}

- (void)dealloc
{
	[menuList dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//-(IBAction)action_barBtn_home {
//	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
//	appdelegate.window.rootViewController = nil;
//	[self.navigationController release];
//	
//	NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
//	[noti postNotificationName:@"returnHomeView" object:self];	
//}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	@try
	{
		Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
		id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
		[activeInstance performSelector:@selector(dismissKeyboard)];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"%@", exception);
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [self.menuList objectAtIndex:[indexPath row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	SettingPinController *settingPinController;
	SettingAccountController *settingAccountController;
	SettingHelpController *settingHelpController;
	SettingPushController *settingPushController = nil;

    
	ContactDefaultSetting *contactDefaultSetting;
    SettingBoardController *settingBoardController;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"로그아웃 하시겠습니까?" 
												   delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];

    
    
    
	switch ([indexPath row]) {
		case 0:
			//SettingPinController *
			settingPinController = [[SettingPinController alloc] initWithNibName:@"SettingPinController" bundle:nil];
			[self.navigationController pushViewController:settingPinController animated:YES];
			[settingPinController release];
			break;
		case 1:
			//SettingAccountController *
			settingAccountController = [[SettingAccountController alloc] initWithNibName:@"SettingAccountController" bundle:nil];
			[self.navigationController pushViewController:settingAccountController animated:YES];
			[settingAccountController release];
			break;
		case 2:
			//SettingHelpController *
//			settingPushController = [[SettingPushController alloc] initWithNibName:@"SettingPushController" bundle:nil];
//			[self.navigationController pushViewController:settingPushController animated:YES];
//			[settingPushController release];
			contactDefaultSetting = [[ContactDefaultSetting alloc] initWithNibName:@"ContactDefaultSetting" bundle:nil];
            [self.navigationController pushViewController:contactDefaultSetting animated:YES];
			[contactDefaultSetting release];

            break;
		case 3:
            settingBoardController = [[SettingBoardController alloc] initWithNibName:@"SettingBoardController" bundle:nil];
            [self.navigationController pushViewController:settingBoardController animated:YES];
			[settingBoardController release];
            break;
        case 4:
			//SettingHelpController *
			settingHelpController = [[SettingHelpController alloc] initWithNibName:@"SettingHelpController" bundle:nil];
			[self.navigationController pushViewController:settingHelpController animated:YES];
			[settingHelpController release];
			break;
            
        case 5:
            alert.tag = 999;
            [alert show];
            [alert release];

            break;
		default:
			break;
	}
	
	 /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) // "취소" 버튼
    {
        // 처리 내용
        ////NSLog(@"cancel");
    }
    else // buttonIndex == 0 // "확인" 버튼
    {
		if(alertView.tag == 999) {
			NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
			[userDefault removeObjectForKey:@"login_id"];
			[userDefault removeObjectForKey:@"login_password"];
			[userDefault synchronize]; 
            
            
            MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
            /*
             [self.view removeFromSuperview];
             [self.navigationController.view removeFromSuperview];
             [self.navigationController release];
             
             
             NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
             [noti postNotificationName:@"returnHomeView" object:self];
             */
            
            [self dismissModalViewControllerAnimated:YES];
            
            
            [self.view.superview removeFromSuperview];
            [self.view removeFromSuperview];
            
            CATransition *myTransition = [CATransition animation];
            myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
            myTransition.type = kCATransitionPush;
            myTransition.subtype = kCATransitionFromLeft;
            myTransition.duration = 0.25;	
            [appdelegate.window.layer addAnimation:myTransition forKey:nil];
            
            appdelegate.window.rootViewController = nil;
            LogInController *loginController = [[LogInController alloc]initWithNibName:@"LogInController" bundle:nil];
            appdelegate.window.rootViewController = loginController;
            
            
            
            

		}
        
        
        
	}
}

@end

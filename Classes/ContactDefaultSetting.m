//
//  ContactDefaultSetting.m
//  MobileOffice2.0
//
//  Created by Kyung Wook Baek on 11. 6. 29..
//  Copyright 2011 ktds. All rights reserved.
//

#import "ContactDefaultSetting.h"


@implementation ContactDefaultSetting

@synthesize sectionArray;
@synthesize sectionTitleArray;
@synthesize menuList;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"주소록 설정";
	self.menuList = [NSMutableArray array];
	[self.menuList addObject:@"임직원"];
	[self.menuList addObject:@"내연락처"];
	[self.menuList addObject:@"폰북"];
	

//	sectionArray = [[NSArray alloc] initWithObjects:menuList], [nil];
//	sectionTitleArray = [[NSArray alloc] initWithObjects:@"Option1"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier=@"MyIdentifier";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if(cell==nil){
		cell=[[[UITableViewCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:MyIdentifier]autorelease];
	
	}
	cell.textLabel.text = [self.menuList objectAtIndex:[indexPath row]];
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *contactDefault = [userDefault objectForKey:@"ContactDefault"];
	if ([contactDefault length] <= 0 || contactDefault == nil ) {
		if(indexPath.row == 0)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
//		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

	}else {
		if (indexPath.row == [[userDefault objectForKey:@"ContactDefault"] intValue]-1) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
//			[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	}

	
	
	
//	if( selectionIndex == indexPath.row ){
//		cell.accessoryType = UITableViewCellAccessoryCheckmark;
//	} else {
//		cell.accessoryType = UITableViewCellAccessoryNone;
//	}
	
//	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { 
//		cell.accessoryType = UITableViewCellAccessoryNone; 
//	}else if (cell.accessoryType == UITableViewCellAccessoryNone) { 
//		cell.accessoryType = UITableViewCellAccessoryCheckmark; 
//	} 
	
	
	
	return cell;     
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"디폴트 설정";
	}

	return sectionHeader;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate
- (void) deselect
{	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//	[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows]] setAccessoryType:UITableViewCellAccessoryNone];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	printf("User selected row %d\n", [newIndexPath row] + 1);
//	NSLog(newIndexPath);
//	if ([[tableView cellForRowAtIndexPath:newIndexPath] accessoryType] == UITableViewCellAccessoryCheckmark)
//		[[tableView cellForRowAtIndexPath:newIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];	
//	else
//		[[tableView cellForRowAtIndexPath:newIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

		
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:newIndexPath];
	
    for (NSInteger idx=0; idx < [self.menuList count]; idx++) {
        UITableViewCell* idxCell = nil;
        idxCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        if ([newIndexPath row] == idx) {
            idxCell.accessoryType =UITableViewCellAccessoryCheckmark;
			NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
			[userDefault setObject:[NSString stringWithFormat:@"%d", newIndexPath.row +1] forKey:@"ContactDefault"];
			[userDefault synchronize];

        }
        else {
            idxCell.accessoryType =UITableViewCellAccessoryNone;
        }
    }
		//셀 선택을 해제한다.
    [cell setSelected:NO animated:YES];
		
		//	[[tableView cellForRowAtIndexPath:newIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];	
//	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//	[userDefault setObject:[NSString stringWithFormat:@"%d", newIndexPath.row +1] forKey:@"ContactDefault"];
//			//[requestDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
//	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
//	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
//	[self.tableView reloadData];

}
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[menuList dealloc];

    [super dealloc];
}


@end


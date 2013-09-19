	//
	//  AFOpenFlowViewController.m
	//  Smc
	//
	//  Created by SangMin Wang on 10. 4. 20..
	//  Copyright 2010 __MyCompanyName__. All rights reserved.
	//
#import "MobileKate2_0_iPadAppDelegate.h"
#import "AFOpenFlowViewController.h"
#import "UIImageExtras.h"
#import "Clipboard.h"
#import "MainMenuController.h"
@implementation AFOpenFlowViewController

//#define FLOW_MAX 18
#define FLOW_MAX 7

@synthesize label;
@synthesize button;
@synthesize monthLabel;
@synthesize dateLabel;

	// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			// Custom initialization
			//NSLog(@"AFOpenFlow!!!! initWithNibName");
		
    }
    return self;
}



	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		//NSLog(@"AFOpenFlow!!!! viewDidLoad");
	NSString *imageName;
	for (int i=1; i < FLOW_MAX+1; i++) {
		
		
//		imageName = [[NSString alloc] initWithFormat:@"%d.cover.png", i];
        imageName = [[NSString alloc] initWithFormat:@"icon_cover0%d.png", i];

		[(AFOpenFlowView *)self.view setImage:[UIImage imageNamed:imageName] forIndex:i-1];
		[imageName release];
	}
	[(AFOpenFlowView *)self.view setNumberOfImages:FLOW_MAX]; 
	[self.view addSubview:button];
//	label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 55)];
//	label.font = [UIFont systemFontOfSize:18.0];
//	label.backgroundColor = [UIColor clearColor];
//	label.textColor = [UIColor blackColor];
//	label.textAlignment = UITextAlignmentCenter;
//
//		[label setText:@"나의정보"];
//			[self.view addSubview:label ];

}

/*
 - (void)awakeFromNib {
 
 NSString *imageName;
 for (int i=1; i < 6; i++) {
 imageName = [[NSString alloc] initWithFormat:@"login_icon_0%d.png", i-1];
 [(AFOpenFlowView *)self.view setImage:[UIImage imageNamed:imageName] forIndex:i];
 [imageName release];
 }
 [(AFOpenFlowView *)self.view setNumberOfImages:6]; 
 
 label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
 label.font = [UIFont systemFontOfSize:15.0];
 label.backgroundColor = [UIColor clearColor];
 label.textColor = [UIColor blackColor];
 label.textAlignment = UITextAlignmentCenter;
 
 [label setText:@"My정보"];
 [self.view addSubview:label ];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration { 

	//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	MainMenuController *mainController = [[MainMenuController alloc] init];
	MobileKate2_0_iPadAppDelegate *appdelegate = (MobileKate2_0_iPadAppDelegate *)[[UIApplication sharedApplication] delegate];
	CATransition *myTransition = [CATransition animation];
	
	switch (self.interfaceOrientation) {
			
		case UIDeviceOrientationPortrait:
			appdelegate.window.rootViewController = mainController;
			[self.view removeFromSuperview];

			myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
			myTransition.type = kCATransitionFade;
			myTransition.duration = 0.125;
			[self.view.layer addAnimation:myTransition forKey:nil];			
			
			break;
			
		case UIDeviceOrientationPortraitUpsideDown:
			appdelegate.window.rootViewController = mainController;
			[self.view removeFromSuperview];

			myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
			myTransition.type = kCATransitionFade;
			myTransition.duration = 0.125;
			[self.view.layer addAnimation:myTransition forKey:nil];			
			
			
			break;
		
		case UIDeviceOrientationLandscapeLeft:
			
			
			break;
		case UIDeviceOrientationLandscapeRight:
			
			
			break;
			
			
	}
	
}
- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
	
		// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[loadImagesOperationQueue release];
	[interestingPhotosDictionary release];
    [super dealloc];
}


- (void)imageDidLoad:(NSArray *)arguments {
	UIImage *loadedImage = (UIImage *)[arguments objectAtIndex:0];
	NSNumber *imageIndex = (NSNumber *)[arguments objectAtIndex:1];
	[(AFOpenFlowView *)self.view setImage:loadedImage forIndex:[imageIndex intValue]];
    
}


- (UIImage *)defaultImage {
	return [UIImage imageNamed:@"default.png"];
}


- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidMoveOn:(int)index {
		//NSLog(@"이동된  커버플로우 ========> %d", index);
	NSString *imagesIndex = [NSString stringWithFormat:@"%d",index];
	Clipboard *clip = [Clipboard sharedClipboard];
	[clip clipValue:imagesIndex clipKey:@"imageMoveBadge"];
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"imageMoveBadge" object:self];
    if (dateLabel != nil) {
        [dateLabel removeFromSuperview];
        dateLabel = nil;
        [monthLabel removeFromSuperview];
        monthLabel = nil;
    }
	 
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
		//NSLog(@"선택된 ss커버플로우 ========> %d", index);
	NSString *selectionIndex = [NSString stringWithFormat:@"%d",index];
	Clipboard *clip = [Clipboard sharedClipboard];
	[clip clipValue:selectionIndex clipKey:@"imageIndexBadge"];
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"imageSelectBadge" object:self];
    
    if (index == 3) {
        if (dateLabel==nil) {
//            monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(420, 275, 100, 55)];
            monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(395, 310, 100, 55)];

            monthLabel.font = [UIFont boldSystemFontOfSize:30.0];
            monthLabel.backgroundColor = [UIColor clearColor];
            monthLabel.textColor = [UIColor blackColor];
            monthLabel.textAlignment = UITextAlignmentCenter;
            
            [self.view addSubview:monthLabel ];
            
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(455, 290, 150, 100)];
            dateLabel.font = [UIFont boldSystemFontOfSize:90.0];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.textColor = [UIColor blackColor];
            dateLabel.textAlignment = UITextAlignmentCenter;
            
            [self.view addSubview:dateLabel ];

            
            NSDate *now = [[NSDate alloc] init];
            NSLog(@"asdh;flaksdf%@", now);
            
            // 날짜 포맷.
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];
            
            
            NSString *theDate = [dateFormat stringFromDate:now];
//            NSLog(@"theDate[%@]",theDate);
            NSArray *tempArray = [theDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
            NSString *stringMonth =  [tempArray objectAtIndex:0];
            NSString *stringDay =  [tempArray objectAtIndex:1];
            if ([stringMonth isEqualToString:@"01"]) {
                monthLabel.text = @"JAN";
            }else if([stringMonth isEqualToString:@"02"]){
                monthLabel.text = @"FEB";
            }else if([stringMonth isEqualToString:@"03"]){
                monthLabel.text = @"MAR";
            }else if([stringMonth isEqualToString:@"04"]){
                monthLabel.text = @"APR";
            }else if([stringMonth isEqualToString:@"05"]){
                monthLabel.text = @"MAY";
            }else if([stringMonth isEqualToString:@"06"]){
                monthLabel.text = @"JUN";
            }else if([stringMonth isEqualToString:@"07"]){
                monthLabel.text = @"JUL";
            }else if([stringMonth isEqualToString:@"08"]){
                monthLabel.text = @"AUG";
            }else if([stringMonth isEqualToString:@"09"]){
                monthLabel.text = @"SEP";
            }else if([stringMonth isEqualToString:@"10"]){
                monthLabel.text = @"OCT";
            }else if([stringMonth isEqualToString:@"11"]){
                monthLabel.text = @"NOV";
            }else if([stringMonth isEqualToString:@"12"]){
                monthLabel.text = @"DEC";
            }
            
            
            dateLabel.text =  stringDay;
            
            
            
            
            
            [dateFormat release];
            [now release];

        }

    }else{
        if (dateLabel != nil) {
            [dateLabel removeFromSuperview];
            dateLabel = nil;
            [monthLabel removeFromSuperview];
            monthLabel = nil;
        }
    }
    
    
//    if (index == 4) {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 55)];
//        label.font = [UIFont systemFontOfSize:18.0];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = UITextAlignmentCenter;
//        
//        [label setText:@"나의정보"];
//        [self.view addSubview:label ];
//
//    }else{
//        if (label) {
//            [label removeFromSuperview];
//            label = nil;
//        }
//    }

	
}
- (void)openFlowView:(AFOpenFlowView *)openFlowView imageSelected:(int)index {
		//NSLog(@"선택된 이미지 ========> %d", index);
	NSString *imagedIndex = [NSString stringWithFormat:@"%d",index];
	Clipboard *clip = [Clipboard sharedClipboard];
	[clip clipValue:imagedIndex clipKey:@"imageIndex"];
	noti = [NSNotificationCenter defaultCenter];
	[noti postNotificationName:@"imageSelect" object:self];	

} 

- (void)setSelectedCover:(int)newSelectedCover {
	[(AFOpenFlowView *)self.view setSelectedCover:newSelectedCover];
	[(AFOpenFlowView *)self.view centerOnSelectedCover:YES];
	[self openFlowView:nil selectionDidChange:newSelectedCover];
		//NSLog(@"selectedcoverintnew");
}

- (void) coverViewMoveRight {
	int index ;
	index = [(AFOpenFlowView *)self.view getSelectedCoverViewIndex] ; 
	
	if( index >= FLOW_MAX-1 ) {
		[self setSelectedCover:FLOW_MAX-1 ];
	}
	else {
		[self setSelectedCover:index+1 ];
	}
}

- (void) coverViewMoveLeft {
	int index ;
	index = [(AFOpenFlowView *)self.view getSelectedCoverViewIndex] ; 
	
	if( index <= 0 ) {
		[self setSelectedCover:0 ];
	}
	else {
		[self setSelectedCover:index-1 ];
	}
	
}

- (void)setDelegate:(id)sender {
	[(AFOpenFlowView *)self.view setDelegate:sender];	
}


@end

//
//  AlertPrompt.m
//  MobileOffice2.0
//
//  Created by nicejin on 11. 3. 3..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "AlertPrompt.h"

@implementation AlertPrompt
@synthesize textField;
@synthesize enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
//		UI *theLabel = [[UITextField alloc] init];
//		theLabel.text = @"aaaa";
//		[self addSubview:theLabel];
		
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
		theTextField.placeholder = @"ddd";
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 0.0); 
        [self setTransform:translate];
    }
    return self;
}
- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}
- (void)dealloc
{
    [textField release];
    [super dealloc];
}
@end

//
//  ContentCell.m
//  Tapatalk
//
//  Created by Manuel Burghard on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface UITextView (Additions)
@end

@class WebView, WebFrame;
@protocol WebPolicyDecisionListener

- (BOOL)textView:(UITextView *)textView shouldLoadRequest:(NSURLRequest *)request;

@end

@implementation UITextView (Additions)

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    [self.delegate textView:self shouldLoadRequest:request];
}
@end

#import "ContentCell.h"


@implementation ContentCell
@synthesize textView, delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0,20.0, 700, self.frame.size.height-20)];
        NSLog(@"%@", self.textView.frame.size.width);
        self.textView.editable = NO;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;

        self.textView.bounces = NO;
        self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
        self.textView.delegate = self;
    
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textView.text = nil;
}

- (void)layoutSubviews { // Only for debugging 
    [super layoutSubviews];
}

- (void)dealloc {
    [textView release];
    self.delegate = nil;
    self.textView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)aTextView {
    if (self.delegate) {
        [self.delegate contentCellDidBeginEditing:self];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
	if (self.delegate) {
        [self.delegate contentCellDidChange:self];
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [aTextView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldLoadRequest:(NSURLRequest *)request {
    return [self.delegate contentCell:self shouldLoadRequest:request];
}

- (void)textViewDidChangeSelection:(UITextView *)aTextView{
	if (self.delegate) {
        [self.delegate contentCellDidChangeChangeSelection:self];
    }
	
}

@end

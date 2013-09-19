//
//  TFUITextView.h
//  TFTest
//
//  Created by 승철 강 on 11. 5. 12..
//  Copyright 2011 두베. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    TFTextViewLeftTopRoundedCorner     = 1 <<  0,
    TFTextViewRightTopRoundedCorner    = 1 <<  1,
    TFTextViewLeftBottomRoundedCorner  = 1 <<  2,
    TFTextViewRightBottomRoundedCorner = 1 <<  3,
};
typedef NSUInteger TFTextViewStyle;

#define TFTextViewRoundedCornerStyle        ( TFTextViewLeftTopRoundedCorner | TFTextViewRightTopRoundedCorner | TFTextViewLeftBottomRoundedCorner | TFTextViewRightBottomRoundedCorner )
#define TFTextViewTopRoundedCornerStyle     ( TFTextViewLeftTopRoundedCorner | TFTextViewRightTopRoundedCorner )
#define TFTextViewBottomRoundedCornerStyle  ( TFTextViewLeftBottomRoundedCorner | TFTextViewRightBottomRoundedCorner )



@interface TFUITextView : UIView <UITextViewDelegate> {
	TFTextViewStyle  _style;
	UIColor*		 _color;
	CGFloat			 _radius;
	
	UITextView *textView;
	id <UITextViewDelegate> delegate;
	
	NSString *text;
	UIFont	 *font;
	UIColor  *textColor;

	BOOL isInitialize;
	
	CGColorRef _initColor;
}

@property (retain,nonatomic) UIColor*			color;
@property (       nonatomic) TFTextViewStyle	style;
@property (       nonatomic) CGFloat			radius;

@property (nonatomic, assign) NSString*			text;
@property (nonatomic, assign) UIFont*			font;
@property (nonatomic, assign) UIColor*			textColor;

@property (nonatomic, assign) id <UITextViewDelegate> delegate;


@end

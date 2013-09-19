//
//  TFUITextView.m
//  TFTest
//
//  Created by 승철 강 on 11. 5. 12..
//  Copyright 2011 두베. All rights reserved.
//

#import "TFUITextView.h"


@implementation TFUITextView

@synthesize color  = _color;
@synthesize style  = _style;
@synthesize radius = _radius;
@synthesize textColor;

#pragma mark -
#pragma mark Properties Method

- (void)setText:(NSString *)aString {
	[textView setText:aString];
}

- (NSString *)text {
	return textView.text;
}
- (void)setFont:(UIFont *)aFont {
	[textView setFont:aFont];
}
- (UIFont *)font {
	return textView.font;
}

- (void)setTextColor:(UIColor *)tColor {
	[textView setTextColor:tColor];
}

- (UIColor *)TextColor {
	return textView.textColor;
}


- (void)setDelegate:(id <UITextViewDelegate>)aDelegate {
	textView.delegate = aDelegate;
}

- (id <UITextViewDelegate>)delegate {
	return textView.delegate;
}

#pragma mark -



- (void)setStyle:(TFTextViewStyle)style {
	_style = style;
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
	if( self = [super initWithFrame:frame] ) {
		self.backgroundColor = [UIColor clearColor];
		
		_style               = TFTextViewRoundedCornerStyle;
		_radius              = 10.0f;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Initialization code.

		self.backgroundColor = [UIColor clearColor];	// 라운딩 처리등을 위해서 배경은 강제로 투명으로 한다.
		self.clipsToBounds	 = YES;						// 서브뷰가 영역 밖으로 나가는 경우 화면에 나타나지 않도록 막는다.
		
		// 텍스트뷰를 생성
		textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 
																5, 
																self.frame.size.width - 10, 
																self.frame.size.height + 20)];
		textView.backgroundColor = [UIColor clearColor];
		textView.contentInset	 = UIEdgeInsetsMake(-4, -4, 0, 0);	// top, left, bottom, right 
		textView.font			 = [UIFont fontWithName:@"Helvetica" size:17];
		
		// bottom padding 처럼 보이게 할 view 생성
		UIView *bottomPaddingView = [[UIView alloc] initWithFrame:CGRectMake(10,				// radius와 맞출 것
																	 self.frame.size.height - 5, 
																	 self.frame.size.width - 25, 
																	 5)];
		bottomPaddingView.backgroundColor = [UIColor whiteColor];
		
		_color		= [UIColor whiteColor];
		_style		= TFTextViewRoundedCornerStyle;
		_radius		= 10.0f;
		
		[self addSubview:textView];
		[textView release];
		[self addSubview:bottomPaddingView];
		[bottomPaddingView release];
		
		isInitialize = YES;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	if (isInitialize) {
//		CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
//		CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
//		isInitialize = NO;
//	} else {
		CGContextSetStrokeColorWithColor(context, _color.CGColor);
		CGContextSetFillColorWithColor(context, _color.CGColor);
//	}
	// If you were making this as a routine, you would probably accept a rectangle
	// that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
	CGRect rrect = rect;
	CGFloat radius = _radius;
	// NOTE: At this point you may want to verify that your radius is no more than half
	// the width and height of your rectangle, as this technique degenerates for those cases.
	
	// In order to draw a rounded rectangle, we will take advantage of the fact that
	// CGContextAddArcToPoint will draw straight lines past the start and end of the arc
	// in order to create the path from the current position and the destination position.
	
	// In order to create the 4 arcs correctly, we need to know the min, mid and max positions
	// on the x and y lengths of the given rectangle.
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    2       3       4
	// midy   1 9              5
	// maxy    8       7       6
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	if( ( _style & TFTextViewLeftTopRoundedCorner ) ) 
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	else
	{
		CGContextAddLineToPoint(context, minx, miny );
		CGContextAddLineToPoint(context, midx, miny );
	}
	
	// Add an arc through 4 to 5
	if( ( _style & TFTextViewRightTopRoundedCorner ) ) 
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	else
	{
		CGContextAddLineToPoint(context, maxx, miny );
		CGContextAddLineToPoint(context, maxx, midy );
	}
	
	// Add an arc through 6 to 7
	if( ( _style & TFTextViewLeftBottomRoundedCorner ) ) 
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	else
	{
		CGContextAddLineToPoint(context, maxx, maxy );
		CGContextAddLineToPoint(context, midx, maxy );
	}
	
	// Add an arc through 8 to 9
	if( ( _style & TFTextViewRightBottomRoundedCorner ) ) 
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	else
	{
		CGContextAddLineToPoint(context, minx, maxy );
		CGContextAddLineToPoint(context, minx, midy );
	}
	
	// Close the path
	CGContextClosePath(context);
	// Fill & stroke the path
	CGContextEOFillPath(context);

	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	//[textView release];
    [super dealloc];
}


@end

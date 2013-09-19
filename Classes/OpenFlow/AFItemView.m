#import <QuartzCore/QuartzCore.h>
#import "AFItemView.h"
#import "AFOpenFlowConstants.h"


@implementation AFItemView
@synthesize number, imageView, horizontalPosition, verticalPosition;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = NULL;
		verticalPosition = 0;
		horizontalPosition = 0;
		
		// Image View
		imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.opaque = YES;
		[self addSubview:imageView];
	}
	return self;
}

- (void)setImage:(UIImage *)newImage originalImageHeight:(CGFloat)imageHeight reflectionFraction:(CGFloat)reflectionFraction {
	[imageView setImage:newImage];
	//verticalPosition = imageHeight * reflectionFraction / 2;
	verticalPosition = 10;//imageHeight * reflectionFraction / 2;
	originalImageHeight = imageHeight;
	self.frame = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
		//self.frame = CGRectMake(0, 0, 250, 300);
}

- (void)setNumber:(int)newNumber {
	horizontalPosition = COVER_SPACING * newNumber;
	number = newNumber;
}

- (CGSize)calculateNewSize:(CGSize)baseImageSize boundingBox:(CGSize)boundingBox {
	CGFloat boundingRatio = boundingBox.width / boundingBox.height;
	CGFloat originalImageRatio = baseImageSize.width / baseImageSize.height;
	
	CGFloat newWidth;
	CGFloat newHeight;
	if (originalImageRatio > boundingRatio) {
		newWidth = boundingBox.width;
		newHeight = boundingBox.width * baseImageSize.height / baseImageSize.width;
	} else {
		newHeight = boundingBox.height;
		newWidth = boundingBox.height * baseImageSize.width / baseImageSize.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (void)setFrame:(CGRect)newFrame {
	[super setFrame:newFrame];
	[imageView setFrame:newFrame];
}

- (void)dealloc {
	[imageView release];
	
	[super dealloc];
}

@end
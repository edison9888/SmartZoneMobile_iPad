#import <UIKit/UIKit.h>

/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
@interface UIImage (OpenFlowExtras)

- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

@end
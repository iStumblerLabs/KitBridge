#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

@protocol ILImageResizing

- (ILImage*) resizedImage:(CGSize)newSize withScale:(CGFloat) scale;

@end

// TODO: ILTraitCollection
// TODO: ILImageConfiguration

// MARK: -

@interface ILImage (KitBridge)

#if IL_APP_KIT
// MARK - Loading and caching images
+ (ILImage*) imageNamed:(NSString*)name inBundle:(NSBundle*)bundle compatibleWithTraitCollection:(NSObject*)traitCollection;
// TODO: + (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle withConfiguration:(UIImageConfiguration *)configuration;
// TODO: + (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle variableValue:(double)value withConfiguration:(UIImageConfiguration *)configuration
// TODO: + (UIImage *)systemImageNamed:(NSString *)name withConfiguration:(UIImageConfiguration *)configuration;
// TODO: + (UIImage *)systemImageNamed:(NSString *)name variableValue:(double)value withConfiguration:(UIImageConfiguration *)configuration;
// TODO: + (UIImage *)systemImageNamed:(NSString *)name compatibleWithTraitCollection:(UITraitCollection *)traitCollection;
+ (ILImage*) systemImageNamed:(NSString*) name;

- (CGImageRef) CGImage;
#endif

// MARK: ILImage

- (ILImage*) inverted;
- (ILImage*) templateTintedWithColor:(ILColor*) tint;
- (ILImage*) croppedImage:(CGRect)bounds;
- (ILImage*) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (ILImage*) resizedImage:(CGSize)newSize;

@end

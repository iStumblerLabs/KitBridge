#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILView (KitBridge)

- (ILImage*) asImage;

@end

NS_ASSUME_NONNULL_END

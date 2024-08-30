#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/// adds common init and update methods to all views in the SparkKit
@protocol ILViewLifecycle <NSObject>

/// run from initWithFrame: or initWithCoder: to initialize the view
- (void) initView;

/// have the view query it's data source and redraw itself
- (void) updateView;

@end

// MARK: -

@interface ILView (KitBridge)

- (ILImage*) asImage;

@end

NS_ASSUME_NONNULL_END

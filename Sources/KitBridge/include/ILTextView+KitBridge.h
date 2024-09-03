#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILTextView (KitBridge)
@property(nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END

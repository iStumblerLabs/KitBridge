#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILStoryboard (KitBridge)

#if IL_APP_KIT
- (__kindof ILViewController*) instantiateInitialViewController;
// TODO: - (__kindof UIViewController *)instantiateInitialViewControllerWithCreator:(UIStoryboardViewControllerCreator)block;
- (__kindof ILViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier;
// TODO: - (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier creator:(UIStoryboardViewControllerCreator)block;
// TODO: typedef __kindof nullable UIViewController * (^UIStoryboardViewControllerCreator)(NSCoder *coder);
#endif // IL_APP_KIT
@end

NS_ASSUME_NONNULL_END

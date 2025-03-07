#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if IL_APP_KIT
@interface NSTextView (KitBridge)

@property(nonatomic, copy) NSString *text;

@end

// MARK: -

@interface NSTextField (KitBridge)

@property(nonatomic, copy) NSString *text;

@end
#endif

// MARK: -

#if IL_UI_KIT
@interface NSTextStorage (KitBridge)

/// readonly variant of attributeRuns from macOS
@property(readonly, copy) NSArray<NSTextStorage*>* attributeRuns;

@end
#endif

NS_ASSUME_NONNULL_END

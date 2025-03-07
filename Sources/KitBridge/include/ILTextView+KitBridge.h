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

@interface NSTextStorage (KitBridge)

#if IL_UI_KIT
/// readonly variant of attributeRuns from macOS
@property(readonly, copy) NSArray<NSTextStorage*>* attributeRuns;
#endif

/// @returns an array of character range strings which have the attribute and value provided
- (NSArray<NSString*>*) rangesForAttribute:(NSString*) attribute value:(id) value;

@end

NS_ASSUME_NONNULL_END

#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif


NS_ASSUME_NONNULL_BEGIN

/// adds convenience methods to create attributed strings
@interface NSAttributedString (KitBridge)

+ (NSAttributedString*) attributedString:(NSString*) string;
+ (NSAttributedString*) attributedString:(NSString*) string withFont:(ILFont*) font;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url andAttributes:(NSDictionary*) attrs;
+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs;
#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach;
#endif

@end

NS_ASSUME_NONNULL_END

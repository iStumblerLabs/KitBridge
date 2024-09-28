#import "include/NSAttributedString+KitBridge.h"
#ifdef SWIFT_PACKAGE
#import "include/ILFont+KitBridge.h"
#import "include/ILColor+KitBridge.h"
#else
#import <KitBridge/ILFont+KitBridge.h>
#import <KitBridge/ILColor+KitBridge.h>
#endif

@implementation NSAttributedString (KitBridge)

+ (NSAttributedString*) attributedString:(NSString*) string {
    return [NSAttributedString.alloc initWithString:string];
}

+ (NSAttributedString*) attributedString:(NSString*) string withFont:(ILFont*) font {
    NSDictionary* attrs = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: ILColor.textColor
    };
    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*)string withLink:(NSURL*) url {
    NSDictionary* attrs = @{
        NSFontAttributeName: [ILFont systemFontOfSize:ILFont.defaultFontSize],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: ILColor.textColor,
        NSLinkAttributeName: url.absoluteString
    };

    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url andAttributes:(NSDictionary*) attrs {
    NSMutableDictionary* mutableAttrs = attrs.mutableCopy;
    mutableAttrs[NSLinkAttributeName] = url.absoluteString;
    mutableAttrs[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);

    return [NSAttributedString.alloc initWithString:string attributes:mutableAttrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs {
    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach {
    NSTextAttachment* attachment = NSTextAttachment.new;
    [attachment setAttachmentCell:attach];
    return [NSAttributedString attributedStringWithAttachment:attachment];
}
#endif

@end

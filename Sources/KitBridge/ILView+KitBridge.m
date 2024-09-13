#import "ILView+KitBridge.h"

@implementation ILView (KitBridge)

- (ILImage*) asImage {
    ILImage* image;
#if IL_UI_KIT
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, self.frame.size.width, self.frame.size.height, 8, 0, colorSpace, 0);
    [self.layer renderInContext:context];
    CGImageRef rendered = CGBitmapContextCreateImage(context);
    image = [ILImage.alloc initWithCGImage:rendered];
    CFBridgingRelease(colorSpace);
    CFBridgingRelease(context);
    CFBridgingRelease(rendered);
#elif IL_APP_KIT
    NSBitmapImageRep *bitmap = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    bitmap.size = self.bounds.size;
    image = [NSImage.alloc initWithSize:self.bounds.size];
    [image addRepresentation:bitmap];
#endif
    return image;
}

@end

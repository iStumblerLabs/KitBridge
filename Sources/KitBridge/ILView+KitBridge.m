#import "ILView+KitBridge.h"

@implementation ILView (KitBridge)

- (ILImage*) asImage {
#if IL_UI_KIT
    UIGraphicsRenderer* renderer = [UIGraphicsImageRenderer.alloc initWithSize:self.frame.size];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, self.frame.size.width, self.frame.size.height, 8, 0, colorSpace, 0);
    [self.layer renderInContext:context];
    CGImageRef rendered = CGBitmapContextCreateImage(context);
    return [ILImage.alloc initWithCGImage:rendered];
#elif IL_APP_KIT
    NSBitmapImageRep *bitmap = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    bitmap.size = self.bounds.size;
    NSImage* image = [NSImage.alloc initWithSize:self.bounds.size];
    [image addRepresentation:bitmap];
    return image;
#endif
}

@end

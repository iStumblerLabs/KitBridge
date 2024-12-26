#import "NSBundle+KitBridge.h"
#import "ILPDFImage.h"

@implementation NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage*) imageForResource:(NSString*) name {
    ILImage* resourceImage = nil;

    if ([name.pathExtension isEqualToString:@"pdf"]) {
#if !TARGET_OS_TV
        NSString* imageResource = [self pathForResource:name.stringByDeletingPathExtension ofType:name.pathExtension];
        resourceImage = [ILPDFImage.alloc initWithContentsOfFile:imageResource];
#endif
    }
    else {
        resourceImage = [UIImage imageNamed:name inBundle:self compatibleWithTraitCollection:nil];
    }

    return resourceImage;
}
#endif

@end

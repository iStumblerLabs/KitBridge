//
//  ILStoryboard+KitBridge.m
//  KitBridge
//
//  Created by Alf Watt on 8/28/24.
//

#import "ILStoryboard+KitBridge.h"

@implementation ILStoryboard (KitBridge)

#if IL_APP_KIT
- (__kindof ILViewController*) instantiateInitialViewController {
    return [self instantiateInitialController];
}

- (__kindof ILViewController *)instantiateViewControllerWithIdentifier:(NSString*) identifier {
    return [self instantiateControllerWithIdentifier:identifier];
}
#endif

@end

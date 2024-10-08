#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

/// @header bridging header for UIBezierPath and NSBezierPath

/// text description of a CGPathRef
NSString* ILCGPathDescription(CGPathRef path);

/// count the number of elements in a CGPathRef
NSInteger ILCGPathElementCount(CGPathRef path);

#if IL_APP_KIT
// From UIBezierPath.h
typedef NS_OPTIONS(NSUInteger, ILRectCorner) {
    UIRectCornerTopLeft     = 1 << 0,
    UIRectCornerTopRight    = 1 << 1,
    UIRectCornerBottomLeft  = 1 << 2,
    UIRectCornerBottomRight = 1 << 3,
    UIRectCornerAllCorners  = ~0UL
};
#endif

typedef void(^ILBezierPathEnumerator)(const CGPathElement* element);

@interface ILBezierPath (KitBridge)

@property(nonatomic, readonly) CGPathRef ILCGPath CF_RETURNS_RETAINED;

#if IL_APP_KIT

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(ILRectCorner)corners cornerRadii:(CGSize)cornerRadii;

+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

+ (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;

// MARK: - Path Construction

- (void)addLineToPoint:(CGPoint)point;

- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;

- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;

- (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

// MARK: - Appending Paths

/// append a path to this one
- (void)appendPath:(ILBezierPath*)bezierPath;

#elif IL_UI_KIT
@property (readonly) NSInteger elementCount;

#endif

// MARK: - Enumerating Paths

/// the provided enumerator block is executed once for each point on the path
- (void)enumeratePathWithBlock:(ILBezierPathEnumerator) enumerator;

@end

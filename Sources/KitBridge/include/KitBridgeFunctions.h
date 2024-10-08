#ifndef KitBridgeFunctions_h
#define KitBridgeFunctions_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// MARK: - Math

/// 12 O'Clock position
extern CGFloat const ILZeroAngleRadians;

/// Converts degrees to radians
/// (angleDegrees * M_PI / 180.0)
CGFloat ILDegreesToRadians(CGFloat angleDegrees);

/// Converts radians to degrees
/// (angleRadians * 180.0 / M_PI)
CGFloat ILRadiansToDegrees(CGFloat angleRadians);

/// Convertes percentage to radians
/// (percent * M_PI * 2)
CGFloat ILPercentToRadians(CGFloat percent);

// MARK: - Geometry

/// @return the length of the vector using the Pythagorean theorem
CGFloat ILVectorLength(CGVector delta);

/// @return the angle of the vector in radians
CGFloat ILVectorRadians(CGVector delta);

/// check to see if a point is 'normal' and neither value is NaN or Infinite
BOOL ILIsNormalPoint(CGPoint point);

/// check to see if a size is 'normal' and neither value is NaN or Infinite
BOOL ILIsNormalSize(CGSize size);

/// check to see if a rect has a 'normal' origin and size and neither value is NaN or Infinite
BOOL ILIsNormalRect(CGRect rect);

/// @return the points in vector form
CGVector ILVectorFromPointToPoint(CGPoint from, CGPoint to);

/// @return the largest square centered in the provided rectangle
CGRect ILRectSquareInRect(CGRect rect);

/// @return the center point of the rect
CGPoint ILPointCenteredInRect(CGRect rect);

/// project a point the provided distance along the vector provided
CGPoint ILPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance);

// MARK: - Foundation

/// NSString from rect in the style of NSStringFromCGRect in UIKit
NSString* ILStringFromCGRect(CGRect rect);

#endif /* KitBridgeFunctions_h */

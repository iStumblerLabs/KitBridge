#import <Foundation/Foundation.h>

/// adds common init and update methods to all views in the SparkKit
@protocol ILViews <NSObject>

/// run from initWithFrame: or initWithCoder: to initialize the view
- (void) initView;

/// have the view query it's data source and redraw itself
- (void) updateView;

@end

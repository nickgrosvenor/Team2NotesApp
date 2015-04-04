
#import <UIKit/UIKit.h>

@interface UIView (NIB)
+ (id)loadView;
+ (NSString*)nibName;
+ (UIView *)loadView:(NSString*)nibName;
@end


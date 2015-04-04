
#import "UIView+NIB.h"

@implementation UIView (NIB)

+ (UIView *)loadView:(NSString*)nibName {
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	
	for (id object in objects) {
		if ([object isKindOfClass:self]) {
			return object;
		}
	}
    
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", [self description], [self class]];	
	
	return nil;
}



+ (id)loadView {
    return [self loadView:[self nibName]];
}

+ (NSString*)nibName
{
    return [self description];
}



@end

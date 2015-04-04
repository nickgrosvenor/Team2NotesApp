

#import "CLTableView.h"

@implementation CLTableView

- (void)updateIndexForTop{
    [super updateIndexForTop];
    if(iPageIndex<0)
        iPageIndex = numberOfRows-1;
    iPageIndex = iPageIndex%numberOfRows;
}
- (void)updateIndexForBottom{
    [super updateIndexForBottom];
    if(iPageIndex<0)
        iPageIndex = numberOfRows-1;
    else
        iPageIndex = iPageIndex%numberOfRows;
}
@end

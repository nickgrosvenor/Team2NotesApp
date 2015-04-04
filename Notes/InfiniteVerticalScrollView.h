
#import <UIKit/UIKit.h>

@protocol InfiniteVerticalScrollViewDataSource;
@protocol InfiniteVerticalScrollViewDelegate;

@interface InfiniteVerticalScrollView : UIScrollView <UIScrollViewDelegate,UITableViewDelegate>{
    IBOutlet id <InfiniteVerticalScrollViewDataSource> infiniteDatasource;
    IBOutlet id <InfiniteVerticalScrollViewDelegate> infiniteDelegate;
    NSInteger iPageIndex;
    NSInteger numberOfRows;
    NSInteger iRowOffset;
    BOOL upScrolling;
    NSMutableArray *visibleLabels;
}
@property(nonatomic,strong)IBOutlet UIView *viewScroll;
@property (nonatomic, assign) id <InfiniteVerticalScrollViewDataSource> infiniteDatasource;
@property (nonatomic, assign) id <InfiniteVerticalScrollViewDelegate> infiniteDelegate;
@property (nonatomic) NSInteger iPageIndex;
@property (nonatomic) NSInteger iRowOffset;
@property (nonatomic, strong) NSMutableArray *visibleLabels;

- (void)scrollToMiddle;
- (UIView *)insertView;
- (CGFloat)placeNewLabelOnTop:(CGFloat)topEdge;
- (CGFloat)placeNewLabelOnBottom:(CGFloat)bottomEdge;
- (void)updateIndexForTop;
- (void)updateIndexForBottom;
- (void)reloadAllData;
-(void)setContentViewFrame:(CGRect)rect;
@end

@protocol InfiniteVerticalScrollViewDataSource <NSObject>

@optional
-(UIView*)scrollview:(InfiniteVerticalScrollView*)scrollView viewForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRowsInScrollView:(InfiniteVerticalScrollView*)scrollView;

- (CGFloat)heightForScrollView:(InfiniteVerticalScrollView *)scrollView;
@end

@protocol InfiniteVerticalScrollViewDelegate <NSObject>

@optional
- (void)scrollview:(InfiniteVerticalScrollView *)scrollView didSelectRowAtIndex:(NSInteger)index;
@end
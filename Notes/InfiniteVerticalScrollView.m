
#import "InfiniteVerticalScrollView.h"
@interface InfiniteVerticalScrollView () {
    
    UIView         *labelContainerView;
    UITapGestureRecognizer *tapGesture;
}

- (void)tileLabelsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY;

@end

@implementation InfiniteVerticalScrollView
@synthesize infiniteDatasource;
@synthesize infiniteDelegate;
@synthesize iRowOffset;
@synthesize iPageIndex;
@synthesize visibleLabels;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        
        upScrolling = YES;
        self.scrollsToTop = NO;
        
    }
    return self;
}
-(void)setInfiniteDatasource:(id<InfiniteVerticalScrollViewDataSource>)infiniteData{
    infiniteDatasource = infiniteData;
    numberOfRows = [infiniteDatasource numberOfRowsInScrollView:self];
    CGFloat height = [infiniteDatasource heightForScrollView:self];
    CGFloat totalHeight = CGRectGetHeight([self bounds]);
    NSInteger totalVisibleRow = (int)floor(totalHeight/height);
    self.iRowOffset = (int)totalVisibleRow/2.0;
}
- (void)reloadAllData{
    if(![visibleLabels count])
        return;
    for (UIView *view in visibleLabels) {
        [view removeFromSuperview];
    }
    upScrolling = YES;
//    UIView *topView = [visibleLabels objectAtIndex:0];
//    iPageIndex = topView.tag;
    [visibleLabels removeAllObjects];
    numberOfRows = [infiniteDatasource numberOfRowsInScrollView:self];
    CGRect visibleBounds = [self convertRect:[self bounds] toView:labelContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}

#pragma mark -
#pragma mark Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0)) {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (UILabel *label in visibleLabels) {
            CGPoint center = [labelContainerView convertPoint:label.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            label.center = [self convertPoint:center toView:labelContainerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];
    
    if(!labelContainerView){
        self.contentSize = CGSizeMake(self.frame.size.width,5000);
        
        visibleLabels = [[NSMutableArray alloc] init];
        
        labelContainerView = [[UIView alloc] init];
        labelContainerView.frame = CGRectMake(0, 0, self.frame.size.width, self.contentSize.height);
        [self addSubview:labelContainerView];
        [labelContainerView setBackgroundColor:[UIColor clearColor]];
        [labelContainerView setUserInteractionEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
    }
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:labelContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}


#pragma mark -
#pragma mark Label Tiling

- (UIView *)insertView {
    UIView *view = nil;
    if([infiniteDatasource respondsToSelector:@selector(scrollview:viewForRowAtIndex:)]){
        view = (UIView*)[infiniteDatasource scrollview:self viewForRowAtIndex:iPageIndex];
        view.userInteractionEnabled = YES;
        view.tag = iPageIndex;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDetected:)];
        [gesture setNumberOfTapsRequired:1];
        [view addGestureRecognizer:gesture];
        [gesture release];
        [labelContainerView addSubview:view];
    }
    return view;
}

- (void)touchDetected:(UITapGestureRecognizer*)gesture{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    for(UIView *view in visibleLabels){
        [view setBackgroundColor:[UIColor clearColor]];
    }
    [UIView commitAnimations];
    UIView *view = gesture.view;
    if([infiniteDelegate respondsToSelector:@selector(scrollview:didSelectRowAtIndex:)])
        [infiniteDelegate scrollview:self didSelectRowAtIndex:view.tag];
  //  [view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:1. alpha:0.3]];
}

- (void)updateIndexForTop{
    if(!upScrolling){
        UIView *lastView = [visibleLabels lastObject];
        iPageIndex = lastView.tag + 1;
        upScrolling = YES;
    }
}
- (void)updateIndexForBottom{
    if(upScrolling){
        UIView *lastView = [visibleLabels objectAtIndex:0];
        iPageIndex = lastView.tag -1;
        upScrolling = NO;
    }
}
- (CGFloat)placeNewLabelOnTop:(CGFloat)topEdge {
    [self updateIndexForTop];
    UIView *label = [self insertView];
    [visibleLabels addObject:label]; // add rightmost label at the end of the array
    
    CGRect frame = [label frame];
    frame.origin.x = [labelContainerView bounds].size.width - frame.size.width;;
    frame.origin.y = topEdge;//[labelContainerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    iPageIndex++;
    upScrolling = YES;
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewLabelOnBottom:(CGFloat)bottomEdge {
    [self updateIndexForBottom];
    UIView *label = [self insertView];
    [visibleLabels insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
    CGRect frame = [label frame];
    frame.origin.x = [labelContainerView bounds].size.width - frame.size.width;
    frame.origin.y = bottomEdge - frame.size.height;//[labelContainerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    
    iPageIndex--;
    return CGRectGetMinY(frame);
}

- (void)tileLabelsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY {
    if ([visibleLabels count] == 0) {
        [self placeNewLabelOnTop:minimumVisibleY];
    }
    UILabel *lastLabel = [visibleLabels lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastLabel frame]);
    while (bottomEdge < maximumVisibleY) {
        bottomEdge = [self placeNewLabelOnTop:bottomEdge];
    }
    
    UILabel *firstLabel = [visibleLabels objectAtIndex:0];
    CGFloat topEdge = CGRectGetMinY([firstLabel frame]);
    while (topEdge > minimumVisibleY) {
        topEdge = [self placeNewLabelOnBottom:topEdge];
    }
    
    lastLabel = [visibleLabels lastObject];
    while ([lastLabel frame].origin.y > maximumVisibleY) {
        [lastLabel removeFromSuperview];
        [visibleLabels removeLastObject];
        lastLabel = [visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = [visibleLabels objectAtIndex:0];
    while (CGRectGetMaxY([firstLabel frame]) < minimumVisibleY) {
        [firstLabel removeFromSuperview];
        [visibleLabels removeObjectAtIndex:0];
        firstLabel = [visibleLabels objectAtIndex:0];
    }
    
    
}
- (void)scrollToMiddle{
    CGRect visibleBounds = [self convertRect:[self bounds] toView:labelContainerView];
    CGFloat visibleHeight = CGRectGetHeight(visibleBounds);
    
    UIView *middleView;
    UIView *lastView = [visibleLabels lastObject];
    CGRect frame = [lastView frame];
    CGFloat delta = self.contentOffset.y;
    int position = round(delta / CGRectGetHeight(frame));
    CGPoint topPoint = CGPointMake(0.0, CGRectGetHeight(frame) * position);
    
    CGPoint centerPoint = CGPointMake(labelContainerView.frame.size.width/2, topPoint.y +visibleHeight/2);
    for(UIView *view in visibleLabels){
        CGRect frame = [view frame];
        if(CGRectContainsPoint(frame, centerPoint)){
            middleView = view;
            break;
        }
    }
    CGPoint centerPointOfRow = middleView.center;
    CGFloat yPOS = centerPointOfRow.y-(visibleHeight/2);
    CGPoint exactPointForMiddle = CGPointMake(0, yPOS);
    
    [self setContentOffset:exactPointForMiddle animated:YES];
    if([infiniteDelegate respondsToSelector:@selector(scrollview:didSelectRowAtIndex:)])
        [infiniteDelegate scrollview:self didSelectRowAtIndex:middleView.tag];
}
-(void)setContentViewFrame:(CGRect)rect{
    [labelContainerView setFrame:rect];
}

-(void)dealloc{
    [visibleLabels release];
    [labelContainerView release];
    self.infiniteDelegate =nil;
    self.infiniteDatasource = nil;
    [super dealloc];
}

@end

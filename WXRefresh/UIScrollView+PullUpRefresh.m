//
//  UIScrollView+PullUpRefresh.m
//  PullRefresh
//
//  Created by Zheng on 14/10/20.
//  Copyright © 2014年 Qingwu Zheng. All rights reserved.
//

#import "UIScrollView+PullUpRefresh.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const InfiniteScrollingViewHeight = 60;

@interface InfiniteScrollingDotView : UIView

@property(nonatomic, strong) UIColor *arrowColor;

@end

@interface InfiniteScrollingView ()

@property(nonatomic, copy) void (^infiniteScrollingHandler)(void);

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, readwrite) InfiniteScrollingState state;
@property(nonatomic, strong) NSMutableArray *viewForState;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, readwrite) CGFloat originalBottomInset;
@property(nonatomic, assign) BOOL wasTriggeredByUser;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UIScrollView (PullUpRefresh)
#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (PullUpRefresh)

@dynamic infiniteScrollingView;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {

  if (!self.infiniteScrollingView) {
    InfiniteScrollingView *view = [[InfiniteScrollingView alloc]
        initWithFrame:CGRectMake(0, self.contentSize.height,
                                 self.bounds.size.width,
                                 InfiniteScrollingViewHeight)];
    view.infiniteScrollingHandler = actionHandler;
    view.scrollView = self;
    [self addSubview:view];

    view.originalBottomInset = self.contentInset.bottom;
    self.infiniteScrollingView = view;
    self.showsInfiniteScrolling = YES;
  }
}

- (void)triggerInfiniteScrolling {
  self.infiniteScrollingView.state = InfiniteScrollingStateTriggered;
  [self.infiniteScrollingView startAnimating];
}

- (void)setInfiniteScrollingView:
    (InfiniteScrollingView *)infiniteScrollingView {
  [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
  objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                           infiniteScrollingView, OBJC_ASSOCIATION_ASSIGN);
  [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (InfiniteScrollingView *)infiniteScrollingView {
  return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
  self.infiniteScrollingView.hidden = !showsInfiniteScrolling;

  if (!showsInfiniteScrolling) {
    if (self.infiniteScrollingView.isObserving) {
      [self removeObserver:self.infiniteScrollingView
                forKeyPath:@"contentOffset"];
      [self removeObserver:self.infiniteScrollingView
                forKeyPath:@"contentSize"];
      [self.infiniteScrollingView resetScrollViewContentInset];
      self.infiniteScrollingView.isObserving = NO;
    }
  } else {
    if (!self.infiniteScrollingView.isObserving) {
      [self addObserver:self.infiniteScrollingView
             forKeyPath:@"contentOffset"
                options:NSKeyValueObservingOptionNew
                context:nil];
      [self addObserver:self.infiniteScrollingView
             forKeyPath:@"contentSize"
                options:NSKeyValueObservingOptionNew
                context:nil];
      [self.infiniteScrollingView
              setScrollViewContentInsetForInfiniteScrolling];
      self.infiniteScrollingView.isObserving = YES;

      [self.infiniteScrollingView setNeedsLayout];
      self.infiniteScrollingView.frame =
          CGRectMake(0, self.contentSize.height,
                     self.infiniteScrollingView.bounds.size.width,
                     InfiniteScrollingViewHeight);
    }
  }
}

- (BOOL)showsInfiniteScrolling {
  return !self.infiniteScrollingView.hidden;
}

@end

#pragma mark - InfiniteScrollingView
@implementation InfiniteScrollingView

// public properties
@synthesize infiniteScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    // default styling values
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.state = InfiniteScrollingStateStopped;
    self.enabled = YES;

    self.viewForState =
        [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
  }

  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  if (self.superview && newSuperview == nil) {
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (scrollView.showsInfiniteScrolling) {
      if (self.isObserving) {
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [scrollView removeObserver:self forKeyPath:@"contentSize"];
        self.isObserving = NO;
      }
    }
  }
}

- (void)layoutSubviews {
  self.activityIndicatorView.center =
      CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
  UIEdgeInsets currentInsets = self.scrollView.contentInset;
  currentInsets.bottom = self.originalBottomInset;
  [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
  UIEdgeInsets currentInsets = self.scrollView.contentInset;
  currentInsets.bottom = self.originalBottomInset + InfiniteScrollingViewHeight;
  [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction |
                              UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.scrollView.contentInset = contentInset;
                   }
                   completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"contentOffset"])
    [self scrollViewDidScroll:
              [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
  else if ([keyPath isEqualToString:@"contentSize"]) {
    [self layoutSubviews];
    self.frame =
        CGRectMake(0, self.scrollView.contentSize.height,
                   self.bounds.size.width, InfiniteScrollingViewHeight);
  }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
  if (self.state != InfiniteScrollingStateLoading && self.enabled) {
    CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
    CGFloat scrollOffsetThreshold =
        scrollViewContentHeight - self.scrollView.bounds.size.height;

    if (!self.scrollView.isDragging &&
        self.state == InfiniteScrollingStateTriggered)
      self.state = InfiniteScrollingStateLoading;
    else if (contentOffset.y > scrollOffsetThreshold &&
             self.state == InfiniteScrollingStateStopped &&
             self.scrollView.isDragging)
      self.state = InfiniteScrollingStateTriggered;
    else if (contentOffset.y < scrollOffsetThreshold &&
             self.state != InfiniteScrollingStateStopped)
      self.state = InfiniteScrollingStateStopped;
  }
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicatorView {
  if (!_activityIndicatorView) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
  return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(InfiniteScrollingState)state {
  id viewPlaceholder = view;

  if (!viewPlaceholder)
    viewPlaceholder = @"";

  if (state == InfiniteScrollingStateAll)
    [self.viewForState
        replaceObjectsInRange:NSMakeRange(0, 3)
         withObjectsFromArray:
             @[ viewPlaceholder, viewPlaceholder, viewPlaceholder ]];
  else
    [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];

  self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
  self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)triggerRefresh {
  self.state = InfiniteScrollingStateTriggered;
  self.state = InfiniteScrollingStateLoading;
}

- (void)startAnimating {
  self.state = InfiniteScrollingStateLoading;
}

- (void)stopAnimating {
  self.state = InfiniteScrollingStateStopped;
}

- (void)setState:(InfiniteScrollingState)newState {

  if (_state == newState)
    return;

  InfiniteScrollingState previousState = _state;
  _state = newState;

  for (id otherView in self.viewForState) {
    if ([otherView isKindOfClass:[UIView class]])
      [otherView removeFromSuperview];
  }

  id customView = [self.viewForState objectAtIndex:newState];
  BOOL hasCustomView = [customView isKindOfClass:[UIView class]];

  if (hasCustomView) {
    [self addSubview:customView];
    CGRect viewBounds = [customView bounds];
    CGPoint origin = CGPointMake(
        roundf((self.bounds.size.width - viewBounds.size.width) / 2),
        roundf((self.bounds.size.height - viewBounds.size.height) / 2));
    [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width,
                                    viewBounds.size.height)];
  } else {
    CGRect viewBounds = [self.activityIndicatorView bounds];
    CGPoint origin = CGPointMake(
        roundf((self.bounds.size.width - viewBounds.size.width) / 2),
        roundf((self.bounds.size.height - viewBounds.size.height) / 2));
    [self.activityIndicatorView
        setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width,
                            viewBounds.size.height)];

    switch (newState) {
    case InfiniteScrollingStateStopped:
      [self.activityIndicatorView stopAnimating];
      break;

    case InfiniteScrollingStateTriggered:
      [self.activityIndicatorView startAnimating];
      break;

    case InfiniteScrollingStateLoading:
      [self.activityIndicatorView startAnimating];
      break;
    }
  }

  if (previousState == InfiniteScrollingStateTriggered &&
      newState == InfiniteScrollingStateLoading &&
      self.infiniteScrollingHandler && self.enabled)
    self.infiniteScrollingHandler();
}

@end

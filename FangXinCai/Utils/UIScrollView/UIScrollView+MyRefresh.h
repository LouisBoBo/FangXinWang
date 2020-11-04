//
//  UIScrollView+MyRefresh.h
//  TYSlidePageScrollViewDemo
//
//  Created by 云商 on 15/9/9.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultTopLoadView.h"

extern const CGFloat TFRefreshHeaderViewHeight;
extern NSString *const observerRefreshHeaderViewKeyPath;
@interface UIScrollView (MyRefresh)


@property(strong,nonatomic) DefaultTopLoadView *topShowView;
@property(strong,nonatomic) NSNumber *isLoosen;
@property(strong,nonatomic) NSNumber *topLoadHeight;

- (void)addTopHeaderWithCallback:(void (^)())callback;
- (void)addTopTarget:(id)target andAction:(SEL)sel withView:(DefaultTopLoadView *)topShowView;

- (void)ffRefreshHeaderEndRefreshing;
- (void)ffRefreshHeaderBeginRefreshing;
@end
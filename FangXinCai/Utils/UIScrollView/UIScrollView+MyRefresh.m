//
//  UIScrollView+MyRefresh.m
//  TYSlidePageScrollViewDemo
//
//  Created by 云商 on 15/9/9.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+MyRefresh.h"
#import "DefaultTopLoadView.h"
#import <objc/runtime.h>


const CGFloat TFRefreshHeaderViewHeight = 60;
NSString *const observerRefreshHeaderViewKeyPath = @"contentOffset";
//#define TFRefreshHeaderViewHeight 60

@interface UIScrollView ()


@end
@implementation UIScrollView (MyRefresh)

static char topShowViewChar;
static char isLoosenChar;
static char topLoadHeightChar;

- (void)addTopTarget:(id)target andAction:(SEL)sel withView:(DefaultTopLoadView *) topShowView{
    if(self.topShowView){
        [self.topShowView removeFromSuperview];
    }
    if(topShowView){
        self.topShowView = topShowView;
    } else {
        self.topShowView = [[DefaultTopLoadView alloc]initWithFrame:CGRectMake(0, -TFRefreshHeaderViewHeight-(int)self.topLoadHeight.intValue, kScreenWidth, TFRefreshHeaderViewHeight)];
        
//        MyLog(@"topShowView.frame: %@", NSStringFromCGRect(self.topShowView.frame));
//        MyLog(@"self.contentInset: %@", NSStringFromUIEdgeInsets(self.contentInset));
        
//        self.topShowView.center = CGPointMake(self.center.x, self.topShowView.center.y);
    }
    
    self.isLoosen = [NSNumber numberWithBool:YES];
    self.topShowView.backgroundColor = [UIColor clearColor];
//    self.topShowView.backgroundColor = [UIColor yellowColor];
    self.topShowView.action = sel;
    self.topShowView.actionTar = target;
    self.topShowView.topRefreshStatus = REFRESH_STATUS_NORMAL;
    self.topShowView.parentScrollView = self;
    [self addSubview:self.topShowView];
    
    [self addObserver:self forKeyPath:observerRefreshHeaderViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)addTopHeaderWithCallback:(void (^)())callback
{
    if(self.topShowView){
        [self.topShowView removeFromSuperview];
    }
//    MyLog(@"%@", NSStringFromCGRect(self.frame));
    self.topShowView = [[DefaultTopLoadView alloc]initWithFrame:CGRectMake(0, -TFRefreshHeaderViewHeight-(int)self.topLoadHeight.intValue, kScreenWidth, TFRefreshHeaderViewHeight)];
    
//    self.topShowView.center = CGPointMake(self.center.x, self.topShowView.center.y);
    
    self.isLoosen = [NSNumber numberWithBool:YES];
    self.topShowView.backgroundColor = [UIColor clearColor];
    //    self.topShowView.backgroundColor = [UIColor yellowColor];
    self.topShowView.beginRefreshingCallback = callback;
    self.topShowView.topRefreshStatus = REFRESH_STATUS_NORMAL;
    self.topShowView.parentScrollView = self;
    [self addSubview:self.topShowView];
    
    [self addObserver:self forKeyPath:observerRefreshHeaderViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:observerRefreshHeaderViewKeyPath]){
        NSValue * point = (NSValue *)[change objectForKey:@"new"];
        CGPoint p = [point CGPointValue];
        [self.topShowView adjustStatusByTop:p.y];
    }
}
-(DefaultTopLoadView *)topShowView{
    return objc_getAssociatedObject(self, &topShowViewChar);
}
-(void)setTopShowView:(DefaultTopLoadView *)topShowView{
    objc_setAssociatedObject(self, &topShowViewChar,topShowView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)isLoosen{
    return objc_getAssociatedObject(self, &isLoosenChar);
}

- (void)setIsLoosen:(NSNumber *)isLoosen
{
    objc_setAssociatedObject(self, &isLoosenChar, isLoosen, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)topLoadHeight
{
    return objc_getAssociatedObject(self, &topLoadHeightChar);
}

- (void)setTopLoadHeight:(NSNumber *)topLoadHeight
{
    objc_setAssociatedObject(self, &topLoadHeightChar, topLoadHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ffRefreshHeaderEndRefreshing
{
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        self.topShowView.topRefreshStatus = REFRESH_STATUS_NORMAL;
    });
}

- (void)ffRefreshHeaderBeginRefreshing
{
    if (self.window) {
        self.topShowView.topRefreshStatus = REFRESH_STATUS_REFRESHING;
    } else {
        if (self.topShowView.topRefreshStatus != REFRESH_STATUS_REFRESHING) {
            self.topShowView.topRefreshStatus = REFRESH_STATUS_REFRESHING;
            [self setNeedsDisplay];
        }
    }

}

@end

//
//  UINavigationBar+Helper.m
//  TLNavigationBar
//
//  Created by andezhou on 15/8/24.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "UINavigationBar+Helper.h"
#import <objc/runtime.h>

CGFloat const kBarHeight = 44.f;
static char overlayKey;

@implementation UINavigationBar (Helper)

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN);
}

- (void)tl_setBackgroundAlpha:(CGFloat)alpha {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    
    self.overlay.backgroundColor = [self.barTintColor colorWithAlphaComponent:alpha];
}

- (void)tl_setTranslationProgress:(CGFloat)progress {
    [self tl_setTranslationY:(-kBarHeight * progress)];
    [self tl_setBackgroundAlpha:1];
    [self setAlpha:1 - progress forSubviewsOfView:self];
}

- (void)setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if (subview == self.overlay) {
            continue;
        }
        subview.alpha = alpha;
        [self setAlpha:alpha forSubviewsOfView:subview];
    }
}

- (void)tl_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)tl_titleViewAlpha:(CGFloat)alpha {
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
}

- (void)tl_dealloc {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self tl_setTranslationProgress:0];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end

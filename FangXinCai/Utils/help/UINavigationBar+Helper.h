//
//  UINavigationBar+Helper.h
//  TLNavigationBar
//
//  Created by andezhou on 15/8/24.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const kBarHeight;

@interface UINavigationBar (Helper)

- (void)tl_setBackgroundAlpha:(CGFloat)alpha;

- (void)tl_setTranslationProgress:(CGFloat)progress;

- (void)tl_titleViewAlpha:(CGFloat)alpha;

- (void)tl_dealloc;


@end

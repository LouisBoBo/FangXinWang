//
//  MBProgressHUD+XJ.h
//  dreamer
//
//  Created by 晓杰 on 15-1-13.
//  Copyright (c) 2015年 PA. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XJ) <MBProgressHUDDelegate>

/**
 *  显示加载视图
 *
 *  @param message 显示的文本
 *  @param delay   延迟多长时间
 *  @param view    在哪个视图上
 */
+ (void)showMessage:(NSString *)text afterDeleay:(CGFloat)delay WithView:(UIView *)view;
/**
 *  隐藏加载视图
 *
 *  @param view 在哪个View上
 */
+ (void)hideHudForView:(UIView *)view;

+ (void)showafterDeleay:(CGFloat)delay WithView:(UIView *)view;

@end

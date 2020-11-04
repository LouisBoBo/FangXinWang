//
//  UIImage+helper.h
//  YunShangShiJi
//
//  Created by zgl on 16/6/7.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (helper)

/// 根据最大宽度转换图片
- (UIImage *)scaleImageMaxWidth:(float)width;
/// 默认图片（size 为绘制的默认图大小，背景色透明）
+ (UIImage*)createDefaultImageWithSize:(CGSize)size;

@end

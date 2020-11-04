//
//  DefaultImgManager.h
//  YunShangShiJi
//
//  Created by zgl on 16/6/23.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultImgManager : NSObject

+ (instancetype)sharedManager;
+ (instancetype)new __attribute__((unavailable("new 不可用,请调用sharedManager")));
- (instancetype)init __attribute__((unavailable("init 不可用,请调用sharedManager")));

/// 默认图片（size为绘制的默认图大小，背景色透明）
- (UIImage*)defaultImgWithSize:(CGSize)size;

@end

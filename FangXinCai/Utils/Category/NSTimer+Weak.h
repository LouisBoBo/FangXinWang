//
//  NSTimer+Weak.h
//  YunShangShiJi
//
//  Created by zgl on 16/8/1.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TimeBlock) (id target, NSTimer *timer);

@interface NSTimer (Weak)

/**
 * 计时器SEL(弱引用，页面销毁可以不用手动释放计时器)
 *
 * @param interval    间隔
 * @param aTarget     目标
 * @param aSelector   方法
 * @param userInfo    用户信息
 * @param repeats     是否重复
 * @retrn 返回 NSTimer 对象
 */
+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)repeats;

/**
 * 计时器Block(弱引用，页面销毁可以不用手动释放计时器)
 *
 * @param interval    间隔
 * @param aTarget     目标
 * @param userInfo    用户信息
 * @param repeats     是否重复
 * @param block       时间Block
 * @retrn 返回 NSTimer 对象
 */
+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)aTarget
                              userInfo:(id)userInfo
                               repeats:(BOOL)repeats
                                 block:(TimeBlock)block;

@end

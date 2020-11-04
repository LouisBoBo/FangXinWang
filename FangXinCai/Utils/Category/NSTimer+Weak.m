//
//  NSTimer+Weak.m
//  YunShangShiJi
//
//  Created by zgl on 16/8/1.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import "NSTimer+Weak.h"

/// 弱引用对象
@interface YFWeakTimeTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) TimeBlock block;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation YFWeakTimeTarget

- (void)fire:(NSTimer *)timer {
    if(self.target) {
        if (self.selector && [self.target respondsToSelector:self.selector]) {
            IMP imp = [self.target methodForSelector:self.selector];
            void (*func)(id, SEL, NSTimer *) = (void *)imp;
            func(self.target, self.selector, timer);
        }
        if (self.block) {
            self.block(_target, timer);
        }
    } else {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

@end


@implementation NSTimer (Weak)

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)repeats
                                 block:(TimeBlock)block {
    YFWeakTimeTarget *timerTarget = [[YFWeakTimeTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.block = block;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(fire:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timerTarget.timer forMode:NSRunLoopCommonModes];
    return timerTarget.timer;
}

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)repeats {
    return [self weakTimerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:userInfo repeats:repeats block:nil];;
}

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)aTarget
                              userInfo:(id)userInfo
                               repeats:(BOOL)repeats
                                 block:(TimeBlock)block {
    return [self weakTimerWithTimeInterval:interval target:aTarget selector:nil userInfo:userInfo repeats:repeats block:block];;
}

@end

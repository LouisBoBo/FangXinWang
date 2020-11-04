//
//  AppDelegate+JPush.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "AppDelegate.h"
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate (JPush)<JPUSHRegisterDelegate>
//初始化jpush
-(void)setupJpush:(nullable NSDictionary *)launchOptions;
@end

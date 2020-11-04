//
//  PPNetworkHelper.h
//  SafeEatDemo
//
//  Created by bob on 2017/9/4.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PPNetworkStatusType) {
    /** 未知网络*/
    PPNetworkStatusUnknown,
    /** 无网络*/
    PPNetworkStatusNotReachable,
    /** 手机网络*/
    PPNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    PPNetworkStatusReachableViaWiFi
};

/** 网络状态的Block*/
typedef void(^PPNetworkStatus)(PPNetworkStatusType status);
@interface NetStatuesListening : NSObject

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;

/**
 手机网络:YES, 反之:NO
 */
+ (BOOL)isWWANNetwork;

/**
 WiFi网络:YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(PPNetworkStatus)networkStatus;


@end

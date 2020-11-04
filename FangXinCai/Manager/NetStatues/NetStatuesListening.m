//
//  PPNetworkHelper.m
//  SafeEatDemo
//
//  Created by bob on 2017/9/4.
//  Copyright © 2017年 bob. All rights reserved.
//

#import "NetStatuesListening.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation NetStatuesListening

/**
 开始监测网络状态
 */
+ (void)load {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork
{
    
     return [AFNetworkReachabilityManager sharedManager].reachable;
    
}

/**
 手机网络:YES, 反之:NO
 */
+ (BOOL)isWWANNetwork
{
    
     return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
    
}

/**
 WiFi网络:YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork
{
    
     return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
    
}


/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(PPNetworkStatus)networkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(PPNetworkStatusUnknown) : nil;
                   
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(PPNetworkStatusNotReachable) : nil;
                   
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWWAN) : nil;
                   
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWiFi) : nil;
                    break;
            }
        }];
    });

}

@end

//
//  AppDelegate+AppService.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

//初始化服务
-(void)initService;
//监听网络状态
- (void)monitorNetworkStatus;
//初始化 window
-(void)initWindow;
//初始化网络请求配置
-(void)ConfigueNetRequest;
//初始化用户系统
-(void)initUserManager;
//配置高德地图
-(void)AMapServices;
//初始化键盘
-(void)ConfigKeyBoard;
//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

//测试登录
- (void)testLogin;
@end

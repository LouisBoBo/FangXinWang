//
//  AppDelegate+AppService.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "RootNavigationController.h"
#import "NetStatuesListening.h"
#import "LoginViewController.h"
#import "UserLoginModel.h"
#import "BaseReqApi.h"
#import "TBReqApi.h"

@implementation AppDelegate (AppService)

#pragma mark ————— 初始化服务 —————
-(void)initService{
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) {//有网络
        
        [MBProgressHUD showTopTipMessage:@"网络恢复正常" isWindow:YES];
        
    }else {//登陆失败加载登陆页面控制器
        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
    
}
#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [NetStatuesListening networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                NSLog(@"网络环境：未知网络");
                // 无网络
                break;
                
            case PPNetworkStatusNotReachable:
                NSLog(@"网络环境：无网络");
                KPostNotification(KNotificationNetWorkStateChange, @NO);
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                NSLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                NSLog(@"网络环境：WiFi");
                //                KPostNotification(KNotificationNetWorkStateChange, @YES);
                break;
        }
        
    }];
    
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];

    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}
#pragma mark-初始化键盘
-(void)ConfigKeyBoard
{
    [IQKeyboardManager sharedManager].enable=YES;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField=15.0f;
}

//初始化网络请求配置
-(void)ConfigueNetRequest
{
    YTKNetworkConfig *config=[YTKNetworkConfig sharedConfig];
        
    config.baseUrl=ReqUrl;
    
    config.cdnUrl=ReqUrl;
    
}

//初始化用户系统
- (void)initUserManager
{
    NSString *userToken = [KUserDefaul objectForKey:User_Token];
    NSString *userID = [KUserDefaul objectForKey:User_ID];
//    if(userToken != nil && userID.integerValue >0)
//    {
//        self.mainTabBar = [MainTabBarController new];
//        self.window.rootViewController = self.mainTabBar;
//    }else{
//        
//        self.mainTabBar = nil;
//        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
//        self.window.rootViewController = loginNavi;
//    }
    
    self.mainTabBar = [MainTabBarController new];
    self.window.rootViewController = self.mainTabBar;
}
//配置高德地图
- (void)AMapServices
{
    [AMapServices sharedServices].apiKey = AMapKey;
}
+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark ————— 获取当前VC —————
-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end

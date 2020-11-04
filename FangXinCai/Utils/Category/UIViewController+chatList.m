//
//  UIViewController+chatList.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "UIViewController+chatList.h"
#import "LoginViewController.h"
#import "CartShopManager.h"
@implementation UIViewController (chatList)
/// 登录
- (void)loginSuccess:(void (^)())success {
    [self loginWithPro:@"toBack" Success:success];
}
- (void)loginWithPro:(NSString *)pro Success:(void (^)())success {
   
    LoginViewController *login=[[LoginViewController alloc]init];
    login.isAutoLoginOut = YES;
    [login returnLoginSuccess:success];
    
    UIViewController *topVC = [self topViewController];
    if (![topVC isKindOfClass:[LoginViewController class]]) {
        [self presentViewController:login animated:YES completion:nil];
    }
}

//获取当前的VC
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

/**
 *  改变购物车tabbar上的数量
 */
-(void)changeTabbarCartNum
{
    NSInteger cart2= [CartShopManager cartShopManarer].cartCount;
    if(cart2>0){
        [kAppDelegate.mainTabBar showBadgeOnItemIndex:3];
        [kAppDelegate.mainTabBar changeBadgeNumOnItemIndex:3 withNum:[NSString stringWithFormat:@"%zd",cart2]];
    }else
        [kAppDelegate.mainTabBar hideBadgeOnItemIndex:3];
}
@end

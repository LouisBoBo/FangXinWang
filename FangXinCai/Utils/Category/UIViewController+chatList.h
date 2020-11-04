//
//  UIViewController+chatList.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
@interface UIViewController (chatList)
/// 登录
- (void)loginSuccess:(void (^)())success;

/**
 *  改变购物车tabbar上的数量
 */
@property (nonatomic , strong) MainTabBarController *maintabBar;
-(void)changeTabbarCartNum;
@end

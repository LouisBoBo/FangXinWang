//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "DishesViewController.h"
#import "MenuViewController.h"
#import "CartViewController.h"
#import "MineViewController.h"
#import "RootNavigationController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[XYTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;

    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [self setupChildViewController:homeVC title:@"首页" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];
    
    DishesViewController *dishesVC = [[DishesViewController alloc]init];
    [self setupChildViewController:dishesVC title:@"菜品" imageName:@"icon_tabbar_onsite" seleceImageName:@"icon_tabbar_onsite_selected"];
    
    MenuViewController *menuVC = [MenuViewController new];
    [self setupChildViewController:menuVC title:@"菜单" imageName:@"icon_tabbar_merchant_normal" seleceImageName:@"icon_tabbar_merchant_selected"];
    
    CartViewController *cartVC = [[CartViewController alloc]init];
    cartVC.ShopCart_Type = ShopCart_TarbarType;
    [self setupChildViewController:cartVC title:@"购物车" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
    
    self.viewControllers = _VCS;
    
//    [self showBadgeOnItemIndex:3];
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:basegreenColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
//    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //    NSLog(@"选中 %ld",tabBarController.selectedIndex);
    
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.layer.borderColor=[UIColor whiteColor].CGColor;
    badgeView.backgroundColor = [UIColor redColor];
    badgeView.textColor=[UIColor whiteColor];
    badgeView.font=[UIFont systemFontOfSize:10];
    badgeView.textAlignment=NSTextAlignmentCenter;
    badgeView.tag=88+index;
    badgeView.frame = CGRectMake(kScreenWidth/5*index+kScreenWidth/5/2+5,5, KZOOM6pt(30), KZOOM6pt(30));
    badgeView.layer.cornerRadius = KZOOM6pt(15);
    badgeView.layer.masksToBounds = YES;//very important
    
    [self.tabBar addSubview:badgeView];
}

-(void)changeBadgeNumOnItemIndex:(int)index withNum:(NSString *)Num
{
    for (UILabel *subView in self.tabBar.subviews) {
        if (subView.tag == 88+index) {
            if (Num.integerValue!=0) {
                subView.frame = CGRectMake(kScreenWidth/5*index+kScreenWidth/5/2+5,2, 16, 16);
                subView.layer.cornerRadius = 8;
            }else{
                subView.frame = CGRectMake(kScreenWidth/5*index+kScreenWidth/5/2+5,5, KZOOM6pt(30), KZOOM6pt(30));
                subView.layer.cornerRadius = KZOOM6pt(15);
            }
            subView.text=[NSString stringWithFormat:@"%@",Num.integerValue<100?Num:@"99"];
        }
    }
}
- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}
- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.tabBar.subviews) {
        if (subView.tag == 88+index) {
            [subView removeFromSuperview];
        }
    }
}
@end

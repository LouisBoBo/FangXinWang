//
//  SelectCouponViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "NotUsedViewController.h"
@interface SelectCouponViewController ()
@property (nonatomic, strong) NotUsedViewController *oneVC;
@end

@implementation SelectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择优惠券";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageView];
    
    NSArray *titles = @[@"确定"];
    NSArray *tags   = @[@"10000"];
    [self addNavigationItemWithTitles:titles isLeft:NO target:self action:@selector(changClick) tags:tags];
}

- (void)changClick
{
    [self.oneVC selectCouponHttp];
}

- (void)setupPageView {
    
    self.oneVC = [[NotUsedViewController alloc] init];
    self.oneVC.couponModel = self.couponModel;
    self.oneVC.is_selectCoupon = YES;
    kWeakSelf(self);
    self.oneVC.selectCouponBlock = ^(CouponData *data, NSDictionary *dic) {
        if(weakself.selectCouponBlock)
        {
            weakself.selectCouponBlock(data,dic);
        }
    };
    
    [self addChildViewController:self.oneVC];
    [self.view addSubview:self.oneVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

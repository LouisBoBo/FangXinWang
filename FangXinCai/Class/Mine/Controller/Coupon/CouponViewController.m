//
//  CouponViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CouponViewController.h"
#import "NotUsedViewController.h"
#import "ExpiredViewController.h"
@interface CouponViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, assign) NSInteger currentViewIndex;
@property (nonatomic, strong) NotUsedViewController *oneVC;
@property (nonatomic, strong) ExpiredViewController *twoVC;
@end

@implementation CouponViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self setupPageView];
    
    NSArray *titles = @[@"兑换"];
    NSArray *tags   = @[@"10000"];
    [self addNavigationItemWithTitles:titles isLeft:NO target:self action:@selector(changClick) tags:tags];
    
}

- (void)changClick
{
    NSLog(@"兑换");
}
- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView {
    CGFloat pageTitleViewY = 0;
    
    NSArray *titleArr = @[@"未使用",@"已过期"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = basegreenColor;
    configure.indicatorColor     = basegreenColor;
    
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 40) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    
    self.oneVC = [[NotUsedViewController alloc] init];
    self.oneVC.couponModel = self.couponModel;
    kWeakSelf(self);
    self.oneVC.selectCouponBlock = ^(CouponData *data, NSDictionary *dic) {
        if(weakself.selectCouponBlock)
        {
            weakself.selectCouponBlock(data,dic);
        }
    };
    
    self.twoVC = [[ExpiredViewController alloc] init];
   
    NSArray *childArr = @[self.oneVC, self.twoVC];
    
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    self.currentViewIndex = selectedIndex;
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end

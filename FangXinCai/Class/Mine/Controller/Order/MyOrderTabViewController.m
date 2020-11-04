//
//  MyOrderTabViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MyOrderTabViewController.h"
#import "TotalOrderViewController.h"
#import "PaymentOrderViewController.h"
#import "DeliveryOrderViewController.h"
#import "ReceivedOrderViewController.h"
#import "FinishOrderViewController.h"

@interface MyOrderTabViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@end

@implementation MyOrderTabViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self setupPageView];
    
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView {
    CGFloat pageTitleViewY = 0;

    NSArray *titleArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = basegreenColor;
    configure.indicatorColor     = basegreenColor;
    
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.selectedIndex = self.selectHeadIndex;
    [self.view addSubview:_pageTitleView];
    
    TotalOrderViewController *oneVC = [[TotalOrderViewController alloc] init];
    PaymentOrderViewController *twoVC = [[PaymentOrderViewController alloc] init];
    DeliveryOrderViewController *threeVC = [[DeliveryOrderViewController alloc] init];
    ReceivedOrderViewController *fourVC = [[ReceivedOrderViewController alloc] init];
    FinishOrderViewController *fiveVC = [[FinishOrderViewController alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC, fiveVC];
    
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    if(self.selectHeadIndex)
    {
        [self.pageTitleView setPageTitleViewWithProgress:KScreenWidth*self.selectHeadIndex originalIndex:self.selectHeadIndex targetIndex:self.selectHeadIndex];
    }
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)backBtnClicked
{
    if([self.comefrom isEqualToString:@"支付"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

//
//  WithdrawalsViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "WithdrawalsViewController.h"

@interface WithdrawalsViewController ()

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.title = @"提现";
    
    [self MainView];
}

- (void)MainView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardSelect:)];
    [self.dtawalsCard addGestureRecognizer:tap];
    [self.goImg addGestureRecognizer:tap];
    
    self.drawalsTextField.borderStyle = UITextBorderStyleNone;
    
    [self.drawalsBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.drawalsBtn addTarget:self action:@selector(drawalsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.OKBtn.backgroundColor = basegreenColor;
    self.OKBtn.layer.cornerRadius = CGRectGetHeight(self.OKBtn.frame)/2;
    [self.OKBtn addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
}
//选择提现方式
- (void)cardSelect:(UITapGestureRecognizer*)tap
{
    NSLog(@"提现方式");
}
//全部提现
- (void)drawalsClick:(UIButton*)sender
{
    NSLog(@"全部提现");
}
//确认
- (void)okClick:(UIButton*)sender
{
    NSLog(@"确认");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

//
//  RechargeViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()
@property (weak, nonatomic) IBOutlet UIView *titlemoneyview;
@property (weak, nonatomic) IBOutlet UIView *backview;
- (IBAction)okBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *moneytextfild;

@end

@implementation RechargeViewController
{
    CGFloat spaceHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.weixinBtn.selected = YES;
    self.isHidenKeyToolBar  = NO;
    self.title = @"充值";
    spaceHeight = 60;

    [self paySelected];
    
}
- (void)viewWillAppear:(BOOL)animated
{
//    [self handleView];
}
- (void)setMoneytextfild:(UITextField *)moneytextfild
{
    moneytextfild.layer.borderWidth = 0;
    moneytextfild.layer.borderColor = KWhiteColor.CGColor;
    moneytextfild.borderStyle = UITextBorderStyleNone;
}
- (void)handleView
{
    [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(225);
    }];
    
    [self.view addSubview:self.updownview];
    [self.updownview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.backview);
        make.bottom.equalTo(self.backview).offset(30);
        make.height.mas_equalTo(60);
    }];
    
    [self.updownview addSubview:self.updownBtn];
    self.updownview.userInteractionEnabled = YES;
    [self.updownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updownview);
        make.centerX.equalTo(self.updownview);
        make.width.height.mas_equalTo(30);
    }];
    
}
- (void)paySelected
{
    [self.weixinBtn setImage:[UIImage imageNamed:@"未选中圆点"] forState:UIControlStateNormal];
    [self.weixinBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    
    [self.zfbBtn setImage:[UIImage imageNamed:@"未选中圆点"] forState:UIControlStateNormal];
    [self.zfbBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    
    [self.cardBtn setImage:[UIImage imageNamed:@"未选中圆点"] forState:UIControlStateNormal];
    [self.cardBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    
   
    [self.okBtn setBackgroundImage:[UIImage imageWithColor:basegreenColor] forState:UIControlStateNormal];
    self.okBtn.clipsToBounds = YES;
    self.okBtn.layer.cornerRadius = 20;
    
    [self.weixinBtn addTarget:self action:@selector(weixingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.zfbBtn addTarget:self action:@selector(zfbClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cardBtn addTarget:self action:@selector(cardClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)weixingClick:(UIButton*)sender
{
    if(sender != self.selectBtn)
    {
        sender.selected = !sender.selected;
    }
    
    self.zfbBtn.selected = NO;
    self.cardBtn.selected = NO;
    self.selectBtn = sender;
}
- (void)zfbClick:(UIButton*)sender
{
    if(sender != self.selectBtn)
    {
        sender.selected = !sender.selected;
    }
    
    self.weixinBtn.selected = NO;
    self.cardBtn.selected = NO;
    self.selectBtn = sender;
}
- (void)cardClick:(UIButton*)sender
{
    if(sender != self.selectBtn)
    {
        sender.selected = !sender.selected;
    }
    
    self.zfbBtn.selected = NO;
    self.weixinBtn.selected = NO;
    self.selectBtn = sender;
}

- (void)updown:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        [self.updownview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.backview);
            make.top.equalTo(self.backview).offset(100);
            make.height.mas_equalTo(60);
        }];
    }else{
        [self.updownview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.backview);
            make.top.mas_offset(165);
            make.height.mas_equalTo(60);
        }];
    }
}

- (UIView *)updownview
{
    if(_updownview == nil)
    {
        _updownview = [[UIView alloc]init];
        _updownview.backgroundColor = basegreenColor;
    }
    return _updownview;
}
- (UIView *)updownBtn
{
    if(_updownBtn == nil)
    {
        _updownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updownBtn setBackgroundImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        [_updownBtn setBackgroundImage:[UIImage imageNamed:@"上"] forState:UIControlStateSelected];
        [_updownBtn addTarget:self action:@selector(updown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updownBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)okBtn:(UIButton *)sender {
}
@end

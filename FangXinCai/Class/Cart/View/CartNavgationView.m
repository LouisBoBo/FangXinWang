//
//  CartNavgationView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/25.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CartNavgationView.h"

@implementation CartNavgationView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        [self creatNavgationView:frame];
    }
    return self;
}

- (void)creatNavgationView:(CGRect)frame
{
    UIView *naview = [[UIView alloc] initWithFrame:frame];
    naview.userInteractionEnabled = YES;
    [self addSubview:naview];
    
    UILabel *titlelab = [UILabel new];
    titlelab.text = @"购物车";
    titlelab.textColor = CNavBgFontColor;
    titlelab.font = [UIFont systemFontOfSize:18];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [naview addSubview:titlelab];
    
    UIButton *customer = [UIButton buttonWithType:UIButtonTypeCustom];
    [customer setBackgroundImage:[UIImage imageNamed:@"客服咨询灰"] forState:UIControlStateNormal];
    [customer addTarget:self action:@selector(customer:) forControlEvents:UIControlEventTouchUpInside];
    [naview addSubview:customer];
    
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editbtn setTitle:@"完成" forState:UIControlStateSelected];
    [editbtn setTitleColor:KGrayColor forState:UIControlStateNormal];
    editbtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [editbtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [naview addSubview:editbtn];
    
    UILabel *linelab = [UILabel new];
    linelab.backgroundColor = CLineColor;
    [self addSubview:linelab];
    
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [customer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(KScreenWidth-40);
        make.width.height.mas_equalTo(20);
    }];
    
    [editbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customer).offset(KZOOM6pt(3));
        make.left.mas_equalTo(KScreenWidth - 95);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    [linelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
        make.top.mas_equalTo(63);
        make.height.mas_equalTo(1);
    }];
}

- (void)editClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    NSLog(@"编辑");
    if(self.editBlock)
    {
        self.editBlock(sender.selected);
    }
}

- (void)customer:(UIButton*)sender
{
    NSLog(@"客服");
    if(self.customerBlock)
    {
        self.customerBlock();
    }
}
@end

//
//  OrderShopFootView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "OrderShopFootView.h"

@implementation OrderShopFootView
- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self = [super initWithFrame:frame])
    {
        [self creatFootView:frame];
    }
    return self;
}

- (void)creatFootView:(CGRect)frame
{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    [self addSubview:self.footView];
    
    UILabel *lineview = [UILabel new];
    lineview.backgroundColor = CLineColor;
    [self.footView addSubview:lineview];
    
    [self.footView addSubview:self.orderHandleView];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(1);
    }];
}

- (UIView*)orderHandleView
{
    if(_orderHandleView == nil)
    {
        _orderHandleView = [UIView new];
        _orderHandleView.frame = CGRectMake(0, 1, kScreenWidth, 49);
        
        NSArray *titleArr = @[@"付款",@"取消订单"];
        for(int i=0; i<titleArr.count; i++)
        {
            UIButton *handelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            handelBtn.layer.cornerRadius = 15;
            handelBtn.layer.borderWidth = 1;
            handelBtn.layer.borderColor = basegreenColor.CGColor;
            [handelBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [handelBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
            handelBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
            [_orderHandleView addSubview:handelBtn];
            
            [handelBtn addTarget:self
                          action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [handelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_orderHandleView).offset(-10-i*90);
                make.centerY.equalTo(_orderHandleView);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(30);
            }];
        }
    }
    
    return _orderHandleView;
}
- (void)btnClick:(UIButton*)sender
{
    if(self.orderHandleBlock)
    {
        self.orderHandleBlock(sender.titleLabel.text);
    }
}
@end

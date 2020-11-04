//
//  OrderShopHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "OrderShopHeadView.h"

@implementation OrderShopHeadView
- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self = [super initWithFrame:frame])
    {
        [self creaHeadView:frame];
    }
    
    return self;
}

- (void)creaHeadView:(CGRect)frame
{
    self.orderDeatilHeadview = [[UIView alloc]initWithFrame:frame];
    [self addSubview:self.orderDeatilHeadview];
    
    [self.orderDeatilHeadview addSubview:self.orderStatusView];
    [self.orderDeatilHeadview addSubview:self.orderAddressView];
}

- (UIView*)orderStatusView
{
    if(_orderStatusView == nil)
    {
        _orderStatusView = [UIView new];
        _orderStatusView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        _orderStatusView.backgroundColor = RGBCOLOR(255, 244, 220);
        
        UIImageView *timeimage = [[UIImageView alloc]init];
        timeimage.image = [UIImage imageNamed:@"时间"];
        [_orderStatusView addSubview:timeimage];
        
        UILabel *titlelab = [UILabel new];
        titlelab.text = @"等待你付款";
        titlelab.textColor = [UIColor redColor];
        titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(40)];
        [_orderStatusView addSubview:titlelab];
        
        UILabel *distributionlab = [UILabel new];
        distributionlab.text = @"剩1小时订单将自动取消";
        distributionlab.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        distributionlab.textColor = KGrayColor;
        [_orderStatusView addSubview:distributionlab];
        
        [timeimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(_orderStatusView);
            make.width.height.mas_equalTo(30);
        }];
        
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeimage).offset(40);
            make.top.mas_equalTo(10);
            make.right.equalTo(_orderStatusView).offset(-10);
            make.height.mas_equalTo(30);
        }];
        
        [distributionlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titlelab);
            make.top.equalTo(titlelab).offset(30);
            make.height.mas_equalTo(30);
        }];
    }
    return _orderStatusView;
}

- (UIView*)orderAddressView
{
    if(_orderAddressView == nil)
    {
        _orderAddressView = [UIView new];
        _orderAddressView.frame = CGRectMake(0, 90, kScreenWidth, 80);
        _orderAddressView.backgroundColor = KWhiteColor;
        
        UIImageView *addressimage = [[UIImageView alloc]init];
        addressimage.image = [UIImage imageNamed:@"地址"];
        [_orderAddressView addSubview:addressimage];
        
        UILabel *Consignee = [UILabel new];
        Consignee.text = [NSString stringWithFormat:@"收货人：%@",@"baby"];
        Consignee.textColor = KGrayColor;
        Consignee.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:Consignee];
        
        UILabel *phone = [UILabel new];
        phone.text = @"18585858585";
        phone.textColor = KGrayColor;
        phone.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:phone];
        
        UILabel *address = [UILabel new];
        address.text = @"事件发生发十几分老骥伏枥首颗福建师范标题";
        address.numberOfLines = 0;
        address.textColor = KGrayColor;
        address.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:address];
        
        [addressimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(_orderAddressView);
            make.width.height.mas_equalTo(30);
        }];
        
        [Consignee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressimage).offset(40);
            make.top.mas_equalTo(10);
            make.right.equalTo(_orderAddressView).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_orderAddressView).offset(-10);
            make.top.height.equalTo(Consignee);
            make.width.mas_equalTo(100);
        }];
        
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(Consignee);
            make.top.equalTo(Consignee).offset(20);
            make.height.mas_equalTo(40);
        }];
    }
    return _orderAddressView;
}
@end

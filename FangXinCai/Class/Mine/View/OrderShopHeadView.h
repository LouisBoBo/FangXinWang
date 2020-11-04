//
//  OrderShopHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShopHeadView : UIView
@property (nonatomic , strong) UIView *orderDeatilHeadview;
@property (nonatomic , strong) UIView *orderStatusView;       //订单状态
@property (nonatomic , strong) UIView *orderAddressView;      //订单地址
- (instancetype)initWithFrame:(CGRect)frame;
@end

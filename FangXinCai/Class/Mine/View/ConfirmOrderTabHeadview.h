//
//  ConfirmOrderTabHeadview.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopModel.h"
@interface ConfirmOrderTabHeadview : UIView
@property (nonatomic , strong) UIView *confirmOrderHead;
@property (nonatomic , strong) UIView *orderAddressView;      //订单地址
@property (nonatomic , strong) UILabel *ConsigneeLab;
@property (nonatomic , strong) UILabel *phoneLab;
@property (nonatomic , strong) UILabel *addressLab;
@property (nonatomic , strong) UIScrollView *shopScrollview;
@property (nonatomic , strong) UIView *orderShopView;         //订单商品
@property (nonatomic , strong) UILabel *countLab;

@property (nonatomic , strong) void(^selectShopClick)(GoodsShopData*shopdata);
@property (nonatomic , strong) NSMutableArray *shopDataArray;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)refreshUI:(NSDictionary*)data;
@end

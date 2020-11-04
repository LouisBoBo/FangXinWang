//
//  SelectCouponViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"
@interface SelectCouponViewController : BaseViewController
@property (nonatomic , strong) CouponModel *couponModel;
@property (nonatomic , strong) void(^selectCouponBlock)(CouponData*data,NSDictionary*dic);//选择的优惠券
@end

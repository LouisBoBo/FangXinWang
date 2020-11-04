//
//  ExpiredViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseCouponViewController.h"

@interface ExpiredViewController : BaseCouponViewController
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) CouponModel *couponModel;
- (void)selectCouponHttp;
@end

//
//  CouponModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/28.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CouponData;
@interface CouponModel : NSObject
@property (nonatomic , strong) NSArray <CouponData *> *coupon_list;
@end

@interface CouponData :NSObject
@property (nonatomic , strong) NSString * condition;
@property (nonatomic , strong) NSString * ID;
@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSString * real_condition;
@property (nonatomic , strong) NSString * use_end_time;
@property (nonatomic , strong) NSString * use_start_time;
@property (nonatomic , assign) BOOL is_select;
@end

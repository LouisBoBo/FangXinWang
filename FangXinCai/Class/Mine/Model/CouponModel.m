//
//  CouponModel.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/28.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
+ (NSDictionary*)mj_objectClassInArray{
    return @{@"coupon_list" : [CouponData class]};
}

@end

@implementation CouponData
+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end

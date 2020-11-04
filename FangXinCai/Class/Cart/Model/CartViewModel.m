//
//  CartViewModel.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CartViewModel.h"

@implementation CartViewModel
+(NSDictionary*)mj_objectClassInArray
{
    return @{@"data":[ShopCartModel class]};
}
@end

@implementation ShopCartModel
+(NSDictionary*)mj_objectClassInArray
{
    return @{@"list":[ShopCartData class]};
}
@end

@implementation ShopCartData
+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end

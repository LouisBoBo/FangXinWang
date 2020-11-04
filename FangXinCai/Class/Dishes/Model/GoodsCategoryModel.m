//
//  GoodsCategoryModel.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "GoodsCategoryModel.h"

@implementation GoodsCategoryModel
+ (NSDictionary*)mj_objectClassInArray{
    return @{@"data" : [GoodsCategoryData class]};
}

@end

@implementation GoodsCategoryData
+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+ (NSDictionary*)mj_objectClassInArray{
    return @{@"child" : [GoodsCategoryData class]};
}
@end



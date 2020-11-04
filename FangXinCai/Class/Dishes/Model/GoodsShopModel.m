//
//  GoodsShopModel.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/30.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "GoodsShopModel.h"

@implementation GoodsShopModel
+ (NSDictionary*)mj_objectClassInArray{
    return @{@"data" : [GoodsShopData class]};
}
@end

@implementation GoodsShopData
+ (NSDictionary*)mj_objectClassInArray{
    return @{@"child" : [GoodSonShopData class]};
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    GoodsShopData *instance = [[GoodsShopData alloc] init];
    if (instance) {
        instance.cat_id = self.cat_id;
        instance.goods_img = [self.goods_img copyWithZone:zone];
        instance.goods_id = [self.goods_id copyWithZone:zone];
        instance.goods_name = [self.goods_name copyWithZone:zone];
        instance.goods_num = [self.goods_num copyWithZone:zone];
        instance.goods_sn = [self.goods_sn copyWithZone:zone];
        instance.goods_unit = [self.goods_unit copyWithZone:zone];
        instance.item_id = [self.item_id copyWithZone:zone];
        instance.key_name = [self.key_name copyWithZone:zone];
        instance.market_price = [self.market_price copyWithZone:zone];
        instance.original_img = [self.original_img copyWithZone:zone];
        instance.price = [self.price copyWithZone:zone];
        instance.prom_id = [self.prom_id copyWithZone:zone];
        instance.prom_type = [self.prom_type copyWithZone:zone];
        instance.sales_sum = [self.sales_sum copyWithZone:zone];
        instance.shop_price = [self.shop_price copyWithZone:zone];
        instance.spec_count = [self.spec_count copyWithZone:zone];
        instance.spec_key = [self.spec_key copyWithZone:zone];
        instance.spec_price = [self.spec_price copyWithZone:zone];
        instance.sprom_id = [self.sprom_id copyWithZone:zone];
        instance.sprom_type = [self.sprom_type copyWithZone:zone];
        instance.store_count = [self.store_count copyWithZone:zone];
        
        instance.child = self.child;
        instance.moreSpeckey = self.moreSpeckey;
        instance.selectMoreSpeckey = self.selectMoreSpeckey;
        instance.childSpeckey = self.childSpeckey;
        
    }
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    GoodsShopData *instance = [[GoodsShopData alloc] init];
    if (instance) {
        instance.cat_id = self.cat_id;
        instance.goods_img = self.goods_img;
        instance.goods_id = [self.goods_id copyWithZone:zone];
        instance.goods_name = [self.goods_name copyWithZone:zone];
        instance.goods_num = [self.goods_num copyWithZone:zone];
        instance.goods_sn = [self.goods_sn copyWithZone:zone];
        instance.goods_unit = [self.goods_unit copyWithZone:zone];
        instance.item_id = [self.item_id copyWithZone:zone];
        instance.key_name = [self.key_name copyWithZone:zone];
        instance.market_price = [self.market_price copyWithZone:zone];
        instance.original_img = [self.original_img copyWithZone:zone];
        instance.price = [self.price copyWithZone:zone];
        instance.prom_id = [self.prom_id copyWithZone:zone];
        instance.prom_type = [self.prom_type copyWithZone:zone];
        instance.sales_sum = [self.sales_sum copyWithZone:zone];
        instance.shop_price = [self.shop_price copyWithZone:zone];
        instance.spec_count = [self.spec_count copyWithZone:zone];
        instance.spec_key = [self.spec_key copyWithZone:zone];
        instance.spec_price = [self.spec_price copyWithZone:zone];
        instance.sprom_id = [self.sprom_id copyWithZone:zone];
        instance.sprom_type = [self.sprom_type copyWithZone:zone];
        instance.store_count = [self.store_count copyWithZone:zone];
        
        instance.child = self.child;
        instance.moreSpeckey = self.moreSpeckey;
        instance.selectMoreSpeckey = self.selectMoreSpeckey;
        instance.childSpeckey = self.childSpeckey;
    }
    return instance;
}
@end

@implementation GoodSonShopData
+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"shopdescription":@"description",@"ID":@"id"};
}
@end

//
//  GoodsShopModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/30.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsCategoryModel.h"
@class GoodsShopData;
@interface GoodsShopModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSArray<GoodsShopData *> *data;
@property (nonatomic, assign) NSInteger code;
@end

@class GoodSonShopData;
@interface GoodsShopData :NSObject<NSCopying,NSMutableCopying>
@property (nonatomic , copy) NSString *cat_id;
@property (nonatomic , copy) NSString *goods_id;
@property (nonatomic , copy) NSString *goods_img;
@property (nonatomic , copy) NSString *goods_name;
@property (nonatomic , copy) NSString *goods_num;
@property (nonatomic , copy) NSString *goods_sn;
@property (nonatomic , copy) NSString *goods_unit;
@property (nonatomic , copy) NSString *item_id;
@property (nonatomic , copy) NSString *key_name;
@property (nonatomic , copy) NSString *market_price;
@property (nonatomic , copy) NSString *original_img;
@property (nonatomic , copy) NSString *price;
@property (nonatomic , copy) NSString *prom_id;
@property (nonatomic , copy) NSString *prom_type;
@property (nonatomic , copy) NSString *sales_sum;
@property (nonatomic , copy) NSString *shop_price;
@property (nonatomic , copy) NSString *spec_count;
@property (nonatomic , copy) NSString *spec_key;
@property (nonatomic , copy) NSString *spec_price;
@property (nonatomic , copy) NSString *sprom_id;
@property (nonatomic , copy) NSString *sprom_type;
@property (nonatomic , copy) NSString *store_count;
@property (nonatomic , copy) NSString *spec_key_name;
@property (nonatomic , strong) NSArray<GoodSonShopData*> *child;

@property (nonatomic , assign) BOOL moreSpeckey;      //多种规格
@property (nonatomic , assign) BOOL selectMoreSpeckey;//选规格
@property (nonatomic , assign) BOOL childSpeckey;     //子规格
@end

@interface GoodSonShopData :NSObject
@property (nonatomic , strong) NSString *shopdescription;
@property (nonatomic , strong) NSString *end_time;
@property (nonatomic , strong) NSString *expression;
@property (nonatomic , strong) NSString *ID;
@property (nonatomic , strong) NSString *is_end;
@property (nonatomic , strong) NSString *prom_img;
@property (nonatomic , strong) NSString *start_time;
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *type;
@end

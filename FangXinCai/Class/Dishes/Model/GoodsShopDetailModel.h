//
//  GoodsShopDetailModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/5.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsShopDetailData;
@interface GoodsShopDetailModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) GoodsShopDetailData *data;
@property (nonatomic, assign) NSInteger code;
@end

@class GoodsattrData;
@class GoodsimageData;
@class GoodsinfoData;
@class GoodscartData;
@class GoodsserviceData;
@class GoodsspecData;
@interface GoodsShopDetailData : NSObject
@property (nonatomic, strong) NSDictionary *goods_cart;
@property (nonatomic, strong) NSDictionary *goods_info;
@property (nonatomic, strong) NSArray<GoodsattrData *> *goods_attr;
@property (nonatomic, strong) NSArray<GoodsimageData *> *goods_image;
@property (nonatomic, strong) NSDictionary *goods_service;
@property (nonatomic, strong) NSArray<GoodsspecData*>  *goods_spec;
@end

@interface GoodsattrData : NSObject
@property (nonatomic, copy)   NSString *attr_name;
@property (nonatomic, copy)   NSString *attr_value;
@end

@interface GoodscartData : NSObject
@property (nonatomic, copy)   NSString *count;
@property (nonatomic, copy)   NSString *goods_total_price;
@property (nonatomic, copy)   NSString *order_total_price;
@property (nonatomic, copy)   NSString *promotion_price;
@property (nonatomic, copy)   NSString *shipping_fee;
@property (nonatomic, copy)   NSString *status;
@end

@interface GoodsinfoData :NSObject

@end

@interface GoodsimageData : NSObject

@end

@interface GoodsserviceData : NSObject
@property (nonatomic, copy)   NSString *headImage;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *value;
@end

@interface GoodsspecData : NSObject
@property (nonatomic, copy)   NSString *bar_code;
@property (nonatomic, copy)   NSString *goods_id;
@property (nonatomic, copy)   NSString *item_id;
@property (nonatomic, copy)   NSString *key;
@property (nonatomic, copy)   NSString *key_name;
@property (nonatomic, copy)   NSString *price;
@property (nonatomic, copy)   NSString *value;
@property (nonatomic, copy)   NSString *prom_id;
@property (nonatomic, copy)   NSString *prom_type;
@property (nonatomic, copy)   NSString *selected;
@property (nonatomic, copy)   NSString *sku;
@property (nonatomic, copy)   NSString *spec_img;
@property (nonatomic, copy)   NSString *spec_key;
@property (nonatomic, copy)   NSString *store_count;
@end


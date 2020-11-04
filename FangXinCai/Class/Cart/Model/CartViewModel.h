//
//  CartViewModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShopCartModel;
@interface CartViewModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSArray<ShopCartModel *> *data;
@property (nonatomic, assign) NSInteger code;
@end

@class ShopCartData;
@interface ShopCartModel : NSObject
@property (nonatomic , strong) NSString *cat_name;
@property (nonatomic , strong) NSArray<ShopCartData*>*list;
@end

@interface ShopCartData : NSObject
@property (nonatomic , strong) NSNumber *goods_num;
@property (nonatomic , strong) NSNumber *member_goods_price;
@property (nonatomic , strong) NSNumber *add_time;
@property (nonatomic , strong) NSNumber *bar_code;
@property (nonatomic , strong) NSString *cat_id;
@property (nonatomic , strong) NSString *cat_name;
@property (nonatomic , strong) NSNumber *ggoods_id;
@property (nonatomic , strong) NSString *goods_id;
@property (nonatomic , strong) NSString *goods_name;
@property (nonatomic , strong) NSNumber *goods_price;
@property (nonatomic , strong) NSString *goods_sn;
@property (nonatomic , strong) NSString *goods_unit;
@property (nonatomic , strong) NSNumber *gprom_id;
@property (nonatomic , strong) NSNumber *gprom_type;
@property (nonatomic , strong) NSString *ID;
@property (nonatomic , strong) NSNumber *is_on_sale;
@property (nonatomic , strong) NSNumber *market_price;
@property (nonatomic , strong) NSString *original_img;
@property (nonatomic , strong) NSNumber *prom_id;
@property (nonatomic , strong) NSNumber *prom_type;
@property (nonatomic , strong) NSNumber *selected;
@property (nonatomic , strong) NSNumber *session_id;
@property (nonatomic , strong) NSNumber *shop_price;
@property (nonatomic , strong) NSString *price;
@property (nonatomic , strong) NSString *sku;
@property (nonatomic , strong) NSString *spec_key;
@property (nonatomic , strong) NSString *spec_key_name;
@property (nonatomic , strong) NSNumber *user_id;

@property (nonatomic , assign) BOOL moreSpeckey;      //多种规格
@end

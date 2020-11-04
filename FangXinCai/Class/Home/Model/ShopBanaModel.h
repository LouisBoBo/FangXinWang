//
//  ShopBanaModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/25.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopBanaData;
@interface ShopBanaModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSArray<ShopBanaData *> *data;
@property (nonatomic, assign) NSInteger code;
@end

/**
 "ad_code":"public/b4a56430dbcf697285a46bd4.jpg",//图片地址
 "ad_name":"张雪峰", //广告名称
 "special_id":1,    //商品专区id
 "ad_link":"mobile/Goods/specialGoods/special_id/1",/跳转地址
 */
@interface ShopBanaData : NSObject
@property (nonatomic , copy) NSString *ad_code;
@property (nonatomic , copy) NSString *ad_name;
@property (nonatomic , copy) NSString *special_id;
@property (nonatomic , copy) NSString *ad_link;
@end

//
//  CartCountModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartCountModel : NSObject
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) NSString *goods_total_price;
@property (nonatomic , strong) NSString *order_total_price;
@property (nonatomic , strong) NSString *prom_order_id;
@property (nonatomic , strong) NSString *promotion_price;
@property (nonatomic , strong) NSString *shipping_fee;
@property (nonatomic , assign) NSInteger status;
@end

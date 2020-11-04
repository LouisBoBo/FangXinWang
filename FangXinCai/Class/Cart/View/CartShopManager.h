//
//  CartShopManager.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartShopManager : NSObject
+(instancetype)cartShopManarer;
//购物车数量
@property (nonatomic , assign)NSInteger cartCount;

//加减购物车
- (void)AddReduiceCartShop:(NSString*)good_num Goods_id:(NSString*)goods_id Spec_key:(NSString*)spec_key Success:(void(^)(id data))success;
//勾选商品
- (void)selectCartShopHttp:(NSString*)cart_id Select:(BOOL)isSelect Success:(void(^)(id data))success;
//删除购物车商品
- (void)deleateCartShopHttp:(NSString*)cart_id Success:(void(^)(id data))success;
//加入/删除常用菜品
- (void)goodsCollectHttp:(NSString*)goods_id Success:(void(^)(id data))success;
@end

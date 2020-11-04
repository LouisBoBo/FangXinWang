//
//  CartShopManager.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CartShopManager.h"

@implementation CartShopManager
+(instancetype)cartShopManarer
{
    static CartShopManager *cartManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cartManager = [[self alloc] init];
        assert(cartManager != nil);
    });
    return cartManager;
}

- (void)AddReduiceCartShop:(NSString*)good_num Goods_id:(NSString*)goods_id Spec_key:(NSString*)spec_key Success:(void(^)(id data))success;
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:goods_id forKey:@"goods_id"];
    [reqDict setValue:spec_key forKey:@"spec_key"];
    [reqDict setValue:good_num forKey:@"goods_num"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"editCartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
        
            if(success)
            {
                success(responseObject);
            }
            
            NSString *count = responseObject[@"data"][@"count"];
            self.cartCount = count.integerValue;
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

- (void)selectCartShopHttp:(NSString*)cart_id Select:(BOOL)isSelect Success:(void(^)(id data))success;
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:cart_id forKey:@"id"];
    [reqDict setValue:[NSString stringWithFormat:@"%d",!isSelect] forKey:@"selected"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"selectCartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
//    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
            if(success)
            {
                success(responseObject);
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

- (void)deleateCartShopHttp:(NSString*)cart_id Success:(void(^)(id data))success;
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:cart_id forKey:@"id"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"delCartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
            if(success)
            {
                success(responseObject);
                
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

- (void)goodsCollectHttp:(NSString*)goods_id Success:(void(^)(id data))success;
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:goods_id forKey:@"goods_id"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"goodsCollect.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
            if(success)
            {
                success(responseObject);
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}
@end

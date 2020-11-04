//
//  BaseCouponViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"
@interface BaseCouponViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *httpDataArr;
@property (nonatomic , strong) void(^selectCouponBlock)(CouponData*data,NSDictionary*dic);//选择的优惠券
@property (nonatomic , assign) BOOL isExpired;              //是否过期
- (void)loadDatas:(BOOL)isExpired;
- (void)selectCouponHttp;                                   //选优惠券
@end

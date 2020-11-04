//
//  OrderDetailViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;//订单商品数据
@property (nonatomic , strong) NSMutableDictionary *orderDic;//订单相关
@property (nonatomic , strong) NSMutableDictionary *payDic;  //支付相关
@property (nonatomic , strong) NSString *comefrom;           //支付过来的
@end

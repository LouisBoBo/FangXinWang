//
//  CartViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,CART_TYPE) {
    ShopCart_NormalType=0,
    ShopCart_TarbarType=1
};
@interface CartViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray*tabDataArr;
@property (nonatomic , strong) NSMutableArray*selectShopArr;
@property (nonatomic , strong) NSMutableArray*sectionSelectArr;
@property (nonatomic , strong) UILabel *shopInfolab;     //所选商品信息
@property (nonatomic , assign) BOOL isJoin;              //是否凑单
@property (nonatomic , assign) CART_TYPE ShopCart_Type;
@end

//
//  StoreManagViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseSearchViewController.h"

@interface StoreManagViewController : BaseSearchViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIButton *footButton;        //新建门店
@end

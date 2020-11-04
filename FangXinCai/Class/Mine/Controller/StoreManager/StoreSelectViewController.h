//
//  StoreSelectViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseSearchViewController.h"
#import "PickShopModel.h"
@interface StoreSelectViewController : BaseSearchViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIButton *footButton;          //新建门店
@property (nonatomic ,strong) UIBarButtonItem * backButton;
@property (nonatomic , strong) dispatch_block_t selectSuccess;//选择门店
@property (nonatomic , strong) PickshopData *pickmodel;
@end

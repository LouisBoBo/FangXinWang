//
//  StoreManagerViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/17.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreManagerViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *httpDataArr;
@property (nonatomic , strong) UIButton *footButton;        //新建门店
@end

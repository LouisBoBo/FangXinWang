//
//  StoreManagerTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/17.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreManagerModel.h"
@interface StoreManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeID;
@property (weak, nonatomic) IBOutlet UIButton *storeSelect;
@property (weak, nonatomic) IBOutlet UIButton *addStore;
@property (weak, nonatomic) IBOutlet UIButton *storeManager;
@property (weak, nonatomic) IBOutlet UIButton *eidtStore;
@property (weak, nonatomic) IBOutlet UIButton *deleateStore;

@property (nonatomic , strong) StoreManagerModel *storeManagerModel;
@property (nonatomic , strong) void(^childAccountBlock)(StoreManagerModel *model); //子账号管理
@property (nonatomic , strong) void(^storeEditBlock)(StoreManagerModel *model);                    //门店编辑
@property (nonatomic , strong) void(^storeDeleateBlock)(StoreManagerModel *model); //门店删除
- (void)refreshData:(StoreManagerModel*)model;
@end

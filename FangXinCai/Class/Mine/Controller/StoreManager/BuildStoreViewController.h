//
//  BuildStoreViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger , ManagerStoreType) {
    BuildStoreType = 0,       //新建门店
    DetailStoreType = 1,      //门店详情
};
@interface BuildStoreViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIButton *footButton;
@property (nonatomic , assign) ManagerStoreType storetype;
@property (nonatomic , strong) NSMutableDictionary *dataDictionary;
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *headerArray;

@property (nonatomic , strong) void(^buildSuccess)(NSString*title);
@end

//
//  MineViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface MineViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView      *tableFootView;
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *imgDataArr;
@end

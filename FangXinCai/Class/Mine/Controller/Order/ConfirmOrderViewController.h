//
//  ConfirmOrderViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmOrderViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView *submitFootview;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *shopDataArray;
@end

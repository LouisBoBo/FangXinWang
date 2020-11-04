//
//  PayStyleViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/3/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface PayStyleViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSString *order_id;     //订单id
@end

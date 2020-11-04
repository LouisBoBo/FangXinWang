//
//  DetailAndRecordViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, DetailRecordStyle) {
    DetailRecore_Money = 0,           //余额明细
    DetailRecore_Jifen = 1,           //积分明细
    DetailRecore_Recharge = 2,        //充值记录
    DetailRecore_Tixian = 3,          //提现记录
};

@interface DetailAndRecordViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , assign) DetailRecordStyle detailRecordStyle;
@end

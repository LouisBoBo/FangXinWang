//
//  CouponTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
#import "HelpWay.h"
@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponMoney;
@property (weak, nonatomic) IBOutlet UILabel *canUse;
@property (weak, nonatomic) IBOutlet UILabel *mustTime;
@property (weak, nonatomic) IBOutlet UILabel *comeFrom;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *linelab;
@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

- (void)refreshData:(CouponData*)model;
@end

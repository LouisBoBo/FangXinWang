//
//  ConfirmOrderTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitOrderModel.h"
@interface ConfirmOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;

- (void)refreshData:(SubmitOrderModel*)model;
@end

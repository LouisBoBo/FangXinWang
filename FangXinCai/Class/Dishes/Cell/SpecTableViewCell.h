//
//  SpecTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopDetailModel.h"
@interface SpecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;
- (void)refreshData:(GoodsattrData*)model;
@end

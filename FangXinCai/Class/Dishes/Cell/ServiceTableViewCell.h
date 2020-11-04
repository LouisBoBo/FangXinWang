//
//  ServiceTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopDetailModel.h"
@interface ServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *discriptionlab;

- (void)refreshData:(GoodsserviceData*)model;
@end

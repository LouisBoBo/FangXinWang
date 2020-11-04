//
//  BigImageTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopDetailModel.h"
#import "GoodsImageModel.h"
@interface BigImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@property (nonatomic , strong) GoodsImageModel *imageModel;
- (void)refreshData:(GoodsImageModel*)imagedata;
@end

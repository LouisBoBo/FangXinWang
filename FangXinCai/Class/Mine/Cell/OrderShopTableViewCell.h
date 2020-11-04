//
//  OrderShopTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopname;
@property (weak, nonatomic) IBOutlet UILabel *shopmodel;
@property (weak, nonatomic) IBOutlet UILabel *shopprice;
@property (weak, nonatomic) IBOutlet UILabel *shopNum;

- (void)refreshData;
@end

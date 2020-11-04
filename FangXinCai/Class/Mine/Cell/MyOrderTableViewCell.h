//
//  MyOrderTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/12.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *shopScrollview;
@property (weak, nonatomic) IBOutlet UILabel *orderShopNum;
@property (weak, nonatomic) IBOutlet UILabel *orderPayMoney;

@end

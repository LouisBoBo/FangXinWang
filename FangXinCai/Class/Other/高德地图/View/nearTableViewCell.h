//
//  nearTableViewCell.h
//  Eatshopdemo
//
//  Created by bob on 16/3/3.
//  Copyright © 2016年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduModel.h"
@interface nearTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *detialLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic,strong)BaiduModel *model;

@end

//
//  ConfirmOrderTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ConfirmOrderTableViewCell.h"

@implementation ConfirmOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)refreshData:(SubmitOrderModel*)model;
{
    self.titleLab.text = model.title;
    self.valueLab.text = model.value;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

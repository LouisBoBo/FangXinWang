//
//  SpecTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SpecTableViewCell.h"

@implementation SpecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelab.textColor = KGrayColor;
    self.titlelab.font = HBFont14;
    
    self.contentlab.font = HBFont14;
}
- (void)refreshData:(GoodsattrData*)model;
{
    self.titlelab.text = model.attr_name;
    self.contentlab.text = model.attr_value;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

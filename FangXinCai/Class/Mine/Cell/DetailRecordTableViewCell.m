//
//  DetailRecordTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "DetailRecordTableViewCell.h"

@implementation DetailRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)refreshData:(DetailRecordModel*)model;
{
    self.title.text = [NSString stringWithFormat:@"%@",model.content];
    self.time.text  = [NSString stringWithFormat:@"%@",model.time];
    self.money.text = [NSString stringWithFormat:@"%.2f",model.money];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

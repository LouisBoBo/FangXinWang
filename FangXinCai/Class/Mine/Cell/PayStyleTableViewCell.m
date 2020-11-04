//
//  PayStyleTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "PayStyleTableViewCell.h"

@implementation PayStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)refreshData:(PayStyleData*)data;
{
    self.model = data;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,data.icon]]];
    self.nameLab.text = [NSString stringWithFormat:@"%@",data.name];
    
    self.selectBtn.selected = data.is_select;
}

- (void)selectClick:(UIButton*)sender
{
    if(self.selectPayStyleBlock)
    {
        self.selectPayStyleBlock(self.model);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

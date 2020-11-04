//
//  nearTableViewCell.m
//  Eatshopdemo
//
//  Created by bob on 16/3/3.
//  Copyright © 2016年 bob. All rights reserved.
//

#import "nearTableViewCell.h"

@implementation nearTableViewCell


-(void)setModel:(BaiduModel *)model
{
    _model=model;
    
    self.addressLabel.text=model.Namestr;
    
    self.detialLabel.text=model.address;
    
    
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

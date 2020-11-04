//
//  BuildStoreTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BuildStoreTableViewCell.h"

@implementation BuildStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.spaceline.frame = CGRectMake(10, self.spaceline.frame.origin.y, kScreenWidth, 1);
    self.inputTextField.borderStyle = UITextBorderStyleNone;
}

- (void)refreshData:(BuildStoreModel*)model isBuild:(BOOL)build;
{
    self.titlelab.text = [NSString stringWithFormat:@"%@",model.title];
    self.contentlab.text = [NSString stringWithFormat:@"%@",model.content];
    
    if(!build)//门店详情
    {
        self.inputTextField.text = [NSString stringWithFormat:@"%@",model.content];
    }else{//创建门店
        self.inputTextField.placeholder = [NSString stringWithFormat:@"%@",model.content];
    }
    
    //当是门店地址栏时显示地址标示
    if([model.title isEqualToString:@"门店地址"])
    {
        self.goImg.hidden = NO;
        self.inputTextField.hidden = YES;
        self.contentlab.hidden = NO;
        
        self.goImg.image = [UIImage imageNamed:@"地址"];
        self.spaceline.frame = CGRectMake(110, self.spaceline.frame.origin.y, kScreenWidth, 1);
        if(![model.content isEqualToString:@"请选择门店地址"])
        {
            self.contentlab.textColor = KGrayColor;
        }
    }else if ([model.title isEqualToString:@"营业执照"])
    {
        self.goImg.image = [UIImage imageNamed:@"arrow_icon"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

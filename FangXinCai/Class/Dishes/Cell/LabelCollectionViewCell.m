//
//  LabelCollectionViewCell.m
//  FJWaterfallFlow
//
//  Created by ios-1 on 2016/12/26.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import "LabelCollectionViewCell.h"

@implementation LabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectbtn.backgroundColor = [UIColor whiteColor];
    self.selectbtn.layer.cornerRadius = 5;
    self.selectbtn.layer.borderWidth =1;
    self.selectbtn.titleLabel.font = HBFont14;
    [self.selectbtn setTintColor:RGBCOLOR(168, 168,168)];
    
}

- (void)setCellData:(GoodsspecData *)dataModel;
{
    self.model = dataModel;
    self.selectbtn.selected = [dataModel.selected boolValue];
    [self.selectbtn setTitle:dataModel.key_name forState:UIControlStateNormal];
    [self.selectbtn setTitleColor:KGrayColor forState:UIControlStateNormal];
    [self.selectbtn setTitleColor:basegreenColor forState:UIControlStateSelected];
    [self.selectbtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.selectbtn.selected)
    {
        self.selectbtn.layer.borderColor = basegreenColor.CGColor;
    }else{
        self.selectbtn.layer.borderColor = CLineColor.CGColor;
    }
}

- (void)click:(UIButton*)sender
{
    
    if(self.clickBlock)
    {
        self.clickBlock(self.model);
    }
}
@end

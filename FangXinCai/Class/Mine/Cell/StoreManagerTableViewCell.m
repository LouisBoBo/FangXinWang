//
//  StoreManagerTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/17.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreManagerTableViewCell.h"

@implementation StoreManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.eidtStore setTitle:@"编辑" forState:UIControlStateNormal];
    [self.eidtStore setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [self.eidtStore setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.eidtStore setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    [self.deleateStore setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleateStore setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [self.deleateStore setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.deleateStore setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    [self.addStore addTarget:self action:@selector(addStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.storeManager addTarget:self action:@selector(managerStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.eidtStore addTarget:self action:@selector(editStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleateStore addTarget:self action:@selector(deleateStore:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)refreshData:(StoreManagerModel*)model;
{
    self.storeName.text = model.nickname;
    self.storeManagerModel = model;
    if(!model.isSelected)
    {
        [self.storeSelect setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        [self.storeSelect setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }
    
}

//新加
- (void)addStore:(UIButton*)sender
{
    NSLog(@"管理");
    if(self.childAccountBlock)
    {
        self.childAccountBlock(self.storeManagerModel);
    }
}
//子帐号管理
- (void)managerStore:(UIButton*)sender
{
    NSLog(@"管理");
    if(self.childAccountBlock)
    {
        self.childAccountBlock(self.storeManagerModel);
    }
}
//编辑门店
- (void)editStore:(UIButton*)sender
{
    NSLog(@"编辑");
    if(self.storeEditBlock)
    {
        self.storeEditBlock(self.storeManagerModel);
    }
}
//删除门店
- (void)deleateStore:(UIButton*)sender
{
    NSLog(@"删除");
    if(self.storeDeleateBlock)
    {
        self.storeDeleateBlock(self.storeManagerModel);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

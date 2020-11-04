//
//  CartShopTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/25.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CartShopTableViewCell.h"
#import "CartShopManager.h"
#import "CartCountModel.h"
@implementation CartShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inputTextField.borderStyle = UITextBorderStyleNone;
    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputTextField.delegate = self;
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = CLineColor.CGColor;
    
    self.reduceBtn.layer.borderWidth = 1;
    self.reduceBtn.layer.borderColor = CLineColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = CLineColor.CGColor;
    
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
    
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.reduceBtn addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshData:(ShopCartData*)model;
{
    self.model = model;
    
    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,model.original_img]]];
    self.shopName.text = [NSString stringWithFormat:@"%@",model.goods_name];
    self.shopPrice.text = [NSString stringWithFormat:@"￥%.2f",model.member_goods_price.floatValue];
    self.inputTextField.text = [NSString stringWithFormat:@"%@",model.goods_num];
    self.selectBtn.selected = [model.selected boolValue];
}
- (void)selectClick:(UIButton*)sender
{
    [self selectCartShopHttp];
}
- (void)reduceClick:(UIButton*)sender
{
    NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inputTextField.text.integerValue-1];
    if(goods_num.integerValue == 0)
    {
        if(self.deleteBlock)
        {
            self.deleteBlock(self.model);
        }
    }else{
        [self AddReduiceCartShop:goods_num];
    }
    
}
- (void)addClick:(UIButton*)sender
{
    NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inputTextField.text.integerValue+1];
    [self AddReduiceCartShop:goods_num];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    NSString *goods_num = textField.text;
    [self AddReduiceCartShop:goods_num];
    
    return YES;
}

//加减购物车数据
- (void)AddReduiceCartShop:(NSString*)good_num
{
    kWeakSelf(self);
    [[CartShopManager cartShopManarer] AddReduiceCartShop:good_num Goods_id:weakself.model.goods_id Spec_key:weakself.model.spec_key Success:^(id data) {
        CartCountModel *countmodel = [CartCountModel mj_objectWithKeyValues:data[@"data"]];
        weakself.model.goods_num = [NSNumber numberWithString:good_num];
        weakself.inputTextField.text = good_num;
        
        if(weakself.reduceAndAddBlock)
        {
            weakself.reduceAndAddBlock(weakself.model,countmodel);
        }
    }];
}

//勾选商品
- (void)selectCartShopHttp
{
    BOOL select = [self.model.selected boolValue];
    kWeakSelf(self);
    [[CartShopManager cartShopManarer] selectCartShopHttp:weakself.model.ID Select:select Success:^(id data) {
        CartCountModel *countmodel = [CartCountModel mj_objectWithKeyValues:data[@"data"]];
        weakself.selectBtn.selected = !weakself.selectBtn.selected;
        weakself.model.selected = [NSNumber numberWithBool:weakself.selectBtn.selected];
        if(weakself.selectBlock)
        {
            weakself.selectBlock(weakself.model,countmodel);
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

//
//  SearchBarNavView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/13.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SearchBarNavView.h"

@implementation SearchBarNavView

- (instancetype)initWithFrame:(CGRect)frame back:(BOOL)isback;
{
    if(self = [super initWithFrame:frame])
    {
        [self searchBar:frame back:isback];
    }
    return self;
}

- (void)searchBar:(CGRect)frame back:(BOOL)isback
{
    UIView *naview = [[UIView alloc] initWithFrame:frame];
    naview.backgroundColor = KWhiteColor;
    [self addSubview:naview];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    backbtn.hidden = isback;
    backbtn.contentMode = UIViewContentModeScaleToFill;
    [naview addSubview:backbtn];
    
    UIView *searchview = [UIView new];
    searchview.backgroundColor = CViewBgColor;
    searchview.clipsToBounds = YES;
    searchview.layer.cornerRadius = 15;
    [naview addSubview:searchview];
    
    UIImageView *searchicon = [UIImageView new];
    searchicon.image = [NSBundle py_imageNamed:@"search"];
    [searchview addSubview:searchicon];
    
    UITextField *textfield = [UITextField new];
    textfield.backgroundColor = CViewBgColor;
    textfield.placeholder = @"搜索";
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:14];
    [searchview addSubview:textfield];
    
    UIButton *customer = [UIButton buttonWithType:UIButtonTypeCustom];
    [customer setBackgroundImage:[UIImage imageNamed:@"客服咨询灰"] forState:UIControlStateNormal];
    [customer addTarget:self action:@selector(customer:) forControlEvents:UIControlEventTouchUpInside];
    [naview addSubview:customer];
    
    UILabel *linelab = [UILabel new];
    linelab.backgroundColor = CLineColor;
    [self addSubview:linelab];
    
    [backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(25);
        make.width.height.mas_equalTo(30);
    }];
    
    [searchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(25);
        make.width.mas_equalTo(KZOOM6pt(600));
        make.height.mas_equalTo(30);
    }];
    
    [searchicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(15);
        make.centerY.equalTo(searchview);
    }];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(searchview);
        make.right.equalTo(searchview);
        make.height.mas_equalTo(30);
    }];
    
    [customer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchview).offset(5);
        make.left.mas_equalTo(KScreenWidth - 30);
        make.width.height.mas_equalTo(20);
    }];
    
    [linelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
        make.top.mas_equalTo(63);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [textField resignFirstResponder];
    if(self.textFieldBlock)
    {
        self.textFieldBlock(textField.text);
    }
}
- (void)customer:(UIButton*)sender
{
    if(self.customerBlock)
    {
        self.customerBlock();
    }
}
@end

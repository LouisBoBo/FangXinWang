//
//  PageClassView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/7.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "PageClassView.h"

@implementation PageClassView
- (instancetype)initWithFrame:(CGRect)frame TitleArr:(NSArray*)titleArr;
{
    if(self == [super initWithFrame:frame])
    {
        self.backgroundColor = KWhiteColor;
        self.titleArr = titleArr;
        [self creatMainview:frame];
    }
    return self;
}

- (void)creatMainview:(CGRect)frame
{
    self.btnwidth = KScreenWidth/self.titleArr.count;
    self.selectLineWidth = self.btnwidth*0.5;
    self.space = (self.btnwidth - self.selectLineWidth)/2;
    
    for(int i=0;i<self.titleArr.count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.btnwidth*i, 0, self.btnwidth, 40);
        button.titleLabel.font = HBFont15;
        button.tag = 10000+i;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        
        [button setTitleColor:KGrayColor forState:UIControlStateNormal];
        [button setTitleColor:basegreenColor forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0)
        {
            button.selected = YES;
        }
        [self addSubview:button];
    }
    
    //分割线
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, KScreenWidth, 1)];
    linelab.backgroundColor = CLineColor;
    [self addSubview:linelab];
    
    //选择指示器
    self.selectLine = [[UILabel alloc] initWithFrame:CGRectMake(self.space, CGRectGetHeight(self.frame)-2, self.selectLineWidth, 1.5)];
    self.selectLine.backgroundColor = basegreenColor;
    [self addSubview:self.selectLine];
}

- (void)click:(UIButton*)sender
{
    for(int i =0;i<self.titleArr.count;i++)
    {
        UIButton *button = (UIButton*)[self viewWithTag:10000+i];
        button.selected = NO;
    }
    sender.selected = YES;
    
    CGFloat index = sender.tag -10000;
    [UIView animateWithDuration:0.5 animations:^{
        self.selectLine.frame = CGRectMake(self.btnwidth*index +self.space, CGRectGetHeight(self.frame)-2, self.selectLineWidth, 1.5);
    }];
    
    if(self.selectBlock)
    {
        self.selectBlock(sender.tag-10000);
    }
}

- (void)setTitle:(NSInteger)index;
{
    for(int i =0;i<self.titleArr.count;i++)
    {
        UIButton *button = (UIButton*)[self viewWithTag:10000+i];
        if(button.tag == 10000+index)
        {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectLine.frame = CGRectMake(self.btnwidth*index+self.space, CGRectGetHeight(self.frame)-2, self.selectLineWidth, 1.5);
    }];
}
@end

//
//  MultilHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/31.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MultilHeadView.h"

@implementation MultilHeadView
{
    NSArray *titleArr;
}
- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self == [super initWithFrame:frame])
    {
        [self creatHeadView:frame];
    }
    return self;
}
- (void)creatHeadView:(CGRect)frame
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    headview.backgroundColor = CViewBgColor;
    titleArr = @[@"商品名",@"销量",@"价格"];
    CGFloat btnwith = frame.size.width/3;
    CGFloat btnheigh = frame.size.height;
    for(int i=0; i <3;i++)
    {
        UIButton *headbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headbtn.frame = CGRectMake(btnwith*i, 0, btnwith, btnheigh);
        headbtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [headbtn setTitleColor:KGrayColor forState:UIControlStateNormal];
        [headbtn setTitleColor:basegreenColor forState:UIControlStateSelected];
        [headbtn setTitle:titleArr[i] forState:UIControlStateNormal];
        headbtn.tag = 10001+i;
        [headbtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:headbtn];
        
        if(i== 0)
        {
            headbtn.selected = YES;
        }
    }
    
    [self addSubview:headview];
}

- (void)headClick:(UIButton*)sender
{
    
    for(int i =0;i<titleArr.count;i++)
    {
        if(sender.tag != i+10001)
        {
            UIButton *button = [self viewWithTag:i+10001];
            button.selected = NO;
        }else{
            sender.selected = YES;
        }
    }
    if(self.headClick)
    {
        self.headClick(sender.tag-10000);
    }
}
@end

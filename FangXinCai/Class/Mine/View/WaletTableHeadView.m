//
//  WaletTableHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/10.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "WaletTableHeadView.h"

@implementation WaletTableHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self creaHeadView:frame];
    }
    
    return self;
}
- (void)creaHeadView:(CGRect)frame
{
    self.tabheadView = [[UIView alloc] init];
    self.tabheadView.frame = frame;
    self.tabheadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tabheadView addSubview:self.moneyHeadview];
    [self.tabheadView addSubview:self.operationview];
    [self addSubview:self.tabheadView];
}

- (UIImageView*)moneyHeadview
{
    if(_moneyHeadview == nil)
    {
        _moneyHeadview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KZOOM6pt(400))];
        _moneyHeadview.image = [UIImage imageNamed:@"my_back_img@2x"];
        _moneyHeadview.userInteractionEnabled = YES;
        
        UILabel *moneylab = [UILabel new];
        moneylab.text = @"56789";
        moneylab.textColor = KWhiteColor;
        moneylab.textAlignment = NSTextAlignmentCenter;
        moneylab.font = [UIFont fontWithName:@"Helvetica-Bold" size:KZOOM6pt(60)];
        [_moneyHeadview addSubview:moneylab];
        
        UILabel *otherlab = [UILabel new];
        otherlab.text = @"可用余额(元)";
        otherlab.textColor = KWhiteColor;
        otherlab.textAlignment = NSTextAlignmentCenter;
        otherlab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [_moneyHeadview addSubview:otherlab];
        
        
        [moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KZOOM6pt(100));
            make.left.width.equalTo(_moneyHeadview);
            make.height.mas_equalTo(KZOOM6pt(60));
        }];
        
        [otherlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KZOOM6pt(200));
            make.left.width.equalTo(_moneyHeadview);
            make.height.mas_equalTo(KZOOM6pt(40));
        }];
    }
    return _moneyHeadview;
}
- (UIView*)operationview
{
    if(_operationview == nil)
    {
        _operationview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyHeadview.frame), kScreenWidth, KZOOM6pt(80))];
        _operationview.backgroundColor = KWhiteColor;
        _operationview.userInteractionEnabled = YES;
        
        NSArray *titleArr = @[@"充值",@"提现"];
        CGFloat with = kScreenWidth/titleArr.count;
        for(int i = 0; i<titleArr.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:KGrayColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
            btn.tag = 10000+i;
            [btn addTarget:self action:@selector(operaClick:) forControlEvents:UIControlEventTouchUpInside];
            [_operationview addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(with*i);
                make.top.bottom.equalTo(_operationview);
                make.width.mas_equalTo(with);
            }];
        }
        
        UILabel *linelab = [UILabel new];
        linelab.backgroundColor = KGrayColor;
        [_operationview addSubview:linelab];
        
        [linelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(with);
            make.top.mas_equalTo(KZOOM6pt(15));
            make.height.mas_equalTo(KZOOM6pt(50));
            make.width.mas_equalTo(KZOOM6pt(1));
        }];
    }
    return _operationview;
}

- (void)operaClick:(UIButton*)sender
{
    if(sender.tag == 10000)//充值
    {
        NSLog(@"充值");
        if(self.moneyBlock)
        {
            self.moneyBlock();
        }
    }else{//提现
        NSLog(@"提现");
        if(self.operaBlock)
        {
            self.operaBlock();
        }
    }
}
@end

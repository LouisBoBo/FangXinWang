//
//  MineTableHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/9.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MineTableHeadView.h"

@implementation MineTableHeadView

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
    
    [self.tabheadView addSubview:self.userHeadview];
    [self.tabheadView addSubview:self.userOrderview];
    [self.tabheadView addSubview:self.userWaletview];
    [self addSubview:self.tabheadView];
}


//用户头像
- (UIImageView*)userHeadview
{
    if(_userHeadview == nil)
    {
        _userHeadview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        _userHeadview.image = [UIImage imageNamed:@"my_back_img@2x"];
        _userHeadview.userInteractionEnabled = YES;
        
        UIImageView *headimage = [UIImageView new];
        headimage.clipsToBounds = YES;
        headimage.layer.cornerRadius = 30;
        headimage.layer.borderWidth = 3;
        headimage.layer.borderColor = KWhiteColor.CGColor;
        headimage.image = [UIImage imageNamed:@"用户图像"];
        [_userHeadview addSubview:self.headimage = headimage];
        
        UILabel *accountslab = [UILabel new];
        accountslab.text = @"门店帐号";
        accountslab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [_userHeadview addSubview:self.accountslab = accountslab];
        
        UILabel *nicknamelab = [UILabel new];
        nicknamelab.text = @"昵称";
        nicknamelab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [_userHeadview addSubview:self.nicknamelab = nicknamelab];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setBackgroundImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
        [_userHeadview addSubview:settingBtn];
        
        UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [customerBtn setBackgroundImage:[UIImage imageNamed:@"联系客服"] forState:UIControlStateNormal];
        [customerBtn addTarget:self action:@selector(customer) forControlEvents:UIControlEventTouchUpInside];
        [_userHeadview addSubview:customerBtn];
        
        [headimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.bottom.equalTo(_userHeadview).offset(-20);
            make.width.height.mas_equalTo(60);
        }];
        
        [accountslab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headimage);
            make.left.mas_equalTo(headimage).offset(80);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
        
        [nicknamelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountslab).offset(30);
            make.left.mas_equalTo(headimage).offset(80);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
        
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(KScreenWidth-40);
            make.width.height.mas_equalTo(25);
        }];
        
        [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(settingBtn);
            make.left.equalTo(settingBtn).offset(-40);
            make.width.height.equalTo(settingBtn);
        }];
    }
    
    return _userHeadview;
}
//用户订单
- (UIView*)userOrderview
{
    if(_userOrderview == nil)
    {
        NSArray *titleArr = @[@"待付款",@"待发货",@"待收货",@"已完成"];
        NSArray *imageArr = @[@"待付款",@"待发货",@"待收货",@"已完成订单"];
        
        _userOrderview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userHeadview.frame), kScreenWidth, 120)];
        _userOrderview.backgroundColor = KWhiteColor;
        UIView *ordertopview = [UIView new];
        [_userOrderview addSubview:ordertopview];
        
        UITapGestureRecognizer *ordertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderClick:)];
        [ordertopview addGestureRecognizer:ordertap];

        UIView *orderbottomview = [UIView new];
        orderbottomview.tag = 888888;
        [_userOrderview addSubview:orderbottomview];

        [ordertopview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(KScreenWidth);
            make.height.mas_equalTo(40);
        }];
        
        [orderbottomview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(ordertopview);
            make.top.equalTo(ordertopview).offset(40);
            make.bottom.equalTo(_userOrderview);
        }];
        
        [self topview:ordertopview title:@"全部订单" gotitle:@"我的订单"];
        [self baseview:orderbottomview topimages:imageArr toptitles:nil bomtittles:titleArr];
    }
    return _userOrderview;
}

//用户钱包
- (UIView*)userWaletview
{
    if(_userWaletview == nil)
    {
        NSArray *toptitleArr = @[@"0.00",@"0",@"0"];
        NSArray *titleArr = @[@"余额",@"优惠券",@"积分"];
        
        _userWaletview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userOrderview.frame)+10, kScreenWidth, 130)];
        _userWaletview.backgroundColor = KWhiteColor;
        UIView *walettopview = [UIView new];
        [_userWaletview addSubview:walettopview];
        
        UITapGestureRecognizer *walettap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(waletClick:)];
        [walettopview addGestureRecognizer:walettap];
        
        UIView *waletbottomview = [UIView new];
        waletbottomview.tag = 999999;
        [_userWaletview addSubview:waletbottomview];
        
        [walettopview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(KScreenWidth);
            make.height.mas_equalTo(40);
        }];
        
        [waletbottomview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(walettopview);
            make.top.equalTo(walettopview).offset(40);
            make.bottom.equalTo(_userWaletview);
        }];
        
        [self topview:walettopview title:@"我的钱包" gotitle:@"资金管理"];
        [self baseview:waletbottomview topimages:nil toptitles:toptitleArr bomtittles:titleArr];
    }
    return _userWaletview;
}

- (void)topview:(UIView*)baseview title:(NSString*)title gotitle:(NSString*)gotitle
{
    
    UILabel *ordertop_tittle = [UILabel new];
    ordertop_tittle.text = title;
    ordertop_tittle.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [baseview addSubview:ordertop_tittle];
    
    UIImageView *goimage = [UIImageView new];
    goimage.image = [UIImage imageNamed:@"arrow_icon.png"];
    [baseview addSubview:goimage];
    
    UILabel *golabel = [UILabel new];
    golabel.text = gotitle;
    golabel.font = [UIFont systemFontOfSize:KZOOM6pt(24)];
    golabel.textAlignment = NSTextAlignmentRight;
    [baseview addSubview:golabel];
    
    UILabel *linelab = [UILabel new];
    linelab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [baseview addSubview:linelab];
    
    [ordertop_tittle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.equalTo(baseview);
        make.width.mas_equalTo(100);
    }];
    
    [goimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ordertop_tittle).offset(10);
        make.right.equalTo(baseview).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    [golabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goimage).offset(-20);
        make.width.mas_equalTo(100);
        make.top.bottom.equalTo(baseview);
    }];
    
    [linelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ordertop_tittle);
        make.height.mas_equalTo(1);
        make.right.bottom.equalTo(baseview);
    }];

}
- (void)baseview:(UIView*)baseview topimages:(NSArray*)topimageArr toptitles:(NSArray*)toptitleArr bomtittles:(NSArray*)bomtitleArr
{
    
    CGFloat backwidth = KScreenWidth/bomtitleArr.count;
    CGFloat backheigh = CGRectGetHeight(baseview.frame);
    
    for(int i =0; i < bomtitleArr.count; i++)
    {
        UIView *backview = [UIView new];
        [baseview addSubview:backview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick:)];
        [backview addGestureRecognizer:tap];
        
        UIImageView *topimage = [UIImageView new];
        UILabel *marklab = [UILabel new];
        UILabel *toplab = [UILabel new];
        
        if(baseview.tag == 888888)//订单
        {
            topimage.image = [UIImage imageNamed:topimageArr[i]];
            
            marklab.tag = 30000+i;
            marklab.hidden = YES;
            marklab.backgroundColor = [UIColor redColor];
            marklab.textColor = [UIColor whiteColor];
            marklab.textAlignment = NSTextAlignmentCenter;
            marklab.font = [UIFont systemFontOfSize:KZOOM6pt(20)];
            
            backview.tag = 10000+i;
            [topimage addSubview:marklab];
            [backview addSubview:topimage];
            
        }else{//钱包
            toplab.text = toptitleArr[i];
            toplab.tag = 40000+i;
            toplab.textAlignment = NSTextAlignmentCenter;
            toplab.font = [UIFont systemFontOfSize:KZOOM6pt(24)];
            
            backview.tag = 20000+i;
            [backview addSubview:toplab];
        }
        
        UILabel *bottomlab = [UILabel new];
        bottomlab.textAlignment = NSTextAlignmentCenter;
        bottomlab.font = [UIFont systemFontOfSize:KZOOM6pt(24)];
        bottomlab.text = bomtitleArr[i];
        [backview addSubview:bottomlab];
        
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backwidth*i);
            make.top.bottom.equalTo(baseview);
            make.width.mas_equalTo(backwidth);
            make.height.mas_equalTo(backheigh);
        }];
        
        if(baseview.tag == 888888)//订单
        {
            [topimage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backview);
                make.top.mas_equalTo(10);
                make.width.height.mas_equalTo(30);
            }];
            
            [marklab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-5);
                make.right.equalTo(topimage).offset(5);
                make.width.height.mas_equalTo(KZOOM6pt(30));
            }];
            marklab.clipsToBounds = YES;
            marklab.layer.cornerRadius = KZOOM6pt(30)/2;
            
        }else{//钱包
            [toplab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backview);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(40);
                make.width.equalTo(backview);
            }];
        }
        
        [bottomlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backview);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.width.equalTo(backview);
            
        }];
    }
}

#pragma mark 刷新界面
- (void)refreshUI:(NSDictionary*)data
{
    //用户信息
    NSString *head_pic = [NSString stringWithFormat:@"%@",data[@"head_pic"]];
    if(head_pic.length > 10)
    {
        [self.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,head_pic]]];
    }
    self.accountslab.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];
    self.nicknamelab.text = [NSString stringWithFormat:@"%@",data[@"nickname"]];
    
    //订单
    NSString *not_pay = [NSString stringWithFormat:@"%@",data[@"not_pay"]];
    NSString *not_shoping = [NSString stringWithFormat:@"%@",data[@"not_shoping"]];
    NSString *not_receive = [NSString stringWithFormat:@"%@",data[@"not_receive"]];
    NSArray *notArray = @[not_pay,not_shoping,not_receive,@"0"];
    for(int j=0; j<notArray.count; j++)
    {
        UILabel *label = (UILabel*)[self.userOrderview viewWithTag:30000+j];
        label.text = notArray[j];
        label.hidden = label.text.intValue>0?NO:YES;
    }
    
    //钱包
    NSString *yueCount = [NSString stringWithFormat:@"%@",data[@"user_money"]];
    NSString *youhuiCount = [NSString stringWithFormat:@"%@",data[@"coupon_count"]];
    NSString *jifenCount = [NSString stringWithFormat:@"%@",data[@"pay_points"]];
    NSArray *countArray = @[yueCount,youhuiCount,jifenCount];
    for(int i =0; i<countArray.count; i++)
    {
        UILabel *label = (UILabel*)[self.userWaletview viewWithTag:40000+i];
        label.text = countArray[i];
    }
}

//设置
- (void)setting
{
    NSLog(@"设置");
    if(self.settingBlock)
    {
        self.settingBlock();
    }
}
//客服
- (void)customer
{
    NSLog(@"客服");
}
//订单
- (void)orderClick:(UITapGestureRecognizer*)tap
{
    NSLog(@"订单");
    if(self.orderBlock)
    {
        self.orderBlock();
    }
}
//钱包
- (void)waletClick:(UITapGestureRecognizer*)tap
{
    NSLog(@"钱包");
    if(self.waletBlock)
    {
        self.waletBlock();
    }
}
//订单+余额
- (void)backClick:(UITapGestureRecognizer*)tap
{
    NSLog(@"tag = %zd",tap.view.tag);
    if(self.orderWaletBlock)
    {
        self.orderWaletBlock(tap.view.tag);
    }
}
@end

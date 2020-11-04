//
//  ConfirmOrderTabHeadview.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ConfirmOrderTabHeadview.h"

@implementation ConfirmOrderTabHeadview
- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self = [super initWithFrame:frame])
    {
        [self creaHeadView:frame];
    }
    return self;
}

- (void)creaHeadView:(CGRect)frame
{
    self.confirmOrderHead = [[UIView alloc]initWithFrame:frame];
    [self addSubview:self.confirmOrderHead];
    
    [self.confirmOrderHead addSubview:self.orderAddressView];
    [self.confirmOrderHead addSubview:self.orderShopView];
}

- (UIView*)orderAddressView
{
    if(_orderAddressView == nil)
    {
        _orderAddressView = [UIView new];
        _orderAddressView.frame = CGRectMake(0, 0, kScreenWidth, KZOOM6pt(160));
        _orderAddressView.backgroundColor = KWhiteColor;
        
        UIImageView *addressimage = [[UIImageView alloc]init];
        addressimage.image = [UIImage imageNamed:@"地址"];
        [_orderAddressView addSubview:addressimage];
        
        UILabel *Consignee = [UILabel new];
        Consignee.text = [NSString stringWithFormat:@"收货人：%@",@"baby"];
        Consignee.textColor = KGrayColor;
        Consignee.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:self.ConsigneeLab = Consignee];
        
        UILabel *phone = [UILabel new];
        phone.text = @"18585858585";
        phone.textColor = KGrayColor;
        phone.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:self.phoneLab = phone];
        
        UILabel *address = [UILabel new];
        address.text = @"事件发生发十几分老骥伏枥首颗福建师范标题";
        address.numberOfLines = 0;
        address.textColor = KGrayColor;
        address.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_orderAddressView addSubview:self.addressLab = address];
        
        UIImageView *goimage = [UIImageView new];
        goimage.image = [UIImage imageNamed:@"arrow_icon"];
        [_orderAddressView addSubview:goimage];
        
        [addressimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(_orderAddressView);
            make.width.height.mas_equalTo(30);
        }];
        
        [Consignee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressimage).offset(40);
            make.top.mas_equalTo(10);
            make.right.equalTo(_orderAddressView).offset(-100);
            make.height.mas_equalTo(20);
        }];
        
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_orderAddressView).offset(-30);
            make.top.height.equalTo(Consignee);
            make.width.mas_equalTo(100);
        }];
        
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(Consignee);
            make.top.equalTo(Consignee).offset(20);
            make.height.mas_equalTo(40);
        }];
        
        [goimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KScreenWidth-25);
            make.width.height.mas_equalTo(20);
            make.centerY.equalTo(_orderAddressView);
        }];
    }
    return _orderAddressView;
}

- (UIView*)orderShopView
{
    if(_orderShopView == nil)
    {
        _orderShopView = [UIView new];
        _orderShopView.frame = CGRectMake(0, CGRectGetMaxY(_orderAddressView.frame)+KZOOM6pt(20), kScreenWidth, KZOOM6pt(260));
        _orderShopView.backgroundColor = KWhiteColor;
        
        //商品
        UIScrollView *shopScrollview = [[UIScrollView alloc]init];
        shopScrollview.userInteractionEnabled = YES;
        [_orderShopView addSubview:self.shopScrollview = shopScrollview];
        
        [shopScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(KZOOM6pt(20));
            make.width.mas_equalTo(KScreenWidth - KZOOM6pt(200));
            make.height.mas_equalTo(KZOOM6pt(120));
        }];
                
        //商品件数
        UILabel *countlabel = [UILabel new];
        countlabel.font = HBFont13;
        countlabel.textColor = KGrayColor;
        countlabel.text = [NSString stringWithFormat:@"共%zd件商品",0];
        countlabel.textAlignment = NSTextAlignmentCenter;
        [_orderShopView addSubview:self.countLab = countlabel];
        
        [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(shopScrollview);
            make.left.mas_equalTo(KScreenWidth-KZOOM6pt(180));
            make.width.mas_equalTo(KZOOM6pt(160));
        }];
        
        //分割线
        UILabel *linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, KZOOM6pt(160), KScreenWidth, 1)];
        linelab.backgroundColor = CLineColor;
        [_orderShopView addSubview:linelab];
        
        //加急配送
        UILabel *jiajiLabel = [UILabel new];
        jiajiLabel.text = @"加急配送";
        jiajiLabel.font = HBFont14;
        [_orderShopView addSubview:jiajiLabel];
        [jiajiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KZOOM6pt(20));
            make.top.mas_equalTo(KZOOM6pt(160));
            make.width.mas_equalTo(KZOOM6pt(200));
            make.height.mas_equalTo(KZOOM6pt(100));
        }];
        
        UISwitch *jiajiswitch = [UISwitch new];
        [_orderShopView addSubview:jiajiswitch];
        [jiajiswitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KScreenWidth-60);
            make.top.mas_equalTo(KZOOM6pt(180));
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
    }
    
    return _orderShopView;
}

- (void)refreshUI:(NSDictionary*)data;
{
    self.ConsigneeLab.text = [NSString stringWithFormat:@"%@",data[@"shops_receiver"]];
    self.phoneLab.text = [NSString stringWithFormat:@"%@",data[@"receiver_phone"]];
    self.addressLab.text = [NSString stringWithFormat:@"%@",data[@"shops_address"]];
    self.countLab.text = [NSString stringWithFormat:@"共%@件商品",data[@"tongji"][@"count"]];
    
    NSArray *shopArray = data[@"goods_list"];
    for(int i=0;i<shopArray.count;i++)
    {
        NSArray *childShopArray = shopArray[i];
        for(int j=0;j<childShopArray.count;j++)
        {
            GoodsShopData *shopdata = [GoodsShopData mj_objectWithKeyValues:childShopArray[j]];
            [self.shopDataArray addObject:shopdata];
        }
    }
    

    CGFloat shopViewHeigh = KZOOM6pt(120);
    for(int i =0; i<self.shopDataArray.count; i++)
    {
        GoodsShopData *shopdata = self.shopDataArray[i];
        UIImageView *shopview = [UIImageView new];
        shopview.userInteractionEnabled = YES;
        shopview.backgroundColor = DRandomColor;
        shopview.tag = 10000+i;
        [shopview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,shopdata.original_img]]];
        [self.shopScrollview addSubview:shopview];
        
        UITapGestureRecognizer *shoptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopClick:)];
        [shopview addGestureRecognizer:shoptap];
        
        [shopview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset((shopViewHeigh+5)*i);
            make.top.mas_offset(0);
            make.width.height.mas_offset(shopViewHeigh);
        }];
    }
    self.shopScrollview.contentSize = CGSizeMake(shopViewHeigh*self.shopDataArray.count+5*(self.shopDataArray.count-1), 0);
}
- (void)shopClick:(UITapGestureRecognizer*)tap
{
    NSInteger tag = tap.view.tag-10000;
    GoodsShopData *shopdata = self.shopDataArray[tag];
    if(self.selectShopClick)
    {
        self.selectShopClick(shopdata);
    }
}
- (NSMutableArray*)shopDataArray
{
    if(_shopDataArray == nil)
    {
        _shopDataArray = [NSMutableArray array];
    }
    return _shopDataArray;
}
@end

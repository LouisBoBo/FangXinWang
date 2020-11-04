//
//  BigImageHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BigImageHeadView.h"
#import "CartShopManager.h"
@implementation BigImageHeadView
- (instancetype)initWithFrame:(CGRect)frame Goodsid:(NSString*)goods_id;
{
    if(self == [super initWithFrame:frame])
    {
        self.goods_id = goods_id;
        [self creatMainView:frame];
    }
    return self;
}

- (void)creatMainView:(CGRect)frame
{
    [self addSubview:self.SDCycleScrollView];
    self.hidden = YES;
    self.backgroundColor = KWhiteColor;
    
    UILabel *pagelab = [UILabel new];
    pagelab.clipsToBounds = YES;
    pagelab.layer.cornerRadius = KZOOM6pt(80)/2;
    pagelab.textAlignment = NSTextAlignmentCenter;
    pagelab.backgroundColor = CViewBgColor;
    pagelab.textColor = KGrayColor;
    pagelab.text = @"";
    [self addSubview:self.pagelab = pagelab];
    
    UILabel *discriptionlab = [UILabel new];
    discriptionlab.text = @"";
    discriptionlab.textColor = KGrayColor;
    discriptionlab.font = HBFont14;
    [self addSubview:self.discriptionlab = discriptionlab];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(KScreenWidth-KZOOM6pt(160), CGRectGetHeight(self.frame)-KZOOM6pt(80), KZOOM6pt(160), KZOOM6pt(60));
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(22)];
    [collectBtn setTitle:@"加入清单" forState:UIControlStateNormal];
    [collectBtn setTitle:@"已经加入" forState:UIControlStateSelected];
    
    [collectBtn setImage:[UIImage imageNamed:@"加入清单"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"加入清单灰"] forState:UIControlStateSelected];
    
    [collectBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [collectBtn setTitleColor:KGrayColor forState:UIControlStateSelected];
    
    [collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [collectBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:KZOOM6pt(10)];
    collectBtn.titleLabel.font=[UIFont systemFontOfSize:KZOOM6pt(24)];
    [self addSubview:self.collectBtn = collectBtn];
    
    [pagelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(KScreenWidth-KZOOM6pt(100));
        make.bottom.equalTo(self.SDCycleScrollView);
        make.width.height.mas_equalTo(KZOOM6pt(80));
    }];
    
    [discriptionlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.mas_equalTo(KZOOM6pt(20));
        make.height.mas_equalTo(KZOOM6pt(100));
        make.width.mas_equalTo(KScreenWidth-KZOOM6pt(200));
    }];
    
}
//加入清单
- (void)collectClick:(UIButton*)sender
{
    [[CartShopManager cartShopManarer] goodsCollectHttp:self.goods_id Success:^(id data) {
      sender.selected = !sender.selected;
    }];
}
#pragma mark ******************* 轮播图 *******************
- (SDCycleScrollView*)SDCycleScrollView
{
    if(_SDCycleScrollView == nil)
    {
        _SDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(500)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _SDCycleScrollView.autoScroll = NO;
        _SDCycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        _SDCycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        _SDCycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
        _SDCycleScrollView.showPageControl = NO;
        kWeakSelf(self);
        _SDCycleScrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
            weakself.pagelab.text = [NSString stringWithFormat:@"%zd/%zd",currentIndex+1,weakself.imagesURLStrings.count];
        };
        
    }
    return _SDCycleScrollView;
}

#pragma mark 点击商品图片缩放效果
- (void)scaleView:(NSArray*)imgViewArr Index:(int)index
{
    self.imgFullScrollView = [[FullScreenScrollView alloc] initWithPicutreArray:imgViewArr withCurrentPage:index];
    self.imgFullScrollView.backgroundColor = [UIColor blackColor];
    
    self.imgFullScrollView.alpha = 0;
    
    [kAppWindow addSubview:self.imgFullScrollView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.imgFullScrollView.frame=CGRectMake(0,0, KScreenWidth,KScreenHeight);
        
        self.imgFullScrollView.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - scrollview回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个",index);
    int count = (int)index + 1;
    [self scaleView:self.imagesURLStrings Index:count];
}
- (void)refreshBanaImages:(NSArray*)imagesURLStrings GoodsInfo:(GoodsShopInfoModel *)goodsinfo;
{
    if(goodsinfo != nil)
    {
        self.hidden = NO;
    }
    self.imagesURLStrings = imagesURLStrings;
    self.pagelab.text = [NSString stringWithFormat:@"%zd/%zd",1,imagesURLStrings.count];
    self.discriptionlab.text = [NSString stringWithFormat:@"%@",goodsinfo.goods_name];
    self.collectBtn.selected = [goodsinfo.collect boolValue];
    self.SDCycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

@end

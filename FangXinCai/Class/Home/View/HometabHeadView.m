//
//  HometabHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/18.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "HometabHeadView.h"
#import "UIButton+EdgeInsets.h"

@implementation HometabHeadView

- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self = [super initWithFrame:frame])
    {
        [self cgreatHeadView:frame];
    }
    return self;
}

- (void)cgreatHeadView:(CGRect)frame
{
    self.hometabHeadView = [[UIView alloc]initWithFrame:frame];
    [self addSubview:self.hometabHeadView];
    
    [self.hometabHeadView addSubview:self.SDCycleScrollView];
    [self.hometabHeadView addSubview:self.myClassView];
    [self.hometabHeadView addSubview:self.myAreaView];
    [self.hometabHeadView addSubview:self.nineAreaView];
}


#pragma mark ******************* 轮播图 *******************
- (SDCycleScrollView*)SDCycleScrollView
{
    if(_SDCycleScrollView == nil)
    {
        NSArray *imagesURLStrings = @[@"",@""];
        
        _SDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(300)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _SDCycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        _SDCycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        _SDCycleScrollView.imageURLStringsGroup = imagesURLStrings;
        
    }
    return _SDCycleScrollView;
}

#pragma mark - scrollview回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个",index);
}
- (void)refreshBanaImages:(NSArray*)imagesURLStrings;
{
    _SDCycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

#pragma mark *************首页分类****************
- (void)myClassAction:(UIButton*)sender
{
    if(self.myclassIndexBlock)
    {
        self.myclassIndexBlock(sender.tag);
    }
}
- (UIView*)myClassView
{
    if(_myClassView == nil)
    {
        _myClassView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SDCycleScrollView.frame), KScreenWidth, KZOOM6pt(240))];
        
        NSArray *TitleArr=@[@"积分兑换",@"优惠券",@"我的订单",@"热销商品"];
        NSArray *imageArr=@[@"时间",@"时间",@"时间",@"时间"];
        
        CGFloat width = KScreenWidth/TitleArr.count;
        for (NSInteger i=0; i<TitleArr.count; i++) {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(i*width, 0, width, KZOOM6pt(220));
            
            [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            
            btn.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [btn setTitle:TitleArr[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:10];
            
            btn.tag=10000+i;
            
            [btn addTarget:self action:@selector(myClassAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_myClassView addSubview:btn];
        }
        
        UILabel *spaceline = [[UILabel alloc]initWithFrame:CGRectMake(0, KZOOM6pt(220), KScreenWidth, KZOOM6pt(20))];
        spaceline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_myClassView addSubview:spaceline];
    }
    
    return _myClassView;
}

#pragma mark ******************* 特价专区 *******************
- (UIView*)myAreaView
{
    if(_myAreaView == nil)
    {
        _myAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myClassView.frame), KScreenWidth, KZOOM6pt(380))];
        NSArray *titleArr = @[@"秒杀专区",@"折扣专区",@"减价优惠",@"赠代金券"];
        NSArray *contentArr = @[@"1元限时秒杀",@"最低5折起",@"最高可减5元",@"最高可领100元"];
        CGFloat viewwidth = KScreenWidth/2;
        CGFloat viewheigh = KZOOM6pt(360)/2;
        NSInteger viewtag = 0;
        for(int i =0; i <2; i++)
        {
            for(int j=0; j<2; j++)
            {
                UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(j*viewwidth, i*viewheigh, viewwidth, viewheigh)];
                backview.userInteractionEnabled = YES;
                backview.tag = 20000+viewtag;
                [_myAreaView addSubview:backview];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SpecialArea:)];
                [backview addGestureRecognizer:tap];
                
                UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(KZOOM6pt(20), KZOOM6pt(10), KZOOM6pt(200), KZOOM6pt(50))];
                titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
                titlelab.textColor = [UIColor redColor];
                titlelab.text = titleArr[viewtag];
                [backview addSubview:titlelab];
                
                UILabel *contentlab = [[UILabel alloc]initWithFrame:CGRectMake(KZOOM6pt(20), CGRectGetMaxY(titlelab.frame), KZOOM6pt(200), KZOOM6pt(40))];
                contentlab.textColor = KGrayColor;
                contentlab.text = contentArr[viewtag];
                contentlab.font = [UIFont systemFontOfSize:KZOOM6pt(26)];
                [backview addSubview:contentlab];
                
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(viewwidth-viewheigh, 0, viewheigh, viewheigh)];
                
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",@""]] placeholderImage:DefaultImg(imageview.size)];
                [backview addSubview:imageview];
                
                viewtag ++;
            }
        }
        
        UILabel *leveline = [[UILabel alloc]initWithFrame:CGRectMake(0, viewheigh, KScreenWidth, 1)];
        leveline.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [_myAreaView addSubview:leveline];
        
        UILabel *verticalline = [[UILabel alloc]initWithFrame:CGRectMake(viewwidth, 0, 1, KZOOM6pt(360))];
        verticalline.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [_myAreaView addSubview:verticalline];
        
        UILabel *spaceline = [[UILabel alloc]initWithFrame:CGRectMake(0, KZOOM6pt(360), KScreenWidth, KZOOM6pt(20))];
        spaceline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_myAreaView addSubview:spaceline];
    }
    
    return _myAreaView;
}

- (void)SpecialArea:(UITapGestureRecognizer*)tap
{
    if(self.specialAreaBlock)
    {
        self.specialAreaBlock(tap.view.tag);
    }
}
#pragma mark ******************* 9.9专区 *******************
- (UIView*)nineAreaView
{
    if(_nineAreaView == nil)
    {
        _nineAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myAreaView.frame), KScreenWidth, KZOOM6pt(300))];
        
        UIView *titlehead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(80))];
        titlehead.backgroundColor = KWhiteColor;
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KZOOM6pt(180), CGRectGetHeight(titlehead.frame))];
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        titlelab.text = @"9.9专区";
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(KScreenWidth-KZOOM6pt(200), 0, KZOOM6pt(200), CGRectGetHeight(titlehead.frame));
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [moreBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
        
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"arrow_icon"] forState:UIControlStateNormal];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(KZOOM6pt(10), KZOOM6pt(150), KZOOM6pt(10), KZOOM6pt(10))];
        [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, KZOOM6pt(10))];
        [moreBtn addTarget:self action:@selector(moreNinePoint) forControlEvents:UIControlEventTouchUpInside];
        
        [_nineAreaView addSubview:titlehead];
        [titlehead addSubview:titlelab];
        [titlehead addSubview:moreBtn];
        
        UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlehead.frame), KScreenWidth, KZOOM6pt(200))];
        
        int count = 4;
        CGFloat width = KZOOM6pt(140);
        CGFloat space = (KScreenWidth - count*width)/(count+1);
        for(int i =0; i<count; i++)
        {
            UIImageView *shopview = [[UIImageView alloc]init];
            shopview.tag = 30000+i;
            shopview.layer.borderWidth = 1;
            shopview.layer.borderColor = CLineColor.CGColor;
            [scrollview addSubview:shopview];
            
            [shopview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",@""]] placeholderImage:DefaultImg(shopview.size)];
            
            UITapGestureRecognizer *shoptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopClick:)];
            [shopview addGestureRecognizer:shoptap];
            
            [shopview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset((width+space)*i+space);
                make.top.mas_offset(KZOOM6pt(20));
                make.width.height.mas_offset(width);
            }];
        }
        scrollview.contentSize = CGSizeMake(width*count+space*(count-1), 0);
        [_nineAreaView addSubview:scrollview];
    }
    return _nineAreaView;
}

//更多
- (void)moreNinePoint
{
    if(self.moreNinePointBlock)
    {
        self.moreNinePointBlock();
    }
}
//9.9专区商品
- (void)shopClick:(UITapGestureRecognizer*)tap
{
    if(self.ninePointBlock)
    {
        self.ninePointBlock(tap.view.tag);
    }
}
@end

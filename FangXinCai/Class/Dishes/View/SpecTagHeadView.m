//
//  SpecTagHeadView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/6.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SpecTagHeadView.h"
#import "LabelCollectionViewCell.h"
#import "GoodsShopDetailModel.h"
@implementation SpecTagHeadView

- (instancetype)initWithFrame:(CGRect)frame;
{
    if(self == [super initWithFrame:frame])
    {
        [self creatSpecTagView:frame];
    }
    
    return self;
}
- (void)creatData
{
    NSArray *titleArr = @[@"50一袋",@"40一袋",@"30一袋",@"20一袋"];
    [self.dataArray addObjectsFromArray:titleArr];
    [self.collectionView reloadData];
}

- (void)reloadData:(NSArray*)dataArray;
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
}
- (void)creatSpecTagView:(CGRect)frame
{
    FJWaterfallFlowLayout *fjWaterfallFlowLayout = [[FJWaterfallFlowLayout alloc] init];
    fjWaterfallFlowLayout.itemSpacing = 10;
    fjWaterfallFlowLayout.lineSpacing = 0;
    fjWaterfallFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    fjWaterfallFlowLayout.colCount = 4;
    fjWaterfallFlowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height) collectionViewLayout:fjWaterfallFlowLayout];
    self.collectionView.backgroundColor = KWhiteColor;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
}

#pragma mark collectionViewDatasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    kWeakSelf(self);
    cell.clickBlock = ^(GoodsspecData *model) {
        if(weakself.selectBlock)
        {
            weakself.selectBlock(model);
        }
    };
    
    GoodsspecData *specData = self.dataArray[indexPath.item];
    [cell setCellData:specData];
    
    return cell;
}


//刷新cell
- (void)reloadCell:(int)index
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:2];
    NSArray *pathArr = @[indexPath];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:pathArr];
    }];
    
}

#pragma mark FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath
{
    CGFloat Heigh = 0;

    return Heigh;
}

- (NSMutableArray*)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end

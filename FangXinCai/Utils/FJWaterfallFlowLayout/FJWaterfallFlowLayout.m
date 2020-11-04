//
//  FJWaterfallFlowLayout.m
//  FJWaterfallFlow
//
//  Created by fujin on 16/1/8.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import "FJWaterfallFlowLayout.h"
/*      默认值    */
static const CGFloat inset = 10;
static const CGFloat colCount = 3;

@interface FJWaterfallFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary *colunMaxYDic;
@end
@implementation FJWaterfallFlowLayout
- (instancetype)init
{
    if (self=[super init]) {
        self.itemSpacing = inset;
        self.lineSpacing = inset;
        self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        self.colCount = colCount;
        self.colunMaxYDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionViewContentSize
{
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    return CGSizeMake(0, [self.colunMaxYDic[maxCol] floatValue]);
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    __block NSString * minCol = @"0";
    //遍历找出最短的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.colunMaxYDic[minCol] floatValue]) {
            minCol = column;
        }
    }];
    
    //    宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right- (self.colCount-1) * self.itemSpacing)/self.colCount;
    //    高度
    CGFloat height = 0;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForWidth:width atIndexPath:indexPath];
        
        if(indexPath.section == 1)
        {
            
            height = width;
        }else{

            height = 50;
        }
    }
    
    CGFloat x = self.sectionInset.left + (width + self.itemSpacing) * [minCol intValue];
    
    CGFloat space = 0.0;
    if (indexPath.item < self.colCount) {
        space = 0.0;
    }else{
        space = self.lineSpacing;
    }
    CGFloat y =[self.colunMaxYDic[minCol] floatValue] + space;
    
    //    跟新对应列的高度
    self.colunMaxYDic[minCol] = @(y + height);
    
    //    计算位置
    UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, height);
    
    return attri;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    //header
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        CGFloat x = self.sectionInset.left;
        CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
        
        //    跟新所有对应列的高度
        for(NSString *key in self.colunMaxYDic.allKeys)
        {
            self.colunMaxYDic[key] = @(y + size.height);
        }
        
        attri.frame = CGRectMake(x , y, size.width, size.height);
        return attri;
    }
    
    //footer
    else{
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        CGFloat x = self.sectionInset.left;
        CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue];
        
        //    跟新所有对应列的高度
        for(NSString *key in self.colunMaxYDic.allKeys)
        {
            self.colunMaxYDic[key] = @(y + size.height + self.sectionInset.bottom);
        }
        
        attri.frame = CGRectMake(x , y, size.width, size.height);
        return attri;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    for(NSInteger i = 0;i < self.colCount; i++)
    {
        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
        self.colunMaxYDic[col] = @0;
    }
    
    NSMutableArray * attrsArray = [NSMutableArray array];
    
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0 ; i < section; i++) {
        
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:headerAttrs];
        
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [attrsArray addObject:attrs];
        }
        
        //获取footer的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:footerAttrs];
    }
    
    return  attrsArray;
}

//- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
//{
//    for(NSInteger i = 0;i < self.colCount; i++)
//    {
//        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
//        self.colunMaxYDic[col] = @0;
//    }
//
//    //UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
//    //截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
//    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
//    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
//    //遍历superArray，得到一个当前屏幕中所有的section数组
//    for (UICollectionViewLayoutAttributes *attributes in superArray)
//    {
//        //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
//        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
//        {
//            [noneHeaderSections addIndex:attributes.indexPath.section];
//        }
//    }
//    
//    //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
//    //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
//    for (UICollectionViewLayoutAttributes *attributes in superArray)
//    {
//        //如果当前的元素是一个header，将header所在的section从数组中移除
//        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
//        {
//            [noneHeaderSections removeIndex:attributes.indexPath.section];
//        }
//    }
//    
//    //遍历当前屏幕中没有header的section数组
//    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
//        
//        //取到当前section中第一个item的indexPath
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
//        //获取当前section在正常情况下已经离开屏幕的header结构信息
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//        
//        //如果当前分区确实有因为离开屏幕而被系统回收的header
//        if (attributes)
//        {
//            //将该header结构信息重新加入到superArray中去
//            [superArray addObject:attributes];
//        }
//    }];
//    
//    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
//    for (UICollectionViewLayoutAttributes *attributes in superArray) {
//        
//        //如果当前item是header
//        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
//        {
//            //得到当前header所在分区的cell的数量
//            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
//            //得到第一个item的indexPath
//            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
//            //得到最后一个item的indexPath
//            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
//            //得到第一个item和最后一个item的结构信息
//            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
//            if (numberOfItemsInSection>0)
//            {
//                //cell有值，则获取第一个cell和最后一个cell的结构信息
//                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
//                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
//            }else
//            {
//                //cell没值,就新建一个UICollectionViewLayoutAttributes
//                firstItemAttributes = [UICollectionViewLayoutAttributes new];
//                //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
//                CGFloat y = CGRectGetMaxY(attributes.frame)+self.sectionInset.top;
//                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
//                //因为只有一个cell，所以最后一个cell等于第一个cell
//                lastItemAttributes = firstItemAttributes;
//            }
//            
//            //获取当前header的frame
//            CGRect rect = attributes.frame;
//            
//            //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
//            CGFloat offset = self.collectionView.contentOffset.y + _naviHeight;
//            //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
//            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
//            
//            //哪个大取哪个，保证header悬停
//            //针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
//            CGFloat maxY = MAX(offset,headerY);
//            
//            //最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
//            //当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
//            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
//            
//            //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
//            rect.origin.y = MIN(maxY,headerMissingY);
//            //给header的结构信息的frame重新赋值
//            attributes.frame = rect;
//            
//            //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
//            //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
//            attributes.zIndex = 7;
//        }
//    }
//    
//    //转换回不可变数组，并返回
//    return [superArray copy];
//    
//}

@end

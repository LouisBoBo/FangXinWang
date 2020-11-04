//
//  FullScreenScrollView.h
//  FDC
//
//  Created by wzz on 15/3/27.
//  Copyright (c) 2015年 JinZongCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenScrollView : UIScrollView<UIScrollViewDelegate>{
    
    CGFloat offset;
}

@property (nonatomic , strong)NSString *type;

-(instancetype)initWithPicutreArray:(NSArray*)PicutreArray withCurrentPage:(int)currentPage;

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;

@end

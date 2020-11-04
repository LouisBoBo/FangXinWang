//
//  PageClassView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/7.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageClassView : UIView
@property (nonatomic , strong) NSArray *titleArr;
@property (nonatomic , strong) UILabel *selectLine;
@property (nonatomic , assign) CGFloat btnwidth;
@property (nonatomic , assign) CGFloat selectLineWidth;
@property (nonatomic , assign) CGFloat space;
@property (nonatomic , strong) void(^selectBlock)(NSInteger index);

- (void)setTitle:(NSInteger)index;
- (instancetype)initWithFrame:(CGRect)frame TitleArr:(NSArray*)titleArr;
@end

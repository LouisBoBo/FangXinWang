//
//  MultilHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/31.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultilHeadView : UIView
@property (nonatomic , strong) void(^headClick)(NSInteger sort);
- (instancetype)initWithFrame:(CGRect)frame;
@end

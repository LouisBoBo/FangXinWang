//
//  SearchBarNavView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/13.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarNavView : UIView<UITextFieldDelegate>
- (instancetype)initWithFrame:(CGRect)frame back:(BOOL)isback;
@property (nonatomic , strong) void(^textFieldBlock)(NSString*text);
@property (nonatomic , strong) dispatch_block_t customerBlock;
@property (nonatomic , strong) dispatch_block_t backBlock;
@end

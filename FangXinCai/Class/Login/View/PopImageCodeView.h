//
//  PopImageCodeView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/23.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopImageCodeView : UIView<UITextFieldDelegate>
@property (nonatomic , strong) UIView *SharePopview;
@property (nonatomic , strong) UIView *ShareInvitationCodeView;
@property (nonatomic , strong) UIImageView *SharetitleImg;
@property (nonatomic , strong) UITextField *inputTextField;
@property (nonatomic , copy) NSString *imageurl; //图片链接

@property (nonatomic , strong) dispatch_block_t leftHideMindBlock;
@property (nonatomic , strong) dispatch_block_t rightHideMindBlock;
@property (nonatomic , strong) dispatch_block_t tapHideMindBlock;
@property (nonatomic , strong) void(^CodeSuccessBlock)(NSString*imageCode);
- (instancetype)initWithFrame:(CGRect)frame andbalance:(NSString*)imageurl;
- (void)remindViewHiden;
@end

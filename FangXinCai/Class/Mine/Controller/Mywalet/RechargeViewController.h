//
//  RechargeViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) UIView * updownview;
@property (strong, nonatomic) UIButton *updownBtn;
@property (weak, nonatomic) UIButton *selectBtn;       //当前选中的按键
@end

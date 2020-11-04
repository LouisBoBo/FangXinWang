//
//  SettingViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/10.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *nicknameview;
@property (weak, nonatomic) IBOutlet UIView *Genderview;
@property (weak, nonatomic) IBOutlet UIView *Phoneview;
@property (weak, nonatomic) IBOutlet UIView *Emailview;
@property (weak, nonatomic) IBOutlet UIView *Loginview;
@property (weak, nonatomic) IBOutlet UIView *Payview;
@property (weak, nonatomic) IBOutlet UIView *Customerview;
@property (weak, nonatomic) IBOutlet UIView *Headview;
@property (weak, nonatomic) IBOutlet UIImageView *headimag;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end

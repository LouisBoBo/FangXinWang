//
//  ChangePassWordViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePassWordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *OldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *NewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *FirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *OldPasswordSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *NewPasswordSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *FirmPasswordSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;
@end

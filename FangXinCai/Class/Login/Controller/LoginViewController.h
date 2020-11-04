//
//  LoginViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/19.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^loginBlock)();

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *logImage;
@property (weak, nonatomic) IBOutlet UIImageView *userlab;
@property (weak, nonatomic) IBOutlet UITextField *phonetextfield;
@property (weak, nonatomic) IBOutlet UIImageView *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextfield;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (nonatomic , assign) BOOL isAutoLoginOut; //是否被挤掉
@property (nonatomic , copy) loginBlock myLoginBlock;
- (void)returnLoginSuccess:(loginBlock)LoginSuccess;
@end

//
//  RegistViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/19.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoIamge;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *messageImg;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *AgreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *ownAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;

@end

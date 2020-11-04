//
//  ChangePayPasswordViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePayPasswordViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldTextField;
@property (weak, nonatomic) IBOutlet UITextField *payTextField;
@property (weak, nonatomic) IBOutlet UITextField *repitTextField;


@end

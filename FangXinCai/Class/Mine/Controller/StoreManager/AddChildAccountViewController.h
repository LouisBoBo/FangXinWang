//
//  AddChildAccountViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/18.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface AddChildAccountViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nicinameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

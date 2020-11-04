//
//  AddChildAccountViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/18.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "AddChildAccountViewController.h"

@interface AddChildAccountViewController ()

@end

@implementation AddChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    self.title = @"添加子账号";
    self.view.backgroundColor = CViewBgColor;
    
    [self mainView];
}
- (void)mainView
{
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:NO target:self action:@selector(cancleClick) tags:nil];
    
    self.accountTextfield.delegate = self;
    self.nicinameTextField.delegate = self;
    self.accountTextfield.borderStyle = UITextBorderStyleNone;
    self.nicinameTextField.borderStyle = UITextBorderStyleNone;
    
    self.saveButton.layer.cornerRadius = CGRectGetHeight(self.saveButton.frame)/2;
    [self.saveButton addTarget:self action:@selector(saveChildAccount:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)saveChildAccount:(UIButton*)sender
{
    NSLog(@"保存 text1=%@,text2=%@",self.accountTextfield.text,self.nicinameTextField.text);
}
- (void)cancleClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

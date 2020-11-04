//
//  ChangePassWordViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "LoginViewController.h"
@interface ChangePassWordViewController ()

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.title = @"修改登录密码";
    
    [self creatManiView];
}
- (void)creatManiView
{
    self.OldPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.NewPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.FirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    
    [self.OldPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self.OldPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
    [self.NewPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self.NewPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
    [self.FirmPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self.FirmPasswordSeeBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
    [self.SubmitBtn setBackgroundColor:basegreenColor];
    self.SubmitBtn.layer.cornerRadius = CGRectGetHeight(self.SubmitBtn.frame)/2;;
    
    [self.OldPasswordSeeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.NewPasswordSeeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.FirmPasswordSeeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.SubmitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
}
//密码可见 不可见
- (void)seeClick:(UIButton*)sender
{
    if(sender == self.OldPasswordSeeBtn)
    {
        self.OldPasswordTextField.secureTextEntry = !self.OldPasswordTextField.secureTextEntry;
    }else if (sender == self.NewPasswordSeeBtn)
    {
        self.NewPasswordTextField.secureTextEntry = !self.NewPasswordTextField.secureTextEntry;
    }else if (sender == self.FirmPasswordSeeBtn)
    {
        self.FirmPasswordTextField.secureTextEntry = !self.FirmPasswordTextField.secureTextEntry;
    }
    sender.selected = !sender.selected;
}

//提交新密码
- (void)submitClick:(UIButton*)sender
{
    NSLog(@"提交");
    //验证旧密码不能为空
    if(self.OldPasswordTextField.text.length ==0)
    {
        [MBProgressHUD show:@"当前密码不能为空" icon:nil view:self.view];
        return;
    }
    
    //验证新密码不能为空
    if(self.NewPasswordTextField.text.length == 0)
    {
        [MBProgressHUD show:@"新密码不能为空" icon:nil view:self.view];
        return;
    }
    
    //确认密码不能为空
    if(self.FirmPasswordTextField.text.length == 0)
    {
        [MBProgressHUD show:@"确认密码不能为空" icon:nil view:self.view];
        return;
    }
    
    [self changePasswordHttp];
}

#pragma mark 网络请求修改密码
- (void)changePasswordHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.OldPasswordTextField.text forKey:@"oldPwd"];
    [reqDict setValue:self.NewPasswordTextField.text forKey:@"newPwd"];
    [reqDict setValue:self.FirmPasswordTextField.text forKey:@"newPwd2"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"editPassword.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            [MBProgressHUD show:@"修改成功" icon:nil view:self.view];
//            kWeakSelf(self);
//            [weakself loginSuccess:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
            
            [self logoutHttp];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD show:message icon:nil view:self.view];
        }else{
            [MBProgressHUD show:message icon:nil view:self.view];
        }
    }];
}

//退出登录
- (void)logoutHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"logout.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            [KUserDefaul removeObjectForKey:User_Token];
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = loginNavi;
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            [KUserDefaul removeObjectForKey:User_Token];
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = loginNavi;
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

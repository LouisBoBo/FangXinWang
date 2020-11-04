//
//  ChangePayPasswordViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ChangePayPasswordViewController.h"

@interface ChangePayPasswordViewController ()
@property (nonatomic , assign) NSInteger secondsCountDown;
@property (nonatomic , strong) NSTimer *countDownTimer;
@end

@implementation ChangePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    self.view.backgroundColor = CViewBgColor;
    
    [self creatMainView];
}

- (void)creatMainView
{
    self.baseView.layer.cornerRadius = 5;
    
    self.titleLab.text = [NSString stringWithFormat:@"发送验证码到您的手机号:%@",[KUserDefaul objectForKey:User_Phone]];
    
    self.codeTextField.delegate = self;
    self.oldTextField.delegate = self;
    self.payTextField.delegate = self;
    self.repitTextField.delegate = self;
    
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.oldTextField.borderStyle = UITextBorderStyleNone;
    self.payTextField.borderStyle = UITextBorderStyleNone;
    self.repitTextField.borderStyle = UITextBorderStyleNone;
    
    self.oldTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.payTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.repitTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.getCodeBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:basegreenColor];
    self.confirmBtn.layer.cornerRadius = CGRectGetHeight(self.confirmBtn.frame)/2;
    
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
}

//获取验证码
- (void)getCodeClick:(UIButton*)sender
{
    [self imageCodeHttp];
}
//确认提交
- (void)confirmClick:(UIButton*)sender
{
    if(self.codeTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请输入验证码" icon:nil view:self.view];
        return;
    }
    
//    if(self.oldTextField.text.length == 0)
//    {
//        [MBProgressHUD show:@"请输入原密码" icon:nil view:self.view];
//        return;
//    }
    
    if(self.payTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请输入新密码" icon:nil view:self.view];
        return;
    }
    
    if(self.repitTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请再次输入新密码" icon:nil view:self.view];
        return;
    }
    
    [self submitPaywordHttp];
}

//获取短信验证码
- (void)imageCodeHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"sendSmsCode.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            self.secondsCountDown = [responseObject[@"data"] integerValue];
            self.countDownTimer = [NSTimer weakTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethord) userInfo:nil repeats:YES];
            self.getCodeBtn.userInteractionEnabled = NO;
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself imageCodeHttp];
            }];
        }
    }];
}

//提交支付密码
- (void)submitPaywordHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.oldTextField.text forKey:@"oldPwd"];
    [reqDict setValue:self.payTextField.text forKey:@"newPwd"];
    [reqDict setValue:self.repitTextField.text forKey:@"newPwd2"];
    [reqDict setValue:self.codeTextField.text forKey:@"smscode"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"editPayPassword.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            [MBProgressHUD show:@"修改支付密码成功" icon:nil view:self.view];
            [self performSelector:@selector(popback) withObject:nil afterDelay:2.0];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself submitPaywordHttp];
            }];
        }
    }];
}

#pragma mark 验证码倒计时
- (void)timerFireMethord
{
    self.secondsCountDown --;
    self.getCodeBtn.userInteractionEnabled=NO;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%zd秒", self.secondsCountDown] forState:UIControlStateNormal];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [self.getCodeBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
    
    if (self.secondsCountDown == 0)  {
        [self.countDownTimer invalidate];
        self.getCodeBtn.userInteractionEnabled=YES;
        [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = YES;
    }
}
- (void)popback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

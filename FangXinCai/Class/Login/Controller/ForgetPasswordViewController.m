//
//  ForgetPasswordViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "PopImageCodeView.h"
@interface ForgetPasswordViewController ()
@property (nonatomic , assign) NSInteger secondsCountDown;
@property (nonatomic , strong) NSTimer *countDownTimer;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = CViewBgColor;
    [self creatMainView];
}

- (void)creatMainView
{
    self.baseView.layer.cornerRadius = 5;
    
    self.codeTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passWordTextField.delegate = self;
    self.repitTextField.delegate = self;
    
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.passWordTextField.borderStyle = UITextBorderStyleNone;
    self.repitTextField.borderStyle = UITextBorderStyleNone;
    
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.getCodeBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:basegreenColor];
    self.confirmBtn.layer.cornerRadius = CGRectGetHeight(self.confirmBtn.frame)/2;
    
    [self.getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
}

//获取验证码
- (void)getCodeClick:(UIButton*)sender
{
    if(self.phoneTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    [self imageCodeHttp];
}
//确认提交
- (void)confirmClick:(UIButton*)sender
{
    if(self.phoneTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    
    if(self.codeTextField.text.length == 0)
    {
        [MBProgressHUD show:@"请输入短信验证码" icon:nil view:self.view];
        return;
    }

    if(self.passWordTextField.text.length == 0)
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

//获取图片验证码
- (void)imageCodeHttp
{
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:self.phoneTextField.text forKey:@"mobile"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"verifyCode.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            [self.view endEditing:YES];
            [self setImageCodeMindView:responseObject[@"data"]];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

//获取短信验证码
- (void)sendMessageHttp:(NSString*)imagecode
{
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:self.phoneTextField.text forKey:@"mobile"];
    [reqDict setValue:@"1" forKey:@"scene"];
    [reqDict setValue:imagecode forKey:@"imgcode"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"getSmsCode.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            self.secondsCountDown = 120;
            self.countDownTimer = [NSTimer weakTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethord) userInfo:nil repeats:YES];
            self.getCodeBtn.userInteractionEnabled = NO;
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

//提交新密码
- (void)submitPaywordHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.phoneTextField.text forKey:@"mobile"];
    [reqDict setValue:self.codeTextField.text forKey:@"smscode"];
    [reqDict setValue:self.passWordTextField.text forKey:@"password"];
    [reqDict setValue:self.repitTextField.text forKey:@"password2"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"findBackPwd.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            [MBProgressHUD show:@"找回密码成功" icon:nil view:self.view];
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

- (void)setImageCodeMindView:(NSString*)imageurl
{
    PopImageCodeView *mindview = [[PopImageCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andbalance:imageurl];
    kWeakSelf(self);
    __weak PopImageCodeView *weakmind = mindview;
    mindview.leftHideMindBlock = ^{
        [weakmind remindViewHiden];
    };
    mindview.rightHideMindBlock = ^{
        [weakmind remindViewHiden];
    };
    mindview.CodeSuccessBlock = ^(NSString *imageCode) {
        [weakself sendMessageHttp:imageCode];
    };
    
    [self.view addSubview:mindview];
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

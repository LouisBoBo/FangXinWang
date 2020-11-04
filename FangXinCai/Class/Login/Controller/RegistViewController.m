//
//  RegistViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/19.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "RegistViewController.h"
#import "StoreSelectViewController.h"
#import "PopImageCodeView.h"

@interface RegistViewController ()
@property (nonatomic , assign) NSInteger secondsCountDown;
@property (nonatomic , strong) NSTimer *countDownTimer;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    self.isHidenKeyToolBar = NO;
    
    [self mainView];
}

#pragma mark *************网络请求************
//注册
- (void)registHttp
{
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:self.phoneTextField.text forKey:@"mobile"];
    [reqDict setValue:self.messageTextField.text forKey:@"smscode"];
    [reqDict setValue:self.passwordTextField.text forKey:@"password"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"register.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            [self saveLoginInfomation:responseObject];
            [self selectStore];
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
            self.senderButton.userInteractionEnabled = NO;
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
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

#pragma mark 保存登录成功返回的数据
- (void)saveLoginInfomation:(NSDictionary*)dicdata
{
    NSString *userName = [NSString stringWithFormat:@"%@",dicdata[@"data"][@"userName"]];
    NSString *shopsID = [NSString stringWithFormat:@"%@",dicdata[@"data"][@"shops_id"]];
    NSString *token = [NSString stringWithFormat:@"%@",dicdata[@"data"][@"token"]];
    
    
    [KUserDefaul setObject:userName forKey:User_Name];
    [KUserDefaul setObject:shopsID forKey:User_ID];
    [KUserDefaul setObject:token forKey:User_Token];
    [KUserDefaul setObject:self.phoneTextField.text forKey:User_Phone];
}

- (void)mainView
{
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.messageTextField.borderStyle = UITextBorderStyleNone;
    self.messageTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    
    [self.senderButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.senderButton setTitleColor:basegreenColor forState:UIControlStateNormal];
    self.senderButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.seeBtn setBackgroundImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self.seeBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
    [self.seeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registBtn.layer.cornerRadius = CGRectGetHeight(self.registBtn.frame)/2;
    self.registBtn.backgroundColor = basegreenColor;
    [self.registBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.AgreementBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.AgreementBtn addTarget:self action:@selector(AgreementClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.ownAccountBtn addTarget:self action:@selector(ownAccountClick:) forControlEvents:UIControlEventTouchUpInside];
}
//发送短信验证码
- (void)sendClick:(UIButton*)sender
{
    //验证手机号不能为空
    if(self.phoneTextField.text.length ==0)
    {
        [MBProgressHUD show:@"手机号不能为空" icon:nil view:self.view];
        return;
    }
    
    //检测是否是手机号
    BOOL isPhone = [HelpWay isMobileNum:self.phoneTextField.text];
    if(!isPhone)
    {
        [MBProgressHUD show:@"请填写正确的手机号" icon:nil view:self.view];
        return;
    }
    
    //图片验证码
    [self imageCodeHttp];
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
    self.senderButton.userInteractionEnabled=NO;
    [self.senderButton setTitle:[NSString stringWithFormat:@"%zd秒", self.secondsCountDown] forState:UIControlStateNormal];
    self.senderButton.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [self.senderButton setTitleColor:KGrayColor forState:UIControlStateNormal];
    
    if (self.secondsCountDown == 0)  {
        [self.countDownTimer invalidate];
        self.senderButton.userInteractionEnabled=YES;
        [self.senderButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.senderButton setTitleColor:basegreenColor forState:UIControlStateNormal];
        self.senderButton.userInteractionEnabled = YES;
    }
}
//密码可见不可见
- (void)seeClick:(UIButton*)sender
{
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    sender.selected = !sender.selected;
}

//注册
- (void)registClick:(UIButton*)sender
{
    //验证手机号不能为空
    if(self.phoneTextField.text.length ==0)
    {
        [MBProgressHUD show:@"手机号不能为空" icon:nil view:self.view];
        return;
    }
    
    //检测是否是手机号
    BOOL isPhone = [HelpWay isMobileNum:self.phoneTextField.text];
    if(!isPhone)
    {
        [MBProgressHUD show:@"请填写正确的手机号" icon:nil view:self.view];
        return;
    }
    
    //短信验证码不能为空
    if(self.messageTextField.text.length == 0)
    {
        [MBProgressHUD show:@"短信验证码不能为空" icon:nil view:self.view];
        return;
    }
    
    //验证密码不能为空
    if(self.passwordTextField.text.length == 0)
    {
        [MBProgressHUD show:@"密码不能为空" icon:nil view:self.view];
        return;
    }
    
    [self registHttp];
}

//选择门店
- (void)selectStore
{
    StoreSelectViewController *store = [StoreSelectViewController new];
    kWeakSelf(self);
    store.selectSuccess = ^{
        [weakself registSuccessRootvc];
    };
    [self.navigationController pushViewController:store animated:YES];
}
//注册成功后重新处理rootViewController
- (void)registSuccessRootvc
{
    MainTabBarController *tabbar = [MainTabBarController new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbar;
}
//用户协议
- (void)AgreementClick:(UIButton*)sender
{
   
}
//拥有账号
- (void)ownAccountClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

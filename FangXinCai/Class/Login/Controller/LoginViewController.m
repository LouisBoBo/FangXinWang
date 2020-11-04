//
//  LoginViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/19.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "MainTabBarController.h"
#import "StoreSelectViewController.h"
#import "StoreExamineViewController.h"
#import "ForgetPasswordViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    self.isHidenKeyToolBar = NO;
    
    [self mainView];
}

#pragma mark 网络请求登录
- (void)loginHttp:(NSString*)userName Pw:(NSString*)passWord
{
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:userName forKey:@"userName"];
    [reqDict setValue:passWord forKey:@"passWord"];
    [reqDict setValue:@"1" forKey:@"loginType"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"login.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            [self saveLoginInfomation:responseObject];
            NSString *shopsID = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shops_id"]];
            //商户id:大于0则跳转到首页，否则跳转到创建商户界面
            if(shopsID.integerValue > 0)
            {
                [self loginSuccessRootvc];
            }else{
                [self selectStore];
            }
           
            if (self.myLoginBlock!=nil) {
                self.myLoginBlock();
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD show:message icon:nil view:self.view];
        }else{
            [MBProgressHUD show:message icon:nil view:self.view];
        }
    }];
}

- (void)returnLoginSuccess:(loginBlock)LoginSuccess;
{
    self.myLoginBlock = LoginSuccess;
}
//选择门店
- (void)selectStore
{
    StoreSelectViewController *store = [StoreSelectViewController new];
    kWeakSelf(self);
    store.selectSuccess = ^{
        [weakself loginSuccessRootvc];
    };
    [self.navigationController pushViewController:store animated:YES];
}
//登录成功后重新处理rootViewController
- (void)loginSuccessRootvc
{
    if(self.isAutoLoginOut)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        MainTabBarController *tabbar = [MainTabBarController new];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = tabbar;
    }
}

//获取当前的VC
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
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
    [KUserDefaul setObject:self.phonetextfield.text forKey:User_Phone];
}

- (void)mainView
{
    self.phonetextfield.borderStyle = UITextBorderStyleNone;
    self.phonetextfield.keyboardType = UIKeyboardTypePhonePad;
    self.passwordtextfield.borderStyle = UITextBorderStyleNone;
    
    [self.seeBtn setBackgroundImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self.seeBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateSelected];
    [self.seeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginBtn.layer.cornerRadius = CGRectGetHeight(self.loginBtn.frame)/2;
    self.loginBtn.backgroundColor = basegreenColor;
    [self.loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetBtn addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
}

//密码可见还可见
- (void)seeClick:(UIButton*)sender
{
    self.passwordtextfield.secureTextEntry = !self.passwordtextfield.secureTextEntry;
    sender.selected = !sender.selected;
}
//登录
- (void)loginClick:(UIButton*)sender
{
    //验证手机号不能为空
    if(self.phonetextfield.text.length ==0)
    {
        [MBProgressHUD show:@"手机号不能为空" icon:nil view:self.view];
        return;
    }
    
    //检测是否是手机号
    BOOL isPhone = [HelpWay isMobileNum:self.phonetextfield.text];
    if(!isPhone)
    {
        [MBProgressHUD show:@"请填写正确的手机号" icon:nil view:self.view];
        return;
    }
    
    //验证密码不能为空
    if(self.passwordtextfield.text.length == 0)
    {
        [MBProgressHUD show:@"密码不能为空" icon:nil view:self.view];
        return;
    }
    
    [self loginHttp:self.phonetextfield.text Pw:self.passwordtextfield.text];
}
//注册
- (void)registClick:(UIButton*)sender
{
    NSLog(@"注册");
    RegistViewController *regist = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}
//忘记密码
- (void)forgetClick:(UIButton*)sender
{
    NSLog(@"忘记密码");
    ForgetPasswordViewController *password = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:password animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

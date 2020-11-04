//
//  StoreExamineViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreExamineViewController.h"
#import "StoreSelectViewController.h"
@interface StoreExamineViewController ()

@end

@implementation StoreExamineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请结果";
    [self creatMainView];
    [self getShopMessageInfo];
}
- (void)creatMainView
{
    self.titlelab.textColor = basegreenColor;
    self.titlelab.font = [UIFont fontWithName:@"Helvetica-Bold" size:KZOOM6pt(50)];//字体加粗
    
    self.undoBtn.layer.cornerRadius = 5;
    self.logoutBtn.layer.cornerRadius = 5;
    
    self.undoBtn.backgroundColor = basegreenColor;
    self.logoutBtn.backgroundColor = basegreenColor;
    
    self.undoBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(32)];
    self.logoutBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(32)];
    
    [self.undoBtn addTarget:self action:@selector(undoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
//网络请求撤消商户申请
- (void)undoHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.applyid forKey:@"apply_id"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"cancelApply.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            [MBProgressHUD showError:@"撤消申请成功" toView:kAppWindow];
            [self undoSuccessGonext];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself undoHttp];
            }];
        }
    }];
}

//网络请求获取门店信息
- (void)getShopMessageInfo
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.applyid forKey:@"apply_id"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"waitCheck.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            self.shopName.text = [NSString stringWithFormat:@"商户名：%@",responseObject[@"data"][@"shops_name"]];
            self.shopContacts.text = [NSString stringWithFormat:@"联系人：%@",responseObject[@"data"][@"shops_contacts"]];
            self.shopPhone.text = [NSString stringWithFormat:@"联系人电话：%@",responseObject[@"data"][@"shops_phone"]];
            self.shopAddress.text = [NSString stringWithFormat:@"商户地址：%@",responseObject[@"data"][@"shops_address"]];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getShopMessageInfo];
            }];
        }
    }];
}
- (void)undoClick:(UIButton*)sender
{
    NSLog(@"撤消");
//    [self undoHttp];
    
    [self undoSuccessGonext];//测试用后面删除
}

- (void)logoutClick:(UIButton*)sender
{
    NSLog(@"退出登录");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)undoSuccessGonext
{
    for(UIViewController *vv in self.navigationController.viewControllers)
    {
        if([vv isKindOfClass:[StoreSelectViewController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }

    StoreSelectViewController *storeSelect = [StoreSelectViewController new];
    [self.navigationController pushViewController:storeSelect animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

//
//  InvoiceViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "InvoiceViewController.h"
#import "UITextView+Placeholder.h"
#import "ChangeUserInfoManager.h"
@interface InvoiceViewController ()
@property (nonatomic , strong) NSString *textviewcontent;
@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.isHidenKeyToolBar  = NO;
    [self creatmainView];
}
- (void)creatmainView
{
    if([self.title isEqualToString:@"发票"])
    {
        self.textview.placeholder = @"请输入发票抬头";
    }else if ([self.title isEqualToString:@"昵称"])
    {
        self.textview.placeholder = self.valueinfo.length==0?@"请输入昵称":self.valueinfo;
    }else if ([self.title isEqualToString:@"手机"])
    {
        self.textview.placeholder =self.valueinfo.length==0?@"请输入手机号码":self.valueinfo;
    }else if ([self.title isEqualToString:@"邮箱"])
    {
        self.textview.placeholder =self.valueinfo.length==0?@"请输入邮箱":self.valueinfo;
    }else if ([self.title isEqualToString:@"订单备注"])
    {
        self.textview.placeholder = @"请输入订单备注";
    }
    
    self.textview.delegate = self;
    
    [self.PreservationBtn setBackgroundImage:[UIImage imageWithColor:basegreenColor] forState:UIControlStateNormal];
    self.PreservationBtn.clipsToBounds = YES;
    self.PreservationBtn.layer.cornerRadius = CGRectGetHeight(self.PreservationBtn.frame)/2;
    
    [self.PreservationBtn addTarget:self action:@selector(preservation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    self.textviewcontent = textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    self.textviewcontent = textView.text;
}
- (void)preservation:(UIButton*)sender
{
    if([self.title isEqualToString:@"发票"])
    {
        if(self.textviewcontent == nil || [self.textviewcontent isEqualToString:@""])
        {
            [MBProgressHUD show:@"请填写发票抬头" icon:nil view:self.view];
            
            return;
        }
    }else if ([self.title isEqualToString:@"订单备注"])
    {
        if(self.textviewcontent == nil || [self.textviewcontent isEqualToString:@""])
        {
            [MBProgressHUD show:[NSString stringWithFormat:@"请填写%@",self.title] icon:nil view:self.view];
            
            return;
        }else{
            if(self.OrderRemarksBlock)
            {
                self.OrderRemarksBlock(self.textviewcontent);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if(self.textviewcontent == nil || [self.textviewcontent isEqualToString:@""])
        {
            [MBProgressHUD show:[NSString stringWithFormat:@"请填写%@",self.title] icon:nil view:self.view];
            
            return;
        }
        
        if([self.title isEqualToString:@"昵称"])
        {
            [[ChangeUserInfoManager changeUserInfoManarer] changeUserInfoHttp:nil NickName:self.textviewcontent Sex:nil Email:nil Success:^(id data) {
                if(self.changeSuccess)
                {
                    self.changeSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([self.title isEqualToString:@"邮箱"])
        {
            [[ChangeUserInfoManager changeUserInfoManarer] changeUserInfoHttp:nil NickName:nil Sex:nil Email:self.textviewcontent Success:^(id data) {
                if(self.changeSuccess)
                {
                    self.changeSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

//
//  HtmlTextViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/2.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "HtmlTextViewController.h"

@interface HtmlTextViewController ()

@end

@implementation HtmlTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlstr = [KUserDefaul objectForKey:@"htmlstr"];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    webview.dataDetectorTypes = UIDataDetectorTypeAll;
    [webview loadHTMLString:htmlstr baseURL:nil];
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

//
//  InvoiceViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface InvoiceViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *PreservationBtn;

@property (nonatomic , strong) NSString *valueinfo;
//修改用户信息成功回调
@property (nonatomic , strong) dispatch_block_t changeSuccess;
//订单备注输入完毕回调
@property (nonatomic , strong) void(^OrderRemarksBlock)(id data);
@end

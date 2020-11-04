//
//  StoreExamineViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreExamineViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopContacts;
@property (weak, nonatomic) IBOutlet UILabel *shopPhone;
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;

@property (nonatomic , strong) NSString *applyid;
@end

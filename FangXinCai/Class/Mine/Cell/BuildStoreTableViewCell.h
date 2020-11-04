//
//  BuildStoreTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildStoreModel.h"
@interface BuildStoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;
@property (weak, nonatomic) IBOutlet UIImageView *goImg;
@property (weak, nonatomic) IBOutlet UILabel *spaceline;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (void)refreshData:(BuildStoreModel*)model isBuild:(BOOL)build;
@end

//
//  DetailRecordTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailRecordModel.h"
@interface DetailRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;

- (void)refreshData:(DetailRecordModel*)model;
@end

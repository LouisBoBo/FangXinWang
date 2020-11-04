//
//  MJFriendCell2TableViewCell.h
//  03-QQ好友列表
//
//  Created by ylgwhyh on 16/2/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopModel.h"

@interface RightTableViewCell : UITableViewCell<UITextFieldDelegate,CAAnimationDelegate>

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *inPutTextField;
@property (weak, nonatomic) IBOutlet UIButton *addactiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (nonatomic , strong) void(^addCartBlock)(NSDictionary*data,BOOL add);
@property (nonatomic , strong) void(^selectSpecBlock)(GoodsShopData *shopmodel);
@property (nonatomic , strong) void(^collectBlock)(GoodsShopData*shopmodel);
@property (nonatomic , strong) GoodsShopData *shopmodel;
- (void)refreshData:(GoodsShopData*)data;
- (void)refreshTextData:(GoodsShopData*)data;
@end

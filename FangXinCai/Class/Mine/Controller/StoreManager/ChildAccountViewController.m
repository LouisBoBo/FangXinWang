//
//  ChildAccountViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/18.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ChildAccountViewController.h"
#import "ChildAccountTableViewCell.h"
#import "AddChildAccountViewController.h"
#import "StoreManagerModel.h"

@interface ChildAccountViewController ()

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"子账号管理";
    
    [self creatMainTableView];
    
    [self creatData];
}

- (void)creatData
{
    
    for(int i =0; i <3; i++)
    {
        StoreManagerModel *model = [StoreManagerModel new];
        model.isSelected = NO;
        [self.tabDataArr addObject:model];
    }
    if(self.tabDataArr.count == 0)
    {
        self.Type=TBNODateType;
    }
    [self.tableView reloadData];
}

//主列表
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-40);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.tableFootView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChildAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChildCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(StoreManagerModel *model in self.tabDataArr)
    {
        model.isSelected = NO;
    }
    StoreManagerModel *model = self.tabDataArr[indexPath.row];
    model.isSelected = YES;
    
    [tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildCell"];
    if(!cell)
    {
        cell = [[ChildAccountTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChildCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView*)tableFootView
{
    if(_tableFootView == nil)
    {
        _tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _tableFootView.backgroundColor = KWhiteColor;
        
        UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footButton setTitleColor:KGrayColor forState:UIControlStateNormal];
        footButton.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [footButton setTitle:@"添加子账号" forState:UIControlStateNormal];
        [footButton setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        [footButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [footButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [footButton addTarget:self action:@selector(addChildAccount:) forControlEvents:UIControlEventTouchUpInside];
        [_tableFootView addSubview:footButton];
        
        
        
        [footButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.height.equalTo(_tableFootView);
            make.width.mas_equalTo(KZOOM6pt(220));
        }];
    }
    return _tableFootView;
}

- (void)addChildAccount:(UIButton*)sender
{
    NSLog(@"添加子账号");
    
    AddChildAccountViewController *addChild = [[AddChildAccountViewController alloc] init];
    [self.navigationController pushViewController:addChild animated:YES];
}
- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

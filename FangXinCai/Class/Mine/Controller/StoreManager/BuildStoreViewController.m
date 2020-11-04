//
//  BuildStoreViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BuildStoreViewController.h"
#import "BuildStoreTableViewCell.h"
#import "UploadStoreViewController.h"
#import "MapViewController.h"
#import "BuildStoreModel.h"
@interface BuildStoreViewController ()
@property (nonatomic , copy) NSString *shops_name;       //商品名称
@property (nonatomic , copy) NSString *shops_contacts;   //联系人
@property (nonatomic , copy) NSString *shops_address;    //联系地址
@property (nonatomic , copy) NSString *shops_license;    //营业执照
@property (nonatomic , copy) NSString *shops_receiver;   //收货人
@property (nonatomic , copy) NSString *receiver_phone;   //收货人电话
@property (nonatomic , copy) NSString *longitude;        //经度
@property (nonatomic , copy) NSString *latitude;         //纬度
@end

@implementation BuildStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenKeyToolBar  = NO;
    
    [self creatMainTableView];
    [self creatData];
}
- (void)creatData
{
    NSArray *keys = @[@"baseMessage",@"Authentication",@"takeover"];
    [self.tabDataArr addObjectsFromArray:keys];
    
    NSArray *headarr = @[@"基础信息",@"认证信息",@"收货信息"];
    [self.headerArray addObjectsFromArray:headarr];
    
    NSArray *baseMessage = @[@"门店名称",@"负责人",@"门店地址",@""];
    NSArray *Authentication = @[@"营业执照"];
    NSArray *takeover = @[@"收货人",@"联系电话"];
    
    NSArray *baseMessageContent = @[@"门店名称",@"负责人姓名",@"请选择门店地址",@"详细地址(如门牌号)"];
    NSArray *AuthenticationContent = @[@"未上传"];
    NSArray *takeoverContent = @[@"收货人姓名",@"收货人电话"];
    
    
    NSMutableArray *totalTitledata = [NSMutableArray array];
    [totalTitledata addObject:baseMessage];
    [totalTitledata addObject:Authentication];
    [totalTitledata addObject:takeover];
    
    NSMutableArray *totalContentdata = [NSMutableArray array];
    [totalContentdata addObject:baseMessageContent];
    [totalContentdata addObject:AuthenticationContent];
    [totalContentdata addObject:takeoverContent];
    
    
    for(int i=0; i<self.headerArray.count;i++)
    {
        NSArray *titlearr = totalTitledata[i];
        NSArray *contentarr = totalContentdata[i];
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for(int j =0;j<titlearr.count; j++)
        {
            BuildStoreModel *model = [[BuildStoreModel alloc]init];
            model.title = titlearr[j];
            model.content = contentarr[j];
            [dataArr addObject:model];
        }
        [self.dataDictionary setObject:dataArr forKey:self.tabDataArr[i]];
    }
    
    NSLog(@"******=%@",self.dataDictionary);
    
}
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-40);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header.hidden = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BuildStoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuildStoreCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footButton];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerArray.count;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 30)];
    headlab.text = [NSString stringWithFormat:@"%@",self.headerArray[section]];
    headlab.textColor = basegreenColor;
    headlab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    
    [headview addSubview:headlab];
    return headview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArr = [self.dataDictionary objectForKey:self.tabDataArr[section]];
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArr = [self.dataDictionary objectForKey:self.tabDataArr[indexPath.section]];
    BuildStoreModel *model = dataArr[indexPath.row];
    if([model.title isEqualToString:@"门店地址"])
    {
        MapViewController *map =[MapViewController new];
        map.hidesBottomBarWhenPushed = YES;
        kWeakSelf(self);
        map.LoctionBlock = ^(CGFloat latitude,CGFloat longitude, NSString *name, NSString *address) {
            self.longitude = [NSString stringWithFormat:@"%f",longitude];
            self.latitude  = [NSString stringWithFormat:@"%f",latitude];
            self.shops_address = address;
            model.content = address;
            //刷新单个cell
            [weakself reloaCellWithSection:0 WithRow:2];
        };
        [self.navigationController pushViewController:map animated:YES];
    }else if ([model.title isEqualToString:@"营业执照"])
    {
        UploadStoreViewController *upload = [UploadStoreViewController new];
        kWeakSelf(self);
        upload.uploadSuccess = ^(NSString *imagesta) {
            self.shops_license = imagesta;
            model.content = @"已上传";
            //刷新单个cell
            [weakself reloaCellWithSection:1 WithRow:0];
        };
        [self.navigationController pushViewController:upload animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildStoreCell"];
    if(!cell)
    {
        cell = [[BuildStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BuildStoreCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.goImg.hidden = (indexPath.section ==0 || indexPath.section ==2)?YES:NO;
    
    cell.inputTextField .hidden = (indexPath.section ==0 || indexPath.section ==2)?NO:YES;
    cell.contentlab .hidden = !cell.inputTextField.hidden;
    
    NSArray *dataArr = [self.dataDictionary objectForKey:self.tabDataArr[indexPath.section]];
    BuildStoreModel *model = dataArr[indexPath.row];
    [cell refreshData:model isBuild:self.storetype==BuildStoreType];
    
    return cell;
}

- (void)reloaCellWithSection:(NSInteger)section WithRow:(NSInteger)row
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    BuildStoreTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentlab.textColor = KGrayColor;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 保存新建的门店
- (void)saveStore:(UIButton*)sender
{
    for(int i =0; i < self.tabDataArr.count; i++)
    {
        NSArray *dataArr = [self.dataDictionary objectForKey:self.tabDataArr[i]];
        for(int j = 0;j<dataArr.count;j++)
        {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            BuildStoreTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            NSArray *dataArr = [self.dataDictionary objectForKey:self.tabDataArr[indexPath.section]];
            BuildStoreModel *model = dataArr[indexPath.row];
            if(cell.inputTextField.text.length == 0)
            {
                NSString *sstt = @"";
                if([model.title isEqualToString:@"门店地址"])
                {
                    sstt = @"";
                    if(![cell.contentlab.text isEqualToString:@"请选择门店地址"] && cell.contentlab.text.length >0)
                    {
                        continue;
                    }
                }else if ([model.title isEqualToString:@""])
                {
                    continue;
                }else if ([model.title isEqualToString:@"营业执照"])
                {
                    sstt = @"营业执照";
                    if([cell.contentlab.text isEqualToString:@"已上传"])
                    {
                        continue;
                    }
                }
                else{
                    sstt = @"请填写";
                }
                [MBProgressHUD show:[NSString stringWithFormat:@"%@%@",sstt,model.content] icon:nil view:self.view];
                return;
            }else{
                if([model.title isEqualToString:@"门店名称"])
                {
                    self.shops_name = cell.inputTextField.text;
                }else if ([model.title isEqualToString:@"负责人"])
                {
                    self.shops_contacts = cell.inputTextField.text;
                }else if ([model.title isEqualToString:@"收货人"])
                {
                    self.shops_receiver = cell.inputTextField.text;
                }else if ([model.title isEqualToString:@"联系电话"])
                {
                    self.receiver_phone = cell.inputTextField.text;
                }
            }
        }
    }
    
    [self saveStoreMessageHttp];
}

- (void)saveStoreMessageHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.shops_name forKey:@"shops_name"];
    [reqDict setValue:self.shops_contacts forKey:@"shops_contacts"];
    [reqDict setValue:self.shops_address forKey:@"shops_address"];
    [reqDict setValue:self.longitude forKey:@"longitude"];
    [reqDict setValue:self.latitude forKey:@"latitude"];
    [reqDict setValue:self.shops_license forKey:@"shops_license"];
    [reqDict setValue:self.shops_receiver forKey:@"shops_receiver"];
    [reqDict setValue:self.receiver_phone forKey:@"receiver_phone"];
    
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"addShop.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        [self.tableView.mj_header endRefreshing];
        
        if (responseStatus == 1) {
            
            [MBProgressHUD show:@"保存成功" icon:nil view:self.view];
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1.0];
            
            if(self.buildSuccess)
            {
                self.buildSuccess(@"success");
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD show:message icon:nil view:self.view];
        }else{
            
            [MBProgressHUD show:message icon:nil view:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself saveStoreMessageHttp];
            }];
        }
    }];
    
}
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIButton*)footButton
{
    if(_footButton == nil)
    {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footButton.frame = CGRectMake(0, kScreenHeight-40-64, kScreenWidth, 40);
        _footButton.backgroundColor = basegreenColor;
        _footButton.titleLabel.textColor = KWhiteColor;
        [_footButton setTitle:@"保存" forState:UIControlStateNormal];
        [_footButton addTarget:self action:@selector(saveStore:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _footButton;
}
- (NSMutableDictionary*)dataDictionary
{
    if(_dataDictionary == nil)
    {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}
- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (NSMutableArray*)headerArray
{
    if(_headerArray == nil)
    {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

//
//  MapViewController.h
//  Eatshopdemo
//
//  Created by bob on 16/3/3.
//  Copyright © 2016年 bob. All rights reserved.
//

#import "baseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
//typedef void(^LoctionBlock)(CGFloat,CGFloat,NSString*,NSString*);//回调经纬度
@interface MapViewController : BaseViewController

//回调经纬度
@property(nonatomic,strong) void (^LoctionBlock)(CGFloat,CGFloat,NSString*,NSString*);
@property (nonatomic , strong) void(^addressBlock)(NSString*address);
@property (nonatomic, strong) MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *NavView;

@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property(nonatomic,strong)UITableView *searchTableView;//搜索列表

@end

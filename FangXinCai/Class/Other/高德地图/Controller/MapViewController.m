//
//  MapViewController.m
//  Eatshopdemo
//
//  Created by bob on 16/3/3.
//  Copyright © 2016年 bob. All rights reserved.
//

#import "MapViewController.h"
#import "nearTableViewCell.h"
#import "BaiduModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapPoiTableView.h"

@interface MapViewController ()<MAMapViewDelegate,MapPoiTableViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{

    UIButton *_locationBtn;
    
    // 地图中心点的标记
    UIImageView *_centerMaker;
    
    // 地图中心点POI列表
    MapPoiTableView *_tableView;
    
    // 第一次定位标记
    BOOL isFirstLocated;
    
    // 搜索API
    AMapSearchAPI *_searchAPI;
    
    // 搜索页数
    NSInteger searchPage;
    
    // 禁止连续点击两次
    BOOL _isMapViewRegionChangedFromTableView;
    
    
    //搜索
    
    BOOL isSearchModel;//是否搜索模式
    NSString *_city;
    // 搜索key
    NSString *_searchString;
    // 搜索页数
    NSInteger resultsearchPage;
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
    
   
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
     isSearchModel=NO;
    
    _searchString=@"";
    [self CreatNavBar];

    [self initMapView];

    [self initLocationButton];
    
    [self initCenterMarker];

    [self CreatTableView];
    
    [self initSearch];

    _searchResultArray = [NSMutableArray array];
    
    
}

//创建导航栏
-(void)CreatNavBar
{
    self.isHidenNaviBar = YES;
    
    self.NavView.backgroundColor = CNavBgColor;
    
    self.searchBackView.layer.cornerRadius=4;
    
    self.searchBackView.clipsToBounds=YES;
    
    self.searchTF.delegate=self;

    [self.searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    isSearchModel=NO;
    
    [self.searchTableView removeFromSuperview];
    
    self.searchTableView=nil;
    
    _searchAPI.delegate=self;
    
    textField.text=@"";
    
    [textField resignFirstResponder];

    return YES;
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isSearchModel=YES;
 
    _searchAPI.delegate = self;

    [self CreatSearchTableView];
    
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    isSearchModel=NO;
    
    [self.searchTableView removeFromSuperview];
    
    self.searchTableView=nil;
    
    _searchAPI.delegate=self;
    [textField resignFirstResponder];
    
    return YES;

}


- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length>0) {
        
        [self CreatSearchTableView];
        
        _searchString=textField.text;
        
        resultsearchPage=1;
        
        searchPage = 1;
        [self searchPoiBySearchString:_searchString];
   
    }else{
   
        _searchString=@"";
        
        resultsearchPage=1;
        
        searchPage = 1;
        [self searchPoiBySearchString:_searchString];
        
        NSLog(@"空");
  
    }

}



#pragma mark-创建搜索结果的tableView
-(void)CreatSearchTableView
{
    
    if (self.searchTableView) {
       
        self.searchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        NSLog(@"已经存在");
        _searchAPI.delegate=self;
        
    }else{
    
    self.searchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    
    self.searchTableView.delegate=self;
    
    self.searchTableView.dataSource=self;
    
    self.searchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    [self.view addSubview:self.searchTableView];
    
    }
    
}



- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self clearMapView];
    
    [self clearSearch];
    
}


#pragma mark - 初始化
- (void)initMapView
{
    //创建地图View
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64,KScreenWidth, 260)];
    
    _mapView.delegate = self;
    // 不显示罗盘
    _mapView.showsCompass = NO;
    // 不显示比例尺
    _mapView.showsScale = NO;
    // 地图缩放等级
    _mapView.zoomLevel = 16;
    // 开启定位
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
}


#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

    if (updatingLocation&& !isFirstLocated) {
        
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
         isFirstLocated = YES;
        
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];
    }
    
    

}



- (void)initCenterMarker
{
   
    UIImage *image = [UIImage imageNamed:@"dit"];
    _centerMaker = [[UIImageView alloc] initWithImage:image];
    _centerMaker.frame = CGRectMake(KScreenWidth/2.0-15, 130+64-20, 30, 40);
    _centerMaker.center = CGPointMake(KScreenWidth/ 2, (130+64-20));
    [self.view addSubview:_centerMaker];
 
}



- (void)initLocationButton
{

    _locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    _locationBtn.frame=CGRectMake(10, 260, 40, 40);
    _locationBtn.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
 
    [_locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [_locationBtn setImage:[UIImage imageNamed:@"weiz"] forState:UIControlStateNormal];
    [self.view addSubview:_locationBtn];
    
    
    
}

#pragma mark - Action
- (void)actionLocation
{
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}


- (void)initSearch
{
    searchPage = 1;
    _searchAPI = [[AMapSearchAPI alloc] init];
    
    if (isSearchModel==NO) {
         _searchAPI.delegate = _tableView;
        
    }else{
        
        _searchAPI.delegate = self;
    }
   

}



-(void)CreatTableView
{
    
    _tableView = [[MapPoiTableView alloc] initWithFrame:CGRectMake(0,64+260, KScreenWidth, KScreenHeight-260-64)];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

}

// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    // 搜索半径
    request.radius = 1000;
    // 搜索结果排序
    request.sortrule = 1;
    // 当前页数
    request.page = searchPage;
    [_searchAPI AMapPOIAroundSearch:request];
}

// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = location;
    // 返回扩展信息
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
}

#pragma mark - Action
- (void)searchPoiBySearchString:(NSString *)searchString
{
    self.searchTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //POI关键字搜索
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchString;
    request.city = _city;
    request.page = searchPage;
    [_searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{

    [_searchResultArray removeAllObjects];
        // 刷新后TableView返回顶部
        [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:NO];
   
    // 刷新完成,没有数据时不显示footer
    if (response.pois.count != 0) {
  
        // 添加数据并刷新TableView
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            [_searchResultArray addObject:obj];
        }];
    }
    [self.searchTableView reloadData];
}



#pragma mark - PlaceAroundTableViewDelegate
- (void)loadMorePOI
{
    searchPage++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
}

- (void)setMapCenterWithPOI:(AMapPOI *)point isLocateImageShouldChange:(BOOL)isLocateImageShouldChange
{
    _isMapViewRegionChangedFromTableView = YES;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(point.location.latitude, point.location.longitude);
    [_mapView setCenterCoordinate:location animated:YES];
    
    if (isLocateImageShouldChange) {
   
       if(self.LoctionBlock)
       {
        self.LoctionBlock(point.location.latitude,point.location.longitude,point.name,point.address);
       }
 
        SetuserNowadress(point.name);
        Setuserdetialadress(point.address);
        
        [self clearMapView];
        
        [self clearSearch];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!_isMapViewRegionChangedFromTableView && isFirstLocated) {
        
        _searchAPI.delegate=_tableView;

        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];
        // 范围移动时当前页面数重置
        searchPage = 1;
        
        }
    _isMapViewRegionChangedFromTableView = NO;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"anntationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"msg_location"];
            annotationView.centerOffset = CGPointMake(0, -18);
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing = NO;
      
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

- (void)setCurrentCity:(NSString *)city
{

    _city=city;
    
}

- (void)setSendButtonEnabledAfterLoadFinished
{
  
}

#pragma mark-清除地图和搜索
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    AMapPOI *poi = [_searchResultArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:poi.name];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    //高亮
    NSRange textHighlightRange = [poi.name rangeOfString:_searchString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:textHighlightRange];
    cell.textLabel.attributedText = text;
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:poi.address];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, detailText.length)];
    [detailText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, detailText.length)];
    //高亮
    NSRange detailTextHighlightRange = [poi.address rangeOfString:_searchString];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:detailTextHighlightRange];
    cell.detailTextLabel.attributedText = detailText;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     _searchAPI.delegate=_tableView;

    [_searchTableView removeFromSuperview];
    
    isSearchModel=NO;
    
    self.searchTF.text=@"";
    [self.searchTF resignFirstResponder];
    
     [self setSelectedLocationWithLocation:_searchResultArray[indexPath.row]];

}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi
{
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude,poi.location.longitude) animated:NO];
    self.searchTF.text=@"";
}




- (void)clearSearch
{
    _searchAPI.delegate=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

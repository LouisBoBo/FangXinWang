//
//  DefaultTopLoadView.m
//  TYSlidePageScrollViewDemo
//
//  Created by 云商 on 15/9/9.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "DefaultTopLoadView.h"
#import "UIScrollView+MyRefresh.h"

//#define TFRefreshHeaderViewHeight 60

@interface DefaultTopLoadView()

@property (strong, nonatomic) UILabel *showLabel;
@property (strong, nonatomic) UILabel *showRefreshLabel;

@property (nonatomic, weak, readonly) UIImageView *arrowImage;
@property (nonatomic, weak, readonly) UIImageView *animationImgView; 
@property (nonatomic, weak, readonly) UIImageView *staticImgView;

@property (nonatomic, assign)CGFloat H_head;

@property (nonatomic, assign)int currTopRefreshStatus;

@end

@implementation DefaultTopLoadView
-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if(self){
//        [self addObserver:self forKeyPath:@"topRefreshStatus" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"topRefreshStatus" options:NSKeyValueObservingOptionNew context:nil];
        
        self.H_head = (int)(-(frame.size.height+frame.origin.y));
        
//        MyLog(@"H_head: %f", self.H_head);
        
        
//        //self.H_head = %d", (int)self.H_head);
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.font = [UIFont systemFontOfSize:12];
    self.showLabel.textColor = [UIColor colorWithRed:150/225.0 green:150/225.0 blue:150/225.0 alpha:1];
    self.showLabel.hidden = YES;
    [self addSubview:self.showLabel];

    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.showLabel.frame), 15, 40)];
    arrowImage.image = [UIImage imageNamed:@"arrow@2x.png"];
    arrowImage.center = CGPointMake(self.center.x, arrowImage.center.y);
    arrowImage.hidden = NO;
    [self addSubview:_arrowImage = arrowImage];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.showLabel.frame), 0, 25, 50)];
    
    imgView.center = CGPointMake(self.center.x, imgView.center.y);
//    imgView.backgroundColor = [UIColor blueColor];
    NSMutableArray *anArr = [NSMutableArray array];
    for (int i = 0 ; i<20; i++) {
//        NSString *gStr = [NSString stringWithFormat:@"TFRefresh%02d",i+1];
//        NSString *file = [[NSBundle mainBundle] pathForResource:gStr ofType:@"png"];
//        UIImage *image = [UIImage imageWithContentsOfFile:file];
//        [anArr addObject:image];
    }
    imgView.animationImages = anArr;
    imgView.animationDuration = 0.5;
    imgView.animationRepeatCount = 0;
    [self addSubview:_animationImgView = imgView];
    self.animationImgView.hidden = YES;

}

-(void)adjustStatusByTop:(float)y
{
    if(self.parentScrollView.isDragging && [self.parentScrollView.isLoosen boolValue] == YES){
        if(y<=-TFRefreshHeaderViewHeight-(int)(self.H_head)){
            if (_currTopRefreshStatus!=REFRESH_STATUS_BEFORE_REFRESH) {
                self.topRefreshStatus = REFRESH_STATUS_BEFORE_REFRESH;
                
            }
        } else{
            if (_currTopRefreshStatus!=REFRESH_STATUS_NORMAL) {
                self.topRefreshStatus = REFRESH_STATUS_NORMAL;
            }
        }
    } else if (self.parentScrollView.isDragging == NO&& [self.parentScrollView.isLoosen boolValue]== YES ) {
        if(y<=-TFRefreshHeaderViewHeight-(int)(self.H_head)){
            
            if (_currTopRefreshStatus!=REFRESH_STATUS_REFRESHING) {
                self.topRefreshStatus = REFRESH_STATUS_REFRESHING;
            }

        }
    }
    
    else if (self.parentScrollView.isDragging  == NO && [self.parentScrollView.isLoosen boolValue] == NO) {
        if(y<=-TFRefreshHeaderViewHeight-(int)(self.H_head)){
            if (_currTopRefreshStatus!=REFRESH_STATUS_BEFORE_REFRESH) {
                self.topRefreshStatus = REFRESH_STATUS_BEFORE_REFRESH;

            }
        } else{
            
            if (_currTopRefreshStatus!=REFRESH_STATUS_NORMAL) {
                self.topRefreshStatus = REFRESH_STATUS_NORMAL;
            }
            
        }
    } else if (self.parentScrollView.isDragging  == NO && [self.parentScrollView.isLoosen boolValue] == YES) {
        if(y<=-TFRefreshHeaderViewHeight-(int)(self.H_head)){
            if (_currTopRefreshStatus!=REFRESH_STATUS_REFRESHING) {
                self.topRefreshStatus = REFRESH_STATUS_REFRESHING;
            }
        }
    }
}

-(void)setTopRefreshStatus:(REFRESH_STATUS)topRefreshStatus{
    
//    //curr = %d, top = %d", _currTopRefreshStatus, topRefreshStatus);
    
    if(_topRefreshStatus == topRefreshStatus){
        return;
    }
    self.currTopRefreshStatus = topRefreshStatus;
//    MyLog(@"topRefreshStatus: %ld", (long)topRefreshStatus);
    
    switch (topRefreshStatus) {
        case REFRESH_STATUS_NORMAL:{
            [UIView animateWithDuration:0.5 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake((self.H_head), 0, self.parentScrollView.contentInset.bottom, 0);
                self.parentScrollView.scrollEnabled = YES;
                
            } completion:^(BOOL finished) {
                if (self.currTopRefreshStatus == REFRESH_STATUS_NORMAL) {
                    [self showNormal];
                }
                
            }];
            break;
        }
        case REFRESH_STATUS_BEFORE_REFRESH:
            [self showBeforeRefresh];
            break;
        case REFRESH_STATUS_REFRESHING:
        {
//            self.parentScrollView.isLoosen = [NSNumber numberWithBool:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(TFRefreshHeaderViewHeight+(int)(self.H_head), 0, self.parentScrollView.contentInset.bottom, 0);

                self.parentScrollView.scrollEnabled = NO;
                
            } completion:^(BOOL finished) {
                if (self.currTopRefreshStatus == REFRESH_STATUS_REFRESHING) {
                    [self showRefreshing];
                }
            }];
            [self showRefreshing];
            [self.actionTar performSelector:self.action withObject:nil afterDelay:0.0];
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        case REFRESH_STATUS_END_REFRESH: {
            [UIView animateWithDuration:0.5 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(TFRefreshHeaderViewHeight+(int)(self.H_head), 0, self.parentScrollView.contentInset.bottom, 0);
                self.parentScrollView.scrollEnabled = YES;
                
            }];
        }
            
        default:
            break;
    }
    _topRefreshStatus = topRefreshStatus;
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if([keyPath isEqualToString:@"topRefreshStatus"]){
//        //        //%@",change);
//        NSNumber *statusNum = (NSNumber *)[change objectForKey:@"new"];
//    }
//    //%@,%@,%@,%@",keyPath,object,change,context);
//}


-(void) showBeforeRefresh{
    
    self.showLabel.hidden = NO;
    self.staticImgView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    [self.showLabel setText:@"松手更新..."];
}

-(void) showNormal{
    self.arrowImage.hidden = NO;
    self.animationImgView.hidden = YES;
    self.showLabel.hidden = NO;
    
    [self.animationImgView stopAnimating];
    self.arrowImage.transform = CGAffineTransformMakeRotation(0);

    [self.showLabel setText:@"下拉刷新"];
}

-(void) showRefreshing{
    
    [self.showLabel setText:@"更新中..."];
    [self.animationImgView startAnimating];
    
    self.showLabel.hidden = YES;
    self.staticImgView.hidden = YES;
    self.arrowImage.hidden = YES;
    self.animationImgView.hidden = NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 } 
 */  

@end

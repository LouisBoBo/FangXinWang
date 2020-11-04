//
//  DefaultTopLoadView.h
//  TYSlidePageScrollViewDemo
//
//  Created by 云商 on 15/9/9.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopViewDelegate <NSObject>

-(void) showBeforeRefresh;

@end


typedef NS_ENUM(NSInteger, REFRESH_STATUS) {
    REFRESH_STATUS_NORMAL = 1,
    
    REFRESH_STATUS_BEFORE_REFRESH = 2,
    
    REFRESH_STATUS_REFRESHING = 3,
    
    REFRESH_STATUS_END_REFRESH = 4
};

@interface DefaultTopLoadView : UIView<TopViewDelegate>

@property (weak,nonatomic  ) id           actionTar;
@property (assign,nonatomic) SEL          action;
@property (nonatomic, copy) void (^beginRefreshingCallback)();
@property (assign,nonatomic) REFRESH_STATUS          topRefreshStatus;
@property (weak,nonatomic  ) UIScrollView *parentScrollView;

-(void)adjustStatusByTop:(float) y;

@end

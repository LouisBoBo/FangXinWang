//
//  AppDelegate.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/7.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


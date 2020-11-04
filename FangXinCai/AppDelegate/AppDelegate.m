//
//  AppDelegate.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/7.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JPush.h"
#import "RootNavigationController.h"
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    //检查更新
    [iVersion sharedInstance].applicationBundleID=AppBundleID;
    //    如果是强更设置这两句代码
    //    [iVersion sharedInstance].remindButtonLabel=@"";
    //    [iVersion sharedInstance].ignoreButtonLabel=@"";
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];//初始化 window
    
    [self initService];//初始化app服务
    
    [self ConfigueNetRequest];//初始化网络配置
    
    [self initUserManager];//初始化用户系统
    
    [self monitorNetworkStatus];//网络状态监听
    
    [self ConfigKeyBoard];//初始化键盘
    
    [AppManager appStart];//广告页
    
    [self setupJpush:launchOptions];//设置极光推送
    
    [self AMapServices];//配置高德地图
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
   
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FangXinCai"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

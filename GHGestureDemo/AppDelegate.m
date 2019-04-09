//
//  AppDelegate.m
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/1.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GHViewController.h"
#import "GHGestureDraggingViewController.h"
#import "GHGestureCropImagViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"wylgGGST0EmCvbi7rqG5QkIBkG8IWGlf"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK: BMK_COORDTYPE_COMMON];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
#ifdef DEVELOPMENT0
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
#elif DEVELOPMENT1
    GHViewController *vc = [[GHViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
#elif DEVELOPMENT2
    GHGestureDraggingViewController *vc = [[GHGestureDraggingViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
#elif DEVELOPMENT3
    GHGestureCropImagViewController *vc = [[GHGestureCropImagViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
#else
    
#endif
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

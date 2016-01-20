//
//  AppDelegate.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

   /*
    //信息展示界面
    DisplayViewController *dispVC = [[DisplayViewController alloc]init];
    UINavigationController *dispNC = [[UINavigationController alloc]initWithRootViewController:dispVC];
    
    //组团界面
    GroupActivityViewController *groupVC = [[GroupActivityViewController alloc]init];
    UINavigationController *groupNC = [[UINavigationController alloc]initWithRootViewController:groupVC];
    
    //行程记录
    TrackLoggingViewController *trackVC = [[TrackLoggingViewController alloc]init];
    UINavigationController *trackNC = [[UINavigationController alloc]initWithRootViewController:trackVC];
    
    //分享界面
    ShareViewController *shareVC = [[ShareViewController alloc]init];
    UINavigationController *shareNC = [[UINavigationController alloc]initWithRootViewController:shareVC];
    
    
    
    //好友界面
    FriendsViewController *friendsVC = [[FriendsViewController alloc]init];
    UINavigationController *friendsNC = [[UINavigationController alloc]initWithRootViewController:friendsVC];
    
    
    
    UITabBarController *tabBC = [[UITabBarController alloc]init];
    tabBC.viewControllers = @[dispNC,groupNC,trackNC,shareNC,friendsNC];
   // tabBC.viewControllers = @[dispVC,groupVC,trackVC,shareVC,friendsVC];
    tabBC.selectedIndex = 2;
    
    //    //tabBar字体选中颜色
    tabBC.tabBar.tintColor = [UIColor orangeColor];
    //    //tabBar颜色
    tabBC.tabBar.barTintColor = [UIColor greenColor];
    
    
    tabBC.tabBar.barStyle = UIBarStyleDefault;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:tabBC];
    */
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    UINavigationController *rootNC = [[UINavigationController alloc]initWithRootViewController:[MapViewController new]];
    [self.window setRootViewController:rootNC];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

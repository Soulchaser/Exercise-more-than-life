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
<<<<<<< HEAD
    
    
    //信息展示界面
    //    DisplayViewController *dispVC = [[DisplayViewController alloc]init];
    //    UINavigationController *dispNC = [[UINavigationController alloc]initWithRootViewController:dispVC];
    
    YDWMViewController *dispVC = [[YDWMViewController alloc]init];
=======

   
    //信息展示界面
    DisplayViewController *dispVC = [DisplayViewController shareDisplayViewController];
>>>>>>> 4cb81522133430929d3d89ec838cb923e019527f
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
    
    
    
<<<<<<< HEAD
    UITabBarController *tabBC = [[UITabBarController alloc]init];
    tabBC.viewControllers = @[dispNC,groupNC,trackNC,shareNC,friendsNC];
    // tabBC.viewControllers = @[dispVC,groupVC,trackVC,shareVC,friendsVC];
    tabBC.selectedIndex = 2;
=======
    self.tabBC = [[UITabBarController alloc]init];
    self.tabBC.viewControllers = @[dispNC,groupNC,trackNC,shareNC,friendsNC];
   // tabBC.viewControllers = @[dispVC,groupVC,trackVC,shareVC,friendsVC];
    self.tabBC.selectedIndex = 2;
>>>>>>> 4cb81522133430929d3d89ec838cb923e019527f
    
    //    //tabBar字体选中颜色
    self.tabBC.tabBar.tintColor = [UIColor orangeColor];
    //    //tabBar颜色
    self.tabBC.tabBar.barTintColor = [UIColor greenColor];
    
    
    self.tabBC.tabBar.barStyle = UIBarStyleDefault;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
<<<<<<< HEAD
    [self.window setRootViewController:tabBC];
    
    //    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    [self.window setBackgroundColor:[UIColor whiteColor]];
    //    [self.window makeKeyAndVisible];
    //    UINavigationController *rootNC = [[UINavigationController alloc]initWithRootViewController:[MapViewController new]];
    //    [self.window setRootViewController:rootNC];
    
=======
    [self.window setRootViewController:self.tabBC];
    /*
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    UINavigationController *rootNC = [[UINavigationController alloc]initWithRootViewController:[MapViewController new]];
    [self.window setRootViewController:rootNC];
     */
    
    //leancoud配置
    // applicationId 即 App Id，clientKey 是 App Key
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"NveC96jd47RocSo5OU0rjxwy-gzGzoHsz"
                      clientKey:@"cOsXhUabVYK7w4y8274uz9xK"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
>>>>>>> 4cb81522133430929d3d89ec838cb923e019527f
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

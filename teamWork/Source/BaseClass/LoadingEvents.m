//
//  LoadingEvents.m
//  HXLProject
//
//  Created by hanxiaolong on 16/1/7.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "LoadingEvents.h"

@interface LoadingEvents ()
@property(nonatomic,strong) UIActivityIndicatorView *activityIC;
@property(nonatomic,strong) UIView *aView;
@end

@implementation LoadingEvents
+(instancetype)shareLoadingEvents
{
    static LoadingEvents *le = nil;
    if (le == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            le = [[LoadingEvents alloc]init];
        });
    }
    return le;
}

-(void)dataBeginLoading:(UIViewController *)showViewController
{
    [self dataLoadSucceed:showViewController];
    
    //DLog(@"123456789")
    self.aView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 设置透明度
    self.aView.alpha = 0.5;
    // 颜色
    self.aView.backgroundColor = [UIColor blackColor];
    // 添加
     [[UIApplication sharedApplication].delegate.window addSubview:self.aView];
    //[showViewController.view addSubview:self.aView];
    // 创建一个citivityIC
    self.activityIC = [[UIActivityIndicatorView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 设置中心点
    self.activityIC.center = self.aView.center;
    // 添加到aView
    [self.aView addSubview:self.activityIC];
    // 开始动画
    [self.activityIC startAnimating];
    DLog(@"开始加载");
}

-(void)dataLoadFailed:(UIViewController *)showViewController
{
    // 停止动画
    [self.activityIC stopAnimating];
    // 移除aView
    [self.aView removeFromSuperview];
    
    
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力啊" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defulAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
    
    
    [alertCon addAction:defulAction];
    
    
    [showViewController presentViewController:alertCon animated:YES completion:nil];
}

-(void)dataLoadSucceed:(UIViewController *)showViewController
{
    // 停止动画
    [self.activityIC stopAnimating];
    // 移除aView
    [self.aView removeFromSuperview];
    

   // NSLog(@"加载出错");
    
}

@end

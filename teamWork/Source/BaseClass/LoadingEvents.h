//
//  LoadingEvents.h
//  HXLProject
//
//  Created by hanxiaolong on 16/1/7.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingEvents : NSObject
//数据加载中的动画
-(void)dataBeginLoading:(UIViewController *)showViewController;
//数据加载完成
-(void)dataLoadSucceed:(UIViewController *)showViewController;
//数据加载失败
-(void)dataLoadFailed:(UIViewController *)showViewController;

+(instancetype)shareLoadingEvents;


@end

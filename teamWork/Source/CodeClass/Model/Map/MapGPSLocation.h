//
//  MapGPSLocation.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDMulticastDelegate;
@class MovementInfo;
@protocol MapGPSLocationDelegate <NSObject>

@optional
//定位成功，代理执行的方法
-(void)GPSLocationSucceed:(MovementInfo *)movementInfo;

//方向更新后代理执行的方法
-(void)GPSUpdateHeading:(CLHeading * )heading;

//定位完成后返回给代理当前的城市的城市名
-(void)GPSGetCityName:(NSString *)cityName;

@end

@interface MapGPSLocation : NSObject<CLLocationManagerDelegate>

+(instancetype)shareMapGPSLocation;
//初始化GPS定位
-(void)setMapGPSLocationWithdistanceFilter:(CLLocationDistance)distanceFilter desiredAccuracy:(CLLocationAccuracy)desiredAccuracy;
//开始定位
-(void)mapGPSLocationStart;
//停止定位
-(void)mapGPSLocationStop;
//开始更新方向
-(void)mapGpsHeadingStop;
//停止更新方法
-(void)mapGpsHeadingStart;

//多播代理
@property(nonatomic)GCDMulticastDelegate<MapGPSLocationDelegate> *multiDelegate;

//添加多代理
-(void)addDelegateMapGPSLocation:(id<MapGPSLocationDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;

//运动状态信息
@property(strong,nonatomic)MovementInfo *movementInfo;

//@property(weak,nonatomic)id<MapGPSLocationDelegate>delegate;






@end

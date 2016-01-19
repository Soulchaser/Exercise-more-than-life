//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h
#import "DisplayViewController.h"
#import "GroupActivityViewController.h"
#import "TrackLoggingViewController.h"
#import "ShareViewController.h"
#import "FriendsViewController.h"
#import <MapKit/MapKit.h>
//地图控制器
#import "MapViewController.h"
//自制的带统计距离的大头针样式
#import "PointWithDistanceAnnView.h"
//自制的带统计距离的大头针类
#import "PointWithDistanceAnn.h"
//用户类
#import "YYUserModel.h"

//自制气泡
#import "DistanceCalloutView.h"

//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//打印
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
#endif

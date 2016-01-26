//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h

#import "YDWMViewController.h"

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
//地图界面用来显示运动信息的视图
#import "MapMoveInfoView.h"

#pragma mark ------------Model------------
//资讯类
#import "DogModel.h"
//用户类
#import "YYUserModel.h"

//自制气泡
#import "DistanceCalloutView.h"

//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark ------------YDD*资讯类头文件------------
#import "JianfeiTableViewController.h"
#import "NanxingTableViewController.h"
#import "WomenTableViewController.h"
#import "SecretTableViewController.h"

#pragma mark ------------重用标识符------------
//减肥瘦身-loseWight
static NSString * const LWID = @"JianfeiTableViewCellReuseIdentifier";
//男性健康-manHealth
static NSString * const MHID = @"NanxingTableViewCellReuseIdentifier";
//女性健康-womenHealth
static NSString * const WHID = @"WomenTableViewCellReuseIdentifier";
//私密生活-secretLife
static NSString * const SLID = @"SecretTableViewCellReuseIdentifier";

#pragma mark ------------GetDataTools*单例工具*------------
#import "YDGetDataTools.h"

//打印
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
#endif

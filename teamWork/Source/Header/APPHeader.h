//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h
//#import "DisplayViewController.h"
//YDD资讯跳转控制器
#import "YDWeatherViewController.h"
#import "YDWMViewController.h"
#import "GroupActivityViewController.h"
#import "TrackNaviController.h"
#import "TrackLoggingViewController.h"
#import "ShareViewController.h"
#import "FriendsViewController.h"
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
//地图用导航视图
//#import "MapNavigationViewController.h"
//自制的带统计距离的大头针样式
#import "PointWithDistanceAnnView.h"
//自制的带统计距离的大头针类
#import "PointWithDistanceAnn.h"
//地图界面用来显示运动信息的视图
#import "MapMoveInfoView.h"
//GPS定位类
#import "MapGPSLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>
//运动数据记录类
#import "MovementInfo.h"
#import "SportInfoView.h"
#import "TrackwayTableViewCell.h"
#import "TrackwayTableViewController.h"
#import "MapwayDetailsViewController.h"

//自定义的地图视图
#import "MapView.h"
#import "PinyinChange.h"

#pragma mark --------CoreData-------
#import <CoreData/CoreData.h>
#import "XLCodeDataTools.h"
#import "Entity+CoreDataProperties.h"
#import "Entity.h"
#import "CordDataInfo.h"
#pragma mark ------------Model------------
//资讯类
#import "DogModel.h"
//资讯类详情
#import "DetailModel.h"

#import "YDWeatherModel.h"
//用户类
#import "YYUserModel.h"


//Leancoud用户工具类
#import "LeancoudTools.h"
//button类目,添加一个方法使button点击后显示倒计时(n秒内无法再次点击)
#import "UIButton+CountDown.h"
//UITableView和UITableViewCell类目,在xib情况下自适应高度
#import "UITableView+FDTemplateLayoutCell.h"
//图像获取方式(相机或相册)
#import "AvatarsourceType.h"
//登陆界面
#import "LoginViewController.h"
//我的分享
#import "UserAllShareTableViewController.h"
#import "FootPrintTableViewController.h"
//关注的人
#import "UserAllAttentionTVC.h"
//关注列表
#import "UserAttentionCell.h"
//关注详情页
#import "AttentionDetailVC.h"
//好友界面
#import "Friend.h"
//自制气泡
#import "DistanceCalloutView.h"

#import "UserViewController.h"
#pragma mark ------------YDD宏------------
#define kGD [YDGetDataTools sharedGetData]
#define errorString @"请检查您键入的拼音是否正确..."
//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark ------------YDD*资讯类头文件------------
#import "JianfeiTableViewController.h"
#import "NanxingTableViewController.h"
#import "WomenTableViewController.h"
#import "SecretTableViewController.h"
#import "DetailViewController.h"
#import "AddTableViewController.h"
#import "SettingViewController.h"
#import "CreatActivityViewController_1.h"
#pragma mark ------------发现活动------------
#import "YDDCarouseFigureView.h"
#import "GroupActibityCell.h"
#import "ActivityDetailViewController.h"

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

//
//  MapView.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/23.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapView : UIView

//地图视图
@property(strong,nonatomic)MAMapView *mapView;
//信息提示label
@property(strong,nonatomic)UILabel *promptLabel;
//用来显示运动信息的视图
@property(strong,nonatomic)MapMoveInfoView *moveInfoView;
 //地图样式切换button
@property(strong,nonatomic)UIButton *mapTypeButton;
//获取位置的高度
@property(strong,nonatomic)UIButton *mapAltitudeButton;
//获取位置的距离
@property(strong,nonatomic)UIButton *mapDistanceButton;
 //地图放大Button
@property(strong,nonatomic)UIButton *mapZoomInButton;
//地图缩小Button
@property(strong,nonatomic)UIButton *mapZoomOutButton;
//地图导航模式Button
@property(strong,nonatomic)UIButton *mapDirectionButton;
//用于向左滑动的view
@property(strong,nonatomic)UIView *leftView;
//路书button
@property(strong,nonatomic)UIButton *loadBookButton;
//分享Button
@property(strong,nonatomic)UIButton *shareButton;
//路书Button
@property(strong,nonatomic)UIButton *mapBookButton;






@end

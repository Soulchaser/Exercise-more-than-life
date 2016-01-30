//
//  MapView.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/23.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapView.h"
#define kFloatButtonWidth ([UIScreen mainScreen].bounds.size.width/10.0)
@implementation MapView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawView];
    }
    return self;
}

-(void)drawView
{
    
    //self.backgroundColor = [UIColor colorWithRed:38.0 green:38.0 blue:38.0 alpha:1];
    CGFloat red = 38 /255.0;
    CGFloat blue = 38 /255.0;
    CGFloat green = 38 /255.0;
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    //设置地图视图
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-64)];

    //地图类型，默认为普通类型
    self.mapView.mapType = MAMapTypeStandard;
    //设置比例尺位置
    self.mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, [UIScreen mainScreen].bounds.size.height-22);
    //设置高德地图LOGO位置
    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.bounds)-55, CGRectGetHeight(self.bounds)-22);

    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5, 30,24, 24)];
    [self.shareButton setImage:[UIImage imageNamed:@"mapShare"] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor whiteColor];
    
    self.mapBookButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.shareButton.frame)-44, 30,24, 24)];
    [self.mapBookButton setImage:[UIImage imageNamed:@"mapBook"] forState:UIControlStateNormal];
    self.mapBookButton.backgroundColor = [UIColor whiteColor];
    
    //提示信息Label
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kFloatButtonWidth*3, kFloatButtonWidth)];
    self.promptLabel.center = CGPointMake(kScreenWidth/2, [UIScreen mainScreen].bounds.size.height*0.8);
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.layer.borderWidth = 20;
    self.promptLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.promptLabel.backgroundColor = [UIColor blackColor];
    self.promptLabel.textColor = [UIColor whiteColor];
    
    //地图样式切换button
    self.mapTypeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5,kScreenHeight*0.1 , kFloatButtonWidth, kFloatButtonWidth)];
    self.mapTypeButton.backgroundColor = [UIColor whiteColor];
    [self.mapTypeButton setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];

    //获取位置的高度
    self.mapAltitudeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5,kScreenHeight*0.2 , kFloatButtonWidth, kFloatButtonWidth)];

    self.mapAltitudeButton.backgroundColor = [UIColor whiteColor];
    [self.mapAltitudeButton setImage:[UIImage imageNamed:@"altitude"] forState:UIControlStateNormal];

    //获取位置的距离
    self.mapDistanceButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5,kScreenHeight*0.3 , kFloatButtonWidth, kFloatButtonWidth)];
    self.mapDistanceButton.backgroundColor = [UIColor whiteColor];
    [self.mapDistanceButton setImage:[UIImage imageNamed:@"distance"] forState:UIControlStateNormal];

    //地图放大Button
    self.mapZoomInButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5, kScreenHeight*0.7, kFloatButtonWidth, kFloatButtonWidth)];
    [self.mapZoomInButton setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [self.mapZoomInButton setImage:[UIImage imageNamed:@"jia_selected"] forState:UIControlStateHighlighted];
 
    //地图缩小Button
    self.mapZoomOutButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5, kScreenHeight*0.7+kFloatButtonWidth, kFloatButtonWidth, kFloatButtonWidth)];
    [self.mapZoomOutButton setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [self.mapZoomOutButton setImage:[UIImage imageNamed:@"jian_selected"] forState:UIControlStateHighlighted];
 
    //定位模式
    self.mapDirectionButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWidth*1.5,kScreenHeight*0.5 , kFloatButtonWidth, kFloatButtonWidth)];
    self.mapDirectionButton.backgroundColor = [UIColor whiteColor];
    [self.mapDirectionButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    
    //运动信息显示视图
    self.moveInfoView = [[MapMoveInfoView alloc]initWithFrame:CGRectMake(kFloatButtonWidth*0.5,kScreenHeight*0.01 , kScreenWidth-kFloatButtonWidth, kFloatButtonWidth*1.5)];
    
    //左滑视图
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, kScreenHeight)];
    
    //拖拽提示视图
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuodong"]];
    tipView.frame =  CGRectMake(0, kScreenHeight/3, 20, 64);
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.alpha = 0.9;
    //tipView.center = CGPointMake(0, kScreenHeight/2);
    [self.leftView addSubview:tipView];
    
    
    [self addSubview:self.shareButton];
    [self addSubview:self.mapBookButton];
    [self.mapView addSubview:self.leftView];
    [self.mapView addSubview:self.mapDirectionButton];
    [self.mapView addSubview:self.moveInfoView];
    [self.mapView addSubview:self.mapZoomOutButton];
    [self.mapView addSubview:self.mapZoomInButton];
    [self.mapView addSubview:self.mapTypeButton];
    [self.mapView addSubview:self.mapAltitudeButton];
    [self.mapView addSubview:self.mapDistanceButton];
    //添加提示信息Label
    //[self.mapView addSubview:self.promptLabel];
    //先把提示label藏起来
    //[self.mapView sendSubviewToBack:self.promptLabel];
    
    [self addSubview:self.mapView];
}




@end

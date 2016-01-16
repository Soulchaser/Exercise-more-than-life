//
//  MapViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapViewController.h"
#define kFloatButtonWihth ([UIScreen mainScreen].bounds.size.width/10.0)
@interface MapViewController ()<MAMapViewDelegate>
//地图视图
@property(strong,nonatomic)MAMapView *mapView;
//信息提示label
@property(strong,nonatomic)UILabel *promptLabel;
//地图的缩放级别，范围是[3-19]
@property(assign,nonatomic)CGFloat zoomLevel;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置高德地图的APIKEY
    [MAMapServices sharedServices].apiKey = KamapKey;
    
    
   
    [self drawView];
    //设置初始的地图缩放级别
    self.zoomLevel = self.mapView.zoomLevel;
    //YES 为打开定位，NO为关闭定位
    self.mapView.showsUserLocation = YES;

}
//绘制界面
-(void)drawView
{
    //提示信息Label
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kFloatButtonWihth*3, kFloatButtonWihth)];
    self.promptLabel.center = CGPointMake(kScreenWidth/2, [UIScreen mainScreen].bounds.size.height*0.8);
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.layer.borderWidth = 40;
    self.promptLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.promptLabel.backgroundColor = [UIColor blackColor];
    self.promptLabel.textColor = [UIColor whiteColor];
    
    
    
    
    //设置地图视图
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    //设置代理
    self.mapView.delegate = self;
    //地图类型，默认为普通类型
    self.mapView.mapType = MAMapTypeStandard;
    //设置比例尺位置
    self.mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, [UIScreen mainScreen].bounds.size.height-22);
    //设置高德地图LOGO位置
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, CGRectGetHeight(self.view.bounds)-22);
    [self.view addSubview:self.mapView];
    
    
    
    //地图样式切换button
    UIButton *mapTypeButtpn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5,kScreenHeight*0.2 , kFloatButtonWihth, kFloatButtonWihth)];
    [mapTypeButtpn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapTypeButtpn.backgroundColor = [UIColor whiteColor];
    [mapTypeButtpn setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];
    //tag
    mapTypeButtpn.tag = 1001;
    //地图缩小Button
    UIButton *mapZoomOutButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5, kScreenHeight*0.8+kFloatButtonWihth, kFloatButtonWihth, kFloatButtonWihth)];
    [mapZoomOutButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapZoomOutButton.backgroundColor = [UIColor whiteColor];
    [mapZoomOutButton setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [mapZoomOutButton setImage:[UIImage imageNamed:@"jian_selected"] forState:UIControlStateHighlighted];
    //tag
    mapZoomOutButton.tag = 1003;
    //地图放大Button
    UIButton *mapZoomInButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5, kScreenHeight*0.8, kFloatButtonWihth, kFloatButtonWihth)];
    [mapZoomInButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapZoomInButton.backgroundColor = [UIColor whiteColor];
    [mapZoomInButton setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [mapZoomInButton setImage:[UIImage imageNamed:@"jia_selected"] forState:UIControlStateHighlighted];
    //tag
    mapZoomInButton.tag = 1002;
    
    
    [self.mapView addSubview:mapZoomOutButton];
    [self.mapView addSubview:mapZoomInButton];
    [self.mapView addSubview:mapTypeButtpn];
    //添加提示信息Label
    [self.mapView addSubview:self.promptLabel];
    //先把提示label藏起来
    [self.mapView sendSubviewToBack:self.promptLabel];
}

//浮窗button点击事件
-(void)buttonAction:(UIButton *)sender
{
    
    
    switch (sender.tag)
    {
            //切换地图模式
        case 1001:
            //如果是卫星地图模式，就切换到普通地图模式
            if (self.mapView.mapType == MAMapTypeSatellite)
            {
                [sender setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];
                self.mapView.mapType = MAMapTypeStandard;
            }
            //如果是普通地图模式，就切换到卫星地图模式
            else
            {
                [sender setImage:[UIImage imageNamed:@"weixing_selected"] forState:UIControlStateNormal];
                self.mapView.mapType = MAMapTypeSatellite;
                self.promptLabel.alpha = 1;
                self.promptLabel.text = @"卫星模式";
                [self.mapView bringSubviewToFront:self.promptLabel];
                //开始动画,动画效果为label逐渐消失
                [UIView beginAnimations:@"prompt" context:NULL];
                //设置动画间隔
                [UIView setAnimationDuration:0.2];
                //提交动画
                [UIView commitAnimations];
                //用2秒内完成animation内的操作,透明度设为0
                [UIView animateWithDuration:2 animations:^{
                    self.promptLabel.alpha= 0;
                }];
                
            }
            break;
            //地图放大
        case 1002:
            if (self.zoomLevel <= 18)
            {
                self.zoomLevel += 1;
            }
            else
            {
                self.zoomLevel = 19;
            }
            [self.mapView setZoomLevel:self.zoomLevel animated:YES];
            break;
        case 1003:
            if (self.zoomLevel >= 4)
            {
                self.zoomLevel -= 1;
            }
            else
            {
                self.zoomLevel = 3;
            }
            [self.mapView setZoomLevel:self.zoomLevel animated:YES];
            break;
            
        default:
            break;
    }
}

#define mark -------地图的代理事件-------
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        DLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

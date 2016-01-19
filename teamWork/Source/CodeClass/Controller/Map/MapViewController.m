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
//是否开启高度测量
@property(assign,nonatomic)BOOL altitudeFlag;
//是否开启测量距离
@property(assign,nonatomic)BOOL distanceFlag;
//用来存放测距模式下的ann
@property(strong,nonatomic)NSMutableArray *distanceAnnArray;
//用来存放测距状态在两点之间覆盖物（连线）
@property(strong,nonatomic)NSMutableArray *distancePolylineArray;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置高德地图的APIKEY
    [MAMapServices sharedServices].apiKey = KamapKey;
    //默认不开启高度测量
    self.altitudeFlag = NO;
   //默认不开启测距模式
    self.distanceFlag = NO;
    [self drawView];
    //设置初始的地图缩放级别
    self.zoomLevel = self.mapView.zoomLevel;
    //YES 为打开定位，NO为关闭定位
    self.mapView.showsUserLocation = YES;
    //追踪用户的location与heading更新
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //后台持续定位的能力
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    
    self.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    
}
//绘制界面
-(void)drawView
{
    //提示信息Label
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kFloatButtonWihth*3, kFloatButtonWihth)];
    self.promptLabel.center = CGPointMake(kScreenWidth/2, [UIScreen mainScreen].bounds.size.height*0.8);
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.layer.borderWidth = 20;
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
    UIButton *mapTypeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5,kScreenHeight*0.2 , kFloatButtonWihth, kFloatButtonWihth)];
    [mapTypeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapTypeButton.backgroundColor = [UIColor whiteColor];
    [mapTypeButton setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];
    //tag
    mapTypeButton.tag = 1001;
 
    //获取位置的高度
    UIButton *mapAltitudeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5,kScreenHeight*0.3 , kFloatButtonWihth, kFloatButtonWihth)];
    [mapAltitudeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapAltitudeButton.backgroundColor = [UIColor whiteColor];
    [mapAltitudeButton setImage:[UIImage imageNamed:@"altitude"] forState:UIControlStateNormal];

    //tag
    mapAltitudeButton.tag = 1002;
  
    //获取位置的距离
    UIButton *mapDistanceButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5,kScreenHeight*0.4 , kFloatButtonWihth, kFloatButtonWihth)];
    [mapDistanceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapDistanceButton.backgroundColor = [UIColor whiteColor];
    [mapDistanceButton setImage:[UIImage imageNamed:@"distance"] forState:UIControlStateNormal];
    
    //tag
    mapDistanceButton.tag = 1003;
    
    //地图放大Button
    UIButton *mapZoomInButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5, kScreenHeight*0.8, kFloatButtonWihth, kFloatButtonWihth)];
    [mapZoomInButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
   // mapZoomInButton.backgroundColor = [UIColor whiteColor];
    [mapZoomInButton setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [mapZoomInButton setImage:[UIImage imageNamed:@"jia_selected"] forState:UIControlStateHighlighted];
    //tag
    mapZoomInButton.tag = 1004;
    
    //地图缩小Button
    UIButton *mapZoomOutButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kFloatButtonWihth*1.5, kScreenHeight*0.8+kFloatButtonWihth, kFloatButtonWihth, kFloatButtonWihth)];
    [mapZoomOutButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
  //  mapZoomOutButton.backgroundColor = [UIColor whiteColor];
    [mapZoomOutButton setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [mapZoomOutButton setImage:[UIImage imageNamed:@"jian_selected"] forState:UIControlStateHighlighted];
    //tag
    mapZoomOutButton.tag = 1005;

    
    
    [self.mapView addSubview:mapZoomOutButton];
    [self.mapView addSubview:mapZoomInButton];
    [self.mapView addSubview:mapTypeButton];
    [self.mapView addSubview:mapAltitudeButton];
    [self.mapView addSubview:mapDistanceButton];
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
                //一个逐渐消失的提示信息
                [self AnimationOfDisappearing:@"卫星模式"];
                
            }
            break;
            //测量海拔
        case 1002:
            if (self.altitudeFlag == NO)
            {
                [sender setImage:[UIImage imageNamed:@"altitude_selected"] forState:UIControlStateNormal];
                self.altitudeFlag = YES;
                 [self AnimationOfDisappearing:@"测量高度"];
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"altitude"] forState:UIControlStateNormal];
                self.altitudeFlag = NO;
            }
            break;
        case 1003:
            if (self.distanceFlag == NO)
            {
                [sender setImage:[UIImage imageNamed:@"distance_selected"] forState:UIControlStateNormal];
                self.distanceFlag = YES;
                [self AnimationOfDisappearing:@"测距模式"];
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"distance"] forState:UIControlStateNormal];
                self.distanceFlag = NO;
                [self.mapView removeAnnotations:self.distanceAnnArray];
                [self.distanceAnnArray removeAllObjects];
                [self.mapView removeOverlays:self.distancePolylineArray];
            }
        
            break;
            //地图放大
        case 1004:
            //最大是19，所以当前值只要比18小就可再加一
            if (self.zoomLevel <= 18)
            {
                self.zoomLevel += 1;
            }
            //
            else
            {
                self.zoomLevel = 19;
            }
            //设置地图缩放率
            [self.mapView setZoomLevel:self.zoomLevel animated:YES];
            break;
        case 1005:
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

#pragma mark -------屏幕点击事件--------

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.distanceFlag == YES)
    {
        // 创建一个大头针对象
        PointWithDistanceAnn * ann = [PointWithDistanceAnn alloc];
        
        ann.coordinate = coordinate;
        CLLocationDistance distance = 0;
        //判断是不是出发点,如果不是则计算与上一个点的距离，是的话就显示出发点
        if (self.distanceAnnArray.count != 0)
        {
            PointWithDistanceAnn *ann2 = (PointWithDistanceAnn *)self.distanceAnnArray.lastObject;
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(ann.coordinate);
            MAMapPoint point2 = MAMapPointForCoordinate(ann2.coordinate);
            //2.计算距离
            distance = MAMetersBetweenMapPoints(point1,point2);
            ann.pointDistance = distance + ann2.pointDistance;
            if (ann.pointDistance >=10000)
            {
                ann.distanceStr = [NSString stringWithFormat:@"%.1fkm",ann.pointDistance/1000];
                
            }
            else
             ann.distanceStr = [NSString stringWithFormat:@"%.fm",ann.pointDistance];
            //构造折线数据对象
            CLLocationCoordinate2D commonPolylineCoords[2];
            commonPolylineCoords[0].latitude = ann2.coordinate.latitude;
            commonPolylineCoords[0].longitude = ann2.coordinate.longitude;
            
            commonPolylineCoords[1].latitude = ann.coordinate.latitude;
            commonPolylineCoords[1].longitude = ann.coordinate.longitude;
            //构造折线对象
            MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
            //存入数组中
            [self.distancePolylineArray addObject:commonPolyline];
            //在地图上添加折线对象
            [self.mapView addOverlay: commonPolyline];
        }
        else
            ann.distanceStr = @"出发点";
        
        
        [self.distanceAnnArray addObject:ann];
        
        // 添加大头针的方法
        [self.mapView addAnnotation:ann];
    }
}


#pragma mark -------地图的代理事件-------
//定位成功后执行的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
      //  DLog(@"%f",userLocation.location.altitude);
        //取出当前位置的坐标
     //   DLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
//添加大头针
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
         view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = YES;
    }
    
    
    
}
//定义大头针
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /*if ([annotation isKindOfClass:[AltitudeAnnotation class]])
    {
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ann"];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
        }
        // 设置气泡左view
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:(UIButtonTypeContactAdd)];
        
        // 显示气泡
        annotationView.canShowCallout = YES;
         return annotationView;
    }*/
    //测距模式的大头针
    if ([annotation isKindOfClass:[PointWithDistanceAnn class]])
    {
        //自制的测距用大头针对象
        PointWithDistanceAnn *ann = (PointWithDistanceAnn *)annotation;
        
        //自制测距用大头针视图
        PointWithDistanceAnnView *annotationView = (PointWithDistanceAnnView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ann"];
        if (annotationView == nil) {
            annotationView = [[PointWithDistanceAnnView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
        }
            
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //气泡的偏移量，向下偏移10
        annotationView.calloutOffset = CGPointMake(0, 10);
        //显示信息赋值
        annotationView.distanceStr = ann.distanceStr;
        
        //设置大头针的样式（图片）
        annotationView.image = [UIImage imageNamed:@"point"];
        
        return annotationView;
    }
    return nil;
}

//两点间的连线方法
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        //线宽
        polylineView.lineWidth = 5.f;
        //线的颜色
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        //polylineView.lineJoinType = kMALineJoinRound;//连接类型
        //polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}






//提示信息从屏幕上逐渐消失的动画
-(void)AnimationOfDisappearing:(NSString *)str
{
    self.promptLabel.alpha = 1;
    self.promptLabel.text = str;
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




//懒加载，初始化使用
-(NSMutableArray *)distanceAnnArray
{
    if (_distanceAnnArray == nil)
    {
        _distanceAnnArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _distanceAnnArray;
}
-(NSMutableArray *)distancePolylineArray
{
    if (_distancePolylineArray == nil)
    {
        _distancePolylineArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _distancePolylineArray;
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

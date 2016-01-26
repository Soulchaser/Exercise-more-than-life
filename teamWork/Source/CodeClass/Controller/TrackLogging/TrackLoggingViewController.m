//
//  TrackLoggingViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "TrackLoggingViewController.h"

#define kFloatButtonWidth ([UIScreen mainScreen].bounds.size.width/10.0)
@interface TrackLoggingViewController ()<UIScrollViewDelegate,MapGPSLocationDelegate,MAMapViewDelegate>

@property(strong,nonatomic)MapView *mapView;
//信息提示label
//@property(strong,nonatomic)UILabel *promptLabel;
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
//定位大头针图片
@property(strong,nonatomic)UIImageView *annImgView;
//当前的用户的跟踪方式
@property(nonatomic)MAUserTrackingMode currentTrackigMode;
//运动计时用timer
@property(strong,nonatomic)NSTimer *moveTimer;
//
@property(assign,nonatomic)NSInteger timeCount;
//
@property(strong,nonatomic)UIScrollView *scrollView;
//导航栏左按钮点击弹出view
@property(strong,nonatomic)BFNavigationBarDrawer *drawer;
//drawer是否弹出
@property(assign,nonatomic)BOOL drawerFlag;
//运动方式
@property(assign,nonatomic)SportModel sportModel;
//运动信息显示界面
@property(strong,nonatomic)SportInfoView *sportInfoView;
//开始运动按钮
@property(strong,nonatomic)UIButton *startButton;
//暂停按钮
@property(strong,nonatomic)UIButton *continueButton;
//停止运动按钮
@property(strong,nonatomic)UIButton *stopButton;
@end

@implementation TrackLoggingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟你走" image:[UIImage imageNamed:@"daohang"] selectedImage:[UIImage imageNamed:@"daohang_selected"]];
        //导航栏左按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ride_selected"] style:UIBarButtonItemStyleDone target:self action:@selector(sportModelChangAction:)];
        //初始运动模式
        self.sportModel = rideModel;
        
        //导航栏左按钮点击弹出view设置
        //视图是否弹出
        self.drawerFlag = NO;
        //弹出视图初始化
        self.drawer = [[BFNavigationBarDrawer alloc]init];
        //三个按钮
        UIBarButtonItem *walkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"walk"] style:UIBarButtonItemStyleDone target:self action:@selector(sportmodelSelectAction:)];
        walkButton.tag = 1101;
        
        UIBarButtonItem *runButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"run"] style:UIBarButtonItemStyleDone target:self action:@selector(sportmodelSelectAction:)];
        runButton.tag = 1102;
        
        UIBarButtonItem *rideButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ride"] style:UIBarButtonItemStyleDone target:self action:@selector(sportmodelSelectAction:)];
        rideButton.tag = 1103;
        
        //加到弹出视图上
        self.drawer.items = @[walkButton, runButton, rideButton];
        
        //设置高德地图的APIKEY
        [MAMapServices sharedServices].apiKey = KamapKey;
    }
    return self;
}
#pragma mark ---导航栏左按钮点击事件-----
-(void)sportModelChangAction:(UIBarButtonItem *)sender
{
    
    if (self.drawerFlag == NO)
    {
        self.drawer.items[0].image = [UIImage imageNamed:@"walk_selected"];
        self.drawer.items[1].image = [UIImage imageNamed:@"run_selected"];
        self.drawer.items[2].image = [UIImage imageNamed:@"ride_selected"];
        //弹出视图
      [self.drawer showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        self.drawerFlag = YES;
        switch (self.sportModel)
        {
            case walkModel:
                self.drawer.items[0].image = [UIImage imageNamed:@"walk_selected"];
                break;
            case runModel:
                self.drawer.items[1].image = [UIImage imageNamed:@"run_selected"];
                break;
            case rideModel:
                self.drawer.items[2].image = [UIImage imageNamed:@"ride_selected"];
                break;
            default:
                break;
        }
    }
    else
    {
        //隐藏视图
        [self.drawer hideAnimated:YES];
        self.drawerFlag = NO;
    }

}
#pragma mark ---弹出视图，更改运动模式方法-----
-(void)sportmodelSelectAction:(UIBarButtonItem *)sender
{
    
    switch (sender.tag)
    {
        case 1101:
            self.sportModel = walkModel;
            break;
        case 1102:
            self.sportModel = runModel;
            break;
        case 1103:
            self.sportModel = rideModel;
            break;
        default:
            break;
    }
    self.navigationItem.leftBarButtonItem.image = sender.image;
    
    [self.drawer hideAnimated:YES];
    self.drawerFlag = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"跟你走";
    //字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self drawView];
    //成为MapGPSLocation的代理
    [[MapGPSLocation shareMapGPSLocation] addDelegateMapGPSLocation:self delegateQueue:dispatch_get_main_queue()];
    
    if ([self performSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    //默认不开启高度测量
    self.altitudeFlag = NO;
    //默认不开启测距模式
    self.distanceFlag = NO;
    [self drawView];
    //设置高德地图代理
    self.mapView.mapView.delegate = self;
    
    //YES 为打开定位，NO为关闭定位
    self.mapView.mapView.showsUserLocation = YES;
    //
    [self.mapView.mapView setZoomLevel:15 animated:YES];
    
    //指南针是否显示，no为不显示
    //self.mapView.showsCompass= NO;
    //设置指南针位置
    self.mapView.mapView.compassOrigin= CGPointMake(kFloatButtonWidth*0.5,kScreenHeight*0.15);
    //追踪用户的location
    self.mapView.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.currentTrackigMode = MAUserTrackingModeFollow;
    //是否关闭后台持续定位的能力
    self.mapView.mapView.pausesLocationUpdatesAutomatically = NO;
    
    self.mapView.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配
    
    self.annImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
    
    [[MapGPSLocation shareMapGPSLocation] mapGpsHeadingStart];
    // Do any additional setup after loading the view.
}

-(void)drawView
{
    //地图视图
    self.mapView = [[MapView alloc]initWithFrame:CGRectMake(kScreenWidth, 0,  kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].delegate.window addSubview:self.mapView];
    
    //滑动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.7)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight*0.7);
    //整页滑动
    self.scrollView.pagingEnabled = YES;
    
    //是否显示竖直方向滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //是否显示水平方向滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.bounces = NO;
    
    self.scrollView.delegate = self;
    
    self.scrollView.tag = 1100;
    
    //第一页
    self.sportInfoView = [[SportInfoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.7)];
    [self.scrollView addSubview:self.sportInfoView];
    
    
    //第二页
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 50, kScreenHeight*0.7)];
    blueView.backgroundColor = [UIColor whiteColor];
    blueView.alpha = 0;
    //[self.scrollView addSubview:redView];
    [self.scrollView addSubview:blueView];
    [self.view addSubview:self.scrollView];
    
    
    self.startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.7, kScreenWidth/2, kScreenHeight*0.1)];
    [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor blueColor];
    [self.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.continueButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight*0.7, kScreenWidth/2, kScreenHeight*0.1)];
    [self.continueButton setTitle:@"继续" forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor blackColor];
    [self.continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.stopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.7, kScreenWidth, kScreenHeight*0.1)];
    [self.stopButton setTitle:@"停止" forState:UIControlStateNormal];
    self.stopButton.backgroundColor = [UIColor redColor];
    [self.stopButton addTarget:self action:@selector(stopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.continueButton];

    self.mapView.mapTypeButton.tag = 1001;
    self.mapView.mapAltitudeButton.tag = 1002;
    self.mapView.mapDistanceButton.tag = 1003;
    self.mapView.mapZoomInButton.tag = 1004;
    self.mapView.mapZoomOutButton.tag = 1005;
    self.mapView.mapDirectionButton.tag = 1006;
    
    
    [self.mapView.mapTypeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapAltitudeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapDistanceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapZoomInButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapZoomOutButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapDirectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.mapView.leftView addGestureRecognizer:pan];
    
    
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark -------运动开始和结束按钮事件-------

-(void)startButtonAction:(UIButton *)sender
{
    
    //初始化GPS定位对象
    [[MapGPSLocation shareMapGPSLocation] setMapGPSLocationWithdistanceFilter:3 desiredAccuracy:kCLLocationAccuracyBest];
    //开始GPS定位
    [[MapGPSLocation shareMapGPSLocation] mapGPSLocationStart];
    [self beginTiming];
    [self.view addSubview:self.stopButton];

}

-(void)continueButtonAction:(UIButton *)sender
{
    
}

-(void)stopButtonAction:(UIButton *)sender
{
    //结束GPS定位
    [[MapGPSLocation shareMapGPSLocation] mapGPSLocationStop];
    [self endTiming];
    [self.stopButton removeFromSuperview];

}

#pragma mark -------界面滑动事件--------
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.mapView];
    //获取手势操作点
    CGPoint point = [pan translationInView:pan.view];
    
    self.scrollView.contentOffset = CGPointMake(kScreenWidth-point.x, 0);
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat magnitude = 0;
        CGFloat slideMult = 0;
        if (self.scrollView.contentOffset.x>kScreenWidth/2)
        {
            magnitude = kScreenWidth - self.scrollView.contentOffset.x;
            slideMult = magnitude / 200;
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //pan.view.center = finalPoint;
                self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
                
            } completion:nil];
            
        }
        else
        {
            magnitude = self.scrollView.contentOffset.x;
            slideMult = magnitude / 200;
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //pan.view.center = finalPoint;
                self.scrollView.contentOffset = CGPointMake(0, 0);
            } completion:nil];
        }
      //  NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        

    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.mapView.frame = CGRectMake(kScreenWidth-scrollView.contentOffset.x, 0, kScreenWidth, kScreenHeight);
}

//浮窗button点击事件
#pragma mark -------浮窗button点击事件--------
-(void)buttonAction:(UIButton *)sender
{
    
    
    switch (sender.tag)
    {
            //切换地图模式
        case 1001:
            
            //如果是卫星地图模式，就切换到普通地图模式
            if (self.mapView.mapView.mapType == MAMapTypeSatellite)
            {
                [sender setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];
                self.mapView.mapView.mapType = MAMapTypeStandard;
            }
            //如果是普通地图模式，就切换到卫星地图模式
            else
            {
                [sender setImage:[UIImage imageNamed:@"weixing_selected"] forState:UIControlStateNormal];
                self.mapView.mapView.mapType = MAMapTypeSatellite;
                //一个逐渐消失的提示信息
                [self AnimationOfDisappearing:@"卫星模式"];
                
            }
            self.mapView.mapView.userTrackingMode = self.currentTrackigMode;
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
                [self.mapView.mapView removeAnnotations:self.distanceAnnArray];
                [self.distanceAnnArray removeAllObjects];
                [self.mapView.mapView removeOverlays:self.distancePolylineArray];
            }
            
            break;
            //地图放大
        case 1004:
            self.zoomLevel = self.mapView.mapView.zoomLevel;
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
            [self.mapView.mapView setZoomLevel:self.zoomLevel animated:YES];
            self.mapView.mapView.zoomLevel = self.zoomLevel;
            break;
        case 1005:
            self.zoomLevel = self.mapView.mapView.zoomLevel;
            if (self.zoomLevel >= 4)
            {
                self.zoomLevel -= 1;
            }
            else
            {
                self.zoomLevel = 3;
            }
            [self.mapView.mapView setZoomLevel:self.zoomLevel animated:YES];
            self.mapView.mapView.zoomLevel = self.zoomLevel;
            break;
            //指针模式
        case 1006:
            //由跟随模式转换成指向模式
            if (self.mapView.mapView.userTrackingMode == MAUserTrackingModeFollowWithHeading)
            {
                
                [sender setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
                //追踪用户的location更新
                self.mapView.mapView.userTrackingMode = MAUserTrackingModeFollow;
                //开始通过GPS获取当前面朝的方向
                [[MapGPSLocation shareMapGPSLocation] mapGpsHeadingStart];
                
            }
            //由指向模式转换成跟随模式
            else
            {
                [sender setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
                // 追踪用户的location与heading更新
                self.mapView.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
                //清除annImgView的角度偏移
                self.annImgView.transform = CGAffineTransformIdentity;
                //停止通过GPS获取当前面朝的方向
                [[MapGPSLocation shareMapGPSLocation] mapGpsHeadingStop];
            }
            self.currentTrackigMode = self.mapView.mapView.userTrackingMode;
            
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
        
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        DLog(@"%f",location.altitude);
        
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
            [self.mapView.mapView addOverlay: commonPolyline];
        }
        else
            ann.distanceStr = @"出发点";
        
        
        [self.distanceAnnArray addObject:ann];
        
        // 添加大头针的方法
        [self.mapView.mapView addAnnotation:ann];
    }
}


#pragma mark -------地图的代理事件-------
//定位成功后执行的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation == YES)
    {
        //            CGFloat distance = 0;
        //            if (self.movementInfo.coorRecord.latitude && self.movementInfo.coorRecord.longitude)
        //            {
        //                //1.将两个经纬度点转成投影点
        //                MAMapPoint point1 = MAMapPointForCoordinate(userLocation.location.coordinate);
        //                MAMapPoint point2 = MAMapPointForCoordinate(self.movementInfo.coorRecord);
        //                //2.计算距离
        //                distance = MAMetersBetweenMapPoints(point1,point2);
        //           //     DLog(@"distance%f",distance);
        //            }
        //
        //            self.movementInfo.coorRecord = userLocation.coordinate;
        //            self.movementInfo.totleDistance += distance;
        //      //  DLog(@"+++%f",self.movementInfo.totleDistance);
        //            self.moveInfoView.distanceLabel.text = [NSString stringWithFormat:@"%0.2f",self.movementInfo.totleDistance];
    }
}


//添加大头针
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        
        self.annImgView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        
        [view addSubview:self.annImgView];
        
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        //pre.image = [UIImage imageNamed:@"touming"];
        //pre.image = self.annImgView.image;
        
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        pre.showsHeadingIndicator = YES;
        [self.mapView.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = YES;
    }
}

//定义大头针
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
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
        
        return polylineView;
    }
    return nil;
}


#pragma mark -----GPS定位类代理方法------
-(void)GPSLocationSucceed:(MovementInfo *)movementInfo
{
    self.mapView.moveInfoView.distanceLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.totleDistance/1000.0];
    self.mapView.moveInfoView.speedLabel.text = [NSString stringWithFormat:@"%0.1f",movementInfo.currentSpeed];
    
    self.sportInfoView.distanceLB.text = self.mapView.moveInfoView.distanceLabel.text;
    self.sportInfoView.currentSpeedLB.text = self.mapView.moveInfoView.speedLabel.text;
}


-(void)GPSUpdateHeading:(CLHeading *)heading
{
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*heading.magneticHeading/180.0);
    //DLog(@"234");
    self.annImgView.transform = CGAffineTransformIdentity;
    self.annImgView.transform = transform;
    
    //    NSLog(@"%@",self.pre)
}


#pragma mark ----动画效果-----
//提示信息从屏幕上逐渐消失的动画
-(void)AnimationOfDisappearing:(NSString *)str
{
    self.mapView.promptLabel.alpha = 1;
    self.mapView.promptLabel.text = str;
    [self.mapView addSubview:self.mapView.promptLabel];
    //开始动画,动画效果为label逐渐消失
    [UIView beginAnimations:@"prompt" context:NULL];
    //设置动画间隔
    [UIView setAnimationDuration:0.2];
    //提交动画
    [UIView commitAnimations];
    //用2秒内完成animation内的操作,透明度设为0
    [UIView animateWithDuration:2 animations:^{
        self.mapView.promptLabel.alpha= 0;
    } completion:^(BOOL finished) {
        [self.mapView.promptLabel removeFromSuperview];
    }];
}

#pragma mark ---运动计时器----
//运动计时开始
-(void)beginTiming
{
    if (self.moveTimer)
    {
        [self endTiming];
    }
    self.timeCount = 0;
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
   
}
//结束计时
-(void)endTiming
{
    [self.moveTimer invalidate];
    self.moveTimer = nil;
}
//计时
-(void)timerAction:(NSTimer *)timer
{
    self.mapView.moveInfoView.timeLabel.text = [NSString stringWithFormat:@"%0d:%02d:%02d",(self.timeCount/3600)%24,(self.timeCount/60)%60,self.timeCount%60];
    
    self.sportInfoView.timeLB.text = self.mapView.moveInfoView.timeLabel.text;
    
    self.timeCount++;
    
}


#pragma mark ---懒加载方法----
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
    // Dispose of any resources that can be recreated.
}



@end
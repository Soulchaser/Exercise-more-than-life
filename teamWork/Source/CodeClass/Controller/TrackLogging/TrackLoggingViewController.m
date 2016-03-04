//
//  TrackLoggingViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "TrackLoggingViewController.h"

#define kFloatButtonWidth ([UIScreen mainScreen].bounds.size.width/10.0)
@interface TrackLoggingViewController ()<UIScrollViewDelegate,MapGPSLocationDelegate,MAMapViewDelegate,AMapLocationManagerDelegate>

@property(strong,nonatomic)MapView *mapView;
//地图的缩放级别，范围是[3-19]
@property(assign,nonatomic)CGFloat zoomLevel;
//是否开启高度测量
@property(assign,nonatomic)BOOL altitudeFlag;
//是否开启测量距离
@property(assign,nonatomic)BOOL distanceFlag;
//用来存放测距模式下的ann
@property(strong,nonatomic)NSMutableArray *distanceAnnArray;
//用来存放起点和终点
@property(strong,nonatomic)NSMutableArray *startAndEndAnnArray;
//用来存放测距状态在两点之间覆盖物（连线）
@property(strong,nonatomic)NSMutableArray *distancePolylineArray;
//用来存放整个运动过程中的运动信息model
@property(strong,nonatomic)NSMutableArray *roadmapArray;
//用来存放运动时的路径画线
@property(strong,nonatomic)NSMutableArray *roadmapPolylineArray;
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
//数据库管理工具
@property(strong,nonatomic)XLCodeDataTools *cordDataTools;
//高德地图定位对象
@property(strong,nonatomic)AMapLocationManager *locationManager;
@end

@implementation TrackLoggingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟你走" image:[UIImage imageNamed:@"daohang"] selectedImage:[UIImage imageNamed:@"daohang_selected"]];
        //导航栏左按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ride_selected"] style:UIBarButtonItemStyleDone target:self action:@selector(sportModelChangAction:)];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
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
        
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1]];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
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
    //设定定位的最小更新距离。默认为kCLDistanceFilterNone，会提示任何移动
    self.mapView.mapView.distanceFilter = 10;
    //指南针是否显示，no为不显示
    //self.mapView.showsCompass= NO;
    //设置指南针位置
    self.mapView.mapView.compassOrigin= CGPointMake(kFloatButtonWidth*0.5,kScreenHeight*0.15);
    //追踪用户的location
    self.mapView.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.currentTrackigMode = MAUserTrackingModeFollow;
    //是否关闭后台持续定位的能力
    self.mapView.mapView.pausesLocationUpdatesAutomatically = YES;
    
    self.mapView.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配
    
    self.annImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
    
    [[MapGPSLocation shareMapGPSLocation] mapGpsHeadingStart];
    
    self.timeCount = 0;
    // Do any additional setup after loading the view.
}

-(void)drawView
{
    //地图视图
    self.mapView = [[MapView alloc]initWithFrame:CGRectMake(kScreenWidth, 0,  kScreenWidth, kScreenHeight)];
    
    
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
    //拖拽提示视图
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuodong"]];
    tipView.frame =  CGRectMake(kScreenWidth-20, kScreenHeight/3, 20, 64);
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.alpha = 0.9;
    [self.sportInfoView addSubview:tipView];
    
    //第二页
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 50, kScreenHeight*0.7)];
    blueView.backgroundColor = [UIColor whiteColor];
    blueView.alpha = 0;
    //[self.scrollView addSubview:redView];
    [self.scrollView addSubview:blueView];
    [self.view addSubview:self.scrollView];
    
    
    self.startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.7, kScreenWidth/2, kScreenHeight*0.1)];
    [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor colorWithRed:10 /255.0 green:83 /255.0 blue:149 /255.0 alpha:1];
    [self.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.continueButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight*0.7, kScreenWidth/2, kScreenHeight*0.1)];
    [self.continueButton setTitle:@"继续" forState:UIControlStateNormal];

    self.continueButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:1];
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
    
    [self.mapView.mapBookButton addTarget:self action:@selector(mapBookAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.mapView.leftView addGestureRecognizer:pan];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].delegate.window addSubview:self.mapView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView removeFromSuperview];
}
#pragma mark -------运动开始和结束按钮事件-------
//开始
-(void)startButtonAction:(UIButton *)sender
{
    [self initWhenMoveStart];
    [self moveStart];
}
//继续
-(void)continueButtonAction:(UIButton *)sender
{
    [self moveStart];
    [self.mapView.mapView removeAnnotation:self.startAndEndAnnArray.lastObject];
    
}
//结束
-(void)stopButtonAction:(UIButton *)sender
{
    //关闭后台持续定位的能力
    self.mapView.mapView.pausesLocationUpdatesAutomatically = YES;
    
    MovementInfo *movementInfo = (MovementInfo *)self.roadmapArray.lastObject;
    
    PointWithDistanceAnn *ann = [[PointWithDistanceAnn alloc]init];
    ann.distanceStr = @"终点";
    ann.coordinate = movementInfo.coorRecord;
    [self.startAndEndAnnArray addObject:ann];
    
    // 添加大头针的方法
    [self.mapView.mapView addAnnotation:ann];
    
    [self.locationManager stopUpdatingLocation];
    [self endTiming];
    [self.stopButton removeFromSuperview];
    
    if (((MovementInfo *)self.roadmapArray.lastObject).totleDistance < 20)
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于本次运动过短，将不会被记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defulAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
        [alertCon addAction:defulAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
    else
    {
        //数据入库
        //组装model
        CordDataInfo *cordDataInfo = [[CordDataInfo alloc]initWithMovementInfoArray:self.roadmapArray sportType:self.sportModel];
        //查询数据库中是否已存在该次的运动的数据，存在的话就更新，不存在则重新写
       NSArray *arr = [self.cordDataTools getDataFromLibraryWithstartDate:((MovementInfo *)self.roadmapArray.firstObject).timeDate];
        if (arr.count == 0)
        {
            //存入数据库
            [self.cordDataTools insertData:cordDataInfo];
        }
        else
        {
            //更新数据
            [self.cordDataTools updata:cordDataInfo];
        }
            
        
    }

}

#pragma mark ------运动开始时的初始化-------
-(void)initWhenMoveStart
{
    //路程记录数组
    [self.roadmapArray removeAllObjects];
    //移除地图上的线路路线
    [self.mapView.mapView removeOverlays:self.roadmapPolylineArray];
    //清空路线数组
    [self.roadmapPolylineArray removeAllObjects];
    //移除地图上的起点和终点的ann
    [self.mapView.mapView removeAnnotations:self.startAndEndAnnArray];
    //清除起点和终点ann的数组
    [self.startAndEndAnnArray removeAllObjects];
    //清空计时
    self.timeCount = 0;
    //清除所有显示数据的label
    self.sportInfoView.currentSpeedLB.text = [NSString stringWithFormat:@"0.00"];
    self.sportInfoView.distanceLB.text = @"0.00";
    self.sportInfoView.timeLB.text = @"0:00:00";
    self.sportInfoView.averageSpeedLB.text = @"0.00";
}

-(void)moveStart
{
    //设置距离筛选器
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //不关闭后台持续定位的能力
    self.mapView.mapView.pausesLocationUpdatesAutomatically = NO;
    
    [self.locationManager startUpdatingLocation];
    [self beginTiming];
    [self.view addSubview:self.stopButton];
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

-(void)mapBookAction
{
    
    TrackwayTableViewController *TwtVC = [[TrackwayTableViewController alloc]init];
    UINavigationController *TwtNC =[[UINavigationController alloc]initWithRootViewController:TwtVC];
    //[self.navigationController pushViewController:TwtVC animated:YES];
    [self presentViewController:TwtNC animated:YES completion:nil];
    [self.mapView removeFromSuperview];
}


#pragma mark -------屏幕点击事件--------

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.distanceFlag == YES)
    {
        // 创建一个大头针对象
        PointWithDistanceAnn * ann = [[PointWithDistanceAnn alloc]init];
        
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


#pragma mark -------高德定位代理方法-------
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{

//    DLog(@"%f,%f",location.coordinate.longitude,location.coordinate.latitude);
    
    MovementInfo *movementInfo = [[MovementInfo alloc]init];
    if (self.roadmapArray.count != 0)
    {
        movementInfo = ((MovementInfo *)self.roadmapArray.lastObject).mutableCopy;
    }
    /*当定位成功后，如果horizontalAccuracy大于0，说明定位有效
     horizontalAccuracy，该位置的纬度和经度确定的圆的中心，并且这个值表示圆的半径。负值表示该位置的纬度和经度是无效的。
     */
    if (location.horizontalAccuracy > 0)
    {
        CGFloat distance = 0;
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
        //将第一次定位单独处理，因为计算距离要与上一个点进行操作，第一次定位没有上一个点
        if (movementInfo.coorRecord.latitude && movementInfo.coorRecord.longitude)
        {
            //DLog(@"=======================%f",location.speed);
            if (location.speed == -1||location.speed == 0)
            {
                movementInfo.currentSpeed = 0.0;
            }
            else if(location.speed != 0)
            {
                CLLocation *locat1 = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
                CLLocation *locat2 = [[CLLocation alloc]initWithLatitude:movementInfo.coorRecord.latitude longitude:movementInfo.coorRecord.longitude];
                
                NSTimeInterval timeINterval = [nowDate timeIntervalSinceDate:movementInfo.timeDate];
                
                //2.计算距离
                distance = [locat1 distanceFromLocation:locat2];
                movementInfo.currentSpeed = (distance/timeINterval)*3.6;
                //去除因定位误差所产生的过大的错误速度
                if (movementInfo.currentSpeed > 60)
                {
                    movementInfo.currentSpeed = 0.0;
                }
            }
            //movementInfo.startDate = movementInfo.lastDate;
            movementInfo.timeDate = nowDate;
            movementInfo.totleDistance += distance;
        }
        //第一次定位,初始化一次参数
        else
        {
            movementInfo.timeDate = nowDate;
            movementInfo.currentSpeed = 0.0;
            movementInfo.totleDistance = 0;
        }
        
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    movementInfo.coorRecord = coordinate;
    [self GDLocationSucceed:movementInfo];

   // NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

-(void)GDLocationSucceed:(MovementInfo *)movementInfo
{
   
        //判断是不是出发点,如果不是则计算与上一个点的距离，是的话就显示出发点
        if (self.roadmapArray.count != 0)
        {
            if (movementInfo.currentSpeed != 0)
            {
                //构造折线数据对象
                CLLocationCoordinate2D commonPolylineCoords[2];
                
                commonPolylineCoords[0].latitude = ((MovementInfo *)(self.roadmapArray.lastObject)).coorRecord.latitude;
                commonPolylineCoords[0].longitude = ((MovementInfo *)(self.roadmapArray.lastObject)).coorRecord.longitude;
                
                commonPolylineCoords[1].latitude = movementInfo.coorRecord.latitude;
                commonPolylineCoords[1].longitude = movementInfo.coorRecord.longitude;
                //构造折线对象
                MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
                //存入数组中
                [self.roadmapPolylineArray addObject:commonPolyline];
                //在地图上添加折线对象
                [self.mapView.mapView addOverlay: commonPolyline];
                
            }
     
        }
        else
        {
            PointWithDistanceAnn *ann = [[PointWithDistanceAnn alloc]init];
            ann.distanceStr = @"出发点";
            ann.coordinate = movementInfo.coorRecord;
            [self.startAndEndAnnArray addObject:ann];
            
            // 添加大头针的方法
            [self.mapView.mapView addAnnotation:ann];
            //[self.roadmapArray addObject:movementInfo];
        }
    [self.roadmapArray addObject:movementInfo];
   // DLog(@"%lu",(unsigned long)self.roadmapArray.count);
    self.mapView.moveInfoView.distanceLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.totleDistance/1000.0];
    self.mapView.moveInfoView.speedLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.currentSpeed];
    
    
    
    self.sportInfoView.distanceLB.text = self.mapView.moveInfoView.distanceLabel.text;
    self.sportInfoView.currentSpeedLB.text = self.mapView.moveInfoView.speedLabel.text;
    self.sportInfoView.averageSpeedLB.text = [NSString stringWithFormat:@"%0.2f",(movementInfo.totleDistance/self.timeCount)*3.6];
    
    
}

#pragma mark -------地图的代理事件-------
//定位成功后执行的方法

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    if(updatingLocation == YES)
    {
    }
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"fail");
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
    
   // self.GPSMovementInfo = movementInfo;
    self.mapView.moveInfoView.distanceLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.totleDistance/1000.0];
    self.mapView.moveInfoView.speedLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.currentSpeed];
    
    self.sportInfoView.distanceLB.text = self.mapView.moveInfoView.distanceLabel.text;
    self.sportInfoView.currentSpeedLB.text = self.mapView.moveInfoView.speedLabel.text;
    self.sportInfoView.averageSpeedLB.text =  [NSString stringWithFormat:@"%0.2f",(movementInfo.totleDistance/self.timeCount)*3.6];
    
}


-(void)GPSUpdateHeading:(CLHeading *)heading
{
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*heading.magneticHeading/180.0);
    self.annImgView.transform = CGAffineTransformIdentity;
    self.annImgView.transform = transform;
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
    self.mapView.moveInfoView.timeLabel.text = [NSString stringWithFormat:@"%0ld:%02ld:%02ld",(long)(self.timeCount/3600)%24,(long)(self.timeCount/60)%60,(long)self.timeCount%60];
    
    self.sportInfoView.timeLB.text = self.mapView.moveInfoView.timeLabel.text;
    
    self.timeCount++;
    
}


#pragma mark ---懒加载方法----
//懒加载，初始化使用
-(XLCodeDataTools *)cordDataTools
{
    if (_cordDataTools == nil)
    {
        _cordDataTools = [[XLCodeDataTools alloc]init];
    }
    return _cordDataTools;
}
-(NSMutableArray *)roadmapArray
{
    if (_roadmapArray == nil)
    {
        _roadmapArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _roadmapArray;
}

-(NSMutableArray *)roadmapPolylineArray
{
    if (_roadmapPolylineArray == nil)
    {
        _roadmapPolylineArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _roadmapPolylineArray;
}

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

-(NSMutableArray *)startAndEndAnnArray
{
    if (_startAndEndAnnArray == nil)
    {
        _startAndEndAnnArray = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _startAndEndAnnArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

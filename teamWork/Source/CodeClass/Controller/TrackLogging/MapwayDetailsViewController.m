//
//  MapwayDetailsViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/2/24.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapwayDetailsViewController.h"

@interface MapwayDetailsViewController ()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NYSegmentedControl * segmentedControl;
@property(strong,nonatomic)MAMapView *mapView;
//定位大头针图片
@property(strong,nonatomic)UIImageView *annImgView;

@property(strong,nonatomic)UITableView *tableView;
@end

static NSString *const cellID = @"cellID";

@implementation MapwayDetailsViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.cordData = [[CordDataInfo alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"轨迹", @"数据"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.segmentedControl.drawsGradientBackground = YES;
    self.segmentedControl.segmentIndicatorInset = 2.0f;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl sizeToFit];
    self.navigationItem.titleView = self.segmentedControl;
    
    [self mapViewSet];
    [self tableVIewSet];
    [self.view addSubview:self.mapView];
    
}

#pragma mark -------地图View---------
-(void)mapViewSet
{
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.frame];
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.delegate = self;

    
    
    PointWithDistanceAnn *ann = [[PointWithDistanceAnn alloc]init];
    ann.distanceStr = @"起点";
    ann.coordinate = ((MovementInfo *)self.cordData.infoArray.firstObject).coorRecord;
    //[self.startAndEndAnnArray addObject:ann];
    PointWithDistanceAnn *ann2 = [[PointWithDistanceAnn alloc]init];
    ann2.distanceStr = @"终点";
    ann2.coordinate = ((MovementInfo *)self.cordData.infoArray.lastObject).coorRecord;
    // 添加大头针的方法
    [self.mapView addAnnotation:ann];
    [self.mapView addAnnotation:ann2];
    
    if (self.cordData.infoArray.count != 0)
    {
        MovementInfo *lastInfo = [[MovementInfo alloc]init];
        lastInfo = self.cordData.infoArray.firstObject;
        
        for (MovementInfo *movementInfo in self.cordData.infoArray)
        {
            
            //if (movementInfo.currentSpeed != 0)
            //{
                //构造折线数据对象
                CLLocationCoordinate2D commonPolylineCoords[2];
                
                commonPolylineCoords[0].latitude = lastInfo.coorRecord.latitude;
                commonPolylineCoords[0].longitude = lastInfo.coorRecord.longitude;
                
                commonPolylineCoords[1].latitude = movementInfo.coorRecord.latitude;
                commonPolylineCoords[1].longitude = movementInfo.coorRecord.longitude;
                //构造折线对象
                MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];

                //在地图上添加折线对象
                [self.mapView addOverlay: commonPolyline];
            lastInfo = movementInfo;
           // }
            
        }

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

#pragma mark ------数据View-------
-(void)tableVIewSet
{
    if ([self performSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-46) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section)
    {
        case 0:
            number = 1;
            break;
        case 1:
            number = 1;
            break;
        case 2:
            number = 3;
            break;
        case 3:
            number = 4;
            break;
        default:
            break;
    }
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    

    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"运动类型";
            switch (self.cordData.sportType)
            {
                case walkModel:
                    cell.detailTextLabel.text = @"步行";
                    break;
                case runModel:
                    cell.detailTextLabel.text = @"跑步";
                    break;
                case rideModel:
                    cell.detailTextLabel.text = @"骑行";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"运动里程";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm",self.cordData.totleDistance/1000.0];
            break;
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"运动匀速";
                    if (self.cordData.movementTime != 0)
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm/h",(self.cordData.totleDistance/self.cordData.movementTime)*3.6];
                        break;
                    }
                    else
                        cell.detailTextLabel.text = @"0.00km/h";
                    break;
                case 1:
                    cell.textLabel.text = @"全程匀速";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm/h",(self.cordData.totleDistance/self.cordData.totleTime)*3.6];
                    break;
                case 2:
                    cell.textLabel.text = @"最快速度";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm/h",self.cordData.maxSpeed];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"运动时间";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d",(int)(self.cordData.movementTime/60/60),(int)(self.cordData.movementTime/60),(int)self.cordData.movementTime%60];
                    break;
                case 1:
                    cell.textLabel.text = @"全程时间";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d",(int)(self.cordData.totleTime/60/60),(int)(self.cordData.totleTime/60),(int)self.cordData.totleTime%60];
                    break;
                case 2:
                    cell.textLabel.text = @"开始时间";
                    cell.detailTextLabel.text = [self stringFromDate:((MovementInfo *)self.cordData.infoArray.firstObject).timeDate];
                    break;
                case 3:
                    cell.textLabel.text = @"结束时间";
                    cell.detailTextLabel.text = [self stringFromDate:((MovementInfo *)self.cordData.infoArray.lastObject).timeDate];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    return cell;
}

//转化Date格式
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    //转化过程中，会把当前时间当成0时区的时间来操作，所以先转成0时区的时间
    NSDate *localeDate = [date  dateByAddingTimeInterval: -interval];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:localeDate];
    
    return destDateString;
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,50)];
//    header.backgroundColor = [UIColor grayColor];
//    return header;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = @"";
    switch (section) {
        case 0:
            str = @"类型";
            break;
        case 1:
            str = @"里程";
            break;
        case 2:
            str = @"速度";
            break;
        case 3:
            str = @"时间";
            break;
        default:
            break;
    }
    return str;
}

-(void)segmentSelected
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        [self.tableView removeFromSuperview];
    }else
    {
        
        [self.view addSubview:self.tableView];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

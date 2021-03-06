//
//  MapGPSLocation.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapGPSLocation.h"

@interface MapGPSLocation ()

@property(strong,nonatomic)CLLocationManager *manager;

@property(strong,nonatomic)CLGeocoder *geo;

@end

@implementation MapGPSLocation

+(instancetype)shareMapGPSLocation
{
    static MapGPSLocation *mm = nil;
    if (mm == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mm = [[MapGPSLocation alloc]init];
        });
    }
    return mm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //判断当前设备是否支持定位
        if ([CLLocationManager locationServicesEnabled] == YES)
        {
            DLog(@"支持");
        }
        else
        {
            DLog(@"不支持");
        }
       
        
        //实例化定位管理对象
        self.manager = [[CLLocationManager alloc]init];
        self.manager.delegate = self;
        
        //设置滤波器不工作
        self.manager.headingFilter = kCLHeadingFilterNone;
        

        self.geo = [[CLGeocoder alloc]init];
        
        if ([CLLocationManager authorizationStatus] !=  kCLAuthorizationStatusAuthorizedWhenInUse) {
            // 开始申请
            [self.manager requestWhenInUseAuthorization];
        }

        
        //初始化多播代理
        self.multiDelegate = (id<MapGPSLocationDelegate>)[[GCDMulticastDelegate alloc]init];
        
    }
    return self;
}
//初始化manager
-(void)setMapGPSLocationWithdistanceFilter:(CLLocationDistance)distanceFilter desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    //开始为定位做准备
    //多少米定位一次
    self.manager.distanceFilter = distanceFilter;
    //定位精度
    self.manager.desiredAccuracy = desiredAccuracy;
}

-(void)mapGPSLocationStart
{
    //开始定位
    [self.manager startUpdatingLocation];
}


-(void)mapGPSLocationStop
{
    //关闭定位
    [self.manager stopUpdatingLocation];
}

-(void)mapGpsHeadingStart
{
    //开始更新方向
    [self.manager startUpdatingHeading];

}

-(void)mapGpsHeadingStop
{
    //关闭更新方向
    [self.manager stopUpdatingHeading];
}

//定位成功后的代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
//    DLog(@"%f,%f",location.coordinate.longitude,location.coordinate.latitude);
//    /*当定位成功后，如果horizontalAccuracy大于0，说明定位有效
//     horizontalAccuracy，该位置的纬度和经度确定的圆的中心，并且这个值表示圆的半径。负值表示该位置的纬度和经度是无效的。
//     */
//    if (location.horizontalAccuracy > 0)
//    {
//        CGFloat distance = 0;
//        if (self.movementInfo.coorRecord.latitude && self.movementInfo.coorRecord.longitude)
//        {
//            
//            NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
//            
//            if (location.speed == -1)
//            {
//                self.movementInfo.currentSpeed = 0.0;
//            }
//            else if(location.speed != 0)
//            {
//                CLLocation *locat1 = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//                CLLocation *locat2 = [[CLLocation alloc]initWithLatitude:self.movementInfo.coorRecord.latitude longitude:self.movementInfo.coorRecord.longitude];
//                
//                NSTimeInterval timeINterval = [nowDate timeIntervalSinceDate:self.movementInfo.lastDate];
//                self.movementInfo.currentSpeed = (distance/timeINterval)*3.6;
//                //self.movementInfo.currentSpeed = location.speed*(self.manager.distanceFilter);
//                //if (self.movementInfo.currentSpeed != 0)
//                //{
//                    //2.计算距离
//                    distance = [locat1 distanceFromLocation:locat2];
//                    self.movementInfo.runDuration += timeINterval;
//               // }
//                
//            }
//            self.movementInfo.startDate = self.movementInfo.lastDate;
//            self.movementInfo.lastDate = nowDate;
//            self.movementInfo.totleDistance += distance;
//        }
//        
//    }
//    
//    self.movementInfo.coorRecord = location.coordinate;
//    
//    
//    [self.multiDelegate GPSLocationSucceed:self.movementInfo];
    [self getCityNameWithCoor:location.coordinate];
    //关闭定位
    //[self.manager stopUpdatingLocation];
}

//定位失败后的代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"定位失败");
}


//获取当前朝向
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{

    [self.multiDelegate GPSUpdateHeading:newHeading];

   // [self.delegate GPSUpdateHeading : transform];
}


//编码，根据城市名称返回坐标
-(void)getCoorWithCityName:(NSString *)cityName
{
    [self.geo geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error)
        {
            DLog(@"编码失败:%@",error);
        }
        
        else
        {
            //返回最后一个编码信息
            CLPlacemark *placeMark = placemarks.lastObject;
            DLog(@"%@ 城市的经度是:%f 纬度是:%f",
                  cityName,placeMark.location.coordinate.longitude,placeMark.location.coordinate.latitude);
        }
        
        
        
    }];
    
}

//反编码，根据坐标返回城市名
-(void)getCityNameWithCoor:(CLLocationCoordinate2D )coor
{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
    
    [self.geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error)
        {
            DLog(@"失败:%@",error);
        }
        else
        {
            CLPlacemark *placeMark = placemarks.lastObject;
            
            [placeMark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
               // DLog(@"%@:%@",key,obj);
                
                if ([key isEqualToString:@"City"])
                {
                    //将汉字转换成拼音
                    
                    NSString *hanziText = obj;
                    NSString *finalStr = [[NSString alloc]init];
 
                    PinyinChange *pinyinChange = [[PinyinChange alloc]init];
                    finalStr = [pinyinChange ChineseChangeToSpelling:hanziText];
                    //将获取的城市名返还给代理
                    [self.multiDelegate GPSGetCityName:finalStr];
                   // [self.delegate GPSGetCityName:finalStr];
                }

            }];
        }
        
    }];
}

//添加多代理
-(void)addDelegateMapGPSLocation:(id<MapGPSLocationDelegate>)delegate delegateQueue:(dispatch_queue_t)queue
{
    [self.multiDelegate addDelegate:delegate delegateQueue:queue];
}

-(MovementInfo *)movementInfo
{
    if (_movementInfo == nil)
    {
        _movementInfo = [[MovementInfo alloc]init];
        _movementInfo.timeDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
        //_movementInfo.lastDate = _movementInfo.startDate;
    }
    return _movementInfo;
}




@end

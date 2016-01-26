//
//  MapViewController.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapGPSLocation.h"
@class MAMapView;
@interface MapViewController : UIViewController<MapGPSLocationDelegate>

@property(assign,nonatomic)CGFloat totleDistance;
//地图视图
@property(strong,nonatomic)MAMapView *mapView;
@end

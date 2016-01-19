//
//  PointWithDistanceAnnView.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/19.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class DistanceCalloutView;
@interface PointWithDistanceAnnView : MAPinAnnotationView
@property(assign,nonatomic)CGFloat pointDistance;
@property(readonly,nonatomic)DistanceCalloutView *calloutView;
@property(assign,nonatomic)CLLocationCoordinate2D coordinate;
@property(strong,nonatomic)NSString *distanceStr;
@end

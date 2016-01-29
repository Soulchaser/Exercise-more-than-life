//
//  MovementInfo.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/21.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAAnnotation;
@interface MovementInfo : NSObject
//记录总的路程
@property(assign,nonatomic)CGFloat totleDistance;
//记录上一个点的定位状态
@property(assign,nonatomic)CLLocationCoordinate2D coorRecord;
//当前速度
@property(assign,nonatomic)CGFloat currentSpeed;
//上一段路程的开始时间
@property(strong,nonatomic)NSDate *startDate;
//上一段路程的结束时间
@property(strong,nonatomic)NSDate *lastDate;
//运动时间
@property(assign,nonatomic)double runDuration;
@end

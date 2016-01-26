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
//运动开始时间
@property(strong,nonatomic)NSDate *startDate;
//到达上一个定位点的时间
@property(strong,nonatomic)NSDate *lastDate;

@end

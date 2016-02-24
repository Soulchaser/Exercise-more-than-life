//
//  CordDataInfo.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/30.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CordDataInfo : NSObject

@property (strong, nonatomic) NSDate *startDate;
@property (assign, nonatomic) NSInteger movementTime;
@property (assign, nonatomic) double totleTime;
@property (assign, nonatomic) CGFloat maxSpeed;
@property (assign, nonatomic) NSInteger sportType;
@property (assign, nonatomic) CGFloat totleDistance;
@property (strong, nonatomic) NSArray *infoArray;
//自定义的初始化方法
-(instancetype)initWithMovementInfoArray:(NSArray *)infoArray  sportType:(NSInteger)sportType;

@end

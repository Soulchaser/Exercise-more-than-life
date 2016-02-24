//
//  CordDataInfo.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/30.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "CordDataInfo.h"

@implementation CordDataInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_startDate];
}

-(instancetype)initWithMovementInfoArray:(NSArray *)infoArray  sportType:(NSInteger)sportType
{
    
    if (self = [super init])
    {
        //出发点
        MovementInfo *firstInfo = (MovementInfo *)infoArray.firstObject;
        //终点
        MovementInfo *lastInfo = (MovementInfo *)infoArray.lastObject;
        //上一个点
        MovementInfo *preInfo = [[MovementInfo alloc]init];
        preInfo = (MovementInfo *)infoArray.firstObject;
        
        //记录运动时间
        NSTimeInterval timeInterval = 0;
        
        
        self.startDate = firstInfo.timeDate;
        self.totleDistance = lastInfo.totleDistance;
        self.totleTime = [lastInfo.timeDate timeIntervalSinceDate:firstInfo.timeDate];
        self.infoArray = infoArray;
        self.maxSpeed = 0.0;
        self.sportType = sportType;
        for (MovementInfo *movementInfo in infoArray)
        {
            if (movementInfo.currentSpeed != 0 )
            {
                timeInterval += [movementInfo.timeDate timeIntervalSinceDate:preInfo.timeDate];
                //求最大速度
                self.maxSpeed = movementInfo.currentSpeed >self.maxSpeed?movementInfo.currentSpeed:self.maxSpeed;
                
            }
            preInfo = movementInfo;
        }
        self.movementTime = timeInterval;
    }
    return self;
}


@end

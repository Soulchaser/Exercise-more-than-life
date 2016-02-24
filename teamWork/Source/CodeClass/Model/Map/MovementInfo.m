//
//  MovementInfo.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/21.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MovementInfo.h"

@implementation MovementInfo

-(id)mutableCopy
{
    MovementInfo *movementInfo = [[MovementInfo alloc]init];

    movementInfo.totleDistance = _totleDistance;
    movementInfo.coorRecord = _coorRecord;
    movementInfo.currentSpeed = _currentSpeed;
    movementInfo.timeDate = _timeDate;
    movementInfo.height = _height;
    
    return movementInfo;
}

//复杂对象想要实现数据持久化(写入文件),必须遵循NSCoding协议,实现以下两个方法
//解码
//在这个方法中,我们需要完成属性的解码操作,根据编码时的key值一一对应获取相应的值
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _timeDate = [aDecoder decodeObjectForKey:@"timeDate"];

        _currentSpeed = [aDecoder decodeFloatForKey:@"currentSpeed"];
        _coorRecord.latitude = [aDecoder decodeDoubleForKey:@"coorRecord.latitude"];
        _coorRecord.longitude = [aDecoder decodeDoubleForKey:@"coorRecord.longitude"];
        //_coorRecord = [aDecoder decodeObjectForKey:@"coorRecord"];
        _totleDistance = [aDecoder decodeFloatForKey:@"totleDistance"];
        _height = [aDecoder decodeFloatForKey:@"height"];
    }
    
    return self;
}
//编码
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_timeDate forKey:@"timeDate"];
    [aCoder encodeFloat:_currentSpeed forKey:@"currentSpeed"];
    [aCoder encodeFloat:_totleDistance forKey:@"totleDistance"];
    [aCoder encodeFloat:_height forKey:@"height"];
    [aCoder encodeDouble:_coorRecord.longitude forKey:@"coorRecord.longitude"];
    [aCoder encodeDouble:_coorRecord.latitude forKey:@"coorRecord.latitude"];
    
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%f,%f,%f,%f",_timeDate,_currentSpeed,_totleDistance,_coorRecord.longitude,_coorRecord.latitude];
}

@end

//
//  YDWeatherModel.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "YDWeatherModel.h"

#pragma mark ------------基本信息------------
@implementation YDWeatherModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_qlty];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的键key--%@",key);
}

-(NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end

@implementation YDmodelForecast

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@",_date];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的key%@",key);
}

@end




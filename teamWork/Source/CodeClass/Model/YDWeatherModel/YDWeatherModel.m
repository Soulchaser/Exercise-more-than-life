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
    return [NSString stringWithFormat:@"%@",_city];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的键key--%@",key);
}
@end

#pragma mark ------------实况代码------------
@implementation nowModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_txt];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的键key--%@",key);
}

@end



#pragma mark ------------空气质量------------

@implementation AqiModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_qlty];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的键key--%@",key);
}

@end

#pragma mark ------------天气预报------------

@implementation ForecastModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_date];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不能识别的键key--%@",key);
}

@end



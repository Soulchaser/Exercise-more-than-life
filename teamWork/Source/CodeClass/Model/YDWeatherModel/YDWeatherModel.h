//
//  YDWeatherModel.h
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark ------------基本信息------------
@interface YDWeatherModel : NSObject

// !!!:日期可以通过获取本机的时间然后加24

@property(strong,nonatomic) NSString * city;//basic-基本信息-城市名

@end
#pragma mark ------------实况代码------------
@interface nowModel : NSObject

@property(strong,nonatomic) NSString * code;//now-实况天气-天气代码

@property(strong,nonatomic) NSString * txt;//now-实况天气-天气状况描述

@end

#pragma mark ------------空气质量------------

@interface AqiModel : NSObject

@property(strong,nonatomic) NSString * aqi;//aqi空气质量-city-aqi空气质量指数

@property(strong,nonatomic) NSString * qlty;//空气质量级别

@end

#pragma mark ------------天气预报------------

@interface ForecastModel : NSObject

@property(strong,nonatomic) NSString * cond;//天气状况

@property(strong,nonatomic) NSString * date;//预报日期

@end





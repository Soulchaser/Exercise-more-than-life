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

@property(strong,nonatomic) NSString * city;//basic-基本信息-城市名

//now
@property(strong,nonatomic) NSString * code;//now-实况天气-天气代码

@property(strong,nonatomic) NSString * txt;//now-实况天气-天气状况描述

//aqi
@property(strong,nonatomic) NSString * aqi;//aqi空气质量-city-aqi空气质量指数

@property(strong,nonatomic) NSString * qlty;//空气质量级别

@property(strong,nonatomic) NSString * tmp;//温度

//forecast
@property(strong,nonatomic) NSMutableArray * array;

@end

@interface YDmodelForecast : NSObject

@property(strong,nonatomic) NSString * code_d;//天气状况

@property(strong,nonatomic) NSString * date;//预报日期

@end





//
//  YDGetDataTools.h
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//
/*

 */
#import <Foundation/Foundation.h>

@interface YDGetDataTools : NSObject

//单例方法
+(instancetype)sharedGetData;

//保存添加的城市的数组
@property(strong,nonatomic) NSMutableArray * BasicArray;

@property(strong,nonatomic) NSMutableArray * TempArray;

@property(strong,nonatomic) NSMutableArray * AqiArray;

@property(strong,nonatomic) NSMutableArray * daily_forecastArray;

// !!!:添加数组过滤方法
// 传入参数-字符串(拼音&城市名称)
// 如果是拼音暂时不做判断
// 如果是城市名称(汉字)进行遍历查询,以保证查询的精确度
#warning 暂时只支持城市拼音全拼如:jinan,beijing-&&&&-城市名称全称如:济南,上海,北京,

//封装请求天气数据的方法
// 传入参数:字符串
// 返回参数:数组
-(NSMutableArray*)requestDataWithCityName:(NSString*)cityName;

@end

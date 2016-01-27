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

// !!!:声明block
typedef void (^PassValueBlock)(NSMutableArray * array);

@interface YDGetDataTools : NSObject

//单例方法
+(instancetype)sharedGetData;

//保存添加的城市的数组
@property(strong,nonatomic) NSMutableArray * BasicArray;

@property(strong,nonatomic) NSMutableArray * TempArray;

@property(strong,nonatomic) NSMutableArray * AqiArray;

@property(strong,nonatomic) NSMutableArray * daily_forecastArray;

@end

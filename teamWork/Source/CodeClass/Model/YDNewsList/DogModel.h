//
//  DogModel.h
//  测试
//
//  Created by 袁东东 on 16/1/15.
//  Copyright © 2016年 袁东东. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "count":1,
	"description":"……",
	"fcount":0,
	"id":503,
	"img":"……",//【1】
	"keywords":"……",
	"message":"……",
	"rcount":0,
	"time":1435561395000,
	"title":"……",
	"topclass":0
 */

@interface DogModel : NSObject

@property(strong,nonatomic) NSString * count;//计数

@property(strong,nonatomic) NSString * Description;//(与系统冲突)描述

@property(strong,nonatomic) NSString * fcount;//未知属性

@property(strong,nonatomic) NSString * ID;    // "id"

@property(strong,nonatomic) NSString * img;   // 不完整的图片url

@property(strong,nonatomic) NSString * keywords;//关键字

@property(strong,nonatomic) NSString * rcount;  //未知属性

@property(strong,nonatomic) NSString * time;  //时间,格式不知道是什么东东

@property(strong,nonatomic) NSString * title; //标题

@property(strong,nonatomic) NSString * topclass;//未知属性

@end

//
//  DetailModel.h
//  测试
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 袁东东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property(strong,nonatomic) NSString * count;//未知属性

@property(strong,nonatomic) NSString * Description;//"description"与系统字段冲突

@property(strong,nonatomic) NSString * fcount;//未知属性

@property(strong,nonatomic) NSString * ID;//"id"

@property(strong,nonatomic) NSString * img;//需要拼接的图片URL

@property(strong,nonatomic) NSString * infoclass;//未知属性

@property(strong,nonatomic) NSString * keywords;//猜测关键字,不知道用在哪里

@property(strong,nonatomic) NSString * message;//信息

@property(strong,nonatomic) NSString * rcount;//未知属性

@property(strong,nonatomic) NSString * time;//不能使用的键值

@property(strong,nonatomic) NSString * title;//标题

@end
